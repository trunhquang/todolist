# Workspace Archive Process - Task List & Expected Results

## Overview
This document lists all tasks required to implement the **Workspace Archive Process** feature. Currently, this feature is **MISSING** - not implemented; only hard delete via `deleteWorkspace` exists.

## Current Status: ⛔ MISSING

### What Exists (Related):
- ✅ `Workspace` entity has `isActive` field (but not used for archiving)
- ✅ `deleteWorkspace` method exists (hard delete)
- ✅ Projects and Tasks have soft delete support (`deletedAt` field)
- ✅ `FirebaseDatabaseService` has `softDeleteProject` and `softDeleteTask` methods

### What's Missing/Broken:
- ⛔ No `isArchived` or `archivedAt` fields in Workspace entity
- ⛔ No archive workspace functionality
- ⛔ No restore workspace functionality
- ⛔ No filtering of archived workspaces in queries
- ⛔ No UI for viewing archived workspaces
- ⛔ No UI for archiving/restoring workspaces
- ⛔ No separate queries for archived workspaces

---

## Task List

### Task 1: Add Archive Fields to Workspace Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add archive-related fields to `Workspace` entity to support soft delete/archive functionality.

**Files to Modify**:
- `lib/features/workspace/domain/entities/workspace.dart`

**Implementation Steps**:
1. Add archive fields to `Workspace` entity:
   ```dart
   final bool isArchived; // Whether workspace is archived
   final DateTime? archivedAt; // When workspace was archived
   final String? archivedBy; // Who archived the workspace
   ```
2. Update constructor to include archive fields:
   - Default `isArchived` to `false`
   - Default `archivedAt` and `archivedBy` to `null`
3. Update `fromMap` method to read archive fields:
   ```dart
   isArchived: (map['isArchived'] as bool?) ?? false,
   archivedAt: map['archivedAt'] != null
       ? DateTime.fromMillisecondsSinceEpoch(map['archivedAt'] as int)
       : null,
   archivedBy: map['archivedBy']?.toString(),
   ```
4. Update `toMap` method to include archive fields:
   ```dart
   'isArchived': isArchived,
   'archivedAt': archivedAt?.millisecondsSinceEpoch,
   'archivedBy': archivedBy,
   ```
5. Update `copyWith` method to support archive fields
6. Add helper methods:
   - `bool get isActive => !isArchived;`
   - `bool get canBeArchived => isActive;`
   - `bool get canBeRestored => isArchived;`

**Expected Results**:
- ✅ Workspace entity has archive fields
- ✅ Archive fields are serialized correctly
- ✅ Helper methods work correctly

**Test Criteria**:
- Unit test: Test entity creation with archive fields
- Test: Verify serialization works correctly

---

### Task 2: Create Archive Workspace Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case for archiving a workspace (soft delete).

**Files to Create/Modify**:
- `lib/features/workspace/domain/usecases/archive_workspace.dart` (new file)

**Implementation Steps**:
1. Create `ArchiveWorkspace` use case class:
   ```dart
   class ArchiveWorkspace implements UseCase<void, ArchiveWorkspaceParams> {
     ArchiveWorkspace(this.repository);
     final WorkspaceRepository repository;
     
     @override
     Future<Either<Failure, void>> call(ArchiveWorkspaceParams params) async {
       // Implementation
     }
   }
   ```
2. Implement validation:
   - Validate current user is Account Holder or Admin
   - Validate workspace exists
   - Validate workspace is not already archived
   - Validate workspace is not the last active workspace (optional)
3. Implement archive logic:
   - Get current workspace
   - Update workspace with archive fields:
     - `isArchived = true`
     - `archivedAt = current timestamp`
     - archivedBy = current user ID
   - Save updated workspace
4. Handle workspace switching:
   - If archiving current workspace, switch to another workspace
   - If no other workspace, handle appropriately
5. Handle errors:
   - Workspace not found
   - Permission denied
   - Network errors
6. Return appropriate results

