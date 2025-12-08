# Backup Automation: Scheduled Backup, Failure Notifications, Storage Quota - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Backup Automation** feature. Currently, this feature is **MISSING** - Not implemented. Backup automation should include: scheduled backup (lịch backup tự động), failure notifications (thông báo khi thất bại), and storage quota checking (kiểm tra giới hạn dung lượng).

## Prerequisites
- User must be logged in
- User must have Account Holder or Admin role
- Workspace must exist
- Backup feature should be implemented (or test cases should document expected behavior)
- OneDrive authentication should be configured
- Notification service should be configured (for failure notifications)
- Storage quota service should be available (for quota checking)

---

## Test Case 1: Scheduled Backup - Automatic Backup Execution

**Objective**: Verify that scheduled backup runs automatically according to configured schedule.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Scheduled backup is enabled
- Backup schedule is configured (e.g., daily at 2:00 AM)
- Workspace has data to backup
- Scheduled backup feature is implemented
- User is on the backup settings screen

**Steps**:
1. Navigate to backup settings screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup Settings" option
   - Verify backup settings screen is displayed

2. Configure scheduled backup:
   - **If NOT implemented**: Scheduled backup is not available (this is expected - feature missing)
   - **If implemented**: 
     - Tap on "Scheduled Backup" or "Automatic Backup" option
     - Verify scheduled backup settings are displayed:
       - Enable/disable scheduled backup toggle
       - Backup frequency (daily, weekly, monthly)
       - Backup time (hour, minute)
       - Backup destination (OneDrive, Firebase Storage)
     - Enable scheduled backup:
       - Toggle "Enable Scheduled Backup" to ON
       - Set frequency to "Daily"
       - Set time to "2:00 AM" (or current time + 5 minutes for testing)
       - Select backup destination
       - Tap "Save" or "Apply"

3. Verify scheduled backup is configured:
   - Verify settings are saved:
     - Scheduled backup is enabled
     - Schedule settings are displayed correctly
     - Next backup time is shown (if available)
   - Verify scheduled backup is active:
     - Status shows "Active" or "Enabled"
     - Next backup time is displayed

4. Wait for scheduled backup to run (or trigger manually for testing):
   - Wait until scheduled time (or use "Run Now" button if available)
   - Verify backup process starts automatically:
     - Backup process begins without user intervention
     - Progress indicator appears (if available)
     - Backup completes successfully

5. Verify backup was created:
   - Navigate to backup list screen
   - Verify new backup file is created:
     - Backup file with current date/time is present
     - Backup file contains workspace data
     - Backup file is uploaded to selected destination

6. Verify scheduled backup continues:
   - Check next scheduled backup time
   - Verify next backup is scheduled correctly
   - Verify scheduled backup continues to run automatically

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Scheduled backup is NOT implemented (missing)
- ✅ **When implemented**: Scheduled backup runs automatically
- ✅ Backup schedule can be configured
- ✅ Backup runs at scheduled time
- ✅ Backup continues to run automatically
- ✅ Backup files are created successfully

---

## Test Case 2: Scheduled Backup - Backup Schedule Configuration

**Objective**: Verify that backup schedule can be configured with different frequencies and times.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Scheduled backup feature is implemented
- User is on the backup settings screen

**Steps**:
1. Navigate to backup settings screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup Settings" option
   - Verify backup settings screen is displayed

2. Configure daily backup:
   - **If NOT implemented**: Schedule configuration is not available (this is expected - feature missing)
   - **If implemented**: 
     - Tap on "Scheduled Backup" option
     - Enable scheduled backup
     - Set frequency to "Daily"
     - Set time to "3:00 AM"
     - Save settings
     - Verify daily backup is configured:
       - Frequency shows "Daily"
       - Time shows "3:00 AM"
       - Next backup time is calculated correctly

3. Configure weekly backup:
   - Change frequency to "Weekly"
     - Set day of week (e.g., Monday)
     - Set time to "4:00 AM"
     - Save settings
     - Verify weekly backup is configured:
       - Frequency shows "Weekly"
       - Day shows "Monday"
       - Time shows "4:00 AM"
       - Next backup time is calculated correctly

