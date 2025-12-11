# Workspace Settings - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Workspace Settings** feature (logo, primary color, timezone, language, date/time format, currency, theme, notifications). Currently, this feature is **PARTIAL** - most settings work, but primary color is missing, validation needs improvement, and StatefulWidget needs to be refactored.

## Current Status: ⚠️ PARTIAL

### What Works:
- ✅ Logo URL setting (can update)
- ✅ Description setting (can update)
- ✅ Timezone setting (can change via dropdown)
- ✅ Language setting (can change via dropdown)
- ✅ Date format setting (can change)
- ✅ Time format setting (can change between 12h/24h)
- ✅ Currency setting (can change via dropdown)
- ✅ Theme setting (can change between Light/Dark/System)
- ✅ Notifications toggle (can toggle)
- ✅ Auto Save toggle (can toggle)
- ✅ Settings are saved to Firebase
- ✅ Settings persist after app restart

### What's Missing/Broken:
- ⚠️ Primary color/màu nhận diện support
- ⚠️ Timezone/language validation not enforced before save
- ⚠️ StatefulWidget breaks project rule (requires GetX + StatelessWidget)
- ⚠️ No server-side persistence for color (when implemented)

---

## Task List

### Task 1: Add Primary Color/Brand Color Support to WorkspaceSettings Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add primary color/brand color (màu nhận diện) field to `WorkspaceSettings` entity to support workspace branding.

**Files to Modify**:
- `lib/features/workspace/domain/entities/workspace_settings.dart`

**Implementation Steps**:
1. Add `primaryColor` field to `WorkspaceSettings` class (String? for hex color code)
2. Update `fromMap` factory to read `primaryColor` from map
3. Update `toMap` method to include `primaryColor` in map
4. Update `copyWith` method to support `primaryColor` parameter
5. Update equality operator and hashCode to include `primaryColor`
6. Add validation helper method for color format (hex validation)

**Expected Results**:
- ✅ `WorkspaceSettings` entity includes `primaryColor` field
- ✅ Color can be stored as hex string (e.g., "#FF5733" or "FF5733")
- ✅ Color is nullable (optional field)
- ✅ Color is included in map serialization/deserialization
- ✅ Color validation helper exists

**Test Criteria**:
- Unit tests for `WorkspaceSettings` with `primaryColor`
- Test color serialization/deserialization
- Test color validation

---

### Task 2: Add Primary Color Picker UI to WorkspaceSettingsPage

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add color picker UI component to allow users to select primary color/brand color for workspace in Appearance section.

**Files to Modify**:
- `lib/features/workspace/presentation/pages/workspace_settings_page.dart`
- `lib/core/widgets/td_color_picker.dart` (new file - create custom color picker widget)

**Implementation Steps**:
1. Create `TDColorPicker` widget (custom color picker following TD widget patterns)
2. Add color picker to Appearance section in WorkspaceSettingsPage
3. Display current primary color (if set) with color preview
4. Allow user to select color from predefined palette
5. Allow user to enter custom hex color code
6. Show color preview in UI
7. Validate color format before save
8. Update `_currentSettings` when color is selected

**Expected Results**:
- ✅ Color picker UI is available in Appearance section
- ✅ Users can select color from predefined palette
- ✅ Users can enter custom hex color code
- ✅ Color preview is displayed
- ✅ Invalid colors are rejected with error message
- ✅ Color picker follows TD widget design patterns

**Test Criteria**:
- Widget test for `TDColorPicker`
- Manual test: Select color, verify preview, save, verify persistence

---

### Task 3: Implement Primary Color Persistence in Backend

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Ensure primary color is persisted to Firebase Realtime Database when workspace settings are updated.

