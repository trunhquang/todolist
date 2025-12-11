# Projects & Teams Visibility + Access Rights by Role/Team - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Projects & Teams Visibility + Access Rights by Role/Team** feature. This feature is currently **PARTIAL** - team/group entities exist, but there's no enforcement path from workspace permissions to projects/tasks/teams views. Need guard rails to ensure data filtered by workspace + permissions before rendering.

## Prerequisites
- User must be logged into the application
- User must have access to workspace with multiple members
- Workspace should have multiple projects, tasks, and teams
- Different users with different roles (Account Holder, Admin, Member, Lead)
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: View All Data Permission - Account Holder/Admin

**Objective**: Verify Account Holder and Admin can view all projects, tasks, and teams.

**Preconditions**:
- User is logged in as Account Holder or Admin
- User has `viewAllData` permission
- Workspace has multiple projects, tasks, and teams
- User is on Projects, Tasks, or Teams screen

**Steps**:
1. Navigate to Projects screen
2. Verify all projects in workspace are displayed:
   - Projects created by any user
   - Projects assigned to any team
   - All project statuses
3. Navigate to Tasks screen
4. Verify all tasks in workspace are displayed:
   - Tasks created by any user
   - Tasks assigned to any user
   - Tasks in any project
   - All task statuses
5. Navigate to Teams screen
6. Verify all teams in workspace are displayed:
   - All teams
   - All team members
   - All team leads

**Expected Results**:
- ✅ Account Holder/Admin can view all projects
- ✅ Account Holder/Admin can view all tasks
- ✅ Account Holder/Admin can view all teams
- ✅ No filtering by team or user

---

## Test Case 2: View Team Data Permission - Lead/Member

**Objective**: Verify users with `viewTeamData` permission can view only their team's data.

**Preconditions**:
- User is logged in as Lead or Member with `viewTeamData` permission
- User is member of Team A
- Workspace has multiple teams (Team A, Team B, Team C)
- Each team has projects, tasks, and members
- User is on Projects, Tasks, or Teams screen

**Steps**:
1. Navigate to Projects screen
2. Verify only Team A's projects are displayed:
   - Projects assigned to Team A
   - Projects created by Team A members
   - Projects NOT assigned to other teams
3. Navigate to Tasks screen
4. Verify only Team A's tasks are displayed:
   - Tasks assigned to Team A members
   - Tasks created by Team A members
   - Tasks in Team A's projects
   - Tasks NOT assigned to other teams
5. Navigate to Teams screen
6. Verify only Team A is displayed:
   - Team A details
   - Team A members
   - Team A lead
   - Other teams are NOT displayed

**Expected Results**:
- ✅ Users with `viewTeamData` see only their team's projects
- ✅ Users with `viewTeamData` see only their team's tasks
- ✅ Users with `viewTeamData` see only their team
- ⚠️ **CURRENT STATUS**: This filtering may not be enforced (needs implementation)

---

## Test Case 3: View Personal Data Permission - Member

**Objective**: Verify users with only `viewPersonalData` permission can view only their own data.

**Preconditions**:
- User is logged in as Member with only `viewPersonalData` permission
- User is member of Team A
- Workspace has multiple projects, tasks, and teams
- User has created some tasks and projects
- Other users have created tasks and projects
- User is on Projects, Tasks, or Teams screen

**Steps**:
1. Navigate to Projects screen
2. Verify only user's own projects are displayed:
   - Projects created by the user
   - Projects assigned to the user
   - Projects NOT created by others
   - Projects NOT assigned to others
3. Navigate to Tasks screen
4. Verify only user's own tasks are displayed:
   - Tasks created by the user
   - Tasks assigned to the user
   - Tasks NOT created by others
   - Tasks NOT assigned to others
5. Navigate to Teams screen
6. Verify user's team membership is displayed:
   - Team A (if user is member)
   - User's role in team
   - Other teams are NOT displayed

