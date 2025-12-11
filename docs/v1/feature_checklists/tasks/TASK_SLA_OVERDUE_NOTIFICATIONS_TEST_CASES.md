# Task SLA Overdue Notifications - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Task SLA Overdue Notifications** feature. This feature is currently **MISSING** - Not implemented; no SLA timers or notifications.

## Prerequisites
- User must be logged in
- Workspace should exist
- Tasks with deadlines should exist
- User should have permission to create/edit tasks

---

## Test Case 1: Automatic Overdue Detection - Missing Feature

**Objective**: Verify system automatically detects overdue tasks (currently missing).

**Preconditions**:
- User is logged in
- Task with deadline exists
- Task deadline has passed
- Task status is not "completed" or "cancelled"
- SLA timer service is implemented

**Steps**:
1. Create a task with deadline:
   - Title: "Test Task"
   - Deadline: Set to 1 hour ago
   - Status: Pending or In Progress
2. Wait for SLA timer to run (e.g., every 5 minutes)
3. Verify one of the following:
   - **If NOT implemented**: Task is not detected as overdue (this is expected - feature missing)
   - **If implemented**: Task is detected as overdue
4. If implemented:
   - Verify overdue detection:
     - System checks tasks periodically
     - Overdue tasks are identified
     - Overdue status is stored/updated
   - Verify detection accuracy:
     - Only tasks with passed deadlines are marked overdue
     - Completed/cancelled tasks are not marked overdue
     - Tasks without deadlines are not checked

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Overdue tasks are automatically detected
- ✅ Detection is accurate
- ✅ Detection runs periodically

---

## Test Case 2: Overdue Notification - Missing Feature

**Objective**: Verify notification is sent when task becomes overdue (currently missing).

**Preconditions**:
- User is logged in
- Task with deadline exists
- Task deadline has passed
- Task is assigned to user
- Overdue notification is implemented

**Steps**:
1. Create a task with deadline:
   - Title: "Test Task"
   - Deadline: Set to 1 hour ago
   - Assignee: Current user
   - Status: Pending
2. Wait for SLA timer to detect overdue
3. Verify one of the following:
   - **If NOT implemented**: No notification is sent (this is expected - feature missing)
   - **If implemented**: Notification is sent
4. If implemented:
   - Verify notification:
     - Notification is received
     - Title: "Task Overdue" or similar
     - Message: Contains task title and overdue information
     - Payload: Contains task ID for navigation
   - Verify notification timing:
     - Notification is sent when task becomes overdue
     - Notification is not sent multiple times for same overdue period
   - Verify notification recipient:
     - Notification is sent to task assignee
     - Notification is sent to task assigner (optional)
     - Notification is sent to project manager (if task is in project)

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Overdue notifications are sent
- ✅ Notifications are clear and helpful
- ✅ Notifications are sent to correct recipients

---

## Test Case 3: Approaching Deadline Notification - Missing Feature

**Objective**: Verify notification is sent when deadline is approaching (currently missing).

**Preconditions**:
- User is logged in
- Task with deadline exists
- Deadline is approaching (e.g., 1 hour before)
- Task is not completed
- Approaching deadline notification is implemented

**Steps**:
1. Create a task with deadline:
   - Title: "Test Task"
   - Deadline: Set to 1 hour from now
   - Assignee: Current user
   - Status: Pending or In Progress
2. Wait for approaching deadline notification time
3. Verify one of the following:
   - **If NOT implemented**: No notification is sent (this is expected - feature missing)
   - **If implemented**: Notification is sent
4. If implemented:
   - Verify notification:
     - Notification is received before deadline
     - Title: "Deadline Approaching" or similar
     - Message: Contains task title and time remaining
     - Payload: Contains task ID
   - Verify notification timing:
     - Notification is sent at configured time before deadline (e.g., 1 hour, 24 hours)
     - Notification is not sent if task is already completed
   - Verify configurable thresholds:
     - Can configure when to send notification (1 hour, 24 hours, etc.)
     - Multiple notifications can be sent (e.g., 24 hours and 1 hour before)

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Approaching deadline notifications are sent
- ✅ Notifications are sent at correct times
- ✅ Thresholds are configurable

---

## Test Case 4: Critical Overdue Notification - Missing Feature

**Objective**: Verify critical notification is sent for critically overdue tasks (currently missing).

**Preconditions**:
- User is logged in
- Task with deadline exists
- Task is overdue by significant time (e.g., 24 hours)
- Critical overdue notification is implemented

