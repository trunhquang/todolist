# Workspace Data Filtering Test Cases

## Overview
This document contains step-by-step test cases for testing the **Workspace Data Filtering** feature (ensuring all data queries filter by active workspace). This feature is currently **PARTIAL** - data services expect workspaceId, but there's no global guard ensuring all queries are scoped.

## Prerequisites
- User must be logged into the application
- User must have access to multiple workspaces (at least 2)
- Each workspace should have different data (tasks, projects, reports)
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: Tasks Filter by Current Workspace

**Objective**: Verify that tasks are filtered by current workspace.

**Preconditions**:
- User is logged in
- User has access to Workspace A and Workspace B
- Workspace A has tasks: Task A1, Task A2
- Workspace B has tasks: Task B1, Task B2
- Current workspace is Workspace A

**Steps**:
1. Navigate to Tasks list screen
2. Verify only Workspace A tasks are displayed:
   - Task A1 is visible
   - Task A2 is visible
   - Task B1 is NOT visible
   - Task B2 is NOT visible
3. Switch to Workspace B
4. Wait for workspace switching to complete
5. Navigate to Tasks list screen (or refresh if already on it)
6. Verify only Workspace B tasks are displayed:
   - Task B1 is visible
   - Task B2 is visible
   - Task A1 is NOT visible
   - Task A2 is NOT visible
7. Switch back to Workspace A
8. Verify Tasks list shows only Workspace A tasks again

**Expected Results**:
- ✅ Tasks are filtered by current workspace
- ✅ Only tasks from current workspace are visible
- ✅ Tasks from other workspaces are not visible
- ✅ Task list updates when workspace is switched

---

## Test Case 2: Projects Filter by Current Workspace

**Objective**: Verify that projects are filtered by current workspace.

**Preconditions**:
- User is logged in
- User has access to Workspace A and Workspace B
- Workspace A has projects: Project A1, Project A2
- Workspace B has projects: Project B1, Project B2
- Current workspace is Workspace A

**Steps**:
1. Navigate to Projects list screen
2. Verify only Workspace A projects are displayed:
   - Project A1 is visible
   - Project A2 is visible
   - Project B1 is NOT visible
   - Project B2 is NOT visible
3. Switch to Workspace B
4. Wait for workspace switching to complete
5. Navigate to Projects list screen
6. Verify only Workspace B projects are displayed:
   - Project B1 is visible
   - Project B2 is visible
   - Project A1 is NOT visible
   - Project A2 is NOT visible
7. Switch back to Workspace A
8. Verify Projects list shows only Workspace A projects again

**Expected Results**:
- ✅ Projects are filtered by current workspace
- ✅ Only projects from current workspace are visible
- ✅ Projects from other workspaces are not visible
- ✅ Project list updates when workspace is switched

---

## Test Case 3: Reports Filter by Current Workspace

**Objective**: Verify that reports are filtered by current workspace.

**Preconditions**:
- User is logged in
- User has access to Workspace A and Workspace B
- Workspace A has reports: Report A1, Report A2
- Workspace B has reports: Report B1, Report B2
- Current workspace is Workspace A

**Steps**:
1. Navigate to Reports list/history screen
2. Verify only Workspace A reports are displayed:
   - Report A1 is visible
   - Report A2 is visible
   - Report B1 is NOT visible
   - Report B2 is NOT visible
3. Switch to Workspace B
4. Wait for workspace switching to complete
5. Navigate to Reports list/history screen
6. Verify only Workspace B reports are displayed:
   - Report B1 is visible
   - Report B2 is visible
   - Report A1 is NOT visible
   - Report A2 is NOT visible

**Expected Results**:
- ✅ Reports are filtered by current workspace
- ✅ Only reports from current workspace are visible
- ✅ Reports from other workspaces are not visible

---

## Test Case 4: Create Task in Current Workspace

**Objective**: Verify that new tasks are created in current workspace.

**Preconditions**:
- User is logged in
- User has access to Workspace A and Workspace B
- Current workspace is Workspace A

**Steps**:
1. Navigate to Create Task screen
2. Fill in task details:
   - Title: "Test Task Workspace A"
   - Description: "Testing workspace filtering"
   - Other required fields