**Expected Results**:
- ✅ Users with `viewPersonalData` see only their own projects
- ✅ Users with `viewPersonalData` see only their own tasks
- ✅ Users with `viewPersonalData` see only their team membership
- ⚠️ **CURRENT STATUS**: This filtering may not be enforced (needs implementation)

---

## Test Case 4: Team-Based Project Filtering

**Objective**: Verify projects are filtered by team membership.

**Preconditions**:
- User is logged in as Lead or Member with `viewTeamData` permission
- User is member of Team A
- Project 1 is assigned to Team A
- Project 2 is assigned to Team B
- Project 3 is not assigned to any team
- User is on Projects screen

**Steps**:
1. Navigate to Projects screen
2. Verify only Team A's projects are displayed:
   - Project 1 is displayed (assigned to Team A)
   - Project 2 is NOT displayed (assigned to Team B)
   - Project 3 is NOT displayed (not assigned to Team A)
3. Verify project filtering works correctly
4. Switch to different team (if user is member of multiple teams)
5. Verify projects update to show new team's projects

**Expected Results**:
- ✅ Projects are filtered by team membership
- ✅ Only team's projects are displayed
- ✅ Filtering updates when team changes
- ⚠️ **CURRENT STATUS**: This filtering may not be enforced (needs implementation)

---

## Test Case 5: Team-Based Task Filtering

**Objective**: Verify tasks are filtered by team membership.

**Preconditions**:
- User is logged in as Lead or Member with `viewTeamData` permission
- User is member of Team A
- Task 1 is assigned to Team A member
- Task 2 is assigned to Team B member
- Task 3 is in Project assigned to Team A
- Task 4 is in Project assigned to Team B
- User is on Tasks screen

**Steps**:
1. Navigate to Tasks screen
2. Verify only Team A's tasks are displayed:
   - Task 1 is displayed (assigned to Team A member)
   - Task 2 is NOT displayed (assigned to Team B member)
   - Task 3 is displayed (in Team A project)
   - Task 4 is NOT displayed (in Team B project)
3. Verify task filtering works correctly
4. Switch to different team (if user is member of multiple teams)
5. Verify tasks update to show new team's tasks

**Expected Results**:
- ✅ Tasks are filtered by team membership
- ✅ Only team's tasks are displayed
- ✅ Filtering updates when team changes
- ⚠️ **CURRENT STATUS**: This filtering may not be enforced (needs implementation)

---

## Test Case 6: Permission-Based Access Control Enforcement

**Objective**: Verify permission checks are enforced before rendering data.

**Preconditions**:
- User is logged in as Member with only `viewPersonalData` permission
- User does NOT have `viewTeamData` or `viewAllData` permissions
- Workspace has projects, tasks, and teams
- User is on Projects, Tasks, or Teams screen

**Steps**:
1. Navigate to Projects screen
2. Verify permission check is performed:
   - Check if user has `viewAllData` - should be false
   - Check if user has `viewTeamData` - should be false
   - Check if user has `viewPersonalData` - should be true
3. Verify only personal projects are displayed
4. Try to access team projects (if possible):
   - Try to view project assigned to another team
   - Verify access is denied or project is not displayed
5. Navigate to Tasks screen
6. Verify only personal tasks are displayed
7. Try to access team tasks (if possible):
   - Try to view task assigned to another team member
   - Verify access is denied or task is not displayed

**Expected Results**:
- ✅ Permission checks are performed before rendering
- ✅ Access is denied for unauthorized data
- ✅ Only authorized data is displayed
- ⚠️ **CURRENT STATUS**: Permission enforcement may not be implemented (needs implementation)

---

## Test Case 7: Team Lead Access to Team Data

**Objective**: Verify Team Lead can view and manage their team's data.

**Preconditions**:
- User is logged in as Team Lead
- User is lead of Team A
- User has `viewTeamData` permission
- Team A has projects, tasks, and members
- User is on Projects, Tasks, or Teams screen

