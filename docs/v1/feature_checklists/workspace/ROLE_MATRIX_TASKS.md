# Role Matrix - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Role Matrix** feature (Account Holder, Admin, Member, Lead, custom permissions). Currently, this feature is **PARTIAL** - basic roles exist with default permission sets, but Lead role, custom role matrix UI, permission templates editing, and transfer ownership flows are missing.

## Current Status: ⚠️ PARTIAL

### What Works:
- ✅ Basic roles: `WorkspaceRole` enum has accountHolder, admin, member
- ✅ Default permission sets: `DefaultPermissionSets` class defines permissions for each role
- ✅ Permission system: `WorkspacePermissions` constants define all available permissions
- ✅ Role assignment: Users can be assigned roles (Admin, Member)
- ✅ Permission inheritance: Permissions are inherited from roles
- ✅ Custom permissions: Individual permissions can be granted/revoked

### What's Missing/Broken:
- ⚠️ Lead role is not in `WorkspaceRole` enum
- ⚠️ No UI for creating custom roles
- ⚠️ No UI for editing permission templates for roles
- ⚠️ No flow to transfer Account Holder role to another user
- ⚠️ Permission templates are hardcoded (cannot be edited via UI)
- ⚠️ No role matrix comparison view

---

## Task List

### Task 1: Add Lead Role to WorkspaceRole Enum

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add Lead role to `WorkspaceRole` enum and implement default permissions for Lead role.

**Files to Modify**:
- `lib/features/workspace/domain/entities/workspace_member.dart`
- `lib/features/workspace/domain/entities/workspace_permissions.dart`

**Implementation Steps**:
1. Add Lead role to `WorkspaceRole` enum:
   ```dart
   enum WorkspaceRole {
     accountHolder('account_holder'),
     admin('admin'),
     lead('lead'),  // NEW
     member('member');
   }
   ```
2. Update `fromString` method to handle 'lead' value
3. Update `displayName` getter to return 'Lead' for lead role
4. Add `isLead` getter to `WorkspaceMember` class
5. Add default Lead permissions to `DefaultPermissionSets`:
   ```dart
   static const List<String> defaultLeadPermissions = [
     WorkspacePermissions.createTasks,
     WorkspacePermissions.assignTasks,
     WorkspacePermissions.updateTaskStatus,
     WorkspacePermissions.setTaskPriority,
     WorkspacePermissions.setTaskDeadline,
     WorkspacePermissions.createProjects,
     WorkspacePermissions.manageProjects,
     WorkspacePermissions.assignProjects,
     WorkspacePermissions.viewTeamData,
     WorkspacePermissions.viewPersonalData,
     WorkspacePermissions.generateReports,
   ];
   ```
6. Update `getDefaultPermissions` method to return Lead permissions
7. Update all role selection UIs to include Lead option
8. Add Lead role to role hierarchy documentation

**Expected Results**:
- ✅ Lead role is available in `WorkspaceRole` enum
- ✅ Lead role can be assigned to users
- ✅ Lead role has appropriate default permissions
- ✅ Lead role appears in all role selection UIs
- ✅ `isLead` getter works correctly

**Test Criteria**:
- Unit test: Verify Lead role enum value and display name
- Manual test: Assign Lead role to user, verify permissions applied
- Code review: Verify Lead role is integrated consistently

---

### Task 2: Create Permission Template Management UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI for editing permission templates for each role (Account Holder, Admin, Member, Lead).

**Files to Create/Modify**:
- `lib/features/workspace/presentation/pages/role_permission_template_page.dart` (new file)
- `lib/features/workspace/presentation/controllers/role_permission_template_controller.dart` (new file)
- `lib/app/routes/app_router.dart`
- `lib/core/constants/app_strings.dart`

**Implementation Steps**:
1. Create `RolePermissionTemplateController`:
   - Load current permission templates for each role
   - Allow toggling permissions on/off
   - Save template changes to Firebase
   - Use GetX pattern (StatelessWidget)
2. Create `RolePermissionTemplatePage`:
   - Display role selector (Account Holder, Admin, Member, Lead)
   - Display permissions grouped by category
   - Show permission toggles (checkboxes/switches)
   - Show permission descriptions
   - Save button (only for Account Holder)
   - Use TD widgets and AppStrings
3. Add route to AppRouter
4. Add navigation from Workspace Management or Role Management
5. Implement permission template persistence:
   - Store templates in Firebase under `workspaces/{workspaceId}/roleTemplates`
   - Load templates on page load
   - Save templates when changed
6. Add validation:
   - Only Account Holder can edit templates
   - Required permissions cannot be removed
   - Validate permission combinations