4. Configure monthly backup:
   - Change frequency to "Monthly"
     - Set day of month (e.g., 1st)
     - Set time to "5:00 AM"
     - Save settings
     - Verify monthly backup is configured:
       - Frequency shows "Monthly"
       - Day shows "1st"
       - Time shows "5:00 AM"
       - Next backup time is calculated correctly

5. Verify schedule validation:
   - Try to set invalid time (e.g., 25:00)
     - Verify error message is shown
     - Verify invalid time is rejected
   - Try to set invalid day (e.g., 32nd for monthly)
     - Verify error message is shown
     - Verify invalid day is rejected

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Backup schedule configuration is NOT implemented (missing)
- ✅ **When implemented**: Backup schedule can be configured
- ✅ Different frequencies are supported (daily, weekly, monthly)
- ✅ Time can be configured
- ✅ Schedule validation works correctly
- ✅ Settings are saved and applied

---

## Test Case 3: Failure Notification - Backup Failure Triggers Notification

**Objective**: Verify that backup failure triggers notification to user.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Notification service is configured
- Failure notification feature is implemented
- Simulate backup failure scenario (e.g., network error, OneDrive error)

**Steps**:
1. Configure failure notification:
   - **If NOT implemented**: Failure notification is not available (this is expected - feature missing)
   - **If implemented**: 
     - Navigate to backup settings
     - Verify "Failure Notifications" option is available
     - Enable failure notifications:
       - Toggle "Notify on Backup Failure" to ON
       - Select notification method (in-app, push, email)
       - Save settings

2. Trigger backup failure:
   - Attempt to create backup with failure scenario:
     - Disconnect network before backup
     - OR Use invalid OneDrive credentials
     - OR Simulate OneDrive service error
   - Verify backup fails:
     - Error message is displayed
     - Backup process stops

3. Verify failure notification is sent:
   - Check notification service:
     - In-app notification appears (if enabled)
     - Push notification is sent (if enabled)
     - Email notification is sent (if enabled)
   - Verify notification content:
     - Title: "Backup Failed" or similar
     - Message: Contains error description
     - Timestamp: Shows when backup failed
     - Action: Option to retry backup (if available)

4. Verify notification is received:
   - Check notification center or inbox
   - Verify failure notification is present
   - Verify notification can be opened
   - Verify notification shows correct information

5. Test notification for different failure types:
   - Network error:
     - Verify notification mentions network issue
   - OneDrive error:
     - Verify notification mentions OneDrive issue
   - Permission error:
     - Verify notification mentions permission issue
   - Storage quota error:
     - Verify notification mentions storage quota issue

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Failure notification is NOT implemented (missing)
- ✅ **When implemented**: Backup failure triggers notification
- ✅ Notification is sent via configured method
- ✅ Notification contains error information
- ✅ Notification is received and can be viewed
- ✅ Different failure types trigger appropriate notifications

---

## Test Case 4: Failure Notification - Multiple Failure Notifications

**Objective**: Verify that multiple backup failures trigger appropriate notifications without spam.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Scheduled backup is enabled
- Failure notification feature is implemented
- Multiple backup failures occur (e.g., scheduled backups fail)

**Steps**:
1. Configure scheduled backup with failures:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Enable scheduled backup
     - Configure to run frequently (e.g., every hour) for testing
     - Enable failure notifications
     - Simulate backup failures (e.g., disconnect network)

2. Wait for multiple backup failures:
   - Wait for scheduled backups to fail (or trigger manually)
   - Verify multiple backup attempts fail
   - Note the number of failures

3. Verify notification handling:
   - **If NOT implemented**: Notifications are not sent (this is expected - feature missing)
   - **If implemented**: 
     - Check notification center
     - Verify notifications are sent for failures:
       - Each failure may trigger a notification
       - OR Notifications are batched/grouped
       - OR Rate limiting prevents spam
     - Verify notification content:
       - Notifications show failure information
       - Notifications may be grouped if multiple failures occur

