# Governance & Safety - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Governance & Safety** feature (audit log, quota cảnh báo, backup/restore). Currently, this feature is **MISSING** - no audit logging around workspace updates/deletes, no quota checks, and no workspace-level backup/restore hooks.

## Current Status: ⛔ MISSING

### What Exists (Related):
- ✅ `ActivityLog` entity exists for tasks/projects (but not for workspace operations)
- ✅ `WorkspaceAnalytics` tracks some events (member added, removed, permissions updated, workspace deleted) but this is analytics, not audit logging
- ✅ `BackupService` exists with `exportDataToOneDrive()` and `restoreAppData()` methods
- ✅ `OneDriveService` has backup/restore methods and `getStorageQuota()` for OneDrive storage
- ✅ `StorageService` has `getStorageSize()` for local storage

### What's Missing/Broken:
- ⛔ No audit logging for workspace operations (create, update, delete)
- ⛔ No audit log entity or service specifically for workspace operations
- ⛔ No quota checks for workspace storage, members, projects
- ⛔ No quota warning system
- ⛔ `BackupService.exportDataToOneDrive()` is empty (not implemented)
- ⛔ No workspace-level backup/restore hooks
- ⛔ No UI for viewing audit logs
- ⛔ No UI for quota management
- ⛔ No UI for workspace backup/restore

---

## Task List

### Task 1: Create Workspace Audit Log Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create audit log entity specifically for workspace operations.

**Files to Create/Modify**:
- `lib/features/workspace/domain/entities/workspace_audit_log.dart` (new file)

**Implementation Steps**:
1. Create `WorkspaceAuditLog` entity:
   ```dart
   class WorkspaceAuditLog {
     final String id;
     final String workspaceId;
     final String action; // 'create', 'update', 'delete', 'member_added', etc.
     final String userId; // User who performed the action
     final String? targetUserId; // Target user (for member operations)
     final DateTime timestamp;
     final Map<String, dynamic>? previousData; // Previous values (for updates)
     final Map<String, dynamic>? newData; // New values (for updates)
     final Map<String, dynamic>? metadata; // Additional metadata
     final String? reason; // Reason for action (for deletions)
   }
   ```
2. Add `fromMap` and `toMap` methods
3. Add `copyWith` method
4. Add helper methods:
   - `getActionDisplayName()`
   - `getChangedFields()`
   - `hasChanges()`

**Expected Results**:
- ✅ Workspace audit log entity exists
- ✅ Entity supports all workspace operations
- ✅ Entity can store previous/new values for updates
- ✅ Entity follows project architecture patterns

**Test Criteria**:
- Unit test: Test entity creation, serialization
- Test: Verify entity can store all required data

---

### Task 2: Create Workspace Audit Log Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for logging workspace operations to audit log.

**Files to Create/Modify**:
- `lib/features/workspace/domain/services/workspace_audit_service.dart` (new file)
- `lib/features/workspace/data/datasources/workspace_remote_data_source.dart`
- `lib/features/workspace/domain/repositories/workspace_repository.dart`

**Implementation Steps**:
1. Create `WorkspaceAuditService`:
   - Method to log workspace creation: `logWorkspaceCreated(Workspace workspace, String userId)`
   - Method to log workspace update: `logWorkspaceUpdated(Workspace oldWorkspace, Workspace newWorkspace, String userId, List<String> changedFields)`
   - Method to log workspace deletion: `logWorkspaceDeleted(Workspace workspace, String userId, String? reason)`
   - Method to log member added: `logMemberAdded(String workspaceId, String memberId, String role, String addedBy)`
   - Method to log member removed: `logMemberRemoved(String workspaceId, String memberId, String removedBy, String? reason)`
   - Method to log permission changed: `logPermissionChanged(String workspaceId, String memberId, List<String> oldPermissions, List<String> newPermissions, String changedBy)`
