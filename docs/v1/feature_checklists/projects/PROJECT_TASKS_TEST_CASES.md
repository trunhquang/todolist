# Tasks Within Project (Add/Remove/Edit; Assign Team/Group/Member; Filters; Status Breakdown) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Tasks Within Project** feature (add/remove/edit; assign team/group/member; filters by status/priority/assignee/tag; status breakdown). This feature is currently **PARTIAL** - tasks link via `projectId`, but no team/group assignment support exists, filter/tag coverage is unclear, and status breakdown is not implemented.

## Prerequisites
- User must be logged in
- Workspace should exist
- Project should exist
- Tasks should exist (some with projectId, some without)
- Teams/Groups should exist (for team assignment tests)
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: View Tasks Within Project - Happy Path

**Objective**: Verify tasks within a project can be viewed.

**Preconditions**:
- User is logged in
- Project exists
- Tasks exist with `projectId` matching the project
- View project tasks feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Verify one of the following:
   - **If NOT implemented**: Project detail page may not show tasks (this is expected - feature missing)
   - **If implemented**: Project detail page shows tasks section
5. If implemented:
   - Verify tasks section appears:
     - Section title: "Tasks" or "Project Tasks"
     - List of tasks
     - Task count displayed
   - Verify only tasks with matching `projectId` are shown:
     - Tasks with `projectId` matching project are displayed
     - Tasks with different `projectId` are NOT displayed
     - Tasks without `projectId` are NOT displayed
   - Verify task information is displayed:
     - Task title
     - Task status
     - Task priority
     - Task assignee (if assigned)
     - Task deadline (if has deadline)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: View tasks within project may not be fully implemented
- ✅ **When implemented**: Tasks within project can be viewed
- ✅ Only tasks with matching `projectId` are shown
- ✅ Task information is displayed correctly

---

## Test Case 2: Add Task to Project - Happy Path

**Objective**: Verify task can be added to a project.

**Preconditions**:
- User is logged in
- User has `createTasks` permission
- Project exists
- Add task to project feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Verify one of the following:
   - **If NOT implemented**: "Add Task" button may not exist (this is expected - feature missing)
   - **If implemented**: "Add Task" or "+" button exists
5. If implemented:
   - Tap "Add Task" button
   - Verify create task dialog/page appears:
     - Title field
     - Description field (optional)
     - Status field
     - Priority field
     - Assignee field (optional)
     - Deadline field (optional)
     - Project field (pre-filled with current project)
   - Fill in task details:
     - Enter task title: "Test Task"
     - Enter description: "Test task description"
     - Select status: "Pending"
     - Select priority: "Medium"
     - Select assignee (optional)
     - Set deadline (optional)
   - Verify project field is pre-filled and cannot be changed (or can be changed)
   - Tap "Create" or "Save" button
   - Verify loading indicator appears
   - Wait for task creation to complete
   - Verify success message appears: "Task created successfully"
   - Verify task appears in project tasks list:
     - Task title is displayed
     - Task has correct `projectId`
   - Verify task is saved to Firebase:
     - Check Firebase data
     - Verify task has correct `projectId`
     - Verify task has correct `workspaceId`

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Add task to project may not be fully implemented
- ✅ **When implemented**: Task can be added to project
- ✅ Task appears in project tasks list
- ✅ Task is saved to Firebase with correct `projectId`

---

## Test Case 3: Remove Task from Project

**Objective**: Verify task can be removed from a project.

**Preconditions**:
- User is logged in
- User has `manageTasks` or `deleteTasks` permission
- Project exists
- Task exists with `projectId` matching the project
- Remove task from project feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Locate a task within the project
5. Verify one of the following:
   - **If NOT implemented**: "Remove from Project" option may not exist (this is expected - feature missing)
   - **If implemented**: "Remove from Project" or "Unlink" option exists
