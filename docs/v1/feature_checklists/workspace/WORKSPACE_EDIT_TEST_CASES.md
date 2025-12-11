# Workspace Edit Information Test Cases

## Overview
This document contains step-by-step test cases for testing the **Edit Workspace Information** feature (name, description, brand color). This feature is currently **PARTIAL** - some functionality works, but primary color/brand color is missing and there are routing issues.

## Prerequisites
- User must be logged into the application
- User must have a workspace with `manage_workspace` permission (Account Holder or Admin)
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: Edit Workspace Name - Happy Path

**Objective**: Verify successful update of workspace name.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Dashboard screen
- User has at least one workspace

**Steps**:
1. Navigate to Workspace Settings screen:
   - From Dashboard, tap on "Workspace Settings" card/button
   - OR navigate via menu/settings to Workspace Settings ??
2. Verify the Workspace Settings screen is displayed with:
   - Title: "Workspace Settings"
   - Workspace Name input field (pre-filled with current name)
   - Workspace Description input field (pre-filled with current description)
   - Logo URL input field (pre-filled with current logo URL if exists)
   - Save Changes button
   - Cancel button
3. Tap on the "Workspace Name" input field
4. Clear the existing name
5. Enter a new workspace name (e.g., "Updated Company Name")
6. Verify the new name is displayed in the input field
7. Tap the "Save Changes" button
8. Verify a loading indicator appears on the Save button
9. Wait for the update process to complete
10. Verify a success message/snackbar appears (e.g., "Workspace updated successfully")
11. Verify the screen automatically navigates back to the previous screen
12. Verify the workspace name is updated in the workspace list/selector
13. Verify the updated name appears in the workspace header/title

**Expected Results**:
- ✅ Workspace name is updated successfully
- ✅ Success message is displayed
- ✅ User is navigated back
- ✅ Updated name appears in workspace list
- ✅ Updated name persists after app restart

**Post-conditions**:
- Workspace name is updated in Firebase
- Updated name is visible in all workspace references

---

## Test Case 2: Edit Workspace Description - Happy Path

**Objective**: Verify successful update of workspace description.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, locate the "Workspace Description" field
2. Verify the field is pre-filled with current description (if exists)
3. Tap on the "Workspace Description" input field
4. Clear the existing description (if any)
5. Enter a new description (e.g., "This is an updated workspace description for testing")
6. Verify the new description is displayed
7. Tap the "Save Changes" button
8. Verify loading indicator appears
9. Wait for update to complete
10. Verify success message appears
11. Verify navigation back occurs
12. Navigate back to Workspace Settings screen
13. Verify the updated description is displayed in the description field

**Expected Results**:
- ✅ Description is updated successfully
- ✅ Description field can be cleared (optional field)
- ✅ Description persists after save
- ✅ Description displays correctly when returning to settings

---

## Test Case 3: Edit Workspace Logo URL

**Objective**: Verify successful update of workspace logo URL.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, locate the "Logo URL" field
2. Verify the field is pre-filled with current logo URL (if exists)
3. Tap on the "Logo URL" input field
4. Enter a valid image URL (e.g., "https://example.com/logo.png")
5. Verify the URL is displayed correctly
6. Tap the "Save Changes" button
7. Verify loading indicator appears
8. Wait for update to complete
9. Verify success message appears
10. Verify navigation back occurs
11. Navigate back to Workspace Settings screen
12. Verify the updated logo URL is displayed in the field

**Expected Results**:
- ✅ Logo URL is updated successfully
- ✅ Valid URL format is accepted
- ✅ Logo URL persists after save

---

## Test Case 4: Edit Workspace - Empty Name Validation

**Objective**: Verify validation error when workspace name is empty.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, locate the "Workspace Name" field
2. Tap on the "Workspace Name" input field
3. Clear all text (make it empty)
4. Tap outside the field or tap "Save Changes" button
5. Verify an error message appears below the Workspace Name field (e.g., "Please enter workspace name")
6. Verify the Save button does not trigger workspace update
7. Verify the screen remains on Workspace Settings page
8. Enter a single character (e.g., "A")
9. Tap "Save Changes" button
10. Verify an error message appears (e.g., "Workspace name must be at least 2 characters")
11. Verify workspace is not updated

**Expected Results**:
- ✅ Error message displayed for empty name
- ✅ Error message displayed for name less than 2 characters
- ✅ Workspace update is prevented
- ✅ User remains on Workspace Settings screen

