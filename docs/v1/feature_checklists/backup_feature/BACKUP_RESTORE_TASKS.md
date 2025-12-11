# Backup Restore: Workspace/Project Restore with Permission Checks - Task List & Implementation Steps

## Overview
This document lists all tasks required to implement the **Backup Restore** feature. Currently, this feature is **MISSING** - Not implemented; no restore flows, no audit trail. The `restoreBackup()` method only downloads and parses backup file, but does not implement actual restore logic, permission checks, or audit trail.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `BackupService.restoreBackup()` exists but only downloads and parses backup file
- ✅ `OneDriveService.restoreAppData()` exists and can download backup file
- ✅ `BackupController.restoreBackup()` exists but calls empty restore logic
- ✅ `AccessControlService` exists for permission checks
- ✅ `PermissionService` exists for permission validation
- ✅ `WorkspaceRepository` exists for workspace operations
- ✅ Data models exist: `TaskEntity`, `Project`, `Workspace`, `WorkspaceMember`

### What's Missing/Broken:
- ⛔ No restore permission checks (Account Holder/Admin only)
- ⛔ No actual restore logic (only downloads backup file)
- ⛔ No workspace restore implementation
- ⛔ No project restore implementation
- ⛔ No task restore implementation
- ⛔ No restore validation (backup file format, workspace match)
- ⛔ No conflict resolution
- ⛔ No restore audit trail
- ⛔ No error handling for restore failures
- ⛔ No restore confirmation dialogs
- ⛔ No restore progress tracking

---

## Task List

### Task 1: Add Restore Permission Checks

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Add permission checks to ensure only Account Holder and Admin can restore backups. This is critical for security.

**Files to Modify**:
- `lib/core/services/backup_service.dart`
- `lib/core/controllers/backup_controller.dart`

**Dependencies**:
- `AccessControlService` or `PermissionService`
- `WorkspaceRepository` for getting user role

**Implementation Steps**:

1. **Add permission check method to BackupService**:
   ```dart
   /// Check if user can perform restore operations
   Future<bool> canPerformRestore(String userId, String workspaceId) async {
     try {
       // Get workspace repository
       final workspaceRepo = Get.find<WorkspaceRepository>();
       
       // Get user's role in workspace
       final result = await workspaceRepo.getUserWorkspaceRole(userId, workspaceId);
       
       return result.fold(
         (failure) {
           Get.log('Failed to check restore permission: ${failure.message}');
           return false;
         },
         (member) {
           if (member == null) return false;
           
           // Only Account Holder and Admin can restore
           final role = member.role.toString().toLowerCase();
           return role == 'account_holder' || role == 'admin';
         },
       );
     } catch (e) {
       Get.log('Error checking restore permission: $e');
       return false;
     }
   }
   ```

2. **Add permission check to restore method**:
   ```dart
   /// Restore workspace/project from backup
   Future<void> restoreBackup({
     required String fileId,
     String? workspaceId, // Optional: restore to specific workspace
     bool restoreWorkspace = true,
     bool restoreProjects = true,
     bool restoreTasks = true,
     bool restoreMembers = false,
   }) async {
     final userId = _storage.getUserId();
     final targetWorkspaceId = workspaceId ?? _storage.getWorkspaceId();
     
     if (userId == null || targetWorkspaceId == null || targetWorkspaceId.isEmpty) {
       throw const UnknownFailure(message: 'User or workspace not found');
     }
     
     // Check permission before restore
     final canRestore = await canPerformRestore(userId, targetWorkspaceId);
     if (!canRestore) {
       throw const PermissionFailure(
         message: 'Only Account Holder and Admin can restore backups',
       );
     }
     
     // Continue with restore...
   }
   ```

3. **Add permission check to BackupController**:
   ```dart
   /// Restore backup from OneDrive
   Future<void> restoreBackup(String fileId) async {
     final userId = _storageService.getUserId();
     final workspaceId = _storageService.getWorkspaceId();
     
     if (userId == null || workspaceId == null) {
       SnackbarService().showError(
         title: AppStrings.error,
         message: AppStrings.userOrWorkspaceNotFound,
       );
       return;
     }
     
     // Check permission before showing restore UI
     try {
       final canRestore = await _backupService.canPerformRestore(userId, workspaceId);
       if (!canRestore) {
         SnackbarService().showError(
           title: AppStrings.error,
           message: AppStrings.permissionDenied,
         );
         return;
       }
     } catch (e) {
       SnackbarService().showError(
         title: AppStrings.error,
         message: 'Failed to check restore permission: $e',
       );
       return;
     }
     
     // Continue with restore...
   }
   ```

