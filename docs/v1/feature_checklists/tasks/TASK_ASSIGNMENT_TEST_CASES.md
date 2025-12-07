# Task Assignment (Team/Group/Member, Reassign, Unassign, Bulk Assign) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Task Assignment** feature (team/group/member, reassign, unassign, bulk assign). This feature is currently **PARTIAL** - single assignee assignment exists, but team/group assignment, bulk operations, and proper reassign/unassign flows are missing.

## Prerequisites
- User must be logged in
- Workspace should exist
- Teams/groups should exist (for team/group assignment tests)
- Workspace members should exist
- Tasks should exist
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: Assign Task to Member - Current Implementation

**Objective**: Verify task can be assigned to a single member (currently implemented).

**Preconditions**:
- User is logged in
- User has `assignTasks` permission
- Task exists
- Workspace members exist
- Assign task to member feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate a task
3. Tap on task or "Assign" button
4. Verify "Assign to Member" or "Assign" option is available
5. Tap "Assign to Member" option
6. Verify member selector appears:
   - List of available workspace members
   - Member name displayed
   - Member role displayed (if applicable)
   - Search field (if applicable)
7. Select a member
8. Confirm assignment
9. Verify loading indicator appears
10. Wait for assignment to complete
11. Verify success message appears: "Task assigned successfully"
12. Verify task is assigned:
    - Task shows assignee name
    - Task has `assignee` field set to member ID
    - Assigned member can view task
13. Verify task is updated in Firebase:
    - Check Firebase data
    - Verify task has `assignee` field set

**Expected Results**:
- ✅ Task can be assigned to member
- ✅ Task has `assignee` field set
- ✅ Assigned member can view task
- ✅ Task is updated in Firebase

---

## Test Case 2: Assign Task to Team - Missing Feature

**Objective**: Verify task can be assigned to a team (currently missing).

**Preconditions**:
- User is logged in
- User has `assignTasks` permission
- Task exists
- Teams exist in workspace
- Assign task to team feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate a task
3. Tap on task or "Assign" button
4. Verify one of the following:
   - **If NOT implemented**: "Assign to Team" option is not available (this is expected - feature missing)
   - **If implemented**: "Assign to Team" option exists
5. If implemented:
   - Tap "Assign to Team" option
   - Verify team selector appears:
     - List of available teams
     - Team name displayed
     - Team member count displayed
     - Team lead displayed (if applicable)
   - Select a team
   - Verify assignment options:
     - "Assign to team lead only" option
     - "Assign to all team members" option
     - "Assign to team (cascade to lead/members)" option
   - Select assignment option (e.g., "Assign to team lead only")
   - Confirm assignment
   - Verify loading indicator appears
   - Wait for assignment to complete
   - Verify success message appears: "Task assigned to team successfully"
   - Verify task is assigned:
     - Task shows team assignment
     - Task has `teamId` field set
     - Team lead can view task (if assigned to lead)
     - Team members can view task (if assigned to all members)
   - Verify cascade behavior (if applicable):
     - If "cascade to lead/members" is selected:
       - Task is visible to team lead
       - Task is visible to all team members
       - Task assignment cascades correctly
   - Verify task is updated in Firebase:
     - Check Firebase data
     - Verify task has `teamId` field set
     - Verify cascade assignments are created (if applicable)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Assign task to team is NOT available (missing)
- ✅ **When implemented**: Task can be assigned to team
- ✅ Team assignment options work correctly
- ✅ Cascade to lead/members works (if implemented)

---

## Test Case 3: Assign Task to Group - Missing Feature

**Objective**: Verify task can be assigned to a group (currently missing).

**Preconditions**:
- User is logged in
- User has `assignTasks` permission
- Task exists
- Groups exist in workspace
- Assign task to group feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate a task
3. Tap on task or "Assign" button
4. Verify one of the following:
   - **If NOT implemented**: "Assign to Group" option is not available (this is expected - feature missing)
   - **If implemented**: "Assign to Group" option exists
