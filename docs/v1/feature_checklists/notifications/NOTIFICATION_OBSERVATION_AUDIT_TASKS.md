# Notification Observation & Audit (Logging, Statistics, Metrics) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Notification Observation & Audit** feature (log notification sending: success/fail, retry count; statistics: success rate, fail rate, invalid tokens). Currently, this feature is **MISSING** - Not implemented; no logging/metrics.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `WorkspaceAnalytics` exists but is for workspace events, not notifications
- ✅ Firebase Analytics is available
- ✅ Basic `Get.log` statements exist but not structured
- ✅ Firebase Realtime Database is available for logging

### What's Missing/Broken:
- ⛔ No notification log entity
- ⛔ No notification statistics service
- ⛔ No logging for notification sends
- ⛔ No statistics calculation
- ⛔ No invalid token tracking
- ⛔ No statistics dashboard
- ⛔ No log export functionality
- ⛔ No audit trail

---

## Task List

### Task 1: Create NotificationLog Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create entity to represent notification log entries for tracking all notification sends.

**Files to Create**:
- `lib/features/notifications/domain/entities/notification_log.dart` (new file)

**Implementation Steps**:
1. Create `NotificationLog` entity:
   ```dart
   class NotificationLog {
     final String id;
     final String userId;
     final String workspaceId;
     final String notificationType; // e.g., 'task_assigned', 'mention', 'workspace_change'
     final String status; // 'success', 'failed', 'suppressed'
     final String? error; // Error message if failed
     final String? errorType; // 'network_error', 'invalid_token', 'server_error', etc.
     final int retryCount;
     final int durationMs; // Time taken to send in milliseconds
     final DateTime timestamp;
     final Map<String, dynamic>? metadata; // Additional data
     
     const NotificationLog({
       required this.id,
       required this.userId,
       required this.workspaceId,
       required this.notificationType,
       required this.status,
       this.error,
       this.errorType,
       this.retryCount = 0,
       this.durationMs = 0,
       required this.timestamp,
       this.metadata,
     });
     
     factory NotificationLog.fromMap(Map<String, dynamic> map) {
       return NotificationLog(
         id: map['id'] ?? '',
         userId: map['userId'] ?? '',
         workspaceId: map['workspaceId'] ?? '',
         notificationType: map['notificationType'] ?? '',
         status: map['status'] ?? '',
         error: map['error'],
         errorType: map['errorType'],
         retryCount: map['retryCount'] ?? 0,
         durationMs: map['durationMs'] ?? 0,
         timestamp: DateTime.fromMillisecondsSinceEpoch(
           map['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
         ),
         metadata: map['metadata'] is Map<String, dynamic>
             ? Map<String, dynamic>.from(map['metadata'])
             : null,
       );
     }
     
     Map<String, dynamic> toMap() {
       return {
         'id': id,
         'userId': userId,
         'workspaceId': workspaceId,
         'notificationType': notificationType,
         'status': status,
         'error': error,
         'errorType': errorType,
         'retryCount': retryCount,
         'durationMs': durationMs,
         'timestamp': timestamp.millisecondsSinceEpoch,
         'metadata': metadata,
       };
     }
     
     NotificationLog copyWith({
       String? id,
       String? userId,
       String? workspaceId,
       String? notificationType,
       String? status,
       String? error,
       String? errorType,
       int? retryCount,
       int? durationMs,
       DateTime? timestamp,
       Map<String, dynamic>? metadata,
     }) {
       return NotificationLog(
         id: id ?? this.id,
         userId: userId ?? this.userId,
         workspaceId: workspaceId ?? this.workspaceId,
         notificationType: notificationType ?? this.notificationType,
         status: status ?? this.status,
         error: error ?? this.error,
         errorType: errorType ?? this.errorType,
         retryCount: retryCount ?? this.retryCount,
         durationMs: durationMs ?? this.durationMs,
         timestamp: timestamp ?? this.timestamp,
         metadata: metadata ?? this.metadata,
       );
     }
   }
   ```

