# Milestones/Phases Linked to Tasks - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Milestones/Phases Linked to Tasks** feature. This feature is currently **MISSING** - no milestone entity/UI exists, and tasks cannot be linked to milestones/phases.

## Prerequisites
- User must be logged in
- Workspace should exist
- Project should exist
- Tasks should exist within project
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: View Milestones/Phases - Missing Feature

**Objective**: Verify milestones/phases can be viewed for a project (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Project has milestones/phases created
- View milestones feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Verify one of the following:
   - **If NOT implemented**: "Milestones" or "Phases" section is not available (this is expected - feature missing)
   - **If implemented**: "Milestones" or "Phases" section appears
5. If implemented:
   - Verify milestones/phases section shows:
     - List of milestones/phases
     - Milestone/phase name
     - Milestone/phase description (if available)
     - Milestone/phase deadline (if available)
     - Milestone/phase status (planned, in progress, completed)
     - Progress indicator (tasks completed / total tasks)
     - Tasks linked to milestone/phase
   - Verify milestones/phases are ordered:
     - By deadline (soonest first)
     - Or by creation date
     - Or by custom order

**Expected Results**:
- ⚠️ **CURRENT STATUS**: View milestones/phases is NOT available (missing)
- ✅ **When implemented**: Milestones/phases can be viewed
- ✅ Milestone/phase information is displayed correctly
- ✅ Progress indicators are accurate

---

## Test Case 2: Create Milestone - Missing Feature

**Objective**: Verify milestone can be created for a project (currently missing).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Create milestone feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Navigate to Milestones section
5. Verify one of the following:
   - **If NOT implemented**: "Create Milestone" or "Add Milestone" button is not available (this is expected - feature missing)
   - **If implemented**: "Create Milestone" or "Add Milestone" button exists
6. If implemented:
   - Tap "Create Milestone" button
   - Verify create milestone dialog/page appears:
     - Title field
     - Description field (optional)
     - Deadline field (optional)
     - Status field (if applicable)
     - Create/Cancel buttons
   - Fill in milestone details:
     - Enter milestone title: "Phase 1: Planning"
     - Enter description: "Complete planning phase"
     - Select deadline (optional)
   - Tap "Create" or "Save" button
   - Verify loading indicator appears
   - Wait for milestone creation to complete
   - Verify success message appears: "Milestone created successfully"
   - Verify milestone appears in milestones list:
     - Milestone title is displayed
     - Milestone is linked to project
   - Verify milestone is saved to Firebase:
     - Check Firebase data
     - Verify milestone has correct projectId
     - Verify milestone has correct workspaceId

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Create milestone is NOT available (missing)
- ✅ **When implemented**: Milestone can be created
- ✅ Milestone appears in list
- ✅ Milestone is saved to Firebase

---

## Test Case 3: Edit Milestone - Missing Feature

**Objective**: Verify milestone can be edited (currently missing).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Milestone exists
- Edit milestone feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Navigate to Milestones section
5. Locate a milestone
6. Tap on milestone or "Edit" button
7. Verify one of the following:
   - **If NOT implemented**: Edit option is not available (this is expected - feature missing)
   - **If implemented**: Edit milestone dialog/page appears
8. If implemented:
   - Verify edit form is pre-filled:
     - Title field (pre-filled)
     - Description field (pre-filled)
     - Deadline field (pre-filled)
     - Status field (pre-filled)
   - Modify milestone details:
     - Change title: "Phase 1: Planning & Design"
     - Change description: "Updated description"
     - Change deadline (if applicable)
   - Tap "Save" button
   - Verify loading indicator appears
   - Wait for update to complete
   - Verify success message appears: "Milestone updated successfully"
   - Verify milestone is updated in list:
     - Updated title is displayed
     - Updated description is displayed
   - Verify milestone is updated in Firebase:
     - Check Firebase data
     - Verify changes are saved

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Edit milestone is NOT available (missing)
- ✅ **When implemented**: Milestone can be edited
- ✅ Changes are saved
- ✅ Milestone is updated in Firebase

---

## Test Case 4: Delete Milestone - Missing Feature

**Objective**: Verify milestone can be deleted (currently missing).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Milestone exists
- Delete milestone feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Navigate to Milestones section
5. Locate a milestone
6. Tap "Delete" button or option
7. Verify one of the following:
   - **If NOT implemented**: Delete option is not available (this is expected - feature missing)
   - **If implemented**: Confirmation dialog appears
8. If implemented:
   - Verify confirmation dialog:
     - Warning message about deleting milestone
     - Milestone name displayed
     - Warning about unlinking tasks (if tasks are linked)
     - Cancel button
     - Delete button (red/danger style)
   - Tap "Cancel":
     - Verify dialog closes
     - Verify milestone is NOT deleted
   - Tap "Delete":
     - Verify loading indicator appears
     - Wait for deletion to complete
     - Verify success message appears: "Milestone deleted successfully"
     - Verify milestone is removed from list
     - Verify milestone is deleted from Firebase:
       - Check Firebase data
       - Verify milestone is removed
     - Verify tasks are unlinked (if applicable):
       - Tasks that were linked to milestone have milestoneId set to null

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Delete milestone is NOT available (missing)
- ✅ **When implemented**: Milestone can be deleted
- ✅ Confirmation dialog appears
- ✅ Tasks are unlinked when milestone is deleted

---

## Test Case 5: Link Task to Milestone - Missing Feature

**Objective**: Verify task can be linked to a milestone (currently missing).

**Preconditions**:
- User is logged in
- User has `manageTasks` permission
- Project exists
- Milestone exists
- Task exists within project
- Link task to milestone feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Navigate to Tasks section
5. Locate a task
6. Tap on task or "Edit" button
7. Verify one of the following:
   - **If NOT implemented**: "Link to Milestone" option is not available (this is expected - feature missing)
   - **If implemented**: "Link to Milestone" or "Milestone" field exists
8. If implemented:
   - Tap "Link to Milestone" or select milestone field
   - Verify milestone selector appears:
     - List of available milestones in project
     - Milestone name displayed
     - Milestone deadline displayed (if available)
     - "None" or "Unlink" option
   - Select a milestone
   - Save task
   - Verify loading indicator appears
   - Wait for update to complete
   - Verify success message appears: "Task linked to milestone"
   - Verify task is linked:
     - Task shows milestone name
     - Task has `milestoneId` field set
     - Task appears in milestone's task list
   - Verify task is updated in Firebase:
     - Check Firebase data
     - Verify task has `milestoneId` field

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Link task to milestone is NOT available (missing)
- ✅ **When implemented**: Task can be linked to milestone
- ✅ Task has milestoneId field
- ✅ Task appears in milestone's task list

---

## Test Case 6: Unlink Task from Milestone - Missing Feature

**Objective**: Verify task can be unlinked from a milestone (currently missing).

**Preconditions**:
- User is logged in
- User has `manageTasks` permission
- Project exists
- Milestone exists
- Task exists and is linked to milestone
- Unlink task feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Navigate to Tasks section
5. Locate a task that is linked to a milestone
6. Tap on task or "Edit" button
7. Verify milestone field shows current milestone
8. Change milestone to "None" or "Unlink"
9. Save task
10. Verify loading indicator appears
11. Wait for update to complete
12. Verify success message appears: "Task unlinked from milestone"
13. Verify task is unlinked:
    - Task no longer shows milestone name
    - Task has `milestoneId` field set to null
    - Task no longer appears in milestone's task list
14. Verify task is updated in Firebase:
    - Check Firebase data
    - Verify task has `milestoneId` field set to null

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Unlink task from milestone is NOT available (missing)
- ✅ **When implemented**: Task can be unlinked from milestone
- ✅ Task milestoneId is set to null
- ✅ Task is removed from milestone's task list

---

## Test Case 7: View Tasks by Milestone - Missing Feature

**Objective**: Verify tasks can be filtered/viewed by milestone (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Project has milestones
- Tasks exist and are linked to different milestones
- View tasks by milestone feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Navigate to Milestones section
5. Locate a milestone
6. Tap on milestone to view details
7. Verify one of the following:
   - **If NOT implemented**: Milestone detail view is not available (this is expected - feature missing)
   - **If implemented**: Milestone detail view appears
8. If implemented:
   - Verify milestone detail shows:
     - Milestone information (title, description, deadline, status)
     - Tasks linked to milestone
     - Task count (e.g., "5 tasks")
     - Progress indicator
   - Verify tasks list shows:
     - Only tasks linked to this milestone
     - Tasks from other milestones are NOT shown
     - Unlinked tasks are NOT shown
   - Verify task information is displayed:
     - Task title
     - Task status
     - Task priority
     - Task assignee
     - Task deadline

**Expected Results**:
- ⚠️ **CURRENT STATUS**: View tasks by milestone is NOT available (missing)
- ✅ **When implemented**: Tasks can be viewed by milestone
- ✅ Only linked tasks are shown
- ✅ Task information is displayed correctly

---

## Test Case 8: Milestone Progress Tracking - Missing Feature

**Objective**: Verify milestone progress is tracked and displayed (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Milestone exists
- Tasks exist and are linked to milestone
- Milestone progress tracking is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Navigate to Milestones section
5. Locate a milestone
6. Verify one of the following:
   - **If NOT implemented**: Progress indicator is not available (this is expected - feature missing)
   - **If implemented**: Progress indicator is displayed
7. If implemented:
   - Verify progress indicator shows:
     - Total tasks in milestone
     - Completed tasks count
     - Progress percentage (e.g., "60%")
     - Progress bar
   - Verify progress is accurate:
     - Count matches actual task counts
     - Percentage is calculated correctly
   - Complete a task in milestone:
     - Mark task as completed
     - Verify progress updates:
       - Completed count increases
       - Progress percentage increases
       - Progress bar updates
   - Add a new task to milestone:
     - Link new task to milestone
     - Verify progress updates:
       - Total count increases
       - Progress percentage may decrease (if task is not completed)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Milestone progress tracking is NOT available (missing)
- ✅ **When implemented**: Milestone progress is tracked
- ✅ Progress is accurate
- ✅ Progress updates in real-time

---

## Test Case 9: Milestone Completion - Missing Feature

**Objective**: Verify milestone completion is detected and displayed (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Milestone exists
- Tasks exist and are linked to milestone
- Milestone completion detection is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Navigate to Milestones section
5. Locate a milestone
6. Complete all tasks in milestone:
   - Mark all tasks as completed
7. Verify one of the following:
   - **If NOT implemented**: Milestone completion is not detected (this is expected - feature missing)
   - **If implemented**: Milestone is marked as completed
8. If implemented:
   - Verify milestone status changes:
     - Status changes to "Completed"
     - Completion date is set
     - Completion indicator is displayed
   - Verify milestone appearance:
     - Milestone is highlighted or marked
     - Progress shows 100%
     - Success indicator is displayed
   - Verify notification (if applicable):
     - Notification is sent: "Milestone completed"
     - Notification includes milestone name

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Milestone completion is NOT detected (missing)
- ✅ **When implemented**: Milestone completion is detected
- ✅ Milestone status is updated
- ✅ Notification is sent (if applicable)

---

## Test Case 10: Milestone Deadline Tracking - Missing Feature

**Objective**: Verify milestone deadline is tracked and overdue detection works (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Milestone exists with deadline
- Milestone deadline tracking is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Navigate to Milestones section
5. Locate a milestone with deadline
6. Verify one of the following:
   - **If NOT implemented**: Deadline tracking is not available (this is expected - feature missing)
   - **If implemented**: Deadline is displayed
7. If implemented:
   - Verify deadline display:
     - Deadline date is shown
     - Days until deadline is shown (if future)
     - Days overdue is shown (if past)
   - Verify overdue detection:
     - If deadline has passed and milestone is not completed:
       - Milestone is marked as overdue
       - Overdue indicator is displayed (red color or warning icon)
       - Days overdue is shown
   - Verify near-due detection:
     - If deadline is approaching (e.g., within 3 days):
       - Milestone is marked as near-due
       - Warning indicator is displayed (yellow/orange color)
       - Days until deadline is shown

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Milestone deadline tracking is NOT available (missing)
- ✅ **When implemented**: Milestone deadline is tracked
- ✅ Overdue detection works
- ✅ Near-due detection works

---

## Test Case 11: Create Phase - Missing Feature

**Objective**: Verify phase can be created for a project (currently missing).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Create phase feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Navigate to Phases section (or Milestones/Phases section)
5. Verify one of the following:
   - **If NOT implemented**: "Create Phase" button is not available (this is expected - feature missing)
   - **If implemented**: "Create Phase" button exists
6. If implemented:
   - Tap "Create Phase" button
   - Verify create phase dialog/page appears:
     - Title field
     - Description field (optional)
     - Start date field (optional)
     - End date field (optional)
     - Status field (if applicable)
     - Create/Cancel buttons
   - Fill in phase details:
     - Enter phase title: "Phase 1: Planning"
     - Enter description: "Planning phase"
     - Select start date
     - Select end date
   - Tap "Create" or "Save" button
   - Verify phase is created:
     - Phase appears in phases list
     - Phase is linked to project
   - Verify phase is saved to Firebase

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Create phase is NOT available (missing)
- ✅ **When implemented**: Phase can be created
- ✅ Phase appears in list
- ✅ Phase is saved to Firebase

---

## Test Case 12: Link Task to Phase - Missing Feature

**Objective**: Verify task can be linked to a phase (currently missing).

**Preconditions**:
- User is logged in
- User has `manageTasks` permission
- Project exists
- Phase exists
- Task exists within project
- Link task to phase feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Navigate to Tasks section
5. Locate a task
6. Edit task
7. Verify one of the following:
   - **If NOT implemented**: "Link to Phase" option is not available (this is expected - feature missing)
   - **If implemented**: "Link to Phase" or "Phase" field exists
8. If implemented:
   - Select a phase from dropdown
   - Save task
   - Verify task is linked:
     - Task shows phase name
     - Task has `phaseId` field set
     - Task appears in phase's task list
   - Verify task is updated in Firebase

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Link task to phase is NOT available (missing)
- ✅ **When implemented**: Task can be linked to phase
- ✅ Task has phaseId field
- ✅ Task appears in phase's task list

---

## Test Case 13: Milestone/Phase Ordering - Missing Feature

**Objective**: Verify milestones/phases can be reordered (currently missing).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Multiple milestones/phases exist
- Reordering feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Navigate to Milestones/Phases section
5. Verify one of the following:
   - **If NOT implemented**: Reorder option is not available (this is expected - feature missing)
   - **If implemented**: Reorder option exists
6. If implemented:
   - Verify reorder methods:
     - Drag and drop
     - Up/Down arrows
     - Order field
   - Reorder milestones/phases:
     - Move milestone A before milestone B
     - Save order
   - Verify order is updated:
     - Milestones/phases are displayed in new order
     - Order is persisted
   - Verify order is saved to Firebase:
     - Check Firebase data
     - Verify `order` or `sortOrder` field is updated

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Milestone/phase ordering is NOT available (missing)
- ✅ **When implemented**: Milestones/phases can be reordered
- ✅ Order is persisted
- ✅ Order is saved to Firebase

---

## Test Case 14: Bulk Link Tasks to Milestone - Missing Feature

**Objective**: Verify multiple tasks can be linked to a milestone at once (currently missing).

**Preconditions**:
- User is logged in
- User has `manageTasks` permission
- Project exists
- Milestone exists
- Multiple tasks exist within project
- Bulk link feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Navigate to Tasks section
5. Verify one of the following:
   - **If NOT implemented**: "Bulk Link to Milestone" option is not available (this is expected - feature missing)
   - **If implemented**: "Bulk Link to Milestone" option exists
6. If implemented:
   - Select multiple tasks (checkboxes)
   - Tap "Bulk Link to Milestone" option
   - Select a milestone
   - Confirm bulk link
   - Verify loading indicator appears
   - Wait for bulk link to complete
   - Verify success message appears: "X tasks linked to milestone"
   - Verify all selected tasks are linked:
     - All tasks have milestoneId set
     - All tasks appear in milestone's task list
   - Verify tasks are updated in Firebase

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Bulk link is NOT available (missing)
- ✅ **When implemented**: Multiple tasks can be linked at once
- ✅ All tasks are linked correctly
- ✅ Success message shows count

---

## Test Case 15: Milestone/Phase Filter in Task List - Missing Feature

**Objective**: Verify tasks can be filtered by milestone/phase (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Project has milestones/phases
- Tasks exist and are linked to different milestones/phases
- Milestone/phase filter feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Navigate to Tasks section
5. Locate filter dropdown/selector
6. Verify one of the following:
   - **If NOT implemented**: Milestone/phase filter is not available (this is expected - feature missing)
   - **If implemented**: Milestone/phase filter exists
7. If implemented:
   - Verify filter shows:
     - All tasks
     - List of milestones/phases
     - Unlinked tasks option
   - Select a milestone/phase:
     - Verify only tasks linked to that milestone/phase are shown
     - Verify tasks from other milestones/phases are hidden
   - Select "Unlinked":
     - Verify only unlinked tasks are shown
   - Select "All":
     - Verify all tasks are shown

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Milestone/phase filter is NOT available (missing)
- ✅ **When implemented**: Tasks can be filtered by milestone/phase
- ✅ Filter works correctly
- ✅ All filter options are available

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Milestones/phases can be viewed (if implemented)
- [ ] Milestone can be created (if implemented)
- [ ] Milestone can be edited (if implemented)
- [ ] Milestone can be deleted (if implemented)
- [ ] Task can be linked to milestone (if implemented)
- [ ] Task can be unlinked from milestone (if implemented)
- [ ] Tasks can be viewed by milestone (if implemented)
- [ ] Milestone progress is tracked (if implemented)
- [ ] Milestone completion is detected (if implemented)
- [ ] Milestone deadline is tracked (if implemented)
- [ ] Phase can be created (if implemented)
- [ ] Task can be linked to phase (if implemented)
- [ ] Milestones/phases can be reordered (if implemented)
- [ ] Multiple tasks can be linked to milestone at once (if implemented)
- [ ] Tasks can be filtered by milestone/phase (if implemented)

---

## Known Issues (Based on Audit Report)

1. **Milestone/Phase Entity Missing**:
   - No milestone entity
   - No phase entity
   - No milestone/phase UI
   - **Status**: ⛔ Missing

2. **Task Linkage Missing**:
   - Tasks have `projectId` but no `milestoneId` or `phaseId`
   - Cannot link tasks to milestones/phases
   - **Status**: ⛔ Missing

3. **Milestone/Phase Management Missing**:
   - No CRUD operations for milestones/phases
   - No milestone/phase repository
   - **Status**: ⛔ Missing

---

## Notes for Testers

1. **Current Status**: Milestones/phases are completely missing. No entity, no UI, no functionality.

2. **Milestone vs Phase**: Need to clarify if milestones and phases are the same thing or different:
   - **Milestone**: Significant point/event in project (e.g., "Phase 1 Complete", "Beta Release")
   - **Phase**: Stage of project (e.g., "Planning", "Development", "Testing", "Deployment")
   - Could be combined into one entity or kept separate

3. **Task Linkage**: Tasks need `milestoneId` and/or `phaseId` fields to link to milestones/phases.

4. **Progress Tracking**: Milestones/phases should track progress based on linked tasks.

5. **Completion**: Milestones/phases should be marked as completed when all linked tasks are completed.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- Project context
- Milestone/phase context
- Task context
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase data (if accessible) showing milestone/phase data
- Whether milestones/phases are working
- Whether task linkage is working

