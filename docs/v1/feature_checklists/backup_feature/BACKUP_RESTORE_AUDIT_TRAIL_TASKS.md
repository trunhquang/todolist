# Backup Restore Audit Trail: Restore Logging - Task List & Implementation Steps

## Overview
This document lists all tasks required to implement the **Backup Restore Audit Trail** feature. Currently, this feature is **MISSING** - Not implemented. Restore audit trail should log: who restored (ai khôi phục), from which backup (từ bản nào), and when (thời gian).

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `ActivityLog` entity exists for tasks/projects (but not specifically for restore operations)
- ✅ `WorkspaceAnalytics` exists but is for analytics, not audit logging
- ✅ `BackupService.restoreBackup()` exists but doesn't log restore operations
- ✅ `FirebaseDatabaseService` exists for data operations
- ✅ Some audit logging infrastructure may exist in other features

### What's Missing/Broken:
- ⛔ No restore audit log entity
- ⛔ No restore audit log service
- ⛔ No logging of who restored (user information)
- ⛔ No logging of from which backup (backup file information)
- ⛔ No logging of when restored (timestamp)
- ⛔ No logging of what was restored (restore details)
- ⛔ No logging of failed restore operations
- ⛔ No audit log viewing UI
- ⛔ No audit log filtering/search
- ⛔ No audit log export functionality

---

## Task List

### Task 1: Create Restore Audit Log Entity

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 1-2 hours

**Description**:
Create entity to represent restore audit log entries. This entity should store all information about restore operations: who restored, from which backup, when, and what was restored.

**Files to Create**:
- `lib/features/backup/domain/entities/restore_audit_log.dart` (new file)

**Dependencies**:
- None

**Implementation Steps**:

1. **Create RestoreAuditLog entity**:
   ```dart
   // lib/features/backup/domain/entities/restore_audit_log.dart
   import 'package:meta/meta.dart';
   
   /// Audit log entry for restore operations
   @immutable
   class RestoreAuditLog {
     const RestoreAuditLog({
       required this.id,
       required this.workspaceId,
       required this.userId,
       required this.userName,
       required this.userEmail,
       required this.userRole,
       required this.backupFileId,
       required this.backupFileName,
       required this.backupDate,
       required this.backupWorkspaceId,
       required this.backupType,
       required this.timestamp,
       required this.status, // 'success', 'failed', 'partial'
       this.restoreDetails,
       this.errorMessage,
       this.errorCode,
     });
     
     factory RestoreAuditLog.fromMap(Map<String, dynamic> map) {
       return RestoreAuditLog(
         id: map['id']?.toString() ?? '',
         workspaceId: map['workspaceId']?.toString() ?? '',
         userId: map['userId']?.toString() ?? '',
         userName: map['userName']?.toString() ?? '',
         userEmail: map['userEmail']?.toString(),
         userRole: map['userRole']?.toString() ?? '',
         backupFileId: map['backupFileId']?.toString() ?? '',
         backupFileName: map['backupFileName']?.toString() ?? '',
         backupDate: map['backupDate'] != null
             ? DateTime.parse(map['backupDate'] as String)
             : DateTime.now(),
         backupWorkspaceId: map['backupWorkspaceId']?.toString() ?? '',
         backupType: map['backupType']?.toString() ?? 'complete',
         timestamp: map['timestamp'] != null
             ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int)
             : DateTime.now(),
         status: map['status']?.toString() ?? 'success',
         restoreDetails: map['restoreDetails'] is Map<String, dynamic>
             ? Map<String, dynamic>.from(map['restoreDetails'] as Map<String, dynamic>)
             : null,
         errorMessage: map['errorMessage']?.toString(),
         errorCode: map['errorCode']?.toString(),
       );
     }
     
     final String id;
     final String workspaceId;
     
     // Who restored
     final String userId;
     final String userName;
     final String? userEmail;
     final String userRole; // 'account_holder', 'admin', 'member'
     
     // From which backup
     final String backupFileId;
     final String backupFileName;
     final DateTime backupDate;
     final String backupWorkspaceId;
     final String backupType; // 'complete', 'partial', 'selective'
     
     // When restored
     final DateTime timestamp;
     
     // Status and details
     final String status; // 'success', 'failed', 'partial'
     final Map<String, dynamic>? restoreDetails; // What was restored
     final String? errorMessage;
     final String? errorCode;
     
     Map<String, dynamic> toMap() {
       return {
         'id': id,
         'workspaceId': workspaceId,
         'userId': userId,
         'userName': userName,
         'userEmail': userEmail,
         'userRole': userRole,
         'backupFileId': backupFileId,
         'backupFileName': backupFileName,
         'backupDate': backupDate.toIso8601String(),
         'backupWorkspaceId': backupWorkspaceId,
         'backupType': backupType,
         'timestamp': timestamp.millisecondsSinceEpoch,
         'status': status,
         'restoreDetails': restoreDetails,
         'errorMessage': errorMessage,
         'errorCode': errorCode,
       };
     }
     
     RestoreAuditLog copyWith({
       String? id,
       String? workspaceId,
       String? userId,
       String? userName,
       String? userEmail,
       String? userRole,
       String? backupFileId,
       String? backupFileName,
       DateTime? backupDate,
       String? backupWorkspaceId,
       String? backupType,
       DateTime? timestamp,
       String? status,
       Map<String, dynamic>? restoreDetails,
       String? errorMessage,
       String? errorCode,
     }) {
       return RestoreAuditLog(
         id: id ?? this.id,
         workspaceId: workspaceId ?? this.workspaceId,
         userId: userId ?? this.userId,
         userName: userName ?? this.userName,
         userEmail: userEmail ?? this.userEmail,
         userRole: userRole ?? this.userRole,
         backupFileId: backupFileId ?? this.backupFileId,
         backupFileName: backupFileName ?? this.backupFileName,
         backupDate: backupDate ?? this.backupDate,
         backupWorkspaceId: backupWorkspaceId ?? this.backupWorkspaceId,
         backupType: backupType ?? this.backupType,
         timestamp: timestamp ?? this.timestamp,
         status: status ?? this.status,
         restoreDetails: restoreDetails ?? this.restoreDetails,
         errorMessage: errorMessage ?? this.errorMessage,
         errorCode: errorCode ?? this.errorCode,
       );
     }
   }
   ```

2. **Add helper methods**:
   ```dart
   /// Get display text for restore status
   String getStatusDisplayText() {
     switch (status) {
       case 'success':
         return 'Success';
       case 'failed':
         return 'Failed';
       case 'partial':
         return 'Partial';
       default:
         return status;
     }
   }
   
   /// Get formatted timestamp for display
   String getFormattedTimestamp() {
     return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}';
   }
   
   /// Check if restore was successful
   bool get isSuccessful => status == 'success';
   
   /// Check if restore failed
   bool get isFailed => status == 'failed';
   ```

**Expected Results**:
- ✅ RestoreAuditLog entity exists
- ✅ Entity stores all required information (who, from which backup, when, what)
- ✅ Entity can be serialized/deserialized
- ✅ Entity has helper methods for display

**Testing**:
- Test entity creation
- Test serialization/deserialization
- Test helper methods
- Verify all required fields are present

---

### Task 2: Create Restore Audit Log Service

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Create service for logging restore operations to audit trail. This service should log who restored, from which backup, when, and what was restored.

**Files to Create/Modify**:
- `lib/core/services/restore_audit_log_service.dart` (new file)
- `lib/core/services/backup_service.dart` (integrate audit logging)

**Dependencies**:
- Task 1 (RestoreAuditLog entity)
- `FirebaseDatabaseService` for storing audit logs
- `StorageService` for getting current user information

**Implementation Steps**:

1. **Create RestoreAuditLogService**:
   ```dart
   // lib/core/services/restore_audit_log_service.dart
   import 'package:get/get.dart';
   import '../services/storage_service.dart';
   import '../services/firebase_database_service.dart';
   import '../../features/backup/domain/entities/restore_audit_log.dart';
   
   class RestoreAuditLogService {
     factory RestoreAuditLogService() => _instance ??= RestoreAuditLogService._();
     RestoreAuditLogService._();
     static RestoreAuditLogService? _instance;
     
     final StorageService _storage = StorageService();
     final FirebaseDatabaseService _db = FirebaseDatabaseService.instance;
     
     /// Log restore operation
     Future<void> logRestore({
       required String workspaceId,
       required String backupFileId,
       required String backupFileName,
       required DateTime backupDate,
       required String backupWorkspaceId,
       required String backupType,
       required Map<String, dynamic> restoreDetails,
       String? userId,
       String? userName,
       String? userEmail,
       String? userRole,
       String status = 'success',
       String? errorMessage,
       String? errorCode,
     }) async {
       try {
         // Get user information if not provided
         final currentUserId = userId ?? _storage.getUserId() ?? '';
         final currentUserName = userName ?? _storage.getString('user_name') ?? 'Unknown';
         final currentUserEmail = userEmail ?? _storage.getString('user_email');
         
         // Get user role if not provided
         String? currentUserRole = userRole;
         if (currentUserRole == null) {
           // Get user role from workspace (if available)
           // This may require calling WorkspaceRepository
           currentUserRole = 'unknown';
         }
         
         // Create audit log entry
         final logEntry = RestoreAuditLog(
           id: _generateLogId(),
           workspaceId: workspaceId,
           userId: currentUserId,
           userName: currentUserName,
           userEmail: currentUserEmail,
           userRole: currentUserRole,
           backupFileId: backupFileId,
           backupFileName: backupFileName,
           backupDate: backupDate,
           backupWorkspaceId: backupWorkspaceId,
           backupType: backupType,
           timestamp: DateTime.now(),
           status: status,
           restoreDetails: restoreDetails,
           errorMessage: errorMessage,
           errorCode: errorCode,
         );
         
         // Save to Firebase
         await _saveAuditLog(workspaceId, logEntry);
         
         Get.log('Restore audit log created: ${logEntry.id}');
       } catch (e) {
         Get.log('ERROR: Failed to log restore operation: $e');
         // Don't throw - logging failure shouldn't break restore
       }
     }
     
     /// Generate unique log ID
     String _generateLogId() {
       return 'restore_${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(6)}';
     }
     
     String _generateRandomString(int length) {
       const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
       return List.generate(length, (_) => chars[DateTime.now().millisecondsSinceEpoch % chars.length]).join();
     }
     
     /// Save audit log to Firebase
     Future<void> _saveAuditLog(String workspaceId, RestoreAuditLog logEntry) async {
       try {
         final logRef = _db.database.ref('workspaces/$workspaceId/audit_logs/restore/${logEntry.id}');
         await logRef.set(logEntry.toMap());
       } catch (e) {
         Get.log('ERROR: Failed to save restore audit log: $e');
         rethrow;
       }
     }
     
     /// Get restore audit logs for workspace
     Future<List<RestoreAuditLog>> getRestoreAuditLogs({
       required String workspaceId,
       DateTime? startDate,
       DateTime? endDate,
       String? userId,
       String? status,
       int? limit,
     }) async {
       try {
         final logRef = _db.database.ref('workspaces/$workspaceId/audit_logs/restore');
         
         // Apply filters
         Query query = logRef.orderByChild('timestamp');
         
         if (startDate != null) {
           query = query.startAt(startDate.millisecondsSinceEpoch);
         }
         
         if (endDate != null) {
           query = query.endAt(endDate.millisecondsSinceEpoch);
         }
         
         if (limit != null) {
           query = query.limitToLast(limit);
         }
         
         final snapshot = await query.get();
         
         if (!snapshot.exists) return [];
         
         final data = snapshot.value as Map<dynamic, dynamic>?;
         if (data == null) return [];
         
         final logs = <RestoreAuditLog>[];
         
         for (final entry in data.entries) {
           try {
             final logData = Map<String, dynamic>.from(entry.value as Map<dynamic, dynamic>);
             final log = RestoreAuditLog.fromMap(logData);
             
             // Apply additional filters
             if (userId != null && log.userId != userId) continue;
             if (status != null && log.status != status) continue;
             
             logs.add(log);
           } catch (e) {
             Get.log('ERROR: Failed to parse restore audit log: $e');
             // Continue with other logs
           }
         }
         
         // Sort by timestamp (most recent first)
         logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
         
         return logs;
       } catch (e) {
         Get.log('ERROR: Failed to get restore audit logs: $e');
         return [];
       }
     }
   }
   ```

