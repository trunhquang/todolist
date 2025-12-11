# Scheduled Backup to OneDrive/Firebase Storage for Account Holder/Admin - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Scheduled Backup to OneDrive/Firebase Storage for Account Holder/Admin** feature. Currently, this feature is **MISSING** - Not implemented; no backup scheduler/service or role guard.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `BackupService` exists with `startScheduledBackups()` and `runScheduledBackupIfDue()` methods
- ✅ `OneDriveService` exists with `backupAppData()` method
- ✅ `BackupController` exists
- ✅ Firebase Storage bucket is configured in `app_constants.dart`
- ⚠️ `exportDataToOneDrive()` is empty (not implemented)
- ⚠️ `startScheduledBackups()` is called in `app.dart` but calls empty method

### What's Missing/Broken:
- ⛔ No role guard (Account Holder/Admin check)
- ⛔ No Firebase Storage backup service
- ⛔ No backup scheduler configuration UI
- ⛔ No failure notification system
- ⛔ No storage quota checking
- ⛔ No backup progress indicator
- ⛔ No backup file verification
- ⛔ `exportDataToOneDrive()` is empty

---

## Task List

### Task 1: Add Role Guard to BackupService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add role guard to ensure only Account Holder/Admin can access backup functionality.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Implementation Steps**:
1. Inject `AccessControlService`:
   ```dart
   final AccessControlService _accessControlService = Get.find<AccessControlService>();
   ```

2. Add permission check method:
   ```dart
   /// Check if user can perform backup operations
   Future<bool> canPerformBackup(String userId, String workspaceId) async {
     try {
       final userRole = await _accessControlService.getUserRole(
         userId: userId,
         workspaceId: workspaceId,
       );
       
       // Only Account Holder and Admin can backup
       return userRole == WorkspaceRole.accountHolder ||
              userRole == WorkspaceRole.admin;
     } catch (e) {
       Get.log('Failed to check backup permission: $e');
       return false;
     }
   }
   ```

3. Add permission checks to backup methods:
   ```dart
   Future<void> exportDataToOneDrive() async {
     final userId = _storage.getUserId();
     final workspaceId = _storage.getWorkspaceId();
     
     if (userId == null || workspaceId == null) {
       throw const UnknownFailure(message: 'User or workspace not found');
     }
     
     // Check permission
     final canBackup = await canPerformBackup(userId, workspaceId);
     if (!canBackup) {
       throw const PermissionFailure(
         message: 'Only Account Holder and Admin can backup workspace',
       );
     }
     
     // Continue with backup...
   }
   ```

4. Add permission check to scheduled backup:
   ```dart
   Future<void> runScheduledBackupIfDue() async {
     final userId = _storage.getUserId();
     final workspaceId = _storage.getWorkspaceId();
     
     if (userId == null || workspaceId == null) return;
     
     // Check permission before running scheduled backup
     final canBackup = await canPerformBackup(userId, workspaceId);
     if (!canBackup) {
       Get.log('Scheduled backup skipped: user does not have permission');
       return;
     }
     
     // Continue with scheduled backup...
   }
   ```

**Expected Results**:
- ✅ Role guard is implemented
- ✅ Only Account Holder/Admin can backup
- ✅ Permission is checked before backup operations
- ✅ Appropriate error messages are shown

**Test Criteria**:
- Test: Account Holder can backup
- Test: Admin can backup
- Test: Member cannot backup
- Test: Permission check works correctly

---

### Task 2: Implement exportDataToOneDrive() Method

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Implement the `exportDataToOneDrive()` method to export workspace data to OneDrive.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Implementation Steps**:
1. Implement `exportDataToOneDrive()`:
   ```dart
   Future<void> exportDataToOneDrive() async {
     final userId = _storage.getUserId();
     final workspaceId = _storage.getWorkspaceId();
     
     if (userId == null || workspaceId == null) {
       throw const UnknownFailure(message: 'User or workspace not found');
     }
     
     // Check permission
     final canBackup = await canPerformBackup(userId, workspaceId);
     if (!canBackup) {
       throw const PermissionFailure(
         message: 'Only Account Holder and Admin can backup workspace',
       );
     }
     
     try {
       // Collect workspace data
       final backupData = await _collectWorkspaceData(workspaceId);
       
       // Create backup payload
       final payload = <String, dynamic>{
         'workspaceId': workspaceId,
         'exportedAt': DateTime.now().toIso8601String(),
         'type': 'workspace_backup',
         'version': '1.0',
         'data': backupData,
       };
       
       // Upload to OneDrive
       await _oneDrive.backupAppData(payload);
       
       // Update last backup timestamp
       await _storage.setInt(_lastBackupKey, DateTime.now().millisecondsSinceEpoch);
     } catch (e) {
       Get.log('Failed to export data to OneDrive: $e');
       rethrow;
     }
   }
   ```

