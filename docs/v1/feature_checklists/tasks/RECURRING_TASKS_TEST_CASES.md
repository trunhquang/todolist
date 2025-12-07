# Recurring Tasks - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Recurring Tasks** feature. This feature is currently **PARTIAL** - `TaskEntity.recurring` + `generate_recurring_tasks.dart` use case exist; UI wiring unclear; no scheduler hook observed in controllers.

## Prerequisites
- User must be logged in
- Workspace should exist
- User should have permission to create tasks

---

## Test Case 1: Create Recurring Task - UI Wiring Unclear

**Objective**: Verify recurring task can be created with proper recurring configuration (UI wiring unclear).

**Preconditions**:
- User is logged in
- Workspace exists
- User has permission to create tasks

**Steps**:
1. Navigate to Task List page
2. Tap "Create Task" button
3. Fill in task details:
   - Title: "Daily Standup"
   - Description: "Team standup meeting"
   - Type: Daily
   - Priority: Medium
   - Status: Pending
4. Enable "Recurring task" toggle
5. Verify recurring options appear:
   - Frequency dropdown (Daily/Weekly/Monthly)
   - Interval input field
   - End date picker (optional)
6. Set recurring configuration:
   - Frequency: Daily
   - Interval: 1
   - End date: (optional) Set to 30 days from now
7. Save task
8. Verify one of the following:
   - **If NOT properly wired**: Recurring config is not saved (this is expected - UI wiring unclear)
   - **If properly wired**: Recurring config is saved
9. If properly wired:
   - Verify task is created with recurring config:
     - Task appears in task list
     - Task has `recurring.isRecurring = true`
     - Task has `recurring.frequency = 'daily'`
     - Task has `recurring.interval = 1`
     - Task has `recurring.endDate` (if set)
   - Verify task is not an instance:
     - Task does not have `parentTaskId`
     - Task is the parent recurring task

**Expected Results**:
- ⚠️ **CURRENT STATUS**: UI wiring unclear - recurring config may not be properly saved
- ✅ **When properly wired**: Recurring task is created with correct config
- ✅ Task is saved to Firebase with recurring config

---

## Test Case 2: Edit Recurring Task Configuration - UI Wiring Unclear

**Objective**: Verify recurring task configuration can be edited (UI wiring unclear).

**Preconditions**:
- User is logged in
- Recurring task exists
- User has permission to edit tasks

**Steps**:
1. Navigate to Task List page
2. Locate a recurring task
3. Tap to edit task
4. Verify recurring configuration is displayed:
   - "Recurring task" toggle is ON
   - Frequency is shown
   - Interval is shown
   - End date is shown (if set)
5. Modify recurring configuration:
   - Change frequency from Daily to Weekly
   - Change interval from 1 to 2
   - Change end date
6. Save task
7. Verify one of the following:
   - **If NOT properly wired**: Changes are not saved (this is expected - UI wiring unclear)
   - **If properly wired**: Changes are saved
8. If properly wired:
   - Verify task is updated:
     - Task has updated `recurring.frequency = 'weekly'`
     - Task has updated `recurring.interval = 2`
     - Task has updated `recurring.endDate`
   - Verify existing instances are not affected:
     - Previously generated instances remain unchanged
     - Only future instances use new config

**Expected Results**:
- ⚠️ **CURRENT STATUS**: UI wiring unclear - recurring config changes may not be saved
- ✅ **When properly wired**: Recurring config is updated correctly
- ✅ Existing instances are not affected

---

## Test Case 3: Disable Recurring Task - UI Wiring Unclear

**Objective**: Verify recurring task can be disabled (UI wiring unclear).

**Preconditions**:
- User is logged in
- Recurring task exists
- User has permission to edit tasks

**Steps**:
1. Navigate to Task List page
2. Locate a recurring task
3. Tap to edit task
4. Verify "Recurring task" toggle is ON
5. Disable recurring:
   - Turn OFF "Recurring task" toggle
