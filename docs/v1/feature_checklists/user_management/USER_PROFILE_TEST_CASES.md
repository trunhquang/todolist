# User Profile (Name, Avatar, Timezone, Language, Signature) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **User Profile** feature (name, avatar, timezone, language, signature). This feature is currently **PARTIAL** - name and avatar updates work, but timezone/language/signature handling, validation, and persistence are missing, and there's no UI for profile edit beyond name/avatar.

## Prerequisites
- User must be logged in
- Device should have internet connection (for Firebase sync)
- User should have access to profile page

---

## Test Case 1: Update User Name - Happy Path

**Objective**: Verify user name can be updated successfully.

**Preconditions**:
- User is logged in
- User is on Profile page or Edit Profile page
- Name update feature is implemented

**Steps**:
1. Navigate to Profile page
2. Locate "Edit Profile" option
3. Tap "Edit Profile"
4. Verify Edit Profile screen appears
5. Locate "Name" or "Full Name" input field
6. Verify current name is displayed in the field
7. Clear the name field
8. Enter new name (e.g., "John Doe Updated")
9. Verify name is entered correctly
10. Tap "Save" or "Update" button
11. Verify loading indicator appears
12. Wait for update to complete
13. Verify success message appears: "Profile updated successfully" or similar
14. Verify profile page shows updated name
15. Verify name is updated in Firebase
16. Restart app
17. Verify name persists after restart

**Expected Results**:
- ✅ Name can be updated
- ✅ Update is saved to Firebase
- ✅ Name persists after app restart
- ✅ Success message is shown

---

## Test Case 2: Update User Avatar - Happy Path

**Objective**: Verify user avatar can be updated successfully.

**Preconditions**:
- User is logged in
- User is on Edit Profile page
- Avatar update feature is implemented

**Steps**:
1. Navigate to Edit Profile page
2. Locate avatar/image section
3. Verify current avatar is displayed (or placeholder if no avatar)
4. Tap on avatar or "Change Avatar" button
5. Verify image picker options appear:
   - Camera
   - Gallery/Photo Library
6. Select "Gallery" option
7. Select an image from gallery
8. Verify selected image is displayed as preview
9. Tap "Save" or "Update" button
10. Verify loading indicator appears
11. Wait for upload to complete
12. Verify success message appears
13. Verify profile page shows updated avatar
14. Verify avatar URL is updated in Firebase
15. Restart app
16. Verify avatar persists after restart

**Expected Results**:
- ✅ Avatar can be updated
- ✅ Image picker works correctly
- ✅ Avatar is uploaded to storage
- ✅ Avatar URL is saved to Firebase
- ✅ Avatar persists after app restart

---

## Test Case 3: Update User Timezone - Missing Feature

**Objective**: Verify user timezone can be updated (currently missing).

**Preconditions**:
- User is logged in
- User is on Edit Profile page
- Timezone update feature is implemented

**Steps**:
1. Navigate to Edit Profile page
2. Locate "Timezone" dropdown or field
3. Verify one of the following:
   - **If NOT implemented**: Timezone field is not available (this is expected - feature missing)
   - **If implemented**: Timezone field is available
4. If implemented:
   - Verify current timezone is displayed (e.g., "UTC" or system timezone)
   - Tap on Timezone dropdown
   - Verify list of available timezones is displayed
   - Select a different timezone (e.g., "UTC+7")
   - Verify selected timezone is displayed
   - Tap "Save" button
   - Verify timezone is updated
   - Verify timezone is saved to Firebase
   - Restart app
   - Verify timezone persists after restart

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Timezone update is NOT available (missing)
- ✅ **When implemented**: Timezone can be updated
- ✅ Timezone is saved to Firebase
- ✅ Timezone persists after app restart

---

## Test Case 4: Update User Language - Missing Feature

**Objective**: Verify user language can be updated (currently missing).

**Preconditions**:
- User is logged in
- User is on Edit Profile page
- Language update feature is implemented

