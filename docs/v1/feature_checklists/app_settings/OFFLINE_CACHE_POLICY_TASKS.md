# Offline Cache Policy: Cache Size, Auto-Clear - Task List & Implementation Steps

## Overview
This document lists all tasks required to implement the **Offline Cache Policy** feature. Currently, this feature is **MISSING** - Not implemented. This feature should include: cache size calculation and display, cache auto-clear policy configuration, manual cache clearing, cache size limits, and cache cleanup scheduling.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `StorageService` - has `getStorageSize()` method (approximate calculation)
- ✅ Hive boxes: `userBox`, `settingsBox`, `tasksBox`, `reportsBox`
- ✅ SharedPreferences for app settings
- ✅ `PaginationService` - has cache clearing methods
- ✅ `clearAllData()` method in StorageService

### What's Missing/Broken:
- ⛔ Accurate cache size calculation (current is approximate)
- ⛔ Cache size breakdown by category
- ⛔ Cache auto-clear policy
- ⛔ Automatic cache cleanup
- ⛔ Manual cache clear UI
- ⛔ Selective cache clear (by category)
- ⛔ Cache size limit setting
- ⛔ Cache cleanup scheduling
- ⛔ Cache policy persistence
- ⛔ Cache size warning

---

## Task List

### Task 1: Create Cache Size Calculation Service

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Create service to accurately calculate cache size for all storage types (Hive boxes, SharedPreferences, pagination cache, etc.).

**Files to Create/Modify**:
- `lib/core/services/cache_size_service.dart` (new file)
- `lib/core/services/storage_service.dart` (enhance getStorageSize method)

**Dependencies**:
- StorageService
- PaginationService

**Implementation Steps**:

1. **Create CacheSizeService**:
   ```dart
   // lib/core/services/cache_size_service.dart
   import 'package:get/get.dart';
   import 'package:shared_preferences/shared_preferences.dart';
   import 'package:hive_flutter/hive_flutter.dart';
   import 'package:path_provider/path_provider.dart';
   import 'dart:io';
   import 'storage_service.dart';
   import 'pagination_service.dart';
   
   class CacheSizeService {
     factory CacheSizeService() => _instance ??= CacheSizeService._();
     CacheSizeService._();
     static CacheSizeService? _instance;
     
     final StorageService _storageService = Get.find<StorageService>();
     final PaginationService _paginationService = Get.find<PaginationService>();
     
     /// Get total cache size in bytes
     Future<int> getTotalCacheSize() async {
       try {
         int totalSize = 0;
         
         // Hive boxes size
         totalSize += await _getHiveBoxSize('user_box');
         totalSize += await _getHiveBoxSize('settings_box');
         totalSize += await _getHiveBoxSize('tasks_box');
         totalSize += await _getHiveBoxSize('reports_box');
         
         // SharedPreferences size
         totalSize += await _getSharedPreferencesSize();
         
         // Pagination cache size
         totalSize += await _getPaginationCacheSize();
         
         // Image cache size (if applicable)
         totalSize += await _getImageCacheSize();
         
         return totalSize;
       } catch (e) {
         Get.log('ERROR: Failed to calculate cache size: $e');
         return 0;
       }
     }
     
     /// Get cache size breakdown by category
     Future<Map<String, int>> getCacheSizeBreakdown() async {
       try {
         return {
           'userData': await _getHiveBoxSize('user_box'),
           'settings': await _getHiveBoxSize('settings_box'),
           'tasks': await _getHiveBoxSize('tasks_box'),
           'reports': await _getHiveBoxSize('reports_box'),
           'sharedPreferences': await _getSharedPreferencesSize(),
           'pagination': await _getPaginationCacheSize(),
           'images': await _getImageCacheSize(),
         };
       } catch (e) {
         Get.log('ERROR: Failed to get cache breakdown: $e');
         return {};
       }
     }
     
     /// Get Hive box size
     Future<int> _getHiveBoxSize(String boxName) async {
       try {
         final directory = await getApplicationDocumentsDirectory();
         final boxPath = '${directory.path}/$boxName.hive';
         final boxLockPath = '${directory.path}/$boxName.lock';
         
         int size = 0;
         
         final boxFile = File(boxPath);
         if (await boxFile.exists()) {
           size += await boxFile.length();
         }
         
         final lockFile = File(boxLockPath);
         if (await lockFile.exists()) {
           size += await lockFile.length();
         }
         
         return size;
       } catch (e) {
         Get.log('ERROR: Failed to get Hive box size for $boxName: $e');
         return 0;
       }
     }
     
     /// Get SharedPreferences size
     Future<int> _getSharedPreferencesSize() async {
       try {
         final prefs = await SharedPreferences.getInstance();
         int size = 0;
         
         for (final key in prefs.getKeys()) {
           final value = prefs.get(key);
           if (value is String) {
             size += key.length + value.length;
           } else if (value is List<String>) {
             size += key.length;
             for (final item in value) {
               size += item.length;
             }
           }
         }
         
         return size;
       } catch (e) {
         Get.log('ERROR: Failed to get SharedPreferences size: $e');
         return 0;
       }
     }
     
     /// Get pagination cache size
     Future<int> _getPaginationCacheSize() async {
       try {
         // Get all pagination cache keys from StorageService
         // This is approximate as we need to track cache keys
         // For now, estimate based on user data box
         return 0; // TODO: Implement accurate pagination cache size
       } catch (e) {
         Get.log('ERROR: Failed to get pagination cache size: $e');
         return 0;
       }
     }
     
     /// Get image cache size
     Future<int> _getImageCacheSize() async {
       try {
         // Get cached network images size
         final directory = await getTemporaryDirectory();
         final cacheDir = Directory('${directory.path}/image_cache');
         
         if (!await cacheDir.exists()) {
           return 0;
         }
         
         int size = 0;
         await for (final entity in cacheDir.list(recursive: true)) {
           if (entity is File) {
             size += await entity.length();
           }
         }
         
         return size;
       } catch (e) {
         Get.log('ERROR: Failed to get image cache size: $e');
         return 0;
       }
     }
     
     /// Format bytes to human-readable string
     String formatBytes(int bytes) {
       if (bytes < 1024) {
         return '$bytes B';
       } else if (bytes < 1024 * 1024) {
         return '${(bytes / 1024).toStringAsFixed(2)} KB';
       } else if (bytes < 1024 * 1024 * 1024) {
         return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
       } else {
         return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
       }
     }
   }
   ```

