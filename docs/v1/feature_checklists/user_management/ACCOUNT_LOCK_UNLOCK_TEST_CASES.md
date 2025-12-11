# Account Lock/Unlock Management - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Account Lock/Unlock Management** feature. This feature is currently **PARTIAL** - `User.isActive` field exists, but no controller/service UI to toggle lock/unlock, and no enforcement paths observed (locked users can still log in).

## Prerequisites
- User must be logged in as Account Holder or Admin
- Device should have internet connection (for Firebase sync)
- Test users with different roles (Account Holder, Admin, Member)

---

## Test Case 1: Lock User Account - Happy Path

**Objective**: Verify user account can be locked successfully.

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists and is active
- Lock account feature is implemented

**Steps**:
1. Navigate to User Management or Member Management screen
2. Locate User B in the member list
3. Verify one of the following:
   - **If NOT implemented**: Lock option is not available (this is expected - feature missing)
   - **If implemented**: "Lock Account" or "Deactivate Account" option is available
4. If implemented:
   - Tap on User B's account
   - Locate "Lock Account" or "Deactivate Account" option
   - Tap the option
   - Verify confirmation dialog appears:
     - Warning message about locking account
     - Information about what happens when locked
     - "Cancel" and "Lock" buttons
   - Read the warning message
   - Tap "Lock" button
   - Verify loading indicator appears
   - Wait for lock to complete
   - Verify success message appears: "Account locked successfully" or similar
   - Verify User B's status changes to "Locked" or "Inactive"
   - Verify `isActive` field is set to `false` in Firebase
   - Verify account status is displayed correctly in UI

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Lock account flow is NOT available (missing)
- ✅ **When implemented**: Account can be locked
- ✅ Lock requires confirmation
- ✅ Account status is updated in Firebase
- ✅ Status is displayed correctly in UI

---

## Test Case 2: Unlock User Account - Happy Path

**Objective**: Verify locked user account can be unlocked successfully.

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists and is locked (isActive = false)
- Unlock account feature is implemented

**Steps**:
1. Navigate to User Management or Member Management screen
2. Locate User B in the member list
3. Verify User B's status shows "Locked" or "Inactive"
4. Verify one of the following:
   - **If NOT implemented**: Unlock option is not available (this is expected - feature missing)
   - **If implemented**: "Unlock Account" or "Activate Account" option is available
5. If implemented:
   - Tap on User B's account
   - Locate "Unlock Account" or "Activate Account" option
   - Tap the option
   - Verify confirmation dialog appears (optional):
     - Confirmation message
     - "Cancel" and "Unlock" buttons
   - Tap "Unlock" button
   - Verify loading indicator appears
   - Wait for unlock to complete
   - Verify success message appears: "Account unlocked successfully" or similar
   - Verify User B's status changes to "Active"
   - Verify `isActive` field is set to `true` in Firebase
   - Verify account status is displayed correctly in UI

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Unlock account flow is NOT available (missing)
- ✅ **When implemented**: Account can be unlocked
- ✅ Account status is updated in Firebase
- ✅ Status is displayed correctly in UI

---

## Test Case 3: Lock Account - Permission Check

**Objective**: Verify only Account Holder/Admin can lock accounts.

**Preconditions**:
- User A is logged in as Member (NOT Account Holder/Admin)
- User B exists and is active
- Lock account feature is implemented

**Steps**:
1. As User A (Member), navigate to User Management screen
2. Locate User B in the member list
3. Verify one of the following:
   - "Lock Account" option is not visible
   - OR "Lock Account" option is disabled
   - OR Error message appears when trying to access
4. Try to lock User B's account (if option exists):
   - Tap "Lock Account" option (if visible)
   - Verify error message appears: "Only Account Holder/Admin can lock accounts" or "Permission denied"
5. As Admin:
   - Verify "Lock Account" option is available
   - Verify can lock accounts
6. As Account Holder:
   - Verify "Lock Account" option is available
   - Verify can lock accounts

**Expected Results**:
- ✅ Only Account Holder/Admin can lock accounts
- ✅ Member cannot lock accounts
- ✅ Permission checks are enforced
- ✅ Appropriate error messages are shown

---

## Test Case 4: Lock Account - Self-Lock Prevention

**Objective**: Verify user cannot lock their own account.

**Preconditions**:
- User A is logged in as Account Holder or Admin
- Lock account feature is implemented

**Steps**:
1. Navigate to User Management screen
2. Locate User A's own account in the member list
3. Verify one of the following:
   - "Lock Account" option is not visible for own account
   - OR "Lock Account" option is disabled for own account
   - OR Error message appears when trying to lock own account
