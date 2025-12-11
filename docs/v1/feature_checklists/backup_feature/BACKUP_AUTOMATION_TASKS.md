# Backup Automation: Scheduled Backup, Failure Notifications, Storage Quota - Task List & Implementation Steps

## Overview
This document lists all tasks required to implement the **Backup Automation** feature. Currently, this feature is **MISSING** - Not implemented. Backup automation should include: scheduled backup (lịch backup tự động), failure notifications (thông báo khi thất bại), and storage quota checking (kiểm tra giới hạn dung lượng).

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `BackupService` exists with `startScheduledBackups()` and `runScheduledBackupIfDue()` methods (but basic)
- ✅ `OneDriveService` exists with `getStorageQuota()` method
- ✅ `NotificationService` exists for sending notifications
- ✅ `SnackbarService` exists for in-app notifications
- ✅ Timer infrastructure exists for scheduled tasks

### What's Missing/Broken:
- ⛔ No comprehensive scheduled backup configuration
- ⛔ No failure notification system for backup failures
- ⛔ No storage quota checking before backup
- ⛔ No quota display in backup settings
- ⛔ No quota exceeded prevention
- ⛔ No notification preferences for backup failures
- ⛔ No quota check for scheduled backup
- ⛔ No backup schedule persistence across restarts

---

## Task List

### Task 1: Enhance Scheduled Backup Configuration

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Enhance scheduled backup to support different frequencies (daily, weekly, monthly) and configurable times.

**Files to Modify**:
- `lib/core/services/backup_service.dart`
- `lib/core/services/backup_scheduler_service.dart` (create new)

**Dependencies**:
- Existing `startScheduledBackups()` method

**Implementation Steps**:

1. **Create BackupSchedulerService**:
   ```dart
   // lib/core/services/backup_scheduler_service.dart
   import 'dart:async';
   import 'package:get/get.dart';
   import 'backup_service.dart';
   import 'storage_service.dart';
   
   class BackupSchedulerService {
     factory BackupSchedulerService() => _instance ??= BackupSchedulerService._();
     BackupSchedulerService._();
     static BackupSchedulerService? _instance;
     
     final BackupService _backupService = BackupService();
     final StorageService _storage = StorageService();
     Timer? _schedulerTimer;
     
     static const String _scheduleEnabledKey = 'backup_schedule_enabled';
     static const String _scheduleFrequencyKey = 'backup_schedule_frequency';
     static const String _scheduleTimeKey = 'backup_schedule_time';
     static const String _scheduleDayKey = 'backup_schedule_day';
     
     /// Get backup schedule configuration
     Map<String, dynamic> getSchedule() {
       return {
         'enabled': _storage.getBool(_scheduleEnabledKey) ?? false,
         'frequency': _storage.getString(_scheduleFrequencyKey) ?? 'daily',
         'time': _storage.getString(_scheduleTimeKey) ?? '02:00',
         'dayOfWeek': _storage.getInt('${_scheduleDayKey}_week') ?? 1, // Monday = 1
         'dayOfMonth': _storage.getInt('${_scheduleDayKey}_month') ?? 1,
       };
     }
     
     /// Set backup schedule configuration
     Future<void> setSchedule({
       bool? enabled,
       String? frequency,
       String? time,
       int? dayOfWeek,
       int? dayOfMonth,
     }) async {
       if (enabled != null) {
         await _storage.setBool(_scheduleEnabledKey, enabled);
       }
       if (frequency != null) {
         await _storage.setString(_scheduleFrequencyKey, frequency);
       }
       if (time != null) {
         await _storage.setString(_scheduleTimeKey, time);
       }
       if (dayOfWeek != null) {
         await _storage.setInt('${_scheduleDayKey}_week', dayOfWeek);
       }
       if (dayOfMonth != null) {
         await _storage.setInt('${_scheduleDayKey}_month', dayOfMonth);
       }
       
       // Restart scheduler with new configuration
       if (enabled == true || (enabled == null && getSchedule()['enabled'])) {
         await startScheduler();
       } else {
         stopScheduler();
       }
     }
     
     /// Start backup scheduler
     Future<void> startScheduler() async {
       stopScheduler();
       
       final schedule = getSchedule();
       if (!schedule['enabled']) {
         Get.log('Backup scheduler is disabled');
         return;
       }
       
       // Calculate next backup time
       final nextBackupTime = _calculateNextBackupTime(schedule);
       final now = DateTime.now();
       final delay = nextBackupTime.difference(now);
       
       if (delay.isNegative) {
         // Next backup time is in the past, schedule for tomorrow
         final tomorrow = nextBackupTime.add(const Duration(days: 1));
         final tomorrowDelay = tomorrow.difference(now);
         _scheduleNextBackup(tomorrowDelay);
       } else {
         _scheduleNextBackup(delay);
       }
       
       Get.log('Backup scheduler started. Next backup: $nextBackupTime');
     }
     
     /// Stop backup scheduler
     void stopScheduler() {
       _schedulerTimer?.cancel();
       _schedulerTimer = null;
     }
     
     /// Calculate next backup time based on schedule
     DateTime _calculateNextBackupTime(Map<String, dynamic> schedule) {
       final frequency = schedule['frequency'] as String;
       final timeString = schedule['time'] as String;
       final timeParts = timeString.split(':');
       final hour = int.parse(timeParts[0]);
       final minute = int.parse(timeParts[1]);
       
       final now = DateTime.now();
       
       switch (frequency) {
         case 'daily':
           var nextBackup = DateTime(now.year, now.month, now.day, hour, minute);
           if (nextBackup.isBefore(now)) {
             nextBackup = nextBackup.add(const Duration(days: 1));
           }
           return nextBackup;
           
         case 'weekly':
           final dayOfWeek = schedule['dayOfWeek'] as int;
           var nextBackup = DateTime(now.year, now.month, now.day, hour, minute);
           final currentDayOfWeek = now.weekday;
           final daysUntilNext = (dayOfWeek - currentDayOfWeek + 7) % 7;
           if (daysUntilNext == 0 && nextBackup.isBefore(now)) {
             nextBackup = nextBackup.add(const Duration(days: 7));
           } else {
             nextBackup = nextBackup.add(Duration(days: daysUntilNext));
           }
           return nextBackup;
           
         case 'monthly':
           final dayOfMonth = schedule['dayOfMonth'] as int;
           var nextBackup = DateTime(now.year, now.month, dayOfMonth, hour, minute);
           if (nextBackup.isBefore(now)) {
             // Move to next month
             if (now.month == 12) {
               nextBackup = DateTime(now.year + 1, 1, dayOfMonth, hour, minute);
             } else {
               nextBackup = DateTime(now.year, now.month + 1, dayOfMonth, hour, minute);
             }
           }
           return nextBackup;
           
         default:
           return now.add(const Duration(days: 1));
       }
     }
     
     /// Schedule next backup
     void _scheduleNextBackup(Duration delay) {
       _schedulerTimer = Timer(delay, () async {
         try {
           Get.log('Running scheduled backup...');
           await _backupService.exportDataToOneDrive();
           
           // Schedule next backup
           await startScheduler();
         } catch (e) {
           Get.log('ERROR: Scheduled backup failed: $e');
           // Still schedule next backup even if current one failed
           await startScheduler();
         }
       });
     }
   }
   ```

2. **Update BackupService to use BackupSchedulerService**:
   ```dart
   // In lib/core/services/backup_service.dart
   import 'backup_scheduler_service.dart';
   
   class BackupService {
     final BackupSchedulerService _scheduler = BackupSchedulerService();
     
     // ... existing code ...
   }
   ```

**Expected Results**:
- ✅ BackupSchedulerService exists
- ✅ Scheduled backup supports daily, weekly, monthly frequencies
- ✅ Backup time can be configured
- ✅ Schedule persists across app restarts
- ✅ Next backup time is calculated correctly

**Testing**:
- Test daily schedule
- Test weekly schedule
- Test monthly schedule
- Test schedule persistence
- Test next backup time calculation

---

### Task 2: Create Backup Failure Notification Service

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Create service for sending failure notifications when backup fails.

**Files to Create/Modify**:
- `lib/core/services/backup_notification_service.dart` (new file)
- `lib/core/services/backup_service.dart` (integrate notifications)

**Dependencies**:
- `NotificationService` for sending notifications
- `SnackbarService` for in-app notifications

**Implementation Steps**:

1. **Create BackupNotificationService**:
   ```dart
   // lib/core/services/backup_notification_service.dart
   import 'package:get/get.dart';
   import 'notification_service.dart';
   import 'snackbar_service.dart';
   import 'storage_service.dart';
   import '../constants/app_strings.dart';
   
   class BackupNotificationService {
     factory BackupNotificationService() => _instance ??= BackupNotificationService._();
     BackupNotificationService._();
     static BackupNotificationService? _instance;
     
     final NotificationService _notificationService = Get.find<NotificationService>();
     final SnackbarService _snackbarService = SnackbarService();
     final StorageService _storage = StorageService();
     
     static const String _notificationsEnabledKey = 'backup_failure_notifications_enabled';
     static const String _notificationMethodsKey = 'backup_failure_notification_methods';
     
     /// Check if failure notifications are enabled
     bool areNotificationsEnabled() {
       return _storage.getBool(_notificationsEnabledKey) ?? true; // Default enabled
     }
     
     /// Get notification methods
     List<String> getNotificationMethods() {
       final methods = _storage.getStringList(_notificationMethodsKey);
       return methods ?? ['in_app', 'push']; // Default methods
     }
     
     /// Set notification preferences
     Future<void> setNotificationPreferences({
       bool? enabled,
       List<String>? methods,
     }) async {
       if (enabled != null) {
         await _storage.setBool(_notificationsEnabledKey, enabled);
       }
       if (methods != null) {
         await _storage.setStringList(_notificationMethodsKey, methods);
       }
     }
     
     /// Send backup failure notification
     Future<void> notifyBackupFailure({
       required String errorMessage,
       required String errorCode,
       DateTime? failureTime,
       bool isScheduled = false,
     }) async {
       if (!areNotificationsEnabled()) {
         Get.log('Backup failure notifications are disabled');
         return;
       }
       
       final methods = getNotificationMethods();
       final time = failureTime ?? DateTime.now();
       
       final title = isScheduled 
           ? AppStrings.scheduledBackupFailed 
           : AppStrings.backupFailed;
       final message = '${AppStrings.backupFailedMessage}: $errorMessage';
       
       // Send in-app notification
       if (methods.contains('in_app')) {
         _snackbarService.showError(
           title: title,
           message: message,
         );
       }
       
       // Send push notification
       if (methods.contains('push')) {
         try {
           final userId = _storage.getUserId();
           if (userId != null) {
             await _notificationService.sendNotificationToUserID(
               userId: userId,
               title: title,
               body: message,
               data: {
                 'type': 'backup_failure',
                 'errorCode': errorCode,
                 'failureTime': time.toIso8601String(),
                 'isScheduled': isScheduled.toString(),
               },
             );
           }
         } catch (e) {
           Get.log('ERROR: Failed to send push notification: $e');
         }
       }
       
       // Send email notification (if implemented)
       if (methods.contains('email')) {
         // TODO: Implement email notification
         Get.log('Email notification not yet implemented');
       }
       
       Get.log('Backup failure notification sent');
     }
     
     /// Send backup success notification (optional)
     Future<void> notifyBackupSuccess({
       required String backupFileName,
       DateTime? backupTime,
       bool isScheduled = false,
     }) async {
       // Only send success notification if user has enabled it
       final sendSuccessNotifications = _storage.getBool('backup_success_notifications_enabled') ?? false;
       if (!sendSuccessNotifications) {
         return;
       }
       
       final methods = getNotificationMethods();
       final time = backupTime ?? DateTime.now();
       
       final title = isScheduled 
           ? AppStrings.scheduledBackupCompleted 
           : AppStrings.backupCompleted;
       final message = '${AppStrings.backupCompletedMessage}: $backupFileName';
       
       // Send in-app notification
       if (methods.contains('in_app')) {
         _snackbarService.showSuccess(
           title: title,
           message: message,
         );
       }
       
       // Send push notification (optional, usually only for failures)
       // Push notifications for success are usually disabled by default
     }
   }
   ```

2. **Add AppStrings constants**:
   ```dart
   // In app_strings.dart
   static const String scheduledBackupFailed = 'Scheduled Backup Failed';
   static const String backupFailed = 'Backup Failed';
   static const String backupFailedMessage = 'Backup failed with error';
   static const String scheduledBackupCompleted = 'Scheduled Backup Completed';
   static const String backupCompleted = 'Backup Completed';
   static const String backupCompletedMessage = 'Backup completed successfully';
   ```

