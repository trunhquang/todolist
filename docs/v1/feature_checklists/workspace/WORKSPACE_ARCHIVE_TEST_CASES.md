# Workspace Archive Process - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Workspace Archive Process** feature. This feature is currently **MISSING** - not implemented; only hard delete via `deleteWorkspace` exists.

## Prerequisites
- User must be logged in as Account Holder or Admin
- Workspace must exist with some data (projects, tasks, members)
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: Archive Workspace - Happy Path

**Objective**: Verify workspace can be successfully archived.

**Preconditions**:
- User is logged in as Account Holder or Admin
- User has `manage_workspace` permission
- Workspace exists with data
- Archive workspace feature is implemented

**Steps**:
1. Navigate to Workspace Management or Workspace Settings screen
2. Locate "Archive Workspace" or "Archive" option
3. Verify one of the following:
   - **If implemented**: Archive option is available
   - **If NOT implemented**: Option is not available (this is expected - current status)
4. If implemented:
   - Tap "Archive Workspace" option
   - Verify confirmation dialog appears with:
     - Warning message about archiving workspace
     - Information about what happens when archived
     - "Cancel" and "Archive" buttons
   - Read the warning message
   - Tap "Archive" button
   - Verify loading indicator appears
   - Wait for archive to complete
   - Verify success message appears: "Workspace archived successfully"
   - Verify workspace is archived (not deleted)
   - Verify workspace data is preserved in Firebase
   - Verify workspace is hidden from normal workspace list
   - Verify workspace appears in archived workspaces list (if implemented)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Archive workspace flow is NOT available (missing)
- ✅ **When implemented**: Workspace can be archived
- ✅ Archive requires confirmation
- ✅ Workspace data is preserved
- ✅ Workspace is hidden from normal list

---

## Test Case 2: Archive Workspace - Permission Check

**Objective**: Verify only Account Holder/Admin can archive workspace.

**Preconditions**:
- User is logged in as Member (NOT Account Holder/Admin)
- Workspace exists
- Archive workspace feature is implemented

**Steps**:
1. Navigate to Workspace Management or Workspace Settings screen
2. Verify one of the following:
   - "Archive Workspace" option is not visible
   - OR "Archive Workspace" option is disabled
   - OR Error message appears when trying to access
3. Try to access archive workspace (if option exists):
   - Tap "Archive Workspace" option (if visible)
   - Verify error message appears: "Only Account Holder/Admin can archive workspace" or "Permission denied"
4. As Admin:
   - Verify "Archive Workspace" option is available
   - Verify archive workspace works correctly
5. As Account Holder:
   - Verify "Archive Workspace" option is available
   - Verify archive workspace works correctly

**Expected Results**:
- ✅ Only Account Holder/Admin can archive workspace
- ✅ Member cannot archive workspace
- ✅ Permission checks are enforced
- ✅ Appropriate error messages are shown

---

## Test Case 3: Archive Workspace - Data Preservation

**Objective**: Verify workspace data is preserved when archived.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has projects, tasks, members, settings
- Archive workspace feature is implemented

**Steps**:
1. Note workspace data before archiving:
   - List of projects
   - List of tasks
   - List of members
   - Workspace settings
2. Archive the workspace
3. Verify data is preserved in Firebase:
   - Check Firebase for workspace data
   - Verify projects still exist
   - Verify tasks still exist
   - Verify members still exist
   - Verify settings are preserved
4. Verify workspace is marked as archived:
   - Check `isArchived` field is true
   - Check `archivedAt` field is set
   - Check workspace is not deleted from Firebase

**Expected Results**:
- ✅ All workspace data is preserved
- ✅ Workspace is marked as archived (not deleted)
- ✅ Data remains accessible (for restore)

---

## Test Case 4: Archive Workspace - Hidden from Normal List

**Objective**: Verify archived workspace is hidden from normal workspace list.

**Preconditions**:
- User is logged in
- Workspace is archived
- Archive workspace feature is implemented

**Steps**:
1. Navigate to workspace selector or workspace list
2. Verify archived workspace is NOT displayed:
   - Archived workspace does not appear in normal list
   - Only active (non-archived) workspaces are shown
3. Verify workspace switching:
   - Try to switch to archived workspace
   - Verify archived workspace is not available for switching
   - OR verify error message if trying to switch
4. Verify workspace queries:
   - `getUserWorkspaces` should not return archived workspaces
   - Workspace selector should not show archived workspaces

**Expected Results**:
- ✅ Archived workspaces are hidden from normal list
- ✅ Archived workspaces cannot be switched to
- ✅ Workspace queries filter out archived workspaces