5. If implemented:
   - Tap "Assign to Group" option
   - Verify group selector appears:
     - List of available groups
     - Group name displayed
     - Group member count displayed
     - Group lead displayed (if applicable)
   - Select a group
   - Verify assignment options (similar to team assignment)
   - Select assignment option
   - Confirm assignment
   - Verify task is assigned:
     - Task shows group assignment
     - Task has `groupId` field set
     - Group members can view task
   - Verify task is updated in Firebase:
     - Check Firebase data
     - Verify task has `groupId` field set

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Assign task to group is NOT available (missing)
- ✅ **When implemented**: Task can be assigned to group
- ✅ Group assignment works correctly

---

## Test Case 4: Reassign Task - Partial Implementation

**Objective**: Verify task can be reassigned to another member/team/group (currently partial - only overwrites assignee).

**Preconditions**:
- User is logged in
- User has `assignTasks` permission
- Task exists and is already assigned
- Workspace members/teams/groups exist
- Reassign task feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate a task that is already assigned
3. Verify task shows current assignee/team/group
4. Tap on task or "Reassign" button
5. Verify one of the following:
   - **If NOT implemented**: Reassign option is not available (this is expected - feature missing)
   - **If implemented**: Reassign option exists
6. If implemented:
   - Tap "Reassign" option
   - Verify reassign dialog/form appears:
     - Current assignment displayed
     - New assignment selector
     - Reassign/Cancel buttons
   - Select new assignee/team/group
   - Confirm reassignment
   - Verify loading indicator appears
   - Wait for reassignment to complete
   - Verify success message appears: "Task reassigned successfully"
   - Verify task is reassigned:
     - Task shows new assignee/team/group
     - Previous assignee/team/group is removed
     - New assignee/team/group can view task
   - Verify activity log (if implemented):
     - "Task reassigned from [Old] to [New] by [User]" activity is logged
   - Verify task is updated in Firebase:
     - Check Firebase data
     - Verify assignment fields are updated
     - Verify previous assignment is cleared

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Reassign is partially implemented (only overwrites assignee, no proper flow)
- ✅ **When fully implemented**: Task can be reassigned properly
- ✅ Previous assignment is cleared
- ✅ Activity log is updated (if implemented)

---

## Test Case 5: Unassign Task - Missing Feature

**Objective**: Verify task can be unassigned (currently missing).

**Preconditions**:
- User is logged in
- User has `assignTasks` permission
- Task exists and is assigned
- Unassign task feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate a task that is assigned
3. Verify task shows current assignee/team/group
4. Tap on task or "Unassign" button
5. Verify one of the following:
   - **If NOT implemented**: Unassign option is not available (this is expected - feature missing)
   - **If implemented**: Unassign option exists
6. If implemented:
   - Tap "Unassign" option
   - Verify confirmation dialog appears:
     - Warning message about unassigning task
     - Current assignment displayed
     - Cancel button
     - Unassign button (red/danger style)
   - Tap "Cancel":
     - Verify dialog closes
     - Verify task is NOT unassigned
   - Tap "Unassign":
     - Verify loading indicator appears
     - Wait for unassignment to complete
     - Verify success message appears: "Task unassigned successfully"
     - Verify task is unassigned:
       - Task shows "Unassigned" or no assignee
       - Task has `assignee`/`teamId`/`groupId` fields set to null
       - Previous assignee/team/group can no longer view task (if applicable)
   - Verify activity log (if implemented):
     - "Task unassigned by [User]" activity is logged
   - Verify task is updated in Firebase:
     - Check Firebase data
     - Verify assignment fields are set to null

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Unassign is NOT available (missing)
- ✅ **When implemented**: Task can be unassigned
- ✅ Confirmation dialog appears
- ✅ Assignment fields are cleared

---

## Test Case 6: Bulk Assign Tasks to Member - Missing Feature

**Objective**: Verify multiple tasks can be assigned to a member at once (currently missing).

**Preconditions**:
- User is logged in
- User has `assignTasks` permission
- Multiple tasks exist
- Workspace members exist
- Bulk assign feature is implemented

**Steps**:
1. Navigate to Task List page
2. Verify one of the following:
   - **If NOT implemented**: Bulk selection is not available (this is expected - feature missing)
   - **If implemented**: Bulk selection mode exists