---

## Test Case 5: Edit Workspace - Invalid Logo URL Validation

**Objective**: Verify validation error when logo URL format is invalid.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, locate the "Logo URL" field
2. Tap on the "Logo URL" input field
3. Enter an invalid URL (e.g., "not-a-valid-url", "ftp://example.com/logo.png")
4. Tap "Save Changes" button
5. Verify an error message appears (e.g., "Please enter valid URL")
6. Verify workspace is not updated
7. Enter a valid HTTP/HTTPS URL (e.g., "https://example.com/logo.png")
8. Verify the error message disappears
9. Tap "Save Changes" button
10. Verify workspace update succeeds

**Expected Results**:
- ✅ Error message displayed for invalid URL format
- ✅ Only HTTP/HTTPS URLs are accepted
- ✅ Valid URLs are accepted and saved

---

## Test Case 6: Edit Workspace - Cancel Button

**Objective**: Verify cancel button functionality.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, make some changes:
   - Change workspace name to "Test Cancel Name"
   - Change description to "Test Cancel Description"
   - Change logo URL to "https://test.com/logo.png"
2. Tap the "Cancel" button
3. Verify the screen navigates back to the previous screen
4. Verify no workspace update was performed
5. Verify no success/error messages appear
6. Navigate back to Workspace Settings screen
7. Verify all fields show original values (not the test values)

**Expected Results**:
- ✅ Cancel button navigates back without saving
- ✅ No workspace is updated
- ✅ Original values are preserved

---

## Test Case 7: Edit Workspace - Permission Denied

**Objective**: Verify that users without `manage_workspace` permission cannot edit workspace.

**Preconditions**:
- User is logged in
- User does NOT have `manage_workspace` permission (Member role)
- User is on Dashboard screen

**Steps**:
1. Attempt to navigate to Workspace Settings screen
2. Verify one of the following:
   - User is blocked from accessing the screen with error message
   - OR user can access screen but Save button is disabled
   - OR user sees permission denied message
3. If user can access the screen:
   - Try to change workspace name
   - Tap "Save Changes" button
   - Verify error message appears (e.g., "Permission denied")
   - Verify workspace is not updated

**Expected Results**:
- ✅ Users without permission are blocked or see error
- ✅ Workspace is not updated without proper permission

---

## Test Case 8: Edit Workspace - Long Name and Description

**Objective**: Verify handling of long workspace names and descriptions.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. Tap on the "Workspace Name" field
2. Enter a very long name (more than 50 characters)
3. Tap "Save Changes" button
4. Verify an error message appears (e.g., "Workspace name must be less than 50 characters")
5. OR verify the name is truncated to 50 characters
6. Enter a valid name (2-50 characters)
7. Tap on the "Workspace Description" field
8. Enter a very long description (more than 500 characters)
9. Tap "Save Changes" button
10. Verify an error message appears for description length
11. OR verify description is truncated
12. Enter a valid description (less than 500 characters)
13. Verify workspace update succeeds

**Expected Results**:
- ✅ Name length validation works (max 50 characters)
- ✅ Description length validation works (max 500 characters)
- ✅ Appropriate error messages are displayed

---

## Test Case 9: Edit Workspace - Loading State

**Objective**: Verify loading state during workspace update.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen
- Device has internet connection

**Steps**:
1. On the Workspace Settings screen, change workspace name to "Loading Test"
2. Tap the "Save Changes" button
3. Immediately verify:
   - Save button shows loading indicator (spinner/progress)
   - Save button is disabled (cannot be tapped again)
   - Cancel button is disabled (if implemented)
   - Form fields are disabled (if implemented)
4. Wait for update to complete
5. Verify loading indicator disappears
6. Verify success message appears
7. Verify navigation occurs

**Expected Results**:
- ✅ Loading indicator is visible during update
- ✅ Button is disabled during loading
- ✅ User cannot trigger multiple update requests
- ✅ Loading state clears after completion

---

## Test Case 10: Edit Workspace - Network Error Handling

**Objective**: Verify error handling when network connection fails.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen
- Device internet connection can be disabled

**Steps**:
1. Disable internet connection on the device (Airplane mode or disable WiFi/Mobile data)
2. On the Workspace Settings screen, change workspace name to "Network Error Test"
3. Tap the "Save Changes" button
4. Verify loading indicator appears
5. Wait for network timeout/error
6. Verify an error message appears (e.g., "Network error" or "Failed to update workspace")
7. Verify loading indicator disappears
8. Verify user remains on Workspace Settings screen
9. Verify entered data is preserved (name still shows "Network Error Test")
10. Re-enable internet connection
11. Tap the "Save Changes" button again
12. Verify workspace update succeeds