**Steps**:
1. Create a task with deadline:
   - Title: "Test Task"
   - Deadline: Set to 25 hours ago
   - Assignee: Current user
   - Status: Pending
2. Wait for critical overdue threshold (e.g., 24 hours overdue)
3. Verify one of the following:
   - **If NOT implemented**: No critical notification is sent (this is expected - feature missing)
   - **If implemented**: Critical notification is sent
4. If implemented:
   - Verify critical notification:
     - Notification is received when task is critically overdue
     - Title: "Critical: Task Overdue" or similar
     - Message: Contains task title and overdue duration
     - Notification has higher priority/urgency
   - Verify critical threshold:
     - Threshold is configurable (e.g., 24 hours, 48 hours)
     - Notification is sent when threshold is exceeded
   - Verify escalation:
     - Manager/supervisor is notified (optional)
     - Multiple escalation levels (optional)

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Critical overdue notifications are sent
- ✅ Thresholds are configurable
- ✅ Escalation works (if implemented)

---

## Test Case 5: SLA Timer Service - Missing Feature

**Objective**: Verify SLA timer service runs periodically to check for overdue tasks (currently missing).

**Preconditions**:
- User is logged in
- SLA timer service is implemented
- Tasks with deadlines exist

**Steps**:
1. Verify one of the following:
   - **If NOT implemented**: No SLA timer service exists (this is expected - feature missing)
   - **If implemented**: SLA timer service exists
2. If implemented:
   - Verify timer initialization:
     - Timer service is initialized on app start
     - Timer runs periodically (e.g., every 5 minutes)
   - Verify timer execution:
     - Timer checks all tasks with deadlines
     - Timer identifies overdue tasks
     - Timer triggers notifications
   - Verify timer efficiency:
     - Timer does not check completed/cancelled tasks
     - Timer only checks tasks in current workspace
     - Timer is efficient (does not cause performance issues)

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: SLA timer service runs periodically
- ✅ Timer is efficient
- ✅ Timer checks correct tasks

---

## Test Case 6: Overdue Task Indicator in UI - Missing Feature

**Objective**: Verify overdue tasks are visually indicated in UI (currently missing).

**Preconditions**:
- User is logged in
- Overdue task exists
- UI indicator is implemented

**Steps**:
1. Navigate to Task List page
2. Locate an overdue task
3. Verify one of the following:
   - **If NOT implemented**: No overdue indicator (this is expected - feature missing)
   - **If implemented**: Overdue indicator is shown
4. If implemented:
   - Verify visual indicator:
     - Overdue badge/icon is shown
     - Overdue tasks are highlighted (e.g., red color)
     - Overdue duration is shown (e.g., "2 days overdue")
   - Verify indicator accuracy:
     - Only overdue tasks show indicator
     - Completed tasks don't show indicator
     - Indicator updates when task is completed

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Overdue tasks are visually indicated
- ✅ Indicator is clear and accurate

---

## Test Case 7: Overdue Task Filter - Missing Feature

**Objective**: Verify tasks can be filtered to show only overdue tasks (currently missing).

**Preconditions**:
- User is logged in
- Overdue tasks exist
- Filter feature is implemented

**Steps**:
1. Navigate to Task List page
2. Open filter options
3. Verify one of the following:
   - **If NOT implemented**: No overdue filter (this is expected - feature missing)
   - **If implemented**: Overdue filter exists
4. If implemented:
   - Verify filter option:
     - "Overdue" filter option exists
     - Can toggle filter on/off
   - Verify filter results:
     - Only overdue tasks are shown when filter is on
     - All tasks are shown when filter is off
   - Verify combined filters:
     - Can combine overdue filter with other filters (status, priority)
     - Combined filters work correctly

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Overdue filter works correctly
- ✅ Filter is accurate
- ✅ Combined filters work

---

## Test Case 8: SLA Settings Configuration - Missing Feature

**Objective**: Verify SLA notification settings can be configured (currently missing).

**Preconditions**:
- User is logged in
- Settings page exists
- SLA settings are implemented

**Steps**:
1. Navigate to Settings page
2. Locate "SLA Notifications" or "Deadline Alerts" section
3. Verify one of the following:
   - **If NOT implemented**: No SLA settings (this is expected - feature missing)
   - **If implemented**: SLA settings exist
