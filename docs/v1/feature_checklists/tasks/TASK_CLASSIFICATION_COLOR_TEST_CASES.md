# Task Classification (Daily/Project) & Color by Status - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Task Classification (Daily/Project) & Color by Status** feature. This feature is currently **PARTIAL** - taskType string supports daily/project but not enforced by enum, and color mapping is not centralized/consistent.

## Prerequisites
- User must be logged in
- Workspace should exist
- Tasks should exist with different types (daily/project) and statuses
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: Create Task with Daily Type - Partial Implementation

**Objective**: Verify task can be created with Daily type (currently partial - uses string, not enum).

**Preconditions**:
- User is logged in
- User has `createTask` permission
- Workspace exists
- Create task feature is implemented

**Steps**:
1. Navigate to Task List page
2. Tap "Create Task" button
3. Verify create task form appears
4. Locate task type selector/dropdown
5. Verify type options are available:
   - "Daily" option
   - "Project" option
6. Select "Daily" type
7. Fill in other task details (title, description, etc.)
8. Create task
9. Verify task is created with Daily type
10. Verify one of the following:
    - **If NOT implemented**: Task type is stored as string "daily" (this is expected - enum enforcement missing)
    - **If implemented**: Task type is stored using `TaskType.daily` enum
11. If implemented:
    - Check Firebase data:
      - Verify task has `taskType` field
      - Verify type is stored as enum value (not string)
    - Verify type safety:
      - Attempt to set invalid type value
      - Verify validation error appears

**Expected Results**:
- ✅ Task can be created with Daily type
- ⚠️ **CURRENT ISSUE**: Type is stored as string, not enum
- ✅ **When implemented**: Type uses enum

---

## Test Case 2: Create Task with Project Type - Partial Implementation

**Objective**: Verify task can be created with Project type (currently partial - uses string, not enum).

**Preconditions**:
- User is logged in
- User has `createTask` permission
- Workspace exists
- Project exists (for project tasks)
- Create task feature is implemented

**Steps**:
1. Navigate to Task List page
2. Tap "Create Task" button
3. Verify create task form appears
4. Select "Project" type
5. Verify project selector appears (if applicable):
   - List of available projects
   - Project name displayed
6. Select a project (optional)
7. Fill in other task details
8. Create task
9. Verify task is created with Project type
10. Verify one of the following:
    - **If NOT implemented**: Task type is stored as string "project" (this is expected - enum enforcement missing)
    - **If implemented**: Task type is stored using `TaskType.project` enum
11. If implemented:
    - Check Firebase data:
      - Verify task has `taskType` field set to enum value
    - Verify project linkage:
      - If project was selected, verify `projectId` is set

**Expected Results**:
- ✅ Task can be created with Project type
- ⚠️ **CURRENT ISSUE**: Type is stored as string, not enum
- ✅ **When implemented**: Type uses enum

---

## Test Case 3: Task Type Enum Validation - Missing Enum Enforcement

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

## Test Case 4: Display Task Type Color - Partial Implementation

**Objective**: Verify task type colors are displayed correctly (currently partial - colors exist but not centralized).

**Preconditions**:
- User is logged in
- Tasks exist with different types (daily/project)
- Task type color display is implemented

**Steps**:
1. Navigate to Task List page
2. Locate tasks with different types
3. Verify task type indicators are displayed:
   - Daily tasks show type indicator
   - Project tasks show type indicator
4. Verify one of the following:
   - **If NOT implemented**: Colors are hardcoded or inconsistent (this is expected - color mapping missing)
   - **If implemented**: Colors are from centralized mapping
5. If implemented:
   - Verify Daily task color:
     - Daily tasks use `AppColors.dailyTask` color
     - Color is consistent across all UI components
   - Verify Project task color:
     - Project tasks use `AppColors.projectTask` color
     - Color is consistent across all UI components
   - Verify color consistency:
     - Check task card
     - Check task list
     - Check task detail view
     - Check dashboard
     - Verify all use same colors

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Colors may be hardcoded or inconsistent
- ✅ **When implemented**: Colors are centralized and consistent
- ✅ All UI components use same colors

---

## Test Case 5: Display Task Status Color - Partial Implementation

**Objective**: Verify task status colors are displayed correctly (currently partial - colors exist but not centralized).

**Preconditions**:
- User is logged in
- Tasks exist with different statuses (pending, in_progress, completed, cancelled)
- Task status color display is implemented

**Steps**:
1. Navigate to Task List page
2. Locate tasks with different statuses
3. Verify task status indicators are displayed:
   - Pending tasks show status indicator
   - In Progress tasks show status indicator
   - Completed tasks show status indicator
   - Cancelled tasks show status indicator
