# App Version & Update: AppVersions, Changelog, Forced Upgrade, Compatibility - Task List & Implementation Steps

## Overview
This document lists all tasks required to implement the **App Version & Update** feature. Currently, this feature is **MISSING** - No AppVersion screen/service, no forced-upgrade check, no schema compatibility check. This feature should include: AppVersions display, changelog display, forced upgrade check, and backend/schema compatibility check.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `pubspec.yaml` contains app version (1.0.0+7)
- ✅ `AppConstants` contains app version constant (1.0.0)
- ✅ `package_info_plus` can be used to get app version (mentioned in other tasks)
- ✅ Firebase Remote Config can be used (if configured)
- ✅ `url_launcher` package exists for opening app store

### What's Missing/Broken:
- ⛔ No AppVersion screen/service
- ⛔ No app version display in settings
- ⛔ No changelog display
- ⛔ No forced upgrade check
- ⛔ No optional upgrade notification
- ⛔ No automatic version check on app launch
- ⛔ No backend/schema compatibility check
- ⛔ No remote version retrieval
- ⛔ No app store integration for upgrades
- ⛔ No manual version check

---

## Task List

### Task 1: Add Package Info Dependency and Create App Version Service

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 1-2 hours

**Description**:
Add package_info_plus dependency and create service to retrieve app version information.

**Files to Create/Modify**:
- `pubspec.yaml` (add package_info_plus if not already included)
- `lib/core/services/app_version_service.dart` (new file)

**Dependencies**:
- None

**Implementation Steps**:

1. **Add package_info_plus to pubspec.yaml** (if not already included):
   ```yaml
   dependencies:
     package_info_plus: ^8.0.0
   ```

2. **Create AppVersionService**:
   ```dart
   // lib/core/services/app_version_service.dart
   import 'package:package_info_plus/package_info_plus.dart';
   import 'package:get/get.dart';
   
   class AppVersionService {
     factory AppVersionService() => _instance ??= AppVersionService._();
     AppVersionService._();
     static AppVersionService? _instance;
     
     PackageInfo? _packageInfo;
     
     /// Initialize and load package info
     Future<void> initialize() async {
       try {
         _packageInfo = await PackageInfo.fromPlatform();
         Get.log('App version loaded: ${_packageInfo?.version}');
       } catch (e) {
         Get.log('ERROR: Failed to load package info: $e');
       }
     }
     
     /// Get current app version
     String getCurrentVersion() {
       return _packageInfo?.version ?? '1.0.0';
     }
     
     /// Get current build number
     String getBuildNumber() {
       return _packageInfo?.buildNumber ?? '1';
     }
     
     /// Get full version string (version+build)
     String getFullVersion() {
       return '${getCurrentVersion()}+${getBuildNumber()}';
     }
     
     /// Get app name
     String getAppName() {
       return _packageInfo?.appName ?? 'TodoList';
     }
     
     /// Get package name
     String getPackageName() {
       return _packageInfo?.packageName ?? '';
     }
     
     /// Get all version information
     Map<String, String> getVersionInfo() {
       return {
         'version': getCurrentVersion(),
         'buildNumber': getBuildNumber(),
         'fullVersion': getFullVersion(),
         'appName': getAppName(),
         'packageName': getPackageName(),
       };
     }
   }
   ```

3. **Initialize AppVersionService in app.dart**:
   ```dart
   // In lib/app/app.dart
   import 'core/services/app_version_service.dart';
   
   static Future<void> initialize() async {
     // ... existing initialization ...
     
     // Initialize App Version Service
     final appVersionService = AppVersionService();
     await appVersionService.initialize();
     Get.put(appVersionService);
   }
   ```

**Expected Results**:
- ✅ package_info_plus is added to pubspec.yaml
- ✅ AppVersionService exists
- ✅ Service can retrieve app version information
- ✅ Service is initialized in app.dart
- ✅ Version information is accurate

**Testing**:
- Test version retrieval
- Test build number retrieval
- Test full version string
- Verify version matches pubspec.yaml

---

### Task 2: Create Remote Version Check Service

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Create service to check app version from remote config (Firebase Remote Config) or API.

**Files to Create/Modify**:
- `pubspec.yaml` (add firebase_remote_config if not already included)
- `lib/core/services/remote_version_service.dart` (new file)

**Dependencies**:
- Task 1 (AppVersionService)
- Firebase Remote Config (or version API)

**Implementation Steps**:

1. **Add firebase_remote_config to pubspec.yaml** (if not already included):
   ```yaml
   dependencies:
     firebase_remote_config: ^5.0.0
   ```

