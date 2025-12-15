# Maintenance/Upgrade Banner: Notification Banner for Maintenance and Upgrade - Task List & Implementation Steps

## Overview
This document lists all tasks required to implement the **Maintenance/Upgrade Banner** feature. Currently, this feature is **MISSING** - Not implemented. This feature should include: maintenance banner display, upgrade banner display, banner configuration from remote config, banner dismissal, and banner persistence.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `TDInvitationNotificationWidget` - example banner widget pattern
- ✅ `SnackbarService` - for temporary notifications (not persistent banners)
- ✅ Firebase Remote Config can be used (if configured)
- ✅ Banner widget pattern exists (can be reused)

### What's Missing/Broken:
- ⛔ No maintenance banner system
- ⛔ No upgrade banner system
- ⛔ No remote config integration for banners
- ⛔ No banner service to manage banner state
- ⛔ No banner controller for UI state
- ⛔ No banner persistence (dismissed state)
- ⛔ No banner priority handling
- ⛔ No banner scheduling

---

## Task List

### Task 1: Create Banner Service for Remote Config Integration

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Create service to retrieve banner configuration from Firebase Remote Config and manage banner state.

**Files to Create/Modify**:
- `lib/core/services/banner_service.dart` (new file)
- `pubspec.yaml` (add firebase_remote_config if not already included)

**Dependencies**:
- Firebase Remote Config

**Implementation Steps**:

1. **Add firebase_remote_config to pubspec.yaml** (if not already included):
   ```yaml
   dependencies:
     firebase_remote_config: ^5.0.0
   ```

