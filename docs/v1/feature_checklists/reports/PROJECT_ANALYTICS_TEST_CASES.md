# Project Analytics (Project Status, Completion Rate, Burnup/Burndown, Overdue/Near-Due Task List) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Project Analytics** feature in the Reports module (project status, completion rate, burnup/burndown, overdue/near-due task list). This feature is currently **PARTIAL** - `project_progress_card.dart` exists; no dedicated project analytics in reports module; overdue/near-due listing not implemented.

## Prerequisites
- User must be logged in
- Workspace should exist
- Projects should exist
- Tasks should exist within projects
- Tasks should have different due dates (some overdue, some near-due)
- User should have permission to view reports

---

## Test Case 1: View Project Analytics in Reports Module - Missing Feature

**Objective**: Verify project analytics section exists in reports module (currently missing).

**Preconditions**:
- User is logged in
- Projects exist
- Project analytics in reports module is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Verify one of the following:
   - **If NOT implemented**: No project analytics section (this is expected - feature missing)
   - **If implemented**: Project analytics section exists
3. If implemented:
   - Verify section display:
     - "Project Analytics" or similar section title is shown
     - Section is visible and accessible
     - Section is in appropriate location
   - Verify section content:
     - Project status overview is displayed
     - Completion rate is displayed
     - Burnup/burndown charts are displayed (if applicable)
     - Overdue/near-due task lists are displayed

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Project analytics section is NOT in reports module (missing)
- ✅ **When implemented**: Project analytics section exists
- ✅ Section is clearly visible
- ✅ Section contains all required components

---

## Test Case 2: View Project Status Overview - Missing Feature

**Objective**: Verify project status overview is displayed in reports (currently missing).

**Preconditions**:
- User is logged in
- Projects exist with different statuses (Pending, In Progress, Completed, Cancelled)
- Project status overview is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Navigate to Project Analytics section
3. Verify one of the following:
   - **If NOT implemented**: No project status overview (this is expected - feature missing)
   - **If implemented**: Project status overview is displayed
4. If implemented:
   - Verify status display:
     - All project statuses are shown
     - Status counts are displayed
     - Status distribution is shown (chart or list)
   - Verify status accuracy:
     - Pending: X projects
     - In Progress: Y projects
     - Completed: Z projects
     - Cancelled: W projects
     - Counts are accurate
   - Verify workspace scoping:
     - Only projects from current workspace are shown
     - Projects from other workspaces are excluded

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Project status overview is NOT in reports module (missing)
- ✅ **When implemented**: Project status overview is displayed
- ✅ Status counts are accurate
- ✅ Workspace scoping works

---

## Test Case 3: View Project Completion Rate - Missing Feature

**Objective**: Verify project completion rate is displayed in reports (currently missing).

**Preconditions**:
- User is logged in
- Projects exist with different completion percentages
- Project completion rate is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Navigate to Project Analytics section
3. Verify one of the following:
   - **If NOT implemented**: No completion rate display (this is expected - feature missing)
   - **If implemented**: Completion rate is displayed
4. If implemented:
   - Verify completion rate display:
     - Overall completion rate is shown (percentage)
     - Completion rate per project is shown (if applicable)
     - Completion rate chart/visualization is shown (if applicable)
   - Verify completion rate accuracy:
     - Overall rate = (completed projects / total projects) * 100
     - Per-project rates match actual progress
     - Rates are calculated correctly
   - Verify workspace scoping:
     - Only projects from current workspace are included
     - Completion rate is scoped to workspace

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Project completion rate is NOT in reports module (missing)
- ✅ **When implemented**: Completion rate is displayed
- ✅ Completion rates are accurate
- ✅ Workspace scoping works

---

## Test Case 4: View Burnup Chart - Missing Feature

**Objective**: Verify burnup chart is displayed in project analytics (currently missing).

**Preconditions**:
- User is logged in
- Project exists with tasks
- Task completion history exists
- Burnup chart is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Navigate to Project Analytics section
3. Select a project (if applicable)
4. Verify one of the following:
   - **If NOT implemented**: No burnup chart (this is expected - feature missing)
   - **If implemented**: Burnup chart is displayed
5. If implemented:
   - Verify chart display:
     - Burnup chart is visible
     - Chart has title "Burnup Chart" or similar
     - Chart shows work completed over time
     - Chart shows total work scope
   - Verify chart data:
     - X-axis shows time (dates)
     - Y-axis shows work (task count or story points)
     - Completed work line is shown
     - Total scope line is shown
     - Chart data is accurate
   - Verify chart interaction:
     - Chart is readable
     - Tooltips show data points (if applicable)
     - Chart can be zoomed/panned (if applicable)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Burnup chart is NOT implemented (missing)
