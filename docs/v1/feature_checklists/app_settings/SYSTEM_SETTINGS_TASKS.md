# System Settings: Language, Date/Time Format, Timezone Defaults, Background Data Permissions - Task List & Implementation Steps

## Overview
This document lists all tasks required to complete the **System Settings** feature. Currently, this feature is **PARTIAL** - Workspace settings capture language/timezone/date/time format, but no global app settings page exists for these settings; no background data permission handling exists. This feature should include: language selection, date/time format selection, timezone defaults, and background data permission management (notifications, sync).

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `WorkspaceSettings` entity - has timezone, language, dateFormat, timeFormat fields
- ✅ `WorkspaceSettingsPage` - can set language/timezone/date/time format per workspace
- ✅ Helper classes: `WorkspaceTimezones`, `WorkspaceLanguages`, `WorkspaceDateFormats`, `WorkspaceTimeFormats`
- ✅ `StorageService` - has `setLanguage()`, `getLanguage()` methods (app-wide)
- ✅ `NotificationService` - has permission handling for notifications (partial)

### What's Missing/Broken:
- ⛔ No global app settings page for language/timezone/date/time format
- ⛔ No app-wide system settings service
- ⛔ No background data permission handling
- ⛔ No background sync permission handling
- ⛔ No UI for background data/sync permissions
- ⚠️ Workspace override integration may need improvement

---

## Task List

### Task 1: Create App-Wide System Settings Service

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Create service to manage app-wide system settings (language, timezone, date format, time format) with persistence.

**Files to Create/Modify**:
- `lib/core/services/app_system_settings_service.dart` (new file)
- `lib/core/services/storage_service.dart` (add system settings methods)

**Dependencies**:
- None

**Implementation Steps**:

1. **Create AppSystemSettingsService**:
   ```dart
   // lib/core/services/app_system_settings_service.dart
   import 'package:get/get.dart';
   import 'storage_service.dart';
   import '../../features/workspace/domain/entities/workspace_settings.dart';
   
   class AppSystemSettingsService {
     factory AppSystemSettingsService() => _instance ??= AppSystemSettingsService._();
     AppSystemSettingsService._();
     static AppSystemSettingsService? _instance;
     
     final StorageService _storage = StorageService();
     
     static const String _languageKey = 'app_language';
     static const String _timezoneKey = 'app_timezone';
     static const String _dateFormatKey = 'app_date_format';
     static const String _timeFormatKey = 'app_time_format';
     
     // Default values
     static const String _defaultLanguage = 'en';
     static const String _defaultTimezone = 'UTC';
     static const String _defaultDateFormat = 'MM/dd/yyyy';
     static const String _defaultTimeFormat = '12h';
     
     /// Get app-wide language
     String getLanguage() {
       return _storage.getString(_languageKey) ?? _defaultLanguage;
     }
     
     /// Set app-wide language
     Future<void> setLanguage(String language) async {
       if (!WorkspaceLanguages.available.contains(language)) {
         throw ArgumentError('Invalid language: $language');
       }
       await _storage.setString(_languageKey, language);
       // Apply language change (if localization is implemented)
       // Get.updateLocale(Locale(language));
     }
     
     /// Get app-wide timezone
     String getTimezone() {
       return _storage.getString(_timezoneKey) ?? _defaultTimezone;
     }
     
     /// Set app-wide timezone
     Future<void> setTimezone(String timezone) async {
       if (!WorkspaceTimezones.available.contains(timezone)) {
         throw ArgumentError('Invalid timezone: $timezone');
       }
       await _storage.setString(_timezoneKey, timezone);
     }
     
     /// Get app-wide date format
     String getDateFormat() {
       return _storage.getString(_dateFormatKey) ?? _defaultDateFormat;
     }
     
     /// Set app-wide date format
     Future<void> setDateFormat(String dateFormat) async {
       if (!WorkspaceDateFormats.available.contains(dateFormat)) {
         throw ArgumentError('Invalid date format: $dateFormat');
       }
       await _storage.setString(_dateFormatKey, dateFormat);
     }
     
     /// Get app-wide time format
     String getTimeFormat() {
       return _storage.getString(_timeFormatKey) ?? _defaultTimeFormat;
     }
     
     /// Set app-wide time format
     Future<void> setTimeFormat(String timeFormat) async {
       if (!WorkspaceTimeFormats.available.contains(timeFormat)) {
         throw ArgumentError('Invalid time format: $timeFormat');
       }
       await _storage.setString(_timeFormatKey, timeFormat);
     }
     
     /// Get all app-wide system settings
     Map<String, String> getAllSettings() {
       return {
         'language': getLanguage(),
         'timezone': getTimezone(),
         'dateFormat': getDateFormat(),
         'timeFormat': getTimeFormat(),
       };
     }
     
     /// Reset to defaults
     Future<void> resetToDefaults() async {
       await _storage.remove(_languageKey);
       await _storage.remove(_timezoneKey);
       await _storage.remove(_dateFormatKey);
       await _storage.remove(_timeFormatKey);
     }
   }
   ```

