# Personal Workspace Auto-Create Test Cases

## Overview
This document contains step-by-step test cases for testing the **Personal Workspace Auto-Create During Registration** feature. This feature is currently **MISSING** - users can register, but personal workspace is not automatically created.

## Prerequisites
- App is installed and can be launched
- User is NOT logged in
- Device should have internet connection (for Firebase sync)
- Firebase is properly configured

---

## Test Case 1: Register New User - Personal Workspace Auto-Create (CURRENTLY MISSING)

**Objective**: Verify that a personal workspace is automatically created when a new user registers.

**Preconditions**:
- User is NOT logged in
- User is on Login/Register screen
- Device has internet connection

**Steps**:
1. Launch the app
2. Navigate to Register screen:
   - Tap "Register" or "Create Account" button on Login screen
3. Verify the Register screen is displayed with:
   - Name input field
   - Email input field
   - Password input field
   - Confirm Password input field
   - Register/Create Account button
4. Fill in registration form:
   - Enter name: "Test User"
   - Enter email: "testuser@example.com" (use unique email)
   - Enter password: "TestPassword123!"
   - Enter confirm password: "TestPassword123!"
5. Tap the "Register" or "Create Account" button
6. Verify loading indicator appears
7. Wait for registration to complete
8. Verify one of the following:
   - **If implemented**: Success message appears, personal workspace is created automatically
   - **If NOT implemented**: Registration succeeds but no workspace is created (this is expected based on audit report)
9. After registration, verify navigation:
   - User is navigated to Dashboard or appropriate screen
10. Check if personal workspace exists:
    - Navigate to workspace selector/list
    - Verify if personal workspace appears
    - OR verify workspace is missing (expected if not implemented)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Personal workspace is NOT auto-created during registration
- ✅ **When implemented**: 
  - Personal workspace is created automatically
  - Workspace name should be user's name or "Personal Workspace"
  - Workspace type is "Personal"
  - User is assigned as Account Holder
  - Workspace appears in workspace list
  - Workspace is set as current workspace

**Post-conditions**:
- User account is created in Firebase
- Personal workspace is created (when implemented)
- User is member of personal workspace with Account Holder role (when implemented)

---

## Test Case 2: Register with Email - Verify Workspace Creation Flow

**Objective**: Verify the complete flow of registration with personal workspace auto-creation.

**Preconditions**:
- User is NOT logged in
- User is on Register screen

**Steps**:
1. On Register screen, fill registration form with valid data
2. Tap "Register" button
3. Verify registration process:
   - Loading indicator appears
   - User account is created in Firebase
   - **If implemented**: Personal workspace creation is triggered
4. Wait for all processes to complete
5. Verify success message appears
6. Verify navigation to Dashboard
7. Check workspace:
   - Open workspace selector
   - Verify personal workspace exists
   - Verify workspace name (e.g., "Test User's Personal Workspace" or "Personal")
   - Verify workspace type is "Personal"
   - Verify current workspace is set to personal workspace
8. Check user role:
   - Navigate to workspace settings or management
   - Verify user has Account Holder role
   - Verify user has all permissions

**Expected Results**:
- ✅ **When implemented**: Complete flow works correctly**
- ✅ User account and workspace are created atomically
- ✅ User can immediately use the app with personal workspace

---

## Test Case 3: Register with Google Sign-In - Personal Workspace Auto-Create

**Objective**: Verify personal workspace is auto-created when registering with Google.

**Preconditions**:
- User is NOT logged in
- User is on Login/Register screen
- Google Sign-In is configured

**Steps**:
1. On Login/Register screen, tap "Sign in with Google" button
2. Complete Google authentication flow
3. Verify registration/authentication succeeds
4. Verify one of the following:
   - **If implemented**: Personal workspace is created automatically
   - **If NOT implemented**: No workspace is created
5. After authentication, check workspace:
   - Navigate to workspace selector
   - Verify if personal workspace exists
