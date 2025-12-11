# Workspace Delete - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Delete Workspace with Account Holder/Admin Permission Confirmation** feature. Currently, this feature is **PARTIAL** - backend deletion works, but UI confirmation dialog in WorkspaceManagementPage is missing and role checks need to be added to UI.

## Current Status: ⚠️ PARTIAL

### What Works:
- ✅ Backend deletion: `WorkspaceController.deleteWorkspace` checks `manage_workspace` permission
- ✅ Repository deletion: `WorkspaceRepositoryImpl.deleteWorkspace` deletes workspace/members/data
- ✅ Remote data source: `WorkspaceRemoteDataSourceImpl.deleteWorkspace` removes from Firebase
- ✅ WorkspaceSettingsPage: Has working delete with confirmation dialog and Account Holder check
- ✅ Permission check in controller: `hasPermission('manage_workspace')` works

### What's Missing/Broken:
- ⚠️ `WorkspaceManagementPage._confirmDeleteWorkspace` is TODO (not implemented)
- ⚠️ No confirmation dialog wired in WorkspaceManagementPage
- ⚠️ No role check in UI (only in controller)
- ⚠️ Permission inconsistency: Controller checks `manage_workspace`, but UI should check Account Holder role specifically

---

## Task List

### Task 1: Implement Delete Confirmation Dialog in WorkspaceManagementPage

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Complete the TODO in `WorkspaceManagementPage._confirmDeleteWorkspace` to show confirmation dialog before deleting workspace.

**Files to Modify**:
- `lib/features/workspace/presentation/pages/workspace_management_page.dart`

**Implementation Steps**:
1. Implement `_confirmDeleteWorkspace` method in `WorkspaceManagementPage`
2. Check user role (Account Holder) before showing dialog
3. Show confirmation dialog using `Get.dialog` or `showDialog`:
   - Title: "Delete Workspace" (from AppStrings)
   - Message: Confirmation text warning about permanent deletion
   - Cancel button
   - Delete button (styled in red/danger color)
4. If user confirms, call `WorkspaceController.deleteWorkspace(workspace.id)`
5. Handle success/error responses
6. Navigate appropriately after deletion (switch to another workspace or Dashboard)
7. Use `SnackbarService` for notifications (not ScaffoldMessenger)

**Expected Results**:
- ✅ Confirmation dialog appears when Delete button is tapped
- ✅ Dialog shows appropriate warning message
- ✅ Cancel button closes dialog without deleting
- ✅ Delete button triggers deletion after confirmation
- ✅ Success/error messages are shown using SnackbarService
- ✅ Navigation works correctly after deletion

**Test Criteria**:
- Manual test: Tap Delete button, verify dialog appears, test cancel and confirm
- Verify deletion works correctly
- Verify navigation after deletion

---

### Task 2: Add Role Check in UI for Delete Button Visibility

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add UI-level role check to hide/disable Delete Workspace button for users who are not Account Holders.

**Files to Modify**:
- `lib/features/workspace/presentation/pages/workspace_management_page.dart`
- `lib/app/pages/workspace/workspace_settings_page.dart` (if needed)

**Implementation Steps**:
1. In `WorkspaceManagementPage`, add method to check if current user is Account Holder:
   - Use `WorkspaceController.getUserWorkspaceRole()` to get user role
   - Check if role is Account Holder
2. Conditionally show/hide Delete button based on role:
   - If Account Holder: Show Delete button
   - If not Account Holder: Hide Delete button OR show disabled button with tooltip
3. Apply same logic to WorkspaceSettingsPage if not already implemented
4. Use `Obx` or `GetBuilder` for reactive UI updates when role changes

**Expected Results**:
- ✅ Delete button is only visible to Account Holders
- ✅ Delete button is hidden/disabled for Members and Admins
- ✅ UI updates reactively when role changes
- ✅ Consistent behavior across WorkspaceManagementPage and WorkspaceSettingsPage

**Test Criteria**:
- Test with Account Holder: Verify button is visible
- Test with Admin: Verify button is hidden/disabled
- Test with Member: Verify button is hidden/disabled
- Verify UI updates correctly

---

