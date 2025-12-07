# Workspace User Management Test Cases

## Overview
This document contains step-by-step test cases for testing the **Workspace User Management** feature (roles, status, invite/revoke, add/remove). This feature is currently **PARTIAL** - domain logic exists, but UI in WorkspaceManagementPage is missing and permissions use strings instead of enums.

## Prerequisites
- User must be logged into the application
- User must have a workspace with `manage_users` permission (Account Holder or Admin)
- User should have access to multiple users for testing
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: View Workspace Members List

**Objective**: Verify workspace members list is displayed correctly.

**Preconditions**:
- User is logged in
- User has `manage_users` permission or is Account Holder/Admin
- Workspace has multiple members
- User is on Workspace Management or User Management screen

**Steps**:
1. Navigate to workspace member management:
   - From Dashboard, navigate to "Manage Workspace" or "User Management"
   - OR tap on "Workspace Members" in Workspace Management page
2. Verify one of the following:
   - **If UserManagementPage is accessible**: Members list is displayed
   - **If WorkspaceManagementPage._manageMembers is used**: Info message appears "Manage members functionality coming soon" (this is expected based on audit report)
3. If members list is displayed, verify:
   - All workspace members are listed
   - Member names are displayed
   - Member emails are displayed (if available)
   - Member roles are displayed (Account Holder, Admin, Member)
   - Member avatars/initials are shown
4. Verify members are sorted appropriately (by name, role, or join date)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: WorkspaceManagementPage._manageMembers is TODO
- ✅ **If UserManagementPage is used**: Members list is displayed correctly
- ✅ Member information is accurate
- ✅ All members are visible

---

## Test Case 2: Invite User to Workspace - Happy Path

**Objective**: Verify successful invitation of a user to workspace.

**Preconditions**:
- User is logged in
- User has `invite_users` permission (Account Holder or Admin)
- User is on User Management screen (or Workspace Management if implemented)

**Steps**:
1. Navigate to User Management screen
2. Verify "Invite User" button/icon is visible (if user has permission)
3. Tap the "Invite User" button
4. Verify invitation dialog/form appears with:
   - Name input field
   - Email input field
   - Role selector (optional)
   - Send Invitation button
   - Cancel button
5. Fill in invitation form:
   - Enter name: "Test User"
   - Enter email: "testuser@example.com" (use valid, unique email)
   - Select role: "Member" (or Admin if applicable)
6. Tap "Send Invitation" button
7. Verify loading indicator appears
8. Wait for invitation to be sent
9. Verify success message appears (e.g., "Invitation sent successfully")
10. Verify dialog closes
11. Verify invitation appears in invitations list (pending invitations)
12. Verify invitation is sent via email (if email service is configured)

**Expected Results**:
- ✅ Invitation dialog/form is displayed
- ✅ Invitation is sent successfully
- ✅ Success message is displayed
- ✅ Invitation appears in pending invitations list
- ✅ Invitation is stored in Firebase

---

## Test Case 3: Invite User - Email Validation

**Objective**: Verify email validation for user invitations.

**Preconditions**:
- User is logged in
- User has `invite_users` permission
- User is on User Management screen

**Steps**:
1. Navigate to User Management screen
2. Tap "Invite User" button
3. Verify invitation form appears
4. Leave email field empty
5. Tap "Send Invitation" button
6. Verify error message appears (e.g., "Please enter email")
7. Enter invalid email format (e.g., "not-an-email", "test@", "@example.com")
8. Tap "Send Invitation" button
9. Verify error message appears (e.g., "Please enter valid email")
10. Enter valid email format (e.g., "test@example.com")
11. Verify error message disappears
12. Verify form can be submitted

**Expected Results**:
- ✅ Email validation works correctly
- ✅ Invalid emails are rejected
- ✅ Valid emails are accepted
- ✅ Error messages are clear

---

## Test Case 4: Invite User - Duplicate Email

**Objective**: Verify handling of duplicate email invitations.

**Preconditions**:
- User is logged in
- User has `invite_users` permission
- User has already invited "existing@example.com" (pending invitation)
- OR user has already invited "existing@example.com" (user is already member)

**Steps**:
1. Navigate to User Management screen
2. Tap "Invite User" button
3. Enter email: "existing@example.com" (already invited or member)
4. Fill other required fields
5. Tap "Send Invitation" button
6. Verify one of the following:
   - Error message appears: "User already invited" or "User is already a member"
   - OR invitation is prevented
   - OR duplicate invitation is handled gracefully
7. Verify no duplicate invitation is created

**Expected Results**:
- ✅ Duplicate invitations are prevented
- ✅ Appropriate error message is displayed
- ✅ No duplicate invitations in list

---