2. **Create RemoteVersionService**:
   ```dart
   // lib/core/services/remote_version_service.dart
   import 'package:firebase_remote_config/firebase_remote_config.dart';
   import 'package:get/get.dart';
   import 'app_version_service.dart';
   import 'storage_service.dart';
   import 'package:version/version.dart'; // For version comparison
   
   class RemoteVersionService {
     factory RemoteVersionService() => _instance ??= RemoteVersionService._();
     RemoteVersionService._();
     static RemoteVersionService? _instance;
     
     final AppVersionService _appVersionService = Get.find<AppVersionService>();
     final StorageService _storage = StorageService();
     RemoteConfig? _remoteConfig;
     
     static const String _lastVersionCheckKey = 'last_version_check_ms';
     static const Duration _versionCheckCacheDuration = Duration(hours: 6);
     
     /// Initialize Remote Config
     Future<void> initialize() async {
       try {
         _remoteConfig = RemoteConfig.instance;
         
         // Set default values
         await _remoteConfig!.setConfigSettings(RemoteConfigSettings(
           fetchTimeout: const Duration(seconds: 10),
           minimumFetchInterval: const Duration(hours: 1),
         ));
         
         // Set defaults
         await _remoteConfig!.setDefaults({
           'latest_version': '1.0.0',
           'minimum_required_version': '1.0.0',
           'forced_upgrade_enabled': false,
           'changelog': '[]',
         });
         
         // Fetch and activate
         await _remoteConfig!.fetchAndActivate();
         
         Get.log('Remote version service initialized');
       } catch (e) {
         Get.log('ERROR: Failed to initialize remote version service: $e');
       }
     }
     
     /// Get latest available version
     String getLatestVersion() {
       return _remoteConfig?.getString('latest_version') ?? '1.0.0';
     }
     
     /// Get minimum required version
     String getMinimumRequiredVersion() {
       return _remoteConfig?.getString('minimum_required_version') ?? '1.0.0';
     }
     
     /// Check if forced upgrade is enabled
     bool isForcedUpgradeEnabled() {
       return _remoteConfig?.getBool('forced_upgrade_enabled') ?? false;
     }
     
     /// Get changelog
     List<Map<String, dynamic>> getChangelog() {
       try {
         final changelogJson = _remoteConfig?.getString('changelog') ?? '[]';
         final changelog = jsonDecode(changelogJson) as List;
         return changelog.map((item) => Map<String, dynamic>.from(item as Map)).toList();
       } catch (e) {
         Get.log('ERROR: Failed to parse changelog: $e');
         return [];
       }
     }
     
     /// Check if update is required
     Future<VersionCheckResult> checkVersion() async {
       try {
         // Refresh remote config if cache is expired
         await _refreshIfNeeded();
         
         final currentVersion = _appVersionService.getCurrentVersion();
         final latestVersion = getLatestVersion();
         final minimumVersion = getMinimumRequiredVersion();
         final forcedUpgrade = isForcedUpgradeEnabled();
         
         final current = Version.parse(currentVersion);
         final latest = Version.parse(latestVersion);
         final minimum = Version.parse(minimumVersion);
         
         // Check if forced upgrade is required
         if (forcedUpgrade && current < minimum) {
           return VersionCheckResult(
             updateRequired: true,
             isForced: true,
             currentVersion: currentVersion,
             latestVersion: latestVersion,
             minimumVersion: minimumVersion,
           );
         }
         
         // Check if optional update is available
         if (current < latest) {
           return VersionCheckResult(
             updateRequired: true,
             isForced: false,
             currentVersion: currentVersion,
             latestVersion: latestVersion,
             minimumVersion: minimumVersion,
           );
         }
         
         // App is up to date
         return VersionCheckResult(
           updateRequired: false,
           isForced: false,
           currentVersion: currentVersion,
           latestVersion: latestVersion,
           minimumVersion: minimumVersion,
         );
       } catch (e) {
         Get.log('ERROR: Failed to check version: $e');
         // Return safe default (no update required)
         return VersionCheckResult(
           updateRequired: false,
           isForced: false,
           currentVersion: _appVersionService.getCurrentVersion(),
           latestVersion: _appVersionService.getCurrentVersion(),
           minimumVersion: _appVersionService.getCurrentVersion(),
         );
       }
     }
     
     /// Refresh remote config if cache is expired
     Future<void> _refreshIfNeeded() async {
       try {
         final lastCheckMs = _storage.getInt(_lastVersionCheckKey) ?? 0;
         final lastCheck = DateTime.fromMillisecondsSinceEpoch(lastCheckMs);
         final now = DateTime.now();
         
         if (now.difference(lastCheck) > _versionCheckCacheDuration) {
           await _remoteConfig?.fetchAndActivate();
           await _storage.setInt(_lastVersionCheckKey, now.millisecondsSinceEpoch);
           Get.log('Remote config refreshed');
         }
       } catch (e) {
         Get.log('ERROR: Failed to refresh remote config: $e');
       }
     }
   }
   
   /// Version check result
   class VersionCheckResult {
     final bool updateRequired;
     final bool isForced;
     final String currentVersion;
     final String latestVersion;
     final String minimumVersion;
     
     VersionCheckResult({
       required this.updateRequired,
       required this.isForced,
       required this.currentVersion,
       required this.latestVersion,
       required this.minimumVersion,
     });
   }
   ```