- ✅ **When implemented**: Burnup chart is displayed
- ✅ Chart data is accurate
- ✅ Chart is clear and readable

---

## Test Case 5: View Burndown Chart - Missing Feature

**Objective**: Verify burndown chart is displayed in project analytics (currently missing).

**Preconditions**:
- User is logged in
- Project exists with tasks
- Task completion history exists
- Burndown chart is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Navigate to Project Analytics section
3. Select a project (if applicable)
4. Verify one of the following:
   - **If NOT implemented**: No burndown chart (this is expected - feature missing)
   - **If implemented**: Burndown chart is displayed
5. If implemented:
   - Verify chart display:
     - Burndown chart is visible
     - Chart has title "Burndown Chart" or similar
     - Chart shows remaining work over time
     - Chart shows ideal burndown line
   - Verify chart data:
     - X-axis shows time (dates)
     - Y-axis shows remaining work (task count or story points)
     - Actual burndown line is shown
     - Ideal burndown line is shown
     - Chart data is accurate
   - Verify chart interaction:
     - Chart is readable
     - Tooltips show data points (if applicable)
     - Chart can be zoomed/panned (if applicable)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Burndown chart is NOT implemented (missing)
- ✅ **When implemented**: Burndown chart is displayed
- ✅ Chart data is accurate
- ✅ Chart is clear and readable

---

## Test Case 6: View Overdue Tasks List - Missing Feature

**Objective**: Verify overdue tasks list is displayed in project analytics (currently missing).

**Preconditions**:
- User is logged in
- Projects exist
- Tasks exist with overdue due dates
- Overdue tasks list is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Navigate to Project Analytics section
3. Verify one of the following:
   - **If NOT implemented**: No overdue tasks list (this is expected - feature missing)
   - **If implemented**: Overdue tasks list is displayed
4. If implemented:
   - Verify list display:
     - "Overdue Tasks" or similar section title is shown
     - List of overdue tasks is displayed
     - Tasks are sorted (by due date, project, etc.)
   - Verify task information:
     - Task title is shown
     - Task due date is shown
     - Days overdue is shown
     - Project name is shown (if applicable)
     - Assignee is shown (if applicable)
   - Verify list accuracy:
     - Only overdue tasks are shown
     - All overdue tasks are included
     - Tasks are correctly identified as overdue
   - Verify workspace scoping:
     - Only tasks from current workspace are shown
     - Tasks from other workspaces are excluded

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Overdue tasks list is NOT implemented (missing)
- ✅ **When implemented**: Overdue tasks list is displayed
- ✅ List is accurate
- ✅ Workspace scoping works

---

## Test Case 7: View Near-Due Tasks List - Missing Feature

**Objective**: Verify near-due tasks list is displayed in project analytics (currently missing).

**Preconditions**:
- User is logged in
- Projects exist
- Tasks exist with near-due dates (e.g., due within 3 days)
- Near-due tasks list is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Navigate to Project Analytics section
3. Verify one of the following:
   - **If NOT implemented**: No near-due tasks list (this is expected - feature missing)
   - **If implemented**: Near-due tasks list is displayed
4. If implemented:
   - Verify list display:
     - "Near-Due Tasks" or similar section title is shown
     - List of near-due tasks is displayed
     - Tasks are sorted (by due date, project, etc.)
   - Verify task information:
     - Task title is shown
     - Task due date is shown
     - Days until due is shown
     - Project name is shown (if applicable)
     - Assignee is shown (if applicable)
   - Verify list accuracy:
     - Only near-due tasks are shown (e.g., due within 3 days)
     - All near-due tasks are included
     - Tasks are correctly identified as near-due
   - Verify workspace scoping:
     - Only tasks from current workspace are shown
     - Tasks from other workspaces are excluded

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Near-due tasks list is NOT implemented (missing)
- ✅ **When implemented**: Near-due tasks list is displayed
- ✅ List is accurate
- ✅ Workspace scoping works

---

## Test Case 8: Filter Project Analytics by Project - Missing Feature

**Objective**: Verify project analytics can be filtered by specific project (currently missing).

**Preconditions**:
- User is logged in
- Multiple projects exist
- Project filtering is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Navigate to Project Analytics section
3. Verify one of the following:
   - **If NOT implemented**: No project filter (this is expected - feature missing)
   - **If implemented**: Project filter exists
