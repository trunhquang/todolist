# Role Matrix Test Cases

## Overview
This document contains step-by-step test cases for testing the **Role Matrix** feature (Account Holder, Admin, Member, Lead, custom permissions). This feature is currently **PARTIAL** - basic roles exist with default permission sets, but Lead role, custom role matrix UI, permission templates editing, and transfer ownership flows are missing.

## Prerequisites
- User must be logged into the application
- User must be Account Holder or Admin (for role management)
- User should have access to workspace with multiple members
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: View Available Roles

**Objective**: Verify available roles are displayed correctly.

**Preconditions**:
- User is logged in
- User has `manage_users` or `assign_permissions` permission
- User is on Role Management or Permission Management screen

**Steps**:
1. Navigate to role/permission management screen:
   - From Workspace Management, navigate to "Role Management" or "Permission Management"
   - OR navigate to User Management → Role Settings
2. Verify available roles are displayed:
   - Account Holder role is shown
   - Admin role is shown
   - Member role is shown
   - Lead role is shown (if implemented) OR not shown (if not implemented - current status)
3. For each role, verify:
   - Role name is displayed
   - Role description is displayed (if available)
   - Default permissions are listed (if available)
4. Verify role hierarchy is clear (Account Holder > Admin > Member > Lead)

**Expected Results**:
- ✅ Account Holder, Admin, Member roles are displayed
- ⚠️ **CURRENT STATUS**: Lead role is NOT displayed (missing)
- ✅ Role information is accurate
- ✅ Role hierarchy is clear

---

## Test Case 2: View Default Permission Sets

**Objective**: Verify default permission sets for each role are displayed correctly.

**Preconditions**:
- User is logged in
- User has `assign_permissions` permission
- User is on Role Management or Permission Management screen

**Steps**:
1. Navigate to Role Management or Permission Management screen
2. Select Account Holder role
3. Verify Account Holder default permissions are displayed:
   - Manage Workspace
   - Manage Users
   - Assign Permissions
   - Create Tasks
   - Assign Tasks
   - Update Task Status
   - Delete Tasks
   - Set Task Priority
   - Set Task Deadline
   - Create Projects
   - Manage Projects
   - Assign Projects
   - View All Data
   - View Team Data
   - View Personal Data
   - Generate Reports
   - View Analytics
   - Invite Users
   - Remove Users
4. Select Admin role
5. Verify Admin default permissions are displayed (subset of Account Holder)
6. Select Member role
7. Verify Member default permissions are displayed (minimal set)
8. Verify permission descriptions are shown (if available)

**Expected Results**:
- ✅ Default permission sets are displayed for each role
- ✅ Account Holder has all permissions
- ✅ Admin has subset of permissions
- ✅ Member has minimal permissions
- ✅ Permission descriptions are clear

---

## Test Case 3: Assign Role to User

**Objective**: Verify role can be assigned to a user.

**Preconditions**:
- User is logged in
- User has `manage_users` permission
- Workspace has at least one member
- User is on User Management screen

**Steps**:
1. Navigate to User Management screen
2. Locate a member in the list
3. Tap on the member card/item
4. Verify "Edit Role" option is available
5. Tap "Edit Role" option
6. Verify role selection dialog appears with:
   - Current role selected
   - Available roles: Admin, Member (Account Holder should not be available for assignment)
   - Lead role option (if implemented) OR not shown (if not implemented)
7. Select a different role (e.g., change Member to Admin)
8. Tap "Save" button
9. Verify loading indicator appears
10. Wait for role update to complete
11. Verify success message appears
12. Verify member's role is updated in the list
13. Verify member's permissions are updated to match new role's default permissions

**Expected Results**:
- ✅ Role can be assigned to user
- ✅ Role assignment succeeds
- ✅ Permissions are updated to match role
- ✅ Role change is persisted

---

## Test Case 4: Assign Lead Role (CURRENTLY MISSING)

**Objective**: Verify Lead role can be assigned (if implemented).

**Preconditions**:
- User is logged in
- User has `manage_users` permission
- Workspace has at least one member
- Lead role is implemented

**Steps**:
1. Navigate to User Management screen
2. Locate a member in the list
3. Tap on the member card/item
4. Tap "Edit Role" option
5. Verify Lead role is available in role selection
6. Select Lead role
7. Tap "Save" button
8. Verify loading indicator appears
9. Wait for role update to complete
10. Verify success message appears
11. Verify member's role is updated to Lead
12. Verify member's permissions match Lead role's default permissions

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Lead role is NOT available (missing)
- ✅ **When implemented**: Lead role can be assigned
- ✅ Lead role permissions are applied correctly