2. Add validation methods

**Expected Results**:
- ✅ NotificationLog entity exists
- ✅ Entity can be serialized/deserialized
- ✅ Entity includes all required fields

**Test Criteria**:
- Unit test: Test entity creation
- Unit test: Test serialization/deserialization

---

### Task 2: Create NotificationStatistics Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create entity to represent notification statistics aggregated data.

**Files to Create**:
- `lib/features/notifications/domain/entities/notification_statistics.dart` (new file)

**Implementation Steps**:
1. Create `NotificationStatistics` entity:
   ```dart
   class NotificationStatistics {
     final String workspaceId;
     final DateTime calculatedAt;
     final int totalSent;
     final int totalSuccess;
     final int totalFailed;
     final int totalSuppressed;
     final int totalInvalidTokens;
     final double successRate; // Percentage
     final double failRate; // Percentage
     final Map<String, int> byType; // Count by notification type
     final Map<String, int> byUser; // Count by user ID
     final Map<String, int> byErrorType; // Count by error type
     
     const NotificationStatistics({
       required this.workspaceId,
       required this.calculatedAt,
       this.totalSent = 0,
       this.totalSuccess = 0,
       this.totalFailed = 0,
       this.totalSuppressed = 0,
       this.totalInvalidTokens = 0,
       this.successRate = 0.0,
       this.failRate = 0.0,
       this.byType = const {},
       this.byUser = const {},
       this.byErrorType = const {},
     });
     
     factory NotificationStatistics.fromMap(Map<String, dynamic> map) {
       return NotificationStatistics(
         workspaceId: map['workspaceId'] ?? '',
         calculatedAt: DateTime.fromMillisecondsSinceEpoch(
           map['calculatedAt'] ?? DateTime.now().millisecondsSinceEpoch,
         ),
         totalSent: map['totalSent'] ?? 0,
         totalSuccess: map['totalSuccess'] ?? 0,
         totalFailed: map['totalFailed'] ?? 0,
         totalSuppressed: map['totalSuppressed'] ?? 0,
         totalInvalidTokens: map['totalInvalidTokens'] ?? 0,
         successRate: (map['successRate'] ?? 0.0).toDouble(),
         failRate: (map['failRate'] ?? 0.0).toDouble(),
         byType: Map<String, int>.from(map['byType'] ?? {}),
         byUser: Map<String, int>.from(map['byUser'] ?? {}),
         byErrorType: Map<String, int>.from(map['byErrorType'] ?? {}),
       );
     }
     
     Map<String, dynamic> toMap() {
       return {
         'workspaceId': workspaceId,
         'calculatedAt': calculatedAt.millisecondsSinceEpoch,
         'totalSent': totalSent,
         'totalSuccess': totalSuccess,
         'totalFailed': totalFailed,
         'totalSuppressed': totalSuppressed,
         'totalInvalidTokens': totalInvalidTokens,
         'successRate': successRate,
         'failRate': failRate,
         'byType': byType,
         'byUser': byUser,
         'byErrorType': byErrorType,
       };
     }
   }
   ```

**Expected Results**:
- ✅ NotificationStatistics entity exists
- ✅ Entity can be serialized/deserialized
- ✅ Entity includes all required fields

**Test Criteria**:
- Unit test: Test entity creation
- Unit test: Test serialization/deserialization

---

### Task 3: Create NotificationLoggingService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for logging notification sends to Firebase.

**Files to Create**:
- `lib/core/services/notification_logging_service.dart` (new file)

