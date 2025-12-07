# Transfer Ownership When Account Holder Leaves - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Transfer Ownership When Account Holder Leaves** feature. This feature is currently **MISSING** - not implemented; no use case/controller/UI flow exists. This is specifically about the scenario where Account Holder wants to leave the workspace and must transfer ownership before leaving.

## Prerequisites
- User must be logged in as Account Holder
- Workspace must have at least one Admin or Member (to transfer ownership to)
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: Leave Workspace - Account Holder Must Transfer Ownership

**Objective**: Verify Account Holder cannot leave workspace without transferring ownership first.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has at least one Admin or Member
- Leave workspace feature is implemented

**Steps**:
1. Navigate to Workspace Settings or User Management screen
2. Locate "Leave Workspace" or "Remove Myself" option
3. Tap "Leave Workspace" option
4. Verify one of the following:
   - **If NOT implemented**: Leave workspace option may not exist or may not check for Account Holder (this is expected - feature missing)
   - **If implemented**: Warning/blocking message appears
5. If implemented:
   - Verify warning message appears:
     - "You are the Account Holder. You must transfer ownership before leaving."
     - "Please transfer ownership to another member first."
     - Link/button to "Transfer Ownership"
   - Verify "Leave Workspace" action is blocked
   - Verify cannot proceed with leaving without transferring ownership
6. Tap "Transfer Ownership" link/button
7. Verify transfer ownership flow is initiated
8. Complete ownership transfer
9. After transfer, verify Account Holder can now leave workspace

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Account Holder leave protection is NOT available (missing)
- ✅ **When implemented**: Account Holder cannot leave without transferring ownership
- ✅ Warning message is clear
- ✅ Transfer ownership flow is accessible from leave warning

---

## Test Case 2: Transfer Ownership Before Leaving - Happy Path

**Objective**: Verify Account Holder can transfer ownership and then leave workspace successfully.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has at least one Admin or Member
- Transfer ownership and leave workspace features are implemented

**Steps**:
1. Navigate to Workspace Settings or User Management screen
2. Tap "Leave Workspace" option
3. Verify warning appears about needing to transfer ownership
4. Tap "Transfer Ownership" link/button
5. Verify transfer ownership page/dialog appears
6. Select a user to transfer ownership to (e.g., an Admin)
7. Enter confirmation text
8. Complete ownership transfer:
   - Tap "Transfer Ownership" button
   - Confirm in final confirmation dialog
   - Wait for transfer to complete
9. Verify ownership transfer is successful:
   - Current user's role changes from Account Holder to Admin (or previous role)
   - Selected user's role changes to Account Holder
   - Success message appears
10. After transfer, navigate back to "Leave Workspace" option
11. Tap "Leave Workspace" option
12. Verify leave workspace flow now works:
   - Confirmation dialog appears (if required)
   - Confirm leaving
   - Verify user is removed from workspace
   - Verify user loses access to workspace
   - Verify workspace still functions correctly with new Account Holder

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Transfer ownership before leaving flow is NOT available (missing)
- ✅ **When implemented**: Account Holder can transfer ownership and then leave
- ✅ Ownership transfer works correctly
- ✅ Leave workspace works after transfer
- ✅ Workspace continues to function with new Account Holder

---

## Test Case 3: Leave Workspace - No Eligible Users to Transfer To

**Objective**: Verify Account Holder cannot leave if there are no eligible users to transfer ownership to.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has NO Admin or Member users (only Account Holder)
- Leave workspace feature is implemented

**Steps**:
1. Navigate to Workspace Settings or User Management screen
2. Tap "Leave Workspace" option
3. Verify one of the following:
   - **If NOT implemented**: Leave workspace may proceed without check (this is expected - feature missing)
   - **If implemented**: Error/warning message appears
4. If implemented:
   - Verify error message appears:
     - "You are the Account Holder and the only member."
     - "You cannot leave the workspace. Please add at least one Admin or Member first."
     - OR "You must transfer ownership before leaving, but there are no eligible users."
   - Verify "Leave Workspace" action is blocked
   - Verify cannot proceed with leaving
5. Add an Admin or Member to workspace
6. Verify Account Holder can now transfer ownership and leave

**Expected Results**:
- ⚠️ **CURRENT STATUS**: No eligible users check is NOT available (missing)
- ✅ **When implemented**: Account Holder cannot leave if no eligible users exist
- ✅ Error message is clear
- ✅ Suggestion to add users is provided

---

## Test Case 4: Transfer Ownership Flow from Leave Warning

**Objective**: Verify transfer ownership flow initiated from leave warning works correctly.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has eligible users (Admin or Member)
- Transfer ownership and leave workspace features are implemented

**Steps**:
1. Navigate to Workspace Settings
2. Tap "Leave Workspace" option
3. Verify warning appears about needing to transfer ownership
4. Tap "Transfer Ownership" link/button from warning
5. Verify transfer ownership page/dialog appears:
   - Pre-filled context: "You are leaving the workspace"
   - Warning about transferring ownership before leaving
   - List of eligible users