## Test Case 5: Revoke Invitation

**Objective**: Verify successful revocation of pending invitation.

**Preconditions**:
- User is logged in
- User has `invite_users` permission
- Workspace has at least one pending invitation
- User is on User Management screen

**Steps**:
1. Navigate to User Management screen
2. Verify pending invitations are displayed in the list
3. Locate a pending invitation
4. Tap on the invitation card/item
5. Verify action menu or revoke button is available
6. Tap "Revoke" or "Cancel Invitation" button
7. Verify confirmation dialog appears (if implemented)
8. Confirm revocation
9. Verify loading indicator appears
10. Wait for revocation to complete
11. Verify success message appears
12. Verify invitation is removed from pending invitations list
13. Verify invitation status is updated in Firebase

**Expected Results**:
- ✅ Invitation can be revoked
- ✅ Revocation succeeds
- ✅ Invitation is removed from list
- ✅ Success message is displayed

---

## Test Case 6: Update User Role

**Objective**: Verify successful update of user role in workspace.

**Preconditions**:
- User is logged in
- User has `manage_users` permission
- Workspace has at least one member (not Account Holder)
- User is on User Management screen

**Steps**:
1. Navigate to User Management screen
2. Locate a member in the list (not Account Holder)
3. Tap on the member card/item
4. Verify action menu appears with "Edit Role" option
5. Tap "Edit Role" option
6. Verify role edit dialog appears showing:
   - Current role
   - Role dropdown/selector (Admin, Member)
   - Save button
   - Cancel button
7. Select a different role (e.g., if current is Member, select Admin)
8. Tap "Save" button
9. Verify loading indicator appears
10. Wait for role update to complete
11. Verify success message appears (e.g., "User role updated successfully")
12. Verify dialog closes
13. Verify member's role is updated in the list
14. Verify role is updated in Firebase

**Expected Results**:
- ✅ Role can be updated
- ✅ Role update succeeds
- ✅ Updated role is displayed in list
- ✅ Role is persisted to Firebase

---

## Test Case 7: Update User Role - Account Holder Protection

**Objective**: Verify Account Holder role cannot be modified.

**Preconditions**:
- User is logged in
- User has `manage_users` permission
- Workspace has Account Holder member
- User is on User Management screen

**Steps**:
1. Navigate to User Management screen
2. Locate Account Holder member in the list
3. Tap on Account Holder member card/item
4. Verify one of the following:
   - "Edit Role" option is not available/disabled
   - OR "Edit Role" option is available but shows error when tapped
5. If "Edit Role" is available, try to change role
6. Verify error message appears (e.g., "Cannot modify Account Holder permissions")
7. Verify role remains unchanged
8. Verify Account Holder role cannot be changed to Admin or Member

**Expected Results**:
- ✅ Account Holder role cannot be modified
- ✅ Appropriate error message is displayed
- ✅ Account Holder protection works correctly

---

## Test Case 8: Remove User from Workspace

**Objective**: Verify successful removal of user from workspace.

**Preconditions**:
- User is logged in
- User has `remove_users` permission
- Workspace has at least one member (not Account Holder, not current user)
- User is on User Management screen

**Steps**:
1. Navigate to User Management screen
2. Locate a member to remove (not Account Holder, not yourself)
3. Tap on the member card/item
4. Verify action menu appears with "Remove" option
5. Tap "Remove" option
6. Verify confirmation dialog appears with:
   - Warning message about removing user
   - User's name displayed
   - "Cancel" button
   - "Remove" button (styled in red/danger)
7. Read the confirmation message
8. Tap "Remove" button in confirmation dialog
9. Verify loading indicator appears
10. Wait for removal to complete
11. Verify success message appears (e.g., "User removed successfully")
12. Verify member is removed from members list
13. Verify member is removed from Firebase
14. Verify user loses access to workspace

**Expected Results**:
- ✅ User can be removed from workspace
- ✅ Confirmation dialog appears before removal
- ✅ Removal succeeds
- ✅ User is removed from list
- ✅ User is removed from Firebase
- ✅ User loses workspace access

---

## Test Case 9: Remove User - Self Removal Protection

**Objective**: Verify user cannot remove themselves from workspace.

**Preconditions**:
- User is logged in
- User has `remove_users` permission
- User is a member of the workspace (not Account Holder)
- User is on User Management screen

**Steps**:
1. Navigate to User Management screen
2. Locate your own member card/item in the list
3. Tap on your own member card
4. Verify one of the following:
   - "Remove" option is not available/disabled
   - OR "Remove" option shows error when tapped
5. If "Remove" is available, try to remove yourself
6. Verify error message appears (e.g., "Cannot remove yourself")
7. Verify you remain in the workspace

