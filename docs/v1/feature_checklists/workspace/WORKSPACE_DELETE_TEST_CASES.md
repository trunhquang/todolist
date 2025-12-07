# Workspace Delete Test Cases

## Overview
This document contains step-by-step test cases for testing the **Delete Workspace with Account Holder/Admin Permission Confirmation** feature. This feature is currently **PARTIAL** - backend deletion works, but UI confirmation dialog in WorkspaceManagementPage is missing.

## Prerequisites
- User must be logged into the application
- User must have a workspace
- Device should have internet connection (for Firebase sync)
- For permission testing: Need test accounts with different roles (Account Holder, Admin, Member)

---

## Test Case 1: Delete Workspace from WorkspaceSettingsPage - Account Holder - Happy Path

**Objective**: Verify successful deletion of workspace by Account Holder from Workspace Settings page.

**Preconditions**:
- User is logged in
- User has Account Holder role in the workspace
- User is on Workspace Settings screen
- Workspace has some data (tasks, projects, members)

**Steps**:
1. Navigate to Workspace Settings screen:
   - From Dashboard, tap on "Workspace Settings" card/button
   - OR navigate via menu/settings to Workspace Settings
2. Verify the Workspace Settings screen is displayed
3. Scroll down to locate the "Danger Zone" section
4. Verify "Delete Workspace" button is visible in Danger Zone
5. Tap the "Delete Workspace" button
6. Verify a confirmation dialog appears with:
   - Title: "Delete Workspace"
   - Message: Confirmation text (e.g., "Are you sure you want to delete this workspace? This action cannot be undone.")
   - "Cancel" button
   - "Delete" button (styled in red/danger color)
7. Read the confirmation message carefully
8. Tap the "Delete" button in the confirmation dialog
9. Verify a loading indicator appears (if implemented)
10. Wait for the deletion process to complete
11. Verify a success message/snackbar appears (e.g., "Workspace deleted successfully")
12. Verify the app navigates to Dashboard (or appropriate screen)
13. Verify the deleted workspace no longer appears in workspace list/selector
14. Verify the app switches to another workspace (if available) or shows empty state
15. Verify workspace data is deleted from Firebase:
    - Workspace record is removed
    - Workspace members are removed
    - Workspace data is removed

**Expected Results**:
- ✅ Confirmation dialog appears before deletion
- ✅ Workspace is deleted successfully
- ✅ Success message is displayed
- ✅ User is navigated away from deleted workspace
- ✅ Workspace is removed from workspace list
- ✅ All workspace data is deleted from Firebase
- ✅ App handles workspace switching correctly

**Post-conditions**:
- Workspace is completely removed from Firebase
- User is on Dashboard or another workspace
- Deleted workspace is not accessible

---

## Test Case 2: Delete Workspace - Cancel Confirmation

**Objective**: Verify cancel button in confirmation dialog prevents deletion.

**Preconditions**:
- User is logged in
- User has Account Holder role
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, locate "Delete Workspace" button
2. Tap the "Delete Workspace" button
3. Verify confirmation dialog appears
4. Tap the "Cancel" button in the confirmation dialog
5. Verify the dialog closes
6. Verify user remains on Workspace Settings screen
7. Verify workspace is NOT deleted
8. Verify no success/error messages appear
9. Verify workspace still appears in workspace list
10. Navigate to Dashboard and verify workspace is still accessible

**Expected Results**:
- ✅ Cancel button closes dialog without deleting
- ✅ Workspace remains intact
- ✅ User stays on Workspace Settings screen
- ✅ No deletion occurs

---

## Test Case 3: Delete Workspace - Permission Denied (Member Role)

**Objective**: Verify that users with Member role cannot delete workspace.

**Preconditions**:
- User is logged in
- User has Member role (NOT Account Holder or Admin)
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, scroll to "Danger Zone" section
2. Verify one of the following:
   - "Delete Workspace" button is NOT visible (hidden for Members)
   - OR "Delete Workspace" button is visible but disabled
   - OR button is visible but shows error when tapped
3. If button is visible, tap the "Delete Workspace" button
4. Verify one of the following:
   - Error message appears: "Only Account Holder can delete workspace"
   - OR "Permission denied" error
   - OR Confirmation dialog does NOT appear
5. Verify workspace is NOT deleted
6. Verify user remains on Workspace Settings screen

**Expected Results**:
- ✅ Members cannot delete workspace
- ✅ Appropriate error message is displayed
- ✅ Workspace remains intact
- ✅ Permission check works correctly

---