**Steps**:
1. Navigate to Edit Profile page
2. Locate "Language" dropdown or field
3. Verify one of the following:
   - **If NOT implemented**: Language field is not available (this is expected - feature missing)
   - **If implemented**: Language field is available
4. If implemented:
   - Verify current language is displayed (e.g., "English" for "en")
   - Tap on Language dropdown
   - Verify list of available languages is displayed with display names:
     - English
     - Tiếng Việt
     - Español
     - etc.
   - Select a different language (e.g., "Tiếng Việt")
   - Verify selected language is displayed
   - Tap "Save" button
   - Verify language is updated
   - Verify app language changes (if app supports localization)
   - Verify language is saved to Firebase
   - Restart app
   - Verify language persists after restart

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Language update is NOT available (missing)
- ✅ **When implemented**: Language can be updated
- ✅ Language is saved to Firebase
- ✅ Language persists after app restart
- ✅ App language changes (if localization is implemented)

---

## Test Case 5: Update User Signature - Missing Feature

**Objective**: Verify user signature can be updated (currently missing).

**Preconditions**:
- User is logged in
- User is on Edit Profile page
- Signature update feature is implemented

**Steps**:
1. Navigate to Edit Profile page
2. Locate "Signature" text field
3. Verify one of the following:
   - **If NOT implemented**: Signature field is not available (this is expected - feature missing)
   - **If implemented**: Signature field is available
4. If implemented:
   - Verify current signature is displayed (or empty if no signature)
   - Enter signature text (e.g., "Best regards, John Doe")
   - Verify signature is entered correctly
   - Tap "Save" button
   - Verify signature is updated
   - Verify signature is saved to Firebase
   - Navigate to profile page
   - Verify signature is displayed (if signature display is implemented)
   - Restart app
   - Verify signature persists after restart

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Signature update is NOT available (missing)
- ✅ **When implemented**: Signature can be updated
- ✅ Signature is saved to Firebase
- ✅ Signature persists after app restart

---

## Test Case 6: Name Validation - Empty Name

**Objective**: Verify validation prevents empty name.

**Preconditions**:
- User is logged in
- User is on Edit Profile page

**Steps**:
1. Navigate to Edit Profile page
2. Locate "Name" input field
3. Clear the name field (make it empty)
4. Tap "Save" button
5. Verify error message appears: "Name is required" or "Please enter your name"
6. Verify save is prevented
7. Verify error message is displayed below name field
8. Enter a valid name
9. Verify error message disappears
10. Verify save is allowed

**Expected Results**:
- ✅ Empty name is rejected
- ✅ Error message is clear
- ✅ Save is prevented for empty name
- ✅ Error clears when valid name is entered

---

## Test Case 7: Name Validation - Minimum Length

**Objective**: Verify validation enforces minimum name length.

**Preconditions**:
- User is logged in
- User is on Edit Profile page

**Steps**:
1. Navigate to Edit Profile page
2. Locate "Name" input field
3. Enter single character (e.g., "A")
4. Tap "Save" button
5. Verify error message appears: "Name must be at least 2 characters" or similar
6. Verify save is prevented
7. Enter valid name (e.g., "John Doe")
8. Verify error message disappears
9. Verify save is allowed

**Expected Results**:
- ✅ Name with less than minimum length is rejected
- ✅ Error message is clear
- ✅ Save is prevented for short name

---

## Test Case 8: Name Validation - Maximum Length

**Objective**: Verify validation enforces maximum name length.

**Preconditions**:
- User is logged in
- User is on Edit Profile page

**Steps**:
1. Navigate to Edit Profile page
2. Locate "Name" input field
3. Enter very long name (e.g., 100+ characters)
4. Tap "Save" button
5. Verify error message appears: "Name must be less than X characters" or similar
6. Verify save is prevented
7. Enter valid name within limit
8. Verify error message disappears
9. Verify save is allowed

**Expected Results**:
- ✅ Name exceeding maximum length is rejected
- ✅ Error message is clear
- ✅ Save is prevented for long name