2. **Initialize CacheSizeService in app.dart**:
   ```dart
   // In lib/app/app.dart
   import 'core/services/cache_size_service.dart';
   
   static Future<void> initialize() async {
     // ... existing initialization ...
     
     // Initialize Cache Size Service
     Get.put(CacheSizeService());
   }
   ```

**Expected Results**:
- ✅ CacheSizeService exists
- ✅ Service can calculate total cache size accurately
- ✅ Service can get cache size breakdown by category
- ✅ Service formats bytes to human-readable strings
- ✅ Service is initialized in app.dart

**Testing**:
- Test total cache size calculation
- Test cache size breakdown
- Test formatBytes method
- Test with different cache sizes
- Test accuracy of calculations

---

### Task 2: Create Cache Policy Service

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Create service to manage cache policy settings (auto-clear interval, size limit, cleanup schedule).

**Files to Create/Modify**:
- `lib/core/services/cache_policy_service.dart` (new file)
- `lib/core/services/storage_service.dart` (add cache policy storage methods)

**Dependencies**:
- Task 1 (CacheSizeService)
- StorageService

**Implementation Steps**:

1. **Create CachePolicyService**:
   ```dart
   // lib/core/services/cache_policy_service.dart
   import 'package:get/get.dart';
   import 'storage_service.dart';
   import 'cache_size_service.dart';
   
   enum CacheAutoClearInterval {
     never,
     daily,
     weekly,
     monthly,
   }
   
   enum CacheCleanupSchedule {
     never,
     daily,
     weekly,
     monthly,
     onAppLaunch,
   }
   
   class CachePolicy {
     final bool autoClearEnabled;
     final CacheAutoClearInterval autoClearInterval;
     final int? maxCacheSizeMB; // null = unlimited
     final CacheCleanupSchedule cleanupSchedule;
     final int? cleanupHour; // 0-23, null = default (2 AM)
     
     CachePolicy({
       this.autoClearEnabled = false,
       this.autoClearInterval = CacheAutoClearInterval.never,
       this.maxCacheSizeMB,
       this.cleanupSchedule = CacheCleanupSchedule.never,
       this.cleanupHour,
     });
     
     Map<String, dynamic> toMap() {
       return {
         'autoClearEnabled': autoClearEnabled,
         'autoClearInterval': autoClearInterval.name,
         'maxCacheSizeMB': maxCacheSizeMB,
         'cleanupSchedule': cleanupSchedule.name,
         'cleanupHour': cleanupHour,
       };
     }
     
     factory CachePolicy.fromMap(Map<String, dynamic> map) {
       return CachePolicy(
         autoClearEnabled: map['autoClearEnabled'] as bool? ?? false,
         autoClearInterval: CacheAutoClearInterval.values.firstWhere(
           (e) => e.name == map['autoClearInterval'],
           orElse: () => CacheAutoClearInterval.never,
         ),
         maxCacheSizeMB: map['maxCacheSizeMB'] as int?,
         cleanupSchedule: CacheCleanupSchedule.values.firstWhere(
           (e) => e.name == map['cleanupSchedule'],
           orElse: () => CacheCleanupSchedule.never,
         ),
         cleanupHour: map['cleanupHour'] as int?,
       );
     }
   }
   
   class CachePolicyService {
     factory CachePolicyService() => _instance ??= CachePolicyService._();
     CachePolicyService._();
     static CachePolicyService? _instance;
     
     final StorageService _storage = StorageService();
     final CacheSizeService _cacheSizeService = Get.find<CacheSizeService>();
     
     static const String _policyKey = 'cache_policy';
     
     /// Get current cache policy
     CachePolicy getPolicy() {
       try {
         final policyMap = _storage.getSetting<Map<String, dynamic>>(_policyKey);
         if (policyMap != null) {
           return CachePolicy.fromMap(policyMap);
         }
         return CachePolicy(); // Default policy
       } catch (e) {
         Get.log('ERROR: Failed to get cache policy: $e');
         return CachePolicy();
       }
     }
     
     /// Set cache policy
     Future<void> setPolicy(CachePolicy policy) async {
       try {
         await _storage.setSetting(_policyKey, policy.toMap());
       } catch (e) {
         Get.log('ERROR: Failed to set cache policy: $e');
         throw Exception('Failed to set cache policy: $e');
       }
     }
     
     /// Check if cache size exceeds limit
     Future<bool> isCacheSizeExceeded() async {
       final policy = getPolicy();
       if (policy.maxCacheSizeMB == null) {
         return false; // Unlimited
       }
       
       final totalSize = await _cacheSizeService.getTotalCacheSize();
       final maxSizeBytes = policy.maxCacheSizeMB! * 1024 * 1024;
       
       return totalSize > maxSizeBytes;
     }
     
     /// Get cache size limit in bytes
     int? getCacheSizeLimitBytes() {
       final policy = getPolicy();
       if (policy.maxCacheSizeMB == null) {
         return null; // Unlimited
       }
       return policy.maxCacheSizeMB! * 1024 * 1024;
     }
   }
   ```