## Test Case 4: Delete Workspace - Permission Denied (Admin Role)

**Objective**: Verify that Admin users cannot delete workspace (only Account Holder can delete).

**Preconditions**:
- User is logged in
- User has Admin role (NOT Account Holder)
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, scroll to "Danger Zone" section
2. Verify "Delete Workspace" button is visible (Admin may see it)
3. Tap the "Delete Workspace" button
4. Verify one of the following:
   - Error message appears: "Only Account Holder can delete workspace"
   - OR Confirmation dialog does NOT appear
   - OR Error appears after attempting to confirm
5. Verify workspace is NOT deleted
6. Verify appropriate error message is displayed

**Expected Results**:
- ✅ Admin cannot delete workspace
- ✅ Only Account Holder can delete workspace
- ✅ Appropriate error message is displayed
- ✅ Workspace remains intact

**Note**: Based on audit report, controller checks `manage_workspace` permission, but UI should check for Account Holder role specifically.

---

## Test Case 5: Delete Workspace from WorkspaceManagementPage (CURRENTLY BROKEN)

**Objective**: Verify delete workspace functionality from Workspace Management page.

**Preconditions**:
- User is logged in
- User has Account Holder role
- User is on Workspace Management screen

**Steps**:
1. Navigate to Workspace Management screen:
   - From Dashboard or menu, navigate to "Manage Workspace" or "Workspace Management"
2. Verify the Workspace Management screen is displayed
3. Scroll down to locate the "Danger Zone" section
4. Verify "Delete Workspace" button is visible
5. Tap the "Delete Workspace" button
6. Verify one of the following:
   - **If implemented**: Confirmation dialog appears (same as Test Case 1)
   - **If NOT implemented**: Info message appears "Delete workspace confirmation coming soon" (this is expected based on audit report)
7. If confirmation dialog appears:
   - Follow steps from Test Case 1
8. If info message appears:
   - Document that this feature is not yet implemented
   - Note that `_confirmDeleteWorkspace` is TODO

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Delete confirmation is NOT implemented in WorkspaceManagementPage
- ✅ **When implemented**: Should work same as WorkspaceSettingsPage

---

## Test Case 6: Delete Workspace - Network Error Handling

**Objective**: Verify error handling when network connection fails during deletion.

**Preconditions**:
- User is logged in
- User has Account Holder role
- User is on Workspace Settings screen
- Device internet connection can be disabled

**Steps**:
1. On the Workspace Settings screen, tap "Delete Workspace" button
2. Verify confirmation dialog appears
3. Tap "Delete" button in confirmation dialog
4. Immediately disable internet connection (Airplane mode or disable WiFi/Mobile data)
5. Wait for network timeout/error
6. Verify an error message appears (e.g., "Network error" or "Failed to delete workspace")
7. Verify loading indicator disappears (if shown)
8. Verify user remains on Workspace Settings screen
9. Verify workspace is NOT deleted
10. Verify workspace still appears in workspace list
11. Re-enable internet connection
12. Try deleting again
13. Verify deletion succeeds this time

**Expected Results**:
- ✅ Error message displayed for network failures
- ✅ Workspace is not deleted on network error
- ✅ User can retry after network is restored
- ✅ Workspace remains intact after failed deletion

---

## Test Case 7: Delete Workspace - Loading State

**Objective**: Verify loading state during workspace deletion.

**Preconditions**:
- User is logged in
- User has Account Holder role
- User is on Workspace Settings screen
- Device has internet connection

**Steps**:
1. On the Workspace Settings screen, tap "Delete Workspace" button
2. Verify confirmation dialog appears
3. Tap "Delete" button in confirmation dialog
4. Immediately verify:
   - Loading indicator appears (spinner/progress)
   - Delete button is disabled (if visible)
   - Cancel button is disabled (if visible)
   - Dialog cannot be dismissed during loading
5. Wait for deletion to complete
6. Verify loading indicator disappears
7. Verify success message appears
8. Verify navigation occurs

**Expected Results**:
- ✅ Loading indicator is visible during deletion
- ✅ UI is disabled during loading
- ✅ User cannot trigger multiple deletion requests
- ✅ Loading state clears after completion

---

## Test Case 8: Delete Workspace - Verify Data Deletion

**Objective**: Verify that all workspace data is deleted from Firebase.

**Preconditions**:
- User is logged in
- User has Account Holder role
- Workspace has:
  - Multiple members
  - Tasks
  - Projects
  - Other workspace data

