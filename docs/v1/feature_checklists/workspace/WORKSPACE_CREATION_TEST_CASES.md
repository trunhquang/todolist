# Workspace Creation Test Cases

## Overview
This document contains step-by-step test cases for testing the **Create Company Workspace** feature. These test cases are designed for manual testing on a physical device or emulator.

## Prerequisites
- User must be logged into the application
- User should have at least one existing workspace (for duplicate name testing)
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: Create Company Workspace - Happy Path

**Objective**: Verify successful creation of a new company workspace with all required fields filled.

**Preconditions**:
- User is logged in
- User is on the Dashboard screen

**Steps**:
1. On the Dashboard screen, locate the "Create Workspace" widget/card
2. Tap the "Create Workspace" button
3. Verify the Create Workspace screen is displayed with:
   - Title: "Create Workspace"
   - Workspace Type selector showing "Personal Workspace" and "Company Workspace" options
   - Workspace Name input field
   - Workspace Description input field (optional)
   - Create button
   - Cancel button
4. Tap on "Company Workspace" option (if not already selected)
5. Verify "Company Workspace" is highlighted/selected (checkmark icon visible)
6. Tap on the "Workspace Name" input field
7. Enter a unique workspace name (e.g., "Test Company ABC")
8. Verify the name is displayed correctly in the input field
9. Tap on the "Workspace Description" input field
10. Enter a description (e.g., "This is a test workspace for company operations")
11. Verify the description is displayed correctly
12. Tap the "Create" button
13. Verify a loading indicator appears on the Create button
14. Wait for the creation process to complete
15. Verify a success message/snackbar appears (e.g., "Workspace created successfully")
16. Verify the screen automatically navigates back to the previous screen
17. Verify the newly created workspace appears in the workspace list
18. Verify the newly created workspace is automatically set as the current workspace

**Expected Results**:
- ✅ Company workspace is created successfully
- ✅ Success message is displayed
- ✅ User is navigated back to Dashboard
- ✅ New workspace appears in workspace list
- ✅ New workspace is set as current workspace
- ✅ Creator is assigned as "Account Holder" role

**Post-conditions**:
- New workspace exists in Firebase
- User is member of the workspace with Account Holder role

---

## Test Case 2: Create Company Workspace - Minimal Required Fields

**Objective**: Verify workspace creation with only required fields (name only, no description).

**Preconditions**:
- User is logged in
- User is on the Dashboard screen

**Steps**:
1. On the Dashboard screen, tap the "Create Workspace" button
2. Verify the Create Workspace screen is displayed
3. Tap on "Company Workspace" option (if not already selected)
4. Tap on the "Workspace Name" input field
5. Enter a unique workspace name (e.g., "Minimal Test Workspace")
6. Leave the "Workspace Description" field empty
7. Tap the "Create" button
8. Verify a loading indicator appears
9. Wait for the creation process to complete
10. Verify a success message appears
11. Verify navigation back occurs
12. Verify the workspace appears in the workspace list

**Expected Results**:
- ✅ Workspace is created successfully with only name field
- ✅ Description field is optional and can be left empty
- ✅ Success message is displayed
- ✅ Navigation works correctly

---

## Test Case 3: Create Workspace - Empty Name Validation

**Objective**: Verify validation error when workspace name is empty.

**Preconditions**:
- User is logged in
- User is on the Create Workspace screen

**Steps**:
1. On the Create Workspace screen, ensure "Company Workspace" is selected
2. Leave the "Workspace Name" field empty
3. Tap the "Create" button
4. Verify an error message appears below the Workspace Name field (e.g., "Please enter workspace name")
5. Verify the Create button does not trigger workspace creation
6. Verify the screen remains on Create Workspace page
7. Enter a single character in the Workspace Name field (e.g., "A")
8. Tap the "Create" button
9. Verify an error message appears (e.g., "Workspace name must be at least 2 characters")
10. Verify workspace is not created

**Expected Results**:
- ✅ Error message displayed for empty name
- ✅ Error message displayed for name less than 2 characters
- ✅ Workspace creation is prevented
- ✅ User remains on Create Workspace screen

---

## Test Case 4: Create Workspace - Duplicate Name Validation

