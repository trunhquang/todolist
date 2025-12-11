# User Profile (Name, Avatar, Timezone, Language, Signature) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **User Profile** feature (name, avatar, timezone, language, signature). Currently, this feature is **PARTIAL** - name and avatar updates work, but timezone/language/signature handling, validation, and persistence are missing, and there's no UI for profile edit beyond name/avatar.

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `AuthController.updateUserProfile` - updates name and avatar
- ✅ `User` entity has `preferences` field (Map<String, dynamic>?)
- ✅ Profile page exists (shows name, avatar, email, role, etc.)
- ✅ Name and avatar can be updated via `updateUserProfile`

### What's Missing/Broken:
- ⚠️ `User` entity has `preferences` but no specific timezone/language/signature fields
- ⛔ No timezone/language/signature handling in `updateUserProfile`
- ⛔ No validation for timezone/language/signature
- ⛔ No persistence of timezone/language/signature to Firebase
- ⛔ No UI for editing timezone/language/signature
- ⛔ Edit Profile shows "Coming soon" message

---

## Task List

### Task 1: Add Timezone/Language/Signature Fields to User Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add timezone, language, and signature fields to `User` entity (either as direct fields or structured within preferences).

**Files to Modify**:
- `lib/features/auth/domain/entities/user.dart`

**Implementation Steps**:
1. **Option A - Direct Fields** (Recommended):
   ```dart
   final String? timezone;
   final String? language;
   final String? signature;
   ```
   - Add to constructor
   - Add to `fromMap` method
   - Add to `toMap` method
   - Add to `copyWith` method

2. **Option B - Structured Preferences**:
   - Keep `preferences` Map but structure it:
   ```dart
   Map<String, dynamic>? get userPreferences => preferences?['user'] as Map<String, dynamic>?;
   String? get timezone => userPreferences?['timezone'] as String?;
   String? get language => userPreferences?['language'] as String?;
   String? get signature => userPreferences?['signature'] as String?;
   ```
   - Add helper methods to get/set these values

3. Add default values:
   - Timezone: System timezone or 'UTC'
   - Language: App default language or 'en'
   - Signature: null (optional)

4. Update equality and hashCode to include new fields

**Expected Results**:
- ✅ User entity has timezone/language/signature fields
- ✅ Fields are serialized correctly
- ✅ Backward compatibility is maintained

**Test Criteria**:
- Unit test: Test entity creation with timezone/language/signature
- Test: Verify serialization works correctly
- Test: Verify backward compatibility (existing users without these fields)

---

### Task 2: Create User Preferences Helper Class

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create a helper class to manage user preferences (timezone, language, signature) with validation and constants.

**Files to Create**:
- `lib/features/auth/domain/entities/user_preferences.dart` (new file)

**Implementation Steps**:
1. Create `UserPreferences` class:
   ```dart
   class UserPreferences {
     final String? timezone;
     final String? language;
     final String? signature;
     
     const UserPreferences({
       this.timezone,
       this.language,
       this.signature,
     });
     
     factory UserPreferences.fromMap(Map<String, dynamic>? map) {
       if (map == null) return const UserPreferences();
       return UserPreferences(
         timezone: map['timezone']?.toString(),
         language: map['language']?.toString(),
         signature: map['signature']?.toString(),
       );
     }
     
     Map<String, dynamic> toMap() {
       return {
         if (timezone != null) 'timezone': timezone,
         if (language != null) 'language': language,
         if (signature != null) 'signature': signature,
       };
     }
   }
   ```

2. Add constants for available values:
   ```dart
   class UserTimezones {
     static const List<String> available = [
       'UTC', 'UTC+1', 'UTC+2', ... // Similar to WorkspaceTimezones
     ];
   }
   
   class UserLanguages {
     static const List<String> available = [
       'en', 'vi', 'es', 'fr', 'de', 'ja', 'ko', 'zh'
     ];
     
     static String getDisplayName(String code) {
       // Similar to WorkspaceLanguages.getDisplayName
     }
   }
   ```