### Task 3: Align Permission Checks (Account Holder vs manage_workspace)

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Align permission checks - decide whether to check for Account Holder role specifically or `manage_workspace` permission. Based on requirements, only Account Holder should be able to delete workspace.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/features/workspace/presentation/pages/workspace_management_page.dart`
- `lib/app/pages/workspace/workspace_settings_page.dart`

**Implementation Steps**:
1. Review current implementation:
   - Controller checks `manage_workspace` permission
   - WorkspaceSettingsPage checks Account Holder role
2. Decide on approach:
   - Option A: Check Account Holder role specifically (recommended for delete)
   - Option B: Check `manage_workspace` permission (more flexible)
3. Update `WorkspaceController.deleteWorkspace` to check Account Holder role:
   - Use `getUserWorkspaceRole()` to get role
   - Check if `role.isAccountHolder`
   - Show error if not Account Holder
4. Update UI to check Account Holder role (already done in Task 2)
5. Ensure consistency across all delete entry points

**Expected Results**:
- ✅ Only Account Holders can delete workspace
- ✅ Permission checks are consistent across controller and UI
- ✅ Clear error messages for non-Account Holders
- ✅ Code is maintainable and follows single responsibility

**Test Criteria**:
- Test with Account Holder: Can delete
- Test with Admin: Cannot delete, sees error
- Test with Member: Cannot delete, sees error
- Verify error messages are clear

---

### Task 4: Create Custom Delete Confirmation Dialog Widget

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Create a reusable TD-prefixed confirmation dialog widget for dangerous actions (like delete workspace) to follow project widget patterns.

**Files to Create**:
- `lib/app/widgets/td_confirm_dialog.dart`

**Implementation Steps**:
1. Create `TDConfirmDialog` widget following TD widget patterns
2. Support parameters:
   - Title (String)
   - Message (String)
   - Confirm button text (default: "Delete")
   - Cancel button text (default: "Cancel")
   - Confirm button color (default: red/danger)
   - On confirm callback
   - On cancel callback
3. Use AppStrings for text
4. Follow TD widget design patterns
5. Use GetX for dialog management (if applicable)
6. Replace existing confirmation dialogs with this widget

**Expected Results**:
- ✅ Reusable confirmation dialog widget
- ✅ Follows TD widget patterns
- ✅ Uses AppStrings for text
- ✅ Consistent styling across app
- ✅ Easy to use in multiple places

**Test Criteria**:
- Widget test for TDConfirmDialog
- Manual test: Use in delete workspace flow
- Verify styling and behavior

---

### Task 5: Add Loading State During Deletion

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add proper loading state during workspace deletion to prevent multiple deletion requests and provide user feedback.

**Files to Modify**:
- `lib/features/workspace/presentation/pages/workspace_management_page.dart`
- `lib/app/pages/workspace/workspace_settings_page.dart`

**Implementation Steps**:
1. Use `WorkspaceController.isLoading` to track deletion state
2. Show loading indicator in confirmation dialog or on Delete button
3. Disable Delete button during loading
4. Disable Cancel button during loading (optional)
5. Prevent dialog dismissal during loading
6. Show loading state in UI appropriately

**Expected Results**:
- ✅ Loading indicator is visible during deletion
- ✅ Buttons are disabled during loading
- ✅ User cannot trigger multiple deletion requests
- ✅ Clear visual feedback during deletion process

**Test Criteria**:
- Manual test: Start deletion, verify loading state
- Verify buttons are disabled during loading
- Verify only one deletion occurs

---

### Task 6: Improve Error Handling for Deletion

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Improve error handling for workspace deletion failures (network errors, permission errors, etc.).

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/features/workspace/presentation/pages/workspace_management_page.dart`
- `lib/app/pages/workspace/workspace_settings_page.dart`

**Implementation Steps**:
1. Review current error handling in `deleteWorkspace` method
2. Add specific error messages for different failure scenarios:
   - Network errors
   - Permission denied
   - Workspace not found
   - Other errors
3. Use `SnackbarService` to show error messages (not ScaffoldMessenger)
4. Ensure errors are user-friendly and actionable
5. Handle partial deletion scenarios (if workspace is partially deleted)
6. Add retry mechanism for network errors (optional)

**Expected Results**:
- ✅ Clear error messages for different failure scenarios
- ✅ Errors are displayed using SnackbarService
- ✅ User understands what went wrong
- ✅ Appropriate actions are suggested

**Test Criteria**:
- Test network error: Verify error message
- Test permission error: Verify error message
- Test other errors: Verify appropriate messages
- Verify error messages are user-friendly

---

### Task 7: Add Workspace Deletion Audit Logging

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add audit logging for workspace deletion to track who deleted which workspace and when (for governance and safety).

**Files to Modify**:
- `lib/features/workspace/data/datasources/workspace_remote_data_source.dart`
- Create: `lib/features/workspace/domain/entities/workspace_audit_log.dart` (if needed)

**Implementation Steps**:
1. Create audit log entry when workspace is deleted:
   - User ID who deleted
   - Workspace ID
   - Timestamp
   - Reason (optional)
2. Store audit log in Firebase (e.g., `workspace_audit_logs/{workspaceId}`)
3. Log before deletion (in case deletion fails)
4. Include workspace metadata in audit log (name, type, member count, etc.)

**Expected Results**:
- ✅ Audit log entry is created for each workspace deletion
- ✅ Log includes user, workspace, timestamp, and metadata
- ✅ Log is stored in Firebase before deletion
- ✅ Logs can be retrieved for audit purposes

**Test Criteria**:
- Delete workspace, verify audit log is created
- Check Firebase for audit log entry
- Verify log contains correct information

---

### Task 8: Add Unit Tests for Delete Workspace Flow

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for workspace deletion functionality.

**Files to Create/Modify**:
- `test/features/workspace/presentation/controllers/workspace_controller_test.dart`
- `test/features/workspace/presentation/pages/workspace_management_page_test.dart`
- `test/features/workspace/data/repositories/workspace_repository_impl_test.dart`