4. If implemented:
   - View all projects:
     - Select "All Projects" from filter
     - Verify analytics for all projects are shown
   - Filter by specific project:
     - Select Project A from filter
     - Verify only Project A analytics are shown
     - Verify burnup/burndown charts show Project A data
     - Verify overdue/near-due lists show only Project A tasks
   - Switch to different project:
     - Select Project B from filter
     - Verify analytics update to Project B
     - Verify data is correct for Project B

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Project filtering is NOT implemented (missing)
- ✅ **When implemented**: Project filter works correctly
- ✅ Analytics are filtered correctly
- ✅ Charts and lists update correctly

---

## Test Case 9: Project Analytics with No Projects - Missing Feature

**Objective**: Verify project analytics handles empty workspace gracefully (currently missing).

**Preconditions**:
- User is logged in
- Workspace has no projects
- Empty state handling is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Navigate to Project Analytics section in empty workspace
3. Verify one of the following:
   - **If NOT implemented**: Analytics show errors or incorrect data (this is expected - handling missing)
   - **If implemented**: Empty state is handled gracefully
4. If implemented:
   - Verify empty state:
     - "No projects" or similar message is shown
     - Empty state icon is displayed
     - No errors are shown
   - Verify UI:
     - Empty state message is clear
     - UI is still usable
     - Sections are still visible (but empty)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Empty state handling may be missing
- ✅ **When implemented**: Empty state is handled gracefully
- ✅ User sees clear message
- ✅ No errors are shown

---

## Test Case 10: Project Analytics with No Overdue/Near-Due Tasks - Missing Feature

**Objective**: Verify overdue/near-due lists handle empty state gracefully (currently missing).

**Preconditions**:
- User is logged in
- Projects exist
- No overdue or near-due tasks exist
- Empty state handling is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Navigate to Project Analytics section
3. View overdue tasks list
4. Verify one of the following:
   - **If NOT implemented**: List shows errors or incorrect data (this is expected - handling missing)
   - **If implemented**: Empty state is handled gracefully
5. If implemented:
   - Verify empty state:
     - "No overdue tasks" or similar message is shown
     - Empty state icon is displayed
     - No errors are shown
6. Repeat for near-due tasks list

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Empty state handling may be missing
- ✅ **When implemented**: Empty state is handled gracefully
- ✅ User sees clear message
- ✅ No errors are shown

---

## Test Case 11: Project Analytics Real-Time Updates - Missing Feature

**Objective**: Verify project analytics update when projects/tasks change (currently missing).

**Preconditions**:
- User is logged in
- Project analytics is displayed
- Real-time updates are implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Navigate to Project Analytics section
3. Note current analytics data
4. Make changes:
   - Complete a task in another tab or device
   - Change project status
   - Add a new task
5. Verify one of the following:
   - **If NOT implemented**: Analytics don't update (this is expected - real-time missing)
   - **If implemented**: Analytics update automatically
6. If implemented:
   - Verify update:
     - Completion rate updates
     - Burnup/burndown charts update
     - Overdue/near-due lists update
     - Status overview updates
   - Verify update timing:
     - Updates happen automatically (no refresh needed)
     - Updates are immediate or near-immediate

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Real-time updates are NOT implemented (missing)
- ✅ **When implemented**: Analytics update automatically
- ✅ Updates are accurate and timely

---

## Test Case 12: Project Analytics Performance with Large Dataset - Missing Feature

**Objective**: Verify project analytics performs well with large number of projects/tasks (currently missing).

**Preconditions**:
- User is logged in
- Large number of projects exist (100+ projects)
- Large number of tasks exist (1000+ tasks)
- Performance optimization is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Navigate to Project Analytics section
3. Measure performance:
   - Time to load analytics
   - Time to render charts
   - Memory usage
   - UI responsiveness
4. Verify one of the following:
   - **If NOT implemented**: Analytics may be slow (this is expected - optimization missing)
   - **If implemented**: Analytics perform well
5. If implemented:
   - Verify performance:
     - Analytics load in reasonable time (< 3 seconds)
     - Charts render quickly
     - Memory usage is acceptable
     - UI remains responsive
   - Verify optimization:
     - Server-side aggregation is used (if applicable)
     - Only necessary data is fetched
     - Caching is used (if applicable)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Performance optimization may be missing
- ✅ **When implemented**: Analytics perform well
- ✅ Large datasets are handled efficiently
- ✅ UI remains responsive

---

## Test Case 13: Project Analytics Integration with Existing Progress Card - Partial Implementation

**Objective**: Verify project analytics integrates with existing `project_progress_card.dart` (progress card exists but analytics in reports module is missing).

**Preconditions**:
- User is logged in
- `project_progress_card.dart` exists
- Project analytics in reports module is implemented

**Steps**:
1. Navigate to Project List page
2. Verify `project_progress_card.dart` is displayed:
   - Progress card shows project progress
   - Progress card shows task statistics
   - Progress card shows overdue indicator