3. **Integrate with BackupService**:
   ```dart
   // In lib/core/services/backup_service.dart
   import 'backup_notification_service.dart';
   
   class BackupService {
     final BackupNotificationService _notificationService = BackupNotificationService();
     
     Future<void> exportDataToOneDrive({
       BackupScope? scope,
       bool isScheduled = false,
     }) async {
       try {
         // ... existing backup logic ...
         
         Get.log('Backup completed successfully');
         
         // Send success notification (optional)
         if (isScheduled) {
           await _notificationService.notifyBackupSuccess(
             backupFileName: fileName,
             backupTime: DateTime.now(),
             isScheduled: true,
           );
         }
       } catch (e) {
         Get.log('ERROR: Backup failed: $e');
         
         // Send failure notification
         await _notificationService.notifyBackupFailure(
           errorMessage: e.toString(),
           errorCode: e is Failure ? e.runtimeType.toString() : 'UnknownError',
           failureTime: DateTime.now(),
           isScheduled: isScheduled,
         );
         
         rethrow;
       }
     }
   }
   ```

**Expected Results**:
- ✅ BackupNotificationService exists
- ✅ Failure notifications are sent when backup fails
- ✅ Notification methods are configurable
- ✅ Notifications work for scheduled and manual backups
- ✅ Notification preferences are saved

**Testing**:
- Test failure notification for manual backup
- Test failure notification for scheduled backup
- Test notification methods (in-app, push, email)
- Test notification preferences
- Verify notifications are sent correctly

---

### Task 3: Create Storage Quota Checking Service

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Create service for checking storage quota before backup to prevent quota exceeded errors.

**Files to Create/Modify**:
- `lib/core/services/backup_quota_service.dart` (new file)
- `lib/core/services/backup_service.dart` (integrate quota checking)

**Dependencies**:
- `OneDriveService.getStorageQuota()`
- `FirebaseStorageService` (if Firebase Storage is used)

**Implementation Steps**:

1. **Create BackupQuotaService**:
   ```dart
   // lib/core/services/backup_quota_service.dart
   import 'package:get/get.dart';
   import 'onedrive_service.dart';
   import 'storage_service.dart';
   import '../errors/failures.dart';
   
   class BackupQuotaService {
     factory BackupQuotaService() => _instance ??= BackupQuotaService._();
     BackupQuotaService._();
     static BackupQuotaService? _instance;
     
     final OneDriveService _oneDrive = OneDriveService();
     final StorageService _storage = StorageService();
     
     static const double _warningThreshold = 0.80; // 80%
     static const double _criticalThreshold = 0.95; // 95%
     static const double _blockThreshold = 0.99; // 99%
     
     /// Get storage quota information
     Future<Map<String, dynamic>> getStorageQuota() async {
       try {
         final quota = await _oneDrive.getStorageQuota();
         
         final total = quota['total'] as int? ?? 0;
         final used = quota['used'] as int? ?? 0;
         final remaining = quota['remaining'] as int? ?? 0;
         
         final percentage = total > 0 ? (used / total) : 0.0;
         
         return {
           'total': total,
           'used': used,
           'remaining': remaining,
           'percentage': percentage,
           'totalGB': _bytesToGB(total),
           'usedGB': _bytesToGB(used),
           'remainingGB': _bytesToGB(remaining),
         };
       } catch (e) {
         Get.log('ERROR: Failed to get storage quota: $e');
         rethrow;
       }
     }
     
     /// Check if quota is sufficient for backup
     Future<bool> isQuotaSufficient({
       int? estimatedBackupSize,
       double? requiredPercentage,
     }) async {
       try {
         final quota = await getStorageQuota();
         final percentage = quota['percentage'] as double;
         
         // Check if quota is already exceeded
         if (percentage >= _blockThreshold) {
           return false;
         }
         
         // If estimated backup size is provided, check if there's enough space
         if (estimatedBackupSize != null) {
           final remaining = quota['remaining'] as int;
           if (remaining < estimatedBackupSize) {
             return false;
           }
         }
         
         // If required percentage is provided, check if quota allows it
         if (requiredPercentage != null) {
           if (percentage + requiredPercentage > _blockThreshold) {
             return false;
           }
         }
         
         return true;
       } catch (e) {
         Get.log('ERROR: Failed to check quota sufficiency: $e');
         // If quota check fails, allow backup (fail open)
         return true;
       }
     }
     
     /// Check quota and throw error if insufficient
     Future<void> ensureQuotaSufficient({
       int? estimatedBackupSize,
     }) async {
       final isSufficient = await isQuotaSufficient(
         estimatedBackupSize: estimatedBackupSize,
       );
       
       if (!isSufficient) {
         final quota = await getStorageQuota();
         final percentage = (quota['percentage'] as double * 100).toStringAsFixed(1);
         
         throw StorageQuotaExceededFailure(
           message: 'Storage quota exceeded ($percentage% used). Please free up space before creating backup.',
         );
       }
     }
     
     /// Get quota warning level
     QuotaWarningLevel getQuotaWarningLevel(double percentage) {
       if (percentage >= _blockThreshold) {
         return QuotaWarningLevel.critical;
       } else if (percentage >= _criticalThreshold) {
         return QuotaWarningLevel.high;
       } else if (percentage >= _warningThreshold) {
         return QuotaWarningLevel.warning;
       } else {
         return QuotaWarningLevel.none;
       }
     }
     
     /// Convert bytes to GB
     double _bytesToGB(int bytes) {
       return bytes / (1024 * 1024 * 1024);
     }
   }
   
   enum QuotaWarningLevel {
     none,
     warning,
     high,
     critical,
   }
   
   class StorageQuotaExceededFailure extends Failure {
     const StorageQuotaExceededFailure({required String message})
         : super(message: message);
   }
   ```