4. Try to lock own account (if option exists):
   - Tap "Lock Account" option (if visible)
   - Verify error message appears: "You cannot lock your own account" or similar
5. Verify own account cannot be locked through any means

**Expected Results**:
- ✅ User cannot lock their own account
- ✅ Self-lock is prevented
- ✅ Error message is clear

---

## Test Case 5: Lock Account - Account Holder Protection

**Objective**: Verify Account Holder account cannot be locked.

**Preconditions**:
- User A is logged in as Admin
- User B is Account Holder
- Lock account feature is implemented

**Steps**:
1. Navigate to User Management screen
2. Locate Account Holder (User B) in the member list
3. Verify one of the following:
   - "Lock Account" option is not visible for Account Holder
   - OR "Lock Account" option is disabled for Account Holder
   - OR Error message appears when trying to lock Account Holder
4. Try to lock Account Holder's account (if option exists):
   - Tap "Lock Account" option (if visible)
   - Verify error message appears: "Account Holder account cannot be locked" or "Cannot lock Account Holder" or similar
5. Verify Account Holder account cannot be locked by anyone (including other Account Holders)

**Expected Results**:
- ✅ Account Holder account cannot be locked
- ✅ Account Holder protection is enforced
- ✅ Error message is clear

---

## Test Case 6: Lock Account - Enforcement on Login

**Objective**: Verify locked users cannot log in.

**Preconditions**:
- User A is locked (isActive = false)
- Login enforcement feature is implemented

**Steps**:
1. As User A, attempt to log in
2. Enter valid credentials
3. Tap "Login" button
4. Verify one of the following:
   - **If NOT implemented**: User A can log in (this is expected - enforcement missing)
   - **If implemented**: Login is blocked
5. If implemented:
   - Verify error message appears: "Your account has been locked. Please contact your administrator." or similar
   - Verify user is not logged in
   - Verify user is redirected to login screen
   - Verify no user data is loaded
   - Check Firebase:
     - Verify `isActive` is `false` for User A
6. Unlock User A's account
7. Attempt to log in again
8. Verify login succeeds

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Login enforcement is NOT available (missing - locked users can still log in)
- ✅ **When implemented**: Locked users cannot log in
- ✅ Error message is clear
- ✅ User can log in after unlock

---

## Test Case 7: Lock Account - Enforcement on Data Access

**Objective**: Verify locked users cannot access data even if already logged in.

**Preconditions**:
- User A is logged in
- User A's account is locked while logged in
- Data access enforcement feature is implemented

**Steps**:
1. As User A, log in successfully
2. Verify User A can access data (tasks, projects, etc.)
3. As Admin/Account Holder, lock User A's account
4. As User A, try to access data:
   - Navigate to different screens
   - Try to load tasks
   - Try to load projects
   - Try to perform actions
5. Verify one of the following:
   - **If NOT implemented**: User A can still access data (this is expected - enforcement missing)
   - **If implemented**: Data access is blocked
6. If implemented:
   - Verify error message appears: "Your account has been locked" or similar
   - Verify user is logged out automatically
   - Verify user is redirected to login screen
   - Verify no data is accessible
7. Unlock User A's account
8. Log in again
9. Verify data access is restored

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Data access enforcement is NOT available (missing)
- ✅ **When implemented**: Locked users cannot access data
- ✅ User is logged out when account is locked
- ✅ Data access is restored after unlock

---

## Test Case 8: Lock Account - Reason/Notes Field

**Objective**: Verify reason/notes can be provided when locking account (if implemented).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists and is active
- Reason/notes field feature is implemented

**Steps**:
1. Navigate to User Management screen
2. Locate User B
3. Tap "Lock Account" option
4. Verify one of the following:
   - **If NOT implemented**: No reason field (this is expected - feature missing)
   - **If implemented**: Reason/notes field is available
5. If implemented:
   - Verify reason field is displayed in lock dialog
   - Enter reason for locking (e.g., "Violation of company policy")
   - Tap "Lock" button
   - Verify reason is saved to Firebase
   - Check Firebase:
     - Verify `lockedReason` or `lockNotes` field exists
     - Verify reason is stored correctly
6. View locked account details
7. Verify reason is displayed

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Reason field is NOT available (missing)
- ✅ **When implemented**: Reason can be provided
- ✅ Reason is saved to Firebase
- ✅ Reason is displayed in account details

---

