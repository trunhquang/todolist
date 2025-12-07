# Project Tracking & Reporting (Dashboard, Task Charts, Burndown/Burnup, Overdue/Near-Due List, Change Log) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Project Tracking & Reporting** feature (project dashboard, task charts, burndown/burnup, overdue/near-due list, change log for status/members/deadline/budget). This feature is currently **PARTIAL** - `project_progress_card.dart` provides progress display, but no burndown/burnup or change log; overdue/near-due not surfaced.

## Prerequisites
- User must be logged in
- Workspace should exist
- Projects should exist
- Tasks should exist within projects
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: View Project Dashboard - Missing Feature

**Objective**: Verify project dashboard exists and displays project overview (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Project has tasks
- Project dashboard feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Verify one of the following:
   - **If NOT implemented**: "Dashboard" tab or section is not available (this is expected - feature missing)
   - **If implemented**: "Dashboard" tab or section appears
5. If implemented:
   - Verify dashboard shows:
     - Project overview (title, description, status)
     - Progress metrics (completion percentage, total tasks, completed tasks)
     - Task statistics (by status, by priority)
     - Charts section (task distribution charts)
     - Overdue/near-due tasks section
     - Recent activity/change log section
   - Verify dashboard is visually organized:
     - Sections are clearly separated
     - Information is easy to read
     - Charts are displayed correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Project dashboard is NOT available (missing)
- ✅ **When implemented**: Project dashboard exists
- ✅ Dashboard displays comprehensive project information
- ✅ Dashboard is visually organized

---

## Test Case 2: View Task Status Distribution Chart - Missing Feature

**Objective**: Verify task status distribution chart is displayed (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Project has tasks with different statuses
- Task charts feature is implemented

**Steps**:
1. Navigate to Project Dashboard
2. Locate "Task Status Distribution" or "Tasks by Status" section
3. Verify one of the following:
   - **If NOT implemented**: Chart is not available (this is expected - feature missing)
   - **If implemented**: Chart is displayed
4. If implemented:
   - Verify chart type:
     - Pie chart or bar chart
     - Shows task distribution by status
   - Verify chart data:
     - Pending tasks count
     - In Progress tasks count
     - Completed tasks count
     - Cancelled tasks count
     - On Hold tasks count (if applicable)
   - Verify chart is interactive:
     - Can hover/tap to see details
     - Shows exact counts or percentages
   - Verify chart updates when tasks change:
     - Change task status, verify chart updates
     - Add new task, verify chart updates

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Task status chart is NOT available (missing)
- ✅ **When implemented**: Task status chart is displayed
- ✅ Chart shows accurate data
- ✅ Chart is interactive
- ✅ Chart updates in real-time

---

## Test Case 3: View Task Priority Distribution Chart - Missing Feature

**Objective**: Verify task priority distribution chart is displayed (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Project has tasks with different priorities
- Task charts feature is implemented

**Steps**:
1. Navigate to Project Dashboard
2. Locate "Task Priority Distribution" or "Tasks by Priority" section
3. Verify one of the following:
   - **If NOT implemented**: Chart is not available (this is expected - feature missing)
   - **If implemented**: Chart is displayed
4. If implemented:
   - Verify chart type:
     - Bar chart or pie chart
     - Shows task distribution by priority
   - Verify chart data:
     - Low priority tasks count
     - Medium priority tasks count
     - High priority tasks count
     - Urgent priority tasks count
   - Verify chart is color-coded:
     - Each priority has distinct color
     - Colors match priority colors in app
   - Verify chart updates when tasks change

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Task priority chart is NOT available (missing)
- ✅ **When implemented**: Task priority chart is displayed
- ✅ Chart shows accurate data
- ✅ Chart is color-coded

---

## Test Case 4: View Burndown Chart - Missing Feature

**Objective**: Verify burndown chart is displayed for project (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Project has tasks with deadlines
- Project has deadline
- Burndown chart feature is implemented

**Steps**:
1. Navigate to Project Dashboard
2. Locate "Burndown Chart" section
3. Verify one of the following:
   - **If NOT implemented**: Burndown chart is not available (this is expected - feature missing)
   - **If implemented**: Burndown chart is displayed
4. If implemented:
   - Verify chart type:
     - Line chart showing remaining work over time
     - X-axis: Time (days/weeks)
     - Y-axis: Remaining tasks or story points
   - Verify chart shows:
     - Ideal burndown line (straight line from start to deadline)
     - Actual burndown line (actual progress over time)
     - Current date marker
     - Project deadline marker
   - Verify chart data:
     - Historical data points (if available)
     - Current remaining work
     - Projected completion date
   - Verify chart updates:
     - When tasks are completed, chart updates
     - When deadline changes, chart updates

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Burndown chart is NOT available (missing)
- ✅ **When implemented**: Burndown chart is displayed
- ✅ Chart shows ideal vs actual progress
- ✅ Chart is accurate
- ✅ Chart updates in real-time

---

## Test Case 5: View Burnup Chart - Missing Feature

**Objective**: Verify burnup chart is displayed for project (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Project has tasks
- Burnup chart feature is implemented

**Steps**:
1. Navigate to Project Dashboard
2. Locate "Burnup Chart" section
3. Verify one of the following:
   - **If NOT implemented**: Burnup chart is not available (this is expected - feature missing)
   - **If implemented**: Burnup chart is displayed
4. If implemented:
   - Verify chart type:
     - Line chart showing completed work over time
     - X-axis: Time (days/weeks)
     - Y-axis: Completed tasks or story points
   - Verify chart shows:
     - Total scope line (total tasks in project)
     - Completed work line (tasks completed over time)
     - Current date marker
   - Verify chart data:
     - Historical completion data
     - Current completion status
     - Projected completion date (if ahead/behind schedule)
   - Verify chart updates:
     - When tasks are completed, chart updates
     - When tasks are added, scope line updates

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Burnup chart is NOT available (missing)
- ✅ **When implemented**: Burnup chart is displayed
- ✅ Chart shows scope vs completed work
- ✅ Chart is accurate
- ✅ Chart updates in real-time

---

## Test Case 6: View Overdue Tasks List - Missing Feature

**Objective**: Verify overdue tasks list is displayed (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Project has tasks with deadlines
- Some tasks are overdue
- Overdue tasks list feature is implemented

**Steps**:
1. Navigate to Project Dashboard
2. Locate "Overdue Tasks" or "Tasks Overdue" section
3. Verify one of the following:
   - **If NOT implemented**: Overdue tasks list is not available (this is expected - feature missing)
   - **If implemented**: Overdue tasks list appears
4. If implemented:
   - Verify list shows:
     - All overdue tasks in project
     - Task title
     - Task assignee
     - Days overdue
     - Task priority
     - Task status
   - Verify list is sorted:
     - By days overdue (most overdue first)
     - Or by priority (urgent first)
   - Verify overdue indicator:
     - Tasks are highlighted (red color or warning icon)
     - Days overdue is clearly displayed
   - Verify list updates:
     - When task deadline passes, task appears in list
     - When task is completed, task is removed from list
     - When task deadline is updated, task is removed/added accordingly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Overdue tasks list is NOT available (missing)
- ✅ **When implemented**: Overdue tasks list is displayed
- ✅ List shows all overdue tasks
- ✅ List is sorted and organized
- ✅ List updates in real-time

---

## Test Case 7: View Near-Due Tasks List - Missing Feature

**Objective**: Verify near-due tasks list is displayed (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Project has tasks with deadlines
- Some tasks are near-due (within X days)
- Near-due tasks list feature is implemented

**Steps**:
1. Navigate to Project Dashboard
2. Locate "Near-Due Tasks" or "Tasks Due Soon" section
3. Verify one of the following:
   - **If NOT implemented**: Near-due tasks list is not available (this is expected - feature missing)
   - **If implemented**: Near-due tasks list appears
4. If implemented:
   - Verify list shows:
     - All near-due tasks in project (e.g., due within 3 days)
     - Task title
     - Task assignee
     - Days until due
     - Task priority
     - Task status
   - Verify list is sorted:
     - By days until due (soonest first)
     - Or by priority
   - Verify near-due indicator:
     - Tasks are highlighted (yellow/orange color or warning icon)
     - Days until due is clearly displayed
   - Verify threshold is configurable:
     - Can set "near-due" threshold (e.g., 3 days, 7 days)
   - Verify list updates:
     - When task deadline approaches threshold, task appears
     - When task deadline passes threshold, task moves to overdue list
     - When task is completed, task is removed from list

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Near-due tasks list is NOT available (missing)
- ✅ **When implemented**: Near-due tasks list is displayed
- ✅ List shows all near-due tasks
- ✅ Threshold is configurable
- ✅ List updates in real-time

---

## Test Case 8: View Project Change Log - Missing Feature

**Objective**: Verify project change log is displayed (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Project has changes (status, members, deadline, etc.)
- Change log feature is implemented

**Steps**:
1. Navigate to Project Dashboard
2. Locate "Change Log" or "Activity Log" or "History" section
3. Verify one of the following:
   - **If NOT implemented**: Change log is not available (this is expected - feature missing)
   - **If implemented**: Change log appears
4. If implemented:
   - Verify change log shows:
     - List of changes in chronological order (newest first)
     - Change type (status changed, member added, deadline changed, etc.)
     - Who made the change
     - When the change was made
     - Old value and new value (for updates)
   - Verify change types are logged:
     - Status changes (e.g., "Status changed from Pending to In Progress")
     - Member changes (e.g., "John Doe added to project", "Jane Smith removed from project")
     - Deadline changes (e.g., "Deadline changed from Jan 1 to Jan 15")
     - Budget changes (if budget exists)
     - Project title/description changes
   - Verify change log is filterable:
     - Filter by change type
     - Filter by date range
     - Filter by user
   - Verify change log updates:
     - When project is changed, new entry appears
     - Changes are logged immediately

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Change log is NOT available (missing)
- ✅ **When implemented**: Change log is displayed
- ✅ All changes are logged
- ✅ Change log is filterable
- ✅ Change log updates in real-time

---

## Test Case 9: View Project Progress Card - Current Implementation

**Objective**: Verify project progress card displays correctly (currently implemented).

**Preconditions**:
- User is logged in
- Project exists
- Project has tasks
- Project progress card is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Verify project progress card is displayed:
   - Project title
   - Project status
   - Progress bar with percentage
   - Task statistics (Total, Completed, Pending, In Progress)
   - Project deadline (if has deadline)
   - Created date
   - Overdue indicator (if overdue)
4. Verify progress bar:
   - Shows completion percentage
   - Color changes based on status (green for on track, red for overdue)
5. Verify task statistics:
   - Total tasks count is correct
   - Completed tasks count is correct
   - Pending tasks count is correct
   - In Progress tasks count is correct
6. Verify overdue indicator:
   - Shows "Overdue" chip if project is overdue
   - Chip is red/error style

**Expected Results**:
- ✅ Project progress card is displayed
- ✅ Progress bar shows correct percentage
- ✅ Task statistics are accurate
- ✅ Overdue indicator works correctly

---

## Test Case 10: Project Dashboard - Task Completion Trend Chart - Missing Feature

**Objective**: Verify task completion trend chart is displayed (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Project has tasks that were completed over time
- Completion trend chart feature is implemented

**Steps**:
1. Navigate to Project Dashboard
2. Locate "Completion Trend" or "Tasks Completed Over Time" section
3. Verify one of the following:
   - **If NOT implemented**: Trend chart is not available (this is expected - feature missing)
   - **If implemented**: Trend chart is displayed
4. If implemented:
   - Verify chart type:
     - Line chart or area chart
     - Shows tasks completed over time
   - Verify chart shows:
     - X-axis: Time (days/weeks)
     - Y-axis: Number of tasks completed
     - Cumulative completion line
     - Or daily/weekly completion bars
   - Verify chart data:
     - Historical completion data
     - Current completion status
     - Trend (increasing, decreasing, stable)
   - Verify chart updates:
     - When tasks are completed, chart updates
     - Historical data is preserved

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Completion trend chart is NOT available (missing)
- ✅ **When implemented**: Completion trend chart is displayed
- ✅ Chart shows completion over time
- ✅ Chart is accurate
- ✅ Chart updates in real-time

---

## Test Case 11: Project Dashboard - Task Assignee Distribution Chart - Missing Feature

**Objective**: Verify task assignee distribution chart is displayed (currently missing).

**Preconditions**:
- User is logged in
- Project exists
- Project has tasks assigned to different members
- Assignee distribution chart feature is implemented

**Steps**:
1. Navigate to Project Dashboard
2. Locate "Task Assignee Distribution" or "Tasks by Assignee" section
3. Verify one of the following:
   - **If NOT implemented**: Assignee chart is not available (this is expected - feature missing)
   - **If implemented**: Assignee chart is displayed
4. If implemented:
   - Verify chart type:
     - Bar chart or pie chart
     - Shows task distribution by assignee
   - Verify chart data:
     - Each assignee's task count
     - Unassigned tasks count
     - Assignee names displayed
   - Verify chart is interactive:
     - Can tap to see assignee details
     - Can filter by assignee
   - Verify chart updates:
     - When tasks are reassigned, chart updates
     - When new tasks are assigned, chart updates

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Assignee distribution chart is NOT available (missing)
- ✅ **When implemented**: Assignee distribution chart is displayed
- ✅ Chart shows accurate data
- ✅ Chart is interactive
- ✅ Chart updates in real-time

---

## Test Case 12: Change Log - Status Change Entry

**Objective**: Verify status changes are logged in change log (when implemented).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Change log feature is implemented

**Steps**:
1. Navigate to Project Dashboard
2. Locate Change Log section
3. Change project status:
   - Edit project
   - Change status from "Pending" to "In Progress"
   - Save changes
4. Verify one of the following:
   - **If NOT implemented**: Change is not logged (this is expected - feature missing)
   - **If implemented**: Change appears in change log
5. If implemented:
   - Verify change log entry:
     - Type: "Status Changed"
     - Old value: "Pending"
     - New value: "In Progress"
     - Changed by: Current user name
     - Changed at: Current timestamp
   - Verify entry appears at top of list (newest first)
   - Verify entry is formatted clearly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Status changes are NOT logged (missing)
- ✅ **When implemented**: Status changes are logged
- ✅ Change log entry is accurate
- ✅ Entry appears immediately

---

## Test Case 13: Change Log - Member Change Entry

**Objective**: Verify member changes are logged in change log (when implemented).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Workspace members exist
- Change log feature is implemented

**Steps**:
1. Navigate to Project Dashboard
2. Locate Change Log section
3. Add a member to project:
   - Navigate to project members
   - Add a member
   - Save
4. Verify one of the following:
   - **If NOT implemented**: Change is not logged (this is expected - feature missing)
   - **If implemented**: Change appears in change log
5. If implemented:
   - Verify change log entry:
     - Type: "Member Added"
     - Member name: Added member's name
     - Changed by: Current user name
     - Changed at: Current timestamp
6. Remove a member from project:
   - Remove the member
   - Save
7. Verify change log entry:
   - Type: "Member Removed"
   - Member name: Removed member's name
   - Changed by: Current user name

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Member changes are NOT logged (missing)
- ✅ **When implemented**: Member changes are logged
- ✅ Add and remove are both logged
- ✅ Change log entries are accurate

---

## Test Case 14: Change Log - Deadline Change Entry

**Objective**: Verify deadline changes are logged in change log (when implemented).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Project has deadline
- Change log feature is implemented

**Steps**:
1. Navigate to Project Dashboard
2. Locate Change Log section
3. Change project deadline:
   - Edit project
   - Change deadline from current date to new date
   - Save changes
4. Verify one of the following:
   - **If NOT implemented**: Change is not logged (this is expected - feature missing)
   - **If implemented**: Change appears in change log
5. If implemented:
   - Verify change log entry:
     - Type: "Deadline Changed"
     - Old value: Previous deadline date
     - New value: New deadline date
     - Changed by: Current user name
     - Changed at: Current timestamp
   - Verify date formatting is clear

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Deadline changes are NOT logged (missing)
- ✅ **When implemented**: Deadline changes are logged
- ✅ Change log entry is accurate
- ✅ Date formatting is clear

---

## Test Case 15: Change Log - Budget Change Entry (If Budget Exists)

**Objective**: Verify budget changes are logged in change log (when implemented, if budget feature exists).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Project has budget field (if implemented)
- Change log feature is implemented

**Steps**:
1. Navigate to Project Dashboard
2. Locate Change Log section
3. Change project budget:
   - Edit project
   - Change budget from current value to new value
   - Save changes
4. Verify one of the following:
   - **If NOT implemented**: Budget change is not logged (this is expected - feature missing)
   - **If implemented**: Change appears in change log
5. If implemented:
   - Verify change log entry:
     - Type: "Budget Changed"
     - Old value: Previous budget amount
     - New value: New budget amount
     - Changed by: Current user name
     - Changed at: Current timestamp
   - Verify currency formatting is correct

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Budget changes are NOT logged (missing, and budget may not exist)
- ✅ **When implemented**: Budget changes are logged (if budget exists)
- ✅ Change log entry is accurate
- ✅ Currency formatting is correct

---

## Test Case 16: Filter Change Log by Type

**Objective**: Verify change log can be filtered by change type (when implemented).

**Preconditions**:
- User is logged in
- Project exists
- Project has various changes logged
- Change log filtering feature is implemented

**Steps**:
1. Navigate to Project Dashboard
2. Locate Change Log section
3. Verify one of the following:
   - **If NOT implemented**: Filter options are not available (this is expected - feature missing)
   - **If implemented**: Filter options exist
4. If implemented:
   - Verify filter options:
     - All changes
     - Status changes only
     - Member changes only
     - Deadline changes only
     - Budget changes only (if applicable)
   - Select "Status changes only":
     - Verify only status changes are shown
     - Verify other changes are hidden
   - Select "Member changes only":
     - Verify only member changes are shown
   - Select "All changes":
     - Verify all changes are shown

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Change log filtering is NOT available (missing)
- ✅ **When implemented**: Change log can be filtered by type
- ✅ Filtering works correctly
- ✅ All filter options are available

---

## Test Case 17: Export Project Dashboard Data - Missing Feature

**Objective**: Verify project dashboard data can be exported (currently missing).

**Preconditions**:
- User is logged in
- User has `generateReports` permission
- Project exists
- Project dashboard exists
- Export feature is implemented

**Steps**:
1. Navigate to Project Dashboard
2. Locate "Export" or "Download" button
3. Verify one of the following:
   - **If NOT implemented**: Export option is not available (this is expected - feature missing)
   - **If implemented**: Export option exists
4. If implemented:
   - Tap "Export" button
   - Verify export options:
     - Export as PDF
     - Export as Excel
     - Export as CSV
   - Select export format (e.g., PDF)
   - Verify export includes:
     - Project overview
     - Charts (as images)
     - Task statistics
     - Overdue/near-due lists
     - Change log (if selected)
   - Confirm export
   - Verify file is generated:
     - File is downloaded
     - File can be opened
     - File contains expected data

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Export is NOT available (missing)
- ✅ **When implemented**: Dashboard data can be exported
- ✅ Multiple export formats are available
- ✅ Export includes all relevant data

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Project dashboard exists (if implemented)
- [ ] Task status distribution chart is displayed (if implemented)
- [ ] Task priority distribution chart is displayed (if implemented)
- [ ] Burndown chart is displayed (if implemented)
- [ ] Burnup chart is displayed (if implemented)
- [ ] Overdue tasks list is displayed (if implemented)
- [ ] Near-due tasks list is displayed (if implemented)
- [ ] Project change log is displayed (if implemented)
- [ ] Project progress card displays correctly
- [ ] Task completion trend chart is displayed (if implemented)
- [ ] Task assignee distribution chart is displayed (if implemented)
- [ ] Status changes are logged (if implemented)
- [ ] Member changes are logged (if implemented)
- [ ] Deadline changes are logged (if implemented)
- [ ] Budget changes are logged (if implemented)
- [ ] Change log can be filtered by type (if implemented)
- [ ] Dashboard data can be exported (if implemented)

---

## Known Issues (Based on Audit Report)

1. **Burndown/Burnup Charts Missing**:
   - No burndown/burnup charts
   - No calculation for remaining work over time
   - **Status**: ⛔ Missing

2. **Change Log Missing**:
   - No change log for project changes
   - Status/member/deadline/budget changes are not logged
   - **Status**: ⛔ Missing

3. **Overdue/Near-Due Not Surfaced**:
   - Overdue detection exists but only shown on individual cards
   - No dedicated overdue/near-due list
   - **Status**: ⛔ Missing

4. **Project Dashboard Missing**:
   - No dedicated project dashboard page
   - Only `project_progress_card.dart` exists
   - **Status**: ⛔ Missing

5. **Task Charts Missing**:
   - No task distribution charts
   - No visual representation of task statistics
   - **Status**: ⛔ Missing

6. **Progress Card Exists**:
   - `project_progress_card.dart` provides basic progress display
   - Shows progress bar, task statistics, overdue indicator
   - **Status**: ✅ Implemented

---

## Notes for Testers

1. **Current Status**: Only basic progress display exists via `project_progress_card.dart`. Burndown/burnup, change log, and overdue/near-due lists are missing.

2. **Chart Libraries**: `fl_chart` and `syncfusion_flutter_charts` are available in `pubspec.yaml`, so chart implementation is possible.

3. **Activity Log**: `ActivityLog` entity exists and supports 'project' entityType, but may not be used for project changes yet.

4. **Overdue Detection**: Overdue detection exists in `calculate_project_progress.dart` and is shown on progress cards, but not as a dedicated list.

5. **Dashboard**: Need to create dedicated project dashboard page with all charts and lists.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- Project context
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase data (if accessible) showing project data
- Whether charts are working
- Whether change log is working
- Whether overdue/near-due lists are working