2. **Integrate quota checking with BackupService**:
   ```dart
   // In lib/core/services/backup_service.dart
   import 'backup_quota_service.dart';
   
   class BackupService {
     final BackupQuotaService _quotaService = BackupQuotaService();
     
     Future<void> exportDataToOneDrive({
       BackupScope? scope,
       bool isScheduled = false,
       bool checkQuota = true,
     }) async {
       try {
         // ... permission check ...
         
         // Check storage quota before backup
         if (checkQuota) {
           // Estimate backup size (optional, can be improved)
           final estimatedSize = await _estimateBackupSize(workspaceId, scope);
           
           await _quotaService.ensureQuotaSufficient(
             estimatedBackupSize: estimatedSize,
           );
           
           Get.log('Storage quota check passed');
         }
         
         // Continue with backup...
       } catch (e) {
         if (e is StorageQuotaExceededFailure) {
           // Send quota exceeded notification
           await _notificationService.notifyBackupFailure(
             errorMessage: e.message,
             errorCode: 'StorageQuotaExceeded',
             failureTime: DateTime.now(),
             isScheduled: isScheduled,
           );
         }
         rethrow;
       }
     }
     
     /// Estimate backup size (rough estimate)
     Future<int> _estimateBackupSize(String workspaceId, BackupScope? scope) async {
       // Rough estimate: 1 KB per task, 2 KB per project, 0.5 KB per member
       // This can be improved with actual data size calculation
       int estimatedSize = 1024; // Base size (1 KB)
       
       if (scope?.includeTasks ?? true) {
         final tasks = await _db.listTasks(workspaceId: workspaceId);
         estimatedSize += tasks.length * 1024; // 1 KB per task
       }
       
       if (scope?.includeProjects ?? true) {
         final projects = await _db.listProjects(workspaceId: workspaceId);
         estimatedSize += projects.length * 2048; // 2 KB per project
       }
       
       return estimatedSize;
     }
   }
   ```

**Expected Results**:
- ✅ BackupQuotaService exists
- ✅ Storage quota is checked before backup
- ✅ Backup is prevented if quota is exceeded
- ✅ Quota warning levels are calculated
- ✅ Error messages are clear

**Testing**:
- Test quota checking before backup
- Test quota exceeded prevention
- Test quota warning levels
- Test quota check for scheduled backup
- Verify error messages are clear

---

### Task 4: Add Quota Display to Backup Settings UI

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Add UI to display storage quota information in backup settings.

**Files to Create/Modify**:
- `lib/app/pages/backup/backup_settings_page.dart` (modify or create)
- `lib/core/controllers/backup_quota_controller.dart` (new file)

**Dependencies**:
- Task 3 (BackupQuotaService)

**Implementation Steps**:

1. **Create BackupQuotaController**:
   ```dart
   // lib/core/controllers/backup_quota_controller.dart
   import 'package:get/get.dart';
   import '../services/backup_quota_service.dart';
   
   class BackupQuotaController extends GetxController {
     final BackupQuotaService _quotaService = BackupQuotaService();
     
     final RxMap<String, dynamic> _quota = <String, dynamic>{}.obs;
     final RxBool _isLoading = false.obs;
     final RxString _errorMessage = ''.obs;
     
     Map<String, dynamic> get quota => _quota;
     bool get isLoading => _isLoading.value;
     String get errorMessage => _errorMessage.value;
     
     @override
     void onInit() {
       super.onInit();
       loadQuota();
     }
     
     Future<void> loadQuota() async {
       _isLoading.value = true;
       _errorMessage.value = '';
       
       try {
         final quota = await _quotaService.getStorageQuota();
         _quota.value = quota;
       } catch (e) {
         _errorMessage.value = 'Failed to load quota: $e';
       } finally {
         _isLoading.value = false;
       }
     }
     
     QuotaWarningLevel get warningLevel {
       final percentage = _quota['percentage'] as double? ?? 0.0;
       return _quotaService.getQuotaWarningLevel(percentage);
     }
     
     String get quotaDisplayText {
       final usedGB = _quota['usedGB'] as double? ?? 0.0;
       final totalGB = _quota['totalGB'] as double? ?? 0.0;
       final percentage = (_quota['percentage'] as double? ?? 0.0 * 100).toStringAsFixed(1);
       return '${usedGB.toStringAsFixed(2)} GB / ${totalGB.toStringAsFixed(2)} GB ($percentage%)';
     }
   }
   ```

2. **Add quota display to BackupSettingsPage**:
   ```dart
   // In backup_settings_page.dart
   Widget _buildQuotaDisplay() {
     return GetBuilder<BackupQuotaController>(
       builder: (controller) {
         if (controller.isLoading) {
           return TDLoadingIndicator();
         }
         
         final warningLevel = controller.warningLevel;
         Color progressColor;
         String warningText = '';
         
         switch (warningLevel) {
           case QuotaWarningLevel.none:
             progressColor = Colors.green;
             break;
           case QuotaWarningLevel.warning:
             progressColor = Colors.orange;
             warningText = AppStrings.quotaWarning;
             break;
           case QuotaWarningLevel.high:
             progressColor = Colors.deepOrange;
             warningText = AppStrings.quotaHigh;
             break;
           case QuotaWarningLevel.critical:
             progressColor = Colors.red;
             warningText = AppStrings.quotaCritical;
             break;
         }
         
         final percentage = controller.quota['percentage'] as double? ?? 0.0;
         
         return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               AppStrings.storageQuota,
               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
             ),
             SizedBox(height: 8),
             Text(controller.quotaDisplayText),
             SizedBox(height: 8),
             LinearProgressIndicator(
               value: percentage,
               backgroundColor: Colors.grey[300],
               valueColor: AlwaysStoppedAnimation<Color>(progressColor),
             ),
             if (warningText.isNotEmpty) ...[
               SizedBox(height: 8),
               Text(
                 warningText,
                 style: TextStyle(color: progressColor),
               ),
             ],
           ],
         );
       },
     );
   }
   ```

**Expected Results**:
- ✅ BackupQuotaController exists
- ✅ Quota information is displayed in backup settings
- ✅ Quota warning levels are shown with colors
- ✅ Quota updates when refreshed

**Testing**:
- Test quota display
- Test quota warning levels
- Test quota refresh
- Verify UI is user-friendly

---

### Task 5: Integrate Quota Check with Scheduled Backup

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2 hours

**Description**:
Integrate quota checking with scheduled backup to prevent scheduled backups from failing due to quota.

**Files to Modify**:
- `lib/core/services/backup_scheduler_service.dart`
- `lib/core/services/backup_service.dart`

**Dependencies**:
- Task 3 (BackupQuotaService)
- Task 1 (BackupSchedulerService)

**Implementation Steps**:

1. **Add quota check to scheduled backup**:
   ```dart
   // In lib/core/services/backup_scheduler_service.dart
   import 'backup_quota_service.dart';
   import 'backup_notification_service.dart';
   
   class BackupSchedulerService {
     final BackupQuotaService _quotaService = BackupQuotaService();
     final BackupNotificationService _notificationService = BackupNotificationService();
     
     /// Schedule next backup
     void _scheduleNextBackup(Duration delay) {
       _schedulerTimer = Timer(delay, () async {
         try {
           Get.log('Running scheduled backup...');
           
           // Check quota before backup
           final isSufficient = await _quotaService.isQuotaSufficient();
           
           if (!isSufficient) {
             Get.log('Scheduled backup skipped: storage quota exceeded');
             
             // Send notification about skipped backup
             await _notificationService.notifyBackupFailure(
               errorMessage: 'Storage quota exceeded. Backup was skipped.',
               errorCode: 'StorageQuotaExceeded',
               failureTime: DateTime.now(),
               isScheduled: true,
             );
             
             // Still schedule next backup
             await startScheduler();
             return;
           }
           
           // Proceed with backup
           await _backupService.exportDataToOneDrive(isScheduled: true);
           
           // Schedule next backup
           await startScheduler();
         } catch (e) {
           Get.log('ERROR: Scheduled backup failed: $e');
           
           // Send failure notification
           await _notificationService.notifyBackupFailure(
             errorMessage: e.toString(),
             errorCode: e is Failure ? e.runtimeType.toString() : 'UnknownError',
             failureTime: DateTime.now(),
             isScheduled: true,
           );
           
           // Still schedule next backup even if current one failed
           await startScheduler();
         }
       });
     }
   }
   ```

**Expected Results**:
- ✅ Quota is checked before scheduled backup
- ✅ Scheduled backup is skipped if quota is exceeded
- ✅ Notification is sent when scheduled backup is skipped
- ✅ Next backup is still scheduled

**Testing**:
- Test quota check for scheduled backup
- Test scheduled backup skip when quota exceeded
- Test notification for skipped backup
- Verify next backup is still scheduled

---

### Task 6: Add Backup Schedule UI

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 4-5 hours

**Description**:
Add UI for configuring backup schedule (frequency, time, day).

**Files to Create/Modify**:
- `lib/app/pages/backup/backup_schedule_settings_page.dart` (new file)
- `lib/core/controllers/backup_schedule_controller.dart` (new file)

**Dependencies**:
- Task 1 (BackupSchedulerService)

**Implementation Steps**:

1. **Create BackupScheduleController**:
   ```dart
   // lib/core/controllers/backup_schedule_controller.dart
   import 'package:get/get.dart';
   import '../services/backup_scheduler_service.dart';
   
   class BackupScheduleController extends GetxController {
     final BackupSchedulerService _scheduler = BackupSchedulerService();
     
     final RxBool _enabled = false.obs;
     final RxString _frequency = 'daily'.obs;
     final RxString _time = '02:00'.obs;
     final RxInt _dayOfWeek = 1.obs;
     final RxInt _dayOfMonth = 1.obs;
     
     bool get enabled => _enabled.value;
     String get frequency => _frequency.value;
     String get time => _time.value;
     int get dayOfWeek => _dayOfWeek.value;
     int get dayOfMonth => _dayOfMonth.value;
     
     @override
     void onInit() {
       super.onInit();
       _loadSchedule();
     }
     
     void _loadSchedule() {
       final schedule = _scheduler.getSchedule();
       _enabled.value = schedule['enabled'];
       _frequency.value = schedule['frequency'];
       _time.value = schedule['time'];
       _dayOfWeek.value = schedule['dayOfWeek'];
       _dayOfMonth.value = schedule['dayOfMonth'];
     }
     
     void setEnabled(bool enabled) {
       _enabled.value = enabled;
     }
     
     void setFrequency(String frequency) {
       _frequency.value = frequency;
     }
     
     void setTime(String time) {
       _time.value = time;
     }
     
     void setDayOfWeek(int day) {
       _dayOfWeek.value = day;
     }
     
     void setDayOfMonth(int day) {
       _dayOfMonth.value = day;
     }
     
     Future<void> saveSchedule() async {
       await _scheduler.setSchedule(
         enabled: _enabled.value,
         frequency: _frequency.value,
         time: _time.value,
         dayOfWeek: _frequency.value == 'weekly' ? _dayOfWeek.value : null,
         dayOfMonth: _frequency.value == 'monthly' ? _dayOfMonth.value : null,
       );
     }
   }
   ```