4. Verify one of the following:
   - **If NOT implemented**: Colors are hardcoded or inconsistent (this is expected - color mapping missing)
   - **If implemented**: Colors are from centralized mapping
5. If implemented:
   - Verify status colors:
     - Pending: `AppColors.pendingStatus`
     - In Progress: `AppColors.inProgressStatus`
     - Completed: `AppColors.completedStatus`
     - Cancelled: `AppColors.cancelledStatus`
   - Verify color consistency:
     - Check task card
     - Check task list
     - Check task detail view
     - Check dashboard
     - Verify all use same colors

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Colors may be hardcoded or inconsistent
- ✅ **When implemented**: Colors are centralized and consistent
- ✅ All UI components use same colors

---

## Test Case 6: Task Type Color Mapping - Missing Centralized Mapping

**Objective**: Verify task type color mapping is centralized (currently missing).

**Preconditions**:
- User is logged in
- Tasks exist with different types
- Centralized color mapping is implemented

**Steps**:
1. Navigate to Task List page
2. Verify one of the following:
   - **If NOT implemented**: Colors are hardcoded in multiple places (this is expected - centralized mapping missing)
   - **If implemented**: Colors come from centralized mapping
3. If implemented:
   - Verify color mapping exists:
     - `TaskType` enum has `color` getter, OR
     - `AppColors` has `getTaskTypeColor(TaskType)` method
   - Verify mapping is used:
     - Check task card code
     - Check task list code
     - Check dashboard code
     - Verify all use centralized mapping
   - Verify color values:
     - Daily: Correct color (e.g., primary color)
     - Project: Correct color (e.g., blue)
   - Test color changes:
     - If primary color changes, verify task type colors update accordingly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Centralized color mapping is NOT available (missing)
- ✅ **When implemented**: Color mapping is centralized
- ✅ All components use centralized mapping
- ✅ Colors are consistent

---

## Test Case 7: Task Status Color Mapping - Missing Centralized Mapping

**Objective**: Verify task status color mapping is centralized (currently missing).

**Preconditions**:
- User is logged in
- Tasks exist with different statuses
- Centralized color mapping is implemented

**Steps**:
1. Navigate to Task List page
2. Verify one of the following:
   - **If NOT implemented**: Colors are hardcoded in multiple places (this is expected - centralized mapping missing)
   - **If implemented**: Colors come from centralized mapping
3. If implemented:
   - Verify color mapping exists:
     - `TaskStatus` enum has `color` getter, OR
     - `AppColors` has `getTaskStatusColor(TaskStatus)` method
   - Verify mapping is used:
     - Check task card code
     - Check task list code
     - Check dashboard code
     - Verify all use centralized mapping
   - Verify color values:
     - Pending: Gray
     - In Progress: Blue
     - Completed: Green or primary color
     - Cancelled: Red
   - Test color consistency:
     - Verify same status always shows same color

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Centralized color mapping is NOT available (missing)
- ✅ **When implemented**: Color mapping is centralized
- ✅ All components use centralized mapping
- ✅ Colors are consistent

---

## Test Case 8: Filter Tasks by Type - Partial Implementation

**Objective**: Verify tasks can be filtered by type (may be partially implemented).

**Preconditions**:
- User is logged in
- Tasks exist with different types (daily/project)
- Filter by type feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate filter options
3. Verify one of the following:
   - **If NOT implemented**: Type filter is not available (this is expected - feature missing)
   - **If implemented**: Type filter exists
4. If implemented:
   - Verify type filter shows:
     - "All Types" option
     - "Daily" option
     - "Project" option
   - Select "Daily":
     - Verify only Daily tasks are shown
     - Verify Project tasks are hidden
   - Select "Project":
     - Verify only Project tasks are shown
     - Verify Daily tasks are hidden
   - Select "All Types":
     - Verify all tasks are shown
   - Verify filter uses enum:
     - Check filter implementation
     - Verify enum is used instead of string

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Type filter may be partially implemented
- ✅ **When fully implemented**: Tasks can be filtered by type
- ✅ Filter uses enum (not string)
- ✅ Filter works correctly

---

## Test Case 9: Task Type Display Text - Partial Implementation

**Objective**: Verify task type display text uses enum (currently partial).

**Preconditions**:
- User is logged in
- Tasks exist with different types
- Enum display text is implemented

**Steps**:
1. Navigate to Task List page
2. Locate tasks with different types
3. Verify type display text:
   - Daily tasks show "Daily" or "Daily Task"
   - Project tasks show "Project" or "Project Task"
4. Verify one of the following:
   - **If NOT implemented**: Display text is hardcoded (this is expected - enum display text missing)
   - **If implemented**: Display text comes from enum
