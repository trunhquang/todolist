# Workspace User Management - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Workspace User Management** feature (roles, status, invite/revoke, add/remove). Currently, this feature is **PARTIAL** - domain logic exists, but UI in WorkspaceManagementPage is missing and permissions use strings instead of enums.

## Current Status: ⚠️ PARTIAL

### What Works:
- ✅ Domain logic: `WorkspaceRepositoryImpl` supports `addMember`, `removeMember`, `updateMemberPermissions`, `listInvitations`, `revokeInvitation`
- ✅ Controller methods: `WorkspaceController` has `inviteUserToWorkspace`, `revokeInvitation`, `removeUserFromWorkspace`, `updateUserRole`, `_togglePermission`
- ✅ UserManagementPage: Has working UI for member management (separate page)
- ✅ Invitation service: Supports sending and revoking invitations
- ✅ Permission checks: Controller checks permissions before operations

### What's Missing/Broken:
- ⚠️ `WorkspaceManagementPage._manageMembers` is TODO (not implemented)
- ⚠️ No navigation from WorkspaceManagementPage to member management
- ⚠️ Permissions checks rely on strings, not enums
- ⚠️ Inconsistent UI locations (UserManagementPage vs WorkspaceManagementPage)

---

## Task List

### Task 1: Implement WorkspaceManagementPage._manageMembers

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Complete the TODO in `WorkspaceManagementPage._manageMembers` to navigate to member management screen.

**Files to Modify**:
- `lib/features/workspace/presentation/pages/workspace_management_page.dart`

**Implementation Steps**:
1. Implement `_manageMembers` method in `WorkspaceManagementPage`
2. Navigate to UserManagementPage:
   - Use `NavigationService().toNamed<void>(AppRouter.userManagement)`
   - OR create dedicated member management screen
3. Ensure navigation works correctly
4. Remove TODO comment
5. Test navigation from Workspace Management page

**Expected Results**:
- ✅ "Manage Members" option navigates to member management screen
- ✅ Navigation works correctly
- ✅ User can manage members from Workspace Management page

**Test Criteria**:
- Manual test: Tap "Manage Members", verify navigation works
- Verify member management screen is accessible

---

### Task 2: Refactor Permissions to Use Enums

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Replace string-based permission checks with enum-based checks for type safety.

**Files to Create/Modify**:
- `lib/features/workspace/domain/entities/workspace_permissions.dart` (may already exist)
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- All files that use permission strings

**Implementation Steps**:
1. Review `WorkspacePermissions` class (if exists)
2. Create permission enum if not exists:
   ```dart
   enum WorkspacePermission {
     manageWorkspace('manage_workspace'),
     manageUsers('manage_users'),
     inviteUsers('invite_users'),
     removeUsers('remove_users'),
     assignPermissions('assign_permissions'),
     // ... other permissions
   }
   ```
3. Update `WorkspaceController.hasPermission()`:
   - Accept `WorkspacePermission` enum instead of String
   - Convert enum to string for repository call
4. Update all permission checks:
   - Replace string literals with enum values
   - Update `inviteUserToWorkspace`, `removeUserFromWorkspace`, etc.
5. Update UI components that check permissions
6. Add type safety and compile-time checks

**Expected Results**:
- ✅ Permissions use enums instead of strings
- ✅ Type safety is enforced
- ✅ Compile-time checks prevent typos
- ✅ All permission checks are updated

**Test Criteria**:
- Code review: Verify enums are used
- Test: Permission checks still work correctly
- Test: Type safety prevents invalid permissions

---

### Task 3: Create Unified Member Management Screen

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create a dedicated member management screen that can be accessed from both WorkspaceManagementPage and other locations.

**Files to Create/Modify**:
- `lib/features/workspace/presentation/pages/workspace_member_management_page.dart` (new file)
- `lib/app/routes/app_router.dart`
- `lib/features/workspace/presentation/pages/workspace_management_page.dart`

**Implementation Steps**:
1. Create `WorkspaceMemberManagementPage`:
   - Display workspace members list
   - Display pending invitations
   - Allow inviting users
   - Allow editing roles
   - Allow removing users
   - Allow managing permissions
2. Use GetX controller pattern (StatelessWidget)
3. Add route to AppRouter
4. Update `WorkspaceManagementPage._manageMembers` to navigate to this page
5. Ensure page follows project rules (TD widgets, AppStrings, etc.)