6. If workspace exists:
   - Verify workspace name uses Google account name
   - Verify workspace type is "Personal"
   - Verify user is Account Holder

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Personal workspace may not be auto-created
- ✅ **When implemented**: Personal workspace is created for Google sign-in users too

---

## Test Case 4: Register - Verify Workspace Name Format

**Objective**: Verify the format of auto-created personal workspace name.

**Preconditions**:
- User is NOT logged in
- Personal workspace auto-create is implemented

**Steps**:
1. Register a new user with name "John Doe"
2. Complete registration
3. Verify personal workspace is created
4. Check workspace name:
   - Navigate to workspace selector
   - Verify workspace name format
   - Expected formats could be:
     - "John Doe's Personal Workspace"
     - "Personal - John Doe"
     - "Personal Workspace"
     - Or just "Personal"
5. Register another user with different name
6. Verify workspace name is appropriate for that user

**Expected Results**:
- ✅ **When implemented**: Workspace name follows consistent format
- ✅ Workspace name is user-friendly and identifiable
- ✅ Workspace name includes user's name or is clearly personal

---

## Test Case 5: Register - Verify Workspace Settings

**Objective**: Verify default settings for auto-created personal workspace.

**Preconditions**:
- User is NOT logged in
- Personal workspace auto-create is implemented

**Steps**:
1. Register a new user
2. Complete registration
3. Navigate to Workspace Settings
4. Verify default settings:
   - Timezone: Should have default (e.g., UTC or user's timezone)
   - Language: Should have default (e.g., 'en' or app default)
   - Date Format: Should have default
   - Time Format: Should have default
   - Currency: Should have default
   - Theme: Should have default (e.g., 'system')
   - Notifications: Should be enabled by default
   - Auto Save: Should be enabled by default
5. Verify settings are saved to Firebase

**Expected Results**:
- ✅ **When implemented**: Default settings are applied to personal workspace
- ✅ Settings are appropriate for personal use
- ✅ Settings can be modified later

---

## Test Case 6: Register - Verify User Permissions

**Objective**: Verify user has correct permissions in auto-created personal workspace.

**Preconditions**:
- User is NOT logged in
- Personal workspace auto-create is implemented

**Steps**:
1. Register a new user
2. Complete registration
3. Verify user role in personal workspace:
   - Navigate to workspace management or settings
   - Verify user has "Account Holder" role
4. Verify user permissions:
   - Check if user can create tasks
   - Check if user can create projects
   - Check if user can manage workspace
   - Check if user has all personal workspace permissions
5. Verify permission set matches `DefaultPermissionSets.personalUserPermissions` or `accountHolderPermissions`

**Expected Results**:
- ✅ **When implemented**: User has Account Holder role
- ✅ User has all necessary permissions for personal workspace
- ✅ User can perform all personal workspace operations

---

## Test Case 7: Register - Network Error During Workspace Creation

**Objective**: Verify error handling when network fails during workspace creation.

**Preconditions**:
- User is NOT logged in
- Personal workspace auto-create is implemented
- Device internet connection can be disabled

**Steps**:
1. Start registration process:
   - Fill registration form
   - Tap "Register" button
2. Immediately after registration succeeds but before workspace creation:
   - Disable internet connection (Airplane mode or disable WiFi/Mobile data)
3. Verify one of the following:
   - **If atomic**: Registration fails if workspace creation fails
   - **If separate**: Registration succeeds but workspace creation fails
4. Verify error message appears
5. Re-enable internet connection
6. Verify one of the following:
   - User can retry workspace creation
   - OR workspace is created automatically on next login
   - OR user is prompted to create workspace

**Expected Results**:
- ✅ **When implemented**: Error handling works correctly
- ✅ User is informed of the error
- ✅ Workspace creation can be retried or completed later
- ✅ Data consistency is maintained

---

## Test Case 8: Register - Duplicate Email Handling

**Objective**: Verify behavior when registering with existing email (workspace should not be created).

**Preconditions**:
- User account with email "existing@example.com" already exists
- User is NOT logged in

**Steps**:
1. On Register screen, enter email "existing@example.com"
2. Fill other registration fields
3. Tap "Register" button
4. Verify error message appears (e.g., "Email already exists")
5. Verify registration fails
6. Verify NO workspace is created (since registration failed)
7. Verify user remains on Register screen

**Expected Results**:
- ✅ Registration fails with appropriate error
- ✅ No workspace is created for failed registration
- ✅ User can correct email and retry

---

## Test Case 9: Register - Verify Workspace Appears in List

**Objective**: Verify personal workspace appears in workspace list after registration.

**Preconditions**:
- User is NOT logged in
- Personal workspace auto-create is implemented

**Steps**:
1. Register a new user
2. Complete registration
3. Navigate to workspace selector/list (if available)
4. Verify personal workspace appears in the list
5. Verify workspace is marked as "Personal" type
6. Verify workspace is set as current/active workspace
7. Verify workspace can be selected/switched to
8. Verify workspace appears after app restart

**Expected Results**:
- ✅ **When implemented**: Personal workspace appears in list
- ✅ Workspace is identifiable as personal workspace
- ✅ Workspace is set as current workspace
- ✅ Workspace persists after app restart

---

## Test Case 10: Register - Multiple Users Same Device

**Objective**: Verify personal workspace creation for multiple users on same device.

**Preconditions**:
- User A is registered and logged out
- User B wants to register
- Personal workspace auto-create is implemented

**Steps**:
1. As User A, log out
2. Register User B with different email
3. Complete registration
4. Verify User B's personal workspace is created
5. Verify User B's workspace is separate from User A's workspace
6. Log out User B
7. Log in as User A
8. Verify User A sees only User A's workspace (not User B's)

