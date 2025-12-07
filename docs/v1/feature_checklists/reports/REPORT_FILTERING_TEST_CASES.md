# Report Filtering (By Workspace/Project/Team/Group/Assignee & Date Range) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Report Filtering** feature (filtering by workspace/project/team/group/assignee and date range). This feature is currently **PARTIAL** - `ReportEntity` carries `workspaceId` and `completedTaskIds`; no filtering/query layer shown for project/team/assignee or date range. No UI for scoped filtering.

## Prerequisites
- User must be logged in
- Multiple workspaces should exist (if testing workspace filtering)
- Projects should exist
- Teams/groups should exist (if applicable)
- Users/assignees should exist
- Tasks should exist with different creation dates
- User should have permission to view reports

---

## Test Case 1: Filter Reports by Workspace - Partial Implementation

**Objective**: Verify reports can be filtered by workspace (workspaceId exists in ReportEntity but filtering may not be fully implemented).

**Preconditions**:
- User is logged in
- User has access to multiple workspaces
- Reports exist in different workspaces
- Workspace filtering is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Verify one of the following:
   - **If NOT implemented**: No workspace filter option (this is expected - filtering missing)
   - **If implemented**: Workspace filter option exists
3. If implemented:
   - View reports in Workspace A:
     - Select Workspace A from filter
     - Verify only reports from Workspace A are shown
     - Verify report count matches Workspace A reports
   - Switch to Workspace B:
     - Select Workspace B from filter
     - Verify only reports from Workspace B are shown
     - Verify report count matches Workspace B reports
   - Verify workspace isolation:
     - Reports from other workspaces are not visible
     - Data is correctly scoped to selected workspace

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Workspace filtering may be partially implemented (workspaceId exists in entity)
- ✅ **When fully implemented**: Workspace filter works correctly
- ✅ Reports are scoped to selected workspace
- ✅ Workspace isolation works

---

## Test Case 2: Filter Reports by Project - Missing Feature

**Objective**: Verify reports can be filtered by project (currently missing).

**Preconditions**:
- User is logged in
- Multiple projects exist
- Reports/tasks exist in different projects
- Project filtering is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Verify one of the following:
   - **If NOT implemented**: No project filter option (this is expected - filtering missing)
   - **If implemented**: Project filter option exists
3. If implemented:
   - View all projects:
     - Select "All Projects" from filter
     - Verify reports from all projects are shown
   - Filter by specific project:
     - Select Project A from filter
     - Verify only reports/tasks from Project A are shown
     - Verify report count matches Project A reports/tasks
   - Switch to different project:
     - Select Project B from filter
     - Verify only reports/tasks from Project B are shown
     - Verify data updates correctly
   - Verify project scoping:
     - Reports/tasks from other projects are not visible
     - Data is correctly scoped to selected project

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Project filtering is NOT implemented (missing)
- ✅ **When implemented**: Project filter works correctly
- ✅ Reports/tasks are scoped to selected project
- ✅ Filter updates correctly

---

## Test Case 3: Filter Reports by Team/Group - Missing Feature

**Objective**: Verify reports can be filtered by team/group (currently missing).

**Preconditions**:
- User is logged in
- Teams/groups exist
- Reports/tasks exist assigned to different teams
- Team/group filtering is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Verify one of the following:
   - **If NOT implemented**: No team/group filter option (this is expected - filtering missing)
   - **If implemented**: Team/group filter option exists
3. If implemented:
   - View all teams:
     - Select "All Teams" from filter
     - Verify reports/tasks from all teams are shown
   - Filter by specific team:
     - Select Team A from filter
     - Verify only reports/tasks assigned to Team A are shown
     - Verify report count matches Team A reports/tasks
   - Switch to different team:
     - Select Team B from filter
     - Verify only reports/tasks assigned to Team B are shown
     - Verify data updates correctly
   - Verify team scoping:
     - Reports/tasks from other teams are not visible
     - Data is correctly scoped to selected team

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Team/group filtering is NOT implemented (missing)
- ✅ **When implemented**: Team/group filter works correctly
- ✅ Reports/tasks are scoped to selected team
- ✅ Filter updates correctly

---

## Test Case 4: Filter Reports by Assignee - Missing Feature

**Objective**: Verify reports can be filtered by assignee (currently missing).

**Preconditions**:
- User is logged in
- Multiple users/assignees exist
- Reports/tasks exist assigned to different users
- Assignee filtering is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Verify one of the following:
   - **If NOT implemented**: No assignee filter option (this is expected - filtering missing)
   - **If implemented**: Assignee filter option exists