---

## Test Case 9: Timezone Validation - Missing Feature

**Objective**: Verify timezone validation works (if implemented).

**Preconditions**:
- User is logged in
- User is on Edit Profile page
- Timezone validation feature is implemented

**Steps**:
1. Navigate to Edit Profile page
2. Locate "Timezone" field
3. Verify one of the following:
   - **If NOT implemented**: Timezone field is not available (this is expected)
   - **If implemented**: Timezone field is available
4. If implemented:
   - Try to set invalid timezone (if possible)
   - Verify error message appears for invalid timezone
   - Verify save is prevented
   - Select valid timezone
   - Verify error message disappears
   - Verify save is allowed

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Timezone validation is NOT available (missing)
- ✅ **When implemented**: Invalid timezone is rejected
- ✅ Error message is clear

---

## Test Case 10: Language Validation - Missing Feature

**Objective**: Verify language validation works (if implemented).

**Preconditions**:
- User is logged in
- User is on Edit Profile page
- Language validation feature is implemented

**Steps**:
1. Navigate to Edit Profile page
2. Locate "Language" field
3. Verify one of the following:
   - **If NOT implemented**: Language field is not available (this is expected)
   - **If implemented**: Language field is available
4. If implemented:
   - Try to set invalid language (if possible)
   - Verify error message appears for invalid language
   - Verify save is prevented
   - Select valid language
   - Verify error message disappears
   - Verify save is allowed

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Language validation is NOT available (missing)
- ✅ **When implemented**: Invalid language is rejected
- ✅ Error message is clear

---

## Test Case 11: Signature Validation - Maximum Length

**Objective**: Verify signature validation enforces maximum length (if implemented).

**Preconditions**:
- User is logged in
- User is on Edit Profile page
- Signature validation feature is implemented

**Steps**:
1. Navigate to Edit Profile page
2. Locate "Signature" field
3. Verify one of the following:
   - **If NOT implemented**: Signature field is not available (this is expected)
   - **If implemented**: Signature field is available
4. If implemented:
   - Enter very long signature (e.g., 500+ characters)
   - Tap "Save" button
   - Verify error message appears: "Signature must be less than X characters" or similar
   - Verify save is prevented
   - Enter valid signature within limit
   - Verify error message disappears
   - Verify save is allowed

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Signature validation is NOT available (missing)
- ✅ **When implemented**: Signature exceeding maximum length is rejected
- ✅ Error message is clear

---

## Test Case 12: Avatar Upload - Image Format Validation

**Objective**: Verify only valid image formats are accepted.

**Preconditions**:
- User is logged in
- User is on Edit Profile page
- Avatar upload feature is implemented

**Steps**:
1. Navigate to Edit Profile page
2. Tap on avatar or "Change Avatar" button
3. Try to select non-image file (if file picker allows):
   - PDF file
   - Text file
   - Video file
4. Verify one of the following:
   - File picker filters to images only
   - OR error message appears: "Please select a valid image file"
5. Select valid image file (JPG, PNG, etc.)
6. Verify image is accepted
7. Verify preview is shown
8. Save avatar
9. Verify avatar is uploaded successfully

**Expected Results**:
- ✅ Only image files are accepted
- ✅ Invalid file types are rejected
- ✅ Error message is clear (if applicable)

---

## Test Case 13: Avatar Upload - Image Size Validation

**Objective**: Verify image size validation works.

**Preconditions**:
- User is logged in
- User is on Edit Profile page
- Avatar upload feature is implemented

**Steps**:
1. Navigate to Edit Profile page
2. Tap on avatar or "Change Avatar" button
3. Try to select very large image file (e.g., 10MB+)
4. Verify one of the following:
   - Image is automatically compressed/resized
   - OR error message appears: "Image size must be less than X MB"
5. If error appears:
   - Verify save is prevented
   - Select smaller image
   - Verify image is accepted
6. Save avatar
7. Verify avatar is uploaded successfully