4. If implemented:
   - Verify settings options:
     - Enable/disable overdue notifications
     - Configure approaching deadline threshold (e.g., 1 hour, 24 hours)
     - Configure critical overdue threshold (e.g., 24 hours, 48 hours)
     - Configure notification frequency (e.g., once, daily, hourly)
   - Verify settings persistence:
     - Settings are saved
     - Settings are applied to notifications
     - Settings are per-user or per-workspace

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: SLA settings can be configured
- ✅ Settings are saved and applied

---

## Test Case 9: Notification Frequency Control - Missing Feature

**Objective**: Verify notification frequency can be controlled to avoid spam (currently missing).

**Preconditions**:
- User is logged in
- Overdue task exists
- Notification frequency control is implemented

**Steps**:
1. Create an overdue task
2. Wait for first overdue notification
3. Verify one of the following:
   - **If NOT implemented**: Notifications may be sent repeatedly (this is expected - control missing)
   - **If implemented**: Notification frequency is controlled
4. If implemented:
   - Verify frequency control:
     - Notification is sent once per overdue period (e.g., once per day)
     - Or notification is sent at configured intervals
     - No notification spam
   - Verify frequency settings:
     - Can configure notification frequency (once, daily, hourly)
     - Settings are respected

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Notification frequency is controlled
- ✅ No notification spam

---

## Test Case 10: Overdue Task Statistics - Missing Feature

**Objective**: Verify overdue task statistics are tracked and displayed (currently missing).

**Preconditions**:
- User is logged in
- Overdue tasks exist
- Statistics feature is implemented

**Steps**:
1. Navigate to Dashboard or Statistics page
2. Verify one of the following:
   - **If NOT implemented**: No overdue statistics (this is expected - feature missing)
   - **If implemented**: Overdue statistics are displayed
3. If implemented:
   - Verify statistics shown:
     - Total overdue tasks count
     - Overdue tasks by workspace
     - Overdue tasks by project
     - Average overdue duration
     - Overdue trend (increasing/decreasing)
   - Verify statistics accuracy:
     - Statistics are accurate
     - Statistics update in real-time
     - Statistics are filtered by workspace

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Overdue statistics are displayed
- ✅ Statistics are accurate

---

## Test Case 11: Overdue Notification for Multiple Tasks - Missing Feature

**Objective**: Verify notification is sent when multiple tasks are overdue (currently missing).

**Preconditions**:
- User is logged in
- Multiple overdue tasks exist
- Bulk notification is implemented

**Steps**:
1. Create multiple overdue tasks:
   - Task 1: Overdue by 1 day
   - Task 2: Overdue by 2 days
   - Task 3: Overdue by 3 days
2. Wait for notification
3. Verify one of the following:
   - **If NOT implemented**: No bulk notification (this is expected - feature missing)
   - **If implemented**: Bulk notification is sent
4. If implemented:
   - Verify bulk notification:
     - Notification mentions multiple overdue tasks
     - Notification shows count: "You have 3 overdue tasks"
     - Notification lists tasks or provides link to view all
   - Verify notification format:
     - Notification is clear and not overwhelming
     - User can see all overdue tasks

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Bulk overdue notifications are sent
- ✅ Notification format is clear

---

## Test Case 12: Overdue Notification Cancellation - Missing Feature

**Objective**: Verify overdue notifications are cancelled when task is completed (currently missing).

**Preconditions**:
- User is logged in
- Overdue task exists
- Notification cancellation is implemented

**Steps**:
1. Create an overdue task
2. Verify notification is scheduled/sent
3. Complete the task
4. Verify one of the following:
   - **If NOT implemented**: Notifications may continue (this is expected - cancellation missing)
   - **If implemented**: Notifications are cancelled
5. If implemented:
   - Verify cancellation:
     - Scheduled notifications are cancelled
     - No further notifications are sent
   - Verify other status changes:
     - Notifications are cancelled when task is cancelled
     - Notifications are cancelled when deadline is removed

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Notifications are cancelled appropriately
- ✅ No unnecessary notifications

---

## Test Case 13: Workspace-Scoped Overdue Detection - Missing Feature

**Objective**: Verify overdue detection is scoped to current workspace (currently missing).

**Preconditions**:
- User is logged in
- User has access to multiple workspaces
- Overdue tasks exist in different workspaces
- Workspace scoping is implemented

**Steps**:
1. Switch to Workspace A
2. Create overdue task in Workspace A
3. Switch to Workspace B
4. Verify one of the following:
   - **If NOT implemented**: Overdue detection may not be workspace-scoped (this is expected - scoping missing)
   - **If implemented**: Overdue detection is workspace-scoped