2. Add `_collectWorkspaceData()` method:
   ```dart
   Future<Map<String, dynamic>> _collectWorkspaceData(String workspaceId) async {
     try {
       // Get tasks (exclude tokens/deviceId)
       final tasks = await _db.listTasks(workspaceId: workspaceId);
       final taskData = tasks.map((task) => task.toMap()).toList();
       
       // Get projects
       final projects = await _db.listProjects(workspaceId: workspaceId);
       final projectData = projects.map((project) => project.toMap()).toList();
       
       // Get workspace settings
       final workspace = await _db.getWorkspace(workspaceId: workspaceId);
       final workspaceData = workspace?.toMap();
       
       // Get members (optional, exclude sensitive data)
       final members = await _db.listWorkspaceMembers(workspaceId: workspaceId);
       final memberData = members.map((member) {
         final map = member.toMap();
         // Exclude tokens/deviceId
         map.remove('fcmToken');
         map.remove('deviceId');
         return map;
       }).toList();
       
       return {
         'tasks': taskData,
         'projects': projectData,
         'workspace': workspaceData,
         'members': memberData,
       };
     } catch (e) {
       Get.log('Failed to collect workspace data: $e');
       rethrow;
     }
   }
   ```

**Expected Results**:
- ✅ `exportDataToOneDrive()` is implemented
- ✅ Workspace data is collected correctly
- ✅ Tokens/deviceId are excluded
- ✅ Backup file is created in OneDrive

**Test Criteria**:
- Test: Backup creates file in OneDrive
- Test: Backup contains workspace data
- Test: Tokens/deviceId are excluded
- Test: Backup file can be restored

---

### Task 3: Create FirebaseStorageBackupService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for backing up data to Firebase Storage.

**Files to Create**:
- `lib/core/services/firebase_storage_backup_service.dart` (new file)

**Implementation Steps**:
1. Add Firebase Storage package to `pubspec.yaml`:
   ```yaml
   dependencies:
     firebase_storage: ^11.5.6
   ```