2. **Initialize AppSystemSettingsService in app.dart**:
   ```dart
   // In lib/app/app.dart
   import 'core/services/app_system_settings_service.dart';
   
   static Future<void> initialize() async {
     // ... existing initialization ...
     
     // Initialize App System Settings Service
     Get.put(AppSystemSettingsService());
   }
   ```

**Expected Results**:
- ✅ AppSystemSettingsService exists
- ✅ Service can get/set app-wide language, timezone, date format, time format
- ✅ Service validates settings values
- ✅ Service persists settings
- ✅ Service is initialized in app.dart

**Testing**:
- Test get/set language
- Test get/set timezone
- Test get/set date format
- Test get/set time format
- Test validation
- Test persistence

---

### Task 2: Create System Settings Controller

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Create GetX controller to manage system settings UI state and operations.

**Files to Create/Modify**:
- `lib/core/controllers/system_settings_controller.dart` (new file)

**Dependencies**:
- Task 1 (AppSystemSettingsService)

**Implementation Steps**:

1. **Create SystemSettingsController**:
   ```dart
   // lib/core/controllers/system_settings_controller.dart
   import 'package:get/get.dart';
   import '../services/app_system_settings_service.dart';
   import '../services/snackbar_service.dart';
   import '../constants/app_strings.dart';
   import '../../features/workspace/domain/entities/workspace_settings.dart';
   
   class SystemSettingsController extends GetxController {
     final AppSystemSettingsService _settingsService = Get.find<AppSystemSettingsService>();
     
     final RxString _language = 'en'.obs;
     final RxString _timezone = 'UTC'.obs;
     final RxString _dateFormat = 'MM/dd/yyyy'.obs;
     final RxString _timeFormat = '12h'.obs;
     final RxBool _isLoading = false.obs;
     
     String get language => _language.value;
     String get timezone => _timezone.value;
     String get dateFormat => _dateFormat.value;
     String get timeFormat => _timeFormat.value;
     bool get isLoading => _isLoading.value;
     
     @override
     void onInit() {
       super.onInit();
       _loadSettings();
     }
     
     Future<void> _loadSettings() async {
       _language.value = _settingsService.getLanguage();
       _timezone.value = _settingsService.getTimezone();
       _dateFormat.value = _settingsService.getDateFormat();
       _timeFormat.value = _settingsService.getTimeFormat();
     }
     
     Future<void> setLanguage(String language) async {
       _isLoading.value = true;
       try {
         await _settingsService.setLanguage(language);
         _language.value = language;
         SnackbarService().showSuccess(
           title: AppStrings.success,
           message: AppStrings.languageUpdated,
         );
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.error,
           message: 'Failed to update language: $e',
         );
       } finally {
         _isLoading.value = false;
       }
     }
     
     Future<void> setTimezone(String timezone) async {
       _isLoading.value = true;
       try {
         await _settingsService.setTimezone(timezone);
         _timezone.value = timezone;
         SnackbarService().showSuccess(
           title: AppStrings.success,
           message: AppStrings.timezoneUpdated,
         );
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.error,
           message: 'Failed to update timezone: $e',
         );
       } finally {
         _isLoading.value = false;
       }
     }
     
     Future<void> setDateFormat(String dateFormat) async {
       _isLoading.value = true;
       try {
         await _settingsService.setDateFormat(dateFormat);
         _dateFormat.value = dateFormat;
         SnackbarService().showSuccess(
           title: AppStrings.success,
           message: AppStrings.dateFormatUpdated,
         );
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.error,
           message: 'Failed to update date format: $e',
         );
       } finally {
         _isLoading.value = false;
       }
     }
     
     Future<void> setTimeFormat(String timeFormat) async {
       _isLoading.value = true;
       try {
         await _settingsService.setTimeFormat(timeFormat);
         _timeFormat.value = timeFormat;
         SnackbarService().showSuccess(
           title: AppStrings.success,
           message: AppStrings.timeFormatUpdated,
         );
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.error,
           message: 'Failed to update time format: $e',
         );
       } finally {
         _isLoading.value = false;
       }
     }
     
     Future<void> resetToDefaults() async {
       _isLoading.value = true;
       try {
         await _settingsService.resetToDefaults();
         await _loadSettings();
         SnackbarService().showSuccess(
           title: AppStrings.success,
           message: AppStrings.settingsReset,
         );
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.error,
           message: 'Failed to reset settings: $e',
         );
       } finally {
         _isLoading.value = false;
       }
     }
   }
   ```