**Expected Results**:
- ✅ Archive workspace use case exists
- ✅ Validation is comprehensive
- ✅ Archive logic works correctly
- ✅ Workspace switching is handled

**Test Criteria**:
- Unit test: Test use case with various scenarios
- Test: Verify validation works
- Test: Verify archive logic works

---

### Task 3: Create Restore Workspace Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case for restoring an archived workspace.

**Files to Create/Modify**:
- `lib/features/workspace/domain/usecases/restore_workspace.dart` (new file)

**Implementation Steps**:
1. Create `RestoreWorkspace` use case class:
   ```dart
   class RestoreWorkspace implements UseCase<void, RestoreWorkspaceParams> {
     RestoreWorkspace(this.repository);
     final WorkspaceRepository repository;
     
     @override
     Future<Either<Failure, void>> call(RestoreWorkspaceParams params) async {
       // Implementation
     }
   }
   ```
2. Implement validation:
   - Validate current user is Account Holder or Admin
   - Validate workspace exists
   - Validate workspace is archived
3. Implement restore logic:
   - Get archived workspace
   - Update workspace with restore fields:
     - `isArchived = false`
     - `archivedAt = null`
     - `archivedBy = null` (optional - keep for history)
   - Save updated workspace
4. Handle errors:
   - Workspace not found
   - Permission denied
   - Network errors
5. Return appropriate results

**Expected Results**:
- ✅ Restore workspace use case exists
- ✅ Validation is comprehensive
- ✅ Restore logic works correctly

**Test Criteria**:
- Unit test: Test use case with various scenarios
- Test: Verify validation works
- Test: Verify restore logic works

---