**Implementation Steps**:
1. Create `NotificationLoggingService`:
   ```dart
   class NotificationLoggingService extends GetxService {
     final FirebaseDatabaseService _databaseService = Get.find<FirebaseDatabaseService>();
     
     /// Log notification send attempt
     Future<void> logNotificationSend({
       required String userId,
       required String workspaceId,
       required String notificationType,
       required String status,
       String? error,
       String? errorType,
       int retryCount = 0,
       int durationMs = 0,
       Map<String, dynamic>? metadata,
     }) async {
       try {
         final logId = DateTime.now().millisecondsSinceEpoch.toString();
         final log = NotificationLog(
           id: logId,
           userId: userId,
           workspaceId: workspaceId,
           notificationType: notificationType,
           status: status,
           error: error,
           errorType: errorType,
           retryCount: retryCount,
           durationMs: durationMs,
           timestamp: DateTime.now(),
           metadata: metadata,
         );
         
         await _databaseService.createNotificationLog(log);
       } catch (e) {
         // Don't throw - logging failure shouldn't break notification sending
         Get.log('Failed to log notification send: $e');
       }
     }
     
     /// Log notification success
     Future<void> logSuccess({
       required String userId,
       required String workspaceId,
       required String notificationType,
       int durationMs = 0,
       Map<String, dynamic>? metadata,
     }) async {
       await logNotificationSend(
         userId: userId,
         workspaceId: workspaceId,
         notificationType: notificationType,
         status: 'success',
         durationMs: durationMs,
         metadata: metadata,
       );
     }
     
     /// Log notification failure
     Future<void> logFailure({
       required String userId,
       required String workspaceId,
       required String notificationType,
       required String error,
       String? errorType,
       int retryCount = 0,
       int durationMs = 0,
       Map<String, dynamic>? metadata,
     }) async {
       await logNotificationSend(
         userId: userId,
         workspaceId: workspaceId,
         notificationType: notificationType,
         status: 'failed',
         error: error,
         errorType: errorType,
         retryCount: retryCount,
         durationMs: durationMs,
         metadata: metadata,
       );
     }
     
     /// Log notification suppressed (by preferences)
     Future<void> logSuppressed({
       required String userId,
       required String workspaceId,
       required String notificationType,
       String? reason,
       Map<String, dynamic>? metadata,
     }) async {
       await logNotificationSend(
         userId: userId,
         workspaceId: workspaceId,
         notificationType: notificationType,
         status: 'suppressed',
         error: reason,
         errorType: 'preference_suppressed',
         metadata: metadata,
       );
     }
   }
   ```

**Expected Results**:
- ✅ NotificationLoggingService exists
- ✅ Service can log success/fail/suppressed
- ✅ Logging doesn't block notification sending

**Test Criteria**:
- Unit test: Test logging methods
- Test: Test with Firebase

---