4. **Add AppStrings constants**:
   ```dart
   // In app_strings.dart
   static const String permissionDenied = 'Permission Denied';
   static const String userOrWorkspaceNotFound = 'User or workspace not found';
   static const String onlyAccountHolderAdminCanRestore = 'Only Account Holder and Admin can restore backups';
   ```

**Expected Results**:
- ✅ Permission checks are performed before restore
- ✅ Only Account Holder and Admin can restore
- ✅ Members are blocked from restoring
- ✅ Clear error messages are shown for permission denials

**Testing**:
- Test with Account Holder (should pass)
- Test with Admin (should pass)
- Test with Member (should fail)
- Test with invalid user/workspace (should fail)
- Verify error messages are clear

---

### Task 2: Implement Backup File Validation

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Implement validation to check backup file format, structure, and integrity before restoring.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Dependencies**:
- Backup file structure from backup implementation

**Implementation Steps**:

1. **Add backup file validation method**:
   ```dart
   /// Validate backup file format and structure
   bool _validateBackupFile(Map<String, dynamic> backupData) {
     try {
       // Check required top-level fields
       if (!backupData.containsKey('workspaceId')) {
         Get.log('ERROR: Backup file missing workspaceId');
         return false;
       }
       
       if (!backupData.containsKey('exportedAt')) {
         Get.log('ERROR: Backup file missing exportedAt');
         return false;
       }
       
       if (!backupData.containsKey('type')) {
         Get.log('ERROR: Backup file missing type');
         return false;
       }
       
       if (!backupData.containsKey('version')) {
         Get.log('ERROR: Backup file missing version');
         return false;
       }
       
       // Validate exportedAt is valid ISO 8601 string
       try {
         DateTime.parse(backupData['exportedAt'] as String);
       } catch (e) {
         Get.log('ERROR: Backup file exportedAt is invalid: $e');
         return false;
       }
       
       // Validate version compatibility
       final version = backupData['version']?.toString() ?? '';
       if (version != '1.0') {
         Get.log('WARNING: Backup file version mismatch: $version vs 1.0');
         // Don't fail, but log warning
       }
       
       // Validate data sections exist (at least one)
       final hasWorkspace = backupData.containsKey('workspace');
       final hasTasks = backupData.containsKey('tasks') && backupData['tasks'] is List;
       final hasProjects = backupData.containsKey('projects') && backupData['projects'] is List;
       
       if (!hasWorkspace && !hasTasks && !hasProjects) {
         Get.log('ERROR: Backup file has no data sections');
         return false;
       }
       
       Get.log('Backup file validation passed');
       return true;
     } catch (e) {
       Get.log('ERROR: Backup file validation failed: $e');
       return false;
     }
   }
   ```

2. **Add workspace ID validation**:
   ```dart
   /// Validate backup workspace ID matches target workspace
   bool _validateWorkspaceMatch(
     Map<String, dynamic> backupData,
     String targetWorkspaceId,
     bool allowMismatch,
   ) {
     final backupWorkspaceId = backupData['workspaceId']?.toString() ?? '';
     
     if (backupWorkspaceId.isEmpty) {
       Get.log('ERROR: Backup file has empty workspaceId');
       return false;
     }
     
     if (backupWorkspaceId != targetWorkspaceId) {
       if (allowMismatch) {
         Get.log('WARNING: Backup workspace ID mismatch: $backupWorkspaceId vs $targetWorkspaceId');
         return true; // Allow mismatch if explicitly allowed
       } else {
         Get.log('ERROR: Backup workspace ID mismatch: $backupWorkspaceId vs $targetWorkspaceId');
         return false;
       }
     }
     
     return true;
   }
   ```