4. Verify notification rate limiting (if implemented):
   - Check if notifications are rate-limited:
     - Not more than X notifications per hour
     - OR Notifications are batched
     - OR Only critical failures trigger notifications
   - Verify rate limiting works correctly:
     - Notifications are not spammed
     - Important failures are still notified

5. Verify notification summary (if implemented):
   - Check if summary notification is sent:
     - Summary shows total failures
     - Summary shows failure time range
     - Summary provides overview of issues

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Multiple failure notifications are NOT implemented (missing)
- ✅ **When implemented**: Multiple failures trigger appropriate notifications
- ✅ Notifications are not spammed
- ✅ Rate limiting works (if implemented)
- ✅ Notification summary is provided (if implemented)

---

## Test Case 5: Storage Quota Checking - Quota Check Before Backup

**Objective**: Verify that storage quota is checked before backup to prevent quota exceeded errors.

**Preconditions**:
- User is logged in as Account Holder or Admin
- OneDrive storage quota is available (or can be checked)
- Storage quota checking feature is implemented
- Storage quota is approaching limit (e.g., 85% used)
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Check current storage quota:
   - **If NOT implemented**: Quota checking is not available (this is expected - feature missing)
   - **If implemented**: 
     - View storage quota information (if displayed):
       - Total storage: e.g., 5 GB
       - Used storage: e.g., 4.25 GB (85%)
       - Remaining storage: e.g., 750 MB (15%)
     - Note current quota status

3. Attempt to create backup:
   - Tap on "Create Backup" or "Backup Now" button
   - Verify quota check is performed:
     - System checks storage quota before backup
     - Quota check completes

4. Verify quota check results:
   - **If quota is sufficient**:
     - Quota check passes
     - Backup process continues
     - Backup completes successfully
   - **If quota is insufficient**:
     - Quota check fails
     - Error message is displayed: "Storage quota exceeded" or similar
     - Backup process is prevented
     - User is informed about quota status

5. Verify quota warning (if approaching limit):
   - If quota is between 80-95%:
     - Warning message is displayed: "Storage quota is at X%. Backup may fail soon."
     - User can still proceed with backup
     - OR User is warned but backup continues

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Storage quota checking is NOT implemented (missing)
- ✅ **When implemented**: Storage quota is checked before backup
- ✅ Backup is prevented if quota is exceeded
- ✅ Warning is shown if quota is approaching limit
- ✅ Quota information is displayed (if available)

---

## Test Case 6: Storage Quota Checking - Quota Display and Monitoring

**Objective**: Verify that storage quota is displayed and monitored in backup settings.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Storage quota checking feature is implemented
- User is on the backup settings screen

**Steps**:
1. Navigate to backup settings screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup Settings" option
   - Verify backup settings screen is displayed

2. View storage quota information:
   - **If NOT implemented**: Quota display is not available (this is expected - feature missing)
   - **If implemented**: 
     - Locate "Storage Quota" or "Storage Usage" section
     - Verify quota information is displayed:
       - Total storage: e.g., "5.0 GB"
       - Used storage: e.g., "4.25 GB"
       - Remaining storage: e.g., "750 MB"
       - Usage percentage: e.g., "85%"
     - Verify quota visualization:
       - Progress bar showing usage percentage
       - Color coding (green/yellow/red based on usage)
       - Usage breakdown (if available)

3. Verify quota updates:
   - Create a backup
   - Verify quota information updates:
     - Used storage increases
     - Remaining storage decreases
     - Usage percentage updates
   - Delete a backup
   - Verify quota information updates:
     - Used storage decreases
     - Remaining storage increases
     - Usage percentage updates

4. Verify quota warnings:
   - Check if quota warnings are displayed:
     - Warning at 80%: "Storage quota is at 80%"
     - Critical warning at 95%: "Storage quota is at 95% - Backup may fail"
   - Verify warning actions:
     - Option to free up space
     - Option to upgrade storage (if available)
     - Option to delete old backups

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Storage quota display is NOT implemented (missing)
- ✅ **When implemented**: Storage quota is displayed
- ✅ Quota information is accurate
- ✅ Quota updates in real-time
- ✅ Quota warnings are shown at appropriate thresholds