6. Save task
7. Verify one of the following:
   - **If NOT properly wired**: Recurring is not disabled (this is expected - UI wiring unclear)
   - **If properly wired**: Recurring is disabled
8. If properly wired:
   - Verify task is updated:
     - Task has `recurring.isRecurring = false`
     - Task has `recurring.frequency = null`
     - Task has `recurring.interval = null`
     - Task has `recurring.endDate = null`
   - Verify no new instances are generated:
     - Future generation does not create instances for this task

**Expected Results**:
- ⚠️ **CURRENT STATUS**: UI wiring unclear - recurring disable may not work
- ✅ **When properly wired**: Recurring is disabled correctly
- ✅ No new instances are generated

---

## Test Case 4: Manual Recurring Task Generation - Partial Implementation

**Objective**: Verify recurring task instances can be generated manually (partial - controller exists but may not be wired to UI).

**Preconditions**:
- User is logged in
- Recurring task exists
- `RecurringTaskController` exists

**Steps**:
1. Navigate to Task List page or Settings page
2. Verify one of the following:
   - **If NOT wired to UI**: No manual generation button/option (this is expected - not wired to UI)
   - **If wired to UI**: Manual generation button/option exists
3. If wired to UI:
   - Tap "Generate Recurring Tasks" button
   - Verify generation starts:
     - Loading indicator appears
     - Generation is in progress
   - Wait for generation to complete
   - Verify generation result:
     - Success message is shown
     - Number of generated instances is displayed
   - Verify instances are created:
     - New task instances appear in task list
     - Instances have `parentTaskId` pointing to parent task
     - Instances have `recurring.isRecurring = false`
     - Instances have correct deadline dates

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Manual generation may not be wired to UI (partial)
- ✅ **When fully implemented**: Manual generation works from UI
- ✅ Instances are generated correctly

---

## Test Case 5: Automatic Recurring Task Generation - Missing Scheduler Hook

**Objective**: Verify recurring task instances are generated automatically (missing - no scheduler hook).

**Preconditions**:
- User is logged in
- Recurring task exists
- Scheduler is implemented

**Steps**:
1. Create a recurring task:
   - Frequency: Daily
   - Interval: 1
   - End date: 7 days from now
2. Verify one of the following:
   - **If NOT implemented**: No automatic generation occurs (this is expected - scheduler missing)
   - **If implemented**: Automatic generation occurs
3. If implemented:
   - Wait for scheduled generation time (e.g., daily at midnight)
   - Verify generation happens automatically:
     - No user interaction required
     - Generation runs in background
   - Verify instances are created:
     - New instances appear in task list
     - Instances are created for each day
   - Verify generation respects limits:
     - Only generates instances up to end date
     - Does not generate past end date

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Automatic generation is NOT implemented (missing scheduler hook)
- ✅ **When implemented**: Automatic generation works
- ✅ Instances are generated on schedule

---

## Test Case 6: Dashboard Hook for Generation - Partial Implementation

**Objective**: Verify recurring task generation is triggered when dashboard is opened (partial - only in dashboard onInit).

**Preconditions**:
- User is logged in
- Recurring task exists
- Dashboard controller has `_checkAndGenerateRecurringTasks()` in `onInit()`

**Steps**:
1. Create a recurring task
2. Note the current time
3. Close app or navigate away from dashboard
4. Wait at least 1 hour (generation cooldown)
5. Navigate to Dashboard page
6. Verify one of the following:
   - **If NOT working**: Generation does not happen (this is unexpected - should work)
   - **If working**: Generation happens automatically
7. If working:
   - Verify generation is triggered:
     - Generation runs when dashboard opens
     - Generation respects cooldown (only runs if > 1 hour since last run)
   - Verify instances are created:
     - New instances appear in task list
   - Verify generation stats:
     - Last generation time is updated
     - Next scheduled generation time is calculated

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Generation is triggered in dashboard `onInit()` (partial - only when dashboard opens)
- ✅ Generation works when dashboard opens
- ✅ Cooldown is respected
- ⚠️ **LIMITATION**: Only works when dashboard is opened, not periodic