**Expected Results**:
- ✅ **When implemented**: Each user gets their own personal workspace
- ✅ Workspaces are isolated per user
- ✅ Users cannot see each other's personal workspaces

---

## Test Case 11: Register - Verify Workspace ID Assignment

**Objective**: Verify workspace ID is properly assigned and stored.

**Preconditions**:
- User is NOT logged in
- Personal workspace auto-create is implemented

**Steps**:
1. Register a new user
2. Complete registration
3. Check Firebase Realtime Database:
   - Navigate to `workspaces/{workspaceId}`
   - Verify workspace exists with unique ID
   - Verify workspace `createdBy` field matches user ID
   - Verify workspace `type` is "personal"
4. Check workspace members:
   - Navigate to `workspace_members/{workspaceId}/{userId}`
   - Verify user is member with Account Holder role
5. Check user document:
   - Verify user document exists
   - Verify user can access the workspace

**Expected Results**:
- ✅ **When implemented**: Workspace has unique ID
- ✅ Workspace is properly linked to user
- ✅ User is properly added as member
- ✅ All relationships are correct in Firebase

**Note**: This may require Firebase console access.

---

## Test Case 12: Register - Verify Workspace Creation Timing

**Objective**: Verify workspace is created at the correct time during registration flow.

**Preconditions**:
- User is NOT logged in
- Personal workspace auto-create is implemented

**Steps**:
1. Start registration process
2. Monitor the flow:
   - User account creation
   - Personal workspace creation
   - Navigation to Dashboard
3. Verify workspace is created:
   - After user account is created
   - Before navigation to Dashboard
   - OR as part of atomic transaction
4. Verify user can access workspace immediately after registration
5. Verify no delay or missing workspace on first login

**Expected Results**:
- ✅ **When implemented**: Workspace is created at appropriate time
- ✅ User has workspace available immediately
- ✅ No race conditions or timing issues

---

## Test Case 13: Register - App Restart After Registration

**Objective**: Verify personal workspace persists after app restart.

**Preconditions**:
- User is NOT logged in
- Personal workspace auto-create is implemented