2. **Initialize CachePolicyService in app.dart**:
   ```dart
   // In lib/app/app.dart
   import 'core/services/cache_policy_service.dart';
   
   static Future<void> initialize() async {
     // ... existing initialization ...
     
     // Initialize Cache Policy Service
     Get.put(CachePolicyService());
   }
   ```

**Expected Results**:
- ✅ CachePolicyService exists
- ✅ Service can get/set cache policy
- ✅ Service can check if cache size exceeds limit
- ✅ Policy persists in storage
- ✅ Service is initialized in app.dart

**Testing**:
- Test get/set policy
- Test policy persistence
- Test cache size limit checking
- Test policy validation

---

### Task 3: Create Cache Cleanup Service

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 4-5 hours

**Description**:
Create service to perform cache cleanup (clear all cache, clear by category, auto-clear based on policy).

**Files to Create/Modify**:
- `lib/core/services/cache_cleanup_service.dart` (new file)
- `lib/core/services/storage_service.dart` (add cache cleanup methods)

**Dependencies**:
- Task 1 (CacheSizeService)
- Task 2 (CachePolicyService)
- StorageService
- PaginationService

**Implementation Steps**:

1. **Create CacheCleanupService**:
   ```dart
   // lib/core/services/cache_cleanup_service.dart
   import 'package:get/get.dart';
   import 'storage_service.dart';
   import 'cache_size_service.dart';
   import 'cache_policy_service.dart';
   import 'pagination_service.dart';
   import 'package:path_provider/path_provider.dart';
   import 'dart:io';
   
   enum CacheCategory {
     all,
     userData,
     settings,
     tasks,
     reports,
     sharedPreferences,
     pagination,
     images,
   }
   
   class CacheCleanupResult {
     final bool success;
     final int bytesCleared;
       final String? error;
     
     CacheCleanupResult({
       required this.success,
       required this.bytesCleared,
       this.error,
     });
   }
   
   class CacheCleanupService {
     factory CacheCleanupService() => _instance ??= CacheCleanupService._();
     CacheCleanupService._();
     static CacheCleanupService? _instance;
     
     final StorageService _storageService = Get.find<StorageService>();
     final CacheSizeService _cacheSizeService = Get.find<CacheSizeService>();
     final CachePolicyService _policyService = Get.find<CachePolicyService>();
     final PaginationService _paginationService = Get.find<PaginationService>();
     
     /// Clear all cache
     Future<CacheCleanupResult> clearAllCache() async {
       try {
         final sizeBefore = await _cacheSizeService.getTotalCacheSize();
         
         // Clear Hive boxes
         await _storageService.clearUserData();
         await _storageService.clearSettings();
         await _storageService.clearTasks();
         await _storageService.clearReports();
         
         // Clear SharedPreferences (except critical data)
         await _clearSharedPreferencesSelective();
         
         // Clear pagination cache
         await _clearPaginationCache();
         
         // Clear image cache
         await _clearImageCache();
         
         final sizeAfter = await _cacheSizeService.getTotalCacheSize();
         final bytesCleared = sizeBefore - sizeAfter;
         
         return CacheCleanupResult(
           success: true,
           bytesCleared: bytesCleared,
         );
       } catch (e) {
         Get.log('ERROR: Failed to clear all cache: $e');
         return CacheCleanupResult(
           success: false,
           bytesCleared: 0,
           error: 'Failed to clear cache: $e',
         );
       }
     }
     
     /// Clear cache by category
     Future<CacheCleanupResult> clearCacheByCategory(CacheCategory category) async {
       try {
         final sizeBefore = await _cacheSizeService.getTotalCacheSize();
         
         switch (category) {
           case CacheCategory.userData:
             await _storageService.clearUserData();
             break;
           case CacheCategory.settings:
             await _storageService.clearSettings();
             break;
           case CacheCategory.tasks:
             await _storageService.clearTasks();
             break;
           case CacheCategory.reports:
             await _storageService.clearReports();
             break;
           case CacheCategory.sharedPreferences:
             await _clearSharedPreferencesSelective();
             break;
           case CacheCategory.pagination:
             await _clearPaginationCache();
             break;
           case CacheCategory.images:
             await _clearImageCache();
             break;
           case CacheCategory.all:
             return await clearAllCache();
         }
         
         final sizeAfter = await _cacheSizeService.getTotalCacheSize();
         final bytesCleared = sizeBefore - sizeAfter;
         
         return CacheCleanupResult(
           success: true,
           bytesCleared: bytesCleared,
         );
       } catch (e) {
         Get.log('ERROR: Failed to clear cache by category: $e');
         return CacheCleanupResult(
           success: false,
           bytesCleared: 0,
           error: 'Failed to clear cache: $e',
         );
       }
     }
     
     /// Auto-clear cache based on policy
     Future<CacheCleanupResult> autoClearCache() async {
       try {
         final policy = _policyService.getPolicy();
         
         if (!policy.autoClearEnabled) {
           return CacheCleanupResult(
             success: true,
             bytesCleared: 0,
           );
         }
         
         // Check if cache size exceeds limit
         final exceedsLimit = await _policyService.isCacheSizeExceeded();
         if (exceedsLimit) {
           // Clear oldest cache or reduce to limit
           return await _clearCacheToLimit();
         }
         
         // Clear based on interval (old cache)
         return await _clearOldCache();
       } catch (e) {
         Get.log('ERROR: Failed to auto-clear cache: $e');
         return CacheCleanupResult(
           success: false,
           bytesCleared: 0,
           error: 'Failed to auto-clear cache: $e',
         );
       }
     }
     
     /// Clear cache to size limit
     Future<CacheCleanupResult> _clearCacheToLimit() async {
       try {
         final policy = _policyService.getPolicy();
         final limitBytes = _policyService.getCacheSizeLimitBytes();
         
         if (limitBytes == null) {
           return CacheCleanupResult(success: true, bytesCleared: 0);
         }
         
         final currentSize = await _cacheSizeService.getTotalCacheSize();
         if (currentSize <= limitBytes) {
           return CacheCleanupResult(success: true, bytesCleared: 0);
         }
         
         // Clear oldest cache first (pagination, then reports, then tasks)
         int bytesCleared = 0;
         
         // Clear pagination cache
         final paginationSize = await _cacheSizeService.getCacheSizeBreakdown();
         if (paginationSize['pagination'] != null && paginationSize['pagination']! > 0) {
           final result = await clearCacheByCategory(CacheCategory.pagination);
           bytesCleared += result.bytesCleared;
         }
         
         // Check if still exceeds limit
         final newSize = await _cacheSizeService.getTotalCacheSize();
         if (newSize > limitBytes) {
           // Clear reports cache
           final result = await clearCacheByCategory(CacheCategory.reports);
           bytesCleared += result.bytesCleared;
         }
         
         return CacheCleanupResult(
           success: true,
           bytesCleared: bytesCleared,
         );
       } catch (e) {
         Get.log('ERROR: Failed to clear cache to limit: $e');
         return CacheCleanupResult(
           success: false,
           bytesCleared: 0,
           error: 'Failed to clear cache to limit: $e',
         );
       }
     }
     
     /// Clear old cache
     Future<CacheCleanupResult> _clearOldCache() async {
       // Clear pagination cache (oldest, least critical)
       return await clearCacheByCategory(CacheCategory.pagination);
     }
     
     /// Clear SharedPreferences selectively (keep critical data)
     Future<void> _clearSharedPreferencesSelective() async {
       // Keep critical keys: user_token, user_id, workspace_id, etc.
       final criticalKeys = [
         'user_token',
         'user_id',
         'workspace_id',
         'user_role',
         'theme_mode',
         'language',
       ];
       
       // This would require access to SharedPreferences keys
       // For now, clear non-critical data manually
       // TODO: Implement selective clearing
     }
     
     /// Clear pagination cache
     Future<void> _clearPaginationCache() async {
       // Clear all pagination cache
       // This requires tracking all pagination cache keys
       // TODO: Implement pagination cache clearing
     }
     
     /// Clear image cache
     Future<void> _clearImageCache() async {
       try {
         final directory = await getTemporaryDirectory();
         final cacheDir = Directory('${directory.path}/image_cache');
         
         if (await cacheDir.exists()) {
           await cacheDir.delete(recursive: true);
         }
       } catch (e) {
         Get.log('ERROR: Failed to clear image cache: $e');
       }
     }
   }
   ```