2. Create `FirebaseStorageBackupService`:
   ```dart
   import 'package:firebase_storage/firebase_storage.dart';
   import 'package:firebase_core/firebase_core.dart';
   import 'dart:convert';
   import 'dart:typed_data';
   
   class FirebaseStorageBackupService extends GetxService {
     final FirebaseStorage _storage = FirebaseStorage.instance;
     
     /// Backup data to Firebase Storage
     Future<String> backupToFirebaseStorage({
       required String workspaceId,
       required Map<String, dynamic> data,
     }) async {
       try {
         // Create backup folder path
         final backupFolder = 'backups/$workspaceId';
         
         // Generate backup file name with timestamp
         final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
         final fileName = 'backup_$timestamp.json';
         final filePath = '$backupFolder/$fileName';
         
         // Convert data to JSON
         final jsonData = jsonEncode(data);
         final fileContent = utf8.encode(jsonData);
         
         // Upload to Firebase Storage
         final ref = _storage.ref(filePath);
         final uploadTask = ref.putData(
           Uint8List.fromList(fileContent),
           SettableMetadata(
             contentType: 'application/json',
             customMetadata: {
               'workspaceId': workspaceId,
               'exportedAt': DateTime.now().toIso8601String(),
               'type': 'workspace_backup',
             },
           ),
         );
         
         // Wait for upload to complete
         final snapshot = await uploadTask;
         final downloadUrl = await snapshot.ref.getDownloadURL();
         
         return downloadUrl;
       } catch (e) {
         Get.log('Failed to backup to Firebase Storage: $e');
         rethrow;
       }
     }
     
     /// List backup files for workspace
     Future<List<Map<String, dynamic>>> listBackups(String workspaceId) async {
       try {
         final backupFolder = 'backups/$workspaceId';
         final ref = _storage.ref(backupFolder);
         final listResult = await ref.listAll();
         
         final backups = <Map<String, dynamic>>[];
         for (final item in listResult.items) {
           final metadata = await item.getMetadata();
           backups.add({
             'name': item.name,
             'path': item.fullPath,
             'size': metadata.size,
             'created': metadata.timeCreated?.toIso8601String(),
             'updated': metadata.updatedTime?.toIso8601String(),
             'downloadUrl': await item.getDownloadURL(),
             'customMetadata': metadata.customMetadata,
           });
         }
         
         return backups;
       } catch (e) {
         Get.log('Failed to list backups: $e');
         rethrow;
       }
     }
     
     /// Download backup file
     Future<Map<String, dynamic>> downloadBackup(String filePath) async {
       try {
         final ref = _storage.ref(filePath);
         final data = await ref.getData();
         
         if (data == null) {
           throw Exception('Failed to download backup file');
         }
         
         final jsonString = utf8.decode(data);
         final backupData = jsonDecode(jsonString) as Map<String, dynamic>;
         
         return backupData;
       } catch (e) {
         Get.log('Failed to download backup: $e');
         rethrow;
       }
     }
     
     /// Delete backup file
     Future<void> deleteBackup(String filePath) async {
       try {
         final ref = _storage.ref(filePath);
         await ref.delete();
       } catch (e) {
         Get.log('Failed to delete backup: $e');
         rethrow;
       }
     }
     
     /// Get storage quota for workspace
     Future<Map<String, dynamic>> getStorageQuota(String workspaceId) async {
       try {
         final backupFolder = 'backups/$workspaceId';
         final ref = _storage.ref(backupFolder);
         final listResult = await ref.listAll();
         
         int totalSize = 0;
         int fileCount = 0;
         
         for (final item in listResult.items) {
           final metadata = await item.getMetadata();
           totalSize += metadata.size ?? 0;
           fileCount++;
         }
         
         // Firebase Storage free tier: 5GB
         const maxStorage = 5 * 1024 * 1024 * 1024; // 5GB in bytes
         
         return {
           'used': totalSize,
           'max': maxStorage,
           'percentage': (totalSize / maxStorage) * 100,
           'fileCount': fileCount,
         };
       } catch (e) {
         Get.log('Failed to get storage quota: $e');
         rethrow;
       }
     }
   }
   ```

**Expected Results**:
- ✅ FirebaseStorageBackupService exists
- ✅ Service can backup to Firebase Storage
- ✅ Service can list/download/delete backups
- ✅ Service can check storage quota

**Test Criteria**:
- Test: Backup to Firebase Storage works
- Test: List backups works
- Test: Download backup works
- Test: Delete backup works
- Test: Storage quota check works

---

### Task 4: Add Backup Destination Selection to BackupService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add support for selecting backup destination (OneDrive or Firebase Storage).

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Implementation Steps**:
1. Add backup destination enum:
   ```dart
   enum BackupDestination {
     oneDrive('onedrive'),
     firebaseStorage('firebase_storage');
     
     const BackupDestination(this.value);
     final String value;
   }
   ```

2. Inject `FirebaseStorageBackupService`:
   ```dart
   final FirebaseStorageBackupService _firebaseStorageBackup = Get.find<FirebaseStorageBackupService>();
   ```

3. Add backup destination configuration:
   ```dart
   BackupDestination? _backupDestination;
   
   BackupDestination? get backupDestination => _backupDestination;
   
   Future<void> setBackupDestination(BackupDestination destination) async {
     _backupDestination = destination;
     await _storage.setString('backup_destination', destination.value);
   }
   
   Future<void> loadBackupDestination() async {
     final destinationValue = _storage.getString('backup_destination');
     if (destinationValue != null) {
       _backupDestination = BackupDestination.values.firstWhere(
         (d) => d.value == destinationValue,
         orElse: () => BackupDestination.oneDrive,
       );
     } else {
       _backupDestination = BackupDestination.oneDrive; // Default
     }
   }
   ```