**Objective**: Verify validation error when workspace name already exists.

**Preconditions**:
- User is logged in
- User has at least one existing workspace (e.g., "Existing Workspace")
- User is on the Create Workspace screen

**Steps**:
1. On the Create Workspace screen, ensure "Company Workspace" is selected
2. Tap on the "Workspace Name" input field
3. Enter the exact name of an existing workspace (e.g., "Existing Workspace")
4. Wait for validation to trigger (may happen automatically as you type)
5. Verify an error message appears below the Workspace Name field (e.g., "Workspace name already exists")
6. Verify the error message appears before tapping Create button
7. Tap the "Create" button
8. Verify workspace creation is prevented
9. Verify the error message remains visible
10. Change the workspace name to a unique name (e.g., "Existing Workspace 2")
11. Verify the error message disappears
12. Verify the Create button becomes enabled/functional

**Expected Results**:
- ✅ Error message displayed for duplicate name
- ✅ Validation occurs in real-time as user types
- ✅ Workspace creation is prevented for duplicate names
- ✅ Error clears when name is changed to unique value

---

## Test Case 5: Create Workspace - Invalid Characters in Name

**Objective**: Verify validation for invalid characters in workspace name.

**Preconditions**:
- User is logged in
- User is on the Create Workspace screen

**Steps**:
1. On the Create Workspace screen, ensure "Company Workspace" is selected
2. Tap on the "Workspace Name" input field
3. Enter a name with invalid characters (e.g., "Test<Workspace>", "Test/Workspace", "Test|Workspace")
4. Tap the "Create" button
5. Verify an error message appears (if validation is implemented)
6. OR verify invalid characters are automatically removed/sanitized
7. Enter a valid name with only alphanumeric characters and spaces
8. Verify the name is accepted

**Expected Results**:
- ✅ Invalid characters are either rejected with error message OR automatically sanitized
- ✅ Valid characters are accepted

**Note**: Based on implementation, invalid characters may be sanitized automatically or rejected with error message.

---

## Test Case 6: Create Workspace - Cancel Button

**Objective**: Verify cancel button functionality.

**Preconditions**:
- User is logged in
- User is on the Create Workspace screen

**Steps**:
1. On the Create Workspace screen, enter some data:
   - Select "Company Workspace"
   - Enter a workspace name (e.g., "Test Cancel")
   - Enter a description (e.g., "Testing cancel")
2. Tap the "Cancel" button
3. Verify the screen navigates back to the previous screen (Dashboard)
4. Verify no workspace was created
5. Verify no success/error messages appear
6. Navigate back to Create Workspace screen
7. Verify all fields are empty/reset
8. Verify "Company Workspace" is still selected (default selection)

**Expected Results**:
- ✅ Cancel button navigates back without saving
- ✅ No workspace is created
- ✅ Form is reset when returning to Create Workspace screen

---

## Test Case 7: Create Workspace - Personal vs Company Type

**Objective**: Verify workspace type selection (Personal vs Company).

**Preconditions**:
- User is logged in
- User is on the Create Workspace screen

**Steps**:
1. On the Create Workspace screen, verify "Company Workspace" is selected by default
2. Verify "Company Workspace" option is highlighted with checkmark
3. Tap on "Personal Workspace" option
4. Verify "Personal Workspace" becomes selected/highlighted
5. Verify "Company Workspace" is no longer selected
6. Enter a workspace name (e.g., "Personal Test")
7. Tap the "Create" button
8. Verify workspace is created with Personal type
9. Navigate back to Create Workspace screen
10. Verify "Company Workspace" is selected by default again
11. Select "Company Workspace"
12. Enter a workspace name (e.g., "Company Test")
13. Tap the "Create" button
14. Verify workspace is created with Company type

**Expected Results**:
- ✅ Workspace type can be switched between Personal and Company
- ✅ Selected type is visually indicated
- ✅ Workspace is created with correct type
- ✅ Default selection is Company Workspace

---

## Test Case 8: Create Workspace - Long Name and Description

**Objective**: Verify handling of long workspace names and descriptions.

**Preconditions**:
- User is logged in
- User is on the Create Workspace screen