3. Navigate to Reports page or Analytics page
4. Navigate to Project Analytics section
5. Verify one of the following:
   - **If NOT implemented**: No project analytics section (this is expected - feature missing)
   - **If implemented**: Project analytics section exists
6. If implemented:
   - Verify integration:
     - Analytics use same data source as progress card
     - Analytics are consistent with progress card
     - Analytics provide more detailed view than progress card

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Project analytics is NOT in reports module (missing), but progress card exists
- ✅ **When implemented**: Project analytics exists in reports module
- ✅ Analytics integrate with existing progress card
- ✅ Analytics provide comprehensive view

---

## Test Case 14: Project Analytics Export - Missing Feature

**Objective**: Verify project analytics can be exported (currently missing).

**Preconditions**:
- User is logged in
- Project analytics is displayed
- Export functionality is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Navigate to Project Analytics section
3. Verify one of the following:
   - **If NOT implemented**: No export option (this is expected - feature missing)
   - **If implemented**: Export option exists
4. If implemented:
   - Tap "Export" button
   - Select export format (Excel, PDF, etc.)
   - Verify export:
     - Export completes successfully
     - File is generated
     - File contains project analytics data
   - Verify exported data:
     - Project status overview is included
     - Completion rates are included
     - Overdue/near-due lists are included
     - Data is accurate

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Export functionality is NOT implemented (missing)
- ✅ **When implemented**: Export works correctly
- ✅ Exported data is accurate

---

## Test Case 15: Project Analytics Workspace Scoping - Missing Feature

**Objective**: Verify project analytics are scoped to current workspace (currently missing).

**Preconditions**:
- User is logged in
- User has access to multiple workspaces
- Projects exist in different workspaces
- Workspace scoping is implemented

**Steps**:
1. Switch to Workspace A
2. Navigate to Project Analytics section
3. Note analytics data
4. Switch to Workspace B
5. Verify one of the following:
   - **If NOT implemented**: Analytics show same data (this is expected - scoping missing)
   - **If implemented**: Analytics show different data
6. If implemented:
   - Verify workspace scoping:
     - Only projects from Workspace B are shown
     - Analytics reflect Workspace B data
     - Data is isolated correctly
   - Verify workspace switching:
     - Analytics update when workspace changes
     - Data reflects current workspace

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Workspace scoping may be missing
- ✅ **When implemented**: Analytics are scoped to workspace
- ✅ Workspace isolation works correctly

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Project analytics section exists in reports module (missing)
- [ ] Project status overview works (missing)
- [ ] Project completion rate works (missing)
- [ ] Burnup chart works (missing)
- [ ] Burndown chart works (missing)
- [ ] Overdue tasks list works (missing)
- [ ] Near-due tasks list works (missing)
- [ ] Project filtering works (missing)
- [ ] Empty state is handled (missing)
- [ ] Real-time updates work (missing)
- [ ] Performance is acceptable (missing)
- [ ] Integration with progress card works (partial)
- [ ] Export works (missing)
- [ ] Workspace scoping works (missing)

---

## Known Issues (Based on Audit Report)

1. **Project Analytics Missing in Reports Module**:
   - `project_progress_card.dart` exists but is for project list display
   - No dedicated project analytics in reports module
   - Overdue/near-due listing not implemented
   - **Status**: ⚠️ Partial

2. **Existing Components**:
   - `project_progress_card.dart` - basic progress display widget
   - `CalculateProjectProgress` use case - calculates project progress
   - `ProjectProgressResult` - progress calculation result
   - Overdue detection - `isOverdue` field in progress result
   - Task statistics - total, completed, pending, in progress, cancelled

3. **Missing Components**:
   - Project analytics section in reports module
   - Burnup/burndown charts
   - Overdue/near-due task lists in reports
   - Project status overview in reports
   - Completion rate display in reports

---

## Notes for Testers

1. **Current Status**: Project analytics is partially implemented:
   - `project_progress_card.dart` exists but is for project list, not reports
   - `CalculateProjectProgress` use case exists
   - But no dedicated project analytics in reports module
   - No burnup/burndown charts
   - No overdue/near-due listing in reports

2. **Integration**: Project analytics in reports module should:
   - Use existing `CalculateProjectProgress` use case
   - Integrate with existing progress calculation
   - Provide comprehensive analytics view
   - Include burnup/burndown charts
   - Include overdue/near-due task lists

3. **Charts**: Chart libraries (`fl_chart` and `syncfusion_flutter_charts`) are available, so burnup/burndown implementation is possible.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether project analytics section exists
- Whether charts are displayed
- Whether overdue/near-due lists are displayed
- Number of projects in workspace
- Number of tasks in projects