6. Select a user to transfer ownership to
7. Enter confirmation text
8. Complete transfer:
   - Tap "Transfer Ownership" button
   - Confirm in final confirmation dialog
   - Wait for transfer to complete
9. Verify transfer is successful
10. Verify user is redirected back to leave workspace flow (if applicable)
11. Verify leave workspace option is now available

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Transfer ownership from leave warning is NOT available (missing)
- ✅ **When implemented**: Transfer ownership flow works from leave warning
- ✅ Context is clear (leaving workspace)
- ✅ Flow is smooth and intuitive

---

## Test Case 5: Cancel Leave Workspace After Transfer

**Objective**: Verify Account Holder can cancel leaving workspace after transferring ownership.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has eligible users
- Transfer ownership and leave workspace features are implemented

**Steps**:
1. Navigate to Workspace Settings
2. Tap "Leave Workspace" option
3. Transfer ownership to another user
4. Verify ownership transfer is successful
5. Navigate back to "Leave Workspace" option
6. Tap "Leave Workspace" option
7. Verify leave workspace confirmation dialog appears
8. Tap "Cancel" button
9. Verify user remains in workspace
10. Verify user's role is now Admin (or previous role, not Account Holder)
11. Verify workspace functions correctly
12. Verify new Account Holder still has Account Holder role

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Cancel leave after transfer may not be properly handled (missing)
- ✅ **When implemented**: Account Holder can cancel leaving after transfer
- ✅ Ownership transfer is not reversed (new Account Holder remains)
- ✅ User can stay in workspace with new role

---

## Test Case 6: Leave Workspace - Last Member Protection

**Objective**: Verify Account Holder cannot leave if they are the last member (even after transfer).

**Preconditions**:
- User is logged in as Account Holder
- Workspace has only Account Holder (no other members)
- Leave workspace feature is implemented

**Steps**:
1. Navigate to Workspace Settings
2. Tap "Leave Workspace" option
3. Verify one of the following:
   - **If NOT implemented**: Leave workspace may proceed (this is expected - feature missing)
   - **If implemented**: Error message appears
4. If implemented:
   - Verify error message appears:
     - "You are the only member of this workspace."
     - "You cannot leave the workspace. Please add at least one member first."
     - OR "Workspace must have at least one member."
   - Verify "Leave Workspace" action is blocked
5. Add a member to workspace
6. Transfer ownership to that member
7. Verify Account Holder can now leave workspace

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Last member protection is NOT available (missing)
- ✅ **When implemented**: Account Holder cannot leave if they are the last member
- ✅ Error message is clear
- ✅ Suggestion to add members is provided

---

## Test Case 7: Transfer Ownership and Leave - Atomic Operation

**Objective**: Verify ownership transfer and leave workspace can be done atomically (if supported).

**Preconditions**:
- User is logged in as Account Holder
- Workspace has eligible users
- Transfer ownership and leave workspace features are implemented
- Atomic operation feature is implemented (optional)

**Steps**:
1. Navigate to Workspace Settings
2. Tap "Leave Workspace" option
3. Verify warning appears about needing to transfer ownership
4. Verify one of the following:
   - **If NOT implemented**: Must transfer ownership separately, then leave (this is expected - current flow)
   - **If implemented**: Option to "Transfer Ownership and Leave" exists
5. If implemented:
   - Tap "Transfer Ownership and Leave" option
   - Select user to transfer ownership to
   - Enter confirmation text
   - Confirm both actions
   - Verify both operations complete:
     - Ownership is transferred
     - User is removed from workspace
   - Verify atomic operation (both succeed or both fail)
6. If not implemented:
   - Verify must complete transfer first, then leave separately

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Atomic transfer and leave is NOT available (missing)
- ✅ **When implemented**: Transfer and leave can be done atomically (if supported)
- ✅ Both operations succeed or both fail together

---

## Test Case 8: Leave Workspace - Workspace Deletion Alternative

**Objective**: Verify Account Holder can delete workspace instead of transferring ownership (if supported).

**Preconditions**:
- User is logged in as Account Holder
- Workspace deletion feature is implemented
- Transfer ownership feature is implemented

**Steps**:
1. Navigate to Workspace Settings
2. Tap "Leave Workspace" option
3. Verify warning appears about needing to transfer ownership
4. Verify one of the following:
   - **If NOT implemented**: Only transfer ownership option is shown (this is expected - current flow)
   - **If implemented**: Alternative option to "Delete Workspace" is shown
5. If implemented:
   - Verify "Delete Workspace" option is available
   - Verify warning about workspace deletion
   - Tap "Delete Workspace" option
   - Verify workspace deletion flow is initiated
   - Complete workspace deletion (if desired)
6. If not implemented:
   - Verify only transfer ownership option is available

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Workspace deletion alternative is NOT available (missing)
- ✅ **When implemented**: Account Holder can choose to delete workspace instead
- ✅ Warning about deletion is clear

---

## Test Case 9: Transfer Ownership - Leave Workspace Notification

**Objective**: Verify new Account Holder is notified when previous Account Holder leaves after transfer (if implemented).