2. **Add AppStrings constants**:
   ```dart
   // In app_strings.dart
   static const String languageUpdated = 'Language updated';
   static const String timezoneUpdated = 'Timezone updated';
   static const String dateFormatUpdated = 'Date format updated';
   static const String timeFormatUpdated = 'Time format updated';
   static const String settingsReset = 'Settings reset to defaults';
   ```

**Expected Results**:
- ✅ SystemSettingsController exists
- ✅ Controller manages system settings UI state
- ✅ Controller can update settings
- ✅ Controller shows success/error messages
- ✅ Controller can reset to defaults

**Testing**:
- Test controller initialization
- Test setting language
- Test setting timezone
- Test setting date format
- Test setting time format
- Test reset to defaults
- Test error handling

---

### Task 3: Add System Settings Section to AppSettingsPage

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Add system settings section (language, timezone, date format, time format) to AppSettingsPage.

**Files to Modify**:
- `lib/app/pages/settings/app_settings_page.dart`

**Dependencies**:
- Task 1 (AppSystemSettingsService)
- Task 2 (SystemSettingsController)

**Implementation Steps**:

1. **Add system settings section to AppSettingsPage**:
   ```dart
   // In lib/app/pages/settings/app_settings_page.dart
   import 'package:flutter/material.dart';
   import 'package:get/get.dart';
   import '../../../core/controllers/system_settings_controller.dart';
   import '../../../core/constants/app_strings.dart';
   import '../../../features/workspace/domain/entities/workspace_settings.dart';
   
   class AppSettingsPage extends StatelessWidget {
     const AppSettingsPage({super.key});
     
     @override
     Widget build(BuildContext context) {
       final themeController = Get.find<ThemeController>();
       final systemController = Get.put(SystemSettingsController());
       final current = themeController.primaryColor;
       
       return Scaffold(
         backgroundColor: AppColors.background,
         appBar: AppBar(
           title: const Text(AppStrings.settings),
           backgroundColor: AppColors.primary,
           foregroundColor: AppColors.onPrimary,
         ),
         body: SingleChildScrollView(
           padding: const EdgeInsets.all(16),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               const WorkspaceSelector(),
               const SizedBox(height: 24),
               
               // Appearance Section
               Text(AppStrings.appearance, style: Theme.of(context).textTheme.titleLarge),
               const SizedBox(height: 12),
               _ThemeModePicker(controller: themeController),
               const SizedBox(height: 24),
               Text(AppStrings.primaryColor, style: Theme.of(context).textTheme.titleMedium),
               const SizedBox(height: 12),
               _ColorPicker(
                 initial: current,
                 onChanged: themeController.setPrimaryColor,
               ),
               const SizedBox(height: 24),
               
               // System Settings Section
               Text(AppStrings.systemSettings, style: Theme.of(context).textTheme.titleLarge),
               const SizedBox(height: 12),
               _buildSystemSettingsSection(systemController),
               const SizedBox(height: 24),
               
               // Reset to Defaults
               TDButton(
                 text: AppStrings.resetToDefaults,
                 onPressed: () async {
                   final confirmed = await Get.dialog<bool>(
                     AlertDialog(
                       title: Text(AppStrings.resetToDefaults),
                       content: Text(AppStrings.resetSystemSettingsConfirmation),
                       actions: [
                         TextButton(
                           onPressed: () => Get.back(result: false),
                           child: Text(AppStrings.cancel),
                         ),
                         TextButton(
                           onPressed: () => Get.back(result: true),
                           child: Text(AppStrings.reset),
                         ),
                       ],
                     ),
                   );
                   
                   if (confirmed == true) {
                     await systemController.resetToDefaults();
                   }
                 },
               ),
             ],
           ),
         ),
       );
     }
     
     Widget _buildSystemSettingsSection(SystemSettingsController controller) {
       return GetBuilder<SystemSettingsController>(
         builder: (controller) => Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             // Language
             _buildDropdownSetting(
               title: AppStrings.language,
               value: controller.language,
               items: WorkspaceLanguages.available,
               displayNames: WorkspaceLanguages.available
                   .map(WorkspaceLanguages.getDisplayName)
                   .toList(),
               onChanged: (value) => controller.setLanguage(value),
             ),
             const SizedBox(height: 16),
             
             // Timezone
             _buildDropdownSetting(
               title: AppStrings.timezone,
               value: controller.timezone,
               items: WorkspaceTimezones.available,
               onChanged: (value) => controller.setTimezone(value),
             ),
             const SizedBox(height: 16),
             
             // Date Format
             _buildDropdownSetting(
               title: AppStrings.dateFormat,
               value: controller.dateFormat,
               items: WorkspaceDateFormats.available,
               onChanged: (value) => controller.setDateFormat(value),
             ),
             const SizedBox(height: 16),
             
             // Time Format
             _buildDropdownSetting(
               title: AppStrings.timeFormat,
               value: controller.timeFormat,
               items: WorkspaceTimeFormats.available,
               onChanged: (value) => controller.setTimeFormat(value),
             ),
           ],
         ),
       );
     }
     
     Widget _buildDropdownSetting({
       required String title,
       required String value,
       required List<String> items,
       List<String>? displayNames,
       required ValueChanged<String> onChanged,
     }) {
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
           const SizedBox(height: 8),
           DropdownButtonFormField<String>(
             value: value,
             items: items.map((item) {
               final index = items.indexOf(item);
               final displayName = displayNames != null && index < displayNames.length
                   ? displayNames[index]
                   : item;
               return DropdownMenuItem(
                 value: item,
                 child: Text(displayName),
               );
             }).toList(),
             onChanged: (value) {
               if (value != null) {
                 onChanged(value);
               }
             },
           ),
         ],
       );
     }
   }
   ```