4. Modify `exportDataToOneDrive()` to support both destinations:
   ```dart
   Future<void> exportDataToBackup() async {
     final userId = _storage.getUserId();
     final workspaceId = _storage.getWorkspaceId();
     
     if (userId == null || workspaceId == null) {
       throw const UnknownFailure(message: 'User or workspace not found');
     }
     
     // Check permission
     final canBackup = await canPerformBackup(userId, workspaceId);
     if (!canBackup) {
       throw const PermissionFailure(
         message: 'Only Account Holder and Admin can backup workspace',
       );
     }
     
     // Load backup destination
     await loadBackupDestination();
     final destination = _backupDestination ?? BackupDestination.oneDrive;
     
     try {
       // Collect workspace data
       final backupData = await _collectWorkspaceData(workspaceId);
       
       // Create backup payload
       final payload = <String, dynamic>{
         'workspaceId': workspaceId,
         'exportedAt': DateTime.now().toIso8601String(),
         'type': 'workspace_backup',
         'version': '1.0',
         'data': backupData,
       };
       
       // Upload to selected destination
       if (destination == BackupDestination.oneDrive) {
         await _oneDrive.backupAppData(payload);
       } else if (destination == BackupDestination.firebaseStorage) {
         await _firebaseStorageBackup.backupToFirebaseStorage(
           workspaceId: workspaceId,
           data: payload,
         );
       }
       
       // Update last backup timestamp
       await _storage.setInt(_lastBackupKey, DateTime.now().millisecondsSinceEpoch);
     } catch (e) {
       Get.log('Failed to export data: $e');
       rethrow;
     }
   }
   
   // Keep old method for backward compatibility
   Future<void> exportDataToOneDrive() async {
     await exportDataToBackup();
   }
   ```

**Expected Results**:
- ✅ Backup destination can be selected
- ✅ Backup works for both OneDrive and Firebase Storage
- ✅ Backup destination is persisted

**Test Criteria**:
- Test: OneDrive backup works
- Test: Firebase Storage backup works
- Test: Destination selection works
- Test: Destination persistence works

---

### Task 5: Add Backup Scheduler Configuration

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add configuration for backup schedule (frequency, time, etc.).

**Files to Create**:
- `lib/features/backup/domain/entities/backup_schedule.dart` (new file)

**Implementation Steps**:
1. Create `BackupSchedule` entity:
   ```dart
   class BackupSchedule {
     final String workspaceId;
     final bool enabled;
     final BackupFrequency frequency;
     final int hour; // 0-23
     final int minute; // 0-59
     final List<int>? daysOfWeek; // 0-6 (Sunday-Saturday), null for daily
     final DateTime? nextBackupTime;
     final DateTime updatedAt;
     final String updatedBy;
     
     const BackupSchedule({
       required this.workspaceId,
       required this.enabled,
       required this.frequency,
       required this.hour,
       required this.minute,
       this.daysOfWeek,
       this.nextBackupTime,
       required this.updatedAt,
       required this.updatedBy,
     });
     
     factory BackupSchedule.fromMap(Map<String, dynamic> map) {
       return BackupSchedule(
         workspaceId: map['workspaceId'] ?? '',
         enabled: map['enabled'] ?? false,
         frequency: BackupFrequency.fromString(map['frequency'] ?? 'daily'),
         hour: map['hour'] ?? 2,
         minute: map['minute'] ?? 0,
         daysOfWeek: map['daysOfWeek'] != null
             ? List<int>.from(map['daysOfWeek'])
             : null,
         nextBackupTime: map['nextBackupTime'] != null
             ? DateTime.fromMillisecondsSinceEpoch(map['nextBackupTime'])
             : null,
         updatedAt: DateTime.fromMillisecondsSinceEpoch(
           map['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch,
         ),
         updatedBy: map['updatedBy'] ?? '',
       );
     }
     
     Map<String, dynamic> toMap() {
       return {
         'workspaceId': workspaceId,
         'enabled': enabled,
         'frequency': frequency.value,
         'hour': hour,
         'minute': minute,
         'daysOfWeek': daysOfWeek,
         'nextBackupTime': nextBackupTime?.millisecondsSinceEpoch,
         'updatedAt': updatedAt.millisecondsSinceEpoch,
         'updatedBy': updatedBy,
       };
     }
     
     DateTime? calculateNextBackupTime() {
       if (!enabled) return null;
       
       final now = DateTime.now();
       var nextBackup = DateTime(now.year, now.month, now.day, hour, minute);
       
       if (nextBackup.isBefore(now)) {
         // If backup time has passed today, move to next occurrence
         if (frequency == BackupFrequency.daily) {
           nextBackup = nextBackup.add(const Duration(days: 1));
         } else if (frequency == BackupFrequency.weekly && daysOfWeek != null) {
           // Find next occurrence in daysOfWeek
           int daysToAdd = 1;
           while (daysToAdd <= 7) {
             final candidate = nextBackup.add(Duration(days: daysToAdd));
             if (daysOfWeek!.contains(candidate.weekday % 7)) {
               nextBackup = candidate;
               break;
             }
             daysToAdd++;
           }
         }
       }
       
       return nextBackup;
     }
   }
   
   enum BackupFrequency {
     daily('daily'),
     weekly('weekly'),
     custom('custom');
     
     const BackupFrequency(this.value);
     final String value;
     
     static BackupFrequency fromString(String value) {
       switch (value.toLowerCase()) {
         case 'daily':
           return BackupFrequency.daily;
         case 'weekly':
           return BackupFrequency.weekly;
         case 'custom':
           return BackupFrequency.custom;
         default:
           return BackupFrequency.daily;
       }
     }
   }
   ```