### Task 4: Add Notification Log Methods to FirebaseDatabaseService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add methods to FirebaseDatabaseService for notification log operations.

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`

**Implementation Steps**:
1. Add notification log methods:
   ```dart
   /// Create notification log entry
   Future<void> createNotificationLog(NotificationLog log) async {
     try {
       final ref = _database.ref(
         'notification_logs/${log.workspaceId}/${log.id}',
       );
       await ref.set(log.toMap());
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to create notification log: $e');
     }
   }
   
   /// Get notification logs for workspace
   Future<List<NotificationLog>> getNotificationLogs({
     required String workspaceId,
     DateTime? fromDate,
     DateTime? toDate,
     String? status,
     String? notificationType,
     String? userId,
     int? limit,
   }) async {
     try {
       var ref = _database.ref('notification_logs/$workspaceId');
       
       // Apply filters
       if (fromDate != null) {
         ref = ref.orderByChild('timestamp')
             .startAt(fromDate.millisecondsSinceEpoch);
       }
       if (toDate != null) {
         ref = ref.orderByChild('timestamp')
             .endAt(toDate.millisecondsSinceEpoch);
       }
       
       final snapshot = await ref.get();
       if (!snapshot.exists) return [];
       
       final data = snapshot.value as Map<dynamic, dynamic>?;
       if (data == null) return [];
       
       final logs = <NotificationLog>[];
       for (final entry in data.entries) {
         try {
           final logData = Map<String, dynamic>.from(entry.value as Map);
           final log = NotificationLog.fromMap(logData);
           
           // Apply client-side filters
           if (status != null && log.status != status) continue;
           if (notificationType != null && log.notificationType != notificationType) continue;
           if (userId != null && log.userId != userId) continue;
           
           logs.add(log);
         } catch (e) {
           continue;
         }
       }
       
       // Sort by timestamp descending
       logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
       
       // Apply limit
       if (limit != null && limit > 0) {
         return logs.take(limit).toList();
       }
       
       return logs;
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to get notification logs: $e');
     }
   }
   ```

**Expected Results**:
- ✅ Database methods exist
- ✅ Methods work correctly
- ✅ Filters work correctly

**Test Criteria**:
- Unit test: Test database methods
- Test: Test with Firebase

---

### Task 5: Create NotificationStatisticsService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for calculating and managing notification statistics.

**Files to Create**:
- `lib/core/services/notification_statistics_service.dart` (new file)

**Implementation Steps**:
1. Create `NotificationStatisticsService`:
   ```dart
   class NotificationStatisticsService extends GetxService {
     final FirebaseDatabaseService _databaseService = Get.find<FirebaseDatabaseService>();
     
     /// Calculate statistics for workspace
     Future<NotificationStatistics> calculateStatistics({
       required String workspaceId,
       DateTime? fromDate,
       DateTime? toDate,
     }) async {
       try {
         final logs = await _databaseService.getNotificationLogs(
           workspaceId: workspaceId,
           fromDate: fromDate,
           toDate: toDate,
         );
         
         final totalSent = logs.length;
         final totalSuccess = logs.where((l) => l.status == 'success').length;
         final totalFailed = logs.where((l) => l.status == 'failed').length;
         final totalSuppressed = logs.where((l) => l.status == 'suppressed').length;
         final totalInvalidTokens = logs.where((l) => l.errorType == 'invalid_token').length;
         
         final successRate = totalSent > 0 ? (totalSuccess / totalSent) * 100 : 0.0;
         final failRate = totalSent > 0 ? (totalFailed / totalSent) * 100 : 0.0;
         
         // Calculate by type
         final byType = <String, int>{};
         for (final log in logs) {
           byType[log.notificationType] = (byType[log.notificationType] ?? 0) + 1;
         }
         
         // Calculate by user
         final byUser = <String, int>{};
         for (final log in logs) {
           byUser[log.userId] = (byUser[log.userId] ?? 0) + 1;
         }
         
         // Calculate by error type
         final byErrorType = <String, int>{};
         for (final log in logs) {
           if (log.errorType != null) {
             byErrorType[log.errorType!] = (byErrorType[log.errorType!] ?? 0) + 1;
           }
         }
         
         return NotificationStatistics(
           workspaceId: workspaceId,
           calculatedAt: DateTime.now(),
           totalSent: totalSent,
           totalSuccess: totalSuccess,
           totalFailed: totalFailed,
           totalSuppressed: totalSuppressed,
           totalInvalidTokens: totalInvalidTokens,
           successRate: successRate,
           failRate: failRate,
           byType: byType,
           byUser: byUser,
           byErrorType: byErrorType,
         );
       } catch (e) {
         Get.log('Failed to calculate statistics: $e');
         return NotificationStatistics(
           workspaceId: workspaceId,
           calculatedAt: DateTime.now(),
         );
       }
     }
     
     /// Save statistics to Firebase (for caching)
     Future<void> saveStatistics(NotificationStatistics statistics) async {
       try {
         await _databaseService.saveNotificationStatistics(statistics);
       } catch (e) {
         Get.log('Failed to save statistics: $e');
       }
     }
     
     /// Get cached statistics
     Future<NotificationStatistics?> getCachedStatistics({
       required String workspaceId,
       Duration? maxAge,
     }) async {
       try {
         final statistics = await _databaseService.getNotificationStatistics(workspaceId);
         if (statistics == null) return null;
         
         if (maxAge != null) {
           final age = DateTime.now().difference(statistics.calculatedAt);
           if (age > maxAge) return null; // Cache expired
         }
         
         return statistics;
       } catch (e) {
         Get.log('Failed to get cached statistics: $e');
         return null;
       }
     }
   }
   ```

**Expected Results**:
- ✅ NotificationStatisticsService exists
- ✅ Service can calculate statistics
- ✅ Service can cache statistics

**Test Criteria**:
- Unit test: Test statistics calculation
- Test: Test with Firebase

---

### Task 6: Add Notification Statistics Methods to FirebaseDatabaseService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add methods to FirebaseDatabaseService for notification statistics operations.

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`