**Expected Results**:
- ✅ Error message displayed for network failures
- ✅ Loading state clears on error
- ✅ Form data is preserved
- ✅ User can retry after network is restored

---

## Test Case 11: Edit Workspace - Multiple Fields Simultaneously

**Objective**: Verify updating multiple fields at once.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, change:
   - Workspace Name: "Multi Field Test"
   - Description: "Updated description for multi-field test"
   - Logo URL: "https://example.com/new-logo.png"
2. Tap the "Save Changes" button
3. Verify loading indicator appears
4. Wait for update to complete
5. Verify success message appears
6. Verify navigation back occurs
7. Navigate back to Workspace Settings screen
8. Verify all three fields show the updated values:
   - Name: "Multi Field Test"
   - Description: "Updated description for multi-field test"
   - Logo URL: "https://example.com/new-logo.png"

**Expected Results**:
- ✅ All fields are updated simultaneously
- ✅ All values persist correctly
- ✅ Single API call updates all fields

---

## Test Case 12: Edit Workspace - Special Characters in Name and Description

**Objective**: Verify handling of special characters in workspace name and description.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. Tap on the "Workspace Name" field
2. Enter name with special characters:
   - Test with: "Workspace @#$% Test"
   - OR test with: "Workspace 🎉 Test"
   - OR test with: "Workspace 测试 Test"
3. Tap "Save Changes" button
4. Verify either:
   - Name is accepted and saved
   - OR invalid characters are rejected with error message
5. Tap on the "Workspace Description" field
6. Enter description with special characters:
   - Emojis: "Test 🎉 Description 😊"
   - Special symbols: "Test @#$%^&*() Description"
   - New lines: "Line 1\nLine 2\nLine 3"
   - Unicode: "Test 测试 Description"
7. Tap "Save Changes" button
8. Verify description is saved correctly
9. Navigate back to Workspace Settings screen
10. Verify description displays correctly with all special characters

**Expected Results**:
- ✅ Special characters are handled appropriately (either accepted or rejected with clear error)
- ✅ Description accepts special characters
- ✅ Data displays correctly when viewed

---

## Test Case 13: Edit Workspace - Verify UpdatedAt Timestamp

**Objective**: Verify that `updatedAt` timestamp is updated when workspace is modified.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. Note the current `updatedAt` timestamp (if visible in UI or check Firebase)
2. On the Workspace Settings screen, change workspace name
3. Tap "Save Changes" button
4. Wait for update to complete
5. Check the `updatedAt` timestamp (via Firebase console or workspace details)
6. Verify the `updatedAt` timestamp is updated to current time
7. Make another change (e.g., update description)
8. Tap "Save Changes" button
9. Wait for update to complete
10. Verify `updatedAt` timestamp is updated again

**Expected Results**:
- ✅ `updatedAt` timestamp is updated on each save
- ✅ Timestamp reflects the actual update time

**Note**: This may require checking Firebase database directly if not visible in UI.

---

## Test Case 14: Edit Workspace - App Backgrounding During Update

**Objective**: Verify behavior when app is backgrounded during workspace update.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, change workspace name to "Background Test"
2. Tap the "Save Changes" button
3. Immediately background the app (press home button or switch apps)
4. Wait 5-10 seconds
5. Return to the app
6. Verify one of the following:
   - Workspace was updated successfully and success message appears
   - OR update is still in progress (loading indicator visible)
   - OR error message appears if update failed
7. Verify app state is consistent

**Expected Results**:
- ✅ App handles backgrounding gracefully
- ✅ Workspace update completes or fails appropriately
- ✅ App state is consistent after returning

---

## Test Case 15: Edit Workspace - Rapid Button Taps

**Objective**: Verify handling of rapid multiple taps on Save button.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, change workspace name to "Rapid Tap Test"
2. Rapidly tap the "Save Changes" button 5-10 times
3. Verify only one workspace update request is processed
4. Verify only one update occurs (not multiple duplicates)
5. Verify loading indicator appears and prevents additional taps
6. Wait for update to complete
7. Verify success message appears only once