6. If implemented:
   - Tap "Remove from Project" option
   - Verify confirmation dialog appears (if required):
     - Warning message about removing task from project
     - Confirm button
   - Confirm removal
   - Verify loading indicator appears
   - Wait for removal to complete
   - Verify success message appears: "Task removed from project"
   - Verify task is removed from project tasks list:
     - Task no longer appears in project tasks
     - Task still exists (not deleted)
   - Verify task is updated in Firebase:
     - Check Firebase data
     - Verify task `projectId` is set to null
     - Verify task is not deleted

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Remove task from project may not be implemented
- ✅ **When implemented**: Task can be removed from project
- ✅ Task is unlinked (projectId set to null)
- ✅ Task is not deleted

---

## Test Case 4: Edit Task Within Project

**Objective**: Verify task within a project can be edited.

**Preconditions**:
- User is logged in
- User has `updateTasks` permission
- Project exists
- Task exists with `projectId` matching the project
- Edit task feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Locate a task within the project
5. Tap on task or "Edit" button
6. Verify edit task dialog/page appears:
   - Title field (pre-filled)
   - Description field (pre-filled)
   - Status field (pre-filled)
   - Priority field (pre-filled)
   - Assignee field (pre-filled)
   - Deadline field (pre-filled)
   - Project field (pre-filled)
7. Modify task details:
   - Change title: "Updated Task Title"
   - Change description: "Updated description"
   - Change status: "In Progress"
   - Change priority: "High"
   - Change assignee (if applicable)
   - Change deadline (if applicable)
8. Verify project field can be changed (or cannot be changed)
9. Tap "Save" button
10. Verify loading indicator appears
11. Wait for update to complete
12. Verify success message appears: "Task updated successfully"
13. Verify task is updated in project tasks list:
    - Updated title is displayed
    - Updated status is displayed
    - Updated priority is displayed
14. Verify task is updated in Firebase:
    - Check Firebase data
    - Verify changes are saved

**Expected Results**:
- ✅ Task can be edited
- ✅ Changes are saved
- ✅ Task is updated in Firebase
- ✅ Success message appears

---

## Test Case 5: Assign Task to Team - Missing Feature

**Objective**: Verify task can be assigned to a team (currently missing).

**Preconditions**:
- User is logged in
- User has `assignTasks` permission
- Project exists
- Task exists with `projectId` matching the project
- Team exists
- Assign task to team feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Locate a task within the project
5. Tap on task or "Assign" button
6. Verify one of the following:
   - **If NOT implemented**: "Assign to Team" option is not available (this is expected - feature missing)
   - **If implemented**: "Assign to Team" option is available
7. If implemented:
   - Tap "Assign to Team" option
   - Verify team selector appears:
     - List of available teams
     - Team name displayed
     - Team member count displayed
   - Select a team
   - Verify assignment options:
     - Assign to team (all members can view)
     - Assign to team lead
     - Assign to specific team member
   - Select assignment type
   - Confirm assignment
   - Verify loading indicator appears
   - Wait for assignment to complete
   - Verify success message appears: "Task assigned to team"
   - Verify task is assigned:
     - Task shows team assignment
     - Team members can view task
     - Task has `teamId` or `assignedTeamId` field set
   - Verify task is updated in Firebase:
     - Check Firebase data
     - Verify task has `teamId` or `assignedTeamId` field

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Assign task to team is NOT available (missing)
- ✅ **When implemented**: Task can be assigned to team
- ✅ Team members can view task
- ✅ Task has team assignment field

---

## Test Case 6: Assign Task to Group - Missing Feature

**Objective**: Verify task can be assigned to a group (currently missing).

**Preconditions**:
- User is logged in
- User has `assignTasks` permission
- Project exists
- Task exists with `projectId` matching the project
- Group exists
- Assign task to group feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Locate a task within the project
5. Tap on task or "Assign" button
6. Verify one of the following:
   - **If NOT implemented**: "Assign to Group" option is not available (this is expected - feature missing)
   - **If implemented**: "Assign to Group" option is available