2. **Initialize CacheCleanupService in app.dart**:
   ```dart
   // In lib/app/app.dart
   import 'core/services/cache_cleanup_service.dart';
   
   static Future<void> initialize() async {
     // ... existing initialization ...
     
     // Initialize Cache Cleanup Service
     Get.put(CacheCleanupService());
   }
   ```

**Expected Results**:
- ✅ CacheCleanupService exists
- ✅ Service can clear all cache
- ✅ Service can clear cache by category
- ✅ Service can auto-clear cache based on policy
- ✅ Service can clear cache to size limit
- ✅ Service is initialized in app.dart

**Testing**:
- Test clear all cache
- Test clear cache by category
- Test auto-clear cache
- Test clear cache to limit
- Test error handling

---

### Task 4: Create Cache Settings Controller

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Create GetX controller to manage cache settings UI state and operations.

**Files to Create/Modify**:
- `lib/core/controllers/cache_settings_controller.dart` (new file)

**Dependencies**:
- Task 1 (CacheSizeService)
- Task 2 (CachePolicyService)
- Task 3 (CacheCleanupService)

**Implementation Steps**:

1. **Create CacheSettingsController**:
   ```dart
   // lib/core/controllers/cache_settings_controller.dart
   import 'package:get/get.dart';
   import '../services/cache_size_service.dart';
   import '../services/cache_policy_service.dart';
   import '../services/cache_cleanup_service.dart';
   import '../services/snackbar_service.dart';
   import '../constants/app_strings_en.dart';
   
   class CacheSettingsController extends GetxController {
     final CacheSizeService _cacheSizeService = Get.find<CacheSizeService>();
     final CachePolicyService _policyService = Get.find<CachePolicyService>();
     final CacheCleanupService _cleanupService = Get.find<CacheCleanupService>();
     
     final RxInt _totalCacheSize = 0.obs;
     final RxMap<String, int> _cacheBreakdown = <String, int>{}.obs;
     final Rx<CachePolicy> _policy = CachePolicy().obs;
     final RxBool _isLoading = false.obs;
     final RxBool _isClearing = false.obs;
     
     int get totalCacheSize => _totalCacheSize.value;
     Map<String, int> get cacheBreakdown => _cacheBreakdown.value;
     CachePolicy get policy => _policy.value;
     bool get isLoading => _isLoading.value;
     bool get isClearing => _isClearing.value;
     
     String getFormattedCacheSize() {
       return _cacheSizeService.formatBytes(_totalCacheSize.value);
     }
     
     String getFormattedCategorySize(String category) {
       final size = _cacheBreakdown[category] ?? 0;
       return _cacheSizeService.formatBytes(size);
     }
     
     @override
     void onInit() {
       super.onInit();
       _loadCacheSize();
       _loadPolicy();
     }
     
     Future<void> _loadCacheSize() async {
       _isLoading.value = true;
       try {
         final totalSize = await _cacheSizeService.getTotalCacheSize();
         final breakdown = await _cacheSizeService.getCacheSizeBreakdown();
         
         _totalCacheSize.value = totalSize;
         _cacheBreakdown.value = breakdown;
       } catch (e) {
         Get.log('ERROR: Failed to load cache size: $e');
       } finally {
         _isLoading.value = false;
       }
     }
     
     Future<void> _loadPolicy() async {
       try {
         _policy.value = _policyService.getPolicy();
       } catch (e) {
         Get.log('ERROR: Failed to load cache policy: $e');
       }
     }
     
     Future<void> refreshCacheSize() async {
       await _loadCacheSize();
     }
     
     Future<void> setPolicy(CachePolicy newPolicy) async {
       _isLoading.value = true;
       try {
         await _policyService.setPolicy(newPolicy);
         _policy.value = newPolicy;
         SnackbarService().showSuccess(
           title: AppStrings.I.success,
           message: AppStrings.I.cachePolicyUpdated,
         );
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.I.error,
           message: 'Failed to update cache policy: $e',
         );
       } finally {
         _isLoading.value = false;
       }
     }
     
     Future<void> clearAllCache() async {
       _isClearing.value = true;
       try {
         final result = await _cleanupService.clearAllCache();
         
         if (result.success) {
           await _loadCacheSize();
           SnackbarService().showSuccess(
             title: AppStrings.I.success,
             message: '${AppStrings.cacheCleared}: ${_cacheSizeService.formatBytes(result.bytesCleared)}',
           );
         } else {
           SnackbarService().showError(
             title: AppStrings.I.error,
             message: result.error ?? 'Failed to clear cache',
           );
         }
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.I.error,
           message: 'Failed to clear cache: $e',
         );
       } finally {
         _isClearing.value = false;
       }
     }
     
     Future<void> clearCacheByCategory(CacheCategory category) async {
       _isClearing.value = true;
       try {
         final result = await _cleanupService.clearCacheByCategory(category);
         
         if (result.success) {
           await _loadCacheSize();
           SnackbarService().showSuccess(
             title: AppStrings.I.success,
             message: '${AppStrings.cacheCleared}: ${_cacheSizeService.formatBytes(result.bytesCleared)}',
           );
         } else {
           SnackbarService().showError(
             title: AppStrings.I.error,
             message: result.error ?? 'Failed to clear cache',
           );
         }
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.I.error,
           message: 'Failed to clear cache: $e',
         );
       } finally {
         _isClearing.value = false;
       }
     }
   }
   ```