3. **Add version package to pubspec.yaml**:
   ```yaml
   dependencies:
     version: ^3.0.0  # For version comparison
   ```

**Expected Results**:
- ✅ RemoteVersionService exists
- ✅ Service can retrieve version information from Remote Config
- ✅ Service can check if update is required
- ✅ Service can determine if upgrade is forced
- ✅ Service caches version check results

**Testing**:
- Test version retrieval from Remote Config
- Test version comparison
- Test forced upgrade detection
- Test optional upgrade detection
- Test caching

---

### Task 3: Create Forced Upgrade Dialog and Gate

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Create forced upgrade dialog that blocks app usage until user upgrades, and integrate with app launch.

**Files to Create/Modify**:
- `lib/app/widgets/forced_upgrade_dialog.dart` (new file)
- `lib/app/app.dart` (add version check on launch)
- `lib/core/controllers/app_version_controller.dart` (new file)

**Dependencies**:
- Task 1 (AppVersionService)
- Task 2 (RemoteVersionService)

**Implementation Steps**:

1. **Create AppVersionController**:
   ```dart
   // lib/core/controllers/app_version_controller.dart
   import 'package:get/get.dart';
   import '../services/app_version_service.dart';
   import '../services/remote_version_service.dart';
   import '../services/navigation_service.dart';
   import '../constants/app_strings.dart';
   
   class AppVersionController extends GetxController {
     final AppVersionService _appVersionService = Get.find<AppVersionService>();
     final RemoteVersionService _remoteVersionService = Get.find<RemoteVersionService>();
     
     final RxBool _isCheckingVersion = false.obs;
     final Rx<VersionCheckResult?> _versionCheckResult = Rx<VersionCheckResult?>(null);
     
     bool get isCheckingVersion => _isCheckingVersion.value;
     VersionCheckResult? get versionCheckResult => _versionCheckResult.value;
     
     /// Check app version
     Future<void> checkVersion() async {
       _isCheckingVersion.value = true;
       
       try {
         final result = await _remoteVersionService.checkVersion();
         _versionCheckResult.value = result;
         
         // Show forced upgrade dialog if required
         if (result.updateRequired && result.isForced) {
           await _showForcedUpgradeDialog(result);
         }
       } catch (e) {
         Get.log('ERROR: Version check failed: $e');
       } finally {
         _isCheckingVersion.value = false;
       }
     }
     
     /// Show forced upgrade dialog
     Future<void> _showForcedUpgradeDialog(VersionCheckResult result) async {
       await Get.dialog(
         ForcedUpgradeDialog(
           currentVersion: result.currentVersion,
           latestVersion: result.latestVersion,
         ),
         barrierDismissible: false, // Cannot dismiss
       );
     }
     
     /// Open app store for upgrade
     Future<void> openAppStore() async {
       try {
         // Get package name
         final packageName = _appVersionService.getPackageName();
         
         // Open app store based on platform
         if (Platform.isAndroid) {
           await url_launcher.launchUrl(
             Uri.parse('https://play.google.com/store/apps/details?id=$packageName'),
           );
         } else if (Platform.isIOS) {
           // iOS app store URL (need to get from App Store Connect)
           await url_launcher.launchUrl(
             Uri.parse('https://apps.apple.com/app/id<APP_ID>'),
           );
         }
       } catch (e) {
         Get.log('ERROR: Failed to open app store: $e');
         SnackbarService().showError(
           title: AppStrings.error,
           message: 'Failed to open app store',
         );
       }
     }
   }
   ```