3. Create the task
4. Verify task is created successfully
5. Navigate to Tasks list
6. Verify "Test Task Workspace A" appears in the list
7. Switch to Workspace B
8. Navigate to Tasks list
9. Verify "Test Task Workspace A" does NOT appear (it's in Workspace A)
10. Switch back to Workspace A
11. Verify "Test Task Workspace A" appears again

**Expected Results**:
- ✅ New tasks are created in current workspace
- ✅ Task workspaceId matches current workspace
- ✅ Task appears only in its workspace's task list

---

## Test Case 5: Create Project in Current Workspace

**Objective**: Verify that new projects are created in current workspace.

**Preconditions**:
- User is logged in
- User has access to Workspace A and Workspace B
- Current workspace is Workspace A

**Steps**:
1. Navigate to Create Project screen
2. Fill in project details:
   - Name: "Test Project Workspace A"
   - Description: "Testing workspace filtering"
3. Create the project
4. Verify project is created successfully
5. Navigate to Projects list
6. Verify "Test Project Workspace A" appears in the list
7. Switch to Workspace B
8. Navigate to Projects list
9. Verify "Test Project Workspace A" does NOT appear
10. Switch back to Workspace A
11. Verify "Test Project Workspace A" appears again

**Expected Results**:
- ✅ New projects are created in current workspace
- ✅ Project workspaceId matches current workspace
- ✅ Project appears only in its workspace's project list

---

## Test Case 6: Create Report in Current Workspace

**Objective**: Verify that new reports are created in current workspace.

**Preconditions**:
- User is logged in
- User has access to Workspace A and Workspace B
- Current workspace is Workspace A

**Steps**:
1. Navigate to Create Report screen
2. Fill in report details
3. Create the report
4. Verify report is created successfully
5. Navigate to Reports list/history
6. Verify the new report appears in the list
7. Switch to Workspace B
8. Navigate to Reports list/history
9. Verify the new report does NOT appear
10. Switch back to Workspace A
11. Verify the new report appears again

**Expected Results**:
- ✅ New reports are created in current workspace
- ✅ Report workspaceId matches current workspace
- ✅ Report appears only in its workspace's report list

---

## Test Case 7: Edit Task - Verify Workspace Isolation

**Objective**: Verify that tasks can only be edited within their workspace context.

**Preconditions**:
- User is logged in
- User has access to Workspace A and Workspace B
- Workspace A has Task A1
- Workspace B has Task B1
- Current workspace is Workspace A

**Steps**:
1. Navigate to Tasks list (Workspace A)
2. Open Task A1 for editing
3. Verify task details are loaded correctly
4. Edit task title to "Updated Task A1"
5. Save the changes
6. Verify task is updated successfully
7. Switch to Workspace B
8. Navigate to Tasks list (Workspace B)
9. Verify Task A1 is NOT visible (it's in Workspace A)
10. Verify Task B1 is visible
11. Try to access Task A1 directly (if possible via ID):
    - Verify access is denied or task is not found
    - OR verify task cannot be edited from wrong workspace

**Expected Results**:
- ✅ Tasks can only be edited in their workspace
- ✅ Tasks from other workspaces are not accessible
- ✅ Workspace isolation is maintained

---

## Test Case 8: Paginated Tasks Filter by Workspace

**Objective**: Verify that paginated task queries filter by current workspace.

**Preconditions**:
- User is logged in
- User has access to Workspace A and Workspace B
- Workspace A has 50+ tasks
- Workspace B has 30+ tasks
- Current workspace is Workspace A

**Steps**:
1. Navigate to Tasks list screen
2. Verify first page shows tasks from Workspace A only
3. Scroll down to load next page
4. Verify next page shows only Workspace A tasks (not Workspace B tasks)
5. Continue loading pages
6. Verify all pages show only Workspace A tasks
7. Switch to Workspace B
8. Navigate to Tasks list
9. Verify first page shows tasks from Workspace B only
10. Load next pages
11. Verify all pages show only Workspace B tasks

**Expected Results**:
- ✅ Paginated queries filter by current workspace
- ✅ All pages show only current workspace data
- ✅ No data leakage between workspaces

---

## Test Case 9: Paginated Projects Filter by Workspace

**Objective**: Verify that paginated project queries filter by current workspace.

**Preconditions**:
- User is logged in
- User has access to Workspace A and Workspace B
- Workspace A has 20+ projects
- Workspace B has 15+ projects
- Current workspace is Workspace A

**Steps**:
1. Navigate to Projects list screen
2. Verify first page shows projects from Workspace A only
3. Scroll down to load next page
4. Verify next page shows only Workspace A projects
5. Continue loading pages
6. Verify all pages show only Workspace A projects
7. Switch to Workspace B
8. Verify projects list shows only Workspace B projects

**Expected Results**:
- ✅ Paginated project queries filter by current workspace
- ✅ All pages show only current workspace data

---

## Test Case 10: Search/Filter Tasks Within Workspace

**Objective**: Verify that task search/filter works within current workspace only.

**Preconditions**:
- User is logged in
- User has access to Workspace A and Workspace B
- Workspace A has tasks with keyword "urgent"
- Workspace B has tasks with keyword "urgent"
- Current workspace is Workspace A

**Steps**:
1. Navigate to Tasks list screen
2. Use search/filter to find tasks with keyword "urgent"
3. Verify only Workspace A tasks with "urgent" are shown
4. Verify Workspace B tasks with "urgent" are NOT shown
5. Switch to Workspace B
6. Search for "urgent" again
7. Verify only Workspace B tasks with "urgent" are shown
8. Verify Workspace A tasks with "urgent" are NOT shown

**Expected Results**:
- ✅ Search/filter works within current workspace only
- ✅ Results are scoped to current workspace
- ✅ No cross-workspace data leakage

---

## Test Case 11: Statistics/Analytics Filter by Workspace

**Objective**: Verify that statistics and analytics are scoped to current workspace.

**Preconditions**:
- User is logged in
- User has access to Workspace A and Workspace B
- Each workspace has different task/project statistics
- Current workspace is Workspace A

**Steps**:
1. Navigate to Statistics/Analytics screen
2. Verify statistics shown are for Workspace A:
   - Task counts match Workspace A tasks
   - Project counts match Workspace A projects
   - Charts/graphs show Workspace A data
3. Switch to Workspace B
4. Navigate to Statistics/Analytics screen
5. Verify statistics shown are for Workspace B:
   - Task counts match Workspace B tasks
   - Project counts match Workspace B projects
   - Charts/graphs show Workspace B data
6. Verify statistics are different from Workspace A

**Expected Results**:
- ✅ Statistics are scoped to current workspace
- ✅ Analytics show only current workspace data
- ✅ No cross-workspace data mixing

---

## Test Case 12: Workspace Switch - Data Updates Immediately

**Objective**: Verify that data updates immediately when workspace is switched.

**Preconditions**:
- User is logged in
- User has access to Workspace A and Workspace B
- User is viewing Tasks list in Workspace A
- Current workspace is Workspace A

**Steps**:
1. On Tasks list screen, note the tasks visible (Workspace A tasks)
2. Switch to Workspace B (without navigating away from Tasks list)
3. Verify Tasks list updates immediately:
   - Workspace A tasks disappear
   - Workspace B tasks appear
4. Verify no stale data from Workspace A is shown
5. Switch back to Workspace A
6. Verify Tasks list updates immediately again
7. Verify Workspace A tasks reappear

**Expected Results**:
- ✅ Data updates immediately when workspace is switched
- ✅ No stale data from previous workspace
- ✅ UI reflects current workspace data correctly

---

## Test Case 13: Missing WorkspaceId - Error Handling

**Objective**: Verify error handling when workspaceId is missing.

**Preconditions**:
- User is logged in
- Current workspace is not set (edge case)

**Steps**:
1. Simulate scenario where workspaceId is missing:
   - Clear workspaceId from storage (if possible)
   - OR test with new user who hasn't selected workspace
2. Navigate to Tasks list screen
3. Verify one of the following:
   - Error message appears: "No workspace ID found"
   - OR empty state is shown
   - OR user is prompted to select workspace
4. Navigate to Projects list screen
5. Verify similar error handling
6. Select a workspace
7. Verify data loads correctly after workspace is set

**Expected Results**:
- ✅ Error handling works when workspaceId is missing
- ✅ Clear error messages are shown
- ✅ User can recover by selecting workspace

---

## Test Case 14: Verify Firebase Query Structure

**Objective**: Verify that Firebase queries use correct workspace path structure.

**Preconditions**:
- User is logged in
- User has access to Workspace A
- Current workspace is Workspace A
- Firebase console access (optional)

**Steps**:
1. Note the current workspace ID (Workspace A)
2. Navigate to Tasks list screen
3. Monitor Firebase queries (if possible via debug tools):
   - Verify queries use path: `workspaces/{workspaceId}/tasks`
   - Verify workspaceId matches current workspace
4. Navigate to Projects list screen
5. Verify queries use path: `workspaces/{workspaceId}/projects`
6. Navigate to Reports list screen
7. Verify queries use path: `workspaces/{workspaceId}/reports`
8. Switch to Workspace B
9. Verify queries now use Workspace B ID in paths

**Expected Results**:
- ✅ Firebase queries use correct workspace path structure
- ✅ All queries include workspaceId in path
- ✅ Queries update when workspace changes

**Note**: May require Firebase console access or debug tools.

---

## Test Case 15: Cross-Workspace Data Leakage Test

**Objective**: Verify no data from other workspaces is visible.

**Preconditions**:
- User is logged in
- User has access to Workspace A and Workspace B
- Workspace A has: Task A1, Project A1, Report A1
- Workspace B has: Task B1, Project B1, Report B1
- Current workspace is Workspace A

**Steps**:
1. Navigate to Tasks list (Workspace A)
2. Verify Task A1 is visible
3. Verify Task B1 is NOT visible
4. Navigate to Projects list (Workspace A)
5. Verify Project A1 is visible
6. Verify Project B1 is NOT visible
7. Navigate to Reports list (Workspace A)
8. Verify Report A1 is visible
9. Verify Report B1 is NOT visible
10. Try to access Workspace B data directly:
    - Try to open Task B1 by ID (if possible)
    - Verify access is denied or task not found
11. Switch to Workspace B
12. Verify only Workspace B data is visible
13. Verify Workspace A data is NOT visible

**Expected Results**:
- ✅ No cross-workspace data leakage
- ✅ Data from other workspaces is not accessible
- ✅ Workspace isolation is maintained

---

## Test Case 16: Global Guard/Interceptor Test (CURRENTLY MISSING)

**Objective**: Verify global guard/interceptor ensures all queries are scoped.

**Preconditions**:
- User is logged in
- Global guard/interceptor is implemented (when available)

**Steps**:
1. Test various data operations:
   - Create task
   - Create project
   - Create report
   - List tasks
   - List projects
   - List reports
   - Update task
   - Delete project
2. Verify one of the following:
   - **If implemented**: Global guard automatically injects workspaceId
   - **If NOT implemented**: Each operation must manually pass workspaceId (this is current behavior)
3. Test operations without workspaceId:
   - Verify guard/interceptor adds workspaceId automatically
   - OR verify error is thrown if workspaceId is missing

**Expected Results**:
- ⚠️ **CURRENT STATUS**: No global guard/interceptor exists
- ✅ **When implemented**: All queries are automatically scoped to current workspace
- ✅ Missing workspaceId is handled gracefully

---

## Test Case 17: Audit All Data Queries

**Objective**: Audit all data queries to ensure they filter by workspace.

**Preconditions**:
- User is logged in
- Access to codebase or documentation

**Steps**:
1. Review all data query operations:
   - Task queries (list, get, create, update, delete)
   - Project queries (list, get, create, update, delete)
   - Report queries (list, get, create, update, delete)
   - User queries (if workspace-scoped)
   - Other data queries
2. For each query, verify:
   - workspaceId parameter is required
   - workspaceId is passed from controller
   - workspaceId matches current workspace
   - Query uses workspaceId in Firebase path
3. Document any queries that don't filter by workspace
4. Test those queries to verify behavior

**Expected Results**:
- ✅ All data queries filter by workspace
- ✅ No queries bypass workspace filtering
- ✅ Audit report is created

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Tasks are filtered by current workspace
- [ ] Projects are filtered by current workspace
- [ ] Reports are filtered by current workspace
- [ ] New tasks are created in current workspace
- [ ] New projects are created in current workspace
- [ ] New reports are created in current workspace
- [ ] Data updates immediately when workspace is switched
- [ ] Paginated queries filter by workspace
- [ ] Search/filter works within workspace only
- [ ] Statistics are scoped to workspace
- [ ] No cross-workspace data leakage
- [ ] Error handling works when workspaceId is missing
- [ ] Firebase queries use correct workspace paths
- [ ] Global guard/interceptor works (when implemented)

---

## Known Issues (Based on Audit Report)

1. **No Global Guard**: 
   - No global guard ensuring controllers/use cases always pass current workspace
   - No interceptor to automatically inject workspaceId
   - **Status**: ⚠️ Missing

2. **Manual WorkspaceId Passing**:
   - Each controller/use case must manually pass workspaceId
   - Easy to forget or miss in new code
   - **Status**: ⚠️ Error-Prone

3. **No Enforcement**:
   - Hard to guarantee all queries are scoped
   - Needs auditing across all features
   - **Status**: ⚠️ Needs Audit

---

## Notes for Testers

1. **Workspace Isolation**: The main goal is to ensure data from one workspace is never visible in another workspace.

2. **Current Workspace**: Always verify which workspace is currently active before testing data visibility.

3. **Firebase Verification**: For critical tests, you may need to check Firebase Realtime Database directly to verify queries use correct workspace paths.

4. **Edge Cases**: Test scenarios where:
   - WorkspaceId is missing
   - User switches workspace rapidly
   - User has access to many workspaces
   - Workspace is deleted while viewing data

5. **Performance**: Verify that workspace filtering doesn't impact performance significantly.

6. **Data Integrity**: Verify that data created in one workspace doesn't appear in another workspace.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- Current workspace ID
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Firebase query paths (if accessible)
- Whether it's a known issue or new bug
- Data that leaked between workspaces (if any)