3. If implemented:
   - Enable bulk selection mode:
     - Tap "Select" or "Bulk Actions" button
     - Verify selection mode is enabled
   - Select multiple tasks:
     - Tap checkboxes on multiple tasks
     - Verify selected tasks are highlighted
     - Verify selection count is displayed (e.g., "3 tasks selected")
   - Tap "Assign" or "Bulk Assign" button
   - Verify assign dialog appears:
     - Assignment type selector (Member/Team/Group)
     - Member/Team/Group selector
     - Selected tasks count displayed
     - Assign/Cancel buttons
   - Select "Assign to Member"
   - Select a member
   - Tap "Assign" button
   - Verify loading indicator appears
   - Wait for bulk assignment to complete
   - Verify success message appears: "X tasks assigned successfully"
   - Verify all selected tasks are assigned:
     - All tasks show the same assignee
     - All tasks have `assignee` field set
   - Verify tasks are updated in Firebase:
     - Check Firebase data
     - Verify all tasks have `assignee` field set

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Bulk assign is NOT available (missing)
- ✅ **When implemented**: Multiple tasks can be assigned at once
- ✅ All selected tasks are assigned correctly
- ✅ Success message shows count

---

## Test Case 7: Bulk Assign Tasks to Team - Missing Feature

**Objective**: Verify multiple tasks can be assigned to a team at once (currently missing).

**Preconditions**:
- User is logged in
- User has `assignTasks` permission
- Multiple tasks exist
- Teams exist in workspace
- Bulk assign to team feature is implemented

**Steps**:
1. Navigate to Task List page
2. Enable bulk selection mode
3. Select multiple tasks
4. Tap "Bulk Assign" button
5. Select "Assign to Team"
6. Select a team
7. Select assignment option (e.g., "Assign to team lead only")
8. Confirm bulk assignment
9. Verify all selected tasks are assigned to team:
   - All tasks show team assignment
   - All tasks have `teamId` field set
10. Verify cascade behavior (if applicable):
    - Team lead can view all tasks (if assigned to lead)
    - Team members can view all tasks (if assigned to all members)
11. Verify tasks are updated in Firebase

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Bulk assign to team is NOT available (missing)
- ✅ **When implemented**: Multiple tasks can be assigned to team at once
- ✅ Cascade behavior works correctly

---

## Test Case 8: Bulk Reassign Tasks - Missing Feature

**Objective**: Verify multiple tasks can be reassigned at once (currently missing).

**Preconditions**:
- User is logged in
- User has `assignTasks` permission
- Multiple tasks exist and are assigned
- Workspace members/teams/groups exist
- Bulk reassign feature is implemented

**Steps**:
1. Navigate to Task List page
2. Enable bulk selection mode
3. Select multiple assigned tasks
4. Tap "Bulk Reassign" button
5. Select new assignee/team/group
6. Confirm bulk reassignment
7. Verify all selected tasks are reassigned:
   - All tasks show new assignment
   - Previous assignments are cleared
8. Verify tasks are updated in Firebase

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Bulk reassign is NOT available (missing)
- ✅ **When implemented**: Multiple tasks can be reassigned at once
- ✅ All tasks are reassigned correctly

---

## Test Case 9: Bulk Unassign Tasks - Missing Feature

**Objective**: Verify multiple tasks can be unassigned at once (currently missing).

**Preconditions**:
- User is logged in
- User has `assignTasks` permission
- Multiple tasks exist and are assigned
- Bulk unassign feature is implemented

**Steps**:
1. Navigate to Task List page
2. Enable bulk selection mode
3. Select multiple assigned tasks
4. Tap "Bulk Unassign" button
5. Verify confirmation dialog appears:
   - Warning message about unassigning multiple tasks
   - Selected tasks count displayed
   - Cancel button
   - Unassign button
6. Confirm bulk unassignment
7. Verify all selected tasks are unassigned:
   - All tasks show "Unassigned"
   - All tasks have assignment fields set to null
8. Verify tasks are updated in Firebase

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Bulk unassign is NOT available (missing)
- ✅ **When implemented**: Multiple tasks can be unassigned at once
- ✅ All tasks are unassigned correctly

---

## Test Case 10: Cascade Assignment to Team Lead - Missing Feature

**Objective**: Verify task assignment to team cascades to team lead (currently missing).