### Task 4: Add Archive/Restore Methods to WorkspaceController

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add methods to `WorkspaceController` for archiving and restoring workspaces.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`

**Implementation Steps**:
1. Add `archiveWorkspace` method:
   ```dart
   Future<void> archiveWorkspace(String workspaceId, {String? reason}) async {
     // Implementation
   }
   ```
2. Implement permission check:
   - Check current user is Account Holder or Admin
   - Show error if not authorized
3. Call archive use case:
   - Create `ArchiveWorkspaceParams`
   - Call `ArchiveWorkspace` use case
   - Handle success/error
4. Handle workspace switching:
   - If archiving current workspace, switch to another
   - Update `_currentWorkspace` observable
5. Update local state:
   - Remove from `_workspaces` list (or mark as archived)
   - Refresh workspace list
6. Add `restoreWorkspace` method:
   ```dart
   Future<void> restoreWorkspace(String workspaceId) async {
     // Implementation
   }
   ```
7. Implement restore logic:
   - Call restore use case
   - Update local state
   - Add restored workspace back to list
8. Show feedback:
   - Success messages
   - Error messages

**Expected Results**:
- ✅ Archive and restore methods exist in controller
- ✅ Permission checks are enforced
- ✅ Workspace switching is handled
- ✅ Success/error handling works correctly

**Test Criteria**:
- Unit test: Test controller methods
- Manual test: Archive/restore workspace, verify it works

---

### Task 5: Add Archive/Restore to Repository

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add repository methods for archiving and restoring workspaces.

**Files to Modify**:
- `lib/features/workspace/domain/repositories/workspace_repository.dart`
- `lib/features/workspace/data/repositories/workspace_repository_impl.dart`

**Implementation Steps**:
1. Add methods to repository interface:
   ```dart
   Future<Either<Failure, void>> archiveWorkspace(String workspaceId, String archivedBy);
   Future<Either<Failure, void>> restoreWorkspace(String workspaceId);
   Future<Either<Failure, List<Workspace>>> getArchivedWorkspaces(String userId);
   ```
2. Implement in `WorkspaceRepositoryImpl`:
   - `archiveWorkspace`: Update workspace with archive fields
   - `restoreWorkspace`: Update workspace to remove archive fields
   - `getArchivedWorkspaces`: Get only archived workspaces for user
3. Update cache:
   - Update cached workspace after archive/restore
   - Invalidate cache if needed
4. Handle errors:
   - Workspace not found
   - Network errors
   - Permission errors

**Expected Results**:
- ✅ Repository methods exist
- ✅ Archive/restore logic works correctly
- ✅ Cache is updated correctly
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test repository methods
- Integration test: Test with Firebase
- Test: Verify cache updates correctly

---

### Task 6: Add Archive/Restore to Remote Data Source

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add remote data source methods for archiving and restoring workspaces in Firebase.

**Files to Modify**:
- `lib/features/workspace/data/datasources/workspace_remote_data_source.dart`
- `lib/features/workspace/data/datasources/workspace_remote_data_source_impl.dart`

**Implementation Steps**:
1. Add methods to remote data source interface:
   ```dart
   Future<void> archiveWorkspace(String workspaceId, String archivedBy);
   Future<void> restoreWorkspace(String workspaceId);
   Future<List<Workspace>> getArchivedWorkspaces(String userId);
   ```
2. Implement in `WorkspaceRemoteDataSourceImpl`:
   - `archiveWorkspace`:
     ```dart
     await workspaceRef.update({
       'isArchived': true,
       'archivedAt': DateTime.now().millisecondsSinceEpoch,
       'archivedBy': archivedBy,
       'updatedAt': DateTime.now().millisecondsSinceEpoch,
     });
     ```
   - `restoreWorkspace`:
     ```dart
     await workspaceRef.update({
       'isArchived': false,
       'archivedAt': null,
       'archivedBy': null,
       'updatedAt': DateTime.now().millisecondsSinceEpoch,
     });
     ```
   - `getArchivedWorkspaces`: Query workspaces where `isArchived == true`
3. Handle Firebase errors:
   - Network errors
   - Permission errors
   - Transaction conflicts
4. Ensure data consistency:
   - Verify updates succeeded
   - Rollback on failure

**Expected Results**:
- ✅ Remote data source methods exist
- ✅ Archive/restore logic works in Firebase
- ✅ Error handling is robust
- ✅ Data consistency is maintained

**Test Criteria**:
- Integration test: Test with Firebase
- Test: Verify archive/restore works correctly
- Test: Verify error handling works

---

### Task 7: Filter Archived Workspaces from Queries

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update all workspace queries to filter out archived workspaces.

**Files to Modify**:
- `lib/features/workspace/data/datasources/workspace_remote_data_source_impl.dart`
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`

**Implementation Steps**:
1. Update `getUserWorkspaces` method:
   - Filter out workspaces where `isArchived == true`
   - Return only active workspaces
2. Update `getWorkspace` method:
   - Check if workspace is archived
   - Return null or error if archived (for normal queries)
   - OR allow access if explicitly requested
3. Update workspace selector:
   - Filter archived workspaces from list
   - Only show active workspaces
4. Update workspace switching:
   - Prevent switching to archived workspaces
   - Show error if trying to switch to archived workspace
5. Update all workspace-related queries:
   - Ensure archived workspaces are filtered
   - Add filtering consistently

**Expected Results**:
- ✅ Archived workspaces are filtered from normal queries
- ✅ Only active workspaces are returned
- ✅ Filtering is consistent across all queries

**Test Criteria**:
- Test: Verify archived workspaces are filtered
- Test: Verify active workspaces are returned
- Test: Verify filtering is consistent

---

### Task 8: Create Archive Workspace UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI for archiving workspaces.

**Files to Create/Modify**:
- `lib/features/workspace/presentation/pages/workspace_management_page.dart`
- `lib/app/pages/workspace/workspace_settings_page.dart`

**Implementation Steps**:
1. Add "Archive Workspace" option to Workspace Management page:
   - Add menu item or button
   - Show only for Account Holder/Admin
   - Show only for active workspaces
2. Add "Archive Workspace" option to Workspace Settings page:
   - Add in "Danger Zone" section
   - Show confirmation dialog