**Steps**:
1. Navigate to Projects screen
2. Verify Team Lead can view Team A's projects:
   - All projects assigned to Team A
   - All projects created by Team A members
3. Verify Team Lead can manage Team A's projects:
   - Can edit Team A projects
   - Can assign projects to Team A members
4. Navigate to Tasks screen
5. Verify Team Lead can view Team A's tasks:
   - All tasks assigned to Team A members
   - All tasks in Team A projects
6. Verify Team Lead can manage Team A's tasks:
   - Can assign tasks to Team A members
   - Can update task status for Team A tasks
7. Navigate to Teams screen
8. Verify Team Lead can view Team A details:
   - Team A members
   - Team A projects
   - Team A tasks

**Expected Results**:
- ✅ Team Lead can view team's projects
- ✅ Team Lead can manage team's projects
- ✅ Team Lead can view team's tasks
- ✅ Team Lead can manage team's tasks
- ✅ Team Lead can view team details

---

## Test Case 8: Cross-Team Data Isolation

**Objective**: Verify data from different teams is isolated.

**Preconditions**:
- User A is logged in as Member of Team A
- User B is logged in as Member of Team B
- Team A has Project 1, Task 1
- Team B has Project 2, Task 2
- Both users have `viewTeamData` permission

**Steps**:
1. As User A:
   - Navigate to Projects screen
   - Verify Project 1 is displayed
   - Verify Project 2 is NOT displayed
   - Navigate to Tasks screen
   - Verify Task 1 is displayed
   - Verify Task 2 is NOT displayed
2. As User B:
   - Navigate to Projects screen
   - Verify Project 2 is displayed
   - Verify Project 1 is NOT displayed
   - Navigate to Tasks screen
   - Verify Task 2 is displayed
   - Verify Task 1 is NOT displayed
3. Verify data isolation:
   - Team A data is not visible to Team B members
   - Team B data is not visible to Team A members

**Expected Results**:
- ✅ Team data is isolated
- ✅ Cross-team data leakage is prevented
- ✅ Each team sees only their own data
- ⚠️ **CURRENT STATUS**: Data isolation may not be enforced (needs implementation)

---

## Test Case 9: Permission Change - Immediate Effect

**Objective**: Verify permission changes take effect immediately.

**Preconditions**:
- User is logged in as Member with `viewPersonalData` permission
- User is viewing Projects screen (showing only personal projects)
- Admin/Account Holder is available to change permissions

**Steps**:
1. As Member, verify only personal projects are displayed
2. As Admin/Account Holder:
   - Grant `viewTeamData` permission to Member
   - Save permission changes
3. As Member:
   - Refresh Projects screen (or wait for auto-refresh)
   - Verify team projects are now displayed
   - Verify permission change took effect immediately
4. As Admin/Account Holder:
   - Revoke `viewTeamData` permission from Member
   - Save permission changes
5. As Member:
   - Refresh Projects screen
   - Verify only personal projects are displayed again
   - Verify permission revocation took effect immediately

**Expected Results**:
- ✅ Permission changes take effect immediately
- ✅ Data visibility updates when permissions change
- ✅ No need to restart app or re-login

---

## Test Case 10: Multi-Team Member Access

**Objective**: Verify users who are members of multiple teams can see all their teams' data.

**Preconditions**:
- User is logged in as Member with `viewTeamData` permission
- User is member of Team A and Team B
- Team A has Project 1, Task 1
- Team B has Project 2, Task 2
- User is on Projects or Tasks screen

**Steps**:
1. Navigate to Projects screen
2. Verify both teams' projects are displayed:
   - Project 1 (from Team A) is displayed
   - Project 2 (from Team B) is displayed
3. Navigate to Tasks screen
4. Verify both teams' tasks are displayed:
   - Task 1 (from Team A) is displayed
   - Task 2 (from Team B) is displayed
5. Verify user can switch between teams (if team selector exists)
6. Verify data from all teams is accessible