**Expected Results**:
- ✅ Large images are handled appropriately
- ✅ Image compression/resizing works (if implemented)
- ✅ Error message is clear (if size limit exists)

---

## Test Case 14: Profile Update - Multiple Fields at Once

**Objective**: Verify multiple profile fields can be updated simultaneously.

**Preconditions**:
- User is logged in
- User is on Edit Profile page
- Multiple profile fields are implemented

**Steps**:
1. Navigate to Edit Profile page
2. Update multiple fields:
   - Change name
   - Change avatar (if implemented)
   - Change timezone (if implemented)
   - Change language (if implemented)
   - Change signature (if implemented)
3. Tap "Save" button
4. Verify all changes are saved
5. Verify success message appears
6. Verify profile page shows all updated values
7. Verify all values are saved to Firebase
8. Restart app
9. Verify all values persist after restart

**Expected Results**:
- ✅ Multiple fields can be updated at once
- ✅ All changes are saved correctly
- ✅ All values persist after restart

---

## Test Case 15: Profile Update - Cancel Changes

**Objective**: Verify changes can be cancelled without saving.

**Preconditions**:
- User is logged in
- User is on Edit Profile page

**Steps**:
1. Navigate to Edit Profile page
2. Note current profile values
3. Make changes to profile:
   - Change name
   - Change avatar (if implemented)
   - Change other fields (if implemented)
4. Tap "Cancel" button
5. Verify Edit Profile screen closes
6. Verify profile page shows original values
7. Verify no changes are saved to Firebase
8. Verify no success message appears

**Expected Results**:
- ✅ Changes can be cancelled
- ✅ Original values are preserved
- ✅ No changes are saved when cancelled

---

## Test Case 16: Profile Display - Show All Fields

**Objective**: Verify all profile fields are displayed correctly.

**Preconditions**:
- User is logged in
- User has profile with all fields set
- Profile display feature is implemented

**Steps**:
1. Navigate to Profile page
2. Verify profile information is displayed:
   - Name
   - Avatar
   - Email
   - Timezone (if implemented)
   - Language (if implemented)
   - Signature (if implemented)
   - Other profile fields
3. Verify all values are displayed correctly
4. Verify formatting is appropriate
5. Verify layout is clean and readable

**Expected Results**:
- ✅ All profile fields are displayed
- ✅ Values are shown correctly
- ✅ Layout is clean and readable

---

## Test Case 17: Profile Persistence - Firebase Sync

**Objective**: Verify profile changes are synced to Firebase.

**Preconditions**:
- User is logged in
- User is on Edit Profile page
- Firebase sync is implemented

**Steps**:
1. Navigate to Edit Profile page
2. Update profile fields (name, avatar, timezone, language, signature)
3. Save changes
4. Verify changes are saved to Firebase:
   - Check Firebase database
   - Verify user document is updated
   - Verify all fields are stored correctly
5. Log out and log in again
6. Verify profile values are loaded from Firebase
7. Verify all values are correct

**Expected Results**:
- ✅ Profile changes are synced to Firebase
- ✅ All fields are stored correctly
- ✅ Values are loaded from Firebase after login

---

## Test Case 18: Profile Persistence - Local Storage

**Objective**: Verify profile is cached in local storage.

**Preconditions**:
- User is logged in
- User has updated profile
- Local storage caching is implemented

**Steps**:
1. Update profile
2. Save changes
3. Verify profile is saved to local storage:
   - Check SharedPreferences or local storage
   - Verify user data is cached
4. Go offline (disable network)
5. Restart app
6. Verify profile is loaded from local cache
7. Verify profile values are displayed correctly
8. Go online
9. Verify profile syncs with Firebase

**Expected Results**:
- ✅ Profile is cached in local storage
- ✅ Profile loads from cache when offline
- ✅ Profile syncs with Firebase when online

---

## Test Case 19: Edit Profile UI - Missing Feature

**Objective**: Verify Edit Profile UI exists and works correctly.