3. Create confirmation dialog:
   - Warning message about archiving
   - Information about what happens when archived
   - "Cancel" and "Archive" buttons
   - Use TD widgets and AppStrings
4. Implement archive action:
   - Call `WorkspaceController.archiveWorkspace`
   - Handle success/error
   - Navigate appropriately
5. Add permission check:
   - Only Account Holder/Admin can see archive option
   - Show error if not authorized

**Expected Results**:
- ✅ Archive workspace UI exists
- ✅ Confirmation dialog is clear
- ✅ Only Account Holder/Admin can access
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Archive workspace, verify UI works
- Test: Verify permission check works

---

### Task 9: Create Archived Workspaces View

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI for viewing archived workspaces.

**Files to Create/Modify**:
- `lib/features/workspace/presentation/pages/archived_workspaces_page.dart` (new file)
- `lib/features/workspace/presentation/controllers/archived_workspaces_controller.dart` (new file)
- `lib/app/routes/app_router.dart`

**Implementation Steps**:
1. Create `ArchivedWorkspacesController`:
   - Load archived workspaces for current user
   - Handle restore action
   - Handle permanent delete action (if implemented)
   - Use GetX pattern
2. Create `ArchivedWorkspacesPage`:
   - Display list of archived workspaces
   - Show workspace information:
     - Workspace name
     - Archive date
     - Archived by (if available)
     - "Archived" badge
   - "Restore" button for each workspace
   - "Permanently Delete" button (if implemented)
   - Empty state if no archived workspaces
   - Use TD widgets and AppStrings
3. Add route to AppRouter
4. Add navigation from Workspace Management
5. Ensure only Account Holder/Admin can access

**Expected Results**:
- ✅ Archived workspaces view exists
- ✅ Archived workspaces are displayed clearly
- ✅ Restore action is available
- ✅ Only Account Holder/Admin can access

**Test Criteria**:
- Manual test: View archived workspaces, verify list is displayed
- Test: Verify restore works from this view

---

### Task 10: Create Restore Workspace UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI for restoring archived workspaces.

**Files to Modify**:
- `lib/features/workspace/presentation/pages/archived_workspaces_page.dart`
- `lib/features/workspace/presentation/controllers/archived_workspaces_controller.dart`

**Implementation Steps**:
1. Add restore functionality to Archived Workspaces page:
   - "Restore" button for each archived workspace
   - Confirmation dialog (optional)
   - Restore action
2. Create restore confirmation dialog (optional):
   - Confirmation message
   - "Cancel" and "Restore" buttons
3. Implement restore action:
   - Call `WorkspaceController.restoreWorkspace`
   - Handle success/error
   - Refresh archived workspaces list
   - Show success message
4. Add permission check:
   - Only Account Holder/Admin can restore
   - Show error if not authorized

**Expected Results**:
- ✅ Restore workspace UI exists
- ✅ Restore action works correctly
- ✅ Success/error handling works
- ✅ Only Account Holder/Admin can restore

**Test Criteria**:
- Manual test: Restore workspace, verify it works
- Test: Verify permission check works

---

### Task 11: Handle Current Workspace Archiving

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Handle special case when archiving the currently active workspace.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/features/workspace/domain/usecases/archive_workspace.dart`

**Implementation Steps**:
1. Detect if archiving current workspace:
   - Check if `workspaceId == currentWorkspace.id`
2. Implement workspace switching logic:
   - If other active workspaces exist:
     - Switch to first available active workspace
     - Update `_currentWorkspace` observable
   - If no other active workspaces:
     - Set `currentWorkspace` to null
     - Show message to create new workspace
     - Navigate to create workspace screen (optional)
3. Update workspace selector:
   - Remove archived workspace from selector
   - Update selector to show new current workspace
4. Handle edge cases:
   - Last workspace archiving
   - No workspaces available
   - Workspace switching errors

**Expected Results**:
- ✅ Current workspace archiving is handled
- ✅ User is switched to another workspace automatically
- ✅ Edge cases are handled appropriately

**Test Criteria**:
- Test: Archive current workspace, verify switching works
- Test: Archive last workspace, verify handling

---

### Task 12: Add Archive Filtering to Data Queries

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Ensure all data queries (projects, tasks, etc.) filter out archived workspaces.

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`
- `lib/features/tasks/presentation/controllers/task_controller.dart`
- `lib/features/tasks/presentation/controllers/project_controller.dart`