3. **Add data integrity validation**:
   ```dart
   /// Validate backup data integrity
   bool _validateBackupDataIntegrity(Map<String, dynamic> backupData) {
     try {
       // Validate tasks
       if (backupData['tasks'] is List) {
         final tasks = backupData['tasks'] as List;
         for (final task in tasks) {
           if (task is! Map<String, dynamic>) {
             Get.log('ERROR: Invalid task format in backup');
             return false;
           }
           
           // Check required task fields
           if (!task.containsKey('id') || !task.containsKey('workspaceId')) {
             Get.log('ERROR: Task missing required fields');
             return false;
           }
         }
       }
       
       // Validate projects
       if (backupData['projects'] is List) {
         final projects = backupData['projects'] as List;
         for (final project in projects) {
           if (project is! Map<String, dynamic>) {
             Get.log('ERROR: Invalid project format in backup');
             return false;
           }
           
           // Check required project fields
           if (!project.containsKey('id') || !project.containsKey('workspaceId')) {
             Get.log('ERROR: Project missing required fields');
             return false;
           }
         }
       }
       
       // Validate workspace
       if (backupData['workspace'] is Map<String, dynamic>) {
         final workspace = backupData['workspace'] as Map<String, dynamic>;
         if (!workspace.containsKey('id')) {
           Get.log('ERROR: Workspace missing required fields');
           return false;
         }
       }
       
       return true;
     } catch (e) {
       Get.log('ERROR: Backup data integrity validation failed: $e');
       return false;
     }
   }
   ```

4. **Add validation to restore method**:
   ```dart
   Future<void> restoreBackup({
     required String fileId,
     String? workspaceId,
     bool allowWorkspaceMismatch = false,
   }) async {
     // ... permission check ...
     
     // Download and parse backup file
     final backupData = await _oneDrive.restoreAppData(fileId);
     
     // Validate backup file
     if (!_validateBackupFile(backupData)) {
       throw const UnknownFailure(message: 'Invalid backup file format');
     }
     
     // Validate workspace match
     final targetWorkspaceId = workspaceId ?? _storage.getWorkspaceId() ?? '';
     if (!_validateWorkspaceMatch(backupData, targetWorkspaceId, allowWorkspaceMismatch)) {
       throw const UnknownFailure(message: 'Backup workspace ID mismatch');
     }
     
     // Validate data integrity
     if (!_validateBackupDataIntegrity(backupData)) {
       throw const UnknownFailure(message: 'Backup data integrity validation failed');
     }
     
     // Continue with restore...
   }
   ```

**Expected Results**:
- ✅ Backup file format is validated
- ✅ Backup file structure is validated
- ✅ Workspace ID match is validated
- ✅ Data integrity is validated
- ✅ Clear error messages for validation failures

**Testing**:
- Test with valid backup file (should pass)
- Test with invalid backup file format (should fail)
- Test with missing required fields (should fail)
- Test with workspace ID mismatch (should fail or warn)
- Test with corrupted data (should fail)

---

### Task 3: Implement Workspace Restore Logic

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 4-5 hours

**Description**:
Implement logic to restore workspace data (workspace settings, projects, tasks, members) from backup file.

**Files to Modify**:
- `lib/core/services/backup_service.dart`

**Dependencies**:
- Task 1 (permission checks)
- Task 2 (backup file validation)
- `WorkspaceRepository` for workspace operations
- `FirebaseDatabaseService` for data operations

**Implementation Steps**:

1. **Add workspace restore method**:
   ```dart
   /// Restore workspace from backup
   Future<void> _restoreWorkspace(
     Map<String, dynamic> backupData,
     String targetWorkspaceId,
   ) async {
     try {
       final workspaceRepo = Get.find<WorkspaceRepository>();
       final workspaceData = backupData['workspace'] as Map<String, dynamic>?;
       
       if (workspaceData == null) {
         Get.log('WARNING: No workspace data in backup');
         return;
       }
       
       // Get current workspace
       final currentWorkspaceResult = await workspaceRepo.getWorkspace(targetWorkspaceId);
       
       await currentWorkspaceResult.fold(
         (failure) async {
           Get.log('ERROR: Failed to get current workspace: ${failure.message}');
           throw failure;
         },
         (currentWorkspace) async {
           // Update workspace with backup data
           final restoredWorkspace = Workspace.fromMap({
             ...currentWorkspace.toMap(),
             ...workspaceData,
             'id': targetWorkspaceId, // Ensure ID matches target workspace
           });
           
           // Update workspace
           final updateResult = await workspaceRepo.updateWorkspace(restoredWorkspace);
           
           updateResult.fold(
             (failure) {
               Get.log('ERROR: Failed to restore workspace: ${failure.message}');
               throw failure;
             },
             (_) {
               Get.log('Workspace restored successfully');
             },
           );
         },
       );
     } catch (e) {
       Get.log('ERROR: Workspace restore failed: $e');
       rethrow;
     }
   }
   ```

