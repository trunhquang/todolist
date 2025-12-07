# Workspace Edit Information - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Edit Workspace Information** feature (tên, mô tả, màu nhận diện). Currently, this feature is **PARTIAL** - basic editing works, but primary color/brand color is missing and there are routing/architecture issues.

## Current Status: ⚠️ PARTIAL

### What Works:
- ✅ Edit workspace name via `WorkspaceSettingsPage` (app/pages/workspace)
- ✅ Edit workspace description via `WorkspaceSettingsPage`
- ✅ Edit workspace logo URL via `WorkspaceSettingsPage`
- ✅ Update workspace via `WorkspaceController.updateWorkspace`
- ✅ Permission check for `manage_workspace`

### What's Missing/Broken:
- ⚠️ Primary color/màu nhận diện support
- ⚠️ Routing issue: `AppRouter.workspaceSettings` doesn't pass required `workspace` param
- ⚠️ StatefulWidget violation (should use GetX + StatelessWidget)
- ⚠️ Management page `_editWorkspace` is TODO
- ⚠️ No server-side persistence for color
- ⚠️ Timezone/language validation not enforced before save

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
Add color picker UI component to allow users to select primary color/brand color for workspace.

**Files to Modify**:
- `lib/app/pages/workspace/workspace_settings_page.dart` (or refactor to use GetX)
- `lib/core/widgets/td_color_picker.dart` (new file - create custom color picker widget)

**Implementation Steps**:
1. Create `TDColorPicker` widget (custom color picker following TD widget patterns)
2. Add color picker section to WorkspaceSettingsPage
2. Add controller for color selection
3. Display current primary color (if set)
4. Allow user to select color from palette or enter hex code
5. Show color preview
6. Validate color format before save

**Expected Results**:
- ✅ Color picker UI is available in Workspace Settings
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
Ensure primary color is persisted to Firebase Realtime Database when workspace is updated.

**Files to Modify**:
- `lib/features/workspace/data/datasources/workspace_remote_data_source.dart`
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`

**Implementation Steps**:
1. Update `updateWorkspace` in `WorkspaceRemoteDataSourceImpl` to include `primaryColor` in update payload
2. Ensure `primaryColor` is read from Firebase when loading workspace
3. Update `WorkspaceController.updateWorkspaceSettings` to accept `primaryColor` parameter
4. Pass `primaryColor` through the update flow

**Expected Results**:
- ✅ Primary color is saved to Firebase when workspace is updated
- ✅ Primary color is loaded from Firebase when workspace is fetched
- ✅ Primary color persists across app restarts
- ✅ Primary color is synced across devices

**Test Criteria**:
- Integration test: Update workspace with color, verify Firebase has color
- Manual test: Update color, restart app, verify color persists

---

### Task 4: Fix WorkspaceSettingsPage Routing Issue

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Fix routing issue where `AppRouter.workspaceSettings` doesn't pass required `workspace` parameter, causing potential runtime break.

**Files to Modify**:
- `lib/app/routes/app_router.dart`
- `lib/features/workspace/presentation/pages/workspace_settings_page.dart` (if it requires workspace param)

**Implementation Steps**:
1. Review which `WorkspaceSettingsPage` is being used (there are two files)
2. If `lib/features/workspace/presentation/pages/workspace_settings_page.dart` requires workspace param:
   - Update route to get workspace from `WorkspaceController.currentWorkspace`
   - OR pass workspace as route argument
3. If `lib/app/pages/workspace/workspace_settings_page.dart` is being used:
   - Verify it doesn't require workspace param (it uses controller)
   - Ensure route works correctly
4. Remove duplicate/unused WorkspaceSettingsPage if exists
5. Update all navigation calls to use correct route

**Expected Results**:
- ✅ Route works without runtime errors
- ✅ Workspace data is accessible in WorkspaceSettingsPage
- ✅ No duplicate WorkspaceSettingsPage implementations
- ✅ All navigation calls work correctly

**Test Criteria**:
- Manual test: Navigate to Workspace Settings from all entry points
- Verify no crashes or errors
- Verify workspace data is displayed correctly

---

### Task 5: Refactor WorkspaceSettingsPage to Use GetX + StatelessWidget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Replace StatefulWidget with GetX controller + StatelessWidget to comply with project rules.

**Files to Modify**:
- `lib/app/pages/workspace/workspace_settings_page.dart`
- `lib/features/workspace/presentation/pages/workspace_settings_page.dart` (if used)
- Create: `lib/features/workspace/presentation/controllers/workspace_settings_controller.dart` (if needed)

**Implementation Steps**:
1. Create `WorkspaceSettingsController` extending `GetxController` (if not exists)
2. Move all state management from StatefulWidget to controller:
   - Form controllers (name, description, logoUrl, primaryColor)
   - Loading state
   - Validation state
   - Settings state
3. Convert `WorkspaceSettingsPage` from StatefulWidget to StatelessWidget
4. Use `GetBuilder` or `Obx` for reactive UI updates
5. Remove `setState` calls
6. Use `Get.find<WorkspaceSettingsController>()` or `Get.put()` for dependency injection

**Expected Results**:
- ✅ WorkspaceSettingsPage is StatelessWidget
- ✅ All state is managed by GetX controller
- ✅ Page follows GetX patterns (GetBuilder/Obx)
- ✅ No StatefulWidget violations
- ✅ Code follows project architecture rules

**Test Criteria**:
- Verify page functionality works identically
- Verify reactive updates work (Obx/GetBuilder)
- Code review: No StatefulWidget, follows GetX patterns

---

### Task 6: Implement Edit Workspace in WorkspaceManagementPage

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Complete the TODO in `WorkspaceManagementPage._editWorkspace` to allow editing workspace from management page.

**Files to Modify**:
- `lib/features/workspace/presentation/pages/workspace_management_page.dart`

**Implementation Steps**:
1. Implement `_editWorkspace` method in `WorkspaceManagementPage`
2. Navigate to WorkspaceSettingsPage with current workspace
3. OR create inline edit dialog/modal
4. Ensure workspace data is passed correctly
5. Handle save/cancel actions
6. Update UI after successful edit

**Expected Results**:
- ✅ "Edit Workspace" button in WorkspaceManagementPage works
- ✅ User can edit workspace name, description, logo, color from management page
- ✅ Changes are saved and reflected in UI
- ✅ Navigation works correctly

**Test Criteria**:
- Manual test: Tap "Edit Workspace" in management page, verify navigation and editing works

---

### Task 7: Add Timezone/Language Validation Before Save

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Enforce validation for timezone and language settings before saving workspace settings.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/features/workspace/domain/services/workspace_validator.dart`