**Steps**:
1. Note the workspace ID before deletion
2. Delete the workspace following Test Case 1 steps
3. Verify workspace is deleted successfully
4. Check Firebase Realtime Database directly:
   - Navigate to `workspaces/{workspaceId}` - verify it's removed
   - Navigate to `workspace_members/{workspaceId}` - verify all members are removed
   - Navigate to `workspace_data/{workspaceId}` - verify all data is removed
5. Verify workspace no longer appears in app
6. Verify members of deleted workspace cannot access it

**Expected Results**:
- ✅ Workspace record is deleted from Firebase
- ✅ All workspace members are removed
- ✅ All workspace data is removed from Firebase
- ✅ Workspace is completely deleted

**Note**: This may require Firebase console access or database inspection tools.

---

## Test Case 9: Delete Workspace - Last Workspace Deletion

**Objective**: Verify behavior when deleting the last/only workspace.

**Preconditions**:
- User is logged in
- User has Account Holder role
- User has only ONE workspace (the one to be deleted)

**Steps**:
1. Verify user has only one workspace
2. On the Workspace Settings screen, tap "Delete Workspace" button
3. Verify confirmation dialog appears
4. Tap "Delete" button
5. Wait for deletion to complete
6. Verify success message appears
7. Verify app navigates appropriately:
   - May navigate to workspace creation screen
   - OR may show empty state
   - OR may navigate to Dashboard with no workspace
8. Verify workspace selector shows empty state or prompts to create workspace
9. Verify user can create a new workspace

**Expected Results**:
- ✅ Last workspace can be deleted
- ✅ App handles empty workspace state gracefully
- ✅ User can create new workspace after deletion
- ✅ No crashes or errors occur

---

## Test Case 10: Delete Workspace - Workspace Switching After Deletion

**Objective**: Verify workspace switching behavior after deletion.

**Preconditions**:
- User is logged in
- User has Account Holder role
- User has multiple workspaces (at least 2)

**Steps**:
1. Note the current workspace (workspace A)
2. Switch to another workspace (workspace B)
3. Switch back to workspace A
4. Delete workspace A following Test Case 1 steps
5. Verify workspace A is deleted
6. Verify app automatically switches to workspace B (or first available workspace)
7. Verify workspace A no longer appears in workspace selector
8. Verify current workspace is workspace B (or another available workspace)
9. Verify user can access workspace B normally

**Expected Results**:
- ✅ App automatically switches to another workspace after deletion
- ✅ Deleted workspace is removed from selector
- ✅ Current workspace is updated correctly
- ✅ User can continue working in remaining workspace

---

## Test Case 11: Delete Workspace - Rapid Button Taps

**Objective**: Verify handling of rapid multiple taps on Delete button.

**Preconditions**:
- User is logged in
- User has Account Holder role
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, rapidly tap "Delete Workspace" button 5-10 times
2. Verify only one confirmation dialog appears (not multiple dialogs)
3. In the confirmation dialog, rapidly tap "Delete" button 5-10 times
4. Verify only one deletion request is processed
5. Verify only one workspace is deleted (not multiple attempts)
6. Verify loading indicator appears and prevents additional taps
7. Wait for deletion to complete
8. Verify success message appears only once

**Expected Results**:
- ✅ Multiple rapid taps are handled correctly
- ✅ Only one deletion occurs
- ✅ Button is disabled during loading to prevent duplicate requests
- ✅ No duplicate dialogs or actions

---

## Test Case 12: Delete Workspace - App Backgrounding During Deletion

**Objective**: Verify behavior when app is backgrounded during workspace deletion.

**Preconditions**:
- User is logged in
- User has Account Holder role
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, tap "Delete Workspace" button
2. Verify confirmation dialog appears
3. Tap "Delete" button
4. Immediately background the app (press home button or switch apps)
5. Wait 5-10 seconds
6. Return to the app
7. Verify one of the following:
   - Workspace was deleted successfully and success message appears
   - OR deletion is still in progress (loading indicator visible)
   - OR error message appears if deletion failed
8. Verify app state is consistent
9. Verify workspace deletion status is correct

**Expected Results**:
- ✅ App handles backgrounding gracefully
- ✅ Workspace deletion completes or fails appropriately
- ✅ App state is consistent after returning

---

## Test Case 13: Delete Workspace - Role Check in UI (CURRENTLY MISSING)

**Objective**: Verify that UI checks user role before showing delete button.

**Preconditions**:
- User is logged in
- User has Member or Admin role (NOT Account Holder)