**Steps**:
1. On the Create Workspace screen, select "Company Workspace"
2. Tap on the "Workspace Name" field
3. Enter a very long name (more than 50 characters, e.g., "This is a very long workspace name that exceeds the maximum allowed length for workspace names")
4. Tap the "Create" button
5. Verify an error message appears (e.g., "Workspace name must be less than 50 characters")
6. OR verify the name is truncated to 50 characters
7. Enter a valid name (2-50 characters)
8. Tap on the "Workspace Description" field
9. Enter a very long description (more than 500 characters)
10. Tap the "Create" button
11. Verify an error message appears for description length
12. OR verify description is truncated
13. Enter a valid description (less than 500 characters)
14. Verify workspace creation succeeds

**Expected Results**:
- ✅ Name length validation works (max 50 characters)
- ✅ Description length validation works (max 500 characters)
- ✅ Appropriate error messages are displayed

---

## Test Case 9: Create Workspace - Loading State

**Objective**: Verify loading state during workspace creation.

**Preconditions**:
- User is logged in
- User is on the Create Workspace screen
- Device has internet connection

**Steps**:
1. On the Create Workspace screen, select "Company Workspace"
2. Enter a valid workspace name (e.g., "Loading Test")
3. Enter an optional description
4. Tap the "Create" button
5. Immediately verify:
   - Create button shows loading indicator (spinner/progress)
   - Create button is disabled (cannot be tapped again)
   - Cancel button is disabled (if implemented)
   - Form fields are disabled (if implemented)
6. Wait for creation to complete
7. Verify loading indicator disappears
8. Verify success message appears
9. Verify navigation occurs

**Expected Results**:
- ✅ Loading indicator is visible during creation
- ✅ Button is disabled during loading
- ✅ User cannot trigger multiple creation requests
- ✅ Loading state clears after completion

---

## Test Case 10: Create Workspace - Network Error Handling

**Objective**: Verify error handling when network connection fails.

**Preconditions**:
- User is logged in
- User is on the Create Workspace screen
- Device internet connection can be disabled

**Steps**:
1. Disable internet connection on the device (Airplane mode or disable WiFi/Mobile data)
2. On the Create Workspace screen, select "Company Workspace"
3. Enter a valid workspace name (e.g., "Network Error Test")
4. Tap the "Create" button
5. Verify loading indicator appears
6. Wait for network timeout/error
7. Verify an error message appears (e.g., "Network error" or "Failed to create workspace")
8. Verify loading indicator disappears
9. Verify user remains on Create Workspace screen
10. Verify entered data is preserved (name and description still visible)
11. Re-enable internet connection
12. Tap the "Create" button again
13. Verify workspace creation succeeds

**Expected Results**:
- ✅ Error message displayed for network failures
- ✅ Loading state clears on error
- ✅ Form data is preserved
- ✅ User can retry after network is restored

---

## Test Case 11: Create Workspace - Verify Creator Role

**Objective**: Verify that workspace creator is assigned Account Holder role.

**Preconditions**:
- User is logged in
- User is on the Create Workspace screen

**Steps**:
1. On the Create Workspace screen, select "Company Workspace"
2. Enter a unique workspace name (e.g., "Role Test Workspace")
3. Tap the "Create" button
4. Wait for successful creation
5. Navigate to Workspace Management or User Management screen
6. Verify the current user appears in the workspace members list
7. Verify the current user has "Account Holder" role
8. Verify the current user has all permissions enabled

**Expected Results**:
- ✅ Creator is automatically added as workspace member
- ✅ Creator is assigned "Account Holder" role
- ✅ Creator has full permissions

**Note**: This may require checking Firebase database or workspace management UI if available.

---

## Test Case 12: Create Workspace - Multiple Workspaces

**Objective**: Verify user can create multiple workspaces.

**Preconditions**:
- User is logged in
- User has at least one existing workspace

**Steps**:
1. Create first workspace:
   - Navigate to Create Workspace screen
   - Select "Company Workspace"
   - Enter name "Workspace 1"
   - Tap Create
   - Verify success
2. Create second workspace:
   - Navigate to Create Workspace screen again
   - Select "Company Workspace"
   - Enter name "Workspace 2"
   - Tap Create
   - Verify success