**Implementation Steps**:
1. Add statistics methods:
   ```dart
   /// Save notification statistics
   Future<void> saveNotificationStatistics(NotificationStatistics statistics) async {
     try {
       final ref = _database.ref(
         'notification_statistics/${statistics.workspaceId}',
       );
       await ref.set(statistics.toMap());
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to save notification statistics: $e');
     }
   }
   
   /// Get notification statistics
   Future<NotificationStatistics?> getNotificationStatistics(String workspaceId) async {
     try {
       final ref = _database.ref('notification_statistics/$workspaceId');
       final snapshot = await ref.get();
       
       if (!snapshot.exists) return null;
       
       final data = snapshot.value as Map<dynamic, dynamic>?;
       if (data == null) return null;
       
       return NotificationStatistics.fromMap(
         Map<String, dynamic>.from(data),
       );
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to get notification statistics: $e');
     }
   }
   ```

**Expected Results**:
- ✅ Database methods exist
- ✅ Methods work correctly

**Test Criteria**:
- Unit test: Test database methods
- Test: Test with Firebase

---

### Task 7: Integrate Logging with Push Notification Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Integrate logging service with push notification service to log all sends.

**Files to Modify**:
- `lib/core/services/push_notification_service.dart`

**Implementation Steps**:
1. Inject `NotificationLoggingService`:
   ```dart
   final NotificationLoggingService _loggingService = Get.find<NotificationLoggingService>();
   ```

2. Add logging to `sendToUser` method:
   ```dart
   Future<PushNotificationResult> sendToUser({
     required String userId,
     required String title,
     required String body,
     Map<String, String>? data,
     required String notificationType,
   }) async {
     final startTime = DateTime.now();
     String? error;
     String? errorType;
     int retryCount = 0;
     
     try {
       // ... existing send logic with retry ...
       
       if (result.success) {
         final duration = DateTime.now().difference(startTime).inMilliseconds;
         await _loggingService.logSuccess(
           userId: userId,
           workspaceId: workspaceId,
           notificationType: notificationType,
           durationMs: duration,
         );
       } else {
         final duration = DateTime.now().difference(startTime).inMilliseconds;
         await _loggingService.logFailure(
           userId: userId,
           workspaceId: workspaceId,
           notificationType: notificationType,
           error: result.error ?? 'Unknown error',
           errorType: errorType,
           retryCount: retryCount,
           durationMs: duration,
         );
       }
       
       return result;
     } catch (e) {
       final duration = DateTime.now().difference(startTime).inMilliseconds;
       await _loggingService.logFailure(
         userId: userId,
         workspaceId: workspaceId,
         notificationType: notificationType,
         error: e.toString(),
         errorType: 'exception',
         retryCount: retryCount,
         durationMs: duration,
       );
       rethrow;
     }
   }
   ```

3. Add logging for suppressed notifications:
   ```dart
   if (!preferences.shouldSendNotification(notificationType)) {
     await _loggingService.logSuppressed(
       userId: userId,
       workspaceId: workspaceId,
       notificationType: notificationType,
       reason: 'User preferences disabled',
     );
     return PushNotificationResult(
       success: false,
       error: 'Notification suppressed by preferences',
       suppressed: true,
     );
   }
   ```

**Expected Results**:
- ✅ All notification sends are logged
- ✅ Success/fail/suppressed are logged correctly
- ✅ Retry attempts are logged