2. **Create ForcedUpgradeDialog widget**:
   ```dart
   // lib/app/widgets/forced_upgrade_dialog.dart
   import 'package:flutter/material.dart';
   import 'package:get/get.dart';
   import '../../core/constants/app_strings.dart';
   import '../../core/controllers/app_version_controller.dart';
   import '../widgets/td_button.dart';
   
   class ForcedUpgradeDialog extends StatelessWidget {
     final String currentVersion;
     final String latestVersion;
     
     const ForcedUpgradeDialog({
       super.key,
       required this.currentVersion,
       required this.latestVersion,
     });
     
     @override
     Widget build(BuildContext context) {
       final controller = Get.find<AppVersionController>();
       
       return WillPopScope(
         onWillPop: () async => false, // Prevent back button
         child: AlertDialog(
           title: Text(AppStrings.updateRequired),
           content: Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(AppStrings.updateRequiredMessage),
               SizedBox(height: 16),
               Text('${AppStrings.currentVersion}: $currentVersion'),
               Text('${AppStrings.latestVersion}: $latestVersion'),
             ],
           ),
           actions: [
             TDButton(
               text: AppStrings.updateNow,
               onPressed: () => controller.openAppStore(),
             ),
           ],
         ),
       );
     }
   }
   ```

3. **Add version check on app launch**:
   ```dart
   // In lib/app/app.dart or main.dart
   static Future<void> initialize() async {
     // ... existing initialization ...
     
     // Initialize App Version Controller
     Get.put(AppVersionController());
     
     // Check version after initialization
     final versionController = Get.find<AppVersionController>();
     await versionController.checkVersion();
   }
   ```

4. **Add AppStrings constants**:
   ```dart
   // In app_strings.dart
   static const String updateRequired = 'Update Required';
   static const String updateRequiredMessage = 'A new version of the app is required. Please update to continue.';
   static const String currentVersion = 'Current Version';
   static const String latestVersion = 'Latest Version';
   static const String updateNow = 'Update Now';
   ```

**Expected Results**:
- ✅ AppVersionController exists
- ✅ ForcedUpgradeDialog exists
- ✅ Forced upgrade dialog blocks app usage
- ✅ Version check is performed on app launch
- ✅ App store is opened for upgrade

**Testing**:
- Test forced upgrade dialog appears
- Test dialog cannot be dismissed
- Test app store opens correctly
- Test version check on app launch

---

### Task 4: Create Optional Upgrade Notification

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Create optional upgrade notification that notifies users when update is available but doesn't block app usage.

**Files to Create/Modify**:
- `lib/app/widgets/optional_upgrade_banner.dart` (new file)
- `lib/core/controllers/app_version_controller.dart` (add optional upgrade)

**Dependencies**:
- Task 2 (RemoteVersionService)
- Task 3 (AppVersionController)

**Implementation Steps**:

1. **Add optional upgrade to AppVersionController**:
   ```dart
   // In lib/core/controllers/app_version_controller.dart
   final RxBool _showOptionalUpgrade = false.obs;
   bool get showOptionalUpgrade => _showOptionalUpgrade.value;
   
   /// Check app version
   Future<void> checkVersion() async {
     _isCheckingVersion.value = true;
     
     try {
       final result = await _remoteVersionService.checkVersion();
       _versionCheckResult.value = result;
       
       if (result.updateRequired) {
         if (result.isForced) {
           // Show forced upgrade dialog
           await _showForcedUpgradeDialog(result);
         } else {
           // Show optional upgrade banner
           _showOptionalUpgrade.value = true;
         }
       }
     } catch (e) {
       Get.log('ERROR: Version check failed: $e');
     } finally {
       _isCheckingVersion.value = false;
     }
   }
   
   /// Dismiss optional upgrade banner
   void dismissOptionalUpgrade() {
     _showOptionalUpgrade.value = false;
   }
   ```

2. **Create OptionalUpgradeBanner widget**:
   ```dart
   // lib/app/widgets/optional_upgrade_banner.dart
   import 'package:flutter/material.dart';
   import 'package:get/get.dart';
   import '../../core/constants/app_strings.dart';
   import '../../core/controllers/app_version_controller.dart';
   
   class OptionalUpgradeBanner extends StatelessWidget {
     const OptionalUpgradeBanner({super.key});
     
     @override
     Widget build(BuildContext context) {
       final controller = Get.find<AppVersionController>();
       
       return Obx(() {
         if (!controller.showOptionalUpgrade) {
           return const SizedBox.shrink();
         }
         
         final result = controller.versionCheckResult;
         if (result == null) return const SizedBox.shrink();
         
         return Container(
           color: Colors.orange,
           padding: EdgeInsets.all(16),
           child: Row(
             children: [
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       AppStrings.updateAvailable,
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         color: Colors.white,
                       ),
                     ),
                     Text(
                       '${AppStrings.newVersionAvailable}: ${result.latestVersion}',
                       style: TextStyle(color: Colors.white),
                     ),
                   ],
                 ),
               ),
               TextButton(
                 onPressed: () => controller.openAppStore(),
                 child: Text(
                   AppStrings.updateNow,
                   style: TextStyle(color: Colors.white),
                 ),
               ),
               IconButton(
                 icon: Icon(Icons.close, color: Colors.white),
                 onPressed: () => controller.dismissOptionalUpgrade(),
               ),
             ],
           ),
         );
       });
     }
   }
   ```