---

## Test Case 5: View Archived Workspaces

**Objective**: Verify archived workspaces can be viewed in a separate list.

**Preconditions**:
- User is logged in as Account Holder or Admin
- User has archived workspaces
- Archive workspace feature is implemented

**Steps**:
1. Navigate to Workspace Management or Settings screen
2. Locate "Archived Workspaces" or "View Archived" option
3. Verify one of the following:
   - **If implemented**: Archived workspaces view is available
   - **If NOT implemented**: View is not available (this is expected)
4. If implemented:
   - Tap "Archived Workspaces" option
   - Verify archived workspaces list appears
   - Verify archived workspaces are displayed with:
     - Workspace name
     - Archive date
     - "Archived" badge or indicator
   - Verify archived workspaces can be restored or permanently deleted

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Archived workspaces view is NOT available (missing)
- ✅ **When implemented**: Archived workspaces can be viewed
- ✅ Archived workspaces are clearly marked
- ✅ Archive date is displayed

---

## Test Case 6: Restore Archived Workspace

**Objective**: Verify archived workspace can be restored.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Workspace is archived
- Restore workspace feature is implemented

**Steps**:
1. Navigate to Archived Workspaces view
2. Locate an archived workspace
3. Tap "Restore" or "Unarchive" button
4. Verify confirmation dialog appears (if implemented):
   - Confirmation message
   - "Cancel" and "Restore" buttons
5. Tap "Restore" button
6. Verify loading indicator appears
7. Wait for restore to complete
8. Verify success message appears: "Workspace restored successfully"
9. Verify workspace is restored:
   - Workspace `isArchived` field is false
   - Workspace `archivedAt` field is cleared
   - Workspace appears in normal workspace list
   - Workspace can be switched to
   - Workspace data is accessible
10. Verify workspace functions normally:
    - Can access projects
    - Can access tasks
    - Can access members
    - Can access settings

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Restore workspace flow is NOT available (missing)
- ✅ **When implemented**: Workspace can be restored
- ✅ Workspace is restored correctly
- ✅ Workspace functions normally after restore

---

## Test Case 7: Restore Archived Workspace - Permission Check

**Objective**: Verify only Account Holder/Admin can restore workspace.

**Preconditions**:
- User is logged in as Member (NOT Account Holder/Admin)
- Workspace is archived
- Restore workspace feature is implemented

**Steps**:
1. Navigate to Archived Workspaces view (if accessible)
2. Verify one of the following:
   - "Restore" option is not visible
   - OR "Restore" option is disabled
   - OR Error message appears when trying to restore
3. Try to restore archived workspace (if option exists):
   - Tap "Restore" button (if visible)
   - Verify error message: "Only Account Holder/Admin can restore workspace" or "Permission denied"
4. As Admin:
   - Verify can restore archived workspace
5. As Account Holder:
   - Verify can restore archived workspace

**Expected Results**:
- ✅ Only Account Holder/Admin can restore workspace
- ✅ Member cannot restore workspace
- ✅ Permission checks are enforced

---

## Test Case 8: Archive Workspace - Current Workspace

**Objective**: Verify behavior when archiving the currently active workspace.

**Preconditions**:
- User is logged in as Account Holder
- User is currently viewing/using a workspace
- Archive workspace feature is implemented

**Steps**:
1. Verify current workspace is active
2. Archive the current workspace
3. Verify workspace switching:
   - Current workspace is archived
   - User is automatically switched to another workspace (if available)
   - OR user is shown workspace selection screen
   - OR user is shown message to select another workspace
4. Verify archived workspace is no longer accessible:
   - Cannot access archived workspace's data
   - Cannot switch back to archived workspace
5. Verify workspace selector:
   - Archived workspace does not appear in selector
   - Other workspaces are available

**Expected Results**:
- ✅ Current workspace can be archived
- ✅ User is switched to another workspace automatically
- ✅ Archived workspace is no longer accessible
- ✅ Workspace selector updates correctly

---

## Test Case 9: Archive Workspace - Last Workspace

**Objective**: Verify behavior when archiving the last workspace.

**Preconditions**:
- User is logged in as Account Holder
- User has only one workspace
- Archive workspace feature is implemented

**Steps**:
1. Verify user has only one workspace
2. Try to archive the last workspace
3. Verify one of the following behaviors:
   - **Option A**: Archive is blocked with message "Cannot archive last workspace"
   - **Option B**: Archive is allowed, user is shown message to create new workspace
   - **Option C**: Archive is allowed, user is redirected to create workspace screen