**Implementation Steps**:
1. Add validation in `WorkspaceValidator.validateWorkspaceSettings` (already exists but may not be enforced)
2. Call validation in `WorkspaceController.updateWorkspace` before saving
3. Display validation errors in UI if validation fails
4. Prevent save if validation fails

**Expected Results**:
- ✅ Invalid timezone values are rejected
- ✅ Invalid language values are rejected
- ✅ Validation errors are displayed to user
- ✅ Save is prevented if validation fails

**Test Criteria**:
- Unit tests for validation
- Manual test: Try to save with invalid timezone/language, verify error

---

### Task 8: Add Primary Color Application to Workspace UI

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

**Expected Results**:
- ✅ Workspace primary color is applied to workspace UI elements
- ✅ Color is visible in workspace selector
- ✅ Color is visible in workspace header
- ✅ Fallback to app primary color if workspace color not set
- ✅ Color contrast is accessible

**Test Criteria**:
- Manual test: Set workspace color, verify UI elements use the color
- Visual test: Verify color application looks correct

---

### Task 9: Add Unit Tests for Primary Color Feature

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for primary color functionality.

**Files to Create/Modify**:
- `test/features/workspace/domain/entities/workspace_settings_test.dart`
- `test/features/workspace/presentation/controllers/workspace_controller_test.dart`
- `test/features/workspace/data/datasources/workspace_remote_data_source_test.dart`

**Implementation Steps**:
1. Test `WorkspaceSettings` with primary color:
   - Test serialization/deserialization
   - Test color validation
   - Test copyWith with color
2. Test `WorkspaceController.updateWorkspaceSettings` with color
3. Test `WorkspaceRemoteDataSource.updateWorkspace` includes color
4. Test color persistence and retrieval

**Expected Results**:
- ✅ Unit tests cover primary color functionality
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

### Task 10: Add Integration Tests for Workspace Edit Flow

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Write integration tests for complete workspace edit flow including primary color.

**Files to Create**:
- `test/features/workspace/integration/workspace_edit_integration_test.dart`

**Implementation Steps**:
1. Test complete flow: Load workspace → Edit name/description/color → Save → Verify
2. Test validation errors
3. Test permission denied scenarios
4. Test network error handling

**Expected Results**:
- ✅ Integration tests cover complete edit flow
- ✅ Tests verify Firebase persistence
- ✅ All integration tests pass

**Test Criteria**:
- Run integration tests
- Verify tests pass with Firebase emulator or test environment

---

## Implementation Priority Order

1. **Task 1**: Add Primary Color to WorkspaceSettings Entity (Foundation)
2. **Task 4**: Fix Routing Issue (Critical Bug)
3. **Task 3**: Implement Primary Color Persistence (Core Functionality)
4. **Task 2**: Add Primary Color Picker UI (User-Facing Feature)
5. **Task 5**: Refactor to GetX + StatelessWidget (Architecture Compliance)
6. **Task 8**: Apply Primary Color to UI (Visual Enhancement)
7. **Task 6**: Implement Edit in Management Page (Feature Completion)
8. **Task 7**: Add Validation (Quality Improvement)
9. **Task 9**: Add Unit Tests (Quality Assurance)
10. **Task 10**: Add Integration Tests (Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Users can edit workspace name, description, logo URL, and primary color
- ✅ All changes are persisted to Firebase
- ✅ Primary color is applied to workspace UI elements
- ✅ Routing works correctly without errors
- ✅ Code follows project rules (GetX + StatelessWidget)
- ✅ All validation works correctly
- ✅ Edit functionality works from both WorkspaceSettingsPage and WorkspaceManagementPage
- ✅ Unit tests have minimum 80% coverage
- ✅ Integration tests pass
- ✅ No known bugs or issues

---

## Dependencies

- **Firebase Realtime Database**: Must support storing primary color in workspace settings
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets for UI components
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications

---

## Notes

1. **Two WorkspaceSettingsPage Files**: There are currently two WorkspaceSettingsPage implementations. Need to consolidate or clarify which one is used.

2. **Color Format**: Decide on color format (hex string, RGB, etc.). Recommendation: Use hex string (e.g., "#FF5733") for consistency.

3. **Color Validation**: Implement validation to ensure color values are valid hex codes.

4. **Backward Compatibility**: Ensure existing workspaces without primary color continue to work (nullable field).

5. **Accessibility**: Ensure selected colors meet contrast requirements for text readability.

6. **Performance**: Color application should not impact app performance.

---

## Related Documentation

- `WORKSPACE_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `WORKSPACE_EDIT_TEST_CASES.md` - Test cases for this feature
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/CODING_STANDARDS.md` - Coding standards