**Expected Results**:
- ✅ Unified member management screen exists
- ✅ Screen is accessible from Workspace Management page
- ✅ Screen follows project architecture rules
- ✅ All member management features are available

**Test Criteria**:
- Manual test: Navigate to member management, verify all features work
- Code review: Verify follows project rules

---

### Task 4: Add Member Status Management UI

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add UI for managing member status (active/inactive).

**Files to Modify**:
- `lib/features/workspace/presentation/pages/workspace_member_management_page.dart` (or UserManagementPage)
- `lib/app/pages/users/user_management_page.dart`

**Implementation Steps**:
1. Add status display in member list:
   - Show active/inactive status
   - Use visual indicators (badges, colors)
2. Add status toggle/action:
   - Allow activating/deactivating members
   - Add confirmation for deactivation
3. Filter inactive members (optional):
   - Add filter to show/hide inactive members
4. Update controller to handle status changes
5. Ensure status changes are persisted

**Expected Results**:
- ✅ Member status is displayed
- ✅ Status can be toggled
- ✅ Status changes are persisted
- ✅ Inactive members lose access

**Test Criteria**:
- Manual test: Toggle member status, verify changes
- Test: Verify inactive members lose access

---

### Task 5: Improve Member Role Selection UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Improve role selection UI to use enums and show all available roles.

**Files to Modify**:
- `lib/app/pages/users/user_management_page.dart`
- `lib/features/workspace/presentation/pages/workspace_member_management_page.dart` (if created)

**Implementation Steps**:
1. Update role selection dropdown:
   - Use `WorkspaceRole` enum instead of hardcoded strings
   - Show all available roles (Account Holder, Admin, Member)
   - Disable Account Holder option for non-Account Holders
2. Add role descriptions:
   - Show what each role can do
   - Help users understand role differences
3. Add role validation:
   - Prevent invalid role assignments
   - Show errors for invalid roles
4. Use AppStrings for role display names

**Expected Results**:
- ✅ Role selection uses enums
- ✅ All roles are available (with restrictions)
- ✅ Role descriptions help users
- ✅ Role validation works

**Test Criteria**:
- Manual test: Edit role, verify all roles are available
- Test: Verify role restrictions work

---

### Task 6: Add Permission Management UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add comprehensive UI for managing individual user permissions.

**Files to Modify**:
- `lib/app/pages/permissions/permission_management_page.dart` (may already exist)
- `lib/features/workspace/presentation/pages/workspace_member_management_page.dart` (if created)

**Implementation Steps**:
1. Review existing PermissionManagementPage
2. Enhance permission management UI:
   - Show all available permissions
   - Allow toggling individual permissions
   - Group permissions by category
   - Show permission descriptions
3. Add permission templates:
   - Predefined permission sets for roles
   - Allow applying templates
4. Add permission validation:
   - Ensure required permissions are not removed
   - Validate permission combinations
5. Use permission enums (from Task 2)

**Expected Results**:
- ✅ Permission management UI is comprehensive
- ✅ Individual permissions can be toggled
- ✅ Permission templates are available
- ✅ Permission validation works

**Test Criteria**:
- Manual test: Toggle permissions, verify changes
- Test: Verify permission templates work

---

### Task 7: Add Bulk Member Operations

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add support for bulk operations (invite multiple users, update multiple roles, etc.).