4. If archive is allowed:
   - Verify workspace is archived
   - Verify user cannot access any workspace
   - Verify user is prompted to create new workspace
5. Create a new workspace
6. Verify user can access the new workspace

**Expected Results**:
- ✅ Last workspace archiving is handled appropriately
- ✅ User is not left without any workspace
- ✅ User can create new workspace if needed

---

## Test Case 10: Archive Workspace - Audit Logging

**Objective**: Verify workspace archiving is logged in audit log (if audit logging exists).

**Preconditions**:
- User is logged in as Account Holder
- Workspace exists
- Archive workspace and audit logging are implemented

**Steps**:
1. Archive a workspace
2. Navigate to Audit Log screen (if implemented)
3. Verify audit log entry is created:
   - Action: "workspace_archived" or "archive"
   - User: Current user ID/name (who archived)
   - Workspace: Archived workspace ID/name
   - Timestamp: Archive date/time
   - Details: Archive information
4. Restore the workspace
5. Verify audit log entry is created:
   - Action: "workspace_restored" or "restore"
   - User: Current user ID/name (who restored)
   - Workspace: Restored workspace ID/name
   - Timestamp: Restore date/time
6. Verify audit log entries are stored in Firebase

**Expected Results**:
- ✅ Workspace archiving is logged (if audit logging exists)
- ✅ Workspace restoration is logged (if audit logging exists)
- ✅ Audit log entries contain correct information

**Note**: This test case applies when audit logging is implemented.

---

## Test Case 11: Archive Workspace - Filtering in Queries

**Objective**: Verify archived workspaces are filtered out from normal queries.

**Preconditions**:
- User is logged in
- User has both active and archived workspaces
- Archive workspace feature is implemented

**Steps**:
1. Verify user has multiple workspaces (some active, some archived)
2. Check `getUserWorkspaces` query:
   - Verify only active workspaces are returned
   - Verify archived workspaces are filtered out
3. Check workspace selector:
   - Verify only active workspaces are shown
   - Verify archived workspaces are not shown
4. Check workspace switching:
   - Verify can only switch to active workspaces
   - Verify cannot switch to archived workspaces
5. Check workspace data queries:
   - Verify projects/tasks queries work only for active workspaces
   - Verify archived workspace data is not accessible through normal queries

**Expected Results**:
- ✅ Archived workspaces are filtered from normal queries
- ✅ Only active workspaces are accessible
- ✅ Filtering is consistent across all queries

---

## Test Case 12: Archive Workspace - Data Access After Archive

**Objective**: Verify data access is restricted for archived workspaces.

**Preconditions**:
- User is logged in
- Workspace is archived
- Archive workspace feature is implemented

**Steps**:
1. Try to access archived workspace's projects:
   - Navigate to Projects screen
   - Verify archived workspace's projects are not accessible
   - OR verify error message if trying to access
2. Try to access archived workspace's tasks:
   - Navigate to Tasks screen
   - Verify archived workspace's tasks are not accessible
   - OR verify error message if trying to access
3. Try to access archived workspace's members:
   - Navigate to User Management screen
   - Verify archived workspace's members are not accessible
4. Try to access archived workspace's settings:
   - Navigate to Workspace Settings screen
   - Verify archived workspace's settings are not accessible
5. Restore the workspace
6. Verify data is accessible again:
   - Projects are accessible
   - Tasks are accessible
   - Members are accessible
   - Settings are accessible

**Expected Results**:
- ✅ Archived workspace data is not accessible
- ✅ Data is accessible again after restore
- ✅ Access restrictions are enforced

---

## Test Case 13: Archive Workspace - Permanent Delete After Archive

**Objective**: Verify archived workspace can be permanently deleted (if implemented).

**Preconditions**:
- User is logged in as Account Holder
- Workspace is archived
- Permanent delete after archive feature is implemented

**Steps**:
1. Navigate to Archived Workspaces view
2. Locate an archived workspace
3. Verify "Permanently Delete" or "Delete Forever" option is available (if implemented)
4. Tap "Permanently Delete" option
5. Verify confirmation dialog appears:
   - Strong warning about permanent deletion
   - Information that data cannot be recovered
   - Confirmation text input (e.g., "DELETE")
   - "Cancel" and "Delete Forever" buttons
6. Enter confirmation text
7. Tap "Delete Forever" button
8. Verify final confirmation dialog appears
9. Confirm permanent deletion
10. Verify workspace is permanently deleted:
    - Workspace is removed from Firebase
    - Workspace data is deleted
    - Workspace cannot be restored