2. **Add method to get user role**:
   ```dart
   /// Get user role in workspace
   Future<String> _getUserRole(String userId, String workspaceId) async {
     try {
       // Get workspace repository
       final workspaceRepo = Get.find<WorkspaceRepository>();
       
       final result = await workspaceRepo.getUserWorkspaceRole(userId, workspaceId);
       
       return result.fold(
         (failure) => 'unknown',
         (member) => member?.role.toString().toLowerCase() ?? 'unknown',
       );
     } catch (e) {
       Get.log('ERROR: Failed to get user role: $e');
       return 'unknown';
     }
   }
   ```

**Expected Results**:
- ✅ RestoreAuditLogService exists
- ✅ Service can log restore operations
- ✅ Service can retrieve restore audit logs
- ✅ Service handles errors gracefully
- ✅ Service doesn't break restore if logging fails

**Testing**:
- Test logging successful restore
- Test logging failed restore
- Test retrieving audit logs
- Test filtering audit logs
- Test error handling

---

### Task 3: Integrate Audit Logging with Restore Operations

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Integrate restore audit logging with restore operations in BackupService. Log restore operations before, during, and after restore.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Dependencies**:
- Task 1 (RestoreAuditLog entity)
- Task 2 (RestoreAuditLogService)
- Restore operations from BACKUP_RESTORE_TASKS.md

**Implementation Steps**:

1. **Add RestoreAuditLogService to BackupService**:
   ```dart
   // In lib/core/services/backup_service.dart
   import 'restore_audit_log_service.dart';
   
   class BackupService {
     final RestoreAuditLogService _auditLogService = RestoreAuditLogService();
     
     // ... existing code ...
   }
   ```