**Files to Modify**:
- `lib/features/workspace/presentation/pages/workspace_member_management_page.dart` (if created)
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`

**Implementation Steps**:
1. Add bulk invite:
   - Allow entering multiple emails
   - Send invitations to all emails
   - Handle partial failures
2. Add bulk role update:
   - Select multiple members
   - Update all selected members' roles
3. Add bulk remove:
   - Select multiple members
   - Remove all selected members
   - Show confirmation for bulk operations
4. Add selection UI:
   - Checkboxes for member selection
   - Select all option
5. Handle errors gracefully

**Expected Results**:
- ✅ Bulk operations are available
- ✅ Multiple users can be managed at once
- ✅ Errors are handled gracefully

**Test Criteria**:
- Manual test: Bulk invite, verify all invitations sent
- Test: Bulk operations handle errors correctly

---

### Task 8: Add Member Activity/Status Indicators

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add visual indicators for member activity status (online, offline, last active, etc.).

**Files to Modify**:
- `lib/app/pages/users/user_management_page.dart`
- `lib/features/workspace/presentation/pages/workspace_member_management_page.dart` (if created)
- `lib/app/pages/users/widgets/member_card.dart`

**Implementation Steps**:
1. Add activity status tracking:
   - Track last active time
   - Determine online/offline status (if possible)
2. Add visual indicators:
   - Online/offline badges
   - Last active time display
   - Activity status colors
3. Update member cards to show status
4. Add activity status to member list

**Expected Results**:
- ✅ Member activity status is displayed
- ✅ Visual indicators are clear
- ✅ Last active time is shown

**Test Criteria**:
- Manual test: Verify activity status is displayed
- Test: Verify status updates correctly

---

### Task 9: Add Unit Tests for User Management

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for user management functionality.

**Files to Create/Modify**:
- `test/features/workspace/presentation/controllers/workspace_controller_test.dart`
- `test/features/workspace/data/repositories/workspace_repository_impl_test.dart`
- `test/app/pages/users/controllers/user_management_controller_test.dart`

**Implementation Steps**:
1. Test `WorkspaceController` methods:
   - Test `inviteUserToWorkspace`
   - Test `revokeInvitation`
   - Test `removeUserFromWorkspace`
   - Test `updateUserRole`
   - Test `grantPermission`/`revokePermission`
2. Test permission checks
3. Test role updates
4. Test member removal
5. Test invitation flow

**Expected Results**:
- ✅ Unit tests cover user management functionality
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

### Task 10: Add Integration Tests for User Management

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Write integration tests for complete user management flow including Firebase persistence.

**Files to Create**:
- `test/features/workspace/integration/user_management_integration_test.dart`

**Implementation Steps**:
1. Test complete invitation flow:
   - Send invitation → Accept → Verify member added
2. Test role update flow:
   - Update role → Verify role changed → Verify permissions updated
3. Test member removal flow:
   - Remove member → Verify removed from Firebase → Verify loses access
4. Test permission updates
5. Test with Firebase emulator

**Expected Results**:
- ✅ Integration tests cover complete user management flow
- ✅ Tests verify Firebase persistence
- ✅ All integration tests pass

**Test Criteria**:
- Run integration tests
- Verify tests pass with Firebase emulator

---

## Implementation Priority Order

1. **Task 1**: Implement WorkspaceManagementPage._manageMembers (Critical - Core Feature)
2. **Task 2**: Refactor Permissions to Use Enums (High Priority - Type Safety)
3. **Task 3**: Create Unified Member Management Screen (Medium Priority - UX)
4. **Task 5**: Improve Member Role Selection UI (Medium Priority - UX)
5. **Task 6**: Add Permission Management UI (Medium Priority - Feature Completeness)
6. **Task 9**: Add Unit Tests (Medium Priority - Quality Assurance)
7. **Task 4**: Add Member Status Management UI (Low Priority)
8. **Task 7**: Add Bulk Member Operations (Low Priority)
9. **Task 8**: Add Member Activity/Status Indicators (Low Priority)
10. **Task 10**: Add Integration Tests (Low Priority)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Users can view workspace members list
- ✅ Users can invite members to workspace
- ✅ Invitations can be revoked
- ✅ User roles can be updated
- ✅ Users can be removed from workspace
- ✅ Permissions can be managed
- ✅ WorkspaceManagementPage._manageMembers is implemented
- ✅ Permissions use enums instead of strings
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ Unit tests have minimum 80% coverage
- ✅ Integration tests pass
- ✅ No known bugs or issues

---

## Dependencies

- **WorkspaceController**: Must have user management methods
- **WorkspaceRepository**: Must support member operations
- **WorkspaceRemoteDataSource**: Must support Firebase operations
- **InvitationService**: Must support invitation operations
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications

---

## Notes

1. **Two Management Pages**: 
   - UserManagementPage: Has working UI (separate page)
   - WorkspaceManagementPage: _manageMembers is TODO
   - Need to connect them or create unified page

2. **Permission Strings**: Currently uses strings like 'manage_users', 'invite_users'. Should use enums for type safety.

3. **Role Management**: Roles can be updated, but Account Holder has special protections.

4. **Permission Management**: Individual permission management may exist in PermissionManagementPage, but needs to be integrated.

5. **Invitation Flow**: Invitation sending works, but acceptance flow may need separate implementation.

6. **Member Status**: Active/inactive status exists in entity but may not have UI.

---

## Related Documentation

- `WORKSPACE_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `WORKSPACE_USER_MANAGEMENT_TEST_CASES.md` - Test cases for this feature
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/CODING_STANDARDS.md` - Coding standards
- `rules/SECURITY_RULES.md` - Security requirements