3. Add validation methods:
   ```dart
   static String? validateTimezone(String? timezone) {
     if (timezone == null || timezone.isEmpty) return null; // Optional
     if (!UserTimezones.available.contains(timezone)) {
       return 'Invalid timezone';
     }
     return null;
   }
   
   static String? validateLanguage(String? language) {
     if (language == null || language.isEmpty) return null; // Optional
     if (!UserLanguages.available.contains(language)) {
       return 'Invalid language';
     }
     return null;
   }
   
   static String? validateSignature(String? signature) {
     if (signature == null) return null; // Optional
     if (signature.length > 500) {
       return 'Signature must be less than 500 characters';
     }
     return null;
   }
   ```

**Expected Results**:
- ✅ UserPreferences helper class exists
- ✅ Constants for timezones/languages are defined
- ✅ Validation methods exist

**Test Criteria**:
- Unit test: Test UserPreferences creation and serialization
- Test: Verify validation methods work correctly

---

### Task 3: Update AuthController.updateUserProfile to Support Timezone/Language/Signature

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Extend `updateUserProfile` method to handle timezone, language, and signature updates.

**Files to Modify**:
- `lib/features/auth/presentation/controllers/auth_controller.dart`

**Implementation Steps**:
1. Update `updateUserProfile` method signature:
   ```dart
   Future<void> updateUserProfile({
     String? name,
     String? profileImageUrl,
     String? timezone,
     String? language,
     String? signature,
   }) async {
     // Implementation
   }
   ```

2. Add validation:
   ```dart
   // Validate timezone
   if (timezone != null) {
     final timezoneError = UserPreferences.validateTimezone(timezone);
     if (timezoneError != null) {
       throw ValidationFailure(message: timezoneError);
     }
   }
   
   // Validate language
   if (language != null) {
     final languageError = UserPreferences.validateLanguage(language);
     if (languageError != null) {
       throw ValidationFailure(message: languageError);
     }
   }
   
   // Validate signature
   if (signature != null) {
     final signatureError = UserPreferences.validateSignature(signature);
     if (signatureError != null) {
       throw ValidationFailure(message: signatureError);
     }
   }
   ```

3. Update local user data:
   ```dart
   final updatedUser = _currentUser.value!.copyWith(
     name: name,
     profileImageUrl: profileImageUrl,
     timezone: timezone,
     language: language,
     signature: signature,
   );
   ```

4. Persist to Firebase:
   ```dart
   // Update in Firebase database
   await _databaseService.updateUser(updatedUser);
   ```

5. Save to local storage:
   ```dart
   await _storageService.setUserData('current_user', updatedUser.toMap());
   ```