2. **Add AppStrings constants**:
   ```dart
   // In app_strings.dart
   static const String systemSettings = 'System Settings';
   static const String language = 'Language';
   static const String timezone = 'Timezone';
   static const String dateFormat = 'Date Format';
   static const String timeFormat = 'Time Format';
   static const String resetSystemSettingsConfirmation = 'Reset system settings to defaults?';
   ```

**Expected Results**:
- ✅ System settings section is added to AppSettingsPage
- ✅ Language, timezone, date format, time format dropdowns are displayed
- ✅ Settings can be changed
- ✅ Reset to defaults button is available
- ✅ UI is user-friendly

**Testing**:
- Test system settings section display
- Test language selection
- Test timezone selection
- Test date format selection
- Test time format selection
- Test reset to defaults

---

### Task 4: Create Background Data Permission Service

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Create service to check and manage background data permissions.

**Files to Create/Modify**:
- `lib/core/services/background_data_permission_service.dart` (new file)
- `pubspec.yaml` (add permission_handler if not already included)

**Dependencies**:
- permission_handler package

**Implementation Steps**:

1. **Add permission_handler to pubspec.yaml** (if not already included):
   ```yaml
   dependencies:
     permission_handler: ^11.1.0
   ```

2. **Create BackgroundDataPermissionService**:
   ```dart
   // lib/core/services/background_data_permission_service.dart
   import 'package:get/get.dart';
   import 'package:permission_handler/permission_handler.dart';
   import 'package:url_launcher/url_launcher.dart';
   import 'dart:io';
   
   class BackgroundDataPermissionService {
     factory BackgroundDataPermissionService() => _instance ??= BackgroundDataPermissionService._();
     BackgroundDataPermissionService._();
     static BackgroundDataPermissionService? _instance;
     
     /// Check if background data is allowed
     Future<bool> isBackgroundDataAllowed() async {
       try {
         if (Platform.isAndroid) {
           // Android: Check if app has unrestricted data access
           // This requires checking device settings (not directly accessible)
           // Return true by default, user can check manually
           return true; // Assume allowed unless user reports issue
         } else if (Platform.isIOS) {
           // iOS: Background data is generally allowed
           return true;
         }
         return true;
       } catch (e) {
         Get.log('ERROR: Failed to check background data permission: $e');
         return true; // Fail open
       }
     }
     
     /// Open device settings for background data
     Future<void> openBackgroundDataSettings() async {
       try {
         if (Platform.isAndroid) {
           // Open Android app settings
           await openAppSettings();
         } else if (Platform.isIOS) {
           // Open iOS app settings
           await openAppSettings();
         }
       } catch (e) {
         Get.log('ERROR: Failed to open settings: $e');
       }
     }
     
     /// Check notification permission
     Future<bool> isNotificationPermissionGranted() async {
       try {
         final status = await Permission.notification.status;
         return status.isGranted;
       } catch (e) {
         Get.log('ERROR: Failed to check notification permission: $e');
         return false;
       }
     }
     
     /// Request notification permission
     Future<bool> requestNotificationPermission() async {
       try {
         final status = await Permission.notification.request();
         return status.isGranted;
       } catch (e) {
         Get.log('ERROR: Failed to request notification permission: $e');
         return false;
       }
     }
     
     /// Open app settings
     Future<void> openAppSettings() async {
       try {
         final uri = Uri.parse('app-settings:');
         if (await canLaunchUrl(uri)) {
           await launchUrl(uri);
         } else {
           Get.log('ERROR: Cannot open app settings');
         }
       } catch (e) {
         Get.log('ERROR: Failed to open app settings: $e');
       }
     }
   }
   ```

