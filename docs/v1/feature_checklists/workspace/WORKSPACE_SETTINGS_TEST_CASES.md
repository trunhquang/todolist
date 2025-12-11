# Workspace Settings Test Cases

## Overview
This document contains step-by-step test cases for testing the **Workspace Settings** feature (logo, primary color, timezone, language, date/time format, currency, theme, notifications). This feature is currently **PARTIAL** - most settings work, but primary color is missing and validation needs improvement.

## Prerequisites
- User must be logged into the application
- User must have a workspace with `manage_workspace` permission (Account Holder or Admin)
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: Update Workspace Logo URL - Happy Path

**Objective**: Verify successful update of workspace logo URL.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. Navigate to Workspace Settings screen
2. Verify the Workspace Settings screen is displayed with sections:
   - Basic Settings (Description, Logo URL)
   - Localization (Timezone, Language, Date Format, Time Format, Currency)
   - Appearance (Theme)
   - Preferences (Notifications, Auto Save)
3. Locate the "Logo URL" field in Basic Settings section
4. Verify the field is pre-filled with current logo URL (if exists)
5. Tap on the "Logo URL" input field
6. Clear existing URL (if any)
7. Enter a valid image URL (e.g., "https://example.com/logo.png")
8. Verify the URL is displayed correctly
9. Scroll down and tap the "Save" button (in app bar or bottom)
10. Verify a loading indicator appears
11. Wait for the update process to complete
12. Verify a success message appears (e.g., "Workspace updated successfully")
13. Verify the screen navigates back (or stays with success message)
14. Navigate back to Workspace Settings screen
15. Verify the updated logo URL is displayed in the field

**Expected Results**:
- ✅ Logo URL is updated successfully
- ✅ Valid URL format is accepted
- ✅ Logo URL persists after save
- ✅ Success message is displayed

---

## Test Case 2: Update Workspace Description

**Objective**: Verify successful update of workspace description.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, locate the "Description" field in Basic Settings section
2. Verify the field is pre-filled with current description (if exists)
3. Tap on the "Description" input field
4. Clear existing description (if any)
5. Enter a new description (e.g., "Updated workspace description for testing")
6. Verify the description is displayed correctly
7. Tap the "Save" button
8. Verify loading indicator appears
9. Wait for update to complete
10. Verify success message appears
11. Navigate back to Workspace Settings screen
12. Verify the updated description is displayed

**Expected Results**:
- ✅ Description is updated successfully
- ✅ Description field can be cleared (optional field)
- ✅ Description persists after save

---

## Test Case 3: Update Timezone Setting

**Objective**: Verify successful update of workspace timezone.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, locate the "Timezone" dropdown in Localization section
2. Verify current timezone is displayed (e.g., "UTC")
3. Tap on the Timezone dropdown
4. Verify list of available timezones is displayed (UTC, UTC+1, UTC+2, etc.)
5. Select a different timezone (e.g., "UTC+7")
6. Verify the selected timezone is displayed in the dropdown
7. Tap the "Save" button
8. Verify loading indicator appears
9. Wait for update to complete
10. Verify success message appears
11. Navigate back to Workspace Settings screen
12. Verify the updated timezone is displayed in the dropdown

**Expected Results**:
- ✅ Timezone can be changed via dropdown
- ✅ Selected timezone is displayed correctly
- ✅ Timezone persists after save
- ✅ All available timezones are listed

---

## Test Case 4: Update Language Setting

**Objective**: Verify successful update of workspace language.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, locate the "Language" dropdown in Localization section
2. Verify current language is displayed (e.g., "English" for "en")
3. Tap on the Language dropdown
4. Verify list of available languages is displayed with display names:
   - English, Tiếng Việt, Español, Français, etc.
5. Select a different language (e.g., "Tiếng Việt")
6. Verify the selected language is displayed in the dropdown
7. Tap the "Save" button
8. Verify loading indicator appears
9. Wait for update to complete
10. Verify success message appears
11. Navigate back to Workspace Settings screen
12. Verify the updated language is displayed

**Expected Results**:
- ✅ Language can be changed via dropdown
- ✅ Language display names are shown correctly
- ✅ Selected language persists after save
- ✅ All available languages are listed

---

## Test Case 5: Update Date Format Setting