**Preconditions**:
- User is logged in
- User has `assignTasks` permission
- Task exists
- Team exists with lead
- Cascade assignment feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate a task
3. Assign task to team with "cascade to lead" option
4. Verify one of the following:
   - **If NOT implemented**: Cascade is not available (this is expected - feature missing)
   - **If implemented**: Cascade works correctly
5. If implemented:
   - Verify task is assigned to team:
     - Task has `teamId` field set
   - Verify team lead can view task:
     - Log in as team lead
     - Navigate to task list
     - Verify task is visible
   - Verify cascade assignment:
     - Task is visible to team lead
     - Task assignment cascades correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Cascade to team lead is NOT available (missing)
- ✅ **When implemented**: Task assignment cascades to team lead
- ✅ Team lead can view assigned tasks

---

## Test Case 11: Cascade Assignment to Team Members - Missing Feature

**Objective**: Verify task assignment to team cascades to all team members (currently missing).

**Preconditions**:
- User is logged in
- User has `assignTasks` permission
- Task exists
- Team exists with multiple members
- Cascade assignment feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate a task
3. Assign task to team with "cascade to all members" option
4. Verify one of the following:
   - **If NOT implemented**: Cascade is not available (this is expected - feature missing)
   - **If implemented**: Cascade works correctly
5. If implemented:
   - Verify task is assigned to team
   - Verify all team members can view task:
     - Log in as each team member
     - Navigate to task list
     - Verify task is visible to all members
   - Verify cascade assignment:
     - Task is visible to all team members
     - Task assignment cascades correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Cascade to team members is NOT available (missing)
- ✅ **When implemented**: Task assignment cascades to all team members
- ✅ All team members can view assigned tasks

---

## Test Case 12: Filter Tasks by Assignee - Partial Implementation

**Objective**: Verify tasks can be filtered by assignee (may be partially implemented).

**Preconditions**:
- User is logged in
- Tasks exist with different assignees
- Filter by assignee feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate filter options
3. Verify one of the following:
   - **If NOT implemented**: Assignee filter is not available (this is expected - feature missing)
   - **If implemented**: Assignee filter exists
4. If implemented:
   - Verify assignee filter shows:
     - "All Assignees" option
     - List of assignees (from tasks)
     - "Unassigned" option
   - Select an assignee:
     - Tap on an assignee
     - Verify only tasks assigned to that assignee are shown
     - Verify tasks assigned to other assignees are hidden
   - Select "Unassigned":
     - Verify only unassigned tasks are shown
   - Select "All Assignees":
     - Verify all tasks are shown

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Assignee filter may be partially implemented
- ✅ **When fully implemented**: Tasks can be filtered by assignee
- ✅ Filter works correctly

---

## Test Case 13: Filter Tasks by Team - Missing Feature

**Objective**: Verify tasks can be filtered by team (currently missing - requires team assignment feature).

**Preconditions**:
- User is logged in
- Tasks exist with different team assignments
- Team assignment feature is implemented
- Filter by team feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate filter options
3. Verify one of the following:
   - **If NOT implemented**: Team filter is not available (this is expected - feature missing)
   - **If implemented**: Team filter exists
4. If implemented:
   - Verify team filter shows:
     - "All Teams" option
     - List of teams (from tasks)
   - Select a team:
     - Verify only tasks assigned to that team are shown
   - Select "All Teams":
     - Verify all tasks are shown

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Team filter is NOT available (missing - requires team assignment)
- ✅ **When implemented**: Tasks can be filtered by team
- ✅ Filter works correctly

---

## Test Case 14: View Assigned Tasks - Current Implementation

**Objective**: Verify users can view tasks assigned to them (currently implemented).

**Preconditions**:
- User is logged in
- Tasks exist assigned to current user
- View assigned tasks feature is implemented

**Steps**:
1. Navigate to Task List page
2. Verify "My Tasks" or "Assigned to Me" filter/view exists
3. Select "My Tasks" or "Assigned to Me"
4. Verify tasks assigned to current user are shown:
   - Only tasks with `assignee` matching current user ID are shown
   - Tasks assigned to other users are hidden
