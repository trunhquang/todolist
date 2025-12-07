# Roles & Permissions (Account Holder/Admin/Lead/Member + Custom Permissions) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Roles & Permissions** feature (Account Holder/Admin/Lead/Member + custom permissions). This feature is currently **PARTIAL** - `UserRoles` defines admin/departmentManager/teamLead/regular with permission lists, but Account Holder role, Lead per workspace/team, custom permission sets for projects/tasks/teams are missing, and workspace role (AccountHolder/Admin/Member) is handled separately in `WorkspaceRole` but not bridged to `User`.

## Prerequisites
- User must be logged in
- User should have different roles (Account Holder, Admin, Member, Lead)
- Device should have internet connection (for Firebase sync)
- Multiple workspaces may be needed for testing

---

## Test Case 1: View User Roles - Current Implementation

**Objective**: Verify current user roles are displayed correctly.

**Preconditions**:
- User is logged in
- User has a role assigned

**Steps**:
1. Navigate to Profile page
2. Verify user role is displayed:
   - Role name is shown (e.g., "Admin", "Department Manager", "Team Lead", "Regular User")
   - Role badge or indicator is displayed
3. Verify role display uses `UserRoles.getRoleDisplayName`
4. Check different roles:
   - Admin role
   - Department Manager role
   - Team Lead role
   - Regular User role
5. Verify Account Holder role is NOT displayed in User.role (this is expected - Account Holder is in WorkspaceRole, not UserRoles)

**Expected Results**:
- ✅ User roles are displayed correctly
- ✅ Role names are clear
- ⚠️ Account Holder role is not in User.role (separate system)

---

## Test Case 2: View Workspace Roles - Current Implementation

**Objective**: Verify workspace roles are displayed correctly.

**Preconditions**:
- User is logged in
- User is a member of a workspace
- Workspace has members with different roles

**Steps**:
1. Navigate to User Management or Member Management screen
2. Verify workspace roles are displayed:
   - Account Holder role
   - Admin role
   - Member role
3. Verify role display uses `WorkspaceRole.displayName`
4. Check role badges/indicators:
   - Account Holder badge
   - Admin badge
   - Member badge
5. Verify Lead role is NOT displayed (this is expected - Lead role is missing)

**Expected Results**:
- ✅ Workspace roles are displayed correctly
- ✅ Account Holder role is shown
- ⚠️ Lead role is NOT available (missing)

---

## Test Case 3: Account Holder Role Mapping - Missing Feature

**Objective**: Verify Account Holder role from WorkspaceRole is mapped to User.role (currently missing).

**Preconditions**:
- User A is Account Holder in a workspace
- Account Holder mapping feature is implemented

**Steps**:
1. As User A (Account Holder), check User.role:
   - Navigate to Profile page
   - Verify one of the following:
     - **If NOT implemented**: User.role shows different role (e.g., "Regular User") - this is expected - no bridge
     - **If implemented**: User.role reflects Account Holder status
2. If implemented:
   - Verify Account Holder is added to UserRoles
   - Verify User.role shows "Account Holder" or equivalent
   - Verify permissions match Account Holder permissions
3. Check permission checks:
   - Verify `AuthController.hasPermission` works with Account Holder
   - Verify Account Holder has all permissions
4. Test in multiple workspaces:
   - User A is Account Holder in Workspace 1
   - User A is Member in Workspace 2
   - Verify role mapping works per workspace

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Account Holder mapping is NOT available (missing)
- ✅ **When implemented**: Account Holder is mapped to User.role
- ✅ Permissions work correctly
- ✅ Role mapping is workspace-aware

---

## Test Case 4: Lead Role Per Workspace/Team - Missing Feature