**Implementation Steps**:
1. Test `WorkspaceController.deleteWorkspace`:
   - Test successful deletion
   - Test permission denied
   - Test network errors
   - Test workspace not found
2. Test `WorkspaceRepositoryImpl.deleteWorkspace`:
   - Test successful deletion
   - Test Firebase errors
3. Test `WorkspaceManagementPage`:
   - Test delete button visibility based on role
   - Test confirmation dialog
   - Test deletion flow
4. Test permission checks
5. Test workspace switching after deletion

**Expected Results**:
- ✅ Unit tests cover delete workspace functionality
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass
- ✅ Edge cases are covered

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

### Task 9: Add Integration Tests for Delete Workspace

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Write integration tests for complete workspace deletion flow including Firebase persistence.

**Files to Create**:
- `test/features/workspace/integration/workspace_delete_integration_test.dart`

**Implementation Steps**:
1. Test complete flow: Load workspace → Delete → Verify removal
2. Test with Firebase emulator or test environment
3. Test permission checks
4. Test data deletion from Firebase
5. Test workspace switching after deletion
6. Test error scenarios

**Expected Results**:
- ✅ Integration tests cover complete delete flow
- ✅ Tests verify Firebase deletion
- ✅ All integration tests pass

**Test Criteria**:
- Run integration tests
- Verify tests pass with Firebase emulator

---

### Task 10: Add Workspace Deletion Warning for Data Loss

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Enhance confirmation dialog to show detailed warning about data loss (tasks, projects, members, etc.).

**Files to Modify**:
- `lib/features/workspace/presentation/pages/workspace_management_page.dart`
- `lib/app/pages/workspace/workspace_settings_page.dart`

**Implementation Steps**:
1. Before showing confirmation dialog, fetch workspace statistics:
   - Number of tasks
   - Number of projects
   - Number of members
   - Other data counts
2. Display statistics in confirmation dialog:
   - "This workspace contains X tasks, Y projects, and Z members"
   - "All data will be permanently deleted"
3. Make warning more prominent
4. Optionally require typing workspace name to confirm (advanced)

**Expected Results**:
- ✅ Confirmation dialog shows data loss warning
- ✅ Statistics are displayed to user
- ✅ User understands consequences of deletion
- ✅ Warning is clear and prominent

**Test Criteria**:
- Manual test: Delete workspace, verify statistics are shown
- Verify warning is clear and understandable

---

## Implementation Priority Order

1. **Task 1**: Implement Delete Confirmation Dialog in WorkspaceManagementPage (Critical - Currently TODO)
2. **Task 2**: Add Role Check in UI for Delete Button Visibility (Critical - Security)
3. **Task 3**: Align Permission Checks (Important - Consistency)
4. **Task 5**: Add Loading State During Deletion (Important - UX)
5. **Task 6**: Improve Error Handling (Important - UX)
6. **Task 8**: Add Unit Tests (Important - Quality)
7. **Task 4**: Create Custom Delete Confirmation Dialog Widget (Nice to have)
8. **Task 10**: Add Workspace Deletion Warning for Data Loss (Nice to have)
9. **Task 7**: Add Workspace Deletion Audit Logging (Nice to have)
10. **Task 9**: Add Integration Tests (Nice to have)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Users can delete workspace from both WorkspaceSettingsPage and WorkspaceManagementPage
- ✅ Confirmation dialog appears before deletion in both locations
- ✅ Only Account Holders can delete workspace (checked in both UI and controller)
- ✅ All workspace data is deleted from Firebase
- ✅ App handles workspace switching correctly after deletion
- ✅ Error handling works for all failure scenarios
- ✅ Loading states work correctly
- ✅ Unit tests have minimum 80% coverage
- ✅ Integration tests pass
- ✅ No known bugs or issues

---

## Dependencies

- **Firebase Realtime Database**: Must support deleting workspace, members, and data
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets for UI components
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications
- **WorkspaceController**: Must have `getUserWorkspaceRole()` method

---

## Notes

1. **Two Delete Locations**: 
   - WorkspaceSettingsPage: Already has working delete with confirmation
   - WorkspaceManagementPage: Delete is TODO (needs implementation)

2. **Permission vs Role**: 
   - Current: Controller checks `manage_workspace` permission
   - Requirement: Only Account Holder should delete
   - Need to align: Check Account Holder role specifically for delete

3. **Confirmation Dialog**: 
   - Should be consistent across both pages
   - Should use AppStrings for text
   - Should follow TD widget patterns (if custom widget is created)

4. **Data Deletion**: 
   - Must delete workspace, members, and workspace_data from Firebase
   - Current implementation already does this correctly

5. **Workspace Switching**: 
   - After deletion, app should switch to another workspace
   - If no other workspace, show empty state or prompt to create

6. **Error Handling**: 
   - Network errors should be handled gracefully
   - Permission errors should show clear messages
   - Partial deletion should be prevented (atomic operation)

---

## Related Documentation

- `WORKSPACE_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `WORKSPACE_DELETE_TEST_CASES.md` - Test cases for this feature
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/CODING_STANDARDS.md` - Coding standards
- `rules/SECURITY_RULES.md` - Security requirements

