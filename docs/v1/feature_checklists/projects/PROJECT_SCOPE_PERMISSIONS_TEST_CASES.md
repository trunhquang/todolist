# Project Scope & Permissions (Workspace + Role/Team; Project Membership Assign/Revoke/Roles) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Project Scope & Permissions** feature (workspace + role/team; project membership assign/revoke/roles). This feature is currently **PARTIAL** - workspace scoping is present (`workspaceId`), but no dedicated project member roles/permissions or UI to assign/revoke exists.

## Prerequisites
- User must be logged in
- Workspace should exist
- Projects should exist
- Workspace members should exist
- Teams should exist (for team-based access tests)
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: Verify Workspace Scoping - Projects Filtered by Workspace

**Objective**: Verify projects are filtered by workspace correctly.

**Preconditions**:
- User is logged in
- User is member of multiple workspaces
- Each workspace has projects
- Workspace scoping is implemented

**Steps**:
1. Switch to Workspace A
2. Navigate to Project List page
3. Verify only Workspace A's projects are displayed:
   - Projects from Workspace A are shown
   - Projects from other workspaces are NOT shown
4. Create a project in Workspace A:
   - Verify project is created
   - Verify project appears in list
   - Verify project has Workspace A's workspaceId
5. Switch to Workspace B
6. Navigate to Project List page
7. Verify only Workspace B's projects are displayed:
   - Projects from Workspace B are shown
   - Projects from Workspace A are NOT shown
   - Project created in Workspace A is NOT shown

**Expected Results**:
- ✅ Projects are filtered by workspace
- ✅ Only current workspace's projects are shown
- ✅ Workspace switching updates project list

---

## Test Case 2: View Project Members - Missing Feature

**Objective**: Verify project members can be viewed (currently missing).

**Preconditions**:
- User is logged in
- User has permission to view project members
- Project exists
- Project has members assigned
- View project members feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Verify one of the following:
   - **If NOT implemented**: "Members" or "Team" section is not available (this is expected - feature missing)
   - **If implemented**: "Members" or "Team" section appears
5. If implemented:
   - Verify members section shows:
     - List of project members
     - Member name
     - Member role in project
     - Member email (if available)
     - Member avatar (if available)
   - Verify member count is displayed:
     - "X members" or similar
   - Verify members are accurate:
     - Only project members are shown
     - Workspace members who are not project members are NOT shown

**Expected Results**:
- ⚠️ **CURRENT STATUS**: View project members is NOT available (missing)
- ✅ **When implemented**: Project members can be viewed
- ✅ Member information is displayed correctly
- ✅ Only project members are shown

---

## Test Case 3: Assign Member to Project - Missing Feature

**Objective**: Verify member can be assigned to a project (currently missing).

**Preconditions**:
- User is logged in
- User has `manageProjects` or project-specific permission
- Project exists
- Workspace members exist
- Assign member to project feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Verify one of the following:
   - **If NOT implemented**: "Add Member" or "Assign Member" button is not available (this is expected - feature missing)
   - **If implemented**: "Add Member" or "Assign Member" button exists
5. If implemented:
   - Tap "Add Member" button
   - Verify member selector appears:
     - List of available workspace members
     - Member name displayed
     - Member role in workspace displayed
     - Members already in project are marked or excluded
   - Select a member
   - Verify role selector appears (if project roles exist):
     - Project Owner
     - Project Manager
     - Project Member
     - Or custom roles
   - Select a role (if applicable)
   - Confirm assignment
   - Verify loading indicator appears
   - Wait for assignment to complete
   - Verify success message appears: "Member added to project"
   - Verify member appears in project members list:
     - Member name is displayed
     - Member role is displayed
   - Verify member is saved to Firebase:
     - Check Firebase data
     - Verify project member record exists
     - Verify member has correct projectId and role

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Assign member to project is NOT available (missing)
- ✅ **When implemented**: Member can be assigned to project
- ✅ Member appears in project members list
- ✅ Member is saved to Firebase

---

## Test Case 4: Revoke Member from Project - Missing Feature

**Objective**: Verify member can be revoked from a project (currently missing).

**Preconditions**:
- User is logged in
- User has `manageProjects` or project-specific permission
- Project exists
- Project has members assigned
- Revoke member from project feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Locate a project member
5. Verify one of the following:
   - **If NOT implemented**: "Remove" or "Revoke" option is not available (this is expected - feature missing)
   - **If implemented**: "Remove" or "Revoke" option exists