**Objective**: Verify Lead role can be assigned per workspace/team (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists
- Team/Group exists
- Lead role feature is implemented

**Steps**:
1. Navigate to User Management or Team Management screen
2. Locate User B
3. Verify one of the following:
   - **If NOT implemented**: Lead role option is not available (this is expected - feature missing)
   - **If implemented**: "Assign as Lead" or "Set as Team Lead" option is available
4. If implemented:
   - Assign User B as Lead for a team
   - Verify Lead role is assigned:
     - Check `WorkspaceRole` enum has `lead` value
     - Check User B's role in workspace is "Lead"
     - Check User B's role in team is "Lead"
   - Verify Lead permissions are applied:
     - Check permissions match Lead default permissions
     - Verify Lead can manage team members
     - Verify Lead can view team data
5. Test Lead role per team:
   - Assign User B as Lead for Team A
   - Assign User C as Lead for Team B
   - Verify both can be Leads simultaneously
   - Verify Lead permissions are scoped to their teams

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Lead role is NOT available (missing)
- ✅ **When implemented**: Lead role can be assigned per workspace/team
- ✅ Lead permissions are applied correctly
- ✅ Multiple Leads can exist for different teams

---

## Test Case 5: Custom Permission Sets for Projects - Missing Feature

**Objective**: Verify custom permission sets can be created for projects (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- Project exists
- Custom permission sets feature is implemented

**Steps**:
1. Navigate to Project Settings or Permission Management screen
2. Locate a project
3. Verify one of the following:
   - **If NOT implemented**: Custom permission option is not available (this is expected - feature missing)
   - **If implemented**: "Custom Permissions" or "Permission Set" option is available
4. If implemented:
   - Tap "Custom Permissions" option
   - Verify permission set editor appears:
     - List of available permissions
     - Checkboxes for each permission
     - Save button
   - Create custom permission set:
     - Select permissions (e.g., view, edit, delete)
     - Name the permission set (e.g., "Project Viewer", "Project Editor")
     - Save permission set
   - Assign permission set to users:
     - Select users
     - Assign custom permission set
     - Verify users have custom permissions
5. Test permission enforcement:
   - User with custom permissions tries to access project
   - Verify permissions are enforced
   - Verify users without permissions are blocked

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Custom permission sets for projects are NOT available (missing)
- ✅ **When implemented**: Custom permission sets can be created
- ✅ Permission sets can be assigned to users
- ✅ Permissions are enforced

---

## Test Case 6: Custom Permission Sets for Tasks - Missing Feature

**Objective**: Verify custom permission sets can be created for tasks (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- Task exists
- Custom permission sets feature is implemented

**Steps**:
1. Navigate to Task Settings or Permission Management screen
2. Locate a task or task category
3. Verify one of the following:
   - **If NOT implemented**: Custom permission option is not available (this is expected - feature missing)
   - **If implemented**: "Custom Permissions" option is available
4. If implemented:
   - Create custom permission set for tasks:
     - Select task-related permissions (create, assign, update, delete, set priority, set deadline)
     - Name the permission set
     - Save permission set
   - Assign permission set to users
   - Test permission enforcement:
     - User with custom permissions tries to perform task actions
     - Verify permissions are enforced
     - Verify users without permissions are blocked

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Custom permission sets for tasks are NOT available (missing)
- ✅ **When implemented**: Custom permission sets can be created
- ✅ Permission sets can be assigned to users
- ✅ Permissions are enforced

---

## Test Case 7: Custom Permission Sets for Teams - Missing Feature

**Objective**: Verify custom permission sets can be created for teams (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- Team/Group exists
- Custom permission sets feature is implemented

**Steps**:
1. Navigate to Team Settings or Permission Management screen
2. Locate a team
3. Verify one of the following:
   - **If NOT implemented**: Custom permission option is not available (this is expected - feature missing)
   - **If implemented**: "Custom Permissions" option is available
4. If implemented:
   - Create custom permission set for teams:
     - Select team-related permissions (view team data, manage team members, assign tasks to team)
     - Name the permission set
     - Save permission set
   - Assign permission set to users
   - Test permission enforcement:
     - User with custom permissions tries to access team data
     - Verify permissions are enforced

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Custom permission sets for teams are NOT available (missing)
- ✅ **When implemented**: Custom permission sets can be created
- ✅ Permission sets can be assigned to users
- ✅ Permissions are enforced

---

## Test Case 8: Permission Inheritance and Override

**Objective**: Verify permission inheritance and override work correctly (if implemented).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B has role-based permissions
- Custom permissions are assigned to User B
- Permission inheritance feature is implemented

**Steps**:
1. Assign role to User B (e.g., Member)
2. Verify User B has default Member permissions
3. Assign custom permissions to User B:
   - Grant additional permission (e.g., "delete_tasks")
   - Revoke existing permission (e.g., "create_tasks")
4. Verify one of the following:
   - **If NOT implemented**: Custom permissions don't override role permissions (this is expected - feature missing)
   - **If implemented**: Custom permissions override role defaults
5. If implemented:
   - Verify User B has custom permissions:
     - Has "delete_tasks" permission
     - Does NOT have "create_tasks" permission
   - Test permission checks:
     - Verify `hasPermission` returns correct values
     - Verify UI reflects custom permissions
6. Remove custom permissions
7. Verify User B reverts to role default permissions

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permission override is NOT available (missing)
- ✅ **When implemented**: Custom permissions override role defaults
- ✅ Permission inheritance works correctly
- ✅ Removing custom permissions reverts to defaults

---

## Test Case 9: Role Bridge - User.role to WorkspaceRole

**Objective**: Verify User.role is bridged with WorkspaceRole (currently missing).

**Preconditions**:
- User A is logged in
- User A is Account Holder in Workspace 1
- User A is Member in Workspace 2
- Role bridge feature is implemented

**Steps**:
1. Switch to Workspace 1 (where User A is Account Holder)
2. Verify one of the following:
   - **If NOT implemented**: User.role doesn't reflect Account Holder (this is expected - no bridge)
   - **If implemented**: User.role reflects Account Holder
3. If implemented:
   - Check `AuthController.hasPermission`:
     - Verify Account Holder permissions work
     - Verify permission checks use workspace role
   - Check role display:
     - Verify Profile page shows Account Holder
     - Verify role is workspace-aware
4. Switch to Workspace 2 (where User A is Member)
5. Verify role changes:
   - User.role reflects Member
   - Permissions match Member permissions
   - Role display shows Member
6. Verify role bridge works correctly:
   - Role is updated when switching workspaces
   - Permissions are updated accordingly
   - No conflicts between UserRoles and WorkspaceRole

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Role bridge is NOT available (missing)
- ✅ **When implemented**: User.role is bridged with WorkspaceRole
- ✅ Role is workspace-aware
- ✅ Permissions are updated when switching workspaces

---

## Test Case 10: Permission Check - Workspace vs User Role

**Objective**: Verify permission checks use workspace role, not just User.role.

**Preconditions**:
- User A is logged in
- User A has different roles in different workspaces
- Permission check feature is implemented

**Steps**:
1. As User A, switch to Workspace 1 (where User A is Admin)
2. Verify permission checks:
   - Check `WorkspaceController.hasPermission`
   - Verify Admin permissions work
   - Verify can perform Admin actions
3. Switch to Workspace 2 (where User A is Member)
4. Verify permission checks:
   - Check `WorkspaceController.hasPermission`
   - Verify Member permissions work
   - Verify cannot perform Admin actions
5. Verify one of the following:
   - **If NOT implemented**: Permission checks may use User.role only (this is expected - no bridge)
   - **If implemented**: Permission checks use workspace role correctly
6. If implemented:
   - Verify `hasPermission` checks workspace membership
   - Verify permissions are workspace-scoped
   - Verify role changes affect permissions immediately

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permission checks may not use workspace role correctly (missing bridge)
- ✅ **When implemented**: Permission checks use workspace role
- ✅ Permissions are workspace-scoped
- ✅ Role changes affect permissions immediately

---

## Test Case 11: Add Account Holder to UserRoles

**Objective**: Verify Account Holder role is added to UserRoles (if implemented).

**Preconditions**:
- Account Holder role addition feature is implemented

**Steps**:
1. Check `UserRoles` class
2. Verify one of the following:
   - **If NOT implemented**: Account Holder is not in UserRoles (this is expected - feature missing)
   - **If implemented**: Account Holder is added to UserRoles
3. If implemented:
   - Verify Account Holder constant exists:
     - `UserRoles.accountHolder` constant
   - Verify Account Holder permissions:
     - `UserRoles.accountHolderPermissions` list
   - Verify Account Holder in permission checks:
     - `UserRoles.hasPermission` handles Account Holder
     - `UserRoles.getPermissions` returns Account Holder permissions
   - Verify Account Holder in role hierarchy:
     - `UserRoles.getRoleLevel` includes Account Holder
     - `UserRoles.canManageRole` handles Account Holder
   - Verify Account Holder display:
     - `UserRoles.getRoleDisplayName` returns "Account Holder"
     - `UserRoles.getRoleDescription` returns description

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Account Holder is NOT in UserRoles (missing)
- ✅ **When implemented**: Account Holder is added to UserRoles
- ✅ All UserRoles methods support Account Holder
- ✅ Account Holder has highest permissions

---

## Test Case 12: Permission Template Management UI - Missing Feature

**Objective**: Verify permission templates can be managed via UI (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- Permission template management feature is implemented

**Steps**:
1. Navigate to Settings or Permission Management screen
2. Locate "Permission Templates" or "Role Templates" section
3. Verify one of the following:
   - **If NOT implemented**: Permission template management is not available (this is expected - feature missing)
   - **If implemented**: Permission template management UI exists
4. If implemented:
   - View existing templates:
     - Account Holder template
     - Admin template
     - Member template
     - Lead template (if exists)
   - Edit template:
     - Select a template
     - Modify permissions (add/remove)
     - Save template
     - Verify template is updated
   - Create custom template:
     - Create new template
     - Name the template
     - Select permissions
     - Save template
     - Verify template is created
   - Delete template:
     - Delete custom template
     - Verify template is removed
   - Verify templates are saved to Firebase

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permission template management UI is NOT available (missing)
- ✅ **When implemented**: Templates can be managed via UI
- ✅ Templates are saved to Firebase
- ✅ Templates can be edited/created/deleted

---

## Test Case 13: Custom Role Creation - Missing Feature

**Objective**: Verify custom roles can be created (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- Custom role creation feature is implemented

**Steps**:
1. Navigate to Role Management or Permission Management screen
2. Locate "Create Custom Role" option
3. Verify one of the following:
   - **If NOT implemented**: Custom role creation is not available (this is expected - feature missing)
   - **If implemented**: Custom role creation UI exists
4. If implemented:
   - Create custom role:
     - Enter role name (e.g., "Project Manager")
     - Enter role description
     - Select permissions for the role
     - Save role
   - Verify role is created:
     - Role appears in role list
     - Role can be assigned to users
     - Permissions work correctly
   - Assign custom role to user:
     - Select user
     - Assign custom role
     - Verify user has custom role permissions
   - Edit custom role:
     - Modify permissions
     - Save changes
     - Verify permissions are updated for users with this role
   - Delete custom role:
     - Delete custom role
     - Verify users with this role are handled appropriately

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Custom role creation is NOT available (missing)
- ✅ **When implemented**: Custom roles can be created
- ✅ Custom roles can be assigned to users
- ✅ Custom role permissions work correctly

---

## Test Case 14: Permission Matrix View - Missing Feature

**Objective**: Verify permission matrix can be viewed (if implemented).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- Permission matrix feature is implemented

**Steps**:
1. Navigate to Permission Management or Role Management screen
2. Locate "Permission Matrix" or "Role Comparison" option
3. Verify one of the following:
   - **If NOT implemented**: Permission matrix is not available (this is expected - feature missing)
   - **If implemented**: Permission matrix view exists
4. If implemented:
   - View permission matrix:
     - Matrix shows roles vs permissions
     - Checkmarks indicate which roles have which permissions
     - Matrix is easy to read and compare
   - Compare roles:
     - Select multiple roles
     - View side-by-side comparison
     - See differences in permissions
   - Export matrix (if implemented):
     - Export to CSV or PDF
     - Verify export works

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permission matrix is NOT available (missing)
- ✅ **When implemented**: Permission matrix can be viewed
- ✅ Matrix is clear and easy to understand
- ✅ Role comparison works

---

## Test Case 15: Permission Enforcement - Projects

**Objective**: Verify permissions are enforced for project operations.

**Preconditions**:
- User A is logged in
- User A has specific permissions for projects
- Project exists
- Permission enforcement feature is implemented

**Steps**:
1. Verify User A's project permissions:
   - Check permissions in Profile or Permission Management
   - Note which project permissions User A has
2. Test project operations:
   - **Create Project**: If has `create_projects` permission
   - **Edit Project**: If has `manage_projects` permission
   - **Delete Project**: If has `manage_projects` permission
   - **Assign Project**: If has `assign_projects` permission
3. Verify one of the following:
   - **If NOT implemented**: Permissions may not be enforced (this is expected - enforcement missing)
   - **If implemented**: Permissions are enforced
4. If implemented:
   - Try to create project without permission:
     - Verify action is blocked
     - Verify error message appears
   - Try to edit project without permission:
     - Verify action is blocked
     - Verify error message appears
   - Try to delete project without permission:
     - Verify action is blocked
     - Verify error message appears
5. Grant permissions
6. Verify operations work after granting permissions

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permission enforcement may not be fully implemented
- ✅ **When implemented**: Permissions are enforced for project operations
- ✅ Error messages are clear
- ✅ Operations work after granting permissions

---

## Test Case 16: Permission Enforcement - Tasks

**Objective**: Verify permissions are enforced for task operations.

**Preconditions**:
- User A is logged in
- User A has specific permissions for tasks
- Task exists
- Permission enforcement feature is implemented

**Steps**:
1. Verify User A's task permissions
2. Test task operations:
   - **Create Task**: If has `create_tasks` permission
   - **Assign Task**: If has `assign_tasks` permission
   - **Update Task Status**: If has `update_task_status` permission
   - **Delete Task**: If has `delete_tasks` permission
   - **Set Task Priority**: If has `set_task_priority` permission
   - **Set Task Deadline**: If has `set_task_deadline` permission
3. Verify permissions are enforced (if implemented)
4. Test without permissions:
   - Try operations without required permissions
   - Verify actions are blocked
   - Verify error messages appear

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permission enforcement may not be fully implemented
- ✅ **When implemented**: Permissions are enforced for task operations
- ✅ All task operations check permissions
- ✅ Error messages are clear

---

## Test Case 17: Permission Enforcement - Teams

**Objective**: Verify permissions are enforced for team operations.

**Preconditions**:
- User A is logged in
- User A has specific permissions for teams
- Team exists
- Permission enforcement feature is implemented

**Steps**:
1. Verify User A's team permissions
2. Test team operations:
   - **View Team Data**: If has `view_team_data` permission
   - **Manage Team Members**: If has appropriate permission
   - **Assign Tasks to Team**: If has `assign_tasks` permission
3. Verify permissions are enforced (if implemented)
4. Test without permissions:
   - Try to view team data without permission
   - Verify data is not accessible
   - Verify error message appears

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permission enforcement may not be fully implemented
- ✅ **When implemented**: Permissions are enforced for team operations
- ✅ Team data access is controlled
- ✅ Error messages are clear

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] User roles are displayed correctly
- [ ] Workspace roles are displayed correctly
- [ ] Account Holder role is mapped to User.role (if implemented)
- [ ] Lead role can be assigned per workspace/team (if implemented)
- [ ] Custom permission sets for projects work (if implemented)
- [ ] Custom permission sets for tasks work (if implemented)
- [ ] Custom permission sets for teams work (if implemented)
- [ ] Permission inheritance and override work (if implemented)
- [ ] Role bridge works (if implemented)
- [ ] Permission checks use workspace role (if implemented)
- [ ] Account Holder is in UserRoles (if implemented)
- [ ] Permission template management UI works (if implemented)
- [ ] Custom role creation works (if implemented)
- [ ] Permission matrix can be viewed (if implemented)
- [ ] Permissions are enforced for projects (if implemented)
- [ ] Permissions are enforced for tasks (if implemented)
- [ ] Permissions are enforced for teams (if implemented)

---

## Known Issues (Based on Audit Report)

1. **Account Holder Role Missing from UserRoles**:
   - `UserRoles` doesn't have Account Holder role
   - Account Holder exists only in `WorkspaceRole`
   - **Status**: ⛔ Missing

2. **Lead Role Missing**:
   - Lead role is not in `WorkspaceRole` enum
   - Lead per workspace/team is not supported
   - **Status**: ⛔ Missing

3. **No Role Bridge**:
   - `User.role` (UserRoles) and `WorkspaceMember.role` (WorkspaceRole) are separate
   - No bridge between the two systems
   - **Status**: ⛔ Missing

4. **No Custom Permission Sets**:
   - Custom permission sets for projects/tasks/teams are not implemented
   - No UI for managing custom permissions
   - **Status**: ⛔ Missing

5. **Permission Templates Hardcoded**:
   - Permission templates are hardcoded in `DefaultPermissionSets`
   - Cannot be edited via UI
   - **Status**: ⚠️ Partial

---

## Notes for Testers

1. **Current Status**: Roles and permissions are partially implemented. Two separate role systems exist (`UserRoles` and `WorkspaceRole`) that are not bridged.

2. **Role Systems**: 
   - `UserRoles`: admin, departmentManager, teamLead, regularUser (used in `User.role`)
   - `WorkspaceRole`: accountHolder, admin, member (used in `WorkspaceMember.role`)
   - These are separate and not integrated

3. **Account Holder**: Exists in `WorkspaceRole` but not in `UserRoles`. This means `User.role` doesn't reflect Account Holder status.

4. **Lead Role**: Mentioned in requirements but not implemented in `WorkspaceRole` enum.

5. **Custom Permissions**: Individual permissions can be granted/revoked, but custom permission sets for projects/tasks/teams are not implemented.

6. **Permission Templates**: Currently hardcoded in `DefaultPermissionSets`. Cannot be edited via UI.

7. **Permission Enforcement**: Some permission checks exist but may not be comprehensive across all operations.

8. **Role Bridge**: Need to bridge `User.role` with `WorkspaceRole` so that workspace roles are reflected in user permissions.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- User roles (Account Holder, Admin, Member, Lead if exists)
- Workspace context
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase data (if accessible) showing user roles and permissions
- Whether role bridge is working (does User.role reflect workspace role?)