2. **Add projects restore method**:
   ```dart
   /// Restore projects from backup
   Future<void> _restoreProjects(
     Map<String, dynamic> backupData,
     String targetWorkspaceId,
   ) async {
     try {
       final projectsData = backupData['projects'] as List?;
       
       if (projectsData == null || projectsData.isEmpty) {
         Get.log('INFO: No projects in backup');
         return;
       }
       
       final db = FirebaseDatabaseService.instance;
       final restoredProjects = <String>[];
       
       for (final projectData in projectsData) {
         if (projectData is! Map<String, dynamic>) continue;
         
         try {
           // Create project from backup data
           final project = Project.fromMap({
             ...projectData,
             'workspaceId': targetWorkspaceId, // Ensure workspace ID matches
           });
           
           // Check if project already exists
           final existingProject = await db.getProject(
             workspaceId: targetWorkspaceId,
             projectId: project.id,
           );
           
           if (existingProject != null) {
             // Update existing project
             await db.updateProject(
               workspaceId: targetWorkspaceId,
               project: project,
             );
           } else {
             // Create new project
             await db.createProject(
               workspaceId: targetWorkspaceId,
               project: project,
             );
           }
           
           restoredProjects.add(project.id);
         } catch (e) {
           Get.log('ERROR: Failed to restore project ${projectData['id']}: $e');
           // Continue with other projects
         }
       }
       
       Get.log('Restored ${restoredProjects.length} projects');
     } catch (e) {
       Get.log('ERROR: Projects restore failed: $e');
       rethrow;
     }
   }
   ```

3. **Add tasks restore method**:
   ```dart
   /// Restore tasks from backup
   Future<void> _restoreTasks(
     Map<String, dynamic> backupData,
     String targetWorkspaceId,
   ) async {
     try {
       final tasksData = backupData['tasks'] as List?;
       
       if (tasksData == null || tasksData.isEmpty) {
         Get.log('INFO: No tasks in backup');
         return;
       }
       
       final db = FirebaseDatabaseService.instance;
       final restoredTasks = <String>[];
       
       for (final taskData in tasksData) {
         if (taskData is! Map<String, dynamic>) continue;
         
         try {
           // Create task from backup data
           final task = TaskEntity.fromMap({
             ...taskData,
             'workspaceId': targetWorkspaceId, // Ensure workspace ID matches
           });
           
           // Check if task already exists
           final existingTask = await db.getTask(
             workspaceId: targetWorkspaceId,
             taskId: task.id,
           );
           
           if (existingTask != null) {
             // Update existing task
             await db.updateTask(
               workspaceId: targetWorkspaceId,
               task: task,
             );
           } else {
             // Create new task
             await db.createTask(
               workspaceId: targetWorkspaceId,
               task: task,
             );
           }
           
           restoredTasks.add(task.id);
         } catch (e) {
           Get.log('ERROR: Failed to restore task ${taskData['id']}: $e');
           // Continue with other tasks
         }
       }
       
       Get.log('Restored ${restoredTasks.length} tasks');
     } catch (e) {
       Get.log('ERROR: Tasks restore failed: $e');
       rethrow;
     }
   }
   ```