**Test Criteria**:
- Test: Success is logged
- Test: Failure is logged
- Test: Suppressed is logged
- Test: Retry attempts are logged

---

### Task 8: Create Notification Statistics Dashboard Page

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI page for viewing notification statistics.

**Files to Create**:
- `lib/app/pages/notifications/notification_statistics_page.dart` (new file)
- `lib/app/pages/notifications/controllers/notification_statistics_controller.dart` (new file)

**Implementation Steps**:
1. Create `NotificationStatisticsController`:
   ```dart
   class NotificationStatisticsController extends GetxController {
     final NotificationStatisticsService _statisticsService = Get.find<NotificationStatisticsService>();
     final StorageService _storageService = Get.find<StorageService>();
     
     final Rx<NotificationStatistics?> statistics = Rx<NotificationStatistics?>(null);
     final RxBool isLoading = false.obs;
     final Rx<DateTime?> fromDate = Rx<DateTime?>(null);
     final Rx<DateTime?> toDate = Rx<DateTime?>(null);
     
     @override
     void onInit() {
       super.onInit();
       loadStatistics();
     }
     
     Future<void> loadStatistics() async {
       try {
         isLoading.value = true;
         
         final workspaceId = _storageService.getWorkspaceId();
         if (workspaceId == null) return;
         
         final stats = await _statisticsService.calculateStatistics(
           workspaceId: workspaceId,
           fromDate: fromDate.value,
           toDate: toDate.value,
         );
         
         statistics.value = stats;
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.error,
           message: AppStrings.failedToLoadStatistics,
         );
       } finally {
         isLoading.value = false;
       }
     }
   }
   ```

2. Create `NotificationStatisticsPage` with:
   - Success rate display
   - Fail rate display
   - Total notifications sent
   - Invalid tokens count
   - Charts for trends
   - Filters for time period, type, user
   - Use TD widgets and AppStrings

**Expected Results**:
- ✅ Statistics dashboard exists
- ✅ Dashboard displays all statistics
- ✅ Filters work correctly
- ✅ UI uses TD widgets and AppStrings

**Test Criteria**:
- Test: Dashboard displays statistics
- Test: Filters work
- Test: Charts are displayed

---

### Task 9: Add Invalid Token Tracking

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add tracking for invalid tokens in statistics.

**Files to Modify**:
- `lib/core/services/push_notification_service.dart`
- `lib/core/services/notification_statistics_service.dart`

**Implementation Steps**:
1. Track invalid tokens when detected:
   ```dart
   Future<void> _handleInvalidToken(String userId, String token) async {
     try {
       // ... existing cleanup logic ...
       
       // Log invalid token
       await _loggingService.logFailure(
         userId: userId,
         workspaceId: workspaceId,
         notificationType: notificationType,
         error: 'Invalid token',
         errorType: 'invalid_token',
       );
       
       // Track in statistics
       await _statisticsService.trackInvalidToken(
         workspaceId: workspaceId,
         userId: userId,
         token: token,
       );
     } catch (e) {
       Get.log('Failed to track invalid token: $e');
     }
   }
   ```

2. Add invalid token tracking to statistics service:
   ```dart
   Future<void> trackInvalidToken({
     required String workspaceId,
     required String userId,
     required String token,
   }) async {
     try {
       final ref = _database.ref(
         'notification_statistics/$workspaceId/invalid_tokens',
       );
       await ref.push().set({
         'userId': userId,
         'token': token.substring(0, 20) + '...', // Partial token for privacy
         'detectedAt': DateTime.now().millisecondsSinceEpoch,
       });
     } catch (e) {
       Get.log('Failed to track invalid token: $e');
     }
   }
   ```

**Expected Results**:
- ✅ Invalid tokens are tracked
- ✅ Statistics include invalid token count
- ✅ Invalid tokens are logged

**Test Criteria**:
- Test: Invalid tokens are tracked
- Test: Statistics include invalid tokens
- Test: Tracking is logged