2. **Create BannerService**:
   ```dart
   // lib/core/services/banner_service.dart
   import 'package:get/get.dart';
   import 'package:firebase_remote_config/firebase_remote_config.dart';
   import 'storage_service.dart';
   
   enum BannerType {
     maintenance,
     upgrade,
   }
   
   enum BannerPriority {
     low,
     medium,
     high,
     critical,
   }
   
   class BannerConfig {
     final BannerType type;
     final bool enabled;
     final String title;
     final String message;
     final BannerPriority priority;
     final DateTime? startTime;
     final DateTime? endTime;
     final String? actionText;
     final String? actionUrl;
     final bool dismissible;
     
     BannerConfig({
       required this.type,
       this.enabled = false,
       this.title = '',
       this.message = '',
       this.priority = BannerPriority.medium,
       this.startTime,
       this.endTime,
       this.actionText,
       this.actionUrl,
       this.dismissible = true,
     });
     
     factory BannerConfig.fromMap(Map<String, dynamic> map, BannerType type) {
       return BannerConfig(
         type: type,
         enabled: map['enabled'] as bool? ?? false,
         title: map['title']?.toString() ?? '',
         message: map['message']?.toString() ?? '',
         priority: BannerPriority.values.firstWhere(
           (e) => e.name == map['priority']?.toString(),
           orElse: () => BannerPriority.medium,
         ),
         startTime: map['startTime'] != null
             ? DateTime.parse(map['startTime'] as String)
             : null,
         endTime: map['endTime'] != null
             ? DateTime.parse(map['endTime'] as String)
             : null,
         actionText: map['actionText']?.toString(),
         actionUrl: map['actionUrl']?.toString(),
         dismissible: map['dismissible'] as bool? ?? true,
       );
     }
     
     bool get isActive {
       if (!enabled) return false;
       
       final now = DateTime.now();
       if (startTime != null && now.isBefore(startTime!)) {
         return false;
       }
       if (endTime != null && now.isAfter(endTime!)) {
         return false;
       }
       
       return true;
     }
   }
   
   class BannerService {
     factory BannerService() => _instance ??= BannerService._();
     BannerService._();
     static BannerService? _instance;
     
     final StorageService _storage = StorageService();
     RemoteConfig? _remoteConfig;
     
     static const String _maintenanceBannerKey = 'maintenance_banner';
     static const String _upgradeBannerKey = 'upgrade_banner';
     static const String _dismissedBannersKey = 'dismissed_banners';
     
     /// Initialize Remote Config
     Future<void> initialize() async {
       try {
         _remoteConfig = RemoteConfig.instance;
         
         await _remoteConfig!.setConfigSettings(RemoteConfigSettings(
           fetchTimeout: const Duration(seconds: 10),
           minimumFetchInterval: const Duration(minutes: 5),
         ));
         
         // Set defaults
         await _remoteConfig!.setDefaults({
           _maintenanceBannerKey: '{}',
           _upgradeBannerKey: '{}',
         });
         
         await _remoteConfig!.fetchAndActivate();
         
         Get.log('Banner service initialized');
       } catch (e) {
         Get.log('ERROR: Failed to initialize banner service: $e');
       }
     }
     
     /// Get maintenance banner config
     BannerConfig? getMaintenanceBanner() {
       try {
         final configJson = _remoteConfig?.getString(_maintenanceBannerKey) ?? '{}';
         final configMap = jsonDecode(configJson) as Map<String, dynamic>;
         
         if (configMap.isEmpty) return null;
         
         final config = BannerConfig.fromMap(configMap, BannerType.maintenance);
         if (!config.isActive) return null;
         
         // Check if dismissed
         if (_isBannerDismissed(BannerType.maintenance, config)) {
           return null;
         }
         
         return config;
       } catch (e) {
         Get.log('ERROR: Failed to get maintenance banner: $e');
         return null;
       }
     }
     
     /// Get upgrade banner config
     BannerConfig? getUpgradeBanner() {
       try {
         final configJson = _remoteConfig?.getString(_upgradeBannerKey) ?? '{}';
         final configMap = jsonDecode(configJson) as Map<String, dynamic>;
         
         if (configMap.isEmpty) return null;
         
         final config = BannerConfig.fromMap(configMap, BannerType.upgrade);
         if (!config.isActive) return null;
         
         // Check if dismissed
         if (_isBannerDismissed(BannerType.upgrade, config)) {
           return null;
         }
         
         return config;
       } catch (e) {
         Get.log('ERROR: Failed to get upgrade banner: $e');
         return null;
       }
     }
     
     /// Get active banner (highest priority)
     BannerConfig? getActiveBanner() {
       final maintenance = getMaintenanceBanner();
       final upgrade = getUpgradeBanner();
       
       if (maintenance == null && upgrade == null) return null;
       if (maintenance == null) return upgrade;
       if (upgrade == null) return maintenance;
       
       // Return highest priority
       if (maintenance.priority.index > upgrade.priority.index) {
         return maintenance;
       }
       return upgrade;
     }
     
     /// Dismiss banner
     Future<void> dismissBanner(BannerType type, BannerConfig config) async {
       try {
         final dismissed = _getDismissedBanners();
         final key = '${type.name}_${config.startTime?.millisecondsSinceEpoch ?? 0}';
         dismissed[key] = DateTime.now().millisecondsSinceEpoch;
         await _storage.setSetting(_dismissedBannersKey, dismissed);
       } catch (e) {
         Get.log('ERROR: Failed to dismiss banner: $e');
       }
     }
     
     /// Check if banner is dismissed
     bool _isBannerDismissed(BannerType type, BannerConfig config) {
       final dismissed = _getDismissedBanners();
       final key = '${type.name}_${config.startTime?.millisecondsSinceEpoch ?? 0}';
       return dismissed.containsKey(key);
     }
     
     /// Get dismissed banners
     Map<String, int> _getDismissedBanners() {
       try {
         final dismissed = _storage.getSetting<Map<String, dynamic>>(_dismissedBannersKey);
         if (dismissed != null) {
           return dismissed.map((k, v) => MapEntry(k.toString(), v as int));
         }
         return {};
       } catch (e) {
         return {};
       }
     }
     
     /// Refresh remote config
     Future<void> refresh() async {
       try {
         await _remoteConfig?.fetchAndActivate();
       } catch (e) {
         Get.log('ERROR: Failed to refresh banner config: $e');
       }
     }
   }
   ```