4. **Add members restore method (optional)**:
   ```dart
   /// Restore members from backup (optional, with permission checks)
   Future<void> _restoreMembers(
     Map<String, dynamic> backupData,
     String targetWorkspaceId,
   ) async {
     try {
       final membersData = backupData['members'] as List?;
       
       if (membersData == null || membersData.isEmpty) {
         Get.log('INFO: No members in backup');
         return;
       }
       
       final workspaceRepo = Get.find<WorkspaceRepository>();
       final restoredMembers = <String>[];
       
       for (final memberData in membersData) {
         if (memberData is! Map<String, dynamic>) continue;
         
         try {
           // Create member from backup data
           final member = WorkspaceMember.fromMap({
             ...memberData,
             'workspaceId': targetWorkspaceId, // Ensure workspace ID matches
           });
           
           // Check if member already exists
           final existingMemberResult = await workspaceRepo.getUserWorkspaceRole(
             member.userId,
             targetWorkspaceId,
           );
           
           await existingMemberResult.fold(
             (failure) async {
               // Member doesn't exist, add them
               await workspaceRepo.addMember(member);
               restoredMembers.add(member.userId);
             },
             (existingMember) async {
               if (existingMember != null) {
                 // Update existing member (preserve current permissions if needed)
                 // Or skip if you want to preserve current state
                 Get.log('Member ${member.userId} already exists, skipping');
               } else {
                 await workspaceRepo.addMember(member);
                 restoredMembers.add(member.userId);
               }
             },
           );
         } catch (e) {
           Get.log('ERROR: Failed to restore member ${memberData['userId']}: $e');
           // Continue with other members
         }
       }
       
       Get.log('Restored ${restoredMembers.length} members');
     } catch (e) {
       Get.log('ERROR: Members restore failed: $e');
       // Don't rethrow - member restore is optional
     }
   }
   ```

5. **Combine restore methods in main restore method**:
   ```dart
   Future<void> restoreBackup({
     required String fileId,
     String? workspaceId,
     bool restoreWorkspace = true,
     bool restoreProjects = true,
     bool restoreTasks = true,
     bool restoreMembers = false,
     bool allowWorkspaceMismatch = false,
   }) async {
     // ... permission check and validation ...
     
     final targetWorkspaceId = workspaceId ?? _storage.getWorkspaceId() ?? '';
     
     try {
       // Restore workspace settings
       if (restoreWorkspace) {
         await _restoreWorkspace(backupData, targetWorkspaceId);
       }
       
       // Restore projects
       if (restoreProjects) {
         await _restoreProjects(backupData, targetWorkspaceId);
       }
       
       // Restore tasks (after projects, to maintain relationships)
       if (restoreTasks) {
         await _restoreTasks(backupData, targetWorkspaceId);
       }
       
       // Restore members (optional)
       if (restoreMembers) {
         await _restoreMembers(backupData, targetWorkspaceId);
       }
       
       Get.log('Restore completed successfully');
     } catch (e) {
       Get.log('ERROR: Restore failed: $e');
       rethrow;
     }
   }
   ```

**Expected Results**:
- ✅ Workspace settings are restored
- ✅ Projects are restored
- ✅ Tasks are restored
- ✅ Members are restored (if enabled)
- ✅ Data relationships are maintained
- ✅ Existing data is updated or new data is created

**Testing**:
- Test complete workspace restore
- Test partial restore (only projects, only tasks, etc.)
- Test restore to existing workspace (overwrite)
- Test restore to new workspace
- Verify data relationships are maintained
- Verify data integrity after restore

---

### Task 4: Implement Restore Audit Trail

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Implement audit trail logging for restore operations. Log who restored, when, from which backup, and what was restored.