2. **Add audit logging to restore method**:
   ```dart
   Future<void> restoreBackup({
     required String fileId,
     String? workspaceId,
     bool restoreWorkspace = true,
     bool restoreProjects = true,
     bool restoreTasks = true,
     bool restoreMembers = false,
   }) async {
     final userId = _storage.getUserId() ?? '';
     final targetWorkspaceId = workspaceId ?? _storage.getWorkspaceId() ?? '';
     
     // ... permission check and validation ...
     
     // Get backup file info
     final backupData = await _oneDrive.restoreAppData(fileId);
     final backupFiles = await listBackups();
     final backupFile = backupFiles.firstWhere(
       (file) => file['id'] == fileId,
       orElse: () => {},
     );
     
     final backupFileName = backupFile['name']?.toString() ?? 'unknown';
     final backupDate = DateTime.tryParse(
       backupData['exportedAt']?.toString() ?? '',
     ) ?? DateTime.now();
     final backupWorkspaceId = backupData['workspaceId']?.toString() ?? '';
     final backupType = backupData['type']?.toString() ?? 'complete';
     
     // Prepare restore details
     final restoreDetails = {
       'workspaceRestored': restoreWorkspace,
       'projectsRestored': restoreProjects ? (backupData['projects'] as List?)?.length ?? 0 : 0,
       'tasksRestored': restoreTasks ? (backupData['tasks'] as List?)?.length ?? 0 : 0,
       'membersRestored': restoreMembers,
       'membersRestoredCount': restoreMembers ? (backupData['members'] as List?)?.length ?? 0 : 0,
       'restoreType': restoreWorkspace && restoreProjects && restoreTasks ? 'complete' : 'selective',
     };
     
     // Get user information
     final userName = _storage.getString('user_name') ?? 'Unknown';
     final userEmail = _storage.getString('user_email');
     final userRole = await _getUserRole(userId, targetWorkspaceId);
     
     String? errorMessage;
     String? errorCode;
     String status = 'success';
     
     try {
       // Perform restore...
       await _restoreWorkspace(backupData, targetWorkspaceId);
       await _restoreProjects(backupData, targetWorkspaceId);
       await _restoreTasks(backupData, targetWorkspaceId);
       if (restoreMembers) {
         await _restoreMembers(backupData, targetWorkspaceId);
       }
       
       // Update restore details with actual counts
       restoreDetails['projectsRestored'] = (backupData['projects'] as List?)?.length ?? 0;
       restoreDetails['tasksRestored'] = (backupData['tasks'] as List?)?.length ?? 0;
       
       Get.log('Restore completed successfully');
     } catch (e) {
       status = 'failed';
       errorMessage = e.toString();
       errorCode = e is Failure ? e.runtimeType.toString() : 'UnknownError';
       Get.log('ERROR: Restore failed: $e');
       rethrow;
     } finally {
       // Log restore operation (always log, even if restore failed)
       await _auditLogService.logRestore(
         workspaceId: targetWorkspaceId,
         backupFileId: fileId,
         backupFileName: backupFileName,
         backupDate: backupDate,
         backupWorkspaceId: backupWorkspaceId,
         backupType: backupType,
         restoreDetails: restoreDetails,
         userId: userId,
         userName: userName,
         userEmail: userEmail,
         userRole: userRole,
         status: status,
         errorMessage: errorMessage,
         errorCode: errorCode,
       );
     }
   }
   ```

3. **Add helper method to get user role**:
   ```dart
   /// Get user role in workspace
   Future<String> _getUserRole(String userId, String workspaceId) async {
     try {
       final workspaceRepo = Get.find<WorkspaceRepository>();
       final result = await workspaceRepo.getUserWorkspaceRole(userId, workspaceId);
       
       return result.fold(
         (failure) => 'unknown',
         (member) => member?.role.toString().toLowerCase() ?? 'unknown',
       );
     } catch (e) {
       Get.log('ERROR: Failed to get user role: $e');
       return 'unknown';
     }
   }
   ```

**Expected Results**:
- ✅ Audit logging is integrated with restore operations
- ✅ Restore operations are logged before, during, and after restore
- ✅ Successful restores are logged
- ✅ Failed restores are logged with error information
- ✅ Logging doesn't break restore if it fails

**Testing**:
- Test logging successful restore
- Test logging failed restore
- Test logging partial restore
- Test logging doesn't break restore
- Verify log entries are created correctly

---

### Task 4: Create Restore Audit Log Repository

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Create repository for restore audit logs following Clean Architecture pattern. This provides abstraction for data access.

**Files to Create**:
- `lib/features/backup/domain/repositories/restore_audit_log_repository.dart` (interface)
- `lib/features/backup/data/repositories/restore_audit_log_repository_impl.dart` (implementation)

**Dependencies**:
- Task 1 (RestoreAuditLog entity)
- `FirebaseDatabaseService`

**Implementation Steps**:

1. **Create repository interface**:
   ```dart
   // lib/features/backup/domain/repositories/restore_audit_log_repository.dart
   import 'package:dartz/dartz.dart';
   import '../../../../core/errors/failures.dart';
   import '../entities/restore_audit_log.dart';
   
   abstract class RestoreAuditLogRepository {
     /// Create restore audit log entry
     Future<Either<Failure, void>> createLog(RestoreAuditLog log);
     
     /// Get restore audit logs for workspace
     Future<Either<Failure, List<RestoreAuditLog>>> getLogs({
       required String workspaceId,
       DateTime? startDate,
       DateTime? endDate,
       String? userId,
       String? status,
       int? limit,
     });
     
     /// Get restore audit log by ID
     Future<Either<Failure, RestoreAuditLog?>> getLogById(String workspaceId, String logId);
   }
   ```