---

## Test Case 7: Recurring Task Frequency - Daily

**Objective**: Verify daily recurring tasks generate instances correctly.

**Preconditions**:
- User is logged in
- Recurring task with daily frequency exists
- Generation is triggered

**Steps**:
1. Create a recurring task:
   - Frequency: Daily
   - Interval: 1
   - End date: 7 days from now
2. Trigger generation manually or wait for automatic generation
3. Verify instances are generated:
   - One instance per day
   - Instances have correct dates:
     - Day 1: Today
     - Day 2: Tomorrow
     - Day 3: Day after tomorrow
     - etc.
   - Verify instance deadlines:
     - Each instance has deadline set correctly
     - Deadlines are sequential

**Expected Results**:
- ✅ Daily frequency works correctly
- ✅ Instances are generated for each day
- ✅ Dates are correct

---

## Test Case 8: Recurring Task Frequency - Weekly

**Objective**: Verify weekly recurring tasks generate instances correctly.

**Preconditions**:
- User is logged in
- Recurring task with weekly frequency exists
- Generation is triggered

**Steps**:
1. Create a recurring task:
   - Frequency: Weekly
   - Interval: 1
   - End date: 4 weeks from now
2. Trigger generation manually or wait for automatic generation
3. Verify instances are generated:
   - One instance per week
   - Instances have correct dates:
     - Week 1: This week
     - Week 2: Next week
     - Week 3: Week after next
     - etc.
   - Verify interval works:
     - If interval = 2, instances are every 2 weeks

**Expected Results**:
- ✅ Weekly frequency works correctly
- ✅ Instances are generated for each week
- ✅ Interval is respected

---

## Test Case 9: Recurring Task Frequency - Monthly

**Objective**: Verify monthly recurring tasks generate instances correctly.

**Preconditions**:
- User is logged in
- Recurring task with monthly frequency exists
- Generation is triggered

**Steps**:
1. Create a recurring task:
   - Frequency: Monthly
   - Interval: 1
   - End date: 6 months from now
2. Trigger generation manually or wait for automatic generation
3. Verify instances are generated:
   - One instance per month
   - Instances have correct dates:
     - Month 1: This month
     - Month 2: Next month
     - Month 3: Month after next
     - etc.
   - Verify month boundaries:
     - Dates are in correct months
     - Day of month is preserved (if possible)

**Expected Results**:
- ✅ Monthly frequency works correctly
- ✅ Instances are generated for each month
- ✅ Month boundaries are handled correctly

---

## Test Case 10: Recurring Task Interval

**Objective**: Verify recurring task interval works correctly.

**Preconditions**:
- User is logged in
- Recurring task with interval > 1 exists
- Generation is triggered

**Steps**:
1. Create a recurring task:
   - Frequency: Daily
   - Interval: 3 (every 3 days)
   - End date: 30 days from now
2. Trigger generation manually or wait for automatic generation
3. Verify instances are generated:
   - Instances are created every 3 days
   - Dates are: Day 0, Day 3, Day 6, Day 9, etc.
   - Not every day (respects interval)

**Expected Results**:
- ✅ Interval is respected
- ✅ Instances are generated at correct intervals
- ✅ Dates are calculated correctly

---

## Test Case 11: Recurring Task End Date

**Objective**: Verify recurring task respects end date.

**Preconditions**:
- User is logged in
- Recurring task with end date exists
- Generation is triggered

**Steps**:
1. Create a recurring task:
   - Frequency: Daily
   - Interval: 1
   - End date: 5 days from now
2. Trigger generation manually or wait for automatic generation
3. Verify instances are generated:
   - Instances are created up to end date
   - No instances are created after end date
   - Last instance date matches end date (or before)

**Expected Results**:
- ✅ End date is respected
- ✅ No instances are generated after end date
- ✅ Last instance is on or before end date

---