6. Update Firebase Auth (for name/avatar only - timezone/language/signature don't go to Auth)

**Expected Results**:
- ✅ updateUserProfile supports timezone/language/signature
- ✅ Validation is enforced
- ✅ Changes are persisted to Firebase
- ✅ Changes are saved to local storage

**Test Criteria**:
- Unit test: Test updateUserProfile with timezone/language/signature
- Test: Verify validation works
- Test: Verify persistence works

---

### Task 4: Update FirebaseDatabaseService to Persist User Preferences

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Ensure `FirebaseDatabaseService.updateUser` persists timezone/language/signature to Firebase.

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`

**Implementation Steps**:
1. Review `updateUser` method:
   ```dart
   Future<void> updateUser(User user) async {
     try {
       await _usersRef.child(user.id).update({
         'name': user.name,
         'profileImageUrl': user.profileImageUrl,
         'timezone': user.timezone,
         'language': user.language,
         'signature': user.signature,
         // ... other fields
       });
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to update user: $e');
     }
   }
   ```

2. Ensure all new fields are included in update
3. Handle null values appropriately (Firebase doesn't store null, use remove or omit)
4. Test Firebase persistence

**Expected Results**:
- ✅ User preferences are persisted to Firebase
- ✅ All fields are stored correctly
- ✅ Null values are handled appropriately

**Test Criteria**:
- Integration test: Test Firebase persistence
- Test: Verify fields are stored correctly
- Test: Verify null values are handled

---

### Task 5: Create Edit Profile Page

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create Edit Profile page with form for editing name, avatar, timezone, language, and signature.

**Files to Create**:
- `lib/app/pages/profile/edit_profile_page.dart` (new file)
- `lib/app/pages/profile/edit_profile_controller.dart` (new file)

**Implementation Steps**:
1. Create `EditProfileController`:
   ```dart
   class EditProfileController extends GetxController {
     final AuthController _authController = Get.find<AuthController>();
     
     final formKey = GlobalKey<FormState>();
     final nameController = TextEditingController();
     final signatureController = TextEditingController();
     
     final RxString? selectedTimezone = Rxn<String>();
     final RxString? selectedLanguage = Rxn<String>();
     final Rxn<String> selectedAvatarUrl = Rxn<String>();
     final RxBool isLoading = false.obs;
     
     @override
     void onInit() {
       super.onInit();
       _loadUserData();
     }
     
     void _loadUserData() {
       final user = _authController.currentUser;
       if (user != null) {
         nameController.text = user.name;
         signatureController.text = user.signature ?? '';
         selectedTimezone.value = user.timezone;
         selectedLanguage.value = user.language;
         selectedAvatarUrl.value = user.profileImageUrl;
       }
     }
     
     Future<void> handleSave() async {
       if (formKey.currentState!.validate()) {
         isLoading.value = true;
         try {
           await _authController.updateUserProfile(
             name: nameController.text.trim(),
             profileImageUrl: selectedAvatarUrl.value,
             timezone: selectedTimezone.value,
             language: selectedLanguage.value,
             signature: signatureController.text.trim().isEmpty 
                 ? null 
                 : signatureController.text.trim(),
           );
           NavigationService().back<void>();
         } finally {
           isLoading.value = false;
         }
       }
     }
     
     Future<void> handleAvatarSelection() async {
       // Implement image picker
     }
     
     @override
     void onClose() {
       nameController.dispose();
       signatureController.dispose();
       super.onClose();
     }
   }
   ```

2. Create `EditProfilePage`:
   - Use TD widgets (TDTextField, TDButton, etc.)
   - Use AppStrings for all text
   - Use GetX pattern (StatelessWidget with GetBuilder/Obx)
   - Form with validation
   - Sections:
     - Basic Information (Name, Avatar)
     - Preferences (Timezone, Language)
     - Signature
   - Save and Cancel buttons

3. Add route to AppRouter

**Expected Results**:
- ✅ Edit Profile page exists
- ✅ All profile fields are available
- ✅ Form validation works
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Edit profile, verify UI works
- Test: Verify form validation works
- Test: Verify save/cancel works

---

### Task 6: Update ProfilePage to Navigate to Edit Profile

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Update ProfilePage to navigate to Edit Profile page instead of showing "Coming soon" message.

**Files to Modify**:
- `lib/app/pages/profile/profile_page.dart`

**Implementation Steps**:
1. Update "Edit Profile" ListTile:
   ```dart
   _ListTile(
     icon: Icons.edit_outlined,
     title: AppStrings.editProfile,
     onTap: () async {
       await NavigationService().toNamed<void>(AppRouter.editProfile);
     },
   ),
   ```

2. Remove "Coming soon" snackbar
3. Ensure navigation works correctly

**Expected Results**:
- ✅ Edit Profile navigation works
- ✅ No "Coming soon" message
- ✅ Navigation is smooth

**Test Criteria**:
- Manual test: Tap Edit Profile, verify navigation works

---

### Task 7: Add Avatar Upload Functionality

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Implement avatar upload with image picker and storage.

**Files to Modify**:
- `lib/app/pages/profile/edit_profile_controller.dart`
- `lib/core/services/storage_service.dart` (if needed)

**Implementation Steps**:
1. Add image_picker dependency (if not already added):
   ```yaml
   image_picker: ^1.0.0
   ```

2. Implement image picker in controller:
   ```dart
   Future<void> handleAvatarSelection() async {
     try {
       final ImagePicker picker = ImagePicker();
       final XFile? image = await picker.pickImage(
         source: ImageSource.gallery,
         maxWidth: 512,
         maxHeight: 512,
         imageQuality: 85,
       );
       
       if (image != null) {
         // Upload to Firebase Storage
         final url = await _uploadImageToStorage(image);
         selectedAvatarUrl.value = url;
       }
     } catch (e) {
       SnackbarService().showError(
         title: AppStrings.error,
         message: 'Failed to select image: $e',
       );
     }
   }
   
   Future<String> _uploadImageToStorage(XFile image) async {
     // Implement Firebase Storage upload
     // Return download URL
   }
   ```

3. Add image validation:
   - Check file size (e.g., max 5MB)
   - Check file format (JPG, PNG)
   - Compress/resize if needed

4. Show image preview in UI

**Expected Results**:
- ✅ Avatar can be selected from gallery
- ✅ Image is uploaded to storage
- ✅ Avatar URL is saved
- ✅ Image validation works

**Test Criteria**:
- Test: Select image, verify upload works
- Test: Verify image validation works
- Test: Verify large images are handled

---

### Task 8: Add Timezone/Language Dropdowns to Edit Profile

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add timezone and language dropdowns to Edit Profile page.

**Files to Modify**:
- `lib/app/pages/profile/edit_profile_page.dart`

**Implementation Steps**:
1. Add timezone dropdown:
   ```dart
   DropdownButtonFormField<String>(
     value: controller.selectedTimezone.value,
     decoration: InputDecoration(
       labelText: AppStrings.timezone,
       prefixIcon: Icon(Icons.access_time),
     ),
     items: UserTimezones.available.map((tz) {
       return DropdownMenuItem(
         value: tz,
         child: Text(tz),
       );
     }).toList(),
     onChanged: (value) {
       controller.selectedTimezone.value = value;
     },
     validator: (value) {
       return UserPreferences.validateTimezone(value);
     },
   ),
   ```

2. Add language dropdown:
   ```dart
   DropdownButtonFormField<String>(
     value: controller.selectedLanguage.value,
     decoration: InputDecoration(
       labelText: AppStrings.language,
       prefixIcon: Icon(Icons.language),
     ),
     items: UserLanguages.available.map((lang) {
       return DropdownMenuItem(
         value: lang,
         child: Text(UserLanguages.getDisplayName(lang)),
       );
     }).toList(),
     onChanged: (value) {
       controller.selectedLanguage.value = value;
     },
     validator: (value) {
       return UserPreferences.validateLanguage(value);
     },
   ),
   ```

3. Use TD widgets if available, or create custom dropdowns following project style

**Expected Results**:
- ✅ Timezone dropdown exists
- ✅ Language dropdown exists
- ✅ Dropdowns work correctly
- ✅ Validation works

**Test Criteria**:
- Manual test: Select timezone/language, verify it works
- Test: Verify validation works

---

### Task 9: Add Signature Field to Edit Profile

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add signature text field to Edit Profile page.

**Files to Modify**:
- `lib/app/pages/profile/edit_profile_page.dart`

**Implementation Steps**:
1. Add signature text field:
   ```dart
   TDTextField(
     controller: controller.signatureController,
     label: AppStrings.signature,
     hint: AppStrings.enterSignature,
     prefixIcon: Icons.edit_note,
     maxLines: 3,
     validator: (value) {
       return UserPreferences.validateSignature(value);
     },
   ),
   ```

2. Add character count (optional):
   - Show remaining characters (e.g., "250/500 characters")
   - Update in real-time

3. Add helpful hint (optional):
   - Explain what signature is used for

**Expected Results**:
- ✅ Signature field exists
- ✅ Validation works
- ✅ Character limit is enforced

**Test Criteria**:
- Test: Enter signature, verify it works
- Test: Verify validation works

---

### Task 10: Display Timezone/Language/Signature in Profile Page

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Display timezone, language, and signature in Profile page (if they should be visible).

**Files to Modify**:
- `lib/app/pages/profile/profile_page.dart`

**Implementation Steps**:
1. Update `_buildUserProfileCard` to show preferences:
   ```dart
   if (user.timezone != null)
     _buildInfoRow(AppStrings.timezone, user.timezone!),
   if (user.language != null)
     _buildInfoRow(AppStrings.language, UserLanguages.getDisplayName(user.language!)),
   if (user.signature != null)
     _buildInfoRow(AppStrings.signature, user.signature!),
   ```

2. Consider layout:
   - Show in additional info section
   - Or show in separate section
   - Format appropriately

**Expected Results**:
- ✅ Timezone is displayed (if set)
- ✅ Language is displayed (if set)
- ✅ Signature is displayed (if set)
- ✅ Layout is clean

**Test Criteria**:
- Manual test: Verify preferences are displayed
- Test: Verify formatting is correct

**Note**: This is optional - preferences may be private and not displayed.

---

### Task 11: Add AppStrings for Profile Fields

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add AppStrings constants for timezone, language, signature, and related messages.

**Files to Modify**:
- `lib/core/constants/app_strings.dart`

**Implementation Steps**:
1. Add profile-related strings:
   ```dart
   static const String timezone = 'Timezone';
   static const String language = 'Language';
   static const String signature = 'Signature';
   static const String enterSignature = 'Enter your signature';
   static const String profileUpdatedSuccessfully = 'Profile updated successfully';
   static const String failedToUpdateProfile = 'Failed to update profile';
   static const String selectImage = 'Select Image';
   static const String changeAvatar = 'Change Avatar';
   // ... other strings
   ```

2. Ensure all user-facing text uses AppStrings

**Expected Results**:
- ✅ All profile strings are in AppStrings
- ✅ No hardcoded strings in UI

**Test Criteria**:
- Test: Verify all strings use AppStrings
- Test: Verify no hardcoded strings

---

### Task 12: Add Unit Tests for Profile Updates

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for profile update functionality.

**Files to Create/Modify**:
- `test/features/auth/presentation/controllers/auth_controller_test.dart`
- `test/features/auth/domain/entities/user_test.dart`
- `test/app/pages/profile/edit_profile_controller_test.dart`

**Implementation Steps**:
1. Test `updateUserProfile`:
   - Test with name only
   - Test with avatar only
   - Test with timezone/language/signature
   - Test with all fields
   - Test validation
   - Test error handling

2. Test User entity:
   - Test with timezone/language/signature
   - Test serialization
   - Test backward compatibility

3. Test EditProfileController:
   - Test form validation
   - Test save functionality
   - Test cancel functionality
   - Test avatar selection

4. Test UserPreferences:
   - Test validation methods
   - Test constants

**Expected Results**:
- ✅ Unit tests cover profile updates
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Add Timezone/Language/Signature Fields to User Entity (Critical - Foundation)
2. **Task 2**: Create User Preferences Helper Class (High Priority - Utilities)
3. **Task 3**: Update AuthController.updateUserProfile (High Priority - Core Feature)
4. **Task 4**: Update FirebaseDatabaseService (High Priority - Data Layer)
5. **Task 5**: Create Edit Profile Page (High Priority - UI)
6. **Task 6**: Update ProfilePage Navigation (Medium Priority - Integration)
7. **Task 8**: Add Timezone/Language Dropdowns (High Priority - UI)
8. **Task 9**: Add Signature Field (Medium Priority - UI)
9. **Task 7**: Add Avatar Upload Functionality (Medium Priority - Feature Completeness)
10. **Task 11**: Add AppStrings (Medium Priority - Code Quality)
11. **Task 10**: Display Preferences in Profile (Low Priority - UX Enhancement)
12. **Task 12**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ User entity has timezone/language/signature fields
- ✅ UserPreferences helper class exists
- ✅ updateUserProfile supports all fields
- ✅ Validation works for all fields
- ✅ All fields are persisted to Firebase
- ✅ Edit Profile page exists with all fields
- ✅ Profile page navigates to Edit Profile
- ✅ Avatar upload works
- ✅ Timezone/language dropdowns work
- ✅ Signature field works
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ No known bugs or issues

---

## Dependencies

- **AuthController**: Must support profile updates
- **FirebaseDatabaseService**: Must persist user preferences
- **Firebase Storage**: Required for avatar upload
- **image_picker**: Required for avatar selection
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications

---

## Notes

1. **Preferences Structure**: Decide whether to use direct fields or structured preferences. Direct fields are simpler but may require migration for existing users.

2. **Default Values**: Consider default timezone (system timezone) and language (app default) for new users.

3. **Optional Fields**: Timezone, language, and signature should be optional (nullable) to maintain backward compatibility.

4. **Validation**: All fields should have appropriate validation (required for name, optional for others, length limits, format checks).

5. **Persistence**: Profile changes should be saved to both Firebase and local storage for offline support.

6. **Avatar Storage**: Avatar should be uploaded to Firebase Storage, and URL should be stored in user document.

7. **Workspace vs User Settings**: Workspace settings have timezone/language, but these are workspace-level. User profile should have its own preferences that may override workspace settings (if implemented).

8. **Localization**: If language is changed, consider updating app localization immediately (if app supports it).

---

## Related Documentation

- `USER_MANAGEMENT_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `USER_PROFILE_TEST_CASES.md` - Test cases for this feature
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/CODING_STANDARDS.md` - Coding standards