3. **Initialize BackgroundDataPermissionService in app.dart**:
   ```dart
   // In lib/app/app.dart
   import 'core/services/background_data_permission_service.dart';
   
   static Future<void> initialize() async {
     // ... existing initialization ...
     
     // Initialize Background Data Permission Service
     Get.put(BackgroundDataPermissionService());
   }
   ```

**Expected Results**:
- ✅ BackgroundDataPermissionService exists
- ✅ Service can check background data permission status
- ✅ Service can open device settings
- ✅ Service can check/request notification permission
- ✅ Service is initialized in app.dart

**Testing**:
- Test background data permission checking
- Test opening device settings
- Test notification permission checking
- Test notification permission requesting

---

### Task 5: Add Background Data Permission Section to AppSettingsPage

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Add background data permission section to AppSettingsPage with status display and settings link.

**Files to Modify**:
- `lib/app/pages/settings/app_settings_page.dart`

**Dependencies**:
- Task 4 (BackgroundDataPermissionService)

**Implementation Steps**:

1. **Add background data permission section**:
   ```dart
   // In lib/app/pages/settings/app_settings_page.dart
   import '../../../core/services/background_data_permission_service.dart';
   
   Widget _buildBackgroundDataSection() {
     final permissionService = Get.find<BackgroundDataPermissionService>();
     
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text(
           AppStrings.backgroundData,
           style: Theme.of(context).textTheme.titleLarge,
         ),
         const SizedBox(height: 12),
         
         // Background Data Status
         FutureBuilder<bool>(
           future: permissionService.isBackgroundDataAllowed(),
           builder: (context, snapshot) {
             final isAllowed = snapshot.data ?? true;
             return ListTile(
               title: Text(AppStrings.backgroundDataAccess),
               subtitle: Text(
                 isAllowed 
                     ? AppStrings.backgroundDataAllowed
                     : AppStrings.backgroundDataRestricted,
               ),
               trailing: Icon(
                 isAllowed ? Icons.check_circle : Icons.warning,
                 color: isAllowed ? Colors.green : Colors.orange,
               ),
             );
           },
         ),
         
         // Open Settings Button
         TDButton(
           text: AppStrings.openDataSettings,
           onPressed: () => permissionService.openBackgroundDataSettings(),
         ),
         
         const SizedBox(height: 16),
         
         // Notification Permission
         FutureBuilder<bool>(
           future: permissionService.isNotificationPermissionGranted(),
           builder: (context, snapshot) {
             final isGranted = snapshot.data ?? false;
             return ListTile(
               title: Text(AppStrings.notificationPermission),
               subtitle: Text(
                 isGranted
                     ? AppStrings.notificationsAllowed
                     : AppStrings.notificationsDenied,
               ),
               trailing: IconButton(
                 icon: Icon(isGranted ? Icons.notifications_active : Icons.notifications_off),
                 onPressed: () async {
                   if (!isGranted) {
                     final granted = await permissionService.requestNotificationPermission();
                     if (granted) {
                       SnackbarService().showSuccess(
                         title: AppStrings.success,
                         message: AppStrings.notificationsEnabled,
                       );
                     }
                   }
                 },
               ),
             );
           },
         ),
       ],
     );
   }
   ```