## Test Case 12: Recurring Task Without End Date

**Objective**: Verify recurring task without end date generates instances indefinitely.

**Preconditions**:
- User is logged in
- Recurring task without end date exists
- Generation is triggered

**Steps**:
1. Create a recurring task:
   - Frequency: Daily
   - Interval: 1
   - End date: (not set)
2. Trigger generation manually or wait for automatic generation
3. Verify instances are generated:
   - Instances are created up to a reasonable limit (e.g., 30 days ahead)
   - Generation continues as long as task is recurring
   - No end date restriction

**Expected Results**:
- ✅ Tasks without end date generate instances
- ✅ Generation continues indefinitely (until disabled)
- ✅ Reasonable limit is applied (e.g., 30 days ahead)

---

## Test Case 13: Recurring Task Instance Properties

**Objective**: Verify recurring task instances have correct properties.

**Preconditions**:
- User is logged in
- Recurring task exists
- Instances are generated

**Steps**:
1. Create a recurring task:
   - Title: "Daily Standup"
   - Description: "Team meeting"
   - Priority: High
   - Status: Pending
   - Assignee: User A
   - Project: Project X
   - Frequency: Daily
2. Trigger generation
3. Verify instance properties:
   - Instance has `parentTaskId` pointing to parent task
   - Instance has `recurring.isRecurring = false`
   - Instance has same title as parent
   - Instance has same description as parent
   - Instance has same priority as parent
   - Instance has same assignee as parent
   - Instance has same project as parent
   - Instance has status = Pending (default)
   - Instance has correct deadline date
   - Instance has `workspaceId` same as parent

**Expected Results**:
- ✅ Instances inherit parent properties correctly
- ✅ Instances have `parentTaskId` set
- ✅ Instances have `recurring.isRecurring = false`
- ✅ Instances have correct deadline dates

---

## Test Case 14: Recurring Task Generation Cooldown

**Objective**: Verify generation cooldown prevents too frequent generation.

**Preconditions**:
- User is logged in
- Recurring task exists
- Generation cooldown is implemented (1 hour)

**Steps**:
1. Create a recurring task
2. Trigger generation manually
3. Note the generation time
4. Immediately trigger generation again
5. Verify one of the following:
   - **If NOT implemented**: Generation runs again (this is expected - cooldown may not work)
   - **If implemented**: Generation is skipped (cooldown active)
6. If implemented:
   - Wait 1 hour
   - Trigger generation again
   - Verify generation runs:
     - Generation executes
     - New instances are created

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Cooldown exists in service but may not be enforced everywhere
- ✅ **When fully implemented**: Cooldown prevents too frequent generation
- ✅ Generation runs after cooldown period

---

## Test Case 15: Recurring Task Generation Statistics

**Objective**: Verify generation statistics are tracked and displayed.

**Preconditions**:
- User is logged in
- Recurring tasks exist
- Generation statistics are implemented

**Steps**:
1. Navigate to Settings or Recurring Tasks page
2. Verify one of the following:
   - **If NOT implemented**: Statistics are not displayed (this is expected - UI missing)
   - **If implemented**: Statistics are displayed
3. If implemented:
   - Verify statistics shown:
     - Total recurring tasks
     - Last generation time
     - Next scheduled generation time
     - Number of instances generated
   - Verify statistics are accurate:
     - Last generation time matches actual last run
     - Next scheduled time is calculated correctly
   - Verify statistics update:
     - Statistics refresh after generation
     - Statistics are current

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Statistics exist in service but may not be displayed in UI
- ✅ **When fully implemented**: Statistics are displayed
- ✅ Statistics are accurate and update correctly

---

## Test Case 16: Recurring Task with Closed Project

**Objective**: Verify recurring tasks stop generating when project is closed.

**Preconditions**:
- User is logged in
- Recurring task linked to project exists
- Project can be closed