**Implementation Steps**:
1. Add workspace archive check to data queries:
   - Before querying projects/tasks, check if workspace is archived
   - Return empty list or error if workspace is archived
2. Update project queries:
   - Check workspace archive status
   - Filter out projects from archived workspaces
3. Update task queries:
   - Check workspace archive status
   - Filter out tasks from archived workspaces
4. Update report queries:
   - Check workspace archive status
   - Filter out reports from archived workspaces
5. Add workspace validation:
   - Validate workspace is active before data operations
   - Show error if trying to access archived workspace data

**Expected Results**:
- ✅ Data queries filter out archived workspaces
- ✅ Archived workspace data is not accessible
- ✅ Validation works correctly

**Test Criteria**:
- Test: Try to access archived workspace data, verify it's blocked
- Test: Verify data queries filter correctly

---

### Task 13: Add Archive Status to Workspace Display

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add visual indicators for archived workspaces in UI.

**Files to Modify**:
- `lib/features/workspace/presentation/widgets/workspace_selector.dart`
- `lib/features/workspace/presentation/pages/workspace_management_page.dart`

**Implementation Steps**:
1. Add archive badge/indicator:
   - Show "Archived" badge on archived workspaces
   - Use different styling (grayed out, etc.)
2. Update workspace selector:
   - Show archive status (if archived workspaces are shown)
   - Style archived workspaces differently
3. Update workspace cards:
   - Show archive date
   - Show archived by (if available)
   - Use visual indicators

**Expected Results**:
- ✅ Archive status is displayed visually
- ✅ Archived workspaces are clearly marked
- ✅ Visual indicators are clear

**Test Criteria**:
- Manual test: Verify archive indicators are displayed
- Test: Verify visual indicators are clear

---

### Task 14: Add Archive/Restore Audit Logging

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add audit logging for workspace archive/restore operations (if audit logging exists).

**Files to Modify**:
- `lib/features/workspace/domain/usecases/archive_workspace.dart`
- `lib/features/workspace/domain/usecases/restore_workspace.dart`
- `lib/features/workspace/domain/services/workspace_audit_service.dart` (if exists)

**Implementation Steps**:
1. Integrate with audit service (if exists):
   - Log archive operation after successful archive
   - Log restore operation after successful restore
2. Create audit log entries:
   - Archive: Action "workspace_archived", user, workspace, timestamp, reason (if provided)
   - Restore: Action "workspace_restored", user, workspace, timestamp
3. Store audit logs in Firebase
4. Handle audit logging errors:
   - Don't fail archive/restore if audit logging fails
   - Log audit logging errors separately

**Expected Results**:
- ✅ Archive/restore operations are logged
- ✅ Audit log entries contain correct information
- ✅ Audit logging doesn't block operations

**Test Criteria**:
- Test: Verify audit logs are created
- Test: Verify audit log contains correct information

**Note**: This task depends on audit logging system being implemented (Task 2 from GOVERNANCE_SAFETY_TASKS.md).

---

### Task 15: Add Unit Tests for Archive Process

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for workspace archive/restore functionality.

**Files to Create/Modify**:
- `test/features/workspace/domain/usecases/archive_workspace_test.dart`
- `test/features/workspace/domain/usecases/restore_workspace_test.dart`
- `test/features/workspace/presentation/controllers/workspace_controller_test.dart`

**Implementation Steps**:
1. Test `ArchiveWorkspace` use case:
   - Test successful archive
   - Test validation (not Account Holder, workspace not found, etc.)
   - Test workspace switching
   - Test error handling