**Steps**:
1. Navigate to Workspace Settings screen
2. Scroll to "Danger Zone" section
3. Verify one of the following:
   - **If implemented**: "Delete Workspace" button is NOT visible for non-Account Holders
   - **If NOT implemented**: Button is visible but shows error when tapped (this is current behavior)
4. If button is visible, verify it's disabled or shows appropriate message
5. Document the current behavior

**Expected Results**:
- ⚠️ **CURRENT STATUS**: UI may not check role (only controller checks)
- ✅ **When implemented**: Delete button should be hidden/disabled for non-Account Holders in UI

---

## Test Case 14: Delete Workspace - Confirmation Dialog Content

**Objective**: Verify confirmation dialog shows appropriate warning message.

**Preconditions**:
- User is logged in
- User has Account Holder role
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, tap "Delete Workspace" button
2. Verify confirmation dialog appears
3. Verify dialog title: "Delete Workspace"
4. Verify dialog message contains:
   - Warning about permanent deletion
   - Information that action cannot be undone
   - May include workspace name
5. Verify "Cancel" button is visible and functional
6. Verify "Delete" button is visible and styled appropriately (red/danger color)
7. Verify dialog can be dismissed by:
   - Tapping Cancel
   - Tapping outside dialog (if implemented)
   - Pressing back button (if on Android)

**Expected Results**:
- ✅ Dialog shows clear warning message
- ✅ Dialog has appropriate styling (danger/red for delete)
- ✅ Dialog can be dismissed via Cancel or back button
- ✅ Message clearly states consequences

---

## Test Case 15: Delete Workspace - Verify Members Cannot Access Deleted Workspace

**Objective**: Verify that members of deleted workspace lose access.

**Preconditions**:
- User A is Account Holder of workspace
- User B is Member of the same workspace
- Both users are logged in on different devices/accounts

**Steps**:
1. As User A (Account Holder), delete the workspace
2. Verify workspace is deleted successfully
3. As User B (Member), try to access the workspace:
   - Refresh app
   - Try to switch to the deleted workspace
   - Try to access workspace data
4. Verify User B cannot access the deleted workspace
5. Verify deleted workspace does not appear in User B's workspace list
6. Verify User B sees appropriate message or empty state

**Expected Results**:
- ✅ Members lose access to deleted workspace
- ✅ Deleted workspace is removed from all members' workspace lists
- ✅ Members cannot access workspace data after deletion

**Note**: This requires two test accounts or devices.

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Account Holder can delete workspace successfully
- [ ] Confirmation dialog appears before deletion
- [ ] Cancel button prevents deletion
- [ ] Members cannot delete workspace
- [ ] Admins cannot delete workspace (only Account Holder)
- [ ] Network errors are handled gracefully
- [ ] Loading states work correctly
- [ ] All workspace data is deleted from Firebase
- [ ] Workspace switching works after deletion
- [ ] Last workspace deletion is handled correctly
- [ ] Rapid taps are handled correctly
- [ ] App backgrounding is handled correctly
- [ ] Role check in UI works (when implemented)
- [ ] Confirmation dialog content is appropriate
- [ ] Members lose access after workspace deletion

---

## Known Issues (Based on Audit Report)

1. **WorkspaceManagementPage Delete Confirmation Missing**: 
   - `WorkspaceManagementPage._confirmDeleteWorkspace` is TODO
   - No confirmation dialog wired
   - **Status**: ⚠️ Not Implemented

2. **Role Check in UI Missing**:
   - No role check in UI (only in controller)
   - Delete button may be visible to non-Account Holders
   - **Status**: ⚠️ Missing

3. **Permission Inconsistency**:
   - Controller checks `manage_workspace` permission
   - WorkspaceSettingsPage checks for Account Holder role specifically
   - May need to align these checks
   - **Status**: ⚠️ Inconsistent

---

## Notes for Testers

1. **Two Delete Locations**: 
   - WorkspaceSettingsPage: Has working delete with confirmation (checks Account Holder)
   - WorkspaceManagementPage: Delete is TODO (not implemented)

2. **Permission Testing**: To test permission denied scenarios, you may need to:
   - Use test accounts with different roles (Member, Admin, Account Holder)
   - OR temporarily modify user role in Firebase

3. **Firebase Verification**: For critical tests (like data deletion), you may need to check Firebase Realtime Database directly to verify data is removed.

4. **Workspace Switching**: After deleting current workspace, app should automatically switch to another workspace. Test this behavior.

5. **Last Workspace**: Deleting the last workspace should be handled gracefully - app should prompt to create new workspace or show empty state.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- User role (Account Holder/Admin/Member)
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