**Objective**: Verify successful update of workspace date format.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, locate the "Date Format" dropdown in Localization section
2. Verify current date format is displayed (e.g., "MM/dd/yyyy")
3. Tap on the Date Format dropdown
4. Verify list of available formats is displayed:
   - MM/dd/yyyy, dd/MM/yyyy, yyyy-MM-dd, etc.
5. Select a different format (e.g., "dd/MM/yyyy")
6. Verify the selected format is displayed
7. Tap the "Save" button
8. Verify update completes successfully
9. Navigate back to Workspace Settings screen
10. Verify the updated date format is displayed

**Expected Results**:
- ✅ Date format can be changed
- ✅ Selected format persists after save
- ✅ All available formats are listed

---

## Test Case 6: Update Time Format Setting

**Objective**: Verify successful update of workspace time format.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, locate the "Time Format" dropdown in Localization section
2. Verify current time format is displayed (e.g., "12h" or "24h")
3. Tap on the Time Format dropdown
4. Verify options are displayed: "12h" and "24h"
5. Select the other format (if currently 12h, select 24h, or vice versa)
6. Verify the selected format is displayed
7. Tap the "Save" button
8. Verify update completes successfully
9. Navigate back to Workspace Settings screen
10. Verify the updated time format is displayed

**Expected Results**:
- ✅ Time format can be changed between 12h and 24h
- ✅ Selected format persists after save

---

## Test Case 7: Update Currency Setting

**Objective**: Verify successful update of workspace currency.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, locate the "Currency" dropdown in Localization section
2. Verify current currency is displayed (e.g., "US Dollar ($)")
3. Tap on the Currency dropdown
4. Verify list of available currencies is displayed with display names:
   - US Dollar ($), Euro (€), British Pound (£), etc.
5. Select a different currency (e.g., "Vietnamese Dong (₫)")
6. Verify the selected currency is displayed
7. Tap the "Save" button
8. Verify update completes successfully
9. Navigate back to Workspace Settings screen
10. Verify the updated currency is displayed

**Expected Results**:
- ✅ Currency can be changed via dropdown
- ✅ Currency display names with symbols are shown correctly
- ✅ Selected currency persists after save

---

## Test Case 8: Update Theme Setting

**Objective**: Verify successful update of workspace theme.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, locate the "Theme" dropdown in Appearance section
2. Verify current theme is displayed (e.g., "System", "Light", or "Dark")
3. Tap on the Theme dropdown
4. Verify options are displayed: "Light", "Dark", "System"
5. Select a different theme (e.g., if currently "System", select "Dark")
6. Verify the selected theme is displayed
7. Tap the "Save" button
8. Verify update completes successfully
9. Navigate back to Workspace Settings screen
10. Verify the updated theme is displayed
11. Verify the workspace UI reflects the theme change (if implemented)

**Expected Results**:
- ✅ Theme can be changed via dropdown
- ✅ Selected theme persists after save
- ✅ Theme options (Light/Dark/System) are available

---

## Test Case 9: Update Notifications Toggle

**Objective**: Verify successful update of workspace notifications setting.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, locate the "Notifications" switch in Preferences section
2. Verify current state of the switch (ON or OFF)
3. Tap the Notifications switch to toggle it
4. Verify the switch state changes (ON to OFF or OFF to ON)
5. Verify the switch visual state updates immediately
6. Tap the "Save" button
7. Verify update completes successfully
8. Navigate back to Workspace Settings screen
9. Verify the switch state matches the saved value

**Expected Results**:
- ✅ Notifications switch can be toggled
- ✅ Switch state updates immediately
- ✅ Toggle state persists after save

---

## Test Case 10: Update Auto Save Toggle

**Objective**: Verify successful update of workspace auto save setting.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, locate the "Auto Save" switch in Preferences section
2. Verify current state of the switch
3. Tap the Auto Save switch to toggle it
4. Verify the switch state changes
5. Tap the "Save" button
6. Verify update completes successfully
7. Navigate back to Workspace Settings screen
8. Verify the switch state matches the saved value

**Expected Results**:
- ✅ Auto Save switch can be toggled
- ✅ Toggle state persists after save

---

## Test Case 11: Update Multiple Settings Simultaneously

**Objective**: Verify updating multiple settings at once.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, make multiple changes:
   - Change timezone to "UTC+7"
   - Change language to "Tiếng Việt"
   - Change date format to "dd/MM/yyyy"
   - Change currency to "VND"
   - Toggle notifications switch