7. If implemented:
   - Tap "Assign to Group" option
   - Verify group selector appears:
     - List of available groups
     - Group name displayed
     - Group member count displayed
   - Select a group
   - Confirm assignment
   - Verify task is assigned:
     - Task shows group assignment
     - Group members can view task
     - Task has `groupId` or `assignedGroupId` field set
   - Verify task is updated in Firebase

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Assign task to group is NOT available (missing)
- ✅ **When implemented**: Task can be assigned to group
- ✅ Group members can view task
- ✅ Task has group assignment field

---

## Test Case 7: Assign Task to Member - Current Implementation

**Objective**: Verify task can be assigned to a member (currently implemented with single assignee).

**Preconditions**:
- User is logged in
- User has `assignTasks` permission
- Project exists
- Task exists with `projectId` matching the project
- Workspace members exist
- Assign task to member feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Locate a task within the project
5. Tap on task or "Assign" button
6. Verify "Assign to Member" or "Assign" option is available
7. Tap "Assign to Member" option
8. Verify member selector appears:
   - List of available workspace members
   - Member name displayed
   - Member role displayed (if applicable)
9. Select a member
10. Confirm assignment
11. Verify loading indicator appears
12. Wait for assignment to complete
13. Verify success message appears: "Task assigned successfully"
14. Verify task is assigned:
    - Task shows assignee name
    - Task has `assignee` field set to member ID
    - Assigned member can view task
15. Verify task is updated in Firebase:
    - Check Firebase data
    - Verify task has `assignee` field set

**Expected Results**:
- ✅ Task can be assigned to member
- ✅ Task has `assignee` field set
- ✅ Assigned member can view task
- ✅ Task is updated in Firebase

---

## Test Case 8: Filter Tasks by Status - Within Project

**Objective**: Verify tasks within a project can be filtered by status.

**Preconditions**:
- User is logged in
- Project exists
- Tasks exist with different statuses within the project
- Status filter feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Locate status filter dropdown/selector
5. Verify one of the following:
   - **If NOT implemented**: Status filter may not exist (this is expected - feature missing)
   - **If implemented**: Status filter exists
6. If implemented:
   - Verify filter shows all status options:
     - All
     - Pending
     - In Progress
     - Completed
     - Cancelled
     - On Hold
   - Select "Pending" filter:
     - Verify only pending tasks are shown
     - Verify tasks with other statuses are hidden
   - Select "In Progress" filter:
     - Verify only in-progress tasks are shown
     - Verify tasks with other statuses are hidden
   - Select "All" filter:
     - Verify all tasks are shown
     - Verify filter is cleared

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Status filter may not be implemented
- ✅ **When implemented**: Tasks can be filtered by status
- ✅ Filter works correctly
- ✅ All status options are available

---

## Test Case 9: Filter Tasks by Priority - Within Project

**Objective**: Verify tasks within a project can be filtered by priority.

**Preconditions**:
- User is logged in
- Project exists
- Tasks exist with different priorities within the project
- Priority filter feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Locate priority filter dropdown/selector
5. Verify one of the following:
   - **If NOT implemented**: Priority filter may not exist (this is expected - feature missing)
   - **If implemented**: Priority filter exists
6. If implemented:
   - Verify filter shows all priority options:
     - All
     - Low
     - Medium
     - High
     - Urgent
   - Select "High" filter:
     - Verify only high-priority tasks are shown
     - Verify tasks with other priorities are hidden
   - Select "All" filter:
     - Verify all tasks are shown

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Priority filter may not be implemented
- ✅ **When implemented**: Tasks can be filtered by priority
- ✅ Filter works correctly

---

## Test Case 10: Filter Tasks by Assignee - Within Project

**Objective**: Verify tasks within a project can be filtered by assignee.

**Preconditions**:
- User is logged in
- Project exists
- Tasks exist with different assignees within the project
- Assignee filter feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Locate assignee filter dropdown/selector
5. Verify one of the following:
   - **If NOT implemented**: Assignee filter may not exist (this is expected - feature missing)
   - **If implemented**: Assignee filter exists