**Expected Results**:
- ✅ Multiple rapid taps are handled correctly
- ✅ Only one workspace update is performed
- ✅ Button is disabled during loading to prevent duplicate requests

---

## Test Case 16: Edit Workspace - Primary Color/Brand Color (CURRENTLY MISSING)

**Objective**: Verify primary color/brand color editing functionality.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, look for "Primary Color" or "Brand Color" field
2. Verify one of the following:
   - **If implemented**: Color picker or color selection UI is visible
   - **If NOT implemented**: Field is missing (this is expected based on audit report)
3. If color picker exists:
   - Tap on the color picker
   - Select a new color (e.g., RGB(255, 0, 0) for red)
   - Tap "Save Changes" button
   - Verify color is saved
   - Verify color is applied to workspace UI elements
4. If color picker does NOT exist:
   - Document that this feature is missing
   - Note that this is a known gap per audit report

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Primary color/brand color feature is NOT implemented
- ✅ **When implemented**: Color picker should be available, color should persist, and color should be applied to workspace UI

---

## Test Case 17: Edit Workspace - Routing Issue (CURRENTLY BROKEN)

**Objective**: Verify workspace settings routing works correctly.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission

**Steps**:
1. Navigate to Workspace Settings via different routes:
   - From Dashboard → Workspace Settings
   - From Workspace Management → Edit Workspace
   - From App Settings → Workspace Settings
2. Verify one of the following:
   - **If route works**: Screen loads correctly with workspace data
   - **If route is broken**: App crashes or shows error (this is expected based on audit report)
3. If route is broken:
   - Note the error message
   - Document that `AppRouter.workspaceSettings` route needs workspace parameter

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Route may be broken if workspace parameter is not passed
- ✅ **When fixed**: Route should work correctly and pass workspace parameter

---

## Test Case 18: Edit Workspace - StatefulWidget vs GetX (CURRENTLY VIOLATES RULES)

**Objective**: Verify that WorkspaceSettingsPage follows project rules (GetX + StatelessWidget).

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission

**Steps**:
1. Check the implementation of WorkspaceSettingsPage
2. Verify one of the following:
   - **If using StatefulWidget**: Document that this violates project rules
   - **If using GetX + StatelessWidget**: Verify it follows project patterns
3. Test the page functionality:
   - Navigate to Workspace Settings
   - Make changes
   - Save changes
   - Verify functionality works correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Page may be using StatefulWidget (violates rules)
- ✅ **When fixed**: Should use GetX controller with StatelessWidget

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] All happy path scenarios work correctly
- [ ] All validation errors are displayed appropriately
- [ ] Loading states work correctly
- [ ] Error handling works for network issues
- [ ] Cancel functionality works
- [ ] Permission checks work correctly
- [ ] Edge cases (long names, special chars, rapid taps) are handled
- [ ] Primary color feature is missing (documented)
- [ ] Routing issue is identified (documented)
- [ ] StatefulWidget violation is identified (documented)

---

## Known Issues (Based on Audit Report)

1. **Primary Color/Brand Color Missing**: 
   - No primary color/màu nhận diện support in WorkspaceSettings
   - No server-side persistence for color
   - **Status**: ⚠️ Missing

2. **Routing Issue**:
   - `AppRouter.workspaceSettings` instantiates page without required `workspace` param
   - This may cause runtime break
   - **Status**: ⚠️ Broken

3. **StatefulWidget Violation**:
   - WorkspaceSettingsPage uses StatefulWidget
   - Project rules require GetX + StatelessWidget
   - **Status**: ⚠️ Violates Rules

4. **Management Page Edit Function**:
   - `WorkspaceManagementPage._editWorkspace` is TODO
   - **Status**: ⚠️ Not Implemented

---

## Notes for Testers

1. **Primary Color**: This feature is currently missing. When testing, document that the color picker/selector is not available.

2. **Routing**: If the app crashes when navigating to Workspace Settings, this is the known routing issue. Document the error.

3. **StatefulWidget**: The page may use StatefulWidget which violates project rules. Document this if found.

4. **Permission Testing**: To test permission denied scenarios, you may need to:
   - Use a test account with Member role (not Admin/Account Holder)
   - OR temporarily modify permissions in Firebase

5. **Data Persistence**: After updating workspace, close and reopen the app to verify changes persist.

6. **Firebase Verification**: For critical tests (like timestamp updates), you may need to check Firebase Realtime Database directly to verify data.

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
- Whether it's a known issue or new bug