3. **Add banner to main app scaffold**:
   ```dart
   // In main app scaffold or home page
   Scaffold(
     body: Column(
       children: [
         OptionalUpgradeBanner(),
         Expanded(
           child: MainContent(),
         ),
       ],
     ),
   )
   ```

**Expected Results**:
- ✅ OptionalUpgradeBanner exists
- ✅ Banner appears when optional update is available
- ✅ User can dismiss banner
- ✅ User can update from banner
- ✅ Banner doesn't block app usage

**Testing**:
- Test optional upgrade banner appears
- Test banner can be dismissed
- Test upgrade action from banner
- Test banner doesn't block app

---

### Task 5: Create Changelog Display Service and UI

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Create service and UI to display changelog (version history and changes).

**Files to Create/Modify**:
- `lib/core/services/changelog_service.dart` (new file)
- `lib/app/pages/settings/changelog_page.dart` (new file)
- `lib/core/controllers/changelog_controller.dart` (new file)

**Dependencies**:
- Task 2 (RemoteVersionService)

**Implementation Steps**:

1. **Create ChangelogService**:
   ```dart
   // lib/core/services/changelog_service.dart
   import 'package:get/get.dart';
   import 'remote_version_service.dart';
   import 'storage_service.dart';
   
   class ChangelogService {
     factory ChangelogService() => _instance ??= ChangelogService._();
     ChangelogService._();
     static ChangelogService? _instance;
     
     final RemoteVersionService _remoteVersionService = Get.find<RemoteVersionService>();
     final StorageService _storage = StorageService();
     
     static const String _changelogCacheKey = 'changelog_cache';
     
     /// Get changelog
     Future<List<ChangelogEntry>> getChangelog() async {
       try {
         // Try to get from remote
         final remoteChangelog = _remoteVersionService.getChangelog();
         
         if (remoteChangelog.isNotEmpty) {
           // Cache changelog
           await _cacheChangelog(remoteChangelog);
           return _parseChangelog(remoteChangelog);
         }
         
         // Fallback to cached changelog
         final cachedChangelog = _getCachedChangelog();
         if (cachedChangelog.isNotEmpty) {
           return _parseChangelog(cachedChangelog);
         }
         
         // Return default changelog
         return _getDefaultChangelog();
       } catch (e) {
         Get.log('ERROR: Failed to get changelog: $e');
         return _getDefaultChangelog();
       }
     }
     
     List<ChangelogEntry> _parseChangelog(List<Map<String, dynamic>> changelogData) {
       return changelogData.map((item) {
         return ChangelogEntry(
           version: item['version']?.toString() ?? '',
           releaseDate: item['releaseDate'] != null
               ? DateTime.parse(item['releaseDate'] as String)
               : DateTime.now(),
           changes: (item['changes'] as List?)?.map((c) => c.toString()).toList() ?? [],
           categories: item['categories'] != null
               ? Map<String, List<String>>.from(item['categories'] as Map)
               : {},
         );
       }).toList();
     }
     
     Future<void> _cacheChangelog(List<Map<String, dynamic>> changelog) async {
       try {
         await _storage.setString(_changelogCacheKey, jsonEncode(changelog));
       } catch (e) {
         Get.log('ERROR: Failed to cache changelog: $e');
       }
     }
     
     List<Map<String, dynamic>> _getCachedChangelog() {
       try {
         final cached = _storage.getString(_changelogCacheKey);
         if (cached != null && cached.isNotEmpty) {
           return (jsonDecode(cached) as List).map((item) => Map<String, dynamic>.from(item as Map)).toList();
         }
       } catch (e) {
         Get.log('ERROR: Failed to get cached changelog: $e');
       }
       return [];
     }
     
     List<ChangelogEntry> _getDefaultChangelog() {
       return [
         ChangelogEntry(
           version: '1.0.0',
           releaseDate: DateTime.now(),
           changes: ['Initial release'],
           categories: {},
         ),
       ];
     }
   }
   
   class ChangelogEntry {
     final String version;
     final DateTime releaseDate;
     final List<String> changes;
     final Map<String, List<String>> categories; // e.g., {'New Features': [...], 'Bug Fixes': [...]}
     
     ChangelogEntry({
       required this.version,
       required this.releaseDate,
       required this.changes,
       required this.categories,
     });
   }
   ```