**Files to Modify**:
- `lib/features/workspace/data/datasources/workspace_remote_data_source.dart`
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`

**Implementation Steps**:
1. Update `updateWorkspace` in `WorkspaceRemoteDataSourceImpl` to include `primaryColor` in settings update
2. Ensure `primaryColor` is read from Firebase when loading workspace settings
3. Verify settings map includes `primaryColor` when saving
4. Test persistence across app restarts

**Expected Results**:
- ✅ Primary color is saved to Firebase when workspace settings are updated
- ✅ Primary color is loaded from Firebase when workspace is fetched
- ✅ Primary color persists across app restarts
- ✅ Primary color is synced across devices

**Test Criteria**:
- Integration test: Update workspace settings with color, verify Firebase has color
- Manual test: Update color, restart app, verify color persists

---

### Task 4: Enforce Timezone/Language Validation Before Save

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Enforce validation for timezone and language settings before saving workspace settings.

**Files to Modify**:
- `lib/features/workspace/presentation/pages/workspace_settings_page.dart`
- `lib/features/workspace/domain/services/workspace_validator.dart`

**Implementation Steps**:
1. Review `WorkspaceValidator.validateWorkspaceSettings` (already exists)
2. Call validation in `_handleSaveSettings` before saving
3. Display validation errors in UI if validation fails
4. Prevent save if validation fails
5. Show error messages for invalid timezone/language values
6. Validate all settings fields (timezone, language, date format, time format, currency, theme)

**Expected Results**:
- ✅ Invalid timezone values are rejected
- ✅ Invalid language values are rejected
- ✅ Invalid date/time format values are rejected
- ✅ Invalid currency values are rejected
- ✅ Invalid theme values are rejected
- ✅ Validation errors are displayed to user
- ✅ Save is prevented if validation fails

**Test Criteria**:
- Unit tests for validation
- Manual test: Try to save with invalid values, verify error

---

### Task 5: Refactor WorkspaceSettingsPage to Use GetX + StatelessWidget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Replace StatefulWidget with GetX controller + StatelessWidget to comply with project rules.

**Files to Modify**:
- `lib/features/workspace/presentation/pages/workspace_settings_page.dart`
- Create: `lib/features/workspace/presentation/controllers/workspace_settings_controller.dart` (if needed)

**Implementation Steps**:
1. Create `WorkspaceSettingsController` extending `GetxController` (if not exists)
2. Move all state management from StatefulWidget to controller:
   - Form controllers (description, logoUrl)
   - Settings state (timezone, language, dateFormat, timeFormat, currency, theme, notifications, autoSave, primaryColor)
   - Loading state
   - Validation state
3. Convert `WorkspaceSettingsPage` from StatefulWidget to StatelessWidget
4. Use `GetBuilder` or `Obx` for reactive UI updates
5. Remove `setState` calls
6. Use `Get.find<WorkspaceSettingsController>()` or `Get.put()` for dependency injection
7. Initialize controller with workspace data

**Expected Results**:
- ✅ WorkspaceSettingsPage is StatelessWidget
- ✅ All state is managed by GetX controller
- ✅ Page follows GetX patterns (GetBuilder/Obx)
- ✅ No StatefulWidget violations
- ✅ Code follows project architecture rules
- ✅ Reactive updates work correctly

**Test Criteria**:
- Verify page functionality works identically
- Verify reactive updates work (Obx/GetBuilder)
- Code review: No StatefulWidget, follows GetX patterns

---

### Task 6: Add Logo URL Validation

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add validation for logo URL format before saving workspace settings.

**Files to Modify**:
- `lib/features/workspace/presentation/pages/workspace_settings_page.dart`
- `lib/features/workspace/domain/services/workspace_validator.dart` (validation already exists)

**Implementation Steps**:
1. Review `WorkspaceValidator.validateLogoUrl` (already exists)
2. Add validator to Logo URL field in WorkspaceSettingsPage
3. Display validation error below field if URL is invalid
4. Prevent save if URL format is invalid
5. Show clear error message for invalid URLs

**Expected Results**:
- ✅ Invalid URL formats are rejected
- ✅ Only HTTP/HTTPS URLs are accepted
- ✅ Error message is displayed for invalid URLs
- ✅ Valid URLs are accepted and saved

**Test Criteria**:
- Manual test: Enter invalid URL, verify error message
- Manual test: Enter valid URL, verify save succeeds

---

### Task 7: Apply Primary Color to Workspace UI Elements

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Apply primary color to workspace-specific UI elements (workspace selector, workspace header, etc.).

**Files to Modify**:
- `lib/features/workspace/presentation/widgets/workspace_selector.dart`
- `lib/app/pages/home/dashboard_page.dart` (workspace header)
- `lib/app/theme/app_colors.dart` (if workspace-specific theme needed)

**Implementation Steps**:
1. Read primary color from current workspace settings
2. Apply color to workspace-specific UI elements:
   - Workspace selector highlight
   - Workspace header/name display
   - Workspace icon/avatar background
3. Use workspace color if set, fallback to app primary color if not set
4. Ensure color contrast meets accessibility standards
5. Update UI when workspace is switched

**Expected Results**:
- ✅ Workspace primary color is applied to workspace UI elements
- ✅ Color is visible in workspace selector
- ✅ Color is visible in workspace header
- ✅ Fallback to app primary color if workspace color not set
- ✅ Color contrast is accessible
- ✅ UI updates when workspace changes

**Test Criteria**:
- Manual test: Set workspace color, verify UI elements use the color
- Visual test: Verify color application looks correct
- Test workspace switching: Verify color updates correctly

---

### Task 8: Add Settings Validation Summary

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Show validation summary before save to help users identify all validation errors at once.

**Files to Modify**:
- `lib/features/workspace/presentation/pages/workspace_settings_page.dart`

**Implementation Steps**:
1. Collect all validation errors before save
2. Display validation summary dialog or banner
3. List all validation errors
4. Allow user to fix errors and retry
5. Only save if all validations pass

**Expected Results**:
- ✅ All validation errors are shown together
- ✅ User can see all issues at once
- ✅ Save is prevented until all errors are fixed

**Test Criteria**:
- Manual test: Enter multiple invalid values, verify all errors are shown

---

### Task 9: Add Unit Tests for Workspace Settings

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for workspace settings functionality.

**Files to Create/Modify**:
- `test/features/workspace/domain/entities/workspace_settings_test.dart`
- `test/features/workspace/presentation/controllers/workspace_settings_controller_test.dart` (if created)
- `test/features/workspace/presentation/pages/workspace_settings_page_test.dart`
- `test/features/workspace/domain/services/workspace_validator_test.dart`

**Implementation Steps**:
1. Test `WorkspaceSettings` entity:
   - Test serialization/deserialization
   - Test copyWith with all fields including primaryColor
   - Test validation
2. Test `WorkspaceSettingsController` (if created):
   - Test state management
   - Test save functionality
   - Test validation
3. Test `WorkspaceSettingsPage`:
   - Test UI rendering
   - Test user interactions
   - Test form validation
4. Test `WorkspaceValidator`:
   - Test all validation methods
   - Test edge cases

**Expected Results**:
- ✅ Unit tests cover workspace settings functionality
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass
- ✅ Edge cases are covered

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

### Task 10: Add Integration Tests for Workspace Settings

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Write integration tests for complete workspace settings flow including Firebase persistence.

**Files to Create**:
- `test/features/workspace/integration/workspace_settings_integration_test.dart`

**Implementation Steps**:
1. Test complete flow: Load workspace → Update settings → Save → Verify
2. Test with Firebase emulator or test environment
3. Test all setting types (timezone, language, currency, etc.)
4. Test validation
5. Test persistence after app restart
6. Test error scenarios

**Expected Results**:
- ✅ Integration tests cover complete settings flow
- ✅ Tests verify Firebase persistence
- ✅ All integration tests pass

**Test Criteria**:
- Run integration tests
- Verify tests pass with Firebase emulator

---

### Task 11: Improve Settings UI/UX

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Improve UI/UX for workspace settings page (better organization, previews, etc.).

**Files to Modify**:
- `lib/features/workspace/presentation/pages/workspace_settings_page.dart`

**Implementation Steps**:
1. Add preview for date/time format changes
2. Add preview for theme changes
3. Add logo preview if URL is provided
4. Improve section organization
5. Add help text/tooltips for settings
6. Add reset to defaults option

**Expected Results**:
- ✅ Settings page is more user-friendly
- ✅ Previews help users understand changes
- ✅ Better organization and clarity

**Test Criteria**:
- Manual test: Verify UI improvements
- User feedback on usability

---

## Implementation Priority Order

1. **Task 1**: Add Primary Color to WorkspaceSettings Entity (Foundation)
2. **Task 5**: Refactor to GetX + StatelessWidget (Architecture Compliance - High Priority)
3. **Task 3**: Implement Primary Color Persistence (Core Functionality)
4. **Task 2**: Add Primary Color Picker UI (User-Facing Feature)
5. **Task 4**: Enforce Timezone/Language Validation (Quality Improvement)
6. **Task 6**: Add Logo URL Validation (Quality Improvement)
7. **Task 7**: Apply Primary Color to UI (Visual Enhancement)
8. **Task 9**: Add Unit Tests (Quality Assurance)
9. **Task 8**: Add Settings Validation Summary (Nice to have)
10. **Task 10**: Add Integration Tests (Nice to have)
11. **Task 11**: Improve Settings UI/UX (Nice to have)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Users can update all workspace settings (logo, description, timezone, language, date/time format, currency, theme, notifications, auto save, primary color)
- ✅ All changes are persisted to Firebase
- ✅ Primary color is applied to workspace UI elements
- ✅ All validation works correctly (timezone, language, logo URL, etc.)
- ✅ Code follows project rules (GetX + StatelessWidget)
- ✅ Settings persist after app restart
- ✅ Unit tests have minimum 80% coverage
- ✅ Integration tests pass
- ✅ No known bugs or issues

---

## Dependencies

- **Firebase Realtime Database**: Must support storing all settings in workspace settings map
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets for UI components
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications
- **WorkspaceController**: Must have `updateWorkspace` method

---

## Notes

1. **Primary Color**: This is a critical missing feature. When implemented, it should:
   - Be stored as hex string in WorkspaceSettings
   - Be persisted to Firebase
   - Be applied to workspace UI elements
   - Have color picker UI

2. **Validation**: Currently, validation exists in `WorkspaceValidator` but may not be enforced before save. Need to ensure validation is called and errors are displayed.

3. **StatefulWidget**: The page currently uses StatefulWidget which violates project rules. Must be refactored to use GetX controller with StatelessWidget.

4. **Settings Organization**: Settings are organized into sections (Basic, Localization, Appearance, Preferences). This organization should be maintained.

5. **Backward Compatibility**: Ensure existing workspaces without primary color continue to work (nullable field).

6. **Accessibility**: Ensure selected colors meet contrast requirements for text readability.

7. **Performance**: Settings updates should not impact app performance.

---

## Related Documentation

- `WORKSPACE_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `WORKSPACE_SETTINGS_TEST_CASES.md` - Test cases for this feature
- `WORKSPACE_EDIT_TASKS.md` - Related tasks for workspace edit feature
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/CODING_STANDARDS.md` - Coding standards
- `rules/UI_UX_RULES.md` - UI/UX requirements