2. **Add section to AppSettingsPage**:
   ```dart
   // Add after system settings section
   const SizedBox(height: 24),
   _buildBackgroundDataSection(),
   ```

3. **Add AppStrings constants**:
   ```dart
   // In app_strings.dart
   static const String backgroundData = 'Background Data';
   static const String backgroundDataAccess = 'Background Data Access';
   static const String backgroundDataAllowed = 'Allowed';
   static const String backgroundDataRestricted = 'Restricted';
   static const String openDataSettings = 'Open Data Settings';
   static const String notificationPermission = 'Notification Permission';
   static const String notificationsAllowed = 'Allowed';
   static const String notificationsDenied = 'Denied';
   static const String notificationsEnabled = 'Notifications enabled';
   ```

**Expected Results**:
- ✅ Background data permission section is added
- ✅ Permission status is displayed
- ✅ User can open device settings
- ✅ Notification permission can be requested
- ✅ UI is user-friendly

**Testing**:
- Test background data section display
- Test permission status display
- Test opening device settings
- Test notification permission requesting

---

### Task 6: Integrate Workspace Override with App-Wide Settings

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Integrate workspace-specific settings to override app-wide defaults when workspace is active.

**Files to Create/Modify**:
- `lib/core/services/workspace_settings_override_service.dart` (new file)
- `lib/features/workspace/presentation/controllers/workspace_controller.dart` (integrate override)

**Dependencies**:
- Task 1 (AppSystemSettingsService)
- WorkspaceController

**Implementation Steps**:

1. **Create WorkspaceSettingsOverrideService**:
   ```dart
   // lib/core/services/workspace_settings_override_service.dart
   import 'package:get/get.dart';
   import '../services/app_system_settings_service.dart';
   import '../../features/workspace/domain/entities/workspace_settings.dart';
   import '../../features/workspace/presentation/controllers/workspace_controller.dart';
   
   class WorkspaceSettingsOverrideService {
     factory WorkspaceSettingsOverrideService() => _instance ??= WorkspaceSettingsOverrideService._();
     WorkspaceSettingsOverrideService._();
     static WorkspaceSettingsOverrideService? _instance;
     
     final AppSystemSettingsService _appSettings = Get.find<AppSystemSettingsService>();
     final WorkspaceController _workspaceController = Get.find<WorkspaceController>();
     
     /// Get effective language (workspace override or app-wide)
     String getEffectiveLanguage() {
       final workspace = _workspaceController.currentWorkspace.value;
       if (workspace == null) {
         return _appSettings.getLanguage();
       }
       
       final settings = WorkspaceSettings.fromMap(workspace.settings ?? {});
       // Use workspace language if set, otherwise app-wide
       return settings.language != _appSettings.getLanguage() 
           ? settings.language 
           : _appSettings.getLanguage();
     }
     
     /// Get effective timezone (workspace override or app-wide)
     String getEffectiveTimezone() {
       final workspace = _workspaceController.currentWorkspace.value;
       if (workspace == null) {
         return _appSettings.getTimezone();
       }
       
       final settings = WorkspaceSettings.fromMap(workspace.settings ?? {});
       // Use workspace timezone if different from default, otherwise app-wide
       return settings.timezone != _appSettings.getTimezone()
           ? settings.timezone
           : _appSettings.getTimezone();
     }
     
     /// Get effective date format (workspace override or app-wide)
     String getEffectiveDateFormat() {
       final workspace = _workspaceController.currentWorkspace.value;
       if (workspace == null) {
         return _appSettings.getDateFormat();
       }
       
       final settings = WorkspaceSettings.fromMap(workspace.settings ?? {});
       return settings.dateFormat != _appSettings.getDateFormat()
           ? settings.dateFormat
           : _appSettings.getDateFormat();
     }
     
     /// Get effective time format (workspace override or app-wide)
     String getEffectiveTimeFormat() {
       final workspace = _workspaceController.currentWorkspace.value;
       if (workspace == null) {
         return _appSettings.getTimeFormat();
       }
       
       final settings = WorkspaceSettings.fromMap(workspace.settings ?? {});
       return settings.timeFormat != _appSettings.getTimeFormat()
           ? settings.timeFormat
           : _appSettings.getTimeFormat();
     }
   }
   ```

2. **Initialize service and integrate with workspace switching**:
   ```dart
   // In app.dart
   Get.put(WorkspaceSettingsOverrideService());
   
   // In WorkspaceController
   Future<void> switchWorkspace(String workspaceId) async {
     // ... existing switch logic ...
     
     // Apply workspace settings overrides
     final overrideService = Get.find<WorkspaceSettingsOverrideService>();
     // Settings are applied automatically via getEffective* methods
   }
   ```

**Expected Results**:
- ✅ WorkspaceSettingsOverrideService exists
- ✅ Service provides effective settings (workspace override or app-wide)
- ✅ Service is integrated with workspace switching
- ✅ Workspace overrides work correctly

**Testing**:
- Test effective language with workspace override
- Test effective timezone with workspace override
- Test effective date format with workspace override
- Test effective time format with workspace override
- Test workspace switching with overrides

---

## Summary

### Implementation Order:
1. **Task 1**: Create App-Wide System Settings Service
2. **Task 2**: Create System Settings Controller
3. **Task 3**: Add System Settings Section to AppSettingsPage
4. **Task 4**: Create Background Data Permission Service
5. **Task 5**: Add Background Data Permission Section to AppSettingsPage
6. **Task 6**: Integrate Workspace Override with App-Wide Settings

### Estimated Total Time: 16-22 hours

### Dependencies:
- Task 1 is independent
- Task 2 depends on Task 1
- Task 3 depends on Tasks 1 and 2
- Task 4 is independent
- Task 5 depends on Task 4
- Task 6 depends on Task 1

### Testing Requirements:
- Unit tests for AppSystemSettingsService
- Unit tests for SystemSettingsController
- Unit tests for BackgroundDataPermissionService
- Unit tests for WorkspaceSettingsOverrideService
- Widget tests for AppSettingsPage
- Integration tests for workspace override
- Manual testing for permission handling

### Success Criteria:
- ✅ App-wide system settings can be set
- ✅ System settings persist correctly
- ✅ Background data permission can be checked
- ✅ Notification permission can be requested
- ✅ Workspace overrides work correctly
- ✅ App-wide defaults are used when no workspace override

### Security and Reliability Considerations:
- System settings should not break app functionality
- Permission checking should be accurate
- Persistence should work reliably across app restarts
- Workspace overrides should work correctly
- Default values should be safe and accessible