5. If implemented:
   - Verify workspace scoping:
     - Only overdue tasks in current workspace are detected
     - Notifications are sent only for current workspace tasks
     - Switching workspace updates overdue list
   - Verify workspace isolation:
     - Overdue tasks in other workspaces are not shown
     - Notifications are not sent for other workspaces

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Overdue detection is workspace-scoped
- ✅ Workspace isolation works correctly

---

## Test Case 14: Overdue Notification Payload and Navigation - Missing Feature

**Objective**: Verify notification payload allows navigation to overdue task (currently missing).

**Preconditions**:
- User is logged in
- Overdue task exists
- Notification navigation is implemented

**Steps**:
1. Receive overdue notification
2. Tap on notification
3. Verify one of the following:
   - **If NOT implemented**: Navigation does not work (this is expected - feature missing)
   - **If implemented**: Navigation works
4. If implemented:
   - Verify navigation:
     - App opens (if closed)
     - Navigates to task detail page
     - Or navigates to task list filtered by overdue
   - Verify payload:
     - Payload contains task ID
     - Payload contains workspace ID
     - Payload is parsed correctly

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Notification navigation works
- ✅ User can quickly access overdue task

---

## Test Case 15: Overdue Task List Widget - Missing Feature

**Objective**: Verify overdue tasks are listed in a dedicated widget/page (currently missing).

**Preconditions**:
- User is logged in
- Overdue tasks exist
- Overdue list widget is implemented

**Steps**:
1. Navigate to Dashboard or Task List page
2. Verify one of the following:
   - **If NOT implemented**: No overdue list widget (this is expected - feature missing)
   - **If implemented**: Overdue list widget exists
3. If implemented:
   - Verify widget display:
     - Widget shows list of overdue tasks
     - Tasks are sorted by overdue duration (most overdue first)
     - Each task shows overdue duration
   - Verify widget interactions:
     - Can tap task to view details
     - Can mark task as completed from widget
     - Can update task deadline from widget
   - Verify widget updates:
     - Widget updates when tasks are completed
     - Widget updates when new tasks become overdue

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Overdue list widget exists
- ✅ Widget is functional and accurate

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Automatic overdue detection works (missing)
- [ ] Overdue notifications are sent (missing)
- [ ] Approaching deadline notifications are sent (missing)
- [ ] Critical overdue notifications are sent (missing)
- [ ] SLA timer service runs periodically (missing)
- [ ] Overdue indicator is shown in UI (missing)
- [ ] Overdue filter works (missing)
- [ ] SLA settings can be configured (missing)
- [ ] Notification frequency is controlled (missing)
- [ ] Overdue statistics are displayed (missing)
- [ ] Bulk overdue notifications work (missing)
- [ ] Notifications are cancelled when task is completed (missing)
- [ ] Overdue detection is workspace-scoped (missing)
- [ ] Notification navigation works (missing)
- [ ] Overdue list widget exists (missing)

---

## Known Issues (Based on Audit Report)

1. **Feature Not Implemented**:
   - No SLA timer service
   - No automatic overdue detection
   - No overdue notifications
   - No approaching deadline notifications
   - No critical overdue notifications
   - **Status**: ⛔ Missing

2. **Partial Implementation**:
   - `NotificationService` has `showTaskDeadline` method but may not be used
   - `NotificationManagerService` has TODO comments for task reminders
   - `notification_settings_page.dart` has deadline alerts toggle but may not be functional
   - Task cards show overdue indicator but may not be accurate

---

## Notes for Testers

1. **Current Status**: SLA overdue notifications are completely missing:
   - No SLA timer service
   - No automatic overdue detection
   - No overdue notifications
   - No approaching deadline notifications

2. **Existing Components**: Some components exist but may not be fully functional:
   - `NotificationService.showTaskDeadline()` exists but may not be called
   - `NotificationManagerService` has TODO comments
   - Settings page has deadline alerts toggle but may not work

3. **Design Considerations**: When implementing, consider:
   - SLA timer service that runs periodically
   - Automatic overdue detection
   - Configurable notification thresholds
   - Notification frequency control
   - Workspace-scoped detection
   - Visual indicators in UI
   - Statistics and reporting

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
- Whether SLA timer exists
- Whether overdue detection works
- Whether notifications are sent
- Whether settings are configurable