2. **Add AppStrings constants**:
   ```dart
   // In app_strings_en.dart
   static const String cachePolicyUpdated = 'Cache policy updated';
   static const String cacheCleared = 'Cache cleared';
   ```

**Expected Results**:
- ✅ CacheSettingsController exists
- ✅ Controller manages cache size and policy state
- ✅ Controller can refresh cache size
- ✅ Controller can set cache policy
- ✅ Controller can clear cache
- ✅ Controller shows success/error messages

**Testing**:
- Test controller initialization
- Test refresh cache size
- Test set policy
- Test clear all cache
- Test clear cache by category
- Test error handling

---

### Task 5: Add Cache Settings Section to AppSettingsPage

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 4-5 hours

**Description**:
Add cache settings section to AppSettingsPage with cache size display, policy configuration, and cache clearing options.

**Files to Modify**:
- `lib/app/pages/settings/app_settings_page.dart`

**Dependencies**:
- Task 4 (CacheSettingsController)

**Implementation Steps**:

1. **Add cache settings section to AppSettingsPage**:
   ```dart
   // In lib/app/pages/settings/app_settings_page.dart
   import '../../../core/controllers/cache_settings_controller.dart';
   import '../../../core/services/cache_cleanup_service.dart';
   
   // Add cache settings section after system settings
   const SizedBox(height: 24),
   _buildCacheSettingsSection(),
   ```