## Test Case 9: Lock Account - Lock Date Tracking

**Objective**: Verify lock date is tracked (if implemented).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists and is active
- Lock date tracking feature is implemented

**Steps**:
1. Navigate to User Management screen
2. Lock User B's account
3. Verify one of the following:
   - **If NOT implemented**: Lock date is not tracked (this is expected - feature missing)
   - **If implemented**: Lock date is recorded
4. If implemented:
   - Check Firebase:
     - Verify `lockedAt` field exists
     - Verify lock date/timestamp is recorded
   - View account details
   - Verify lock date is displayed
5. Unlock User B's account
6. Verify unlock date is tracked (if implemented):
   - Check Firebase:
     - Verify `unlockedAt` field exists
     - Verify unlock date/timestamp is recorded

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Lock date tracking is NOT available (missing)
- ✅ **When implemented**: Lock date is tracked
- ✅ Lock date is displayed
- ✅ Unlock date is tracked (if implemented)

---

## Test Case 10: Lock Account - Bulk Lock

**Objective**: Verify multiple accounts can be locked at once (if implemented).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- Multiple users exist and are active
- Bulk lock feature is implemented

**Steps**:
1. Navigate to User Management screen
2. Locate "Bulk Actions" or "Select Multiple" option
3. Select multiple users to lock
4. Tap "Lock Selected" button
5. Verify one of the following:
   - **If NOT implemented**: Bulk lock is not available (this is expected - feature missing)
   - **If implemented**: Bulk lock works
6. If implemented:
   - Verify confirmation dialog appears:
     - List of users to be locked
     - Warning message
     - "Cancel" and "Lock All" buttons
   - Confirm bulk lock
   - Verify all selected accounts are locked:
     - All accounts have `isActive = false`
     - All accounts show "Locked" status
   - Verify success message appears

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Bulk lock is NOT available (missing)
- ✅ **When implemented**: Multiple accounts can be locked
- ✅ All selected accounts are locked
- ✅ Confirmation is required

---

## Test Case 11: Account Status Display

**Objective**: Verify account status is displayed correctly in UI.

**Preconditions**:
- User A is logged in
- User B exists with different statuses (active, locked)
- Account status display feature is implemented

**Steps**:
1. Navigate to User Management or Profile screen
2. Verify account status is displayed:
   - Active accounts show "Active" or green indicator
   - Locked accounts show "Locked" or "Inactive" or red indicator
3. Verify status is visible in:
   - User list
   - User profile/details
   - Member cards
4. Test status changes:
   - Lock an account
   - Verify status updates immediately
   - Unlock an account
   - Verify status updates immediately

**Expected Results**:
- ✅ Account status is displayed
- ✅ Status is clear and visible
- ✅ Status updates in real-time

---

## Test Case 12: Filter Users by Status

**Objective**: Verify users can be filtered by account status (if implemented).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- Multiple users exist with different statuses
- Filter feature is implemented

**Steps**:
1. Navigate to User Management screen
2. Locate filter options
3. Verify one of the following:
   - **If NOT implemented**: Filter by status is not available (this is expected - feature missing)
   - **If implemented**: Filter by status is available
4. If implemented:
   - Select "Active" filter
   - Verify only active users are shown
   - Select "Locked" filter
   - Verify only locked users are shown
   - Select "All" filter
   - Verify all users are shown
5. Test filter combinations:
   - Filter by status + role
   - Filter by status + workspace
   - Verify filters work together

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Filter by status is NOT available (missing)
- ✅ **When implemented**: Users can be filtered by status
- ✅ Filter works correctly
- ✅ Multiple filters can be combined

---

## Test Case 13: Lock Account - Audit Logging

**Objective**: Verify account lock/unlock is logged in audit log (if audit logging exists).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists
- Audit logging feature is implemented

**Steps**:
1. Lock User B's account
2. Navigate to Audit Log screen (if implemented)
3. Verify one of the following:
   - **If NOT implemented**: Audit log is not available (this is expected - feature missing)
   - **If implemented**: Audit log entry is created
4. If implemented:
   - Verify audit log entry:
     - Action: "account_locked" or "lock"
     - User: User A (who locked)
     - Target: User B (who was locked)
     - Timestamp: Lock date/time
     - Reason: Lock reason (if provided)
5. Unlock User B's account
6. Verify audit log entry is created:
   - Action: "account_unlocked" or "unlock"
   - User: User A (who unlocked)
   - Target: User B (who was unlocked)
   - Timestamp: Unlock date/time