2. **Create ChangelogController**:
   ```dart
   // lib/core/controllers/changelog_controller.dart
   import 'package:get/get.dart';
   import '../services/changelog_service.dart';
   
   class ChangelogController extends GetxController {
     final ChangelogService _changelogService = ChangelogService();
     
     final RxList<ChangelogEntry> _changelog = <ChangelogEntry>[].obs;
     final RxBool _isLoading = false.obs;
     
     List<ChangelogEntry> get changelog => _changelog;
     bool get isLoading => _isLoading.value;
     
     @override
     void onInit() {
       super.onInit();
       loadChangelog();
     }
     
     Future<void> loadChangelog() async {
       _isLoading.value = true;
       
       try {
         final changelog = await _changelogService.getChangelog();
         _changelog.value = changelog;
       } catch (e) {
         Get.log('ERROR: Failed to load changelog: $e');
       } finally {
         _isLoading.value = false;
       }
     }
   }
   ```

3. **Create ChangelogPage UI**:
   ```dart
   // lib/app/pages/settings/changelog_page.dart
   // Implementation with:
   // - List of changelog entries
   // - Each entry shows version, date, and changes
   // - Changes are categorized (New Features, Bug Fixes, Improvements)
   // - Pull to refresh
   ```

**Expected Results**:
- ✅ ChangelogService exists
- ✅ ChangelogController exists
- ✅ ChangelogPage UI exists
- ✅ Changelog is displayed correctly
- ✅ Changelog is cached for offline access

**Testing**:
- Test changelog loading
- Test changelog display
- Test changelog caching
- Test offline changelog access

---

### Task 6: Create Backend/Schema Compatibility Check Service

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Create service to check backend/schema compatibility to ensure app version is compatible with backend schema.

**Files to Create/Modify**:
- `lib/core/services/schema_compatibility_service.dart` (new file)
- `lib/core/services/firebase_database_service.dart` (add schema version check)

**Dependencies**:
- Task 1 (AppVersionService)
- Firebase Database

**Implementation Steps**:

1. **Create SchemaCompatibilityService**:
   ```dart
   // lib/core/services/schema_compatibility_service.dart
   import 'package:get/get.dart';
   import 'package:firebase_database/firebase_database.dart';
   import 'app_version_service.dart';
   import 'package:version/version.dart';
   
   class SchemaCompatibilityService {
     factory SchemaCompatibilityService() => _instance ??= SchemaCompatibilityService._();
     SchemaCompatibilityService._();
     static SchemaCompatibilityService? _instance;
     
     final AppVersionService _appVersionService = Get.find<AppVersionService>();
     final FirebaseDatabase _database = Get.find<FirebaseDatabase>();
     
     static const String _schemaVersionPath = 'app_config/schema_version';
     static const String _appSchemaVersion = '1.0'; // Current app schema version
     
     /// Check backend/schema compatibility
     Future<CompatibilityResult> checkCompatibility() async {
       try {
         // Get backend schema version from Firebase
         final schemaRef = _database.ref(_schemaVersionPath);
         final snapshot = await schemaRef.get();
         
         if (!snapshot.exists) {
           Get.log('WARNING: Schema version not found in backend');
           // Assume compatible if schema version is not set
           return CompatibilityResult(
             isCompatible: true,
             appSchemaVersion: _appSchemaVersion,
             backendSchemaVersion: null,
             message: 'Schema version not configured in backend',
           );
         }
         
         final backendSchemaVersion = snapshot.value?.toString() ?? '';
         
         if (backendSchemaVersion.isEmpty) {
           return CompatibilityResult(
             isCompatible: true,
             appSchemaVersion: _appSchemaVersion,
             backendSchemaVersion: null,
             message: 'Backend schema version is empty',
           );
         }
         
         // Compare schema versions
         final appVersion = Version.parse(_appSchemaVersion);
         final backendVersion = Version.parse(backendSchemaVersion);
         
         // App schema must be >= backend schema (app can be newer)
         // OR app schema must match backend schema exactly (depending on compatibility policy)
         final isCompatible = appVersion >= backendVersion;
         
         return CompatibilityResult(
           isCompatible: isCompatible,
           appSchemaVersion: _appSchemaVersion,
           backendSchemaVersion: backendSchemaVersion,
           message: isCompatible
               ? 'App schema is compatible with backend'
               : 'App schema (${_appSchemaVersion}) is incompatible with backend schema ($backendSchemaVersion)',
         );
       } catch (e) {
         Get.log('ERROR: Schema compatibility check failed: $e');
         // Fail open - assume compatible if check fails
         return CompatibilityResult(
           isCompatible: true,
           appSchemaVersion: _appSchemaVersion,
           backendSchemaVersion: null,
           message: 'Compatibility check failed: $e',
         );
       }
     }
     
     /// Check compatibility and throw error if incompatible
     Future<void> ensureCompatible() async {
       final result = await checkCompatibility();
       
       if (!result.isCompatible) {
         throw SchemaIncompatibilityException(
           message: result.message,
           appSchemaVersion: result.appSchemaVersion,
           backendSchemaVersion: result.backendSchemaVersion ?? 'unknown',
         );
       }
     }
   }
   
   class CompatibilityResult {
     final bool isCompatible;
     final String appSchemaVersion;
     final String? backendSchemaVersion;
     final String message;
     
     CompatibilityResult({
       required this.isCompatible,
       required this.appSchemaVersion,
       this.backendSchemaVersion,
       required this.message,
     });
   }
   
   class SchemaIncompatibilityException implements Exception {
     final String message;
     final String appSchemaVersion;
     final String backendSchemaVersion;
     
     SchemaIncompatibilityException({
       required this.message,
       required this.appSchemaVersion,
       required this.backendSchemaVersion,
     });
     
     @override
     String toString() => message;
   }
   ```