**Expected Results**:
- ✅ Multi-team members see all their teams' data
- ✅ Data from all teams is displayed
- ✅ Team switching works correctly (if implemented)

---

## Test Case 11: Guard Rails - Workspace + Permissions

**Objective**: Verify guard rails ensure data is filtered by workspace + permissions before rendering.

**Preconditions**:
- User is logged in
- User has access to multiple workspaces
- Each workspace has projects, tasks, and teams
- User is on Projects, Tasks, or Teams screen

**Steps**:
1. Verify workspace filtering:
   - Switch to Workspace A
   - Verify only Workspace A's data is displayed
   - Switch to Workspace B
   - Verify only Workspace B's data is displayed
2. Verify permission filtering:
   - As Member with `viewPersonalData`, verify only personal data
   - As Lead with `viewTeamData`, verify only team data
   - As Admin with `viewAllData`, verify all data
3. Verify combined filtering:
   - Data is filtered by workspace AND permissions
   - No data from other workspaces
   - No data beyond permission scope
4. Verify guard rails work:
   - Check if guard/interceptor exists (if implemented)
   - Verify guard enforces workspace + permissions
   - Verify guard prevents unauthorized access

**Expected Results**:
- ✅ Data is filtered by workspace
- ✅ Data is filtered by permissions
- ✅ Guard rails enforce filtering
- ⚠️ **CURRENT STATUS**: Guard rails may not be implemented (needs implementation)

---

## Test Case 12: Project Assignment to Team

**Objective**: Verify projects can be assigned to teams and team members can view them.

**Preconditions**:
- User is logged in as Admin or Account Holder
- User has `assignProjects` permission
- Team A exists with members
- Project exists but not assigned to any team
- User is on Projects screen

**Steps**:
1. Navigate to Projects screen
2. Select a project
3. Assign project to Team A:
   - Open project settings
   - Select Team A from team selector
   - Save assignment
4. Verify project is assigned to Team A
5. As Team A member:
   - Navigate to Projects screen
   - Verify assigned project is displayed
   - Verify project is accessible