2. **Create cache settings section widget**:
   ```dart
   Widget _buildCacheSettingsSection() {
     final controller = Get.put(CacheSettingsController());
     
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text(
           AppStrings.I.offlineStorage,
           style: Theme.of(context).textTheme.titleLarge,
         ),
         const SizedBox(height: 12),
         
         // Cache Size Display
         GetBuilder<CacheSettingsController>(
           builder: (controller) => Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(
                 '${AppStrings.cacheSize}: ${controller.getFormattedCacheSize()}',
                 style: TextStyle(fontWeight: FontWeight.bold),
               ),
               if (controller.cacheBreakdown.isNotEmpty) ...[
                 const SizedBox(height: 8),
                 ...controller.cacheBreakdown.entries.map((entry) {
                   return Padding(
                     padding: EdgeInsets.only(left: 16),
                     child: Text(
                       '${entry.key}: ${controller.getFormattedCategorySize(entry.key)}',
                     ),
                   );
                 }),
               ],
               const SizedBox(height: 8),
               TextButton.icon(
                 icon: Icon(Icons.refresh),
                 label: Text(AppStrings.refresh),
                 onPressed: controller.isLoading ? null : () => controller.refreshCacheSize(),
               ),
             ],
           ),
         ),
         const SizedBox(height: 16),
         
         // Clear Cache Buttons
         TDButton(
           text: AppStrings.I.clearAllCache,
           onPressed: controller.isClearing ? null : () async {
             final confirmed = await Get.dialog<bool>(
               AlertDialog(
                 title: Text(AppStrings.clearCache),
                 content: Text(AppStrings.clearCacheConfirmation),
                 actions: [
                   TextButton(
                     onPressed: () => Get.back(result: false),
                     child: Text(AppStrings.cancel),
                   ),
                   TextButton(
                     onPressed: () => Get.back(result: true),
                     child: Text(AppStrings.clear),
                   ),
                 ],
               ),
             );
             
             if (confirmed == true) {
               await controller.clearAllCache();
             }
           },
         ),
         const SizedBox(height: 16),
         
         // Cache Policy Settings
         _buildCachePolicySection(controller),
       ],
     );
   }
   
   Widget _buildCachePolicySection(CacheSettingsController controller) {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text(
           AppStrings.I.cachePolicy,
           style: Theme.of(context).textTheme.titleMedium,
         ),
         const SizedBox(height: 12),
         
         // Auto-Clear Toggle
         SwitchListTile(
           title: Text(AppStrings.autoClearCache),
           value: controller.policy.autoClearEnabled,
           onChanged: (value) {
             final newPolicy = controller.policy.copyWith(autoClearEnabled: value);
             controller.setPolicy(newPolicy);
           },
         ),
         
         // Auto-Clear Interval
         if (controller.policy.autoClearEnabled) ...[
           DropdownButtonFormField<CacheAutoClearInterval>(
             value: controller.policy.autoClearInterval,
             decoration: InputDecoration(labelText: AppStrings.I.autoClearInterval),
             items: CacheAutoClearInterval.values.map((interval) {
               return DropdownMenuItem(
                 value: interval,
                 child: Text(_getIntervalDisplayName(interval)),
               );
             }).toList(),
             onChanged: (value) {
               if (value != null) {
                 final newPolicy = controller.policy.copyWith(autoClearInterval: value);
                 controller.setPolicy(newPolicy);
               }
             },
           ),
         ],
         
         // Cache Size Limit
         TextField(
           decoration: InputDecoration(
             labelText: AppStrings.I.maxCacheSizeMB,
             hintText: 'e.g., 500 (leave empty for unlimited)',
           ),
           keyboardType: TextInputType.number,
           onChanged: (value) {
             final limitMB = value.isEmpty ? null : int.tryParse(value);
             final newPolicy = controller.policy.copyWith(maxCacheSizeMB: limitMB);
             controller.setPolicy(newPolicy);
           },
         ),
       ],
     );
   }
   ```