3. **Initialize BannerService in app.dart**:
   ```dart
   // In lib/app/app.dart
   import 'core/services/banner_service.dart';
   
   static Future<void> initialize() async {
     // ... existing initialization ...
     
     // Initialize Banner Service
     final bannerService = BannerService();
     await bannerService.initialize();
     Get.put(bannerService);
   }
   ```

**Expected Results**:
- ✅ BannerService exists
- ✅ Service can retrieve banner config from Remote Config
- ✅ Service can get active banner (highest priority)
- ✅ Service can dismiss banners
- ✅ Service checks banner active state (start/end time)
- ✅ Service is initialized in app.dart

**Testing**:
- Test get maintenance banner
- Test get upgrade banner
- Test get active banner (priority)
- Test banner dismissal
- Test banner active state checking
- Test remote config refresh

---

### Task 2: Create Banner Controller

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Create GetX controller to manage banner UI state and operations.

**Files to Create/Modify**:
- `lib/core/controllers/banner_controller.dart` (new file)

**Dependencies**:
- Task 1 (BannerService)

**Implementation Steps**:

1. **Create BannerController**:
   ```dart
   // lib/core/controllers/banner_controller.dart
   import 'package:get/get.dart';
   import '../services/banner_service.dart';
   import '../services/snackbar_service.dart';
   import '../constants/app_strings_en.dart';
   import 'package:url_launcher/url_launcher.dart';
   
   class BannerController extends GetxController {
     final BannerService _bannerService = Get.find<BannerService>();
     
     final Rx<BannerConfig?> _activeBanner = Rx<BannerConfig?>(null);
     final RxBool _isLoading = false.obs;
     
     BannerConfig? get activeBanner => _activeBanner.value;
     bool get isLoading => _isLoading.value;
     bool get hasActiveBanner => _activeBanner.value != null;
     
     @override
     void onInit() {
       super.onInit();
       _loadBanner();
     }
     
     Future<void> _loadBanner() async {
       _isLoading.value = true;
       try {
         final banner = _bannerService.getActiveBanner();
         _activeBanner.value = banner;
       } catch (e) {
         Get.log('ERROR: Failed to load banner: $e');
       } finally {
         _isLoading.value = false;
       }
     }
     
     Future<void> refreshBanner() async {
       await _bannerService.refresh();
       await _loadBanner();
     }
     
     Future<void> dismissBanner() async {
       final banner = _activeBanner.value;
       if (banner == null) return;
       
       try {
         await _bannerService.dismissBanner(banner.type, banner);
         _activeBanner.value = null;
         SnackbarService().showSuccess(
           title: AppStrings.I.success,
           message: AppStrings.I.bannerDismissed,
         );
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.I.error,
           message: 'Failed to dismiss banner: $e',
         );
       }
     }
     
     Future<void> handleBannerAction() async {
       final banner = _activeBanner.value;
       if (banner == null || banner.actionUrl == null) return;
       
       try {
         final uri = Uri.parse(banner.actionUrl!);
         if (await canLaunchUrl(uri)) {
           await launchUrl(uri);
         } else {
           SnackbarService().showError(
             title: AppStrings.I.error,
             message: 'Cannot open link: ${banner.actionUrl}',
           );
         }
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.I.error,
           message: 'Failed to open link: $e',
         );
       }
     }
   }
   ```

2. **Add AppStrings constants**:
   ```dart
   // In app_strings_en.dart
   static const String bannerDismissed = 'Banner dismissed';
   ```

**Expected Results**:
- ✅ BannerController exists
- ✅ Controller manages banner UI state
- ✅ Controller can refresh banner
- ✅ Controller can dismiss banner
- ✅ Controller can handle banner action
- ✅ Controller shows success/error messages

**Testing**:
- Test controller initialization
- Test load banner
- Test refresh banner
- Test dismiss banner
- Test handle banner action
- Test error handling