2. **Create repository implementation**:
   ```dart
   // lib/features/backup/data/repositories/restore_audit_log_repository_impl.dart
   import 'package:dartz/dartz.dart';
   import 'package:get/get.dart';
   import '../../../../core/errors/failures.dart';
   import '../../../../core/services/firebase_database_service.dart';
   import '../../domain/entities/restore_audit_log.dart';
   import '../../domain/repositories/restore_audit_log_repository.dart';
   
   class RestoreAuditLogRepositoryImpl implements RestoreAuditLogRepository {
     RestoreAuditLogRepositoryImpl({
       FirebaseDatabaseService? databaseService,
     }) : _databaseService = databaseService ?? Get.find<FirebaseDatabaseService>();
     
     final FirebaseDatabaseService _databaseService;
     
     @override
     Future<Either<Failure, void>> createLog(RestoreAuditLog log) async {
       try {
         final logRef = _databaseService.database.ref(
           'workspaces/${log.workspaceId}/audit_logs/restore/${log.id}',
         );
         await logRef.set(log.toMap());
         return const Right(null);
       } catch (e) {
         return Left(UnknownFailure(message: 'Failed to create restore audit log: $e'));
       }
     }
     
     @override
     Future<Either<Failure, List<RestoreAuditLog>>> getLogs({
       required String workspaceId,
       DateTime? startDate,
       DateTime? endDate,
       String? userId,
       String? status,
       int? limit,
     }) async {
       try {
         // Implementation similar to RestoreAuditLogService.getRestoreAuditLogs
         // ... (code from Task 2)
       } catch (e) {
         return Left(UnknownFailure(message: 'Failed to get restore audit logs: $e'));
       }
     }
     
     @override
     Future<Either<Failure, RestoreAuditLog?>> getLogById(String workspaceId, String logId) async {
       try {
         final logRef = _databaseService.database.ref(
           'workspaces/$workspaceId/audit_logs/restore/$logId',
         );
         final snapshot = await logRef.get();
         
         if (!snapshot.exists) {
           return const Right(null);
         }
         
         final data = snapshot.value as Map<dynamic, dynamic>?;
         if (data == null) {
           return const Right(null);
         }
         
         final log = RestoreAuditLog.fromMap(Map<String, dynamic>.from(data));
         return Right(log);
       } catch (e) {
         return Left(UnknownFailure(message: 'Failed to get restore audit log: $e'));
       }
     }
   }
   ```

**Expected Results**:
- ✅ RestoreAuditLogRepository interface exists
- ✅ RestoreAuditLogRepositoryImpl implementation exists
- ✅ Repository follows Clean Architecture pattern
- ✅ Repository provides abstraction for data access

**Testing**:
- Test repository methods
- Test error handling
- Test data access abstraction

---

### Task 5: Create Restore Audit Log UI

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 4-5 hours

**Description**:
Create UI for viewing restore audit logs. This should display who restored, from which backup, when, and what was restored.

**Files to Create/Modify**:
- `lib/app/pages/backup/restore_audit_log_page.dart` (new file)
- `lib/core/controllers/restore_audit_log_controller.dart` (new file)
- `lib/app/routes/app_router.dart` (add route)

**Dependencies**:
- Task 2 (RestoreAuditLogService)
- Task 4 (RestoreAuditLogRepository)

**Implementation Steps**:

1. **Create RestoreAuditLogController**:
   ```dart
   // lib/core/controllers/restore_audit_log_controller.dart
   import 'package:get/get.dart';
   import '../services/restore_audit_log_service.dart';
   import '../../features/backup/domain/entities/restore_audit_log.dart';
   import '../services/storage_service.dart';
   
   class RestoreAuditLogController extends GetxController {
     final RestoreAuditLogService _auditLogService = RestoreAuditLogService();
     final StorageService _storage = StorageService();
     
     final RxList<RestoreAuditLog> _logs = <RestoreAuditLog>[].obs;
     final RxBool _isLoading = false.obs;
     final RxString _errorMessage = ''.obs;
     
     List<RestoreAuditLog> get logs => _logs;
     bool get isLoading => _isLoading.value;
     String get errorMessage => _errorMessage.value;
     
     @override
     void onInit() {
       super.onInit();
       loadLogs();
     }
     
     Future<void> loadLogs() async {
       _isLoading.value = true;
       _errorMessage.value = '';
       
       try {
         final workspaceId = _storage.getWorkspaceId() ?? '';
         if (workspaceId.isEmpty) {
           _errorMessage.value = 'No workspace selected';
           return;
         }
         
         final logs = await _auditLogService.getRestoreAuditLogs(
           workspaceId: workspaceId,
           limit: 100,
         );
         
         _logs.value = logs;
       } catch (e) {
         _errorMessage.value = 'Failed to load audit logs: $e';
       } finally {
         _isLoading.value = false;
       }
     }
     
     Future<void> filterLogs({
       DateTime? startDate,
       DateTime? endDate,
       String? userId,
       String? status,
     }) async {
       _isLoading.value = true;
       _errorMessage.value = '';
       
       try {
         final workspaceId = _storage.getWorkspaceId() ?? '';
         if (workspaceId.isEmpty) {
           _errorMessage.value = 'No workspace selected';
           return;
         }
         
         final logs = await _auditLogService.getRestoreAuditLogs(
           workspaceId: workspaceId,
           startDate: startDate,
           endDate: endDate,
           userId: userId,
           status: status,
         );
         
         _logs.value = logs;
       } catch (e) {
         _errorMessage.value = 'Failed to filter audit logs: $e';
       } finally {
         _isLoading.value = false;
       }
     }
   }
   ```

2. **Create RestoreAuditLogPage UI**:
   ```dart
   // lib/app/pages/backup/restore_audit_log_page.dart
   // Implementation with list of restore audit logs
   // Display: who, from which backup, when, what was restored
   // Include filtering and search
   ```

**Expected Results**:
- ✅ RestoreAuditLogController exists
- ✅ RestoreAuditLogPage UI exists
- ✅ UI displays restore audit logs
- ✅ UI supports filtering and search
- ✅ UI is user-friendly and accessible

**Testing**:
- Test UI displays logs correctly
- Test filtering works
- Test search works
- Test UI is responsive

---

## Summary

### Implementation Order:
1. **Task 1**: Create Restore Audit Log Entity
2. **Task 2**: Create Restore Audit Log Service
3. **Task 3**: Integrate Audit Logging with Restore Operations
4. **Task 4**: Create Restore Audit Log Repository
5. **Task 5**: Create Restore Audit Log UI

### Estimated Total Time: 11-15 hours

### Dependencies:
- Task 1 is independent
- Task 2 depends on Task 1
- Task 3 depends on Tasks 1 and 2
- Task 4 depends on Task 1
- Task 5 depends on Tasks 2 and 4

### Testing Requirements:
- Unit tests for RestoreAuditLog entity
- Unit tests for RestoreAuditLogService
- Unit tests for repository
- Integration tests for audit logging with restore
- Manual testing for UI

### Success Criteria:
- ✅ Restore operations are logged with complete information
- ✅ Who restored is logged (user ID, name, role)
- ✅ From which backup is logged (backup file ID, name, date)
- ✅ When restored is logged (timestamp)
- ✅ What was restored is logged (details)
- ✅ Failed restores are logged with error information
- ✅ Audit logs can be viewed in UI
- ✅ Audit logs can be filtered and searched

### Security and Compliance Considerations:
- **Critical**: Audit logs must be tamper-proof (read-only after creation)
- Audit logs must be accessible to Account Holders and Admins only
- Audit logs should be retained for compliance requirements
- Audit logs should be exportable for compliance reporting