6. As Team B member:
   - Navigate to Projects screen
   - Verify assigned project is NOT displayed (if Team B member doesn't have viewAllData)

**Expected Results**:
- ✅ Projects can be assigned to teams
- ✅ Team members can view assigned projects
- ✅ Project assignment affects visibility
- ⚠️ **CURRENT STATUS**: Team assignment may not affect visibility (needs implementation)

---

## Test Case 13: Task Assignment to Team Member

**Objective**: Verify tasks assigned to team members are visible to team leads and team members.

**Preconditions**:
- User is logged in as Admin or Account Holder
- User has `assignTasks` permission
- Team A exists with Lead and Members
- Task exists but not assigned
- User is on Tasks screen

**Steps**:
1. Navigate to Tasks screen
2. Select a task
3. Assign task to Team A member:
   - Open task assignment
   - Select Team A member from assignee list
   - Save assignment
4. Verify task is assigned to Team A member
5. As Team A Lead:
   - Navigate to Tasks screen
   - Verify assigned task is displayed
   - Verify task is accessible
6. As Team A Member (assignee):
   - Navigate to Tasks screen
   - Verify assigned task is displayed
   - Verify task is accessible
7. As Team B Member:
   - Navigate to Tasks screen
   - Verify assigned task is NOT displayed (if Team B member doesn't have viewAllData)

**Expected Results**:
- ✅ Tasks can be assigned to team members
   - Team leads can view team member tasks
   - Team members can view their assigned tasks
   - Task assignment affects visibility
   - ⚠️ **CURRENT STATUS**: Team assignment may not affect visibility (needs implementation)

---

## Test Case 14: Search/Filter Within Permission Scope

**Objective**: Verify search and filter operations respect permission scope.

**Preconditions**:
- User is logged in as Member with `viewPersonalData` permission
- Workspace has multiple projects and tasks (some personal, some team, some all)
- User is on Projects or Tasks screen with search/filter functionality

**Steps**:
1. Navigate to Projects screen
2. Use search to find a project:
   - Search for personal project name - should find it
   - Search for team project name - should NOT find it (if user doesn't have viewTeamData)
   - Search for other user's project - should NOT find it
3. Use filter to filter projects:
   - Filter by status - should show only personal projects with that status
   - Filter by assignee - should show only personal projects
4. Navigate to Tasks screen
5. Repeat search and filter tests for tasks
6. Verify search/filter respects permission scope

**Expected Results**:
- ✅ Search respects permission scope
- ✅ Filter respects permission scope
- ✅ Only authorized data appears in search/filter results
- ⚠️ **CURRENT STATUS**: Search/filter may not respect permissions (needs implementation)

---

## Test Case 15: Statistics/Analytics Scoped by Permissions

**Objective**: Verify statistics and analytics are scoped by user permissions.

**Preconditions**:
- User is logged in with specific permissions (viewAllData, viewTeamData, or viewPersonalData)
- Workspace has projects, tasks, and teams with various data
- User is on Dashboard or Analytics screen

**Steps**:
1. Navigate to Dashboard or Analytics screen
2. Verify statistics are scoped by permissions:
   - As Account Holder/Admin with `viewAllData`: See all workspace statistics
   - As Lead/Member with `viewTeamData`: See only team statistics
   - As Member with `viewPersonalData`: See only personal statistics
3. Verify analytics charts/graphs reflect permission scope:
   - Charts show only authorized data
   - Metrics are calculated from authorized data only
4. Verify statistics update when permissions change

**Expected Results**:
- ✅ Statistics are scoped by permissions
- ✅ Analytics reflect permission scope
- ✅ Charts show only authorized data
- ⚠️ **CURRENT STATUS**: Statistics may not be scoped (needs implementation)

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Account Holder/Admin can view all data
- [ ] Users with viewTeamData see only team data
- [ ] Users with viewPersonalData see only personal data
- [ ] Projects are filtered by team membership
- [ ] Tasks are filtered by team membership
- [ ] Permission checks are enforced before rendering
- [ ] Team Lead can view/manage team data
- [ ] Cross-team data isolation works
- [ ] Permission changes take effect immediately
- [ ] Multi-team members see all their teams' data
- [ ] Guard rails enforce workspace + permissions filtering
- [ ] Project assignment to team affects visibility
- [ ] Task assignment to team member affects visibility
- [ ] Search/filter respects permission scope
- [ ] Statistics are scoped by permissions

---

## Known Issues (Based on Audit Report)

1. **No Enforcement Path**:
   - No enforcement path from workspace permissions to projects/tasks/teams views
   - Data may not be filtered by permissions before rendering
   - **Status**: ⚠️ Missing

2. **No Guard Rails**:
   - No guard rails ensuring data filtered by workspace + permissions
   - Easy to miss permission checks in new code
   - **Status**: ⚠️ Missing

3. **Team-Based Filtering**:
   - Team/group entities exist but may not be used for filtering
   - Projects/tasks may not be filtered by team membership
   - **Status**: ⚠️ Needs Implementation

---

## Notes for Testers

1. **Permission Scopes**:
   - `viewAllData`: Can view all workspace data (Account Holder, Admin)
   - `viewTeamData`: Can view only team data (Lead, some Members)
   - `viewPersonalData`: Can view only personal data (Member)

2. **Team Membership**: Users can be members of multiple teams. They should see data from all their teams if they have `viewTeamData` permission.

3. **Guard Rails**: The main issue is that there's no enforcement mechanism ensuring data is filtered before rendering. This needs to be implemented.

4. **Current Behavior**: Document actual behavior even if it doesn't match expected behavior. This helps identify what needs to be fixed.

5. **Workspace + Permissions**: Data must be filtered by BOTH workspace AND permissions. Missing either filter can cause data leakage.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- User role and permissions
- Current workspace
- Team membership (if applicable)
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Data that was visible when it shouldn't be (if any)