2. Test `RestoreWorkspace` use case:
   - Test successful restore
   - Test validation
   - Test error handling
3. Test `WorkspaceController` methods:
   - Test archive workspace
   - Test restore workspace
   - Test permission checks
4. Test repository methods:
   - Test archive workspace
   - Test restore workspace
   - Test get archived workspaces
5. Test filtering:
   - Test archived workspaces are filtered from queries
   - Test active workspaces are returned

**Expected Results**:
- ✅ Unit tests cover archive/restore functionality
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Add Archive Fields to Workspace Entity (Critical - Foundation)
2. **Task 2**: Create Archive Workspace Use Case (Critical - Core Feature)
3. **Task 3**: Create Restore Workspace Use Case (Critical - Core Feature)
4. **Task 5**: Add Archive/Restore to Repository (Critical - Data Layer)
5. **Task 6**: Add Archive/Restore to Remote Data Source (Critical - Data Layer)
6. **Task 4**: Add Archive/Restore Methods to WorkspaceController (High Priority - Controller Layer)
7. **Task 7**: Filter Archived Workspaces from Queries (High Priority - Data Integrity)
8. **Task 12**: Add Archive Filtering to Data Queries (High Priority - Data Integrity)
9. **Task 11**: Handle Current Workspace Archiving (High Priority - User Experience)
10. **Task 8**: Create Archive Workspace UI (High Priority - UI)
11. **Task 9**: Create Archived Workspaces View (Medium Priority - Feature Completeness)
12. **Task 10**: Create Restore Workspace UI (High Priority - UI)
13. **Task 13**: Add Archive Status to Workspace Display (Low Priority - UX)
14. **Task 14**: Add Archive/Restore Audit Logging (Medium Priority - Governance)
15. **Task 15**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Workspace entity has archive fields
- ✅ Archive workspace use case exists
- ✅ Restore workspace use case exists
- ✅ Repository methods exist
- ✅ Remote data source methods exist
- ✅ Controller methods exist
- ✅ Archived workspaces are filtered from queries
- ✅ Archive workspace UI exists
- ✅ Archived workspaces view exists
- ✅ Restore workspace UI exists
- ✅ Current workspace archiving is handled
- ✅ Data queries filter archived workspaces
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ Only Account Holder/Admin can archive/restore
- ✅ No known bugs or issues

---

## Dependencies

- **WorkspaceController**: Must provide workspace operations
- **WorkspaceRepository**: Must support archive/restore operations
- **WorkspaceRemoteDataSource**: Must support archive/restore in Firebase
- **Firebase Realtime Database**: Must support workspace archive fields
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications
- **WorkspaceAuditService**: Required for audit logging (if audit logging is implemented)

---

## Notes

1. **Soft Delete**: Archive is a soft delete mechanism - data is preserved, workspace is hidden. This is different from hard delete which permanently removes data.

2. **Data Preservation**: All workspace data (projects, tasks, members, settings) should be preserved when archiving for potential restoration.

3. **Filtering**: Archived workspaces must be filtered out from all normal queries and UI lists to prevent accidental access.

4. **Restore**: Archived workspaces should be restorable, bringing them back to active state with all data intact.

5. **Permission**: Only Account Holder/Admin should be able to archive/restore workspaces.

6. **Current Workspace**: Special handling is needed when archiving the currently active workspace - user should be switched to another workspace automatically.

7. **Last Workspace**: Consider preventing archiving the last workspace or handling it appropriately.

8. **Audit Logging**: When audit logging is implemented, archive/restore operations should be logged for governance and compliance.

---

## Related Documentation

- `WORKSPACE_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `WORKSPACE_ARCHIVE_TEST_CASES.md` - Test cases for this feature
- `WORKSPACE_DELETE_TASKS.md` - Related delete workspace tasks
- `GOVERNANCE_SAFETY_TASKS.md` - Related audit logging tasks
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/SECURITY_RULES.md` - Security requirements