2. Implement audit log persistence:
   - Store audit logs in Firebase: `workspaces/{workspaceId}/audit_logs/{logId}`
   - Store audit logs before operations (so they're not lost if operation fails)
   - Use timestamp as part of log ID for ordering
3. Add repository methods:
   - `getWorkspaceAuditLogs(String workspaceId, {DateTime? startDate, DateTime? endDate, String? action})`
   - `createAuditLog(WorkspaceAuditLog log)`
4. Integrate audit logging into workspace operations:
   - Call audit service in `WorkspaceController.createWorkspace`
   - Call audit service in `WorkspaceController.updateWorkspace`
   - Call audit service in `WorkspaceController.deleteWorkspace`
   - Call audit service in member operations

**Expected Results**:
- ✅ Workspace audit service exists
- ✅ All workspace operations are logged
- ✅ Audit logs are stored in Firebase
- ✅ Audit logs are created before operations

**Test Criteria**:
- Unit test: Test audit logging for each operation
- Integration test: Verify audit logs are stored in Firebase
- Manual test: Perform operations, verify audit logs are created

---

### Task 3: Create Audit Log UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI for viewing workspace audit logs.

**Files to Create/Modify**:
- `lib/features/workspace/presentation/pages/workspace_audit_log_page.dart` (new file)
- `lib/features/workspace/presentation/controllers/workspace_audit_log_controller.dart` (new file)
- `lib/app/routes/app_router.dart`

**Implementation Steps**:
1. Create `WorkspaceAuditLogController`:
   - Load audit logs for current workspace
   - Filter logs by action, user, date range
   - Search logs
   - Export logs (optional)
   - Use GetX pattern
2. Create `WorkspaceAuditLogPage`:
   - Display list of audit log entries
   - Show: Action, User, Timestamp, Details
   - Filter options: Action type, User, Date range
   - Search functionality
   - Export button (optional)
   - Use TD widgets and AppStrings
3. Add route to AppRouter
4. Add navigation from Workspace Management or Settings
5. Ensure only Account Holder/Admin can access audit log
6. Add permission check before showing page

**Expected Results**:
- ✅ Audit log UI exists
- ✅ Audit logs are displayed correctly
- ✅ Filtering and search work
- ✅ Only Account Holder/Admin can access
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: View audit log, verify entries are displayed
- Test: Verify filtering and search work
- Test: Verify permission check works

---

### Task 4: Implement Workspace Storage Quota Checking

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Implement quota checking for workspace storage usage.

**Files to Create/Modify**:
- `lib/features/workspace/domain/services/workspace_quota_service.dart` (new file)
- `lib/features/workspace/domain/entities/workspace_quota.dart` (new file)
- `lib/core/services/firebase_database_service.dart`

**Implementation Steps**:
1. Create `WorkspaceQuota` entity:
   - `storageLimit`: Total storage limit (bytes)
   - `storageUsed`: Current storage used (bytes)
   - `memberLimit`: Maximum members allowed
   - `memberCount`: Current member count
   - `projectLimit`: Maximum projects allowed
   - `projectCount`: Current project count
   - `taskLimit`: Maximum tasks allowed (optional)
   - `taskCount`: Current task count (optional)
2. Create `WorkspaceQuotaService`:
   - Method to calculate storage usage: `calculateStorageUsage(String workspaceId)`
   - Method to get quota: `getWorkspaceQuota(String workspaceId)`
   - Method to check if quota exceeded: `isQuotaExceeded(String workspaceId, String quotaType)`
   - Method to check if approaching limit: `isApproachingLimit(String workspaceId, String quotaType, double threshold)`
3. Implement storage calculation:
   - Calculate size of all workspace data in Firebase
   - Include: Projects, Tasks, Members, Settings, Files
   - Cache calculation results for performance
4. Integrate quota checking:
   - Check quota before creating new data
   - Check quota before adding members
   - Check quota before creating projects
   - Throw error if quota exceeded

**Expected Results**:
- ✅ Workspace quota service exists
- ✅ Storage usage is calculated correctly
- ✅ Quota limits are checked
- ✅ Quota checks are integrated into operations

**Test Criteria**:
- Unit test: Test quota calculation
- Test: Verify quota checks work before operations
- Manual test: Verify storage usage is calculated correctly

---

### Task 5: Implement Quota Warning System

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Implement quota warning system that shows warnings when approaching limits.

**Files to Create/Modify**:
- `lib/features/workspace/presentation/controllers/workspace_quota_controller.dart` (new file)
- `lib/features/workspace/presentation/widgets/quota_warning_widget.dart` (new file)
- `lib/core/services/snackbar_service.dart` (may need updates)

**Implementation Steps**:
1. Create `WorkspaceQuotaController`:
   - Load quota information
   - Check if warnings are needed
   - Monitor quota changes
   - Use GetX pattern
2. Create `QuotaWarningWidget`:
   - Display quota warnings
   - Show storage usage percentage
   - Show member count vs limit
   - Show project count vs limit
   - Show warning when approaching limit (e.g., 80%)
   - Show error when at limit (100%)
   - Provide actions (upgrade, clean up, etc.)
3. Integrate warnings into UI:
   - Show warnings on Dashboard
   - Show warnings in Workspace Settings
   - Show warnings when creating new data
   - Show snackbar notifications for critical warnings
4. Configure warning thresholds:
   - Storage: 80% warning, 95% critical
   - Members: 90% warning, 100% critical
   - Projects: 90% warning, 100% critical

**Expected Results**:
- ✅ Quota warning system exists
- ✅ Warnings are shown at appropriate thresholds
- ✅ Warnings are clear and actionable
- ✅ Warnings appear in multiple places

**Test Criteria**:
- Manual test: Verify warnings appear when approaching limit
- Test: Verify warnings are shown in correct places
- Test: Verify warning thresholds work correctly

---

### Task 6: Create Quota Management UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI for viewing and managing workspace quotas.

**Files to Create/Modify**:
- `lib/features/workspace/presentation/pages/workspace_quota_page.dart` (new file)
- `lib/features/workspace/presentation/controllers/workspace_quota_controller.dart`

**Implementation Steps**:
1. Create `WorkspaceQuotaPage`:
   - Display current quota usage:
     - Storage usage with progress bar
     - Member count vs limit
     - Project count vs limit
     - Task count vs limit (if applicable)
   - Show breakdown by data type:
     - Tasks size
     - Projects size
     - Files size
     - Other data size
   - Show quota limits and usage percentages
   - Refresh button to recalculate
   - Use TD widgets and AppStrings
2. Add quota management actions:
   - "Upgrade Plan" button (if applicable)
   - "Clean Up Data" button (if applicable)
   - "View Details" link
3. Add route to AppRouter
4. Add navigation from Workspace Settings
5. Ensure only Account Holder/Admin can access quota management

**Expected Results**:
- ✅ Quota management UI exists
- ✅ Quota usage is displayed clearly
- ✅ Breakdown by data type is shown
- ✅ Management actions are available

**Test Criteria**:
- Manual test: View quota page, verify usage is displayed
- Test: Verify breakdown is accurate
- Test: Verify management actions work

---

### Task 7: Implement Workspace-Level Backup

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Implement workspace-level backup functionality.

**Files to Modify**:
- `lib/core/services/backup_service.dart`
- `lib/features/workspace/data/datasources/workspace_remote_data_source.dart`

**Implementation Steps**:
1. Implement `BackupService.exportDataToOneDrive()`:
   - Load all workspace data:
     - Workspace settings
     - Projects
     - Tasks
     - Members
     - Teams/Groups
     - Reports (if applicable)
   - Create backup payload:
     ```dart
     {
       'workspaceId': workspaceId,
       'workspaceName': workspaceName,
       'exportedAt': DateTime.now().toIso8601String(),
       'exportedBy': userId,
       'version': '1.0',
       'workspace': workspace.toMap(),
       'projects': projects.map((p) => p.toMap()).toList(),
       'tasks': tasks.map((t) => t.toMap()).toList(),
       'members': members.map((m) => m.toMap()).toList(),
       'teams': teams.map((t) => t.toMap()).toList(),
     }
     ```
   - Encrypt backup data (if required)
   - Upload to OneDrive using `OneDriveService.backupAppData()`
   - Return backup file information
2. Add workspace-specific backup hooks:
   - Call backup hooks before workspace deletion
   - Call backup hooks on scheduled backups
   - Include workspace metadata in backup
3. Add backup validation:
   - Verify backup data integrity
   - Calculate backup checksum
   - Store checksum with backup

**Expected Results**:
- ✅ Workspace backup is implemented
- ✅ All workspace data is included in backup
- ✅ Backup is stored securely
- ✅ Backup hooks are integrated

**Test Criteria**:
- Manual test: Create backup, verify all data is included
- Test: Verify backup is stored correctly
- Test: Verify backup data integrity

---

### Task 8: Implement Workspace-Level Restore

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Implement workspace-level restore functionality.

**Files to Modify**:
- `lib/core/services/backup_service.dart`
- `lib/features/workspace/data/datasources/workspace_remote_data_source.dart`
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`

**Implementation Steps**:
1. Implement workspace restore:
   - Load backup file from OneDrive
   - Parse backup data
   - Validate backup data integrity
   - Check backup checksum
   - Restore workspace data:
     - Restore workspace settings
     - Restore projects
     - Restore tasks
     - Restore members (with permission checks)
     - Restore teams/groups
   - Maintain data relationships (tasks linked to projects, etc.)
   - Handle conflicts (if workspace already exists)
2. Add restore validation:
   - Verify user has permission to restore
   - Verify backup is valid
   - Verify backup is for correct workspace (if restoring to existing workspace)
   - Show confirmation dialog before restore
3. Add restore logging:
   - Log restore operation in audit log (if audit logging exists)
   - Include: Who restored, when, from which backup
4. Add error handling:
   - Handle partial restore failures
   - Rollback on critical failures
   - Show clear error messages

**Expected Results**:
- ✅ Workspace restore is implemented
- ✅ All workspace data is restored correctly
- ✅ Data relationships are maintained
- ✅ Restore is logged and validated

**Test Criteria**:
- Manual test: Restore workspace, verify all data is restored
- Test: Verify data relationships are maintained
- Test: Verify restore validation works

---

### Task 9: Create Backup/Restore UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI for workspace backup and restore.

**Files to Create/Modify**:
- `lib/features/workspace/presentation/pages/workspace_backup_page.dart` (new file)
- `lib/features/workspace/presentation/controllers/workspace_backup_controller.dart` (new file)
- `lib/app/routes/app_router.dart`

**Implementation Steps**:
1. Create `WorkspaceBackupController`:
   - Load available backups
   - Create backup
   - Restore backup
   - Delete backup (optional)
   - Show backup progress
   - Use GetX pattern
2. Create `WorkspaceBackupPage`:
   - Display backup information:
     - Last backup date
     - Backup size
     - Next scheduled backup
   - "Backup Now" button
   - List of available backups:
     - Backup date
     - Backup size
     - Backup details
   - "Restore" button for each backup
   - Backup settings:
     - Enable/disable automatic backup
     - Backup frequency (daily, weekly, monthly)
   - Use TD widgets and AppStrings
3. Add route to AppRouter
4. Add navigation from Workspace Settings
5. Ensure only Account Holder/Admin can access backup/restore
6. Add confirmation dialogs for restore

**Expected Results**:
- ✅ Backup/restore UI exists
- ✅ Backup can be created manually
- ✅ Backups can be restored
- ✅ Automatic backup can be configured
- ✅ Only Account Holder/Admin can access

**Test Criteria**:
- Manual test: Create backup, verify it appears in list
- Test: Restore backup, verify workspace is restored
- Test: Verify permission check works

---

### Task 10: Add Quota Enforcement to Operations

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add quota enforcement to workspace operations (create project, add member, etc.).

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/features/tasks/presentation/controllers/project_controller.dart`
- `lib/features/tasks/presentation/controllers/task_controller.dart`

**Implementation Steps**:
1. Add quota checks before operations:
   - Before creating project: Check project limit
   - Before adding member: Check member limit
   - Before creating task: Check task limit (if applicable)
   - Before uploading file: Check storage limit
2. Integrate `WorkspaceQuotaService`:
   - Check quota before operations
   - Throw error if quota exceeded
   - Show appropriate error messages
3. Update controllers:
   - `WorkspaceController.inviteUserToWorkspace`: Check member limit
   - `ProjectController.createProject`: Check project limit
   - `TaskController.createTask`: Check task limit (if applicable)
4. Add quota error handling:
   - Show clear error messages
   - Suggest actions (upgrade, clean up)
   - Link to quota management page

**Expected Results**:
- ✅ Quota checks are enforced before operations
- ✅ Operations are blocked when quota exceeded
- ✅ Clear error messages are shown
- ✅ Quota enforcement is consistent

**Test Criteria**:
- Test: Try to create project at limit - should be blocked
- Test: Try to add member at limit - should be blocked
- Test: Verify error messages are clear

---

### Task 11: Add Unit Tests for Governance & Safety

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for governance & safety functionality.

**Files to Create/Modify**:
- `test/features/workspace/domain/services/workspace_audit_service_test.dart`
- `test/features/workspace/domain/services/workspace_quota_service_test.dart`
- `test/core/services/backup_service_test.dart`

**Implementation Steps**:
1. Test `WorkspaceAuditService`:
   - Test logging workspace creation
   - Test logging workspace update
   - Test logging workspace deletion
   - Test logging member operations
   - Test logging permission changes
2. Test `WorkspaceQuotaService`:
   - Test storage usage calculation
   - Test quota checking
   - Test warning thresholds
3. Test `BackupService`:
   - Test workspace backup
   - Test workspace restore
   - Test backup data integrity
4. Test quota enforcement:
   - Test project limit enforcement
   - Test member limit enforcement
   - Test storage limit enforcement

**Expected Results**:
- ✅ Unit tests cover governance & safety functionality
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Create Workspace Audit Log Entity (Critical - Foundation)
2. **Task 2**: Create Workspace Audit Log Service (Critical - Core Feature)
3. **Task 4**: Implement Workspace Storage Quota Checking (High Priority - Core Feature)
4. **Task 5**: Implement Quota Warning System (High Priority - User Experience)
5. **Task 7**: Implement Workspace-Level Backup (High Priority - Data Safety)
6. **Task 8**: Implement Workspace-Level Restore (High Priority - Data Safety)
7. **Task 10**: Add Quota Enforcement to Operations (High Priority - Data Integrity)
8. **Task 3**: Create Audit Log UI (Medium Priority - Feature Completeness)
9. **Task 6**: Create Quota Management UI (Medium Priority - Feature Completeness)
10. **Task 9**: Create Backup/Restore UI (Medium Priority - Feature Completeness)
11. **Task 11**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Workspace audit log entity and service exist
- ✅ All workspace operations are logged
- ✅ Audit log UI exists and is accessible
- ✅ Workspace quota service exists
- ✅ Quota warnings are shown at appropriate thresholds
- ✅ Quota enforcement is integrated into operations
- ✅ Workspace backup is fully implemented
- ✅ Workspace restore is fully implemented
- ✅ Backup/restore UI exists
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ Only Account Holder/Admin can access governance features
- ✅ No known bugs or issues

---

## Dependencies

- **WorkspaceController**: Must provide workspace operations
- **WorkspaceRepository**: Must support audit log operations
- **Firebase Realtime Database**: Must support audit log storage
- **OneDriveService**: Required for backup/restore
- **BackupService**: Must support workspace-level backup/restore
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **SnackbarService**: Must use SnackbarService for notifications

---

## Notes

1. **Audit Logging**: Critical for governance and compliance. Should log all workspace operations with user, timestamp, and details.

2. **Quota Management**: Important for preventing resource exhaustion. Should check storage, members, projects, and tasks.

3. **Backup/Restore**: Critical for data safety. Should backup all workspace data and allow restore with data integrity.

4. **Permission Requirements**: Most governance features should be restricted to Account Holder/Admin.

5. **Data Integrity**: Backup and restore must maintain all data relationships and prevent data corruption.

6. **Performance**: Quota calculations and audit log queries should be optimized and cached for performance.

---

## Related Documentation

- `WORKSPACE_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `GOVERNANCE_SAFETY_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/backup.md` - Backup feature requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/SECURITY_RULES.md` - Security requirements