7. Verify audit log entries are stored in Firebase

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Audit logging is NOT available (missing)
- ✅ **When implemented**: Lock/unlock operations are logged
- ✅ Audit log entries contain correct information

**Note**: This test case applies when audit logging is implemented.

---

## Test Case 14: Lock Account - Notification to User

**Objective**: Verify locked user receives notification (if implemented).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists and is active
- Notification feature is implemented

**Steps**:
1. Lock User B's account
2. Verify one of the following:
   - **If NOT implemented**: No notification is sent (this is expected - feature missing)
   - **If implemented**: Notification is sent
3. If implemented:
   - Verify User B receives notification:
     - Email notification (if email notifications exist)
     - Push notification (if push notifications exist)
     - In-app notification (if in-app notifications exist)
   - Verify notification contains:
     - Account lock information
     - Reason (if provided)
     - Contact information for support
4. Unlock User B's account
5. Verify unlock notification is sent (if implemented)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Notifications are NOT available (missing)
- ✅ **When implemented**: Locked user receives notification
- ✅ Notification contains relevant information

**Note**: This is an optional feature for user communication.

---

## Test Case 15: Lock Account - Temporary Lock

**Objective**: Verify temporary lock with auto-unlock works (if implemented).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists and is active
- Temporary lock feature is implemented

**Steps**:
1. Navigate to User Management screen
2. Locate User B
3. Tap "Lock Account" option
4. Verify one of the following:
   - **If NOT implemented**: No temporary lock option (this is expected - feature missing)
   - **If implemented**: "Temporary Lock" option is available
5. If implemented:
   - Select "Temporary Lock"
   - Set lock duration (e.g., 24 hours, 7 days)
   - Confirm lock
   - Verify account is locked
   - Wait for lock duration to expire
   - Verify account is automatically unlocked
   - OR verify unlock reminder is sent before expiration
6. Check Firebase:
   - Verify `lockedUntil` field exists
   - Verify unlock date is recorded

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Temporary lock is NOT available (missing)
- ✅ **When implemented**: Temporary lock works
- ✅ Account is automatically unlocked after duration
- ✅ Lock duration is tracked

**Note**: This is an optional feature for temporary suspensions.

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Account can be locked
- [ ] Account can be unlocked
- [ ] Only Account Holder/Admin can lock accounts
- [ ] User cannot lock their own account
- [ ] Account Holder account cannot be locked
- [ ] Locked users cannot log in (if enforcement is implemented)
- [ ] Locked users cannot access data (if enforcement is implemented)
- [ ] Reason/notes can be provided (if implemented)
- [ ] Lock date is tracked (if implemented)
- [ ] Bulk lock works (if implemented)
- [ ] Account status is displayed correctly
- [ ] Users can be filtered by status (if implemented)
- [ ] Lock/unlock is logged (if audit logging exists)
- [ ] Notifications are sent (if implemented)
- [ ] Temporary lock works (if implemented)

---

## Known Issues (Based on Audit Report)

1. **No Lock/Unlock UI**:
   - No controller/service UI to toggle lock/unlock
   - No UI for account management
   - **Status**: ⛔ Missing

2. **No Enforcement**:
   - No enforcement paths observed
   - Locked users can still log in
   - Locked users can still access data
   - **Status**: ⛔ Missing

3. **isActive Field Exists**:
   - `User.isActive` field exists
   - Field is displayed in profile page
   - But no way to change it
   - **Status**: ⚠️ Partial

---

## Notes for Testers

1. **Current Status**: Account lock/unlock management is partially implemented. The `isActive` field exists but cannot be changed through UI, and there's no enforcement to prevent locked users from logging in.

2. **Enforcement**: Currently, locked users (isActive = false) can still log in. Enforcement needs to be added to login flow and data access.

3. **Permission**: Only Account Holder/Admin should be able to lock/unlock accounts. Members should not have this permission.

4. **Self-Lock Prevention**: Users should not be able to lock their own accounts. This prevents accidental self-lockout.

5. **Account Holder Protection**: Account Holder accounts should not be lockable to prevent workspace lockout.

6. **Login Enforcement**: When implemented, locked users should be blocked from logging in with a clear error message.

7. **Data Access Enforcement**: When implemented, if a user is locked while logged in, they should be logged out and blocked from accessing data.

8. **Audit Logging**: Lock/unlock operations should be logged for compliance and security auditing.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- User roles (Account Holder, Admin, Member)
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase data (if accessible) showing user `isActive` status
- Whether enforcement is working (can locked users log in?)