---

### Task 3: Create Banner Widget

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Create reusable banner widget to display maintenance/upgrade banners with proper styling.

**Files to Create/Modify**:
- `lib/app/widgets/maintenance_upgrade_banner.dart` (new file)

**Dependencies**:
- Task 2 (BannerController)

**Implementation Steps**:

1. **Create MaintenanceUpgradeBanner widget**:
   ```dart
   // lib/app/widgets/maintenance_upgrade_banner.dart
   import 'package:flutter/material.dart';
   import 'package:get/get.dart';
   import '../../core/controllers/banner_controller.dart';
   import '../../core/services/banner_service.dart';
   import '../../app/theme/app_colors.dart';
   import '../../app/theme/app_text_styles.dart';
   import '../../core/constants/app_spacing.dart';
   import 'td_button.dart';
   
   class MaintenanceUpgradeBanner extends StatelessWidget {
     const MaintenanceUpgradeBanner({super.key});
     
     @override
     Widget build(BuildContext context) {
       final controller = Get.put(BannerController());
       
       return Obx(() {
         final banner = controller.activeBanner;
         if (banner == null) {
           return const SizedBox.shrink();
         }
         
         return _buildBanner(banner, controller);
       });
     }
     
     Widget _buildBanner(BannerConfig banner, BannerController controller) {
       final color = _getBannerColor(banner.type, banner.priority);
       final icon = _getBannerIcon(banner.type);
       
       return Container(
         width: double.infinity,
         margin: const EdgeInsets.all(AppSpacing.sm),
         padding: const EdgeInsets.all(AppSpacing.md),
         decoration: BoxDecoration(
           color: color.withValues(alpha: 0.1),
           borderRadius: BorderRadius.circular(12),
           border: Border.all(
             color: color.withValues(alpha: 0.3),
             width: 1,
           ),
         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(
               children: [
                 Icon(
                   icon,
                   color: color,
                   size: 20,
                 ),
                 const SizedBox(width: AppSpacing.sm),
                 Expanded(
                   child: Text(
                     banner.title.isNotEmpty ? banner.title : _getDefaultTitle(banner.type),
                     style: AppTextStyles.titleSmall.copyWith(
                       color: color,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 ),
                 if (banner.dismissible)
                   IconButton(
                     icon: Icon(Icons.close, size: 18, color: color),
                     onPressed: () => controller.dismissBanner(),
                     padding: EdgeInsets.zero,
                     constraints: const BoxConstraints(),
                   ),
               ],
             ),
             if (banner.message.isNotEmpty) ...[
               const SizedBox(height: AppSpacing.sm),
               Text(
                 banner.message,
                 style: AppTextStyles.bodySmall.copyWith(
                   color: AppColors.onSurfaceVariant,
                 ),
               ),
             ],
             if (banner.actionText != null && banner.actionUrl != null) ...[
               const SizedBox(height: AppSpacing.sm),
               TDButton(
                 text: banner.actionText!,
                 onPressed: () => controller.handleBannerAction(),
                 variant: TDButtonVariant.outlined,
               ),
             ],
           ],
         ),
       );
     }
     
     Color _getBannerColor(BannerType type, BannerPriority priority) {
       if (priority == BannerPriority.critical) {
         return AppColors.error;
       }
       
       switch (type) {
         case BannerType.maintenance:
           return AppColors.warning;
         case BannerType.upgrade:
           return AppColors.info;
       }
     }
     
     IconData _getBannerIcon(BannerType type) {
       switch (type) {
         case BannerType.maintenance:
           return Icons.build;
         case BannerType.upgrade:
           return Icons.system_update;
       }
     }
     
     String _getDefaultTitle(BannerType type) {
       switch (type) {
         case BannerType.maintenance:
           return 'Maintenance in Progress';
         case BannerType.upgrade:
           return 'Update Available';
       }
     }
   }
   ```