**Steps**:
1. Register a new user
2. Complete registration
3. Verify personal workspace exists
4. Close the app completely
5. Reopen the app
6. Log in with the registered credentials
7. Verify personal workspace still exists
8. Verify workspace is loaded correctly
9. Verify workspace is set as current workspace

**Expected Results**:
- ✅ **When implemented**: Workspace persists after app restart
- ✅ Workspace is loaded from Firebase correctly
- ✅ User can continue using workspace after restart

---

## Test Case 14: Register - Verify No Duplicate Workspace Creation

**Objective**: Verify personal workspace is not created multiple times for same user.

**Preconditions**:
- User is NOT logged in
- Personal workspace auto-create is implemented

**Steps**:
1. Register a new user
2. Complete registration
3. Note the workspace ID
4. Log out
5. Log in again with same credentials
6. Verify only ONE personal workspace exists
7. Verify workspace ID is the same as before
8. Verify no duplicate workspaces are created

**Expected Results**:
- ✅ **When implemented**: Only one personal workspace per user
- ✅ Workspace is not recreated on subsequent logins
- ✅ Existing workspace is reused

---

## Test Case 15: Register - Error Recovery

**Objective**: Verify recovery mechanism if workspace creation fails partially.

**Preconditions**:
- User is NOT logged in
- Personal workspace auto-create is implemented
- Can simulate partial failure

**Steps**:
1. Register a new user
2. Simulate workspace creation failure (if possible):
   - Network interruption
   - Firebase error
   - Permission error
3. Verify error handling:
   - Error message is displayed
   - User is informed of the issue
4. Verify recovery options:
   - User can retry workspace creation
   - OR workspace is created on next login
   - OR manual workspace creation is available
5. Verify data consistency:
   - User account exists
   - No orphaned data
   - Workspace creation can be completed

**Expected Results**:
- ✅ **When implemented**: Error recovery works correctly
- ✅ User is not left in inconsistent state
- ✅ Workspace creation can be completed later

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Personal workspace is auto-created during registration (when implemented)
- [ ] Workspace name is appropriate
- [ ] Workspace type is "Personal"
- [ ] User has Account Holder role
- [ ] User has correct permissions
- [ ] Workspace appears in workspace list
- [ ] Workspace is set as current workspace
- [ ] Workspace persists after app restart
- [ ] No duplicate workspaces are created
- [ ] Error handling works correctly
- [ ] Workspace creation works for email registration
- [ ] Workspace creation works for Google sign-in
- [ ] Each user gets their own workspace
- [ ] Workspace settings have defaults

---

## Known Issues (Based on Audit Report)

1. **Personal Workspace Auto-Create Missing**: 
   - No creation logic in auth register flow
   - Only enum/supporting strings exist
   - `WorkspaceRemoteDataSource`/use cases never called during registration
   - **Status**: ⛔ Missing

2. **Current Behavior**:
   - User account is created successfully
   - Personal workspace is NOT created
   - User must manually create workspace later
   - **Status**: ⛔ Not Implemented

---

## Notes for Testers

1. **Current Status**: Personal workspace auto-creation is NOT implemented. When testing, document that workspace is not created automatically.

2. **Expected Behavior**: When implemented, personal workspace should be created automatically during registration, before or after user account creation.

3. **Workspace Name**: The format of personal workspace name should be determined during implementation. Common formats:
   - "{User Name}'s Personal Workspace"
   - "Personal - {User Name}"
   - "Personal Workspace"
   - Just "Personal"

4. **Testing Registration**: Use unique email addresses for each test to avoid conflicts.

5. **Firebase Verification**: For critical tests (like workspace creation), you may need to check Firebase Realtime Database directly to verify workspace is created.

6. **Error Scenarios**: Test various error scenarios to ensure robust implementation.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- Registration method (email/Google)
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Firebase data (if accessible)
- Whether it's a known issue or new bug