---

## Test Case 7: Storage Quota Checking - Quota Exceeded Prevention

**Objective**: Verify that backup is prevented when storage quota is exceeded.

**Preconditions**:
- User is logged in as Account Holder or Admin
- OneDrive storage quota is at or near limit (e.g., 98% used)
- Storage quota checking feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Check storage quota status:
   - **If NOT implemented**: Quota checking is not available (this is expected - feature missing)
   - **If implemented**: 
     - View storage quota information
     - Verify quota is at or near limit:
       - Usage: 98% or higher
       - Remaining: Very low (e.g., 100 MB)

3. Attempt to create backup:
   - Tap on "Create Backup" or "Backup Now" button
   - Verify quota check is performed:
     - System checks storage quota
     - Quota check detects quota is exceeded or near limit

4. Verify backup is prevented:
   - **If quota is exceeded (100% or higher)**:
     - Backup is prevented
     - Error message is displayed: "Storage quota exceeded. Please free up space before creating backup."
     - Backup process does not start
   - **If quota is critical (95-99%)**:
     - Warning is displayed: "Storage quota is at X%. Backup may fail."
     - User can choose to proceed or cancel
     - If user proceeds, backup may fail or succeed depending on actual quota

5. Verify error message actions:
   - Check if error message provides actions:
     - "Free Up Space" button (opens cleanup screen)
     - "Delete Old Backups" button (opens backup management)
     - "Upgrade Storage" button (if available)
   - Verify actions work correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Quota exceeded prevention is NOT implemented (missing)
- ✅ **When implemented**: Backup is prevented when quota is exceeded
- ✅ Error message is clear and actionable
- ✅ User is provided with options to free up space
- ✅ Backup process does not start if quota is exceeded

---

## Test Case 8: Failure Notification - Notification Preferences

**Objective**: Verify that users can configure failure notification preferences.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Failure notification feature is implemented
- User is on the backup settings screen

**Steps**:
1. Navigate to backup settings screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup Settings" option
   - Verify backup settings screen is displayed

2. Configure notification preferences:
   - **If NOT implemented**: Notification preferences are not available (this is expected - feature missing)
   - **If implemented**: 
     - Locate "Failure Notifications" or "Notification Settings" section
     - Verify notification options are available:
       - Enable/disable failure notifications
       - Notification methods: In-app, Push, Email
       - Notification frequency: Immediate, Daily summary, Weekly summary
       - Notification severity: All failures, Critical only
     - Configure notification preferences:
       - Enable failure notifications
       - Select notification methods (e.g., In-app + Push)
       - Set frequency to "Immediate"
       - Save settings

3. Verify preferences are saved:
   - Navigate away from settings screen
   - Navigate back to settings screen
   - Verify notification preferences are saved:
     - Settings match what was configured
     - Preferences persist across app restarts

4. Test notification with preferences:
   - Trigger a backup failure
   - Verify notifications are sent according to preferences:
     - In-app notification appears (if enabled)
     - Push notification is sent (if enabled)
     - Email notification is sent (if enabled)
   - Verify notification frequency is respected:
     - Immediate notifications are sent immediately
     - Summary notifications are sent at scheduled time

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Notification preferences are NOT implemented (missing)
- ✅ **When implemented**: Users can configure notification preferences
- ✅ Preferences are saved and applied
- ✅ Notifications are sent according to preferences
- ✅ Preferences persist across app restarts

---

## Test Case 9: Scheduled Backup - Backup Schedule Persistence

**Objective**: Verify that backup schedule persists across app restarts and device reboots.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Scheduled backup is configured
- Scheduled backup feature is implemented
- App is running

**Steps**:
1. Configure scheduled backup:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Enable scheduled backup
     - Set frequency to "Daily"
     - Set time to "2:00 AM"
     - Save settings
     - Verify schedule is configured

2. Restart app:
   - Close app completely
   - Reopen app
   - Log in again
   - Navigate to backup settings