**Files to Modify**:
- `lib/core/services/backup_service.dart`
- `lib/core/services/audit_log_service.dart` (create if doesn't exist)

**Dependencies**:
- Restore operations from Task 3
- Audit logging service (may need to be created)

**Implementation Steps**:

1. **Create audit log service (if doesn't exist)**:
   ```dart
   // lib/core/services/audit_log_service.dart
   class AuditLogService {
     factory AuditLogService() => _instance ??= AuditLogService._();
     AuditLogService._();
     static AuditLogService? _instance;
     
     final FirebaseDatabaseService _db = FirebaseDatabaseService.instance;
     
     /// Log restore operation
     Future<void> logRestore({
       required String userId,
       required String workspaceId,
       required String backupFileId,
       required String backupFileName,
       required DateTime backupDate,
       required Map<String, dynamic> restoreDetails,
     }) async {
       try {
         final logEntry = {
           'type': 'restore',
           'userId': userId,
           'workspaceId': workspaceId,
           'timestamp': DateTime.now().millisecondsSinceEpoch,
           'backupFileId': backupFileId,
           'backupFileName': backupFileName,
           'backupDate': backupDate.toIso8601String(),
           'restoreDetails': restoreDetails,
         };
         
         await _db.createAuditLogEntry(logEntry);
       } catch (e) {
         Get.log('ERROR: Failed to log restore operation: $e');
         // Don't throw - logging failure shouldn't break restore
       }
     }
   }
   ```

2. **Add restore details tracking**:
   ```dart
   /// Track restore details for audit log
   class RestoreDetails {
     final bool workspaceRestored;
     final int projectsRestored;
     final int tasksRestored;
     final bool membersRestored;
     final int membersRestoredCount;
     final String restoreType; // 'complete', 'selective', 'project'
     
     RestoreDetails({
       this.workspaceRestored = false,
       this.projectsRestored = 0,
       this.tasksRestored = 0,
       this.membersRestored = false,
       this.membersRestoredCount = 0,
       this.restoreType = 'complete',
     });
     
     Map<String, dynamic> toMap() {
       return {
         'workspaceRestored': workspaceRestored,
         'projectsRestored': projectsRestored,
         'tasksRestored': tasksRestored,
         'membersRestored': membersRestored,
         'membersRestoredCount': membersRestoredCount,
         'restoreType': restoreType,
       };
     }
   }
   ```

3. **Add audit logging to restore method**:
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
     
     // Download backup file
     final backupData = await _oneDrive.restoreAppData(fileId);
     
     // Get backup file info
     final backupFiles = await listBackups();
     final backupFile = backupFiles.firstWhere(
       (file) => file['id'] == fileId,
       orElse: () => {},
     );
     final backupFileName = backupFile['name']?.toString() ?? 'unknown';
     final backupDate = DateTime.tryParse(
       backupData['exportedAt']?.toString() ?? '',
     ) ?? DateTime.now();
     
     // Track restore details
     final restoreDetails = RestoreDetails(
       workspaceRestored: restoreWorkspace,
       projectsRestored: restoreProjects ? (backupData['projects'] as List?)?.length ?? 0 : 0,
       tasksRestored: restoreTasks ? (backupData['tasks'] as List?)?.length ?? 0 : 0,
       membersRestored: restoreMembers,
       membersRestoredCount: restoreMembers ? (backupData['members'] as List?)?.length ?? 0 : 0,
       restoreType: restoreWorkspace && restoreProjects && restoreTasks ? 'complete' : 'selective',
     );
     
     try {
       // Perform restore...
       
       // Log restore operation
       final auditLogService = AuditLogService();
       await auditLogService.logRestore(
         userId: userId,
         workspaceId: targetWorkspaceId,
         backupFileId: fileId,
         backupFileName: backupFileName,
         backupDate: backupDate,
         restoreDetails: restoreDetails.toMap(),
       );
       
       Get.log('Restore logged in audit trail');
     } catch (e) {
       Get.log('ERROR: Restore failed: $e');
       // Still try to log the failed restore
       try {
         final auditLogService = AuditLogService();
         await auditLogService.logRestore(
           userId: userId,
           workspaceId: targetWorkspaceId,
           backupFileId: fileId,
           backupFileName: backupFileName,
           backupDate: backupDate,
           restoreDetails: {
             ...restoreDetails.toMap(),
             'status': 'failed',
             'error': e.toString(),
           },
         );
       } catch (logError) {
         Get.log('ERROR: Failed to log failed restore: $logError');
       }
       rethrow;
     }
   }
   ```

**Expected Results**:
- ✅ Restore operations are logged in audit trail
- ✅ Log entries contain complete information (who, when, from which backup, what was restored)
- ✅ Failed restores are also logged
- ✅ Log entries are accessible and searchable

**Testing**:
- Test successful restore logging
- Test failed restore logging
- Verify log entries contain all required information
- Verify log entries are accessible
- Test log entry search/filter

---

### Task 5: Add Restore Confirmation Dialog

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Add confirmation dialog before restore to warn users about data being overwritten and allow them to confirm or cancel.

**Files to Modify**:
- `lib/core/controllers/backup_controller.dart`
- `lib/app/pages/backup/backup_page.dart` (or restore UI)

**Dependencies**:
- Restore functionality from Task 3
- UI components (TDButton, TDDialog)

**Implementation Steps**:

1. **Add confirmation dialog method to BackupController**:
   ```dart
   /// Show restore confirmation dialog
   Future<bool> showRestoreConfirmation({
     required String backupFileName,
     required DateTime backupDate,
     required int projectsCount,
     required int tasksCount,
     required bool hasWorkspaceSettings,
     required bool hasMembers,
   }) async {
     // This will be handled by UI layer
     // Return true if user confirms, false if cancels
     return false; // Placeholder
   }
   ```

2. **Update restore method to show confirmation**:
   ```dart
   /// Restore backup from OneDrive
   Future<void> restoreBackup(String fileId) async {
     // ... permission check ...
     
     // Get backup file info
     final backupData = await _backupService.restoreBackup(fileId);
     final backupFiles = await _backupService.listBackups();
     final backupFile = backupFiles.firstWhere(
       (file) => file['id'] == fileId,
       orElse: () => {},
     );
     
     final backupFileName = backupFile['name']?.toString() ?? 'Unknown';
     final backupDate = DateTime.tryParse(
       backupData['exportedAt']?.toString() ?? '',
     ) ?? DateTime.now();
     
     final projectsCount = (backupData['projects'] as List?)?.length ?? 0;
     final tasksCount = (backupData['tasks'] as List?)?.length ?? 0;
     final hasWorkspaceSettings = backupData.containsKey('workspace');
     final hasMembers = (backupData['members'] as List?)?.isNotEmpty ?? false;
     
     // Show confirmation dialog
     final confirmed = await _showRestoreConfirmationDialog(
       backupFileName: backupFileName,
       backupDate: backupDate,
       projectsCount: projectsCount,
       tasksCount: tasksCount,
       hasWorkspaceSettings: hasWorkspaceSettings,
       hasMembers: hasMembers,
     );
     
     if (!confirmed) {
       return; // User cancelled
     }
     
     // Continue with restore...
   }
   ```

3. **Add confirmation dialog UI**:
   ```dart
   // In backup_page.dart or restore widget
   Future<bool> _showRestoreConfirmationDialog({
     required String backupFileName,
     required DateTime backupDate,
     required int projectsCount,
     required int tasksCount,
     required bool hasWorkspaceSettings,
     required bool hasMembers,
   }) async {
     return await Get.dialog<bool>(
       TDDialog(
         title: AppStrings.restoreConfirmation,
         content: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(AppStrings.restoreWarning),
             SizedBox(height: 16),
             Text('${AppStrings.backupFile}: $backupFileName'),
             Text('${AppStrings.backupDate}: ${_formatDate(backupDate)}'),
             if (hasWorkspaceSettings) Text('${AppStrings.workspaceSettings}: ${AppStrings.included}'),
             if (projectsCount > 0) Text('${AppStrings.projects}: $projectsCount'),
             if (tasksCount > 0) Text('${AppStrings.tasks}: $tasksCount'),
             if (hasMembers) Text('${AppStrings.members}: ${AppStrings.included}'),
             SizedBox(height: 16),
             Text(AppStrings.restoreDataOverwriteWarning),
           ],
         ),
         actions: [
           TDButton(
             text: AppStrings.cancel,
             onPressed: () => Get.back(result: false),
           ),
           TDButton(
             text: AppStrings.confirm,
             onPressed: () => Get.back(result: true),
           ),
         ],
       ),
     ) ?? false;
   }
   ```

4. **Add AppStrings constants**:
   ```dart
   // In app_strings.dart
   static const String restoreConfirmation = 'Restore Confirmation';
   static const String restoreWarning = 'This will restore data from backup. Current data may be overwritten.';
   static const String restoreDataOverwriteWarning = 'Are you sure you want to continue?';
   static const String backupFile = 'Backup File';
   static const String backupDate = 'Backup Date';
   static const String included = 'Included';
   ```

**Expected Results**:
- ✅ Confirmation dialog appears before restore
- ✅ Dialog shows backup file information
- ✅ Dialog warns about data overwrite
- ✅ User can confirm or cancel
- ✅ Restore only proceeds if confirmed

**Testing**:
- Test confirmation dialog appears
- Test dialog shows correct backup information
- Test user can cancel restore
- Test user can confirm restore
- Verify restore only proceeds if confirmed

---

### Task 6: Add Restore Progress Tracking

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Add progress tracking for restore operations to show users restore progress.

**Files to Modify**:
- `lib/core/services/backup_service.dart`
- `lib/core/controllers/backup_controller.dart`

**Dependencies**:
- Restore functionality from Task 3

**Implementation Steps**:

1. **Add progress callback to restore methods**:
   ```dart
   Future<void> restoreBackup({
     required String fileId,
     String? workspaceId,
     bool restoreWorkspace = true,
     bool restoreProjects = true,
     bool restoreTasks = true,
     bool restoreMembers = false,
     Function(double)? onProgress,
   }) async {
     // ... validation ...
     
     double progress = 0.0;
     final totalSteps = [
       restoreWorkspace,
       restoreProjects,
       restoreTasks,
       restoreMembers,
     ].where((e) => e).length;
     
     final stepProgress = 1.0 / (totalSteps + 1); // +1 for final completion
     
     try {
       // Restore workspace
       if (restoreWorkspace) {
         onProgress?.call(progress);
         await _restoreWorkspace(backupData, targetWorkspaceId);
         progress += stepProgress;
         onProgress?.call(progress);
       }
       
       // Restore projects
       if (restoreProjects) {
         await _restoreProjects(backupData, targetWorkspaceId);
         progress += stepProgress;
         onProgress?.call(progress);
       }
       
       // Restore tasks
       if (restoreTasks) {
         await _restoreTasks(backupData, targetWorkspaceId);
         progress += stepProgress;
         onProgress?.call(progress);
       }
       
       // Restore members
       if (restoreMembers) {
         await _restoreMembers(backupData, targetWorkspaceId);
         progress += stepProgress;
         onProgress?.call(progress);
       }
       
       // Complete
       progress = 1.0;
       onProgress?.call(progress);
       
       Get.log('Restore completed successfully');
     } catch (e) {
       Get.log('ERROR: Restore failed: $e');
       rethrow;
     }
   }
   ```

2. **Update BackupController to track progress**:
   ```dart
   /// Restore backup from OneDrive
   Future<void> restoreBackup(String fileId) async {
     _isRestoring.value = true;
     _restoreProgress.value = 0.0;
     
     try {
       await executeAsync(
         () async {
           // Update progress callback
           void onProgress(double progress) {
             _restoreProgress.value = progress;
           }
           
           // Perform restore with progress tracking
           await _backupService.restoreBackup(
             fileId: fileId,
             onProgress: onProgress,
           );
         },
         showLoading: false,
         successMessage: AppStrings.restoreComplete,
       );
     } finally {
       _isRestoring.value = false;
       _restoreProgress.value = 0.0;
     }
   }
   ```

**Expected Results**:
- ✅ Restore progress is tracked
- ✅ Progress indicator updates during restore
- ✅ Users can see restore progress
- ✅ Progress is accurate

**Testing**:
- Test progress tracking during restore
- Test progress indicator updates
- Test progress accuracy
- Test progress with different restore scopes

---

## Summary

### Implementation Order:
1. **Task 1**: Add restore permission checks
2. **Task 2**: Implement backup file validation
3. **Task 3**: Implement workspace restore logic
4. **Task 4**: Implement restore audit trail
5. **Task 5**: Add restore confirmation dialog
6. **Task 6**: Add restore progress tracking

### Estimated Total Time: 16-22 hours

### Dependencies:
- Task 1 is independent
- Task 2 depends on backup file structure
- Task 3 depends on Tasks 1 and 2
- Task 4 depends on Task 3
- Task 5 depends on Task 3
- Task 6 depends on Task 3

### Testing Requirements:
- Unit tests for permission checks
- Unit tests for backup file validation
- Unit tests for restore logic
- Unit tests for audit logging
- Integration tests for complete restore flow
- Manual testing with various restore scenarios
- Security testing for permission enforcement

### Success Criteria:
- ✅ Only Account Holder and Admin can restore
- ✅ Backup file is validated before restore
- ✅ Workspace data is restored correctly
- ✅ Data relationships are maintained
- ✅ Restore operations are logged in audit trail
- ✅ Confirmation dialog prevents accidental restores
- ✅ Progress tracking provides user feedback
- ✅ Error handling is comprehensive

### Security Considerations:
- **Critical**: Only Account Holder and Admin should be able to restore
- Permission checks must be performed before restore
- Restore operations must be logged in audit trail
- Data validation must be performed before restore
- Confirmation dialog prevents accidental restores