**Preconditions**:
- User A is logged in as Account Holder
- User B exists (Admin or Member)
- Transfer ownership and leave workspace features are implemented
- Notification feature is implemented

**Steps**:
1. User A transfers ownership to User B
2. Verify ownership transfer is successful
3. User A leaves workspace
4. Verify one of the following:
   - **If NOT implemented**: No notification is sent (this is expected - feature missing)
   - **If implemented**: Notification is sent to User B
5. If implemented:
   - Verify User B (new Account Holder) receives notification:
     - Email notification
     - Push notification
     - In-app notification
   - Verify notification contains:
     - "You are now the Account Holder"
     - Previous Account Holder's name
     - Workspace name
     - Effective date/time
   - Verify notification is sent immediately

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Leave workspace notification is NOT available (missing)
- ✅ **When implemented**: New Account Holder is notified when previous Account Holder leaves
- ✅ Notification contains relevant information

---

## Test Case 10: Leave Workspace - Audit Logging

**Objective**: Verify Account Holder leaving workspace is logged in audit log (if audit logging exists).

**Preconditions**:
- User is logged in as Account Holder
- Workspace has eligible users
- Transfer ownership, leave workspace, and audit logging features are implemented

**Steps**:
1. Navigate to Workspace Settings
2. Transfer ownership to another user
3. Leave workspace
4. Navigate to Audit Log screen (if implemented)
5. Verify one of the following:
   - **If NOT implemented**: Audit log is not available (this is expected - feature missing)
   - **If implemented**: Audit log entries are created
6. If implemented:
   - Verify audit log entries:
     - Entry 1: Ownership transfer
       - Action: "ownership_transferred"
       - From: Previous Account Holder
       - To: New Account Holder
     - Entry 2: User left workspace
       - Action: "user_left_workspace" or "member_removed"
       - User: Previous Account Holder
       - Reason: "Account Holder left after transferring ownership"
   - Verify audit log entries are stored in Firebase
   - Verify entries are not editable

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Audit logging for leave workspace is NOT available (missing)
- ✅ **When implemented**: Account Holder leaving is logged
- ✅ Both transfer and leave are logged
- ✅ Audit log entries contain correct information

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Account Holder cannot leave without transferring ownership (if implemented)
- [ ] Account Holder can transfer ownership and then leave (if implemented)
- [ ] Account Holder cannot leave if no eligible users exist (if implemented)
- [ ] Transfer ownership flow from leave warning works (if implemented)
- [ ] Account Holder can cancel leaving after transfer (if implemented)
- [ ] Account Holder cannot leave if they are the last member (if implemented)
- [ ] Atomic transfer and leave works (if implemented)
- [ ] Workspace deletion alternative is available (if implemented)
- [ ] New Account Holder is notified when previous Account Holder leaves (if implemented)
- [ ] Account Holder leaving is logged in audit log (if implemented)

---

## Known Issues (Based on Audit Report)

1. **Transfer Ownership When Leaving Missing**:
   - No flow for Account Holder to transfer ownership before leaving
   - No check to prevent Account Holder from leaving without transferring ownership
   - **Status**: ⛔ Missing

2. **Leave Workspace Protection Missing**:
   - Account Holder may be able to leave workspace without transferring ownership
   - No warning/blocking when Account Holder tries to leave
   - **Status**: ⛔ Missing

3. **No Eligible Users Check Missing**:
   - No check for eligible users before allowing Account Holder to leave
   - **Status**: ⛔ Missing

4. **Related Transfer Ownership Feature**:
   - General transfer ownership feature exists in workspace checklists
   - But specific "transfer when leaving" flow is missing
   - **Status**: ⛔ Missing

---

## Notes for Testers

1. **Current Status**: Transfer ownership when Account Holder leaves is completely missing. Account Holder may be able to leave workspace without transferring ownership, which could cause workspace issues.

2. **Related Features**: General transfer ownership feature is documented in workspace checklists (`TRANSFER_OWNERSHIP_TEST_CASES.md`, `TRANSFER_OWNERSHIP_TASKS.md`), but the specific "transfer when leaving" flow is missing.

3. **Account Holder Protection**: Account Holder should not be able to leave workspace without transferring ownership first. This is critical for workspace continuity.

4. **Eligible Users**: Account Holder must transfer ownership to an Admin or Member. If no eligible users exist, Account Holder cannot leave.

5. **Last Member Protection**: Account Holder should not be able to leave if they are the last member of the workspace.

6. **Atomic Operations**: Ideally, transfer ownership and leave workspace could be done atomically, but this is optional. Current flow may require two separate steps.

7. **Workspace Deletion Alternative**: As an alternative to transferring ownership, Account Holder might be able to delete the workspace instead (if workspace deletion is implemented).

8. **Notifications**: When Account Holder leaves after transferring ownership, the new Account Holder should be notified.

9. **Audit Logging**: When audit logging is implemented, both ownership transfer and Account Holder leaving should be logged.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- User roles (Account Holder, Admin, Member)
- Workspace context
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase data (if accessible) showing workspace membership
- Whether transfer ownership works
- Whether leave workspace protection works
- Whether eligible users check works