**Expected Results**:
- ✅ MaintenanceUpgradeBanner widget exists
- ✅ Widget displays banner with proper styling
- ✅ Widget shows title, message, and action button
- ✅ Widget has dismiss button (if dismissible)
- ✅ Widget styling matches banner type and priority
- ✅ Widget is reusable

**Testing**:
- Test banner display
- Test banner styling
- Test dismiss button
- Test action button
- Test different banner types
- Test different priorities

---

### Task 4: Integrate Banner into App Scaffold

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Integrate banner widget into main app scaffold so it appears on all screens (or key screens).

**Files to Modify**:
- `lib/app/app.dart` (add banner to GetMaterialApp)
- `lib/app/pages/home/dashboard_page.dart` (add banner to home screen)
- OR Create wrapper widget for all screens

**Dependencies**:
- Task 3 (MaintenanceUpgradeBanner widget)

**Implementation Steps**:

1. **Option A: Add banner to main app scaffold** (Recommended):
   ```dart
   // In lib/app/app.dart
   import 'widgets/maintenance_upgrade_banner.dart';
   
   @override
   Widget build(BuildContext context) {
     final themeController = Get.put(ThemeController());
     return GetBuilder<ThemeController>(
       init: themeController,
       builder: (ctrl) {
         final seed = ctrl.primaryColor;
         return GetMaterialApp(
           title: AppConstants.appName,
           theme: AppTheme.lightTheme(seed),
           darkTheme: AppTheme.darkTheme(seed),
           themeMode: ctrl.themeMode,
           builder: (context, child) {
             return Scaffold(
               body: Column(
                 children: [
                   const MaintenanceUpgradeBanner(),
                   Expanded(child: child ?? const SizedBox()),
                 ],
               ),
             );
           },
           getPages: AppRouter.routes,
           initialRoute: AppRouter.initialRoute,
           // ... rest of config ...
         );
       },
     );
   }
   ```

2. **Option B: Add banner to key screens**:
   ```dart
   // In lib/app/pages/home/dashboard_page.dart
   import '../../../widgets/maintenance_upgrade_banner.dart';
   
   body: SingleChildScrollView(
     padding: const EdgeInsets.all(16),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         const MaintenanceUpgradeBanner(),
         // ... rest of content ...
       ],
     ),
   ),
   ```

3. **Initialize BannerController on app launch**:
   ```dart
   // In app.dart initialize
   // BannerController will be initialized when banner widget is built
   ```

**Expected Results**:
- ✅ Banner is integrated into app scaffold
- ✅ Banner appears on all screens (or key screens)
- ✅ Banner is positioned correctly
- ✅ Banner doesn't block critical UI elements
- ✅ Banner is scrollable (if needed)

**Testing**:
- Test banner appears on app launch
- Test banner appears on different screens
- Test banner positioning
- Test banner doesn't block UI
- Test banner scrolling

---

### Task 5: Add Banner Refresh on App Launch

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 1-2 hours

**Description**:
Add banner refresh on app launch to get latest banner configuration from remote config.

**Files to Modify**:
- `lib/app/app.dart` (add banner refresh in initialize)

**Dependencies**:
- Task 1 (BannerService)
- Task 2 (BannerController)

**Implementation Steps**:

1. **Add banner refresh in app initialization**:
   ```dart
   // In lib/app/app.dart
   import 'core/services/banner_service.dart';
   import 'core/controllers/banner_controller.dart';
   
   static Future<void> initialize() async {
     // ... existing initialization ...
     
     // Initialize Banner Service
     final bannerService = BannerService();
     await bannerService.initialize();
     Get.put(bannerService);
     
     // Refresh banner on app launch
     await bannerService.refresh();
     
     // Initialize Banner Controller (will load banner)
     Get.put(BannerController());
   }
   ```

2. **Add periodic banner refresh** (optional):
   ```dart
   // In BannerService or BannerController
   Timer? _refreshTimer;
   
   void startPeriodicRefresh() {
     _refreshTimer = Timer.periodic(Duration(minutes: 15), (timer) {
       refresh();
     });
   }
   
   void stopPeriodicRefresh() {
     _refreshTimer?.cancel();
   }
   ```