3. If implemented:
   - View all assignees:
     - Select "All Assignees" from filter
     - Verify reports/tasks from all assignees are shown
   - Filter by specific assignee:
     - Select User A from filter
     - Verify only reports/tasks assigned to User A are shown
     - Verify report count matches User A reports/tasks
   - Switch to different assignee:
     - Select User B from filter
     - Verify only reports/tasks assigned to User B are shown
     - Verify data updates correctly
   - Verify assignee scoping:
     - Reports/tasks from other assignees are not visible
     - Data is correctly scoped to selected assignee

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Assignee filtering is NOT implemented (missing)
- ✅ **When implemented**: Assignee filter works correctly
- ✅ Reports/tasks are scoped to selected assignee
- ✅ Filter updates correctly

---

## Test Case 5: Filter Reports by Date Range - Partial Implementation

**Objective**: Verify reports can be filtered by date range (basic period selector exists but custom date range may be missing).

**Preconditions**:
- User is logged in
- Reports/tasks exist with different creation dates
- Date range filtering is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Verify one of the following:
   - **If NOT implemented**: No date range filter (this is unexpected - period selector exists)
   - **If implemented**: Date range filter exists
3. If implemented:
   - Test predefined periods:
     - Select "Last 7 days"
     - Verify only reports/tasks from last 7 days are shown
     - Select "Last 30 days"
     - Verify only reports/tasks from last 30 days are shown
     - Select "Last 90 days"
     - Verify only reports/tasks from last 90 days are shown
   - Test custom date range:
     - Select "Custom Range" option
     - Pick start date (e.g., 2 weeks ago)
     - Pick end date (e.g., today)
     - Verify only reports/tasks within date range are shown
     - Verify date range is correctly applied
   - Test date range validation:
     - Try to select end date before start date
     - Verify error message is shown
     - Verify invalid range is not applied

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Basic period selector exists (partial), custom date range may be missing
- ✅ **When fully implemented**: Date range filter works correctly
- ✅ Predefined periods work
- ✅ Custom date range works
- ✅ Validation works

---

## Test Case 6: Combined Filters (Multiple Filters Together) - Missing Feature

**Objective**: Verify multiple filters can be applied together (currently missing).

**Preconditions**:
- User is logged in
- All filter types are implemented
- Combined filtering is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Apply multiple filters:
   - Select Project A
   - Select Team B
   - Select User C
   - Select date range (Last 30 days)
3. Verify one of the following:
   - **If NOT implemented**: Filters don't work together (this is expected - combined filtering missing)
   - **If implemented**: Combined filters work
4. If implemented:
   - Verify combined filtering:
     - Only reports/tasks matching ALL filters are shown
     - Count is accurate for combined filters
   - Remove one filter:
     - Remove Project filter
     - Verify reports/tasks still match remaining filters (Team, User, Date)
   - Clear all filters:
     - Tap "Clear Filters" button
     - Verify all filters are cleared
     - Verify all reports/tasks are shown

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Combined filtering is NOT implemented (missing)
- ✅ **When implemented**: Combined filters work correctly
- ✅ All filters are applied together
- ✅ Clear filters works

---

## Test Case 7: Filter UI Display - Missing Feature

**Objective**: Verify filter UI is displayed correctly (currently missing).

**Preconditions**:
- User is logged in
- Filter UI is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Verify one of the following:
   - **If NOT implemented**: No filter UI (this is expected - UI missing)
   - **If implemented**: Filter UI is displayed
3. If implemented:
   - Verify filter UI components:
     - Workspace selector is visible
     - Project selector is visible
     - Team/group selector is visible (if applicable)
     - Assignee selector is visible
     - Date range selector is visible
   - Verify filter UI design:
     - UI follows project rules (TD widgets, AppStrings)
     - UI is clear and readable
     - UI is responsive
   - Verify filter UI placement:
     - Filters are in appropriate location (top of page, sidebar, etc.)
     - Filters don't overlap other content

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Filter UI is NOT implemented (missing)
- ✅ **When implemented**: Filter UI is displayed correctly
- ✅ UI follows project rules
- ✅ UI is clear and usable

---

## Test Case 8: Filter State Persistence - Missing Feature

**Objective**: Verify filter state persists across page navigation (currently missing).

**Preconditions**:
- User is logged in
- Filters are applied
- State persistence is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Apply filters:
   - Select Project A
   - Select date range (Last 30 days)
3. Navigate away from page (e.g., go to another page)
4. Navigate back to Reports page
5. Verify one of the following:
   - **If NOT implemented**: Filters are reset (this is expected - persistence missing)
   - **If implemented**: Filters are preserved
6. If implemented:
   - Verify filter persistence:
     - Project filter is still selected
     - Date range filter is still selected
     - Reports/tasks match preserved filters
   - Verify persistence across app restart:
     - Close and reopen app
     - Navigate to Reports page
     - Verify filters are preserved (if applicable)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Filter state persistence is NOT implemented (missing)