**Expected Results**:
- ✅ User cannot remove themselves
- ✅ Appropriate error message is displayed
- ✅ Self-removal protection works correctly

---

## Test Case 10: Remove User - Account Holder Protection

**Objective**: Verify Account Holder cannot be removed from workspace.

**Preconditions**:
- User is logged in
- User has `remove_users` permission
- Workspace has Account Holder member
- User is on User Management screen

**Steps**:
1. Navigate to User Management screen
2. Locate Account Holder member in the list
3. Tap on Account Holder member card
4. Verify one of the following:
   - "Remove" option is not available/disabled
   - OR "Remove" option shows error when tapped
5. If "Remove" is available, try to remove Account Holder
6. Verify error message appears (e.g., "Cannot remove Account Holder")
7. Verify Account Holder remains in workspace

**Expected Results**:
- ✅ Account Holder cannot be removed
- ✅ Appropriate error message is displayed
- ✅ Account Holder protection works correctly

---

## Test Case 11: Update User Permissions

**Objective**: Verify successful update of user permissions.

**Preconditions**:
- User is logged in
- User has `assign_permissions` permission
- Workspace has at least one member
- User is on Permission Management screen (if available)

**Steps**:
1. Navigate to Permission Management screen (if available)
2. Locate a member in the list
3. Verify member's current permissions are displayed
4. Tap on a permission toggle/checkbox to grant or revoke permission
5. Verify permission state changes
6. Tap "Save" button (if applicable)
7. Verify loading indicator appears
8. Wait for permission update to complete
9. Verify success message appears
10. Verify permission is updated in the list
11. Verify permission is persisted to Firebase
12. Verify user's access reflects the permission change

**Expected Results**:
- ✅ Permissions can be updated
- ✅ Permission toggles work correctly
- ✅ Permission updates are persisted
- ✅ User access reflects permission changes

**Note**: Permission management UI may not be fully implemented.

---

## Test Case 12: Search/Filter Members

**Objective**: Verify search/filter functionality for workspace members.

**Preconditions**:
- User is logged in
- User has access to User Management screen
- Workspace has multiple members (5+)

**Steps**:
1. Navigate to User Management screen
2. Locate search bar/field
3. Enter search query: member's name (e.g., "John")
4. Verify members list filters to show only matching members
5. Clear search query
6. Verify all members are shown again
7. Enter search query: member's email
8. Verify members list filters correctly
9. Enter search query: role name (e.g., "Admin")
10. Verify members with that role are shown
11. Enter search query that matches no members
12. Verify empty state is shown

**Expected Results**:
- ✅ Search/filter works correctly
- ✅ Search by name works
- ✅ Search by email works
- ✅ Search by role works
- ✅ Empty state is shown when no results

---

## Test Case 13: View Pending Invitations

**Objective**: Verify pending invitations are displayed correctly.

**Preconditions**:
- User is logged in
- User has `invite_users` permission
- Workspace has pending invitations
- User is on User Management screen

**Steps**:
1. Navigate to User Management screen
2. Verify pending invitations section/list is visible
3. Verify invitations are displayed with:
   - Invited user's email
   - Invited user's name (if provided)
   - Invited role
   - Invitation status (Pending)
   - Invitation date
4. Verify invitations are separate from active members
5. Verify invitations can be revoked (if user has permission)

**Expected Results**:
- ✅ Pending invitations are displayed
- ✅ Invitation information is accurate
- ✅ Invitations are distinguishable from members

---

## Test Case 14: Permission Denied - Member Role

**Objective**: Verify users without permission cannot manage members.

**Preconditions**:
- User is logged in
- User has Member role (NOT Admin or Account Holder)
- User does NOT have `manage_users` permission

**Steps**:
1. Attempt to navigate to User Management screen
2. Verify one of the following:
   - User is blocked from accessing the screen
   - OR screen is accessible but actions are disabled
   - OR error message appears
3. If screen is accessible:
   - Verify "Invite User" button is not visible or disabled
   - Verify member actions (edit role, remove) are not available
   - Try to invite user - verify error message
   - Try to edit role - verify error message
   - Try to remove user - verify error message

**Expected Results**:
- ✅ Members without permission are blocked or see errors
- ✅ Permission checks work correctly
- ✅ Appropriate error messages are displayed

---

## Test Case 15: WorkspaceManagementPage._manageMembers (CURRENTLY TODO)

**Objective**: Verify member management from Workspace Management page.

**Preconditions**:
- User is logged in
- User has `manage_users` permission
- User is on Workspace Management screen