3. Verify schedule persists:
   - **If NOT implemented**: Schedule is not persisted (this is expected - feature missing)
   - **If implemented**: 
     - Check scheduled backup settings
     - Verify schedule is still configured:
       - Scheduled backup is still enabled
       - Frequency is still "Daily"
       - Time is still "2:00 AM"
       - Next backup time is calculated correctly

4. Restart device:
   - Restart device (if possible)
   - Reopen app
   - Log in again
   - Navigate to backup settings

5. Verify schedule persists after device restart:
   - Check scheduled backup settings
   - Verify schedule is still configured:
     - Scheduled backup is still enabled
     - Schedule settings are preserved
     - Scheduled backup continues to work

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Backup schedule persistence is NOT implemented (missing)
- ✅ **When implemented**: Backup schedule persists across app restarts
- ✅ Backup schedule persists across device reboots
- ✅ Scheduled backup continues to work after restart
- ✅ Schedule settings are preserved

---

## Test Case 10: Storage Quota Checking - Quota Check for Scheduled Backup

**Objective**: Verify that storage quota is checked before scheduled backup runs.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Scheduled backup is enabled and configured
- Storage quota checking feature is implemented
- Storage quota is at or near limit
- Scheduled backup time is approaching

**Steps**:
1. Configure scheduled backup:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Enable scheduled backup
     - Set frequency to "Daily"
     - Set time to current time + 5 minutes (for testing)
     - Save settings

2. Set storage quota to near limit:
   - Manually set quota to 98% used (if possible)
   - OR Wait for quota to reach near limit naturally
   - Verify quota status is near limit

3. Wait for scheduled backup to run:
   - Wait until scheduled backup time
   - OR Trigger scheduled backup manually (if available)
   - Verify scheduled backup process starts

4. Verify quota check during scheduled backup:
   - **If NOT implemented**: Quota check is not performed (this is expected - feature missing)
   - **If implemented**: 
     - Verify quota check is performed:
       - System checks storage quota before backup
       - Quota check completes
     - Verify backup behavior based on quota:
       - **If quota is sufficient**:
         - Backup proceeds
         - Backup completes successfully
       - **If quota is insufficient**:
         - Backup is skipped
         - Failure notification is sent (if enabled)
         - Log entry is created (if logging is enabled)

5. Verify failure notification for quota exceeded:
   - Check notification center
   - Verify notification is sent (if quota was exceeded):
     - Title: "Scheduled Backup Failed" or similar
     - Message: "Storage quota exceeded. Backup was skipped."
     - Timestamp: Shows when backup was scheduled
     - Action: Option to free up space or retry

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Quota check for scheduled backup is NOT implemented (missing)
- ✅ **When implemented**: Storage quota is checked before scheduled backup
- ✅ Scheduled backup is skipped if quota is exceeded
- ✅ Failure notification is sent if scheduled backup fails due to quota
- ✅ Log entry is created for skipped backup

---

## Summary

### Current Status: ⛔ MISSING
All backup automation features are currently **NOT IMPLEMENTED**. No scheduled backup automation, failure notifications, or storage quota checking exists.

### What Needs to Be Implemented:
1. ✅ Scheduled backup automation (daily, weekly, monthly)
2. ✅ Backup schedule configuration UI
3. ✅ Backup schedule persistence
4. ✅ Failure notification system
5. ✅ Failure notification preferences
6. ✅ Storage quota checking before backup
7. ✅ Storage quota display and monitoring
8. ✅ Quota exceeded prevention
9. ✅ Quota check for scheduled backup
10. ✅ Notification for quota-related failures

### Test Execution Notes:
- All test cases should be executed after implementation
- Test cases marked as "Missing Feature" should be updated once implemented
- Focus on automation, notifications, and quota management
- Test with various scenarios (scheduled backup, failures, quota limits)
- Verify notifications are sent correctly
- Verify quota checks work correctly

### Security and Reliability Considerations:
- **Critical**: Scheduled backup must respect user permissions
- Failure notifications must be sent reliably
- Storage quota checks must be accurate
- Quota exceeded prevention must work correctly
- Automation should not break if services are unavailable