- ✅ **When implemented**: Filter state persists
- ✅ Filters are preserved across navigation
- ✅ User experience is improved

---

## Test Case 9: Filter Performance with Large Dataset - Missing Feature

**Objective**: Verify filtering performs well with large number of reports/tasks (currently missing).

**Preconditions**:
- User is logged in
- Large number of reports/tasks exist (1000+)
- Filtering is implemented
- Performance optimization is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Measure performance:
   - Time to apply filter
   - Time to load filtered results
   - Memory usage
   - UI responsiveness
3. Verify one of the following:
   - **If NOT implemented**: Filtering may be slow (this is expected - optimization missing)
   - **If implemented**: Filtering performs well
4. If implemented:
   - Apply filter:
     - Select project filter
     - Measure time to filter
     - Verify filtering completes in reasonable time (< 2 seconds)
   - Verify performance:
     - Filtering is fast
     - Memory usage is acceptable
     - UI remains responsive
   - Verify optimization:
     - Server-side filtering is used (if applicable)
     - Only necessary data is fetched
     - Caching is used (if applicable)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Performance optimization may be missing
- ✅ **When implemented**: Filtering performs well
- ✅ Large datasets are handled efficiently
- ✅ UI remains responsive

---

## Test Case 10: Filter Query Layer Implementation - Missing Feature

**Objective**: Verify filtering query layer is implemented correctly (currently missing).

**Preconditions**:
- User is logged in
- Filtering query layer is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Apply filters:
   - Select Project A
   - Select Team B
   - Select date range
3. Verify one of the following:
   - **If NOT implemented**: No query layer (this is expected - query layer missing)
   - **If implemented**: Query layer works
4. If implemented:
   - Verify query construction:
     - Filters are converted to database queries
     - Queries are optimized
     - Queries use proper indexes
   - Verify query execution:
     - Queries execute correctly
     - Results match filters
     - No errors occur
   - Verify workspace scoping:
     - All queries include workspaceId filter
     - Data isolation is maintained

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Filtering query layer is NOT implemented (missing)
- ✅ **When implemented**: Query layer works correctly
- ✅ Queries are optimized
- ✅ Workspace scoping is maintained

---

## Test Case 11: Filter with Empty Results - Missing Feature

**Objective**: Verify filtering handles empty results gracefully (currently missing).

**Preconditions**:
- User is logged in
- Filters are applied that result in no matches
- Empty state handling is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Apply filters that result in no matches:
   - Select Project that has no reports/tasks
   - Select date range with no reports/tasks
   - Apply combined filters with no matches
3. Verify one of the following:
   - **If NOT implemented**: Empty state shows errors or incorrect data (this is expected - handling missing)
   - **If implemented**: Empty state is handled gracefully
4. If implemented:
   - Verify empty state:
     - "No results" message is shown
     - Empty state icon is displayed
     - No errors are shown
   - Verify UI:
     - Empty state message is clear
     - UI is still usable
     - Clear filters option is available

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Empty state handling may be missing
- ✅ **When implemented**: Empty state is handled gracefully
- ✅ User sees clear message
- ✅ No errors are shown

---

## Test Case 12: Filter Integration with Charts - Missing Feature

**Objective**: Verify charts update when filters are applied (currently missing).

**Preconditions**:
- User is logged in
- Charts are displayed
- Filters are applied
- Chart-filter integration is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Note current chart data
3. Apply filter (e.g., select Project A)
4. Verify one of the following:
   - **If NOT implemented**: Charts don't update (this is expected - integration missing)
   - **If implemented**: Charts update
5. If implemented:
   - Verify chart update:
     - Charts reload with filtered data
     - Chart data reflects filter
     - Counts are updated
   - Verify filter persistence:
     - Charts maintain filter state
     - Charts update when filter changes

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Chart-filter integration is NOT implemented (missing)
- ✅ **When implemented**: Charts update with filters
- ✅ Filter state is maintained
- ✅ Data is accurate

---

## Test Case 13: Filter Saved Configurations - Missing Feature

**Objective**: Verify filter configurations can be saved and reused (currently missing).

**Preconditions**:
- User is logged in
- Filters are applied
- Saved filter configurations are implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Apply filters:
   - Select Project A
   - Select Team B
   - Select date range (Last 30 days)
3. Save filter configuration:
   - Tap "Save Filter" button
   - Enter filter name (e.g., "Monthly Project A Report")
   - Verify one of the following:
     - **If NOT implemented**: No save option (this is expected - feature missing)
     - **If implemented**: Filter is saved