---

## Test Case 5: View Custom Permission Sets

**Objective**: Verify custom permission sets can be viewed (if implemented).

**Preconditions**:
- User is logged in
- User has `assign_permissions` permission
- Workspace has members with custom permissions
- User is on Permission Management screen

**Steps**:
1. Navigate to Permission Management screen
2. Locate a member with custom permissions
3. Verify member's custom permissions are displayed
4. Verify custom permissions are distinct from role default permissions
5. Verify permission categories are grouped (if implemented):
   - Workspace Management
   - Task Management
   - Project Management
   - Data Access
   - Reports & Analytics
   - Invitations
6. Verify each permission shows:
   - Permission name
   - Permission description
   - Enabled/disabled state

**Expected Results**:
- ✅ Custom permissions are displayed
- ✅ Permissions are organized by category
- ✅ Permission information is clear

**Note**: Custom permission sets may exist but UI may not fully support viewing/editing.

---

## Test Case 6: Edit Permission Template for Role (CURRENTLY MISSING)

**Objective**: Verify permission templates can be edited for roles (if implemented).

**Preconditions**:
- User is logged in
- User is Account Holder (only Account Holder can edit templates)
- User is on Role Management screen

**Steps**:
1. Navigate to Role Management screen
2. Locate "Permission Templates" or "Edit Role Permissions" section
3. Verify one of the following:
   - **If implemented**: Permission template editing UI is available
   - **If NOT implemented**: UI is not available (this is expected)
4. If implemented:
   - Select a role (e.g., Admin or Member)
   - Verify current permission template is displayed
   - Toggle permissions on/off
   - Add custom permissions (if supported)
   - Tap "Save Template" button
   - Verify success message appears
   - Verify template is saved
   - Verify new members assigned this role get updated permissions

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permission template editing UI is NOT available (missing)
- ✅ **When implemented**: Permission templates can be edited
- ✅ Template changes affect new role assignments
- ✅ Only Account Holder can edit templates

---

## Test Case 7: Create Custom Role (CURRENTLY MISSING)

**Objective**: Verify custom roles can be created (if implemented).

**Preconditions**:
- User is logged in
- User is Account Holder (only Account Holder can create custom roles)
- User is on Role Management screen

**Steps**:
1. Navigate to Role Management screen
2. Locate "Create Custom Role" or "Add Role" button
3. Verify one of the following:
   - **If implemented**: "Create Custom Role" button is available
   - **If NOT implemented**: Button is not available (this is expected)
4. If implemented:
   - Tap "Create Custom Role" button
   - Verify role creation dialog/form appears
   - Enter role name: "Project Manager"
   - Enter role description: "Manages projects and assigns tasks"
   - Select permissions for the role
   - Tap "Create Role" button
   - Verify success message appears
   - Verify custom role appears in roles list
   - Verify custom role can be assigned to users

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Custom role creation is NOT available (missing)
- ✅ **When implemented**: Custom roles can be created
- ✅ Custom roles can be assigned to users
- ✅ Custom roles have their own permission sets

---

## Test Case 8: View Role Matrix/Comparison

**Objective**: Verify role matrix/comparison view is available (if implemented).

**Preconditions**:
- User is logged in
- User has `assign_permissions` permission
- User is on Role Management screen

**Steps**:
1. Navigate to Role Management screen
2. Locate "Role Matrix" or "Compare Roles" option
3. Verify one of the following:
   - **If implemented**: Role matrix view is available
   - **If NOT implemented**: View is not available (this is expected)
4. If implemented:
   - Tap "Role Matrix" option
   - Verify matrix view displays:
     - Roles as columns (Account Holder, Admin, Member, Lead, Custom)
     - Permissions as rows
     - Checkmarks/X marks for each role-permission combination
   - Verify matrix is easy to read and compare
   - Verify matrix can be exported (if supported)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Role matrix view is NOT available (missing)
- ✅ **When implemented**: Role matrix is displayed clearly
- ✅ Matrix shows all roles and permissions
- ✅ Matrix is easy to compare

---

## Test Case 9: Transfer Account Holder Role (CURRENTLY MISSING)

**Objective**: Verify Account Holder role can be transferred to another user (if implemented).

**Preconditions**:
- User is logged in
- User is Account Holder
- Workspace has at least one Admin or Member
- User is on Role Management or User Management screen

**Steps**:
1. Navigate to Role Management or User Management screen
2. Locate "Transfer Ownership" or "Transfer Account Holder" option
3. Verify one of the following:
   - **If implemented**: Transfer ownership option is available
   - **If NOT implemented**: Option is not available (this is expected)