**Expected Results**:
- ✅ Permission template editing UI exists
- ✅ Templates can be edited for each role
- ✅ Changes are persisted to Firebase
- ✅ Only Account Holder can edit templates
- ✅ UI follows project rules (TD widgets, AppStrings, GetX)

**Test Criteria**:
- Manual test: Edit permission template, verify changes persist
- Test: Verify only Account Holder can edit
- Test: Verify new role assignments use updated templates

---

### Task 3: Create Custom Role Management UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI for creating and managing custom roles with custom permission sets.

**Files to Create/Modify**:
- `lib/features/workspace/presentation/pages/custom_role_management_page.dart` (new file)
- `lib/features/workspace/presentation/controllers/custom_role_controller.dart` (new file)
- `lib/features/workspace/domain/entities/custom_role.dart` (new file)
- `lib/features/workspace/data/datasources/workspace_remote_data_source.dart`
- `lib/features/workspace/domain/repositories/workspace_repository.dart`
- `lib/app/routes/app_router.dart`

**Implementation Steps**:
1. Create `CustomRole` entity:
   - id, name, description, permissions, workspaceId, createdBy, createdAt
   - fromMap/toMap methods
2. Create `CustomRoleController`:
   - Load custom roles for workspace
   - Create new custom role
   - Update custom role
   - Delete custom role
   - Assign custom role to users
   - Use GetX pattern
3. Create `CustomRoleManagementPage`:
   - Display list of custom roles
   - "Create Custom Role" button
   - Role creation/edit dialog:
     - Name input
     - Description input
     - Permission selection (grouped by category)
   - Delete role option
   - Use TD widgets and AppStrings
4. Update repository to support custom roles:
   - Add methods: `createCustomRole`, `updateCustomRole`, `deleteCustomRole`, `getCustomRoles`
5. Update remote data source to persist custom roles in Firebase
6. Update role assignment UI to include custom roles
7. Add validation:
   - Only Account Holder can create/edit/delete custom roles
   - Role name must be unique
   - Role must have at least one permission

**Expected Results**:
- ✅ Custom roles can be created
- ✅ Custom roles can be edited
- ✅ Custom roles can be deleted
- ✅ Custom roles can be assigned to users
- ✅ Custom roles are persisted to Firebase
- ✅ Only Account Holder can manage custom roles

**Test Criteria**:
- Manual test: Create custom role, assign to user, verify permissions
- Test: Verify custom roles are persisted
- Test: Verify only Account Holder can manage custom roles

---

### Task 4: Implement Transfer Account Holder Ownership Flow

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Implement complete flow for transferring Account Holder role to another user.