2. **Create BackupScheduleSettingsPage UI**:
   ```dart
   // Implementation with:
   // - Enable/disable toggle
   // - Frequency selector (daily, weekly, monthly)
   // - Time picker
   // - Day selector (for weekly/monthly)
   // - Save button
   // - Next backup time display
   ```

**Expected Results**:
- ✅ BackupScheduleController exists
- ✅ BackupScheduleSettingsPage UI exists
- ✅ UI allows configuring schedule
- ✅ Schedule is saved and applied
- ✅ Next backup time is displayed

**Testing**:
- Test schedule configuration
- Test schedule persistence
- Test next backup time calculation
- Verify UI is user-friendly

---

### Task 7: Add Failure Notification Preferences UI

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Add UI for configuring failure notification preferences.

**Files to Create/Modify**:
- `lib/app/pages/backup/backup_notification_settings_page.dart` (new file)
- `lib/core/controllers/backup_notification_controller.dart` (new file)

**Dependencies**:
- Task 2 (BackupNotificationService)

**Implementation Steps**:

1. **Create BackupNotificationController**:
   ```dart
   // lib/core/controllers/backup_notification_controller.dart
   import 'package:get/get.dart';
   import '../services/backup_notification_service.dart';
   
   class BackupNotificationController extends GetxController {
     final BackupNotificationService _notificationService = BackupNotificationService();
     
     final RxBool _enabled = true.obs;
     final RxList<String> _methods = <String>['in_app', 'push'].obs;
     
     bool get enabled => _enabled.value;
     List<String> get methods => _methods;
     
     @override
     void onInit() {
       super.onInit();
       _loadPreferences();
     }
     
     void _loadPreferences() {
       _enabled.value = _notificationService.areNotificationsEnabled();
       _methods.value = _notificationService.getNotificationMethods();
     }
     
     void setEnabled(bool enabled) {
       _enabled.value = enabled;
     }
     
     void toggleMethod(String method) {
       if (_methods.contains(method)) {
         _methods.remove(method);
       } else {
         _methods.add(method);
       }
     }
     
     Future<void> savePreferences() async {
       await _notificationService.setNotificationPreferences(
         enabled: _enabled.value,
         methods: _methods.toList(),
       );
     }
   }
   ```

2. **Create BackupNotificationSettingsPage UI**:
   ```dart
   // Implementation with:
   // - Enable/disable toggle
   // - Notification methods checkboxes (in-app, push, email)
   // - Save button
   ```

**Expected Results**:
- ✅ BackupNotificationController exists
- ✅ BackupNotificationSettingsPage UI exists
- ✅ UI allows configuring notification preferences
- ✅ Preferences are saved and applied

**Testing**:
- Test notification preferences configuration
- Test preferences persistence
- Test notifications are sent according to preferences

---

## Summary

### Implementation Order:
1. **Task 1**: Enhance scheduled backup configuration
2. **Task 2**: Create backup failure notification service
3. **Task 3**: Create storage quota checking service
4. **Task 5**: Integrate quota check with scheduled backup
5. **Task 4**: Add quota display to backup settings UI
6. **Task 6**: Add backup schedule UI
7. **Task 7**: Add failure notification preferences UI

### Estimated Total Time: 18-24 hours

### Dependencies:
- Task 1 is independent
- Task 2 depends on NotificationService
- Task 3 depends on OneDriveService
- Task 4 depends on Task 3
- Task 5 depends on Tasks 1, 2, and 3
- Task 6 depends on Task 1
- Task 7 depends on Task 2

### Testing Requirements:
- Unit tests for scheduler service
- Unit tests for notification service
- Unit tests for quota service
- Integration tests for scheduled backup with quota checking
- Integration tests for failure notifications
- Manual testing for UI components

### Success Criteria:
- ✅ Scheduled backup runs automatically
- ✅ Backup schedule can be configured
- ✅ Failure notifications are sent when backup fails
- ✅ Storage quota is checked before backup
- ✅ Backup is prevented if quota is exceeded
- ✅ Quota information is displayed
- ✅ Notification preferences are configurable

### Security and Reliability Considerations:
- **Critical**: Scheduled backup must respect user permissions
- Failure notifications must be sent reliably
- Storage quota checks must be accurate
- Quota exceeded prevention must work correctly
- Automation should not break if services are unavailable
- Schedule persistence must work across app restarts