5. Verify task information is displayed:
   - Task title
   - Task status
   - Task priority
   - Task deadline (if applicable)

**Expected Results**:
- ✅ Assigned tasks can be viewed
- ✅ Only tasks assigned to current user are shown
- ✅ Task information is displayed correctly

---

## Test Case 15: View Team Assigned Tasks - Missing Feature

**Objective**: Verify team members can view tasks assigned to their team (currently missing).

**Preconditions**:
- User is logged in
- User is member of a team
- Tasks exist assigned to user's team
- Team assignment feature is implemented
- View team tasks feature is implemented

**Steps**:
1. Navigate to Task List page
2. Verify one of the following:
   - **If NOT implemented**: "Team Tasks" filter/view is not available (this is expected - feature missing)
   - **If implemented**: "Team Tasks" filter/view exists
3. If implemented:
   - Select "Team Tasks" or "Assigned to My Team"
   - Verify tasks assigned to user's team are shown:
     - Only tasks with `teamId` matching user's team ID are shown
     - Tasks assigned to other teams are hidden
   - Verify task information is displayed correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: View team tasks is NOT available (missing - requires team assignment)
- ✅ **When implemented**: Team members can view team assigned tasks
- ✅ Only team assigned tasks are shown

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Task can be assigned to member (if implemented)
- [ ] Task can be assigned to team (if implemented)
- [ ] Task can be assigned to group (if implemented)
- [ ] Task can be reassigned (if implemented)
- [ ] Task can be unassigned (if implemented)
- [ ] Multiple tasks can be assigned at once (if implemented)
- [ ] Multiple tasks can be reassigned at once (if implemented)
- [ ] Multiple tasks can be unassigned at once (if implemented)
- [ ] Cascade to team lead works (if implemented)
- [ ] Cascade to team members works (if implemented)
- [ ] Tasks can be filtered by assignee (if implemented)
- [ ] Tasks can be filtered by team (if implemented)
- [ ] Users can view assigned tasks (if implemented)
- [ ] Team members can view team tasks (if implemented)

---

## Known Issues (Based on Audit Report)

1. **Team/Group Assignment Missing**:
   - No `teamId` or `groupId` fields in TaskEntity
   - No team/group assignment UI
   - No team/group assignment logic
   - **Status**: ⛔ Missing

2. **Bulk Operations Missing**:
   - No bulk assign functionality
   - No bulk reassign functionality
   - No bulk unassign functionality
   - **Status**: ⛔ Missing

3. **Reassign Flow Missing**:
   - Reassign only overwrites assignee (no proper flow)
   - No reassign confirmation
   - No activity log for reassignment
   - **Status**: ⚠️ Partial

4. **Unassign Missing**:
   - No unassign functionality
   - No unassign UI
   - **Status**: ⛔ Missing

5. **Cascade Missing**:
   - No cascade to team lead
   - No cascade to team members
   - **Status**: ⛔ Missing

---

## Notes for Testers

1. **Current Status**: Task assignment is partially implemented. Only single member assignment exists. Team/group assignment, bulk operations, and proper reassign/unassign flows are missing.

2. **Single Assignee**: Currently, tasks can only be assigned to a single member via the `assignee` field. This works but is limited.

3. **Team/Group Assignment**: Need to add:
   - `teamId` and `groupId` fields to TaskEntity
   - Team/group assignment UI
   - Team/group assignment logic
   - Cascade behavior (assign to team lead or all members)

4. **Bulk Operations**: Need to add:
   - Bulk selection UI
   - Bulk assign functionality
   - Bulk reassign functionality
   - Bulk unassign functionality

5. **Reassign**: Currently, reassigning just overwrites the assignee. Need proper reassign flow with:
   - Reassign confirmation
   - Activity log entry
   - Clear previous assignment

6. **Unassign**: Need to add:
   - Unassign functionality
   - Unassign UI
   - Clear assignment fields

7. **Cascade**: When assigning to team/group, need to cascade to:
   - Team lead (if "assign to lead" option)
   - All team members (if "assign to all members" option)

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- Workspace context
- Team/group context (if applicable)
- Task context
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase data (if accessible) showing task assignment data
- Whether team/group assignment is working
- Whether bulk operations are working