**Preconditions**:
- User is logged in
- User is on Profile page

**Steps**:
1. Navigate to Profile page
2. Locate "Edit Profile" option
3. Verify one of the following:
   - **If NOT implemented**: "Edit Profile" shows "Coming soon" message (this is expected - feature missing)
   - **If implemented**: "Edit Profile" navigates to Edit Profile screen
4. If implemented:
   - Tap "Edit Profile"
   - Verify Edit Profile screen appears
   - Verify all profile fields are available:
     - Name field
     - Avatar upload
     - Timezone dropdown (if implemented)
     - Language dropdown (if implemented)
     - Signature field (if implemented)
   - Verify form validation works
   - Verify Save and Cancel buttons are available
   - Verify UI follows project rules (TD widgets, AppStrings)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Edit Profile UI is NOT fully available (shows "Coming soon")
- ✅ **When implemented**: Edit Profile UI exists
- ✅ All profile fields are available
- ✅ UI follows project rules

---

## Test Case 20: Profile Update - Error Handling

**Objective**: Verify error handling works correctly.

**Preconditions**:
- User is logged in
- User is on Edit Profile page

**Steps**:
1. Navigate to Edit Profile page
2. Make changes to profile
3. Go offline (disable network)
4. Tap "Save" button
5. Verify error message appears: "Failed to update profile" or "Network error" or similar
6. Verify changes are not saved
7. Go online
8. Save changes again
9. Verify changes are saved successfully
10. Test other error scenarios:
    - Invalid Firebase permissions
    - Storage quota exceeded (for avatar)
    - Server error
11. Verify appropriate error messages are shown

**Expected Results**:
- ✅ Error handling works correctly
- ✅ Error messages are clear
- ✅ Changes are not saved on error
- ✅ User can retry after error

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] User name can be updated
- [ ] User avatar can be updated
- [ ] User timezone can be updated (if implemented)
- [ ] User language can be updated (if implemented)
- [ ] User signature can be updated (if implemented)
- [ ] Name validation works correctly
- [ ] Timezone validation works (if implemented)
- [ ] Language validation works (if implemented)
- [ ] Signature validation works (if implemented)
- [ ] Avatar upload validation works
- [ ] Multiple fields can be updated at once
- [ ] Changes can be cancelled
- [ ] Profile fields are displayed correctly
- [ ] Profile syncs to Firebase
- [ ] Profile is cached in local storage
- [ ] Edit Profile UI exists (if implemented)
- [ ] Error handling works correctly

---

## Known Issues (Based on Audit Report)

1. **Timezone/Language/Signature Missing**:
   - `User` entity has `preferences` but no specific timezone/language/signature fields
   - No handling for timezone/language/signature in `updateUserProfile`
   - **Status**: ⛔ Missing

2. **No Validation**:
   - No validation for timezone/language/signature
   - **Status**: ⛔ Missing

3. **No Persistence**:
   - Timezone/language/signature are not persisted to Firebase
   - **Status**: ⛔ Missing

4. **No UI**:
   - Edit Profile shows "Coming soon" message
   - No UI for editing timezone/language/signature
   - **Status**: ⛔ Missing

---

## Notes for Testers

1. **Current Status**: Only name and avatar updates work. Timezone, language, and signature are completely missing.

2. **Edit Profile**: Currently shows "Coming soon" message. Full Edit Profile UI needs to be implemented.

3. **Preferences Field**: `User` entity has `preferences` Map but it's not structured for timezone/language/signature. These need to be added as specific fields or structured within preferences.

4. **Workspace vs User Settings**: Workspace settings have timezone/language, but these are workspace-level, not user-level. User profile should have its own timezone/language preferences.

5. **Validation**: All profile fields should have appropriate validation (required, length limits, format, etc.).

6. **Persistence**: Profile changes should be saved to both Firebase and local storage for offline support.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- User account used
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase data (if accessible) showing user profile
- Network conditions (online/offline)