2. Add schedule management to `BackupService`:
   ```dart
   Future<void> saveBackupSchedule(BackupSchedule schedule) async {
     try {
       await _db.saveBackupSchedule(schedule);
       // Update scheduler if enabled
       if (schedule.enabled) {
         _updateScheduler(schedule);
       } else {
         stopScheduledBackups();
       }
     } catch (e) {
       Get.log('Failed to save backup schedule: $e');
       rethrow;
     }
   }
   
   Future<BackupSchedule?> getBackupSchedule(String workspaceId) async {
     try {
       return await _db.getBackupSchedule(workspaceId: workspaceId);
     } catch (e) {
       Get.log('Failed to get backup schedule: $e');
       return null;
     }
   }
   
   void _updateScheduler(BackupSchedule schedule) {
     stopScheduledBackups();
     
     if (!schedule.enabled) return;
     
     // Calculate next backup time
     final nextBackup = schedule.calculateNextBackupTime();
     if (nextBackup == null) return;
     
     // Calculate delay until next backup
     final delay = nextBackup.difference(DateTime.now());
     if (delay.isNegative) return;
     
     // Start timer for next backup
     _timer = Timer(delay, () async {
       await runScheduledBackupIfDue();
       // Schedule next backup
       _updateScheduler(schedule);
     });
   }
   ```

**Expected Results**:
- ✅ Backup schedule can be configured
- ✅ Schedule supports daily/weekly/custom frequencies
- ✅ Next backup time is calculated correctly
- ✅ Scheduler updates when schedule changes

**Test Criteria**:
- Test: Daily schedule works
- Test: Weekly schedule works
- Test: Custom schedule works
- Test: Next backup time is calculated correctly

---

### Task 6: Add Backup Settings UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add UI for configuring backup settings (destination, schedule, etc.).

**Files to Create**:
- `lib/app/pages/backup/backup_settings_page.dart` (new file)
- `lib/app/pages/backup/controllers/backup_settings_controller.dart` (new file)

**Implementation Steps**:
1. Create `BackupSettingsController`:
   ```dart
   class BackupSettingsController extends GetxController {
     final BackupService _backupService = Get.find<BackupService>();
     final AccessControlService _accessControlService = Get.find<AccessControlService>();
     
     final RxBool isLoading = false.obs;
     final Rx<BackupSchedule?> schedule = Rx<BackupSchedule?>(null);
     final Rx<BackupDestination?> destination = Rx<BackupDestination?>(null);
     final Rx<Map<String, dynamic>?> storageQuota = Rx<Map<String, dynamic>?>(null);
     
     @override
     void onInit() {
       super.onInit();
       _loadSettings();
     }
     
     Future<void> _loadSettings() async {
       isLoading.value = true;
       try {
         final workspaceId = _storageService.getWorkspaceId();
         if (workspaceId != null) {
           schedule.value = await _backupService.getBackupSchedule(workspaceId);
           destination.value = _backupService.backupDestination;
           // Load storage quota if Firebase Storage
           if (destination.value == BackupDestination.firebaseStorage) {
             storageQuota.value = await _firebaseStorageBackup.getStorageQuota(workspaceId);
           }
         }
       } catch (e) {
         Get.log('Failed to load backup settings: $e');
       } finally {
         isLoading.value = false;
       }
     }
     
     Future<void> saveSchedule(BackupSchedule newSchedule) async {
       // Implementation
     }
     
     Future<void> saveDestination(BackupDestination newDestination) async {
       // Implementation
     }
   }
   ```