3. Create third workspace:
   - Navigate to Create Workspace screen again
   - Select "Company Workspace"
   - Enter name "Workspace 3"
   - Tap Create
   - Verify success
4. Navigate to workspace selector/list
5. Verify all three workspaces appear in the list
6. Verify user can switch between all created workspaces

**Expected Results**:
- ✅ Multiple workspaces can be created
- ✅ All workspaces appear in workspace list
- ✅ User can switch between workspaces

---

## Test Case 13: Create Workspace - App Backgrounding During Creation

**Objective**: Verify behavior when app is backgrounded during workspace creation.

**Preconditions**:
- User is logged in
- User is on the Create Workspace screen

**Steps**:
1. On the Create Workspace screen, select "Company Workspace"
2. Enter a valid workspace name (e.g., "Background Test")
3. Tap the "Create" button
4. Immediately background the app (press home button or switch apps)
5. Wait 5-10 seconds
6. Return to the app
7. Verify one of the following:
   - Workspace was created successfully and success message appears
   - OR creation is still in progress (loading indicator visible)
   - OR error message appears if creation failed
8. Verify app state is consistent

**Expected Results**:
- ✅ App handles backgrounding gracefully
- ✅ Workspace creation completes or fails appropriately
- ✅ App state is consistent after returning

---

## Test Case 14: Create Workspace - Rapid Button Taps

**Objective**: Verify handling of rapid multiple taps on Create button.

**Preconditions**:
- User is logged in
- User is on the Create Workspace screen

**Steps**:
1. On the Create Workspace screen, select "Company Workspace"
2. Enter a valid workspace name (e.g., "Rapid Tap Test")
3. Rapidly tap the "Create" button 5-10 times
4. Verify only one workspace creation request is processed
5. Verify only one workspace is created (not multiple duplicates)
6. Verify loading indicator appears and prevents additional taps
7. Wait for creation to complete
8. Verify success message appears only once

**Expected Results**:
- ✅ Multiple rapid taps are handled correctly
- ✅ Only one workspace is created
- ✅ Button is disabled during loading to prevent duplicate requests

---

## Test Case 15: Create Workspace - Special Characters in Description

**Objective**: Verify handling of special characters in workspace description.

**Preconditions**:
- User is logged in
- User is on the Create Workspace screen

**Steps**:
1. On the Create Workspace screen, select "Company Workspace"
2. Enter a valid workspace name (e.g., "Special Chars Test")
3. Tap on the "Workspace Description" field
4. Enter description with special characters:
   - Emojis: "Test 🎉 Workspace 😊"
   - Special symbols: "Test @#$%^&*() Workspace"
   - New lines: "Line 1\nLine 2\nLine 3"
   - Unicode: "Test 测试 Workspace"
5. Tap the "Create" button
6. Verify workspace is created successfully
7. Verify description is saved correctly with all characters
8. Navigate to workspace settings/details
9. Verify description displays correctly with all special characters

**Expected Results**:
- ✅ Special characters are accepted in description
- ✅ Description is saved correctly
- ✅ Description displays correctly when viewed

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] All happy path scenarios work correctly
- [ ] All validation errors are displayed appropriately
- [ ] Loading states work correctly
- [ ] Error handling works for network issues
- [ ] Cancel functionality works
- [ ] Workspace type selection works
- [ ] Creator role assignment works
- [ ] Multiple workspace creation works
- [ ] Edge cases (long names, special chars, rapid taps) are handled

---

## Notes for Testers

1. **Workspace Name Uniqueness**: The validation checks against locally loaded workspaces only. If you have workspaces that aren't loaded, duplicate names might be accepted.

2. **Default Selection**: "Company Workspace" should be selected by default when opening the Create Workspace screen.

3. **Success Navigation**: After successful creation, the app should automatically navigate back to the previous screen (usually Dashboard).

4. **Role Verification**: To verify Account Holder role assignment, you may need to check:
   - Workspace Management screen (if implemented)
   - Firebase Realtime Database directly
   - User Management screen

5. **Network Testing**: For network error testing, use Airplane mode or disable WiFi/Mobile data. Ensure you re-enable connection for subsequent tests.

6. **Data Persistence**: After creating a workspace, close and reopen the app to verify the workspace persists and appears in the workspace list.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)