5. If implemented:
   - Verify enum has `displayText` getter:
     - `TaskType.daily.displayText` returns "Daily"
     - `TaskType.project.displayText` returns "Project"
   - Verify display text is used:
     - Check task card
     - Check task list
     - Check task detail view
     - Verify all use enum display text

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Display text may be hardcoded
- ✅ **When implemented**: Display text comes from enum
- ✅ All components use enum display text

---

## Test Case 10: Task Status Display Text - Partial Implementation

**Objective**: Verify task status display text uses enum (currently partial).

**Preconditions**:
- User is logged in
- Tasks exist with different statuses
- Enum display text is implemented

**Steps**:
1. Navigate to Task List page
2. Locate tasks with different statuses
3. Verify status display text:
   - Pending tasks show "Pending"
   - In Progress tasks show "In Progress"
   - Completed tasks show "Completed"
   - Cancelled tasks show "Cancelled"
4. Verify one of the following:
   - **If NOT implemented**: Display text is hardcoded (this is expected - enum display text missing)
   - **If implemented**: Display text comes from enum
5. If implemented:
   - Verify enum has `displayText` getter:
     - `TaskStatus.pending.displayText` returns "Pending"
     - `TaskStatus.inProgress.displayText` returns "In Progress"
     - etc.
   - Verify display text is used:
     - Check task card
     - Check task list
     - Check task detail view
     - Verify all use enum display text

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Display text may be hardcoded
- ✅ **When implemented**: Display text comes from enum
- ✅ All components use enum display text

---

## Test Case 11: Task Type Icon Mapping - Missing Feature

**Objective**: Verify task type icons are displayed (currently missing or inconsistent).

**Preconditions**:
- User is logged in
- Tasks exist with different types
- Task type icon display is implemented

**Steps**:
1. Navigate to Task List page
2. Locate tasks with different types
3. Verify one of the following:
   - **If NOT implemented**: Icons are not displayed or inconsistent (this is expected - icon mapping missing)
   - **If implemented**: Icons are displayed consistently
4. If implemented:
   - Verify Daily task icon:
     - Daily tasks show appropriate icon (e.g., calendar icon)
     - Icon is consistent across all UI components
   - Verify Project task icon:
     - Project tasks show appropriate icon (e.g., work icon)
     - Icon is consistent across all UI components
   - Verify icon mapping:
     - Icons come from centralized mapping
     - `TaskType` enum has `icon` getter, OR
     - `TaskConstants` has icon mapping

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Icons may be missing or inconsistent
- ✅ **When implemented**: Icons are displayed consistently
- ✅ Icon mapping is centralized

---

## Test Case 12: Task Status Icon Mapping - Missing Feature

**Objective**: Verify task status icons are displayed (currently missing or inconsistent).

**Preconditions**:
- User is logged in
- Tasks exist with different statuses
- Task status icon display is implemented

**Steps**:
1. Navigate to Task List page
2. Locate tasks with different statuses
3. Verify one of the following:
   - **If NOT implemented**: Icons are not displayed or inconsistent (this is expected - icon mapping missing)
   - **If implemented**: Icons are displayed consistently
4. If implemented:
   - Verify status icons:
     - Pending: Schedule icon
     - In Progress: Play icon
     - Completed: Check icon
     - Cancelled: Cancel icon
   - Verify icon consistency:
     - Icons are consistent across all UI components
   - Verify icon mapping:
     - Icons come from centralized mapping

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Icons may be missing or inconsistent
- ✅ **When implemented**: Icons are displayed consistently
- ✅ Icon mapping is centralized

---

## Test Case 13: Color Consistency Across UI Components - Missing Feature

**Objective**: Verify task type and status colors are consistent across all UI components (currently missing).

**Preconditions**:
- User is logged in
- Tasks exist with different types and statuses
- Centralized color mapping is implemented

**Steps**:
1. Navigate to different pages/views:
   - Task List page
   - Task Detail page
   - Dashboard page
   - Project Detail page (if applicable)
2. Verify one of the following:
   - **If NOT implemented**: Colors are inconsistent across components (this is expected - centralized mapping missing)
   - **If implemented**: Colors are consistent
3. If implemented:
   - Verify Daily task color:
     - Same color in task list
     - Same color in task detail
     - Same color in dashboard
   - Verify Project task color:
     - Same color in task list
     - Same color in task detail
     - Same color in dashboard
   - Verify status colors:
     - Same colors across all components
   - Verify color source:
     - All components use same color mapping
     - No hardcoded colors

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Colors may be inconsistent
- ✅ **When implemented**: Colors are consistent across all components
- ✅ All components use centralized mapping