**Steps**:
1. Create a recurring task linked to a project
2. Trigger generation - verify instances are created
3. Close the project
4. Trigger generation again
5. Verify one of the following:
   - **If NOT implemented**: Instances are still generated (this is expected - project check may not work)
   - **If implemented**: Generation is skipped for closed project
6. If implemented:
   - Verify generation result:
     - Task is skipped
     - Reason: "Project is closed"
   - Verify no instances are created:
     - No new instances for this task
   - Reopen project:
     - Generation resumes
     - New instances are created

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Project closed check exists in use case but may not be fully tested
- ✅ **When fully implemented**: Generation stops for closed projects
- ✅ Generation resumes when project reopens

---

## Test Case 17: Recurring Task Generation Errors

**Objective**: Verify error handling for generation failures.

**Preconditions**:
- User is logged in
- Recurring task exists
- Error handling is implemented

**Steps**:
1. Create a recurring task
2. Simulate error condition:
   - Disconnect internet
   - Or cause database error
3. Trigger generation
4. Verify one of the following:
   - **If NOT implemented**: Error is not handled gracefully (this is expected - error handling may be missing)
   - **If implemented**: Error is handled gracefully
5. If implemented:
   - Verify error handling:
     - Error message is shown
     - Generation result indicates failure
     - Partial generation is handled (some instances created, some failed)
   - Verify recovery:
     - Retry works after error is resolved
     - Previously generated instances are not duplicated

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Error handling may be partial
- ✅ **When fully implemented**: Errors are handled gracefully
- ✅ Recovery works correctly

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Recurring task can be created (UI wiring unclear)
- [ ] Recurring config can be edited (UI wiring unclear)
- [ ] Recurring can be disabled (UI wiring unclear)
- [ ] Manual generation works (partial - may not be wired to UI)
- [ ] Automatic generation works (missing - no scheduler hook)
- [ ] Dashboard hook works (partial - only when dashboard opens)
- [ ] Daily frequency works
- [ ] Weekly frequency works
- [ ] Monthly frequency works
- [ ] Interval works correctly
- [ ] End date is respected
- [ ] Tasks without end date work
- [ ] Instance properties are correct
- [ ] Generation cooldown works
- [ ] Statistics are displayed (may not be in UI)
- [ ] Closed project check works
- [ ] Error handling works

---

## Known Issues (Based on Audit Report)

1. **UI Wiring Unclear**:
   - Recurring config may not be properly saved when creating/editing tasks
   - UI exists but wiring to save/load recurring config may be incomplete
   - **Status**: ⚠️ Partial

2. **No Scheduler Hook**:
   - No automatic periodic generation
   - Only manual trigger in dashboard `onInit()`
   - No background timer/scheduler
   - **Status**: ⛔ Missing

3. **Manual Generation Not Wired to UI**:
   - `RecurringTaskController` exists but may not be accessible from UI
   - No visible button/option to trigger generation
   - **Status**: ⚠️ Partial

---

## Notes for Testers

1. **Current Status**: Recurring tasks are partially implemented:
   - Core logic exists (`GenerateRecurringTasks` use case)
   - Service exists (`RecurringTaskService`)
   - Controller exists (`RecurringTaskController`)
   - UI exists (`task_edit_page.dart`) but wiring unclear
   - No scheduler for automatic generation

2. **UI Wiring**: The UI for recurring tasks exists in `task_edit_page.dart` but need to verify:
   - Recurring config is properly saved when creating tasks
   - Recurring config is properly loaded when editing tasks
   - Recurring config changes are persisted

3. **Scheduler**: There's no periodic timer/scheduler. Generation only happens:
   - When dashboard is opened (in `dashboard_controller.dart` `onInit()`)
   - Manually via `RecurringTaskController` (if wired to UI)

4. **Generation Cooldown**: Service has cooldown (1 hour) but need to verify it's enforced.

5. **Project Closed Check**: Use case has check for closed projects but need to verify it works.

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
- Whether recurring config is saved/loaded correctly
- Whether generation happens automatically
- Whether manual generation works
- Whether scheduler exists