11. Verify deletion is logged in audit log (if audit logging exists)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permanent delete after archive is NOT available (missing)
- ✅ **When implemented**: Archived workspace can be permanently deleted
- ✅ Permanent deletion requires strong confirmation
- ✅ Workspace is permanently removed

**Note**: This is an optional feature. Some systems may not allow permanent deletion.

---

## Test Case 14: Archive Workspace - Auto-Archive After Inactivity

**Objective**: Verify workspace can be auto-archived after period of inactivity (if implemented).

**Preconditions**:
- User is logged in as Account Holder
- Workspace exists
- Auto-archive feature is implemented and configured

**Steps**:
1. Configure auto-archive settings:
   - Enable auto-archive
   - Set inactivity period (e.g., 90 days)
   - Save settings
2. Simulate workspace inactivity:
   - No activity for configured period
   - OR manually trigger auto-archive (for testing)
3. Verify workspace is auto-archived:
   - Workspace is marked as archived
   - Archive date is set
   - Workspace is hidden from normal list
4. Verify notification is sent (if implemented):
   - Email/notification about auto-archive
   - Information about how to restore
5. Restore the workspace
6. Verify workspace functions normally

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Auto-archive is NOT available (missing)
- ✅ **When implemented**: Workspace can be auto-archived
- ✅ Auto-archive works after inactivity period
- ✅ Notification is sent (if implemented)

**Note**: This is an optional feature.

---

## Test Case 15: Archive Workspace - Bulk Archive

**Objective**: Verify multiple workspaces can be archived at once (if implemented).

**Preconditions**:
- User is logged in as Account Holder
- User has multiple workspaces
- Bulk archive feature is implemented

**Steps**:
1. Navigate to Workspace Management screen
2. Locate "Bulk Actions" or "Select Multiple" option
3. Select multiple workspaces to archive
4. Tap "Archive Selected" button
5. Verify confirmation dialog appears:
   - List of workspaces to be archived
   - Warning message
   - "Cancel" and "Archive All" buttons
6. Confirm bulk archive
7. Verify all selected workspaces are archived:
   - All workspaces are marked as archived
   - All workspaces are hidden from normal list
   - All workspaces appear in archived list
8. Verify bulk archive is logged (if audit logging exists)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Bulk archive is NOT available (missing)
- ✅ **When implemented**: Multiple workspaces can be archived
- ✅ Bulk archive works correctly
- ✅ All selected workspaces are archived

**Note**: This is an optional feature.

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Workspace can be archived
- [ ] Only Account Holder/Admin can archive workspace
- [ ] Workspace data is preserved when archived
- [ ] Archived workspace is hidden from normal list
- [ ] Archived workspaces can be viewed separately
- [ ] Workspace can be restored
- [ ] Only Account Holder/Admin can restore workspace
- [ ] Current workspace archiving works correctly
- [ ] Last workspace archiving is handled appropriately
- [ ] Workspace archiving is logged (if audit logging exists)
- [ ] Archived workspaces are filtered from queries
- [ ] Data access is restricted for archived workspaces
- [ ] Archived workspace can be permanently deleted (if implemented)
- [ ] Auto-archive works (if implemented)
- [ ] Bulk archive works (if implemented)

---

## Known Issues (Based on Audit Report)

1. **Archive Process Missing**:
   - No archive workspace functionality
   - Only hard delete via `deleteWorkspace` exists
   - **Status**: ⛔ Missing

2. **No Archive Fields**:
   - Workspace entity has `isActive` but no `isArchived` or `archivedAt`
   - Cannot distinguish between active and archived workspaces
   - **Status**: ⛔ Missing

3. **No Archive Queries**:
   - `getUserWorkspaces` doesn't filter by archive status
   - No separate query for archived workspaces
   - **Status**: ⛔ Missing

---

## Notes for Testers

1. **Current Status**: Archive workspace is completely missing. All test cases assume the feature will be implemented.

2. **Soft Delete vs Hard Delete**: Archive is a soft delete (data preserved, workspace hidden). Hard delete permanently removes data.

3. **Data Preservation**: When archiving, all workspace data should be preserved for potential restoration.

4. **Filtering**: Archived workspaces should be filtered out from all normal queries and UI lists.

5. **Restore**: Archived workspaces should be restorable, bringing them back to active state.

6. **Permission**: Only Account Holder/Admin should be able to archive/restore workspaces.

7. **Current Workspace**: Special handling needed when archiving the currently active workspace.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- User role (Account Holder, Admin, Member)
- Current workspace
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase data (if accessible) showing archive status

