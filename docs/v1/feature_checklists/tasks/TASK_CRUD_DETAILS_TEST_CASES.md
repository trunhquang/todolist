# Task CRUD & Details (Title, Description, Status Enum, Priority Enum, Type, Deadline, Tags, Checklist, Attachments; Creator/Assignee/Updater; Comments/Activity) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Task CRUD & Details** feature. This feature is currently **PARTIAL** - basic CRUD exists but enum enforcement, tags, checklist, attachments, updater tracking, and comments/activity log are missing.

## Prerequisites
- User must be logged in
- Workspace should exist
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: Create Task with Basic Details - Partial Implementation

**Objective**: Verify task can be created with basic details (title, description, status, priority, type, deadline).

**Preconditions**:
- User is logged in
- User has `createTask` permission
- Workspace exists
- Create task feature is implemented

**Steps**:
1. Navigate to Task List page
2. Tap "Create Task" or "+" button
3. Verify create task form appears:
   - Title field
   - Description field
   - Status dropdown/selector
   - Priority dropdown/selector
   - Type dropdown/selector (daily/project)
   - Deadline toggle and date picker
   - Assignee selector
   - Create/Cancel buttons
4. Fill in task details:
   - Enter title: "Complete project documentation"
   - Enter description: "Write comprehensive documentation for the project"
   - Select status: "Pending" (or verify it's default)
   - Select priority: "High"
   - Select type: "Project"
   - Enable deadline toggle
   - Select deadline date
   - Select assignee (optional)
5. Tap "Create" or "Save" button
6. Verify loading indicator appears
7. Wait for task creation to complete
8. Verify success message appears: "Task created successfully"
9. Verify task appears in task list:
   - Task title is displayed
   - Task status is displayed
   - Task priority is displayed
   - Task type is displayed
   - Task deadline is displayed (if set)
   - Task assignee is displayed (if set)
10. Verify task is saved to Firebase:
    - Check Firebase data
    - Verify task has correct workspaceId
    - Verify task has correct assigner (creator)
    - Verify task has correct status/priority/type values

**Expected Results**:
- ✅ Task can be created with basic details
- ✅ Task appears in list
- ✅ Task is saved to Firebase
- ⚠️ **CURRENT ISSUE**: Status/priority/type are stored as strings, not enums

---

## Test Case 2: Create Task with Enum Values - Missing Enum Enforcement

**Objective**: Verify task status/priority/type use enums instead of strings (currently missing).

**Preconditions**:
- User is logged in
- User has `createTask` permission
- Workspace exists
- Enum enforcement is implemented

**Steps**:
1. Navigate to Task List page
2. Tap "Create Task" button
3. Fill in task details:
   - Enter title: "Test Enum Task"
   - Select status: "In Progress"
   - Select priority: "Urgent"
   - Select type: "Daily"
4. Create task
5. Verify one of the following:
   - **If NOT implemented**: Status/priority/type are stored as strings (this is expected - enum enforcement missing)
   - **If implemented**: Status/priority/type are stored using enums from `task_enums.dart`
6. If implemented:
   - Check Firebase data:
     - Verify status is stored as enum value (not string)
     - Verify priority is stored as enum value (not string)
     - Verify type is stored as enum value (not string)
   - Verify type safety:
     - Attempt to set invalid status value
     - Verify validation error appears
     - Attempt to set invalid priority value
     - Verify validation error appears
     - Attempt to set invalid type value
     - Verify validation error appears

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Enum enforcement is NOT implemented (status/priority/type are strings)
- ✅ **When implemented**: Status/priority/type use enums
- ✅ Type safety is enforced
- ✅ Invalid enum values are rejected

---

## Test Case 3: Edit Task Details - Partial Implementation

**Objective**: Verify task details can be edited (currently partial - updater tracking missing).

**Preconditions**:
- User is logged in
- User has `updateTask` permission
- Task exists
- Edit task feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate a task
3. Tap on task or "Edit" button
4. Verify edit task form appears:
   - Title field (pre-filled)
   - Description field (pre-filled)
   - Status dropdown (pre-filled)
   - Priority dropdown (pre-filled)
   - Type dropdown (pre-filled)
   - Deadline field (pre-filled)
   - Assignee selector (pre-filled)
5. Modify task details:
   - Change title: "Updated task title"
   - Change description: "Updated description"
   - Change status: "In Progress"
   - Change priority: "High"
   - Change deadline (if applicable)
6. Tap "Save" button
7. Verify loading indicator appears
8. Wait for update to complete
9. Verify success message appears: "Task updated successfully"
10. Verify task is updated:
    - Updated title is displayed
    - Updated description is displayed
    - Updated status is displayed
    - Updated priority is displayed
11. Verify one of the following:
    - **If NOT implemented**: Updater field is not tracked (this is expected - updater tracking missing)
    - **If implemented**: Updater field is tracked
12. If implemented:
    - Check Firebase data:
      - Verify task has `updatedBy` or `updater` field
      - Verify updater is current user
      - Verify `updatedAt` timestamp is set

**Expected Results**:
- ✅ Task can be edited
- ✅ Changes are saved
- ⚠️ **CURRENT ISSUE**: Updater tracking is missing
- ✅ **When implemented**: Updater is tracked

---

## Test Case 4: Add Tags to Task - Missing Feature

**Objective**: Verify tags can be added to tasks (currently missing).

**Preconditions**:
- User is logged in
- User has `updateTask` permission
- Task exists
- Tags feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate a task
3. Tap on task to view/edit
4. Verify one of the following:
   - **If NOT implemented**: Tags field is not available (this is expected - feature missing)
   - **If implemented**: Tags field or "Add Tags" option exists
5. If implemented:
   - Tap "Add Tags" or tags field
   - Verify tag input appears:
     - Tag input field
     - Existing tags list
     - Add tag button
     - Remove tag option
   - Add tags:
     - Enter tag: "urgent"
     - Tap "Add" or press Enter
     - Verify tag is added to list
     - Enter another tag: "documentation"
     - Add tag
     - Verify both tags are displayed
   - Remove a tag:
     - Tap "X" or remove button on a tag
     - Verify tag is removed
   - Save task
   - Verify tags are saved:
     - Tags are displayed on task card
     - Tags are displayed in task detail view
   - Verify tags are saved to Firebase:
     - Check Firebase data
     - Verify task has `tags` field (array)
     - Verify tags array contains added tags

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Tags are NOT available (missing)
- ✅ **When implemented**: Tags can be added to tasks
- ✅ Tags are displayed correctly
- ✅ Tags are saved to Firebase

---

## Test Case 5: Add Checklist Items to Task - Missing Feature

**Objective**: Verify checklist items can be added to tasks (currently missing).

**Preconditions**:
- User is logged in
- User has `updateTask` permission
- Task exists
- Checklist feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate a task
3. Tap on task to view/edit
4. Verify one of the following:
   - **If NOT implemented**: Checklist section is not available (this is expected - feature missing)
   - **If implemented**: Checklist section exists
5. If implemented:
   - Verify checklist section shows:
     - "Add Checklist Item" button
     - List of checklist items (if any)
     - Progress indicator (e.g., "2/5 completed")
   - Add checklist items:
     - Tap "Add Checklist Item" button
     - Enter item text: "Review requirements"
     - Save item
     - Verify item is added to list
     - Add more items:
       - "Write documentation"
       - "Test implementation"
       - "Get approval"
     - Verify all items are displayed
   - Check/uncheck items:
     - Tap checkbox on an item
     - Verify item is marked as completed
     - Verify progress indicator updates
     - Uncheck item
     - Verify item is marked as incomplete
   - Edit checklist item:
     - Tap on item text
     - Modify text: "Review and update requirements"
     - Save changes
     - Verify item is updated
   - Delete checklist item:
     - Tap delete button on item
     - Confirm deletion
     - Verify item is removed
   - Save task
   - Verify checklist is saved:
     - Checklist items are displayed on task
     - Progress indicator is accurate
   - Verify checklist is saved to Firebase:
     - Check Firebase data
     - Verify task has `checklist` field (array)
     - Verify checklist items are saved with:
       - Item text
       - Completed status
       - Order/index

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Checklist is NOT available (missing)
- ✅ **When implemented**: Checklist items can be added
- ✅ Checklist progress is tracked
- ✅ Checklist is saved to Firebase

---

## Test Case 6: Add Attachments to Task - Missing Feature

**Objective**: Verify attachments can be added to tasks (currently missing).

**Preconditions**:
- User is logged in
- User has `updateTask` permission
- Task exists
- Attachments feature is implemented
- Device has file access permission

**Steps**:
1. Navigate to Task List page
2. Locate a task
3. Tap on task to view/edit
4. Verify one of the following:
   - **If NOT implemented**: Attachments section is not available (this is expected - feature missing)
   - **If implemented**: Attachments section exists
5. If implemented:
   - Verify attachments section shows:
     - "Add Attachment" button
     - List of attachments (if any)
     - Attachment count
   - Add attachment:
     - Tap "Add Attachment" button
     - Verify file picker appears:
       - Gallery option
       - Files option
       - Camera option (if applicable)
     - Select a file (image or document)
     - Verify file is uploaded:
       - Loading indicator appears
       - Upload progress is shown (if applicable)
     - Wait for upload to complete
     - Verify attachment is added:
       - Attachment appears in list
       - File name is displayed
       - File size is displayed (if applicable)
       - File type icon is displayed
   - View attachment:
     - Tap on attachment
     - Verify attachment opens:
       - Image opens in viewer
       - Document opens in viewer/downloads
   - Delete attachment:
     - Tap delete button on attachment
     - Confirm deletion
     - Verify attachment is removed
   - Save task
   - Verify attachments are saved:
     - Attachments are displayed on task
     - Attachment count is accurate
   - Verify attachments are saved to Firebase:
     - Check Firebase data
     - Verify task has `attachments` field (array)
     - Verify attachments array contains:
       - File URL/path
       - File name
       - File size
       - File type
       - Upload timestamp

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Attachments are NOT available (missing)
- ✅ **When implemented**: Attachments can be added
- ✅ Attachments are uploaded correctly
- ✅ Attachments are saved to Firebase

---

## Test Case 7: Add Comment to Task - Missing Feature

**Objective**: Verify comments can be added to tasks (currently missing).

**Preconditions**:
- User is logged in
- User has `updateTask` permission (or comment permission)
- Task exists
- Comments feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate a task
3. Tap on task to view details
4. Verify one of the following:
   - **If NOT implemented**: Comments section is not available (this is expected - feature missing)
   - **If implemented**: Comments section exists
5. If implemented:
   - Verify comments section shows:
     - Comments list (if any)
     - Comment input field
     - "Add Comment" or "Post" button
   - Add a comment:
     - Enter comment text: "This task needs more details"
     - Tap "Add Comment" or "Post" button
     - Verify loading indicator appears
     - Wait for comment to be saved
     - Verify comment appears in list:
       - Comment text is displayed
       - Comment author is displayed
       - Comment timestamp is displayed
   - Add more comments:
     - Enter another comment: "I'll work on this tomorrow"
     - Post comment
     - Verify both comments are displayed
     - Verify comments are ordered by timestamp (newest first or oldest first)
   - Edit comment (if user is author):
     - Tap "Edit" button on own comment
     - Modify comment text
     - Save changes
     - Verify comment is updated
   - Delete comment (if user is author or has permission):
     - Tap "Delete" button on comment
     - Confirm deletion
     - Verify comment is removed
   - Verify comments are saved to Firebase:
     - Check Firebase data
     - Verify task has `comments` field (array) or separate comments collection
     - Verify comments contain:
       - Comment text
       - Author ID
       - Timestamp
       - Edit timestamp (if edited)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Comments are NOT available (missing)
- ✅ **When implemented**: Comments can be added
- ✅ Comments are displayed correctly
- ✅ Comments are saved to Firebase

---

## Test Case 8: View Task Activity Log - Missing Feature

**Objective**: Verify task activity log is displayed (currently missing).

**Preconditions**:
- User is logged in
- Task exists
- Task has been modified (status changes, assignee changes, etc.)
- Activity log feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate a task
3. Tap on task to view details
4. Navigate to "Activity" or "History" tab/section
5. Verify one of the following:
   - **If NOT implemented**: Activity log is not available (this is expected - feature missing)
   - **If implemented**: Activity log is displayed
6. If implemented:
   - Verify activity log shows:
     - List of activities
     - Activity type (created, updated, status changed, assigned, etc.)
     - User who performed action
     - Timestamp
     - Details of change (if applicable)
   - Verify activities are logged:
     - Task created activity
     - Status changed activity (if status was changed)
     - Priority changed activity (if priority was changed)
     - Assignee changed activity (if assignee was changed)
     - Description updated activity (if description was updated)
   - Verify activity details:
     - "Status changed from 'Pending' to 'In Progress' by John Doe"
     - "Assigned to Jane Smith by John Doe"
     - "Priority changed from 'Medium' to 'High' by John Doe"
   - Verify activities are ordered:
     - Most recent first, or
     - Oldest first
   - Verify activity log is saved to Firebase:
     - Check Firebase data
     - Verify task has `activityLog` field (array) or separate activity collection
     - Verify activities contain:
       - Action type
       - User ID
       - Timestamp
       - Change details

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Activity log is NOT available (missing)
- ✅ **When implemented**: Activity log is displayed
- ✅ All task changes are logged
- ✅ Activity log is saved to Firebase

---

## Test Case 9: View Task Creator/Assignee/Updater - Partial Implementation

**Objective**: Verify task creator, assignee, and updater are displayed (currently partial - updater missing).

**Preconditions**:
- User is logged in
- Task exists
- Task has creator, assignee, and has been updated
- Task detail view is implemented

**Steps**:
1. Navigate to Task List page
2. Locate a task
3. Tap on task to view details
4. Navigate to task detail view
5. Verify task information section shows:
   - Task title
   - Task description
   - Task status
   - Task priority
   - Task type
   - Task deadline
6. Verify creator information:
   - "Created by: [User Name]" is displayed
   - Creator name is correct
   - Created date/time is displayed
7. Verify assignee information:
   - "Assigned to: [User Name]" is displayed (if assigned)
   - Assignee name is correct
   - "Unassigned" is displayed (if not assigned)
8. Verify one of the following:
   - **If NOT implemented**: Updater information is not displayed (this is expected - updater tracking missing)
   - **If implemented**: Updater information is displayed
9. If implemented:
   - Verify updater information:
     - "Last updated by: [User Name]" is displayed
     - Updater name is correct
     - Last updated date/time is displayed

**Expected Results**:
- ✅ Creator information is displayed
- ✅ Assignee information is displayed
- ⚠️ **CURRENT ISSUE**: Updater information is missing
- ✅ **When implemented**: Updater information is displayed

---

## Test Case 10: Delete Task - Partial Implementation

**Objective**: Verify task can be deleted (soft delete).

**Preconditions**:
- User is logged in
- User has `deleteTask` permission
- Task exists
- Delete task feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate a task
3. Tap on task or "Delete" button
4. Verify one of the following:
   - **If NOT implemented**: Delete option is not available (this is expected - feature missing)
   - **If implemented**: Delete option exists
5. If implemented:
   - Tap "Delete" button
   - Verify confirmation dialog appears:
     - Warning message about deleting task
     - Task title displayed
     - Cancel button
     - Delete button (red/danger style)
   - Tap "Cancel":
     - Verify dialog closes
     - Verify task is NOT deleted
   - Tap "Delete":
     - Verify loading indicator appears
     - Wait for deletion to complete
     - Verify success message appears: "Task deleted successfully"
     - Verify task is removed from list (or moved to deleted tasks)
     - Verify task is soft deleted in Firebase:
       - Check Firebase data
       - Verify task has `deletedAt` timestamp
       - Verify task is not permanently deleted
   - Verify activity log (if implemented):
     - "Task deleted by [User Name]" activity is logged

**Expected Results**:
- ✅ Task can be deleted
- ✅ Confirmation dialog appears
- ✅ Task is soft deleted (not permanently deleted)
- ✅ Task is removed from active list

---

## Test Case 11: Task Status Enum Validation - Missing Enum Enforcement

**Objective**: Verify task status uses enum and validates correctly (currently missing).

**Preconditions**:
- User is logged in
- User has `createTask` or `updateTask` permission
- Enum enforcement is implemented

**Steps**:
1. Navigate to Task List page
2. Tap "Create Task" button
3. Fill in task details
4. Verify status dropdown:
   - Status options are from `TaskStatus` enum:
     - Pending
     - In Progress
     - Completed
     - Cancelled
     - On Hold
   - Status values are enum values, not strings
5. Select a status
6. Verify one of the following:
   - **If NOT implemented**: Status is stored as string (this is expected - enum enforcement missing)
   - **If implemented**: Status is stored as enum
7. If implemented:
   - Attempt to set invalid status:
     - Try to set status to "invalid_status"
     - Verify validation error appears
     - Verify invalid status is rejected
   - Verify status comparisons use enum:
     - Check code for status comparisons
     - Verify enum is used instead of string comparison

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Status enum enforcement is NOT implemented
- ✅ **When implemented**: Status uses enum
- ✅ Invalid status values are rejected
- ✅ Status comparisons use enum

---

## Test Case 12: Task Priority Enum Validation - Missing Enum Enforcement

**Objective**: Verify task priority uses enum and validates correctly (currently missing).

**Preconditions**:
- User is logged in
- User has `createTask` or `updateTask` permission
- Enum enforcement is implemented

**Steps**:
1. Navigate to Task List page
2. Tap "Create Task" button
3. Fill in task details
4. Verify priority dropdown:
   - Priority options are from `TaskPriority` enum:
     - Low
     - Medium
     - High
     - Urgent
   - Priority values are enum values, not strings
5. Select a priority
6. Verify one of the following:
   - **If NOT implemented**: Priority is stored as string (this is expected - enum enforcement missing)
   - **If implemented**: Priority is stored as enum
7. If implemented:
   - Attempt to set invalid priority:
     - Try to set priority to "invalid_priority"
     - Verify validation error appears
     - Verify invalid priority is rejected
   - Verify priority comparisons use enum:
     - Check code for priority comparisons
     - Verify enum is used instead of string comparison

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Priority enum enforcement is NOT implemented
- ✅ **When implemented**: Priority uses enum
- ✅ Invalid priority values are rejected
- ✅ Priority comparisons use enum

---

## Test Case 13: Task Type Enum Validation - Missing Enum Enforcement

**Objective**: Verify task type uses enum and validates correctly (currently missing).

**Preconditions**:
- User is logged in
- User has `createTask` or `updateTask` permission
- Enum enforcement is implemented

**Steps**:
1. Navigate to Task List page
2. Tap "Create Task" button
3. Fill in task details
4. Verify type dropdown:
   - Type options are from `TaskType` enum:
     - Daily
     - Project
   - Type values are enum values, not strings
5. Select a type
6. Verify one of the following:
   - **If NOT implemented**: Type is stored as string (this is expected - enum enforcement missing)
   - **If implemented**: Type is stored as enum
7. If implemented:
   - Attempt to set invalid type:
     - Try to set type to "invalid_type"
     - Verify validation error appears
     - Verify invalid type is rejected
   - Verify type comparisons use enum:
     - Check code for type comparisons
     - Verify enum is used instead of string comparison

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Type enum enforcement is NOT implemented
- ✅ **When implemented**: Type uses enum
- ✅ Invalid type values are rejected
- ✅ Type comparisons use enum

---

## Test Case 14: Filter Tasks by Tags - Missing Feature

**Objective**: Verify tasks can be filtered by tags (currently missing - tags feature must be implemented first).

**Preconditions**:
- User is logged in
- Tasks exist with different tags
- Tags feature is implemented
- Tag filter feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate filter options
3. Verify one of the following:
   - **If NOT implemented**: Tag filter is not available (this is expected - feature missing)
   - **If implemented**: Tag filter exists
4. If implemented:
   - Verify tag filter shows:
     - List of available tags (from all tasks)
     - Tag count (number of tasks with each tag)
     - "All Tags" option
   - Select a tag:
     - Tap on a tag (e.g., "urgent")
     - Verify only tasks with that tag are shown
     - Verify tasks without that tag are hidden
   - Select multiple tags:
     - Select multiple tags
     - Verify tasks matching any selected tag are shown (OR logic)
     - Or verify tasks matching all selected tags are shown (AND logic)
   - Clear tag filter:
     - Tap "Clear" or "All Tags"
     - Verify all tasks are shown

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Tag filter is NOT available (missing - requires tags feature)
- ✅ **When implemented**: Tasks can be filtered by tags
- ✅ Filter works correctly
- ✅ Multiple tag selection works

---

## Test Case 15: Search Tasks by Tags - Missing Feature

**Objective**: Verify tasks can be searched by tags (currently missing - tags feature must be implemented first).

**Preconditions**:
- User is logged in
- Tasks exist with different tags
- Tags feature is implemented
- Tag search feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate search field
3. Enter tag name in search: "#urgent"
4. Verify one of the following:
   - **If NOT implemented**: Tag search is not available (this is expected - feature missing)
   - **If implemented**: Search results show tasks with matching tag
5. If implemented:
   - Verify search works:
     - Enter "#urgent" in search
     - Verify tasks with "urgent" tag are shown
     - Enter "#documentation" in search
     - Verify tasks with "documentation" tag are shown
   - Verify search highlights:
     - Matching tag is highlighted in results
   - Clear search:
     - Clear search field
     - Verify all tasks are shown

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Tag search is NOT available (missing - requires tags feature)
- ✅ **When implemented**: Tasks can be searched by tags
- ✅ Search works correctly

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Task can be created with basic details (if implemented)
- [ ] Task status/priority/type use enums (if implemented)
- [ ] Task can be edited (if implemented)
- [ ] Tags can be added to tasks (if implemented)
- [ ] Checklist items can be added to tasks (if implemented)
- [ ] Attachments can be added to tasks (if implemented)
- [ ] Comments can be added to tasks (if implemented)
- [ ] Task activity log is displayed (if implemented)
- [ ] Task creator/assignee/updater are displayed (if implemented)
- [ ] Task can be deleted (if implemented)
- [ ] Status enum validation works (if implemented)
- [ ] Priority enum validation works (if implemented)
- [ ] Type enum validation works (if implemented)
- [ ] Tasks can be filtered by tags (if implemented)
- [ ] Tasks can be searched by tags (if implemented)

---

## Known Issues (Based on Audit Report)

1. **Enum Enforcement Missing**:
   - `task_enums.dart` exists but not used
   - Status/priority/type are stored as strings
   - No type safety for enum values
   - **Status**: ⚠️ Partial

2. **Tags Missing**:
   - No tags field in TaskEntity
   - No tag UI
   - No tag filtering
   - **Status**: ⛔ Missing

3. **Checklist Missing**:
   - No checklist field in TaskEntity
   - No checklist UI
   - **Status**: ⛔ Missing

4. **Attachments Missing**:
   - No attachments field in TaskEntity
   - No attachment UI
   - No file upload functionality
   - **Status**: ⛔ Missing

5. **Updater Tracking Missing**:
   - No `updatedBy` or `updater` field in TaskEntity
   - Only `assigner` exists (for creator)
   - **Status**: ⛔ Missing

6. **Comments Missing**:
   - No comment entity
   - No comment UI
   - No comment functionality
   - **Status**: ⛔ Missing

7. **Activity Log Missing**:
   - `ActivityLog` entity exists but for conflict resolution, not task activity
   - No task-specific activity log
   - No activity log UI for tasks
   - **Status**: ⛔ Missing

---

## Notes for Testers

1. **Current Status**: Task CRUD is partially implemented. Basic create/edit/delete works, but:
   - Enums are not enforced (status/priority/type are strings)
   - Tags, checklist, attachments are missing
   - Updater tracking is missing
   - Comments and activity log are missing

2. **Enum Enforcement**: `task_enums.dart` file exists with `TaskStatus`, `TaskPriority`, and `TaskType` enums, but `TaskEntity` still uses strings. Need to:
   - Update `TaskEntity` to use enums
   - Update controllers to use enums
   - Update UI to use enums
   - Add validation for enum values

3. **Tags**: Need to add:
   - `tags` field to `TaskEntity` (List<String>)
   - Tag input UI
   - Tag display UI
   - Tag filtering

4. **Checklist**: Need to add:
   - `checklist` field to `TaskEntity` (List<ChecklistItem>)
   - ChecklistItem entity
   - Checklist UI
   - Checklist progress tracking

5. **Attachments**: Need to add:
   - `attachments` field to `TaskEntity` (List<Attachment>)
   - Attachment entity
   - File upload functionality
   - Attachment UI
   - File storage (Firebase Storage)

6. **Updater Tracking**: Need to add:
   - `updatedBy` or `updater` field to `TaskEntity`
   - Track updater when task is updated
   - Display updater in UI

7. **Comments**: Need to add:
   - Comment entity
   - Comment repository
   - Comment UI
   - Comment service

8. **Activity Log**: Need to add:
   - Task-specific activity log (separate from conflict resolution ActivityLog)
   - Activity log UI
   - Log all task changes (status, priority, assignee, description, etc.)

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- Workspace context
- Task context
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase data (if accessible) showing task data
- Whether enums are being used
- Whether tags/checklist/attachments are working
- Whether comments/activity log are working
