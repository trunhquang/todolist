# Members & Teams (Add/Remove User to Team/Group, Assign Lead, Cascading) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Members & Teams** feature (add/remove user to Team/Group, assign lead, cascading permissions). This feature is currently **PARTIAL** - workspace hierarchy helpers exist (`WorkspaceRepositoryImpl.updateManager/listTeam`, `WorkspaceMember.managerUserId`), but Team/Group assignment UI/flows, cascading permission enforcement to tasks/projects, and user listing/filter by role/status UI are missing.

## Prerequisites
- User must be logged in
- User should have Account Holder or Admin role (for team management)
- Workspace should have multiple members
- Teams/Groups should exist (or be creatable)
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: View Team Members - Current Implementation

**Objective**: Verify team members can be viewed using existing hierarchy helpers.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Workspace has teams/groups
- Teams have members assigned

**Steps**:
1. Navigate to Team Management or Team Detail page
2. Verify team members are displayed:
   - Team name is shown
   - Lead group user is displayed
   - Team members list is displayed
3. Verify one of the following:
   - **If implemented**: Team members are loaded using `listTeam` method
   - **If NOT implemented**: Team members may not be displayed correctly
4. Check team member details:
   - Member name
   - Member email
   - Member role
   - Manager relationship (if `managerUserId` is set)

**Expected Results**:
- ✅ Team members are displayed
- ✅ Lead group user is shown
- ⚠️ Team members may be loaded via `listTeam` but UI may be incomplete

---

## Test Case 2: Add User to Team - Missing Feature