6. If implemented:
   - Tap "Remove" option
   - Verify confirmation dialog appears:
     - Warning message about removing member from project
     - Member name displayed
     - Confirm button
   - Confirm removal
   - Verify loading indicator appears
   - Wait for removal to complete
   - Verify success message appears: "Member removed from project"
   - Verify member is removed from project members list:
     - Member no longer appears
     - Member count decreases
   - Verify member is updated in Firebase:
     - Check Firebase data
     - Verify project member record is removed or marked inactive
     - Verify member still exists in workspace (not deleted)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Revoke member from project is NOT available (missing)
- ✅ **When implemented**: Member can be revoked from project
- ✅ Member is removed from project
- ✅ Member is not deleted from workspace

---

## Test Case 5: Assign Project Role to Member - Missing Feature

**Objective**: Verify project role can be assigned to a member (currently missing).

**Preconditions**:
- User is logged in
- User has `manageProjects` or project-specific permission
- Project exists
- Project member exists
- Project roles exist (Project Owner, Project Manager, Project Member, etc.)
- Assign project role feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Locate a project member
5. Verify one of the following:
   - **If NOT implemented**: "Change Role" option is not available (this is expected - feature missing)
   - **If implemented**: "Change Role" option exists
6. If implemented:
   - Tap "Change Role" option
   - Verify role selector appears:
     - List of available project roles
     - Current role highlighted
     - Role description displayed (if available)
   - Select a new role (e.g., "Project Manager")
   - Confirm role change
   - Verify loading indicator appears
   - Wait for role change to complete
   - Verify success message appears: "Member role updated"
   - Verify member role is updated:
     - New role is displayed
     - Permissions are updated (if role-based permissions exist)
   - Verify role is saved to Firebase:
     - Check Firebase data
     - Verify member has correct project role

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Assign project role is NOT available (missing)
- ✅ **When implemented**: Project role can be assigned to member
- ✅ Role is updated correctly
- ✅ Permissions are updated (if applicable)

---

## Test Case 6: Project Access Control - View Project Permission

**Objective**: Verify project access is controlled by permissions (when implemented).

**Preconditions**:
- User is logged in
- Project exists
- Project has access control implemented
- User may or may not have access to project

**Steps**:
1. Navigate to Project List page
2. Verify one of the following:
   - **If NOT implemented**: All workspace projects are shown (this is expected - access control missing)
   - **If implemented**: Only accessible projects are shown
3. If implemented:
   - As user with `viewAllData` permission:
     - Verify all projects are shown
   - As user with `viewTeamData` permission:
     - Verify only team projects are shown
   - As user with `viewPersonalData` permission:
     - Verify only personal projects are shown
   - As project member:
     - Verify assigned projects are shown
   - As non-member:
     - Verify non-assigned projects are NOT shown
4. Try to access a project directly (if possible):
   - Navigate to project detail page
   - Verify one of the following:
     - **If NOT implemented**: Project is accessible (this is expected - access control missing)
     - **If implemented**: Project is accessible only if user has permission
   - If access control exists:
     - Verify error message appears if no permission: "You don't have permission to view this project"

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Project access control may not be fully implemented
- ✅ **When implemented**: Project access is controlled by permissions
- ✅ Only accessible projects are shown
- ✅ Error messages are clear

---

## Test Case 7: Project Access Control - Edit Project Permission

**Objective**: Verify project editing is controlled by permissions (when implemented).

**Preconditions**:
- User is logged in
- Project exists
- User has different permissions
- Project edit permission control is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Verify one of the following:
   - **If NOT implemented**: "Edit" button is visible to all users (this is expected - permission check missing)
   - **If implemented**: "Edit" button is shown/hidden based on permissions
4. If implemented:
   - As user with `manageProjects` permission:
     - Verify "Edit" button is visible
     - Verify can edit project
   - As project owner/manager:
     - Verify "Edit" button is visible
     - Verify can edit project
   - As project member:
     - Verify "Edit" button is hidden or disabled
     - Verify cannot edit project
   - As non-member:
     - Verify "Edit" button is hidden
     - Verify cannot edit project
5. Try to edit project directly (if possible):
   - Navigate to edit project page
   - Verify one of the following:
     - **If NOT implemented**: Edit page is accessible (this is expected - permission check missing)
     - **If implemented**: Edit page shows error if no permission

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Edit permission check may not be fully implemented
- ✅ **When implemented**: Project editing is controlled by permissions
- ✅ Edit button is shown/hidden based on permissions
- ✅ Error messages are clear

---

## Test Case 8: Team-Based Project Access - Missing Feature

**Objective**: Verify projects can be assigned to teams and team members can access them (currently missing).

**Preconditions**:
- User is logged in
- User has `assignProjects` permission
- Project exists
- Team exists with members
- Team-based project access is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Verify one of the following:
   - **If NOT implemented**: "Assign to Team" option is not available (this is expected - feature missing)
   - **If implemented**: "Assign to Team" option exists