**Expected Results**:
- ✅ Banner is refreshed on app launch
- ✅ Banner shows latest configuration
- ✅ Periodic refresh works (if implemented)
- ✅ Refresh is efficient and non-blocking

**Testing**:
- Test banner refresh on app launch
- Test banner shows latest config
- Test periodic refresh (if implemented)
- Test refresh doesn't block app

---

### Task 6: Add Banner Scheduling Support

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Enhance banner service to support scheduled banners (start/end times) and check banner active state.

**Files to Modify**:
- `lib/core/services/banner_service.dart` (enhance with scheduling)

**Dependencies**:
- Task 1 (BannerService)

**Implementation Steps**:

1. **Enhance BannerConfig with scheduling** (already in Task 1):
   - `startTime` and `endTime` fields already added
   - `isActive` getter already checks time range

2. **Add scheduled banner checking**:
   ```dart
   // In BannerService
   /// Check if banner should be displayed based on schedule
   bool _isBannerScheduled(BannerConfig config) {
     if (config.startTime == null && config.endTime == null) {
       return true; // No schedule, always active if enabled
     }
     
     final now = DateTime.now();
     
     if (config.startTime != null && now.isBefore(config.startTime!)) {
       return false; // Not started yet
     }
     
     if (config.endTime != null && now.isAfter(config.endTime!)) {
       return false; // Already ended
     }
     
     return true; // Within schedule
   }
   ```

3. **Add scheduled banner monitoring** (optional):
   ```dart
   // In BannerService
   Timer? _scheduleTimer;
   
   void startScheduleMonitoring() {
     _scheduleTimer = Timer.periodic(Duration(minutes: 1), (timer) {
       // Check if any scheduled banner should appear/disappear
       final activeBanner = getActiveBanner();
       // Notify controller if banner state changes
     });
   }
   ```

**Expected Results**:
- ✅ Banner scheduling is supported
- ✅ Banners appear at start time
- ✅ Banners disappear at end time
- ✅ Schedule checking works correctly
- ✅ Schedule monitoring works (if implemented)

**Testing**:
- Test banner appears at start time
- Test banner disappears at end time
- Test banner with no schedule
- Test schedule monitoring (if implemented)

---

## Summary

### Implementation Order:
1. **Task 1**: Create Banner Service for Remote Config Integration
2. **Task 2**: Create Banner Controller
3. **Task 3**: Create Banner Widget
4. **Task 4**: Integrate Banner into App Scaffold
5. **Task 5**: Add Banner Refresh on App Launch
6. **Task 6**: Add Banner Scheduling Support

### Estimated Total Time: 13-19 hours

### Dependencies:
- Task 1 is independent
- Task 2 depends on Task 1
- Task 3 depends on Task 2
- Task 4 depends on Task 3
- Task 5 depends on Tasks 1 and 2
- Task 6 depends on Task 1

### Testing Requirements:
- Unit tests for BannerService
- Unit tests for BannerController
- Widget tests for MaintenanceUpgradeBanner
- Integration tests for banner display
- Manual testing for remote config integration
- Manual testing for banner dismissal
- Manual testing for banner scheduling

### Success Criteria:
- ✅ Maintenance banner is displayed when maintenance mode is active
- ✅ Upgrade banner is displayed when upgrade is available
- ✅ Banner configuration is retrieved from remote config
- ✅ Banner can be dismissed
- ✅ Banner dismissal persists
- ✅ Banner priority is handled correctly
- ✅ Banner scheduling works correctly
- ✅ Banner refresh works correctly

### Security and Reliability Considerations:
- Banner should not break app functionality
- Remote config should be validated before displaying banner
- Banner dismissal should be secure (prevent spoofing)
- Banner scheduling should handle timezone correctly
- Banner refresh should be efficient and non-blocking
- Banner should handle remote config errors gracefully