2. Create `BackupSettingsPage` UI with:
   - Enable/disable scheduled backup toggle
   - Backup destination selection (OneDrive/Firebase Storage)
   - Schedule configuration (frequency, time, days)
   - Storage quota display (for Firebase Storage)
   - Manual backup button
   - Last backup info

3. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Backup settings UI exists
- ✅ Settings can be configured
- ✅ UI uses TD widgets and AppStrings

**Test Criteria**:
- Test: Settings UI works
- Test: Settings are saved correctly
- Test: UI follows project rules

---

### Task 7: Add Failure Notification System

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add notification system for backup failures.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Implementation Steps**:
1. Inject notification service:
   ```dart
   final PushNotificationService _pushService = Get.find<PushNotificationService>();
   final SnackbarService _snackbarService = Get.find<SnackbarService>();
   ```

2. Add failure notification:
   ```dart
   Future<void> _notifyBackupFailure({
     required String workspaceId,
     required String error,
   }) async {
     try {
       // Get Account Holder/Admin users
       final admins = await _db.listWorkspaceMembers(workspaceId: workspaceId);
       final adminUsers = admins.where((member) =>
         member.role == WorkspaceRole.accountHolder ||
         member.role == WorkspaceRole.admin,
       ).toList();
       
       // Send notifications
       for (final admin in adminUsers) {
         await _pushService.sendToUser(
           userId: admin.userId,
           title: AppStrings.backupFailed,
           body: AppStrings.backupFailedMessage(error),
           notificationType: 'backup_failure',
         );
       }
       
       // Show in-app notification
       _snackbarService.showError(
         title: AppStrings.backupFailed,
         message: AppStrings.backupFailedMessage(error),
       );
     } catch (e) {
       Get.log('Failed to send backup failure notification: $e');
     }
   }
   ```

3. Call notification on backup failure:
   ```dart
   Future<void> runScheduledBackupIfDue() async {
     // ... existing code ...
     try {
       await exportDataToBackup();
       await _storage.setInt(_lastBackupKey, now.millisecondsSinceEpoch);
     } catch (e) {
       // Notify on failure
       final workspaceId = _storage.getWorkspaceId();
       if (workspaceId != null) {
         await _notifyBackupFailure(
           workspaceId: workspaceId,
           error: e.toString(),
         );
       }
     }
   }
   ```

**Expected Results**:
- ✅ Failure notification is sent
- ✅ Notification is sent to Account Holder/Admin
- ✅ Multiple notification channels are supported

**Test Criteria**:
- Test: Failure notification is sent
- Test: Notification contains error details
- Test: Notification is sent to correct users

---

### Task 8: Add Storage Quota Checking

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add storage quota checking before backup.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Implementation Steps**:
1. Add quota check method:
   ```dart
   Future<bool> checkStorageQuota(String workspaceId) async {
     try {
       if (_backupDestination == BackupDestination.firebaseStorage) {
         final quota = await _firebaseStorageBackup.getStorageQuota(workspaceId);
         final percentage = quota['percentage'] as double;
         
         // Warn if over 80%
         if (percentage > 80) {
           await _notifyQuotaWarning(workspaceId, percentage);
         }
         
         // Prevent backup if over 95%
         if (percentage > 95) {
           throw const StorageQuotaExceededFailure(
             message: 'Storage quota exceeded. Please free up space.',
           );
         }
       }
       
       return true;
     } catch (e) {
       Get.log('Failed to check storage quota: $e');
       rethrow;
     }
   }
   ```

2. Call quota check before backup:
   ```dart
   Future<void> exportDataToBackup() async {
     // ... existing permission check ...
     
     // Check storage quota
     await checkStorageQuota(workspaceId);
     
     // Continue with backup...
   }
   ```

**Expected Results**:
- ✅ Storage quota is checked
- ✅ Backup is prevented when quota is exceeded
- ✅ Warnings are shown when approaching quota

**Test Criteria**:
- Test: Quota check works
- Test: Backup is prevented when quota exceeded
- Test: Warnings are shown appropriately

---

### Task 9: Add Backup Progress Indicator

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add progress indicator for backup operations.

**Files to Modify**:
- `lib/core/controllers/backup_controller.dart`