**Files to Create/Modify**:
- `lib/features/workspace/domain/usecases/transfer_ownership.dart` (new file)
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/features/workspace/presentation/pages/transfer_ownership_page.dart` (new file)
- `lib/features/workspace/data/repositories/workspace_repository_impl.dart`
- `lib/features/workspace/data/datasources/workspace_remote_data_source.dart`
- `lib/app/routes/app_router.dart`

**Implementation Steps**:
1. Create `TransferOwnership` use case:
   - Validate current user is Account Holder
   - Validate target user exists and is Admin or Member
   - Transfer Account Holder role to target user
   - Update current user's role (to Admin or previous role)
   - Log transfer event (if audit logging exists)
2. Add `transferOwnership` method to `WorkspaceController`:
   - Check current user is Account Holder
   - Show confirmation dialog
   - Call use case
   - Handle success/error
3. Create `TransferOwnershipPage`:
   - Display warning about ownership transfer
   - List eligible users (Admin, Member)
   - User selection
   - Confirmation input (email or confirmation text)
   - Transfer button
   - Use TD widgets and AppStrings
4. Update repository to support ownership transfer:
   - Add `transferOwnership` method
   - Update both users' roles atomically
   - Ensure transaction safety
5. Update remote data source to persist ownership transfer
6. Add navigation from Workspace Management or Role Management
7. Add audit logging (if audit system exists):
   - Log ownership transfer event
   - Include timestamp, from user, to user

**Expected Results**:
- ✅ Account Holder can transfer ownership
- ✅ Transfer requires confirmation
- ✅ Roles are updated correctly
- ✅ Transfer is logged (if audit exists)
- ✅ Transfer is atomic (both users updated together)
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Transfer ownership, verify roles updated
- Test: Verify transfer requires confirmation
- Test: Verify transfer is atomic
- Test: Verify transfer is logged

---

### Task 5: Create Role Matrix Comparison View

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI for viewing and comparing role permissions in a matrix format.

**Files to Create/Modify**:
- `lib/features/workspace/presentation/pages/role_matrix_page.dart` (new file)
- `lib/features/workspace/presentation/controllers/role_matrix_controller.dart` (new file)
- `lib/app/routes/app_router.dart`

**Implementation Steps**:
1. Create `RoleMatrixController`:
   - Load all roles (Account Holder, Admin, Member, Lead, Custom)
   - Load all permissions
   - Build matrix data structure
   - Use GetX pattern
2. Create `RoleMatrixPage`:
   - Display matrix table:
     - Rows: Permissions (grouped by category)
     - Columns: Roles
     - Cells: Checkmarks/X marks or icons
   - Group permissions by category
   - Color code permissions (if applicable)
   - Export button (optional)
   - Use TD widgets and AppStrings
3. Add route to AppRouter
4. Add navigation from Role Management
5. Implement export functionality (optional):
   - Export to CSV
   - Export to PDF
   - Export to Excel

**Expected Results**:
- ✅ Role matrix view is displayed
- ✅ Matrix shows all roles and permissions
- ✅ Matrix is easy to read and compare
- ✅ Permissions are grouped by category
- ✅ Export functionality works (if implemented)

**Test Criteria**:
- Manual test: View role matrix, verify all roles and permissions shown
- Test: Verify matrix is accurate
- Test: Verify export works (if implemented)

---

### Task 6: Update DefaultPermissionSets to Support Custom Templates

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Update `DefaultPermissionSets` to load custom templates from Firebase instead of using hardcoded values.

**Files to Modify**:
- `lib/features/workspace/domain/entities/workspace_permissions.dart`
- `lib/features/workspace/data/datasources/workspace_remote_data_source.dart`
- `lib/features/workspace/domain/repositories/workspace_repository.dart`

**Implementation Steps**:
1. Add method to load permission templates from Firebase:
   - `getPermissionTemplates(String workspaceId)`
   - Returns templates for each role
   - Falls back to defaults if no custom templates exist
2. Update `DefaultPermissionSets`:
   - Make it load from Firebase (or cache)
   - Keep hardcoded defaults as fallback
   - Support custom templates per workspace
3. Update repository to support template loading:
   - Add `getPermissionTemplates` method
   - Cache templates for performance
4. Update controllers to use loaded templates:
   - Load templates on initialization
   - Use templates when assigning roles
   - Update templates when edited

**Expected Results**:
- ✅ Permission templates are loaded from Firebase
- ✅ Custom templates override defaults
- ✅ Templates are cached for performance
- ✅ Fallback to defaults if no custom templates

**Test Criteria**:
- Test: Load templates, verify custom templates are used
- Test: Verify fallback to defaults works
- Test: Verify templates are cached

---

### Task 7: Add Lead Role Permissions to DefaultPermissionSets

**Priority**: High (depends on Task 1)  
**Status**: ⚠️ Not Started

**Description**:
Define appropriate default permissions for Lead role.

**Files to Modify**:
- `lib/features/workspace/domain/entities/workspace_permissions.dart`

**Implementation Steps**:
1. Define Lead role permissions (after Task 1):
   - Lead should manage team/group
   - Lead should assign tasks to team members
   - Lead should view team data
   - Lead should NOT manage workspace or users
2. Add `defaultLeadPermissions` constant to `DefaultPermissionSets`
3. Update `getDefaultPermissions` to return Lead permissions
4. Document Lead role permissions and use cases
5. Ensure Lead permissions are between Admin and Member in hierarchy

**Expected Results**:
- ✅ Lead role has appropriate default permissions
- ✅ Lead permissions are documented
- ✅ Lead permissions fit role hierarchy

**Test Criteria**:
- Manual test: Assign Lead role, verify permissions applied
- Test: Verify Lead permissions are appropriate

---

### Task 8: Update Role Selection UI to Include Lead and Custom Roles

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Update all role selection UIs to include Lead role and custom roles.

**Files to Modify**:
- `lib/app/pages/users/user_management_page.dart`
- `lib/features/workspace/presentation/pages/workspace_member_management_page.dart` (if exists)
- Any other files with role selection dropdowns

**Implementation Steps**:
1. Update role selection dropdowns:
   - Add Lead role option
   - Add custom roles (if any exist)
   - Exclude Account Holder from assignment options
   - Show role descriptions
2. Update role display:
   - Show Lead role correctly
   - Show custom roles correctly
   - Use role display names
3. Ensure role selection is consistent across all UIs
4. Use AppStrings for role names

**Expected Results**:
- ✅ Lead role appears in all role selection UIs
- ✅ Custom roles appear in role selection UIs
- ✅ Role selection is consistent
- ✅ Role descriptions are shown

**Test Criteria**:
- Manual test: Verify Lead and custom roles appear in selection
- Test: Verify role selection works correctly

---

### Task 9: Add Permission Template Validation

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add validation rules for permission templates to prevent invalid configurations.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/role_permission_template_controller.dart`
- `lib/features/workspace/domain/entities/workspace_permissions.dart`

