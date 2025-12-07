# Transfer Account Holder Ownership - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Transfer Account Holder Ownership** feature. This feature is currently **MISSING** - not implemented; no use case/controller/UI flow exists.

## Prerequisites
- User must be logged in as Account Holder
- Workspace must have at least one Admin or Member (to transfer ownership to)
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: Transfer Ownership - Happy Path

**Objective**: Verify Account Holder can successfully transfer ownership to another user.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has at least one Admin or Member
- Transfer ownership feature is implemented

**Steps**:
1. Navigate to Workspace Management or Role Management screen
2. Locate "Transfer Ownership" or "Transfer Account Holder" option
3. Verify one of the following:
   - **If implemented**: Transfer ownership option is available
   - **If NOT implemented**: Option is not available (this is expected - current status)
4. If implemented:
   - Tap "Transfer Ownership" option
   - Verify transfer ownership page/dialog appears
   - Verify warning message is displayed about transferring ownership
   - Verify list of eligible users is displayed (Admin and Member roles)
   - Select a user to transfer ownership to (e.g., an Admin)
   - Verify user details are shown (name, email, current role)
   - Enter confirmation text (e.g., "TRANSFER" or user's email address)
   - Tap "Transfer Ownership" button
   - Verify final confirmation dialog appears with:
     - Warning about losing Account Holder privileges
     - Confirmation that selected user will become Account Holder
     - "Cancel" and "Confirm" buttons
   - Tap "Confirm" button
   - Verify loading indicator appears
   - Wait for transfer to complete
   - Verify success message appears: "Ownership transferred successfully"
   - Verify current user's role changes from Account Holder to Admin (or previous role)
   - Verify selected user's role changes to Account Holder
   - Verify workspace still functions correctly
   - Verify new Account Holder has all Account Holder permissions

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Transfer ownership flow is NOT available (missing)
- ✅ **When implemented**: Account Holder can transfer ownership
- ✅ Transfer requires confirmation
- ✅ Roles are updated correctly
- ✅ Both users' roles are updated atomically
- ✅ New Account Holder has correct permissions

---

## Test Case 2: Transfer Ownership - Permission Check

**Objective**: Verify only Account Holder can transfer ownership.

**Preconditions**:
- User is logged in as Admin (NOT Account Holder)
- Workspace has Account Holder and other members
- Transfer ownership feature is implemented

**Steps**:
1. Navigate to Workspace Management or Role Management screen
2. Verify one of the following:
   - "Transfer Ownership" option is not visible
   - OR "Transfer Ownership" option is disabled
   - OR Error message appears when trying to access
3. Try to access transfer ownership (if option exists):
   - Tap "Transfer Ownership" option (if visible)
   - Verify error message appears: "Only Account Holder can transfer ownership" or "Permission denied"
4. As Member:
   - Verify "Transfer Ownership" option is not available
   - Try to access transfer ownership - verify error
5. As Account Holder:
   - Verify "Transfer Ownership" option is available
   - Verify transfer ownership works correctly

**Expected Results**:
- ✅ Only Account Holder can transfer ownership
- ✅ Admin cannot transfer ownership
- ✅ Member cannot transfer ownership
- ✅ Permission checks are enforced
- ✅ Appropriate error messages are shown

---

## Test Case 3: Transfer Ownership - Confirmation Required

**Objective**: Verify transfer ownership requires proper confirmation.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has eligible users (Admin or Member)
- Transfer ownership feature is implemented

**Steps**:
1. Navigate to Transfer Ownership screen
2. Select a user to transfer ownership to
3. Try to transfer without entering confirmation text:
   - Leave confirmation field empty
   - Tap "Transfer Ownership" button
   - Verify error message: "Please enter confirmation text"
   - Verify transfer is blocked
4. Enter incorrect confirmation text:
   - Enter wrong text (e.g., "CANCEL" instead of "TRANSFER")
   - Tap "Transfer Ownership" button
   - Verify error message: "Confirmation text does not match"
   - Verify transfer is blocked
5. Enter correct confirmation text:
   - Enter correct text (e.g., "TRANSFER" or user's email)
   - Tap "Transfer Ownership" button
   - Verify final confirmation dialog appears
6. Cancel final confirmation:
   - Tap "Cancel" button in final confirmation dialog
   - Verify dialog closes
   - Verify ownership is NOT transferred
   - Verify user remains Account Holder
7. Confirm transfer:
   - Tap "Confirm" button in final confirmation dialog
   - Verify transfer proceeds

**Expected Results**:
- ✅ Confirmation text is required
- ✅ Incorrect confirmation text is rejected
- ✅ Final confirmation dialog is shown
- ✅ Transfer can be cancelled
- ✅ Transfer only proceeds with proper confirmation

---

## Test Case 4: Transfer Ownership - Eligible Users Only

**Objective**: Verify only eligible users (Admin or Member) can receive ownership.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has members with different roles
- Transfer ownership feature is implemented

**Steps**:
1. Navigate to Transfer Ownership screen
2. Verify eligible users list:
   - Admin users are shown in the list
   - Member users are shown in the list
   - Account Holder (current user) is NOT shown in the list
   - Other Account Holders (if any) are NOT shown in the list
3. Verify user information is displayed:
   - User name
   - User email
   - Current role
   - Member since date (if available)
4. Try to select Account Holder (if somehow available):
   - Verify Account Holder cannot be selected
   - OR verify error message if selected

**Expected Results**:
- ✅ Only Admin and Member users are eligible
- ✅ Account Holder cannot transfer to another Account Holder
- ✅ Eligible users list is accurate
- ✅ User information is displayed correctly

---

## Test Case 5: Transfer Ownership - Atomic Update

**Objective**: Verify both users' roles are updated atomically (both succeed or both fail).

**Preconditions**:
- User is logged in as Account Holder
- Workspace has eligible users
- Transfer ownership feature is implemented

**Steps**:
1. Navigate to Transfer Ownership screen
2. Select a user to transfer ownership to
3. Complete transfer process:
   - Enter confirmation text
   - Confirm transfer
4. Verify atomic update:
   - Check current user's role in Firebase - should be Admin (or previous role)
   - Check selected user's role in Firebase - should be Account Holder
   - Verify both updates happened together
   - Verify no partial updates (one updated, one not)
5. Simulate network error during transfer (if possible):
   - Disconnect network mid-transfer
   - Verify transfer fails
   - Verify both users' roles remain unchanged
   - Verify no partial updates occurred

**Expected Results**:
- ✅ Both users' roles are updated atomically
- ✅ No partial updates occur
- ✅ If transfer fails, both users' roles remain unchanged
- ✅ Transaction safety is maintained

---

## Test Case 6: Transfer Ownership - Previous Role Preservation

**Objective**: Verify previous Account Holder's role is set correctly after transfer.

**Preconditions**:
- User is logged in as Account Holder
- Account Holder was previously Admin before becoming Account Holder
- Workspace has eligible users
- Transfer ownership feature is implemented

**Steps**:
1. Note current Account Holder's previous role (if tracked)
2. Navigate to Transfer Ownership screen
3. Transfer ownership to another user
4. Verify previous Account Holder's role:
   - If previous role was Admin: Should become Admin
   - If previous role was Member: Should become Member
   - If no previous role tracked: Should become Admin (default)
5. Verify previous Account Holder retains appropriate permissions for their new role

**Expected Results**:
- ✅ Previous Account Holder's role is set correctly
- ✅ Role is based on previous role (if tracked) or defaults to Admin
- ✅ Permissions match the new role

**Note**: This test case assumes previous role tracking is implemented. If not, default to Admin.

---

## Test Case 7: Transfer Ownership - Permissions Update

**Objective**: Verify permissions are updated correctly for both users after transfer.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has eligible users
- Transfer ownership feature is implemented

**Steps**:
1. As Account Holder, note current permissions (should have all permissions)
2. Navigate to Transfer Ownership screen
3. Select a user (e.g., Admin) to transfer ownership to
4. Note selected user's current permissions
5. Complete transfer process
6. Verify new Account Holder's permissions:
   - Check permissions in Firebase
   - Verify all Account Holder permissions are granted
   - Verify permissions match `DefaultPermissionSets.accountHolderPermissions`
7. Verify previous Account Holder's permissions:
   - Check permissions in Firebase
   - Verify permissions match their new role (Admin or Member)
   - Verify Account Holder-specific permissions are removed
8. Test permissions in app:
   - As new Account Holder: Verify can manage workspace, manage users, etc.
   - As previous Account Holder: Verify permissions match new role

**Expected Results**:
- ✅ New Account Holder has all Account Holder permissions
- ✅ Previous Account Holder's permissions match new role
- ✅ Permissions are updated correctly in Firebase
- ✅ Permissions work correctly in app

---

## Test Case 8: Transfer Ownership - Audit Logging

**Objective**: Verify ownership transfer is logged in audit log (if audit logging exists).

**Preconditions**:
- User is logged in as Account Holder
- Workspace has eligible users
- Transfer ownership and audit logging are implemented

**Steps**:
1. Navigate to Transfer Ownership screen
2. Transfer ownership to another user
3. Navigate to Audit Log screen (if implemented)
4. Verify audit log entry is created:
   - Action: "ownership_transferred" or "transfer_ownership"
   - User: Previous Account Holder ID/name (who transferred)
   - Target User: New Account Holder ID/name (who received)
   - Workspace: Workspace ID/name
   - Timestamp: Transfer date/time
   - Details: Transfer information
5. Verify audit log entry is stored in Firebase
6. Verify audit log entry cannot be deleted or modified

**Expected Results**:
- ✅ Ownership transfer is logged in audit log
- ✅ Audit log entry contains correct information
- ✅ Audit log entry is stored in Firebase
- ✅ Audit log entry is immutable

**Note**: This test case applies when audit logging is implemented.

---

## Test Case 9: Transfer Ownership - Workspace Access After Transfer

**Objective**: Verify both users can still access workspace after transfer.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has eligible users
- Transfer ownership feature is implemented

**Steps**:
1. As Account Holder, note current workspace access
2. Navigate to Transfer Ownership screen
3. Transfer ownership to another user (e.g., Admin)
4. As previous Account Holder:
   - Verify can still access workspace
   - Verify can perform actions based on new role (Admin or Member)
   - Verify cannot perform Account Holder-only actions (if any)
5. As new Account Holder:
   - Verify can access workspace
   - Verify can perform all Account Holder actions
   - Verify can manage workspace, users, permissions, etc.
6. Verify workspace data is intact:
   - Projects are still accessible
   - Tasks are still accessible
   - Members are still accessible
   - Settings are still accessible

**Expected Results**:
- ✅ Both users can still access workspace
- ✅ Previous Account Holder has appropriate access for new role
- ✅ New Account Holder has full Account Holder access
- ✅ Workspace data is intact

---

## Test Case 10: Transfer Ownership - Multiple Transfers

**Objective**: Verify ownership can be transferred multiple times.

**Preconditions**:
- User A is logged in as Account Holder
- Workspace has multiple eligible users (User B, User C)
- Transfer ownership feature is implemented

**Steps**:
1. As User A (Account Holder):
   - Transfer ownership to User B
   - Verify User B becomes Account Holder
   - Verify User A becomes Admin
2. As User B (new Account Holder):
   - Verify can access transfer ownership
   - Transfer ownership to User C
   - Verify User C becomes Account Holder
   - Verify User B becomes Admin
3. Verify all transfers are logged (if audit logging exists)
4. Verify workspace functions correctly after multiple transfers

**Expected Results**:
- ✅ Ownership can be transferred multiple times
- ✅ Each transfer works correctly
- ✅ All transfers are logged (if audit logging exists)
- ✅ Workspace functions correctly after multiple transfers

---

## Test Case 11: Transfer Ownership - Error Handling

**Objective**: Verify error handling works correctly during transfer.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has eligible users
- Transfer ownership feature is implemented

**Steps**:
1. Navigate to Transfer Ownership screen
2. Select a user to transfer ownership to
3. Simulate network error:
   - Disconnect network
   - Complete transfer process
   - Verify error message appears: "Network error" or "Failed to transfer ownership"
   - Verify transfer does not complete
   - Verify both users' roles remain unchanged
4. Simulate user not found error:
   - Select a user that no longer exists (if possible)
   - Complete transfer process
   - Verify error message: "User not found"
   - Verify transfer does not complete
5. Simulate workspace not found error:
   - Try to transfer when workspace is deleted (if possible)
   - Verify error handling
6. Verify error messages are clear and actionable

**Expected Results**:
- ✅ Network errors are handled gracefully
- ✅ User not found errors are handled
- ✅ Workspace errors are handled
- ✅ Error messages are clear
- ✅ No partial updates occur on errors

---

## Test Case 12: Transfer Ownership - UI/UX

**Objective**: Verify transfer ownership UI/UX is clear and user-friendly.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has eligible users
- Transfer ownership feature is implemented

**Steps**:
1. Navigate to Transfer Ownership screen
2. Verify UI elements:
   - Warning message is clear and prominent
   - Eligible users list is easy to read
   - User information is displayed clearly
   - Confirmation input field is visible
   - Transfer button is clearly labeled
   - Cancel button is available
3. Verify user experience:
   - Instructions are clear
   - Warning about consequences is visible
   - Confirmation requirements are explained
   - Progress indicators are shown during transfer
   - Success/error messages are clear
4. Verify accessibility:
   - Text is readable
   - Buttons are accessible
   - Error messages are accessible
5. Verify UI follows project rules:
   - Uses TD widgets
   - Uses AppStrings
   - Follows design guidelines

**Expected Results**:
- ✅ UI is clear and user-friendly
- ✅ Warning messages are prominent
- ✅ Instructions are clear
- ✅ UI follows project rules
- ✅ Accessibility is maintained

---

## Test Case 13: Transfer Ownership - Workspace Settings Access

**Objective**: Verify workspace settings access after transfer.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has eligible users
- Transfer ownership feature is implemented

**Steps**:
1. As Account Holder, access workspace settings
2. Note current settings access
3. Transfer ownership to another user
4. As previous Account Holder:
   - Try to access workspace settings
   - Verify access based on new role:
     - If Admin: Can access most settings (if Admin has permission)
     - If Member: Limited settings access
5. As new Account Holder:
   - Access workspace settings
   - Verify full settings access
   - Verify can modify all settings
6. Verify settings are preserved after transfer

**Expected Results**:
- ✅ Previous Account Holder has appropriate settings access
- ✅ New Account Holder has full settings access
- ✅ Settings are preserved after transfer

---

## Test Case 14: Transfer Ownership - Member Management Access

**Objective**: Verify member management access after transfer.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has eligible users and other members
- Transfer ownership feature is implemented

**Steps**:
1. As Account Holder, access member management
2. Note current member management capabilities
3. Transfer ownership to another user
4. As previous Account Holder:
   - Try to access member management
   - Verify access based on new role:
     - If Admin: Can manage members (if Admin has permission)
     - If Member: Cannot manage members
5. As new Account Holder:
   - Access member management
   - Verify full member management access
   - Verify can add, remove, and manage members
6. Verify member list is intact after transfer

**Expected Results**:
- ✅ Previous Account Holder has appropriate member management access
- ✅ New Account Holder has full member management access
- ✅ Member list is intact after transfer

---

## Test Case 15: Transfer Ownership - Rapid Transfer Prevention

**Objective**: Verify rapid/accidental transfers are prevented.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has eligible users
- Transfer ownership feature is implemented

**Steps**:
1. Navigate to Transfer Ownership screen
2. Select a user to transfer ownership to
3. Enter confirmation text
4. Rapidly tap "Transfer Ownership" button multiple times
5. Verify one of the following:
   - Only one transfer is processed
   - OR button is disabled after first tap
   - OR duplicate transfers are prevented
6. Verify no duplicate role updates occur
7. Verify transfer completes only once

**Expected Results**:
- ✅ Rapid transfers are prevented
- ✅ Only one transfer is processed
- ✅ No duplicate role updates occur
- ✅ Button is disabled during transfer

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Account Holder can transfer ownership
- [ ] Only Account Holder can transfer ownership
- [ ] Transfer requires confirmation
- [ ] Only eligible users (Admin/Member) can receive ownership
- [ ] Both users' roles are updated atomically
- [ ] Previous Account Holder's role is set correctly
- [ ] Permissions are updated correctly
- [ ] Ownership transfer is logged (if audit logging exists)
- [ ] Both users can still access workspace
- [ ] Ownership can be transferred multiple times
- [ ] Error handling works correctly
- [ ] UI/UX is clear and user-friendly
- [ ] Workspace settings access is correct after transfer
- [ ] Member management access is correct after transfer
- [ ] Rapid transfers are prevented

---

## Known Issues (Based on Audit Report)

1. **Transfer Ownership Flow Missing**:
   - No use case for transferring ownership
   - No controller method for transferring ownership
   - No UI flow for transferring ownership
   - **Status**: ⛔ Missing

2. **No Ownership Transfer Validation**:
   - No validation that current user is Account Holder
   - No validation that target user is eligible
   - **Status**: ⛔ Missing

3. **No Ownership Transfer Logging**:
   - No audit logging for ownership transfers
   - No tracking of ownership history
   - **Status**: ⛔ Missing (depends on audit logging implementation)

---

## Notes for Testers

1. **Current Status**: Transfer ownership is completely missing. All test cases assume the feature will be implemented.

2. **Account Holder Only**: Only the current Account Holder can transfer ownership. This is a critical security feature.

3. **Eligible Users**: Only Admin and Member users can receive ownership. Account Holders cannot transfer to other Account Holders.

4. **Atomic Updates**: Both users' roles must be updated together. If one fails, both should remain unchanged.

5. **Confirmation Required**: Transfer should require explicit confirmation to prevent accidental transfers.

6. **Audit Logging**: When audit logging is implemented, ownership transfers should be logged.

7. **Previous Role**: The previous Account Holder's role after transfer should be based on their role before becoming Account Holder, or default to Admin.

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
- Firebase data (if accessible) showing role changes