3. **Add AppStrings constants**:
   ```dart
   // In app_strings_en.dart
   static const String offlineStorage = 'Offline Storage';
   static const String cacheSize = 'Cache Size';
   static const String refresh = 'Refresh';
   static const String clearAllCache = 'Clear All Cache';
   static const String clearCache = 'Clear Cache';
   static const String clearCacheConfirmation = 'Are you sure you want to clear all cache? This will remove offline data.';
   static const String cachePolicy = 'Cache Policy';
   static const String autoClearCache = 'Auto-Clear Cache';
   static const String autoClearInterval = 'Auto-Clear Interval';
   static const String maxCacheSizeMB = 'Maximum Cache Size (MB)';
   ```

**Expected Results**:
- ✅ Cache settings section is added to AppSettingsPage
- ✅ Cache size is displayed with breakdown
- ✅ Clear cache buttons are available
- ✅ Cache policy can be configured
- ✅ UI is user-friendly

**Testing**:
- Test cache settings section display
- Test cache size display
- Test clear all cache
- Test cache policy configuration
- Test UI responsiveness

---

### Task 6: Create Cache Auto-Clear Scheduler

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Create scheduler to automatically trigger cache cleanup based on policy (interval, schedule, size limit).

**Files to Create/Modify**:
- `lib/core/services/cache_scheduler_service.dart` (new file)
- `lib/app/app.dart` (initialize scheduler)

**Dependencies**:
- Task 2 (CachePolicyService)
- Task 3 (CacheCleanupService)

**Implementation Steps**:

1. **Create CacheSchedulerService**:
   ```dart
   // lib/core/services/cache_scheduler_service.dart
   import 'package:get/get.dart';
   import 'dart:async';
   import 'cache_policy_service.dart';
   import 'cache_cleanup_service.dart';
   
   class CacheSchedulerService {
     factory CacheSchedulerService() => _instance ??= CacheSchedulerService._();
     CacheSchedulerService._();
     static CacheSchedulerService? _instance;
     
     final CachePolicyService _policyService = Get.find<CachePolicyService>();
     final CacheCleanupService _cleanupService = Get.find<CacheCleanupService>();
     
     Timer? _autoClearTimer;
     Timer? _scheduleTimer;
     
     /// Start cache scheduler
     void startScheduler() {
       _scheduleAutoClear();
       _scheduleCleanup();
     }
     
     /// Stop cache scheduler
     void stopScheduler() {
       _autoClearTimer?.cancel();
       _scheduleTimer?.cancel();
     }
     
     /// Schedule auto-clear based on interval
     void _scheduleAutoClear() {
       final policy = _policyService.getPolicy();
       
       if (!policy.autoClearEnabled || policy.autoClearInterval == CacheAutoClearInterval.never) {
         return;
       }
       
       final interval = _getIntervalDuration(policy.autoClearInterval);
       if (interval == null) return;
       
       _autoClearTimer = Timer.periodic(interval, (timer) async {
         await _cleanupService.autoClearCache();
       });
     }
     
     /// Schedule cleanup based on schedule
     void _scheduleCleanup() {
       final policy = _policyService.getPolicy();
       
       if (policy.cleanupSchedule == CacheCleanupSchedule.never) {
         return;
       }
       
       if (policy.cleanupSchedule == CacheCleanupSchedule.onAppLaunch) {
         // Cleanup on app launch (already handled in app initialization)
         return;
       }
       
       // Schedule daily/weekly/monthly cleanup
       final nextCleanup = _calculateNextCleanupTime(policy);
       final delay = nextCleanup.difference(DateTime.now());
       
       if (delay.isNegative) {
         // Already past, schedule for next interval
         _scheduleNextCleanup(policy);
       } else {
         _scheduleTimer = Timer(delay, () {
           _cleanupService.clearAllCache();
           _scheduleNextCleanup(policy);
         });
       }
     }
     
     Duration? _getIntervalDuration(CacheAutoClearInterval interval) {
       switch (interval) {
         case CacheAutoClearInterval.daily:
           return Duration(days: 1);
         case CacheAutoClearInterval.weekly:
           return Duration(days: 7);
         case CacheAutoClearInterval.monthly:
           return Duration(days: 30);
         case CacheAutoClearInterval.never:
           return null;
       }
     }
     
     DateTime _calculateNextCleanupTime(CachePolicy policy) {
       final now = DateTime.now();
       final hour = policy.cleanupHour ?? 2; // Default 2 AM
       
       switch (policy.cleanupSchedule) {
         case CacheCleanupSchedule.daily:
           var next = DateTime(now.year, now.month, now.day, hour);
           if (next.isBefore(now)) {
             next = next.add(Duration(days: 1));
           }
           return next;
         case CacheCleanupSchedule.weekly:
           // Next week same day
           return now.add(Duration(days: 7));
         case CacheCleanupSchedule.monthly:
           // Next month same day
           return DateTime(now.year, now.month + 1, now.day, hour);
         default:
           return now;
       }
     }
     
     void _scheduleNextCleanup(CachePolicy policy) {
       final nextCleanup = _calculateNextCleanupTime(policy);
       final delay = nextCleanup.difference(DateTime.now());
       
       _scheduleTimer = Timer(delay, () {
         _cleanupService.clearAllCache();
         _scheduleNextCleanup(policy);
       });
     }
   }
   ```

2. **Initialize and start scheduler in app.dart**:
   ```dart
   // In lib/app/app.dart
   import 'core/services/cache_scheduler_service.dart';
   
   static Future<void> initialize() async {
     // ... existing initialization ...
     
     // Initialize Cache Scheduler Service
     final scheduler = Get.put(CacheSchedulerService());
     
     // Start scheduler
     scheduler.startScheduler();
     
     // Check cache size limit on app launch
     final policyService = Get.find<CachePolicyService>();
     final cleanupService = Get.find<CacheCleanupService>();
     if (await policyService.isCacheSizeExceeded()) {
       await cleanupService.autoClearCache();
     }
   }
   ```

**Expected Results**:
- ✅ CacheSchedulerService exists
- ✅ Scheduler can start/stop
- ✅ Auto-clear runs according to interval
- ✅ Scheduled cleanup runs according to schedule
- ✅ Scheduler is initialized and started in app.dart

**Testing**:
- Test scheduler start/stop
- Test auto-clear interval
- Test scheduled cleanup
- Test cache size limit checking on app launch

---

## Summary

### Implementation Order:
1. **Task 1**: Create Cache Size Calculation Service
2. **Task 2**: Create Cache Policy Service
3. **Task 3**: Create Cache Cleanup Service
4. **Task 4**: Create Cache Settings Controller
5. **Task 5**: Add Cache Settings Section to AppSettingsPage
6. **Task 6**: Create Cache Auto-Clear Scheduler

### Estimated Total Time: 19-25 hours

### Dependencies:
- Task 1 is independent
- Task 2 depends on Task 1
- Task 3 depends on Tasks 1 and 2
- Task 4 depends on Tasks 1, 2, and 3
- Task 5 depends on Task 4
- Task 6 depends on Tasks 2 and 3

### Testing Requirements:
- Unit tests for CacheSizeService
- Unit tests for CachePolicyService
- Unit tests for CacheCleanupService
- Unit tests for CacheSettingsController
- Unit tests for CacheSchedulerService
- Widget tests for cache settings UI
- Integration tests for cache cleanup
- Manual testing for cache size calculation

### Success Criteria:
- ✅ Cache size is calculated accurately
- ✅ Cache size is displayed with breakdown
- ✅ Cache policy can be configured
- ✅ Cache can be cleared manually (all or by category)
- ✅ Cache is auto-cleared according to policy
- ✅ Cache size limit is enforced
- ✅ Scheduled cleanup works correctly
- ✅ Policy settings persist after app restart

### Security and Reliability Considerations:
- Cache clearing should not break app functionality
- Cache size calculation should be accurate
- Auto-clear should not remove critical data
- Policy settings should persist reliably
- Cache cleanup should be efficient and non-blocking
- Scheduler should handle errors gracefully