5. If implemented:
   - Tap "Assign to Team" option
   - Verify team selector appears:
     - List of available teams
     - Team name displayed
     - Team member count displayed
   - Select a team
   - Confirm assignment
   - Verify project is assigned to team:
     - Project shows team assignment
     - Team members can view project
   - Verify project is updated in Firebase:
     - Check Firebase data
     - Verify project has `teamId` or `assignedTeamId` field
6. As Team A member:
   - Navigate to Project List page
   - Verify assigned project is displayed
   - Verify project is accessible
7. As Team B member:
   - Navigate to Project List page
   - Verify assigned project is NOT displayed (if Team B member doesn't have viewAllData)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Team-based project access is NOT available (missing)
- ✅ **When implemented**: Projects can be assigned to teams
- ✅ Team members can access assigned projects
- ✅ Project assignment affects visibility

---

## Test Case 9: Project Owner Role - Missing Feature

**Objective**: Verify project owner role exists and has full permissions (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Project owner role is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Verify one of the following:
   - **If NOT implemented**: Project owner is not displayed (this is expected - feature missing)
   - **If implemented**: Project owner is displayed
4. If implemented:
   - Verify project owner is shown:
     - "Owner: [Name]" or similar
     - Owner avatar (if available)
   - As project owner:
     - Verify full permissions:
       - Can edit project
       - Can delete project
       - Can manage project members
       - Can assign/revoke members
       - Can change project roles
   - Verify project owner cannot be removed:
     - "Remove" option is disabled or hidden for owner
     - Error message if trying to remove owner

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Project owner role is NOT available (missing)
- ✅ **When implemented**: Project owner role exists
- ✅ Owner has full permissions
- ✅ Owner cannot be removed

---

## Test Case 10: Project Manager Role - Missing Feature

**Objective**: Verify project manager role exists and has management permissions (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Project manager role is implemented
- User is assigned as project manager

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Assign user as project manager (if not already)
4. Verify one of the following:
   - **If NOT implemented**: Project manager role is not available (this is expected - feature missing)
   - **If implemented**: Project manager role exists
5. If implemented:
   - As project manager:
     - Verify management permissions:
       - Can edit project (except delete)
       - Can manage project members
       - Can assign/revoke members
       - Can change project roles (except owner)
       - Can view all project data
   - Verify limitations:
     - Cannot delete project
     - Cannot remove project owner
     - Cannot change owner role

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Project manager role is NOT available (missing)
- ✅ **When implemented**: Project manager role exists
- ✅ Manager has management permissions
- ✅ Limitations are enforced

---

## Test Case 11: Project Member Role - Missing Feature

**Objective**: Verify project member role exists and has limited permissions (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Project member role is implemented
- User is assigned as project member

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Assign user as project member (if not already)
4. Verify one of the following:
   - **If NOT implemented**: Project member role is not available (this is expected - feature missing)
   - **If implemented**: Project member role exists
5. If implemented:
   - As project member:
     - Verify limited permissions:
       - Can view project
       - Can view project tasks
       - Can create tasks in project
       - Can update own tasks
       - Cannot edit project
       - Cannot delete project
       - Cannot manage project members
       - Cannot assign/revoke members
       - Cannot change project roles

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Project member role is NOT available (missing)
- ✅ **When implemented**: Project member role exists
- ✅ Member has limited permissions
- ✅ Restrictions are enforced

---

## Test Case 12: Project Member Management UI - Missing Feature

**Objective**: Verify UI exists for managing project members (currently missing).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Project member management UI is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Verify one of the following:
   - **If NOT implemented**: "Members" section or "Manage Members" button is not available (this is expected - feature missing)
   - **If implemented**: "Members" section or "Manage Members" button exists
5. If implemented:
   - Tap "Manage Members" or navigate to members section
   - Verify members management page appears:
     - List of project members
     - "Add Member" button
     - Member actions (Edit Role, Remove)
   - Verify UI elements:
     - Member name
     - Member role
     - Member email (if available)
     - Member avatar (if available)
     - Action buttons
   - Verify functionality:
     - Can add members
     - Can change member roles
     - Can remove members
   - Verify UI follows project rules:
     - Uses TD widgets
     - Uses AppStrings
     - Uses NavigationService
     - Uses SnackbarService

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Project member management UI is NOT available (missing)
- ✅ **When implemented**: UI exists for managing project members
- ✅ UI is functional
- ✅ UI follows project rules

---

## Test Case 13: Project Permission Inheritance from Workspace

**Objective**: Verify project permissions inherit from workspace permissions (when implemented).

**Preconditions**:
- User is logged in
- Workspace exists
- Project exists
- Permission inheritance is implemented

**Steps**:
1. As workspace Admin:
   - Verify can access all projects
   - Verify can manage all projects
2. As workspace Member:
   - Verify can access projects based on workspace permissions
   - Verify project access is limited by workspace role
3. Verify workspace permissions affect project access:
   - `viewAllData` → can view all projects
   - `viewTeamData` → can view team projects
   - `viewPersonalData` → can view personal projects
   - `manageProjects` → can manage projects
4. Verify project-specific permissions override workspace permissions (if applicable):
   - Project member can access project even without workspace `viewAllData`
   - Project member permissions are respected

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permission inheritance may not be fully implemented
- ✅ **When implemented**: Project permissions inherit from workspace
- ✅ Inheritance works correctly
- ✅ Project-specific permissions can override workspace permissions

---

## Test Case 14: Bulk Assign Members to Project - Missing Feature

**Objective**: Verify multiple members can be assigned to a project at once (currently missing).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Multiple workspace members exist
- Bulk assign feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Navigate to members section
5. Verify one of the following:
   - **If NOT implemented**: "Bulk Add" option is not available (this is expected - feature missing)
   - **If implemented**: "Bulk Add" or "Add Multiple" option exists
6. If implemented:
   - Tap "Bulk Add" option
   - Verify member selector appears:
     - List of available workspace members
     - Checkboxes for each member
     - "Select All" option
   - Select multiple members
   - Select default role (if applicable)
   - Confirm bulk assignment
   - Verify loading indicator appears
   - Wait for assignment to complete
   - Verify success message appears: "X members added to project"
   - Verify all selected members appear in project members list:
     - All members are displayed
     - All members have correct role

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Bulk assign is NOT available (missing)
- ✅ **When implemented**: Multiple members can be assigned at once
- ✅ All members are assigned correctly
- ✅ Success message shows count

---

## Test Case 15: Project Member Count Display

**Objective**: Verify project member count is displayed correctly.

**Preconditions**:
- User is logged in
- Project exists
- Project has members assigned
- Member count display is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Verify member count is displayed:
   - On project card: "X members" or similar
   - On project detail page: "Members: X" or similar
4. Verify count is accurate:
   - Count matches actual number of project members
   - Count excludes removed members
5. Add a new member to project:
   - Verify count increases
6. Remove a member from project:
   - Verify count decreases

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Member count may not be displayed
- ✅ **When implemented**: Member count is displayed
- ✅ Count is accurate
- ✅ Count updates when members change

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Projects are filtered by workspace
- [ ] Project members can be viewed (if implemented)
- [ ] Member can be assigned to project (if implemented)
- [ ] Member can be revoked from project (if implemented)
- [ ] Project role can be assigned to member (if implemented)
- [ ] Project access is controlled by permissions
- [ ] Project editing is controlled by permissions
- [ ] Projects can be assigned to teams (if implemented)
- [ ] Project owner role exists (if implemented)
- [ ] Project manager role exists (if implemented)
- [ ] Project member role exists (if implemented)
- [ ] Project member management UI exists (if implemented)
- [ ] Project permissions inherit from workspace
- [ ] Multiple members can be assigned at once (if implemented)
- [ ] Project member count is displayed correctly

---

## Known Issues (Based on Audit Report)

1. **Project Member Roles/Permissions Missing**:
   - No dedicated project member roles/permissions
   - No ProjectMember entity
   - No project-specific access control
   - **Status**: ⛔ Missing

2. **Project Member Management UI Missing**:
   - No UI to assign/revoke project members
   - No UI to manage project roles
   - **Status**: ⛔ Missing

3. **Workspace Scoping Exists**:
   - Projects have `workspaceId` field
   - Projects are filtered by workspace
   - **Status**: ✅ Implemented

4. **Workspace Permissions Exist**:
   - `WorkspacePermissions` has project-related permissions
   - `createProjects`, `manageProjects`, `assignProjects` exist
   - **Status**: ✅ Implemented

5. **Team-Based Access Missing**:
   - No team assignment for projects
   - No team-based project filtering
   - **Status**: ⛔ Missing

---

## Notes for Testers

1. **Current Status**: Workspace scoping exists (`workspaceId`), but project-specific membership, roles, and permissions are missing.

2. **Workspace vs Project Permissions**: Currently, only workspace-level permissions exist. Project-specific permissions need to be implemented.

3. **Project Members**: Currently, there's no concept of "project members". All workspace members can potentially access all projects (based on workspace permissions). Need to implement project-specific membership.

4. **Project Roles**: Need to implement project-specific roles (Project Owner, Project Manager, Project Member) separate from workspace roles.

5. **Access Control**: Need to implement project-level access control that checks both workspace permissions and project membership.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- User roles (Account Holder, Admin, Member)
- Workspace context
- Project context
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase data (if accessible) showing project data
- Whether project members are working
- Whether project roles are working
- Whether access control is working