**Implementation Steps**:
1. Add progress tracking:
   ```dart
   final RxDouble _backupProgress = 0.0.obs;
   final RxString _backupStatus = ''.obs;
   
   double get backupProgress => _backupProgress.value;
   String get backupStatus => _backupStatus.value;
   ```

2. Update progress during backup:
   ```dart
   Future<void> performBackup() async {
     _isBackingUp.value = true;
     _backupProgress.value = 0.0;
     
     try {
       _backupStatus.value = AppStrings.collectingData;
       _backupProgress.value = 0.1;
       
       // Collect data
       final data = await _backupService._collectWorkspaceData(workspaceId);
       _backupProgress.value = 0.3;
       
       _backupStatus.value = AppStrings.uploadingBackup;
       _backupProgress.value = 0.5;
       
       // Upload backup
       await _backupService.exportDataToBackup();
       _backupProgress.value = 1.0;
       
       _backupStatus.value = AppStrings.backupCompleted;
     } catch (e) {
       _backupStatus.value = AppStrings.backupFailed;
       rethrow;
     } finally {
       _isBackingUp.value = false;
     }
   }
   ```

3. Display progress in UI

**Expected Results**:
- ✅ Progress indicator is shown
- ✅ Progress updates during backup
- ✅ Progress is accurate

**Test Criteria**:
- Test: Progress indicator works
- Test: Progress is accurate
- Test: User experience is good

---

### Task 10: Add Unit Tests

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for backup feature.

**Files to Create**:
- `test/core/services/backup_service_test.dart`
- `test/core/services/firebase_storage_backup_service_test.dart`
- `test/features/backup/domain/entities/backup_schedule_test.dart`

**Expected Results**:
- ✅ Unit tests cover backup feature
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Add Role Guard to BackupService (Critical - Security)
2. **Task 2**: Implement exportDataToOneDrive() Method (Critical - Core Functionality)
3. **Task 3**: Create FirebaseStorageBackupService (High Priority - Feature)
4. **Task 4**: Add Backup Destination Selection (High Priority - Feature)
5. **Task 5**: Add Backup Scheduler Configuration (High Priority - Core Feature)
6. **Task 6**: Add Backup Settings UI (High Priority - UI)
7. **Task 7**: Add Failure Notification System (Medium Priority - Feature)
8. **Task 8**: Add Storage Quota Checking (Medium Priority - Feature)
9. **Task 9**: Add Backup Progress Indicator (Medium Priority - UX)
10. **Task 10**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Role guard is implemented (Account Holder/Admin only)
- ✅ `exportDataToOneDrive()` is implemented
- ✅ Firebase Storage backup service exists
- ✅ Backup destination can be selected
- ✅ Backup schedule can be configured
- ✅ Backup settings UI exists
- ✅ Failure notification works
- ✅ Storage quota checking works
- ✅ Progress indicator works
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, SnackbarService, NavigationService)
- ✅ Workspace scoping is enforced
- ✅ No known bugs or issues

---

## Dependencies

- **Firebase Realtime Database**: Required for storing backup schedules
- **Firebase Storage**: Required for Firebase Storage backup
- **OneDrive Service**: Required for OneDrive backup (already exists)
- **GetX**: Required for state management (project rule)
- **AppStrings**: All text must use AppStrings constants
- **AccessControlService**: Required for role guard
- **PushNotificationService**: Required for failure notifications

---

## Notes

1. **Role Guard**: Only Account Holder and Admin should be able to backup. This is critical for data security.

2. **Backup Destination**: Support both OneDrive and Firebase Storage. Allow users to choose.

3. **Scheduled Backup**: Support daily, weekly, and custom frequencies. Calculate next backup time correctly.

4. **Failure Notification**: Notify Account Holder/Admin when backup fails. Use multiple notification channels.

5. **Storage Quota**: Check storage quota before backup. Prevent backup when quota is exceeded. Warn when approaching quota.

6. **Progress Indicator**: Show backup progress to improve user experience.

7. **Workspace Scoping**: All backup operations must be scoped to current workspace for data isolation.

8. **Existing Components**: `BackupService.startScheduledBackups()` exists but calls empty `exportDataToOneDrive()`. Need to implement the method.

---

## Related Documentation

- `BACKUP_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `SCHEDULED_BACKUP_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/backup_feature/backup.md` - Backup requirements