4. If implemented:
   - Verify saved filter:
     - Filter appears in saved filters list
     - Filter name is displayed
   - Load saved filter:
     - Select saved filter from list
     - Verify filters are applied correctly
     - Verify reports/tasks match saved filter
   - Delete saved filter:
     - Delete saved filter
     - Verify filter is removed from list

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Saved filter configurations are NOT implemented (missing)
- ✅ **When implemented**: Saved filters work correctly
- ✅ Filters can be saved and loaded
- ✅ User experience is improved

---

## Test Case 14: Filter Validation - Missing Feature

**Objective**: Verify filter inputs are validated correctly (currently missing).

**Preconditions**:
- User is logged in
- Filter validation is implemented

**Steps**:
1. Navigate to Reports page or Analytics page
2. Test invalid filter inputs:
   - Select end date before start date
   - Select invalid project (if applicable)
   - Select invalid assignee (if applicable)
3. Verify one of the following:
   - **If NOT implemented**: Invalid inputs are accepted (this is expected - validation missing)
   - **If implemented**: Validation works
4. If implemented:
   - Verify validation:
     - Error messages are shown for invalid inputs
     - Invalid filters are not applied
     - User is guided to fix errors
   - Verify validation messages:
     - Messages are clear
     - Messages use AppStrings
     - Messages are user-friendly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Filter validation is NOT implemented (missing)
- ✅ **When implemented**: Validation works correctly
- ✅ Invalid inputs are rejected
- ✅ Error messages are clear

---

## Test Case 15: Filter Workspace Scoping Enforcement - Partial Implementation

**Objective**: Verify all filters enforce workspace scoping (workspaceId exists but enforcement may be incomplete).

**Preconditions**:
- User is logged in
- User has access to multiple workspaces
- Workspace scoping is enforced

**Steps**:
1. Switch to Workspace A
2. Apply filters:
   - Select Project from Workspace A
   - Select Team from Workspace A
   - Select Assignee from Workspace A
3. Verify one of the following:
   - **If NOT implemented**: Filters may show data from other workspaces (this is expected - enforcement missing)
   - **If implemented**: Workspace scoping is enforced
4. If implemented:
   - Verify workspace scoping:
     - Only projects from current workspace are shown in filter
     - Only teams from current workspace are shown in filter
     - Only assignees from current workspace are shown in filter
     - Results are scoped to current workspace
   - Switch workspace:
     - Switch to Workspace B
     - Verify filters are reset or updated
     - Verify only Workspace B data is shown

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Workspace scoping may be partially implemented
- ✅ **When fully implemented**: Workspace scoping is enforced
- ✅ All filters respect workspace boundaries
- ✅ Data isolation is maintained

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Workspace filtering works (partial)
- [ ] Project filtering works (missing)
- [ ] Team/group filtering works (missing)
- [ ] Assignee filtering works (missing)
- [ ] Date range filtering works (partial)
- [ ] Combined filters work (missing)
- [ ] Filter UI is displayed (missing)
- [ ] Filter state persists (missing)
- [ ] Performance is acceptable (missing)
- [ ] Query layer works (missing)
- [ ] Empty state is handled (missing)
- [ ] Chart integration works (missing)
- [ ] Saved filters work (missing)
- [ ] Filter validation works (missing)
- [ ] Workspace scoping is enforced (partial)

---

## Known Issues (Based on Audit Report)

1. **Filtering Not Implemented**:
   - `ReportEntity` carries `workspaceId` and `completedTaskIds`
   - No filtering/query layer shown for project/team/assignee or date range
   - No UI for scoped filtering
   - **Status**: ⚠️ Partial

2. **Existing Components**:
   - `ReportEntity` has `workspaceId` field
   - Basic period selector exists in `report_analytics_page.dart` (week/month/quarter)
   - `firebase_database_service.dart` has some date filtering for reports (startDate, endDate, userId)
   - `getTasksOptimized` has projectId and assigneeId filters (for tasks, not reports)

---

## Notes for Testers

1. **Current Status**: Filtering is partially implemented:
   - `ReportEntity` has `workspaceId` field
   - Basic period selector exists
   - But no comprehensive filtering UI or query layer
   - No project/team/assignee filtering

2. **Filtering Requirements**: Need to implement:
   - Filter by workspace (may be partially working)
   - Filter by project
   - Filter by team/group
   - Filter by assignee
   - Filter by date range (custom range, not just predefined periods)
   - Combined filters
   - Filter UI
   - Saved filter configurations

3. **Integration**: Filters need to be integrated with:
   - Report aggregation
   - Charts
   - Task statistics
   - Query layer

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
- Whether filters are displayed
- Whether filters work correctly
- Whether workspace scoping works
- Number of reports/tasks in workspace
- Filter values used