**Objective**: Verify users can be added to teams via UI (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists (not in any team)
- Team A exists
- Add user to team feature is implemented

**Steps**:
1. Navigate to Team Management or Team Detail page
2. Select Team A
3. Verify one of the following:
   - **If NOT implemented**: "Add Member" or "Add User" option is not available (this is expected - feature missing)
   - **If implemented**: "Add Member" or "Add User" button/option is available
4. If implemented:
   - Tap "Add Member" button
   - Verify user selection dialog/screen appears:
     - List of available users (not in team)
     - Search functionality
     - User details (name, email, role)
   - Select User B
   - Confirm addition
   - Verify User B is added to Team A:
     - User B appears in team members list
     - Team member count increases
     - User B's `managerUserId` may be updated (if team has manager)
5. Verify Firebase data:
   - Check `TeamGroup.members` includes User B's ID
   - Check `WorkspaceMember.managerUserId` is updated (if applicable)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Add user to team UI is NOT available (missing)
- ✅ **When implemented**: Users can be added to teams via UI
- ✅ Team membership is updated in Firebase
- ✅ Manager relationship is updated (if applicable)

---

## Test Case 3: Remove User from Team - Missing Feature

**Objective**: Verify users can be removed from teams via UI (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B is member of Team A
- Remove user from team feature is implemented

**Steps**:
1. Navigate to Team Management or Team Detail page
2. Select Team A
3. Locate User B in team members list
4. Verify one of the following:
   - **If NOT implemented**: "Remove" or "Remove from Team" option is not available (this is expected - feature missing)
   - **If implemented**: "Remove" or "Remove from Team" button/option is available
5. If implemented:
   - Tap "Remove" button for User B
   - Verify confirmation dialog appears:
     - Warning message
     - Confirm/Cancel buttons
   - Confirm removal
   - Verify User B is removed from Team A:
     - User B no longer appears in team members list
     - Team member count decreases
     - User B's `managerUserId` may be cleared (if team manager was set)
6. Verify Firebase data:
   - Check `TeamGroup.members` no longer includes User B's ID
   - Check `WorkspaceMember.managerUserId` is cleared (if applicable)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Remove user from team UI is NOT available (missing)
- ✅ **When implemented**: Users can be removed from teams via UI
- ✅ Confirmation dialog appears before removal
- ✅ Team membership is updated in Firebase

---

## Test Case 4: Assign Lead to Team - Missing Feature

**Objective**: Verify lead can be assigned to teams via UI (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists (member of Team A or available)
- Team A exists
- Assign lead feature is implemented

**Steps**:
1. Navigate to Team Management or Team Detail page
2. Select Team A
3. Verify one of the following:
   - **If NOT implemented**: "Assign Lead" or "Set Lead" option is not available (this is expected - feature missing)
   - **If implemented**: "Assign Lead" or "Set Lead" button/option is available
4. If implemented:
   - Tap "Assign Lead" button
   - Verify user selection dialog appears:
     - List of team members or available users
     - Search functionality
   - Select User B
   - Confirm assignment
   - Verify User B is assigned as lead:
     - `TeamGroup.leadGroupUserId` is set to User B's ID
     - User B is displayed as lead in team
     - Lead badge/indicator is shown
     - User B may get Lead role permissions (if cascading is implemented)
5. Verify Firebase data:
   - Check `TeamGroup.leadGroupUserId` is set to User B's ID
   - Check User B's role/permissions are updated (if cascading is implemented)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Assign lead UI is NOT available (missing)
- ✅ **When implemented**: Lead can be assigned to teams via UI
- ✅ Lead assignment is saved to Firebase
- ✅ Lead role/permissions are applied (if cascading is implemented)

---

## Test Case 5: Change Team Lead - Missing Feature

**Objective**: Verify team lead can be changed (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- Team A has User B as lead
- User C exists (member of Team A)
- Change lead feature is implemented

**Steps**:
1. Navigate to Team Detail page for Team A
2. Verify current lead is User B
3. Verify one of the following:
   - **If NOT implemented**: "Change Lead" option is not available (this is expected - feature missing)
   - **If implemented**: "Change Lead" button/option is available
4. If implemented:
   - Tap "Change Lead" button
   - Select User C as new lead
   - Confirm change
   - Verify lead is changed:
     - `TeamGroup.leadGroupUserId` is updated to User C's ID
     - User C is displayed as lead
     - User B is no longer displayed as lead
     - User B's permissions may be updated (if cascading is implemented)
     - User C's permissions may be updated (if cascading is implemented)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Change lead UI is NOT available (missing)
- ✅ **When implemented**: Team lead can be changed
- ✅ Lead change is saved to Firebase
- ✅ Permissions are updated for both old and new leads (if cascading is implemented)

---

## Test Case 6: Cascading Permissions - Tasks - Missing Feature

**Objective**: Verify permissions cascade to tasks when user joins team (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists (not in any team)
- Team A exists
- Task 1 is assigned to Team A
- Cascading permissions feature is implemented

**Steps**:
1. Verify User B's current permissions:
   - Check User B's task permissions
   - Verify User B cannot access Task 1 (not in team)
2. Add User B to Team A (using add user to team feature)
3. Verify one of the following:
   - **If NOT implemented**: User B's permissions are NOT updated (this is expected - cascading missing)
   - **If implemented**: User B's permissions are updated
4. If implemented:
   - Verify User B can now access Task 1:
     - Task 1 appears in User B's task list
     - User B can view Task 1 details
     - User B can perform actions on Task 1 (based on team permissions)
   - Verify permission enforcement:
     - Check `PermissionService.hasPermission` returns true for team-related permissions
     - Check task filtering includes Task 1 for User B
5. Remove User B from Team A
6. Verify permissions are revoked:
   - User B can no longer access Task 1
   - Task 1 no longer appears in User B's task list

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Cascading permissions to tasks are NOT implemented (missing)
- ✅ **When implemented**: Permissions cascade to tasks when user joins team
- ✅ Task access is updated automatically
- ✅ Permissions are revoked when user leaves team

---

## Test Case 7: Cascading Permissions - Projects - Missing Feature

**Objective**: Verify permissions cascade to projects when user joins team (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists (not in any team)
- Team A exists
- Project 1 is assigned to Team A
- Cascading permissions feature is implemented

**Steps**:
1. Verify User B's current permissions:
   - Check User B's project permissions
   - Verify User B cannot access Project 1 (not in team)
2. Add User B to Team A
3. Verify one of the following:
   - **If NOT implemented**: User B's permissions are NOT updated (this is expected - cascading missing)
   - **If implemented**: User B's permissions are updated
4. If implemented:
   - Verify User B can now access Project 1:
     - Project 1 appears in User B's project list
     - User B can view Project 1 details
     - User B can perform actions on Project 1 (based on team permissions)
   - Verify permission enforcement:
     - Check `PermissionService.hasPermission` returns true for team-related permissions
     - Check project filtering includes Project 1 for User B
5. Remove User B from Team A
6. Verify permissions are revoked:
   - User B can no longer access Project 1
   - Project 1 no longer appears in User B's project list

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Cascading permissions to projects are NOT implemented (missing)
- ✅ **When implemented**: Permissions cascade to projects when user joins team
- ✅ Project access is updated automatically
- ✅ Permissions are revoked when user leaves team

---

## Test Case 8: Filter Users by Role - Missing Feature

**Objective**: Verify users can be filtered by role (currently missing).

**Preconditions**:
- User is logged in
- Workspace has multiple members with different roles
- Filter by role feature is implemented

**Steps**:
1. Navigate to User Management page
2. Verify one of the following:
   - **If NOT implemented**: Role filter is not available (this is expected - feature missing)
   - **If implemented**: Role filter dropdown/chips are available
3. If implemented:
   - Verify filter options:
     - Account Holder
     - Admin
     - Member
     - Lead (if exists)
     - All (show all roles)
   - Select "Account Holder" filter:
     - Verify only Account Holders are displayed
     - Verify other roles are hidden
   - Select "Admin" filter:
     - Verify only Admins are displayed
   - Select "Member" filter:
     - Verify only Members are displayed
   - Select "All" filter:
     - Verify all users are displayed
4. Test multiple filters:
   - Select multiple roles (if supported)
   - Verify users with selected roles are displayed

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Filter by role is NOT available (missing)
- ✅ **When implemented**: Users can be filtered by role
- ✅ Filter works correctly
- ✅ UI is clear and easy to use

---

## Test Case 9: Filter Users by Status - Missing Feature

**Objective**: Verify users can be filtered by status (active/locked) (currently missing).

**Preconditions**:
- User is logged in
- Workspace has members with different statuses (active, locked)
- Filter by status feature is implemented

**Steps**:
1. Navigate to User Management page
2. Verify one of the following:
   - **If NOT implemented**: Status filter is not available (this is expected - feature missing)
   - **If implemented**: Status filter dropdown/chips are available
3. If implemented:
   - Verify filter options:
     - Active
     - Locked
     - All (show all statuses)
   - Select "Active" filter:
     - Verify only active users are displayed
     - Verify locked users are hidden
   - Select "Locked" filter:
     - Verify only locked users are displayed
     - Verify active users are hidden
   - Select "All" filter:
     - Verify all users are displayed
4. Test combined filters (if supported):
   - Filter by role AND status
   - Verify combined filter works correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Filter by status is NOT available (missing)
- ✅ **When implemented**: Users can be filtered by status
- ✅ Filter works correctly
- ✅ Combined filters work (if supported)

---

## Test Case 10: Filter Users by Team - Missing Feature

**Objective**: Verify users can be filtered by team membership (currently missing).

**Preconditions**:
- User is logged in
- Workspace has multiple teams
- Users are members of different teams
- Filter by team feature is implemented

**Steps**:
1. Navigate to User Management page
2. Verify one of the following:
   - **If NOT implemented**: Team filter is not available (this is expected - feature missing)
   - **If implemented**: Team filter dropdown is available
3. If implemented:
   - Verify filter options:
     - All Teams
     - Team A
     - Team B
     - Team C
     - No Team (users not in any team)
   - Select "Team A" filter:
     - Verify only Team A members are displayed
     - Verify other team members are hidden
   - Select "No Team" filter:
     - Verify only users not in any team are displayed
   - Select "All Teams" filter:
     - Verify all users are displayed
4. Test combined filters (if supported):
   - Filter by team AND role
   - Filter by team AND status
   - Verify combined filters work correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Filter by team is NOT available (missing)
- ✅ **When implemented**: Users can be filtered by team
- ✅ Filter works correctly
- ✅ Combined filters work (if supported)

---

## Test Case 11: Update Manager Relationship - Current Implementation

**Objective**: Verify manager relationship can be updated using existing `updateManager` method.

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists
- User C exists (potential manager)
- `updateManager` method exists

**Steps**:
1. Verify User B's current manager:
   - Check `WorkspaceMember.managerUserId` for User B
   - Note current manager (if any)
2. Update manager for User B:
   - Use `WorkspaceController.setManager` or direct repository call
   - Set User C as manager for User B
3. Verify manager is updated:
   - Check `WorkspaceMember.managerUserId` is set to User C's ID
   - Verify Firebase data is updated
4. Verify one of the following:
   - **If UI exists**: Manager relationship is displayed in UI
   - **If UI missing**: Manager relationship is updated in backend but may not be visible in UI
5. Clear manager:
   - Set `managerUserId` to null
   - Verify manager is cleared

**Expected Results**:
- ✅ Manager relationship can be updated via `updateManager` method
- ✅ Manager relationship is saved to Firebase
- ⚠️ UI for updating manager may be missing

---

## Test Case 12: List Team Members - Current Implementation

**Objective**: Verify team members can be listed using existing `listTeam` method.

**Preconditions**:
- User A is logged in
- User B is manager (has team members)
- `listTeam` method exists

**Steps**:
1. Get team members for User B:
   - Use `WorkspaceRepository.listTeam` with User B's ID as `managerUserId`
2. Verify team members are returned:
   - List includes all members with `managerUserId` set to User B's ID
   - Member details are correct
3. Verify one of the following:
   - **If UI exists**: Team members are displayed in UI
   - **If UI missing**: Team members can be retrieved but may not be displayed in UI
4. Test with different managers:
   - List team for User C (different manager)
   - Verify different team members are returned

**Expected Results**:
- ✅ Team members can be listed via `listTeam` method
- ✅ Correct team members are returned
- ⚠️ UI for displaying team members may be incomplete

---

## Test Case 13: Multi-Team Membership - Missing Feature

**Objective**: Verify users can be members of multiple teams (if supported).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists
- Team A and Team B exist
- Multi-team membership feature is implemented

**Steps**:
1. Add User B to Team A
2. Verify User B is member of Team A
3. Add User B to Team B
4. Verify one of the following:
   - **If NOT implemented**: User B cannot be in multiple teams (this is expected - feature may not support this)
   - **If implemented**: User B is member of both teams
5. If implemented:
   - Verify User B appears in both team member lists
   - Verify User B can access tasks/projects from both teams
   - Verify permissions from both teams are combined
6. Remove User B from Team A
7. Verify User B is still member of Team B

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Multi-team membership may not be supported (needs verification)
- ✅ **When implemented**: Users can be members of multiple teams
- ✅ Permissions from all teams are combined
- ✅ Team membership is managed correctly

---

## Test Case 14: Team Member Count - Missing Feature

**Objective**: Verify team member count is displayed and updated correctly.

**Preconditions**:
- User is logged in
- Team A exists
- Team member count feature is implemented

**Steps**:
1. Navigate to Team Management or Team Detail page
2. Select Team A
3. Verify one of the following:
   - **If NOT implemented**: Team member count is not displayed (this is expected - feature missing)
   - **If implemented**: Team member count is displayed
4. If implemented:
   - Note current member count
   - Add a member to Team A
   - Verify member count increases
   - Remove a member from Team A
   - Verify member count decreases
   - Verify count matches actual member list

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Team member count may not be displayed (missing)
- ✅ **When implemented**: Team member count is displayed and updated correctly
- ✅ Count matches actual member list

---

## Test Case 15: Permission Enforcement After Team Change - Missing Feature

**Objective**: Verify permission enforcement works correctly after team membership changes.

**Preconditions**:
- User A is logged in
- User B exists
- Team A exists
- Task 1 is assigned to Team A
- Permission enforcement feature is implemented

**Steps**:
1. Verify User B cannot access Task 1 (not in team)
2. Add User B to Team A
3. Verify one of the following:
   - **If NOT implemented**: User B still cannot access Task 1 (this is expected - cascading missing)
   - **If implemented**: User B can now access Task 1
4. If implemented:
   - Verify permission checks work:
     - `PermissionService.hasPermission` returns correct values
     - Task filtering includes Task 1
     - User B can perform allowed actions on Task 1
5. Remove User B from Team A
6. Verify permissions are revoked:
   - User B can no longer access Task 1
   - Permission checks return false
   - Task 1 is filtered out

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permission enforcement after team change is NOT implemented (missing)
- ✅ **When implemented**: Permissions are enforced correctly after team changes
- ✅ Access is granted/revoked automatically
- ✅ Permission checks work correctly

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Team members can be viewed
- [ ] Users can be added to teams (if implemented)
- [ ] Users can be removed from teams (if implemented)
- [ ] Lead can be assigned to teams (if implemented)
- [ ] Team lead can be changed (if implemented)
- [ ] Permissions cascade to tasks (if implemented)
- [ ] Permissions cascade to projects (if implemented)
- [ ] Users can be filtered by role (if implemented)
- [ ] Users can be filtered by status (if implemented)
- [ ] Users can be filtered by team (if implemented)
- [ ] Manager relationship can be updated
- [ ] Team members can be listed
- [ ] Multi-team membership works (if supported)
- [ ] Team member count is displayed (if implemented)
- [ ] Permission enforcement works after team changes (if implemented)

---

## Known Issues (Based on Audit Report)

1. **Team/Group Assignment UI Missing**:
   - No UI to add/remove users from teams
   - No UI to assign lead to teams
   - **Status**: ⛔ Missing

2. **Cascading Permission Enforcement Missing**:
   - Permissions don't cascade to tasks/projects when user joins team
   - **Status**: ⛔ Missing

3. **User Listing/Filter Missing**:
   - No filter by role UI
   - No filter by status UI
   - No filter by team UI
   - **Status**: ⛔ Missing

4. **Manager Relationship**:
   - `updateManager` method exists
   - `listTeam` method exists
   - `WorkspaceMember.managerUserId` field exists
   - **Status**: ✅ Implemented (backend only, UI may be missing)

---

## Notes for Testers

1. **Current Status**: Team/group management is partially implemented. Backend methods exist (`updateManager`, `listTeam`), but UI for team assignment and cascading permissions are missing.

2. **TeamGroup Entity**: Exists with `leadGroupUserId` and `members` list. Can be used to track team membership.

3. **Manager Relationship**: `WorkspaceMember.managerUserId` exists to track manager. `updateManager` and `listTeam` methods can be used to manage this relationship.

4. **Cascading Permissions**: When user joins team, permissions should automatically cascade to tasks/projects assigned to that team. This is not currently implemented.

5. **User Filtering**: Need UI to filter users by role, status, and team. Currently missing.

6. **Team Management UI**: Some UI exists (Team Management page, Team Detail page) but may have TODOs or incomplete functionality.

7. **Permission Enforcement**: Need to ensure permissions are enforced after team membership changes. Currently missing.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- User roles (Account Holder, Admin, Member)
- Workspace context
- Team/group context
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase data (if accessible) showing team membership
- Whether cascading permissions are working
- Whether filters are working