6. If implemented:
   - Verify filter shows all assignee options:
     - All
     - Unassigned
     - List of workspace members
   - Select a specific member:
     - Verify only tasks assigned to that member are shown
     - Verify tasks assigned to other members are hidden
   - Select "Unassigned":
     - Verify only unassigned tasks are shown
   - Select "All":
     - Verify all tasks are shown

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Assignee filter may not be implemented
- ✅ **When implemented**: Tasks can be filtered by assignee
- ✅ Filter works correctly

---

## Test Case 11: Filter Tasks by Tag - Missing Feature

**Objective**: Verify tasks within a project can be filtered by tag (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Tasks exist with tags within the project
- Tag filter feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Locate tag filter dropdown/selector
5. Verify one of the following:
   - **If NOT implemented**: Tag filter is not available (this is expected - feature missing)
   - **If implemented**: Tag filter exists
6. If implemented:
   - Verify filter shows all tag options:
     - All
     - List of available tags
   - Select a specific tag:
     - Verify only tasks with that tag are shown
     - Verify tasks without that tag are hidden
   - Select multiple tags:
     - Verify tasks with any selected tag are shown
   - Select "All":
     - Verify all tasks are shown

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Tag filter is NOT available (missing)
- ✅ **When implemented**: Tasks can be filtered by tag
- ✅ Filter works correctly
- ✅ Multiple tag selection works

---

## Test Case 12: Project Task Status Breakdown - Missing Feature

**Objective**: Verify project shows task status breakdown (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Tasks exist with different statuses within the project
- Status breakdown feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Verify one of the following:
   - **If NOT implemented**: Status breakdown section is not available (this is expected - feature missing)
   - **If implemented**: Status breakdown section appears
5. If implemented:
   - Verify status breakdown shows:
     - Total tasks count
     - Pending tasks count
     - In Progress tasks count
     - Completed tasks count
     - Cancelled tasks count
     - On Hold tasks count
   - Verify breakdown is accurate:
     - Counts match actual task counts
     - Percentages are calculated correctly
   - Verify breakdown is visual:
     - Progress bars or charts
     - Color coding by status
   - Verify breakdown updates when tasks change:
     - Create new task, verify count updates
     - Change task status, verify count updates

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Status breakdown is NOT available (missing)
- ✅ **When implemented**: Project shows task status breakdown
- ✅ Breakdown is accurate
- ✅ Breakdown is visual
- ✅ Breakdown updates in real-time

---

## Test Case 13: Combined Filters - Status + Priority + Assignee

**Objective**: Verify multiple filters can be combined to filter tasks within a project.

**Preconditions**:
- User is logged in
- Project exists
- Tasks exist with different statuses, priorities, and assignees within the project
- Combined filters feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Apply multiple filters:
   - Select status: "In Progress"
   - Select priority: "High"
   - Select assignee: "John Doe"
5. Verify filtered results:
   - Only tasks matching ALL filters are shown:
     - Status is "In Progress"
     - Priority is "High"
     - Assignee is "John Doe"
   - Tasks matching only some filters are hidden
6. Remove one filter:
   - Clear assignee filter
   - Verify results update:
     - Tasks with status "In Progress" and priority "High" are shown (regardless of assignee)
7. Clear all filters:
   - Verify all tasks are shown

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Combined filters may not be fully implemented
- ✅ **When implemented**: Multiple filters can be combined
- ✅ Filter logic works correctly (AND logic)
- ✅ Filters can be cleared individually or all at once

---

## Test Case 14: Task Count Display - Within Project

**Objective**: Verify task count is displayed correctly within project.

**Preconditions**:
- User is logged in
- Project exists
- Tasks exist within the project
- Task count display is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Verify task count is displayed:
   - On project card: "5 tasks" or similar
   - On project detail page: "Total: 5 tasks" or similar
4. Verify count is accurate:
   - Count matches actual number of tasks with matching `projectId`
   - Count excludes tasks with different `projectId`
   - Count excludes deleted tasks
5. Add a new task to project:
   - Verify count increases
6. Remove a task from project:
   - Verify count decreases
7. Delete a task:
   - Verify count decreases

**Expected Results**:
- ✅ Task count is displayed
- ✅ Count is accurate
- ✅ Count updates when tasks change

---

## Test Case 15: Move Task Between Projects - Missing Feature

**Objective**: Verify task can be moved from one project to another (currently missing).

**Preconditions**:
- User is logged in
- User has `manageTasks` permission
- Project A exists
- Project B exists
- Task exists with `projectId` matching Project A
- Move task between projects feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate Project A
3. Tap on Project A to view details
4. Locate a task within Project A
5. Verify one of the following:
   - **If NOT implemented**: "Move to Project" option is not available (this is expected - feature missing)
   - **If implemented**: "Move to Project" option is available
6. If implemented:
   - Tap "Move to Project" option
   - Verify project selector appears:
     - List of available projects
     - Project name displayed
   - Select Project B
   - Confirm move
   - Verify loading indicator appears
   - Wait for move to complete
   - Verify success message appears: "Task moved to project"
   - Verify task is moved:
     - Task no longer appears in Project A tasks
     - Task appears in Project B tasks
     - Task `projectId` is updated to Project B ID
   - Verify task is updated in Firebase:
     - Check Firebase data
     - Verify task has correct `projectId`

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Move task between projects is NOT available (missing)
- ✅ **When implemented**: Task can be moved between projects
- ✅ Task `projectId` is updated
- ✅ Task appears in new project
- ✅ Task is removed from old project

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Tasks within project can be viewed
- [ ] Task can be added to project
- [ ] Task can be removed from project
- [ ] Task within project can be edited
- [ ] Task can be assigned to team (if implemented)
- [ ] Task can be assigned to group (if implemented)
- [ ] Task can be assigned to member
- [ ] Tasks can be filtered by status
- [ ] Tasks can be filtered by priority
- [ ] Tasks can be filtered by assignee
- [ ] Tasks can be filtered by tag (if implemented)
- [ ] Project shows task status breakdown (if implemented)
- [ ] Multiple filters can be combined
- [ ] Task count is displayed correctly
- [ ] Task can be moved between projects (if implemented)

---

## Known Issues (Based on Audit Report)

1. **Team/Group Assignment Missing**:
   - No team/group assignment support for tasks
   - Tasks only have single `assignee` field
   - No `teamId` or `groupId` fields
   - **Status**: ⛔ Missing

2. **Tag Support Missing**:
   - No tags field in TaskEntity
   - No tag filter
   - **Status**: ⛔ Missing

3. **Status Breakdown Missing**:
   - No status breakdown per project
   - Only basic `ProjectStatistics` exists
   - **Status**: ⛔ Missing

4. **Filter Coverage Unclear**:
   - Status/priority/assignee filters may exist but unclear
   - Tag filter missing
   - Team filter missing
   - **Status**: ⚠️ Partial

5. **Task Linkage Exists**:
   - Tasks link via `projectId` field
   - `getProjectTasks` method exists
   - **Status**: ✅ Implemented

---

## Notes for Testers

1. **Current Status**: Tasks can be linked to projects via `projectId`, but team/group assignment, tags, and status breakdown are missing.

2. **Task Assignment**: Currently only single member assignment exists (`assignee` field). Team/group assignment needs to be implemented.

3. **Filters**: Status/priority/assignee filters may exist, but tag and team filters are missing. Need to verify what filters are actually implemented.

4. **Status Breakdown**: Project statistics exist but may not show detailed status breakdown. Need to verify what statistics are displayed.

5. **Task Management**: Add/remove/edit tasks within project may be partially implemented. Need to verify what operations are available.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- Project context
- Task context
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase data (if accessible) showing task `projectId`
- Whether filters are working
- Whether team/group assignment is working
- Whether tags are working
- Whether status breakdown is displayed