---

### Task 10: Add Log Export Functionality

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add functionality to export notification logs.

**Files to Create**:
- `lib/core/services/notification_log_export_service.dart` (new file)

**Implementation Steps**:
1. Create export service:
   ```dart
   class NotificationLogExportService {
     /// Export logs to CSV
     Future<String> exportToCSV({
       required List<NotificationLog> logs,
     }) async {
       // Generate CSV content
       // Return file path
     }
     
     /// Export logs to JSON
     Future<String> exportToJSON({
       required List<NotificationLog> logs,
     }) async {
       // Generate JSON content
       // Return file path
     }
   }
   ```

2. Add export button to statistics page

**Expected Results**:
- ✅ Logs can be exported
- ✅ Multiple formats are supported
- ✅ Export works correctly

**Test Criteria**:
- Test: Export to CSV works
- Test: Export to JSON works
- Test: Exported data is accurate

---

### Task 11: Add Unit Tests

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for notification observation & audit.

**Files to Create**:
- `test/core/services/notification_logging_service_test.dart`
- `test/core/services/notification_statistics_service_test.dart`
- `test/features/notifications/domain/entities/notification_log_test.dart`
- `test/features/notifications/domain/entities/notification_statistics_test.dart`

**Expected Results**:
- ✅ Unit tests cover observation & audit
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Create NotificationLog Entity (Critical - Foundation)
2. **Task 2**: Create NotificationStatistics Entity (Critical - Foundation)
3. **Task 3**: Create NotificationLoggingService (Critical - Core Logic)
4. **Task 4**: Add Notification Log Methods to FirebaseDatabaseService (Critical - Data Layer)
5. **Task 7**: Integrate Logging with Push Notification Service (High Priority - Integration)
6. **Task 5**: Create NotificationStatisticsService (High Priority - Core Logic)
7. **Task 6**: Add Notification Statistics Methods to FirebaseDatabaseService (High Priority - Data Layer)
8. **Task 8**: Create Notification Statistics Dashboard Page (Medium Priority - UI)
9. **Task 9**: Add Invalid Token Tracking (Medium Priority - Feature)
10. **Task 10**: Add Log Export Functionality (Low Priority - Feature)
11. **Task 11**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ NotificationLog entity exists
- ✅ NotificationStatistics entity exists
- ✅ NotificationLoggingService exists
- ✅ All notification sends are logged
- ✅ Statistics are calculated correctly
- ✅ Invalid tokens are tracked
- ✅ Statistics dashboard exists
- ✅ Log export works (optional)
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, SnackbarService, NavigationService)
- ✅ Workspace scoping is enforced
- ✅ No known bugs or issues

---

## Dependencies

- **Firebase Realtime Database**: Required for storing logs and statistics
- **GetX**: Required for state management (project rule)
- **AppStrings**: All text must use AppStrings constants
- **Push Notification Service**: Required for integration (from Notification Main Flow tasks)
- **StorageService**: Required for getting workspace ID

---

## Notes

1. **Logging Performance**: Logging should not block notification sending. Wrap in try-catch and don't throw errors.

2. **Statistics Calculation**: Statistics can be calculated on-demand or cached. Consider caching for performance.

3. **Privacy**: User-specific statistics should only be visible to Admins/Account Holders. Regular users can see aggregate statistics.

4. **Log Retention**: Consider implementing log retention policy (e.g., keep logs for 90 days, then archive or delete).

5. **Real-Time Updates**: Statistics dashboard can use Firebase listeners for real-time updates.

6. **Workspace Scoping**: All logs and statistics should be scoped to workspace for data isolation.

---

## Related Documentation

- `NOTIFICATIONS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `NOTIFICATION_OBSERVATION_AUDIT_TEST_CASES.md` - Test cases for this feature
- `NOTIFICATION_MAIN_FLOW_TASKS.md` - Related push notification tasks
- `docs/v1/feature_checklists/notifications/notifications.md` - Notification requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