**Implementation Steps**:
1. Define validation rules:
   - Required permissions cannot be removed
   - Permission dependencies (e.g., assignTasks requires createTasks)
   - Minimum permission sets per role
2. Add validation methods:
   - `validatePermissionTemplate`
   - `checkPermissionDependencies`
   - `checkRequiredPermissions`
3. Add validation to template editing UI:
   - Show errors when invalid
   - Prevent saving invalid templates
   - Show warnings for risky configurations
4. Add validation messages to AppStrings

**Expected Results**:
- ✅ Permission templates are validated
- ✅ Invalid configurations are prevented
- ✅ Validation messages are clear
- ✅ Required permissions are protected

**Test Criteria**:
- Test: Try to remove required permission, verify error
- Test: Verify validation messages are clear

---

### Task 10: Add Unit Tests for Role Matrix

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for role matrix functionality.

**Files to Create/Modify**:
- `test/features/workspace/domain/entities/workspace_role_test.dart`
- `test/features/workspace/domain/entities/workspace_permissions_test.dart`
- `test/features/workspace/presentation/controllers/role_permission_template_controller_test.dart`
- `test/features/workspace/presentation/controllers/custom_role_controller_test.dart`

**Implementation Steps**:
1. Test `WorkspaceRole` enum:
   - Test Lead role (after Task 1)
   - Test fromString method
   - Test displayName getter
2. Test `DefaultPermissionSets`:
   - Test default permissions for each role
   - Test Lead permissions (after Task 7)
   - Test getDefaultPermissions method
3. Test permission template controller:
   - Test loading templates
   - Test saving templates
   - Test validation
4. Test custom role controller:
   - Test creating custom roles
   - Test updating custom roles
   - Test deleting custom roles
5. Test ownership transfer:
   - Test transfer use case
   - Test role updates

**Expected Results**:
- ✅ Unit tests cover role matrix functionality
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Add Lead Role to WorkspaceRole Enum (Critical - Core Feature)
2. **Task 7**: Add Lead Role Permissions (High Priority - Depends on Task 1)
3. **Task 2**: Create Permission Template Management UI (High Priority - Core Feature)
4. **Task 4**: Implement Transfer Account Holder Ownership Flow (High Priority - Security Feature)
5. **Task 6**: Update DefaultPermissionSets to Support Custom Templates (Medium Priority - Architecture)
6. **Task 3**: Create Custom Role Management UI (Medium Priority - Feature Completeness)
7. **Task 5**: Create Role Matrix Comparison View (Medium Priority - UX)
8. **Task 8**: Update Role Selection UI (Medium Priority - Consistency)
9. **Task 9**: Add Permission Template Validation (Low Priority - Quality)
10. **Task 10**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Lead role is available and can be assigned
- ✅ Permission templates can be edited via UI
- ✅ Custom roles can be created and managed
- ✅ Account Holder can transfer ownership
- ✅ Role matrix view is available
- ✅ Permission templates are loaded from Firebase
- ✅ All role selection UIs include Lead and custom roles
- ✅ Permission template validation works
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ No known bugs or issues

---

## Dependencies

- **WorkspaceRole Enum**: Must support Lead role
- **DefaultPermissionSets**: Must support custom templates
- **WorkspaceRepository**: Must support custom roles and templates
- **WorkspaceRemoteDataSource**: Must persist custom roles and templates
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications
- **Firebase**: Required for persistence

---

## Notes

1. **Lead Role**: Lead role is mentioned in requirements but not implemented. It should fit between Admin and Member in hierarchy.

2. **Permission Templates**: Currently hardcoded in `DefaultPermissionSets`. Need to support custom templates per workspace.

3. **Custom Roles**: No support for creating custom roles. Need to add entity, repository, and UI.

4. **Transfer Ownership**: Critical security feature - Account Holder should be able to transfer ownership when leaving.

5. **Role Matrix**: Helpful for understanding role differences. Should show all roles and permissions in comparison format.

6. **Permission Validation**: Need to ensure permission templates are valid and don't break access control.

---

## Related Documentation

- `WORKSPACE_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `ROLE_MATRIX_TEST_CASES.md` - Test cases for this feature
- `WORKSPACE_USER_MANAGEMENT_TEST_CASES.md` - Related user management tests
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/CODING_STANDARDS.md` - Coding standards
- `rules/SECURITY_RULES.md` - Security requirements