2. Verify all changes are reflected in the UI
3. Tap the "Save" button
4. Verify loading indicator appears
5. Wait for update to complete
6. Verify success message appears
7. Navigate back to Workspace Settings screen
8. Verify all changes are persisted:
   - Timezone: UTC+7
   - Language: Tiếng Việt
   - Date Format: dd/MM/yyyy
   - Currency: VND
   - Notifications: Updated state

**Expected Results**:
- ✅ All settings can be updated simultaneously
- ✅ All values persist correctly
- ✅ Single API call updates all settings

---

## Test Case 12: Invalid Logo URL Validation

**Objective**: Verify validation error when logo URL format is invalid.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, locate the "Logo URL" field
2. Tap on the Logo URL input field
3. Enter an invalid URL (e.g., "not-a-valid-url", "ftp://example.com/logo.png")
4. Tap the "Save" button
5. Verify one of the following:
   - Error message appears below the field (e.g., "Invalid logo URL format")
   - OR validation prevents save
6. Enter a valid HTTP/HTTPS URL (e.g., "https://example.com/logo.png")
7. Verify the error message disappears (if shown)
8. Tap the "Save" button
9. Verify workspace update succeeds

**Expected Results**:
- ✅ Invalid URL format is rejected
- ✅ Error message is displayed (if validation is implemented)
- ✅ Valid URLs are accepted

**Note**: Validation may not be enforced before save (known gap).

---

## Test Case 13: Timezone/Language Validation (CURRENTLY NOT ENFORCED)

**Objective**: Verify timezone and language validation before save.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, note current timezone and language values
2. Try to save with invalid values (if possible to set):
   - This may require modifying dropdown values programmatically
   - OR checking if validation exists
3. Verify one of the following:
   - **If validation exists**: Error message appears for invalid timezone/language
   - **If validation does NOT exist**: Invalid values may be saved (this is expected based on audit report)
4. Document the current behavior

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Timezone/language validation may not be enforced before save
- ✅ **When implemented**: Invalid values should be rejected with error messages

---

## Test Case 14: Primary Color/Brand Color (CURRENTLY MISSING)

**Objective**: Verify primary color/brand color (màu nhận diện) setting functionality.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, look for "Primary Color" or "Brand Color" field in Appearance section
2. Verify one of the following:
   - **If implemented**: Color picker or color selection UI is visible
   - **If NOT implemented**: Field is missing (this is expected based on audit report)
3. If color picker exists:
   - Tap on the color picker
   - Select a color (e.g., RGB(255, 0, 0) for red)
   - Verify color preview is shown
   - Tap "Save" button
   - Verify color is saved
   - Verify color is applied to workspace UI elements
4. If color picker does NOT exist:
   - Document that this feature is missing
   - Note that this is a known gap per audit report

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Primary color/brand color feature is NOT implemented
- ✅ **When implemented**: Color picker should be available, color should persist, and color should be applied to workspace UI

---

## Test Case 15: Cancel Button Functionality

**Objective**: Verify cancel button discards changes.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, make some changes:
   - Change timezone to "UTC+7"
   - Change language to "Tiếng Việt"
   - Change description to "Test Cancel"
2. Tap the "Cancel" button
3. Verify the screen navigates back to previous screen
4. Verify no workspace update was performed
5. Verify no success/error messages appear
6. Navigate back to Workspace Settings screen
7. Verify all fields show original values (not the test values)

**Expected Results**:
- ✅ Cancel button navigates back without saving
- ✅ No workspace is updated
- ✅ Original values are preserved

---

## Test Case 16: Permission Denied - Member Role

**Objective**: Verify that users without `manage_workspace` permission cannot update settings.

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
   - Try to change a setting (e.g., timezone)
   - Tap "Save" button
   - Verify error message appears (e.g., "Permission denied")
   - Verify workspace is not updated

**Expected Results**:
- ✅ Users without permission are blocked or see error
- ✅ Workspace settings are not updated without proper permission

---

## Test Case 17: Loading State During Save

**Objective**: Verify loading state during workspace settings update.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen
- Device has internet connection