**Steps**:
1. Navigate to Workspace Management screen
2. Locate "Workspace Members" section or "Manage Members" option
3. Tap on "Manage Members" or "Workspace Members" option
4. Verify one of the following:
   - **If implemented**: Navigates to member management screen
   - **If NOT implemented**: Info message appears "Manage members functionality coming soon" (this is expected)
5. If implemented, verify member management screen works as in Test Cases 1-14

**Expected Results**:
- ⚠️ **CURRENT STATUS**: WorkspaceManagementPage._manageMembers is TODO
- ✅ **When implemented**: Should navigate to member management screen

---

## Test Case 16: Member Status (Active/Inactive)

**Objective**: Verify member status (active/inactive) is displayed and can be managed.

**Preconditions**:
- User is logged in
- User has `manage_users` permission
- Workspace has members with different statuses
- User is on User Management screen

**Steps**:
1. Navigate to User Management screen
2. Verify member status is displayed (if implemented):
   - Active members are shown
   - Inactive members are shown (or filtered out)
3. If status management is available:
   - Try to deactivate a member
   - Verify member status changes
   - Verify inactive member loses access
4. Try to reactivate a member
5. Verify member regains access

**Expected Results**:
- ✅ Member status is displayed (if implemented)
- ✅ Status can be managed (if implemented)
- ✅ Status changes affect user access

**Note**: Status management may not be fully implemented.

---

## Test Case 17: Permissions Use Strings Instead of Enums (CURRENT ISSUE)

**Objective**: Verify permissions are checked using enums instead of strings.

**Preconditions**:
- User is logged in
- Codebase access or documentation

**Steps**:
1. Review permission checks in code:
   - Check `WorkspaceController.hasPermission()` calls
   - Check permission strings used (e.g., 'manage_users', 'invite_users')
2. Verify one of the following:
   - **If using strings**: Document that permissions use strings (current behavior)
   - **If using enums**: Verify enums are used consistently
3. Test permission checks:
   - Verify permission checks work correctly
   - Verify type safety (if enums are used)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permissions use strings (not enums)
- ✅ **When fixed**: Permissions should use enums for type safety

---

## Test Case 18: Invitation Acceptance Flow

**Objective**: Verify invited user can accept invitation and join workspace.

**Preconditions**:
- User A (Account Holder/Admin) has invited User B
- User B has received invitation (email or in-app notification)
- User B is logged in or can log in

**Steps**:
1. As User B, check for workspace invitation:
   - Check email for invitation link
   - OR check in-app notifications
   - OR check invitation widget/notification
2. Accept the invitation:
   - Tap on invitation notification
   - OR use invitation link/button
3. Verify invitation acceptance flow:
   - User B is added to workspace
   - User B is assigned the invited role
   - User B gains access to workspace
4. As User A, verify User B appears in members list
5. Verify User B's role matches the invitation

**Expected Results**:
- ✅ Invitation can be accepted
- ✅ User is added to workspace upon acceptance
- ✅ User gets correct role
- ✅ User gains workspace access

**Note**: Invitation acceptance flow may need to be tested separately.

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Workspace members list is displayed
- [ ] Users can be invited to workspace
- [ ] Invitations can be revoked
- [ ] User roles can be updated
- [ ] Users can be removed from workspace
- [ ] Permissions can be updated (if implemented)
- [ ] Search/filter works correctly
- [ ] Pending invitations are displayed
- [ ] Permission checks work correctly
- [ ] Account Holder protection works
- [ ] Self-removal protection works
- [ ] WorkspaceManagementPage._manageMembers works (when implemented)
- [ ] Permissions use enums (when fixed)

---

## Known Issues (Based on Audit Report)

1. **WorkspaceManagementPage._manageMembers TODO**: 
   - Method is not implemented
   - Shows info message "Manage members functionality coming soon"
   - **Status**: ⚠️ Not Implemented

2. **Permissions Use Strings**:
   - Permission checks rely on strings (e.g., 'manage_users', 'invite_users')
   - Should use enums for type safety
   - **Status**: ⚠️ Needs Refactoring

3. **UserManagementPage Exists**:
   - Separate UserManagementPage has member management UI
   - But WorkspaceManagementPage doesn't navigate to it
   - **Status**: ⚠️ Inconsistent

---

## Notes for Testers

1. **Two Management Pages**: 
   - UserManagementPage: Has working member management UI
   - WorkspaceManagementPage: _manageMembers is TODO

2. **Permission Testing**: To test permission denied scenarios, you may need to:
   - Use test account with Member role
   - OR temporarily modify permissions in Firebase

3. **Invitation Flow**: Invitation acceptance may need separate testing if it's a different flow.

4. **Permission Strings**: Current implementation uses string-based permissions. Document this when testing.

5. **Account Holder**: Account Holder has special protections - cannot be removed or have role changed.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- User role and permissions
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