---

## Test Case 14: Update Task Type - Partial Implementation

**Objective**: Verify task type can be updated (currently partial - may use string).

**Preconditions**:
- User is logged in
- User has `updateTask` permission
- Task exists
- Edit task feature is implemented

**Steps**:
1. Navigate to Task List page
2. Locate a task
3. Tap on task or "Edit" button
4. Verify edit task form appears
5. Locate type selector
6. Change task type:
   - If task is Daily, change to Project
   - If task is Project, change to Daily
7. Save task
8. Verify task type is updated
9. Verify one of the following:
   - **If NOT implemented**: Type is stored as string (this is expected - enum enforcement missing)
   - **If implemented**: Type is stored as enum
10. If implemented:
    - Verify type is updated correctly
    - Verify color updates accordingly

**Expected Results**:
- ✅ Task type can be updated
- ⚠️ **CURRENT ISSUE**: Type may be stored as string
- ✅ **When implemented**: Type uses enum

---

## Test Case 15: Task Type Color Theme Integration - Missing Feature

**Objective**: Verify task type colors integrate with app theme (currently missing).

**Preconditions**:
- User is logged in
- Tasks exist with different types
- Theme integration is implemented

**Steps**:
1. Navigate to Settings or Theme page
2. Change app theme (if applicable):
   - Light theme
   - Dark theme
   - Custom theme
3. Navigate to Task List page
4. Verify one of the following:
   - **If NOT implemented**: Colors don't adapt to theme (this is expected - theme integration missing)
   - **If implemented**: Colors adapt to theme
5. If implemented:
   - Verify Daily task color:
     - Color adapts to theme
     - Color is readable in current theme
   - Verify Project task color:
     - Color adapts to theme
     - Color is readable in current theme
   - Verify status colors:
     - Colors adapt to theme
     - Colors are readable in current theme

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Theme integration is NOT available (missing)
- ✅ **When implemented**: Colors adapt to theme
- ✅ Colors are readable in all themes

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Task can be created with Daily type (if implemented)
- [ ] Task can be created with Project type (if implemented)
- [ ] Task type uses enum (if implemented)
- [ ] Task type colors are displayed (if implemented)
- [ ] Task status colors are displayed (if implemented)
- [ ] Color mapping is centralized (if implemented)
- [ ] Colors are consistent across components (if implemented)
- [ ] Tasks can be filtered by type (if implemented)
- [ ] Task type display text uses enum (if implemented)
- [ ] Task status display text uses enum (if implemented)
- [ ] Task type icons are displayed (if implemented)
- [ ] Task status icons are displayed (if implemented)
- [ ] Task type can be updated (if implemented)
- [ ] Colors integrate with theme (if implemented)

---

## Known Issues (Based on Audit Report)

1. **Enum Enforcement Missing**:
   - `TaskType` enum exists but `TaskEntity` uses `String taskType`
   - No type safety for task type values
   - **Status**: ⚠️ Partial

2. **Color Mapping Not Centralized**:
   - Colors exist in `AppColors` but not used consistently
   - Hardcoded colors in multiple UI components
   - No centralized mapping function
   - **Status**: ⛔ Missing

3. **Status Color Mapping Missing**:
   - Status colors exist but not mapped to enum
   - Hardcoded colors in UI components
   - **Status**: ⛔ Missing

4. **Icon Mapping Missing**:
   - Icons may exist in `TaskConstants` but not used consistently
   - **Status**: ⛔ Missing

---

## Notes for Testers

1. **Current Status**: Task classification and color mapping are partially implemented:
   - `TaskType` enum exists but not enforced
   - Colors exist but not centralized
   - Colors may be inconsistent across components

2. **Task Type Enum**: `TaskType` enum exists in `task_enums.dart` with `daily` and `project` values, but `TaskEntity` still uses `String taskType`. Need to:
   - Update `TaskEntity` to use `TaskType` enum
   - Update controllers to use enum
   - Update UI to use enum

3. **Color Mapping**: `AppColors` has colors for task types and statuses, but they're not used consistently. Need to:
   - Create centralized color mapping functions
   - Update all UI components to use centralized mapping
   - Ensure colors are consistent

4. **Status Colors**: Need to map `TaskStatus` enum to colors:
   - Pending: Gray
   - In Progress: Blue
   - Completed: Green/Primary
   - Cancelled: Red

5. **Type Colors**: Need to map `TaskType` enum to colors:
   - Daily: Primary color
   - Project: Blue

6. **Consistency**: All UI components should use the same color mapping to ensure consistency.

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
- Firebase data (if accessible) showing task type data
- Whether enum is being used
- Whether colors are consistent
- Which UI components show inconsistent colors