2. **Integrate compatibility check with app launch**:
   ```dart
   // In lib/app/app.dart
   import 'core/services/schema_compatibility_service.dart';
   
   static Future<void> initialize() async {
     // ... existing initialization ...
     
     // Initialize Schema Compatibility Service
     Get.put(SchemaCompatibilityService());
     
     // Check compatibility
     final compatibilityService = Get.find<SchemaCompatibilityService>();
     try {
       await compatibilityService.ensureCompatible();
       Get.log('Schema compatibility check passed');
     } on SchemaIncompatibilityException catch (e) {
       Get.log('ERROR: Schema incompatibility: $e');
       // Show error or trigger forced upgrade
       // This should be handled by AppVersionController
     }
   }
   ```

**Expected Results**:
- ✅ SchemaCompatibilityService exists
- ✅ Service checks backend schema version
- ✅ Service compares app schema with backend schema
- ✅ Incompatibility is detected and handled
- ✅ Compatibility check is performed on app launch

**Testing**:
- Test compatibility check with compatible schemas
- Test compatibility check with incompatible schemas
- Test compatibility check when backend schema is unavailable
- Test error handling

---

### Task 7: Create App Version Settings Page

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Create UI page to display app version information and provide access to changelog and manual version check.

**Files to Create/Modify**:
- `lib/app/pages/settings/app_version_page.dart` (new file)
- `lib/app/routes/app_router.dart` (add route)

**Dependencies**:
- Task 1 (AppVersionService)
- Task 2 (RemoteVersionService)
- Task 5 (ChangelogService)

**Implementation Steps**:

1. **Create AppVersionPage**:
   ```dart
   // lib/app/pages/settings/app_version_page.dart
   import 'package:flutter/material.dart';
   import 'package:get/get.dart';
   import '../../../core/constants/app_strings.dart';
   import '../../../core/controllers/app_version_controller.dart';
   import '../../../core/services/navigation_service.dart';
   import '../../widgets/td_app_bar.dart';
   import '../../widgets/td_button.dart';
   import 'changelog_page.dart';
   
   class AppVersionPage extends StatelessWidget {
     const AppVersionPage({super.key});
     
     @override
     Widget build(BuildContext context) {
       final controller = Get.find<AppVersionController>();
       
       return Scaffold(
         appBar: TDAppBar(
           title: AppStrings.appVersion,
         ),
         body: GetBuilder<AppVersionController>(
           builder: (controller) => ListView(
             padding: EdgeInsets.all(16),
             children: [
               // App Information
               _buildAppInfoSection(controller),
               SizedBox(height: 24),
               
               // Version Check
               _buildVersionCheckSection(controller),
               SizedBox(height: 24),
               
               // Changelog
               _buildChangelogSection(),
             ],
           ),
         ),
       );
     }
     
     Widget _buildAppInfoSection(AppVersionController controller) {
       final versionInfo = controller.appVersionService.getVersionInfo();
       
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(
             AppStrings.appInformation,
             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
           ),
           SizedBox(height: 16),
           _buildInfoRow(AppStrings.appName, versionInfo['appName'] ?? ''),
           _buildInfoRow(AppStrings.version, versionInfo['version'] ?? ''),
           _buildInfoRow(AppStrings.buildNumber, versionInfo['buildNumber'] ?? ''),
           _buildInfoRow(AppStrings.packageName, versionInfo['packageName'] ?? ''),
         ],
       );
     }
     
     Widget _buildVersionCheckSection(AppVersionController controller) {
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(
             AppStrings.versionCheck,
             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
           ),
           SizedBox(height: 16),
           TDButton(
             text: AppStrings.checkForUpdates,
             onPressed: controller.isCheckingVersion ? null : () => controller.checkVersion(),
           ),
           if (controller.isCheckingVersion)
             Padding(
               padding: EdgeInsets.all(16),
               child: CircularProgressIndicator(),
             ),
           if (controller.versionCheckResult != null) ...[
             SizedBox(height: 16),
             _buildVersionCheckResult(controller.versionCheckResult!),
           ],
         ],
       );
     }
     
     Widget _buildChangelogSection() {
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(
             AppStrings.changelog,
             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
           ),
           SizedBox(height: 16),
           TDButton(
             text: AppStrings.viewChangelog,
             onPressed: () => NavigationService().toNamed<void>(AppRoutes.changelog),
           ),
         ],
       );
     }
     
     Widget _buildInfoRow(String label, String value) {
       return Padding(
         padding: EdgeInsets.symmetric(vertical: 8),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text(label),
             Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
           ],
         ),
       );
     }
     
     Widget _buildVersionCheckResult(VersionCheckResult result) {
       if (result.updateRequired) {
         return Column(
           children: [
             Text(
               result.isForced ? AppStrings.updateRequired : AppStrings.updateAvailable,
               style: TextStyle(
                 color: result.isForced ? Colors.red : Colors.orange,
                 fontWeight: FontWeight.bold,
               ),
             ),
             SizedBox(height: 8),
             Text('${AppStrings.currentVersion}: ${result.currentVersion}'),
             Text('${AppStrings.latestVersion}: ${result.latestVersion}'),
             SizedBox(height: 16),
             TDButton(
               text: AppStrings.updateNow,
               onPressed: () => controller.openAppStore(),
             ),
           ],
         );
       } else {
         return Text(
           AppStrings.appIsUpToDate,
           style: TextStyle(color: Colors.green),
         );
       }
     }
   }
   ```

2. **Add AppStrings constants**:
   ```dart
   // In app_strings.dart
   static const String appVersion = 'App Version';
   static const String appInformation = 'App Information';
   static const String versionCheck = 'Version Check';
   static const String checkForUpdates = 'Check for Updates';
   static const String viewChangelog = 'View Changelog';
   static const String updateAvailable = 'Update Available';
   static const String appIsUpToDate = 'App is up to date';
   ```

**Expected Results**:
- ✅ AppVersionPage exists
- ✅ Page displays app version information
- ✅ Page allows manual version check
- ✅ Page provides access to changelog
- ✅ Page is user-friendly

**Testing**:
- Test app version display
- Test manual version check
- Test changelog navigation
- Verify UI is user-friendly

---

## Summary

### Implementation Order:
1. **Task 1**: Add package info dependency and create app version service
2. **Task 2**: Create remote version check service
3. **Task 6**: Create backend/schema compatibility check service
4. **Task 3**: Create forced upgrade dialog and gate
5. **Task 4**: Create optional upgrade notification
6. **Task 5**: Create changelog display service and UI
7. **Task 7**: Create app version settings page

### Estimated Total Time: 18-24 hours

### Dependencies:
- Task 1 is independent
- Task 2 depends on Task 1
- Task 3 depends on Tasks 1 and 2
- Task 4 depends on Tasks 2 and 3
- Task 5 depends on Task 2
- Task 6 is independent (but should be integrated with Task 3)
- Task 7 depends on Tasks 1, 2, and 5

### Testing Requirements:
- Unit tests for version services
- Unit tests for compatibility service
- Unit tests for version comparison
- Integration tests for version check on app launch
- Integration tests for forced upgrade flow
- Manual testing for UI components

### Success Criteria:
- ✅ App version is displayed
- ✅ Changelog is displayed
- ✅ Forced upgrade is detected and blocks app
- ✅ Optional upgrade is detected and notifies user
- ✅ Backend/schema compatibility is checked
- ✅ Version check is performed on app launch
- ✅ App store integration works correctly

### Security and Reliability Considerations:
- **Critical**: Forced upgrade must work correctly to ensure security
- Version checks should not break app if service is unavailable
- Compatibility checks must be accurate
- App store integration must work for both Android and iOS
- Version information should be cached for offline scenarios
- Schema compatibility must be checked to prevent data corruption