4. If implemented:
   - Tap "Transfer Ownership" option
   - Verify transfer dialog appears with:
     - Warning message about transferring ownership
     - List of eligible users (Admin or Member)
     - Confirmation required
   - Select a user to transfer ownership to
   - Enter confirmation text (e.g., "TRANSFER" or user's email)
   - Tap "Transfer Ownership" button
   - Verify final confirmation dialog appears
   - Confirm transfer
   - Verify loading indicator appears
   - Wait for transfer to complete
   - Verify success message appears
   - Verify current user's role changes to Admin (or previous role)
   - Verify selected user's role changes to Account Holder
   - Verify transfer is logged (if audit logging exists)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Transfer ownership flow is NOT available (missing)
- ✅ **When implemented**: Account Holder can transfer ownership
- ✅ Transfer requires confirmation
- ✅ Roles are updated correctly
- ✅ Transfer is logged

---

## Test Case 10: Permission Inheritance from Role

**Objective**: Verify permissions are inherited from role when role is assigned.

**Preconditions**:
- User is logged in
- User has `manage_users` permission
- Workspace has a member with custom permissions
- User is on User Management screen

**Steps**:
1. Navigate to User Management screen
2. Locate a member with custom permissions
3. Note the member's current permissions
4. Change the member's role (e.g., from Member to Admin)
5. Verify one of the following behaviors:
   - **Option A**: Permissions are replaced with role default permissions
   - **Option B**: Permissions are merged with role default permissions
   - **Option C**: User is asked to choose (replace or merge)
6. Verify permissions are updated correctly
7. Change role back to original
8. Verify permissions behavior is consistent

**Expected Results**:
- ✅ Permissions are updated when role changes
- ✅ Permission inheritance behavior is clear
- ✅ Behavior is consistent

**Note**: Current implementation may vary - document actual behavior.

---

## Test Case 11: Custom Permissions Override Role Defaults

**Objective**: Verify custom permissions can override role default permissions.

**Preconditions**:
- User is logged in
- User has `assign_permissions` permission
- Workspace has a member
- User is on Permission Management screen

**Steps**:
1. Navigate to Permission Management screen
2. Locate a member
3. Verify member's current permissions (from role defaults)
4. Toggle a permission that is NOT in role defaults (e.g., grant "Manage Workspace" to a Member)
5. Verify permission is granted
6. Verify permission persists after refresh
7. Toggle a permission that IS in role defaults (e.g., revoke "Create Tasks" from a Member)
8. Verify permission is revoked
9. Verify permission persists after refresh
10. Verify custom permissions override role defaults

**Expected Results**:
- ✅ Custom permissions can be granted
- ✅ Custom permissions can override role defaults
- ✅ Permission changes persist
- ✅ Custom permissions are displayed correctly

---

## Test Case 12: Role-Based Access Control Verification

**Objective**: Verify role-based access control works correctly.

**Preconditions**:
- User is logged in
- Workspace has members with different roles (Account Holder, Admin, Member)
- Test with different user accounts

**Steps**:
1. As Account Holder:
   - Verify can access all features
   - Verify can manage workspace
   - Verify can manage users
   - Verify can assign permissions
   - Verify can delete workspace
2. As Admin:
   - Verify can manage users
   - Verify can assign tasks
   - Verify can create projects
   - Verify CANNOT manage workspace (if restricted)
   - Verify CANNOT delete workspace
3. As Member:
   - Verify can create tasks
   - Verify can update own tasks
   - Verify CANNOT manage users
   - Verify CANNOT assign tasks to others
   - Verify CANNOT create projects (if restricted)
4. Verify access control matches role permissions

**Expected Results**:
- ✅ Role-based access control works correctly
- ✅ Each role has appropriate access
- ✅ Restrictions are enforced
- ✅ Permissions match role definitions

---

## Test Case 13: Lead Role Permissions (CURRENTLY MISSING)

**Objective**: Verify Lead role has appropriate permissions (if implemented).

**Preconditions**:
- User is logged in
- User has `manage_users` permission
- Lead role is implemented
- Workspace has a member assigned Lead role

**Steps**:
1. Navigate to Permission Management screen
2. Locate a member with Lead role
3. Verify Lead role permissions are displayed
4. Verify Lead role has permissions for:
   - Managing team/group
   - Assigning tasks to team members
   - Viewing team data
   - Creating tasks
   - Updating task status
5. Verify Lead role does NOT have:
   - Manage workspace permission
   - Manage users permission (or limited)
   - Delete workspace permission
6. Test Lead role access:
   - As Lead, verify can manage team
   - As Lead, verify can assign tasks to team members
   - As Lead, verify cannot manage workspace

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Lead role is NOT implemented
- ✅ **When implemented**: Lead role has appropriate permissions
- ✅ Lead role access control works correctly

---

## Test Case 14: Permission Template Persistence

**Objective**: Verify permission template changes persist correctly.

**Preconditions**:
- User is logged in
- User is Account Holder
- Permission template editing is implemented
- User has edited a permission template

**Steps**:
1. Edit a permission template (e.g., Admin role)
2. Save the template
3. Verify success message appears
4. Close the app
5. Reopen the app
6. Navigate to Role Management screen
7. Verify edited permission template is still saved
8. Assign the role to a new user
9. Verify new user gets updated permissions from template

**Expected Results**:
- ✅ Permission template changes persist
- ✅ Templates are saved to Firebase
- ✅ New role assignments use updated templates

**Note**: This test case applies when template editing is implemented.

---

## Test Case 15: Role Assignment Validation

**Objective**: Verify role assignment has proper validation.

**Preconditions**:
- User is logged in
- User has `manage_users` permission
- User is on User Management screen

**Steps**:
1. Navigate to User Management screen
2. Try to assign Account Holder role to a user
3. Verify one of the following:
   - Account Holder role is not available for assignment
   - OR error message appears: "Cannot assign Account Holder role"
4. Try to assign role to yourself
5. Verify one of the following:
   - Self-assignment is prevented
   - OR warning message appears
6. Try to assign role when user is not a member
7. Verify appropriate error handling

**Expected Results**:
- ✅ Role assignment validation works
- ✅ Account Holder cannot be assigned
- ✅ Self-assignment is prevented (if applicable)
- ✅ Appropriate error messages are shown

---

## Test Case 16: Permission Matrix Export (CURRENTLY MISSING)

**Objective**: Verify permission matrix can be exported (if implemented).

**Preconditions**:
- User is logged in
- User has `assign_permissions` permission
- Permission matrix view is implemented
- User is on Role Management screen

**Steps**:
1. Navigate to Role Management screen
2. Open Role Matrix view
3. Locate "Export" or "Download" button
4. Verify one of the following:
   - **If implemented**: Export button is available
   - **If NOT implemented**: Export is not available (this is expected)
5. If implemented:
   - Tap "Export" button
   - Select export format (CSV, PDF, Excel)
   - Verify file is downloaded
   - Open exported file
   - Verify matrix data is correct

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permission matrix export is NOT available (missing)
- ✅ **When implemented**: Matrix can be exported
- ✅ Exported data is accurate

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Available roles are displayed (Account Holder, Admin, Member)
- [ ] Lead role is available (when implemented)
- [ ] Default permission sets are displayed for each role
- [ ] Roles can be assigned to users
- [ ] Permission templates can be edited (when implemented)
- [ ] Custom roles can be created (when implemented)
- [ ] Role matrix view is available (when implemented)
- [ ] Account Holder can transfer ownership (when implemented)
- [ ] Permissions are inherited from roles
- [ ] Custom permissions can override role defaults
- [ ] Role-based access control works correctly
- [ ] Permission template changes persist
- [ ] Role assignment validation works

---

## Known Issues (Based on Audit Report)

1. **Lead Role Missing**: 
   - Lead role is not in `WorkspaceRole` enum
   - Cannot assign Lead role to users
   - **Status**: ⚠️ Not Implemented

2. **Custom Role Matrix UI Missing**:
   - No UI for creating custom roles
   - No UI for managing role matrix
   - **Status**: ⚠️ Not Implemented

3. **Permission Templates Editing Missing**:
   - No UI for editing permission templates for roles
   - Templates are hardcoded in `DefaultPermissionSets`
   - **Status**: ⚠️ Not Implemented

4. **Transfer Ownership Flow Missing**:
   - No flow to transfer Account Holder role
   - No use case/controller/UI for ownership transfer
   - **Status**: ⚠️ Not Implemented

---

## Notes for Testers

1. **Current Roles**: Only Account Holder, Admin, and Member are available. Lead role is missing.

2. **Permission Templates**: Default permission sets exist in code (`DefaultPermissionSets`) but cannot be edited via UI.

3. **Custom Roles**: Cannot create custom roles - only predefined roles are available.

4. **Transfer Ownership**: Account Holder cannot transfer ownership to another user - this feature is missing.

5. **Permission Inheritance**: When assigning a role, permissions may be replaced or merged - document actual behavior.

6. **Role Hierarchy**: Account Holder > Admin > Member. Lead role should fit between Admin and Member (when implemented).

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- User role and permissions
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