**Steps**:
1. On the Workspace Settings screen, change a setting (e.g., timezone)
2. Tap the "Save" button
3. Immediately verify:
   - Save button shows loading indicator (spinner/progress)
   - Save button is disabled (cannot be tapped again)
   - Cancel button is disabled (if implemented)
   - Form fields are disabled (if implemented)
4. Wait for update to complete
5. Verify loading indicator disappears
6. Verify success message appears
7. Verify navigation occurs (if implemented)

**Expected Results**:
- ✅ Loading indicator is visible during update
- ✅ Button is disabled during loading
- ✅ User cannot trigger multiple update requests
- ✅ Loading state clears after completion

---

## Test Case 18: Network Error Handling

**Objective**: Verify error handling when network connection fails.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen
- Device internet connection can be disabled

**Steps**:
1. Disable internet connection on the device (Airplane mode or disable WiFi/Mobile data)
2. On the Workspace Settings screen, change a setting (e.g., timezone to "UTC+7")
3. Tap the "Save" button
4. Verify loading indicator appears
5. Wait for network timeout/error
6. Verify an error message appears (e.g., "Network error" or "Failed to update workspace")
7. Verify loading indicator disappears
8. Verify user remains on Workspace Settings screen
9. Verify entered data is preserved (timezone still shows "UTC+7")
10. Re-enable internet connection
11. Tap the "Save" button again
12. Verify workspace update succeeds

**Expected Results**:
- ✅ Error message displayed for network failures
- ✅ Loading state clears on error
- ✅ Form data is preserved
- ✅ User can retry after network is restored

---

## Test Case 19: StatefulWidget vs GetX (CURRENTLY VIOLATES RULES)

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

## Test Case 20: Settings Persistence After App Restart

**Objective**: Verify that workspace settings persist after app restart.

**Preconditions**:
- User is logged in
- User has `manage_workspace` permission
- User is on Workspace Settings screen

**Steps**:
1. On the Workspace Settings screen, change multiple settings:
   - Timezone: "UTC+7"
   - Language: "Tiếng Việt"
   - Currency: "VND"
   - Theme: "Dark"
2. Tap "Save" button
3. Verify update succeeds
4. Close the app completely
5. Reopen the app
6. Navigate to Workspace Settings screen
7. Verify all saved settings are displayed correctly:
   - Timezone: UTC+7
   - Language: Tiếng Việt
   - Currency: VND
   - Theme: Dark

**Expected Results**:
- ✅ All settings persist after app restart
- ✅ Settings are loaded from Firebase correctly
- ✅ Settings are displayed correctly in UI

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Logo URL can be updated
- [ ] Description can be updated
- [ ] Timezone can be changed
- [ ] Language can be changed
- [ ] Date format can be changed
- [ ] Time format can be changed
- [ ] Currency can be changed
- [ ] Theme can be changed
- [ ] Notifications toggle works
- [ ] Auto Save toggle works
- [ ] Multiple settings can be updated simultaneously
- [ ] Validation works (when implemented)
- [ ] Primary color feature is missing (documented)
- [ ] StatefulWidget violation is identified (documented)
- [ ] Settings persist after app restart
- [ ] Permission checks work correctly
- [ ] Loading states work correctly
- [ ] Error handling works for network issues

---

## Known Issues (Based on Audit Report)

1. **Primary Color Missing**: 
   - No primary color/màu nhận diện support in WorkspaceSettings
   - No server-side persistence for color
   - **Status**: ⚠️ Missing

2. **Validation Not Enforced**:
   - Timezone/language validation not enforced before save
   - **Status**: ⚠️ Missing

3. **StatefulWidget Violation**:
   - WorkspaceSettingsPage uses StatefulWidget
   - Project rules require GetX + StatelessWidget
   - **Status**: ⚠️ Violates Rules

---

## Notes for Testers

1. **Primary Color**: This feature is currently missing. When testing, document that the color picker/selector is not available.

2. **Validation**: Timezone and language validation may not be enforced before save. Document this if found.

3. **StatefulWidget**: The page may use StatefulWidget which violates project rules. Document this if found.

4. **Permission Testing**: To test permission denied scenarios, you may need to:
   - Use a test account with Member role (not Admin/Account Holder)
   - OR temporarily modify permissions in Firebase

5. **Data Persistence**: After updating settings, close and reopen the app to verify changes persist.

6. **Firebase Verification**: For critical tests (like persistence), you may need to check Firebase Realtime Database directly to verify data.

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

