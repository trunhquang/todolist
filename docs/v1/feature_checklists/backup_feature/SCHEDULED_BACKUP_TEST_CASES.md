# Scheduled Backup to OneDrive/Firebase Storage for Account Holder/Admin - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Scheduled Backup to OneDrive/Firebase Storage for Account Holder/Admin** feature. Currently, this feature is **MISSING** - Not implemented; no backup scheduler/service or role guard.

## Prerequisites
- User must be logged in
- Workspace should exist
- Tasks/projects should exist
- OneDrive authentication should be configured (for OneDrive backup)
- Firebase Storage should be configured (for Firebase Storage backup)
- User should have Account Holder or Admin role (for backup access)

---

## Test Case 1: Scheduled Backup Role Guard - Account Holder Access - Missing Feature

**Objective**: Verify only Account Holder can access scheduled backup functionality (currently missing).

**Preconditions**:
- User is logged in as Account Holder
- Scheduled backup feature is implemented
- Role guard is implemented

**Steps**:
1. Navigate to workspace settings or backup settings
2. Verify one of the following:
   - **If NOT implemented**: Scheduled backup option is not visible (this is expected - feature missing)
   - **If implemented**: Scheduled backup option is visible
3. If implemented:
   - Verify Account Holder access:
     - Scheduled backup settings are visible
     - Scheduled backup can be enabled/disabled
     - Backup schedule can be configured
     - Backup destination (OneDrive/Firebase Storage) can be selected
   - Verify backup functionality:
     - Manual backup can be triggered
     - Scheduled backup can be started
     - Backup status is visible

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Role guard is NOT implemented (missing)
- ✅ **When implemented**: Account Holder can access scheduled backup
- ✅ Scheduled backup settings are visible
- ✅ Backup functionality works for Account Holder

---

## Test Case 2: Scheduled Backup Role Guard - Admin Access - Missing Feature

**Objective**: Verify Admin can access scheduled backup functionality (currently missing).

**Preconditions**:
- User is logged in as Admin
- Scheduled backup feature is implemented
- Role guard is implemented

**Steps**:
1. Navigate to workspace settings or backup settings
2. Verify one of the following:
   - **If NOT implemented**: Scheduled backup option is not visible (this is expected - feature missing)
   - **If implemented**: Scheduled backup option is visible
3. If implemented:
   - Verify Admin access:
     - Scheduled backup settings are visible
     - Scheduled backup can be enabled/disabled
     - Backup schedule can be configured
     - Backup destination (OneDrive/Firebase Storage) can be selected
   - Verify backup functionality:
     - Manual backup can be triggered
     - Scheduled backup can be started
     - Backup status is visible

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Role guard is NOT implemented (missing)
- ✅ **When implemented**: Admin can access scheduled backup
- ✅ Scheduled backup settings are visible
- ✅ Backup functionality works for Admin

---

## Test Case 3: Scheduled Backup Role Guard - Member Access Denied - Missing Feature

**Objective**: Verify Member cannot access scheduled backup functionality (currently missing).

**Preconditions**:
- User is logged in as Member (not Account Holder/Admin)
- Scheduled backup feature is implemented
- Role guard is implemented

**Steps**:
1. Navigate to workspace settings or backup settings
2. Verify one of the following:
   - **If NOT implemented**: Scheduled backup option is not visible (this is expected - feature missing)
   - **If implemented**: Scheduled backup option is NOT visible
3. If implemented:
   - Verify Member access denial:
     - Scheduled backup settings are NOT visible
     - OR Scheduled backup settings are visible but disabled
     - OR Error message appears when trying to access
   - Try to access backup settings:
     - Navigate to backup settings page
     - Verify error message: "Permission denied" or "Only Account Holder/Admin can access backup settings"
   - Try to trigger manual backup:
     - If backup button is visible, tap it
     - Verify error message: "Permission denied" or "Only Account Holder/Admin can backup workspace"
   - Verify permission enforcement:
     - Permission is checked before showing backup options
     - Permission is checked before allowing backup
     - Unauthorized users cannot access backup

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Role guard is NOT implemented (missing)
- ✅ **When implemented**: Member cannot access scheduled backup
- ✅ Permission is enforced correctly
- ✅ Appropriate error messages are shown

---

## Test Case 4: Enable Scheduled Backup to OneDrive - Missing Feature

**Objective**: Verify scheduled backup to OneDrive can be enabled (currently missing).

**Preconditions**:
- User is logged in as Account Holder/Admin
- OneDrive authentication is configured
- Scheduled backup feature is implemented

**Steps**:
1. Navigate to backup settings
2. Verify one of the following:
   - **If NOT implemented**: Scheduled backup option is not available (this is expected - feature missing)
   - **If implemented**: Scheduled backup option is available
3. If implemented:
   - Configure scheduled backup:
     - Enable "Scheduled Backup" toggle
     - Select backup destination: "OneDrive"
     - Configure backup schedule:
       - Frequency: Daily, Weekly, or Custom
       - Time: Select backup time
       - Day of week: If weekly, select day
     - Save settings
   - Verify backup configuration:
     - Settings are saved
     - Backup schedule is displayed
     - Next backup time is shown
   - Verify OneDrive authentication:
     - If not authenticated, authentication prompt appears
     - After authentication, OneDrive is connected
   - Wait for scheduled backup time (or trigger manually)
   - Verify backup execution:
     - Backup process starts
     - Progress indicator is shown
     - Backup completes successfully
     - Backup file is created in OneDrive

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Scheduled backup is NOT implemented (missing)
- ✅ **When implemented**: Scheduled backup to OneDrive can be enabled
- ✅ Backup schedule is configured correctly
- ✅ Backup executes at scheduled time

---

## Test Case 5: Enable Scheduled Backup to Firebase Storage - Missing Feature

**Objective**: Verify scheduled backup to Firebase Storage can be enabled (currently missing).

**Preconditions**:
- User is logged in as Account Holder/Admin
- Firebase Storage is configured
- Scheduled backup feature is implemented

**Steps**:
1. Navigate to backup settings
2. Verify one of the following:
   - **If NOT implemented**: Scheduled backup option is not available (this is expected - feature missing)
   - **If implemented**: Scheduled backup option is available
3. If implemented:
   - Configure scheduled backup:
     - Enable "Scheduled Backup" toggle
     - Select backup destination: "Firebase Storage"
     - Configure backup schedule:
       - Frequency: Daily, Weekly, or Custom
       - Time: Select backup time
       - Day of week: If weekly, select day
     - Save settings
   - Verify backup configuration:
     - Settings are saved
     - Backup schedule is displayed
     - Next backup time is shown
   - Wait for scheduled backup time (or trigger manually)
   - Verify backup execution:
     - Backup process starts
     - Progress indicator is shown
     - Backup completes successfully
     - Backup file is created in Firebase Storage

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Scheduled backup is NOT implemented (missing)
- ✅ **When implemented**: Scheduled backup to Firebase Storage can be enabled
- ✅ Backup schedule is configured correctly
- ✅ Backup executes at scheduled time

---

## Test Case 6: Scheduled Backup Execution - Daily Frequency - Missing Feature

**Objective**: Verify scheduled backup executes daily at configured time (currently missing).

**Preconditions**:
- User is logged in as Account Holder/Admin
- Scheduled backup is enabled
- Backup destination is configured (OneDrive or Firebase Storage)
- Backup schedule is set to "Daily"
- Backup time is configured

**Steps**:
1. Configure daily backup:
   - Set frequency to "Daily"
   - Set backup time (e.g., 2:00 AM)
   - Save settings
2. Verify one of the following:
   - **If NOT implemented**: Scheduled backup doesn't execute (this is expected - feature missing)
   - **If implemented**: Scheduled backup executes
3. If implemented:
   - Wait for backup time (or manually trigger for testing)
   - Verify backup execution:
     - Backup process starts automatically
     - Progress indicator is shown
     - Backup completes successfully
   - Verify backup file:
     - File is created in selected destination
     - File contains workspace data
     - File timestamp matches backup time
   - Verify next backup schedule:
     - Next backup time is calculated correctly
     - Next backup is scheduled for next day at same time
   - Wait for next day (or manually advance time for testing)
   - Verify backup executes again:
     - Backup executes at scheduled time
     - New backup file is created

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Daily backup is NOT implemented (missing)
- ✅ **When implemented**: Daily backup executes correctly
- ✅ Backup executes at scheduled time
- ✅ Next backup is scheduled correctly

---

## Test Case 7: Scheduled Backup Execution - Weekly Frequency - Missing Feature

**Objective**: Verify scheduled backup executes weekly at configured time (currently missing).

**Preconditions**:
- User is logged in as Account Holder/Admin
- Scheduled backup is enabled
- Backup destination is configured
- Backup schedule is set to "Weekly"
- Backup day and time are configured

**Steps**:
1. Configure weekly backup:
   - Set frequency to "Weekly"
   - Set backup day (e.g., Monday)
   - Set backup time (e.g., 2:00 AM)
   - Save settings
2. Verify one of the following:
   - **If NOT implemented**: Scheduled backup doesn't execute (this is expected - feature missing)
   - **If implemented**: Scheduled backup executes
3. If implemented:
   - Wait for backup day and time (or manually trigger for testing)
   - Verify backup execution:
     - Backup process starts automatically
     - Progress indicator is shown
     - Backup completes successfully
   - Verify backup file:
     - File is created in selected destination
     - File contains workspace data
   - Verify next backup schedule:
     - Next backup time is calculated correctly
     - Next backup is scheduled for next week on same day at same time
   - Wait for next week (or manually advance time for testing)
   - Verify backup executes again:
     - Backup executes at scheduled day and time
     - New backup file is created

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Weekly backup is NOT implemented (missing)
- ✅ **When implemented**: Weekly backup executes correctly
- ✅ Backup executes at scheduled day and time
- ✅ Next backup is scheduled correctly

---

## Test Case 8: Scheduled Backup Failure Notification - Missing Feature

**Objective**: Verify notification is sent when scheduled backup fails (currently missing).

**Preconditions**:
- User is logged in as Account Holder/Admin
- Scheduled backup is enabled
- Backup destination is configured
- Notification system is implemented

**Steps**:
1. Configure scheduled backup
2. Simulate backup failure:
   - Disconnect internet
   - OR Revoke OneDrive/Firebase Storage access
   - OR Fill storage quota
3. Wait for scheduled backup time (or trigger manually)
4. Verify one of the following:
   - **If NOT implemented**: Failure notification is not sent (this is expected - feature missing)
   - **If implemented**: Failure notification is sent
5. If implemented:
   - Verify backup failure:
     - Backup process starts
     - Backup fails (due to simulated error)
     - Error is logged
   - Verify notification:
     - Notification is sent to Account Holder/Admin
     - Notification contains error details:
       - Backup failed message
       - Error reason
       - Timestamp
       - Suggested actions
   - Verify notification delivery:
     - In-app notification is shown
     - Push notification is sent (if configured)
     - Email notification is sent (if configured)
   - Verify retry mechanism:
     - Retry option is available
     - Retry works after error is resolved

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Failure notification is NOT implemented (missing)
- ✅ **When implemented**: Failure notification is sent
- ✅ Notification contains error details
- ✅ Multiple notification channels are supported

---

## Test Case 9: Scheduled Backup Storage Quota Check - Missing Feature

**Objective**: Verify storage quota is checked before backup (currently missing).

**Preconditions**:
- User is logged in as Account Holder/Admin
- Scheduled backup is enabled
- Backup destination is configured
- Storage quota checking is implemented

**Steps**:
1. Configure scheduled backup
2. Check current storage usage:
   - Navigate to backup settings
   - View storage usage:
     - Current usage
     - Storage limit
     - Usage percentage
3. Simulate storage quota exceeded:
   - Fill storage to capacity
   - OR Set storage limit to very low value
4. Trigger backup (manually or wait for scheduled time)
5. Verify one of the following:
   - **If NOT implemented**: Quota check is not performed (this is expected - feature missing)
   - **If implemented**: Quota check is performed
6. If implemented:
   - Verify quota check:
     - Storage quota is checked before backup
     - Quota status is displayed
   - Verify quota exceeded handling:
     - Backup is prevented if quota is exceeded
     - Warning message is shown:
       - "Storage quota exceeded"
       - "Please free up space or upgrade storage"
     - Notification is sent to Account Holder/Admin
   - Verify quota warning:
     - Warning is shown when approaching quota (e.g., 80% full)
     - Warning is shown before backup fails
   - Free up storage:
     - Delete old backups
     - OR Upgrade storage
   - Verify backup after freeing space:
     - Backup can proceed after quota is available
     - Backup completes successfully

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Storage quota check is NOT implemented (missing)
- ✅ **When implemented**: Storage quota is checked
- ✅ Backup is prevented when quota is exceeded
- ✅ Warnings are shown appropriately

---

## Test Case 10: Disable Scheduled Backup - Missing Feature

**Objective**: Verify scheduled backup can be disabled (currently missing).

**Preconditions**:
- User is logged in as Account Holder/Admin
- Scheduled backup is enabled
- Backup schedule is configured

**Steps**:
1. Navigate to backup settings
2. Verify scheduled backup is enabled:
   - Toggle is ON
   - Backup schedule is displayed
   - Next backup time is shown
3. Disable scheduled backup:
   - Toggle "Scheduled Backup" OFF
   - Save settings
4. Verify one of the following:
   - **If NOT implemented**: Scheduled backup cannot be disabled (this is expected - feature missing)
   - **If implemented**: Scheduled backup is disabled
5. If implemented:
   - Verify backup is disabled:
     - Toggle is OFF
     - Backup schedule is hidden or grayed out
     - Next backup time is not shown
   - Verify backup doesn't execute:
     - Wait for scheduled backup time
     - Verify backup does NOT execute
     - No backup file is created
   - Re-enable backup:
     - Toggle "Scheduled Backup" ON
     - Configure schedule
     - Save settings
   - Verify backup is re-enabled:
     - Backup schedule is active
     - Next backup time is shown
     - Backup will execute at scheduled time

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Disable backup is NOT implemented (missing)
- ✅ **When implemented**: Scheduled backup can be disabled
- ✅ Backup doesn't execute when disabled
- ✅ Backup can be re-enabled

---

## Test Case 11: Manual Backup Trigger - Missing Feature

**Objective**: Verify manual backup can be triggered (currently missing).

**Preconditions**:
- User is logged in as Account Holder/Admin
- Backup destination is configured
- Manual backup feature is implemented

**Steps**:
1. Navigate to backup settings
2. Verify one of the following:
   - **If NOT implemented**: Manual backup button is not available (this is expected - feature missing)
   - **If implemented**: Manual backup button is available
3. If implemented:
   - Trigger manual backup:
     - Tap "Backup Now" button
     - OR Select "Manual Backup" option
   - Verify backup process:
     - Backup process starts immediately
     - Progress indicator is shown
     - Progress updates during backup
   - Verify backup completion:
     - Backup completes successfully
     - Success message is shown
     - Backup file is created
   - Verify backup file:
     - File is created in selected destination
     - File contains workspace data
     - File timestamp matches backup time
   - Verify backup doesn't affect schedule:
     - Scheduled backup still executes at scheduled time
     - Manual backup doesn't reset schedule

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Manual backup is NOT implemented (missing)
- ✅ **When implemented**: Manual backup can be triggered
- ✅ Backup completes successfully
- ✅ Manual backup doesn't affect schedule

---

## Test Case 12: Backup Progress Indicator - Missing Feature

**Objective**: Verify backup progress is shown during backup (currently missing).

**Preconditions**:
- User is logged in as Account Holder/Admin
- Backup is triggered (manual or scheduled)
- Progress indicator is implemented

**Steps**:
1. Trigger backup (manual or wait for scheduled time)
2. Verify one of the following:
   - **If NOT implemented**: Progress indicator is not shown (this is expected - feature missing)
   - **If implemented**: Progress indicator is shown
3. If implemented:
   - Verify progress display:
     - Progress indicator appears immediately
     - Progress percentage is shown (if available)
     - Progress updates during backup
     - Current step is shown (e.g., "Backing up tasks...", "Backing up projects...")
   - Verify user experience:
     - User knows backup is in progress
     - User can see backup progress
     - Progress is accurate
   - Verify completion:
     - Progress indicator shows 100% on completion
     - Progress indicator disappears on completion
     - Success message is shown

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Progress indicator is NOT implemented (missing)
- ✅ **When implemented**: Progress indicator is shown
- ✅ Progress is accurate
- ✅ User experience is good

---

## Test Case 13: Backup File Verification - Missing Feature

**Objective**: Verify backup file is created correctly and can be verified (currently missing).

**Preconditions**:
- User is logged in as Account Holder/Admin
- Backup is completed
- File verification is implemented

**Steps**:
1. Trigger backup and wait for completion
2. Verify one of the following:
   - **If NOT implemented**: File verification is not available (this is expected - feature missing)
   - **If implemented**: File verification is available
3. If implemented:
   - Verify backup file exists:
     - File is created in selected destination
     - File name is correct (includes timestamp)
     - File size is reasonable
   - Verify backup file content:
     - File can be opened
     - File contains workspace data:
       - Tasks
       - Projects
       - Workspace settings
       - Members (if included)
     - Data is complete and correct
   - Verify backup metadata:
     - Backup timestamp
     - Workspace ID
     - Backup type
     - File checksum (if implemented)
   - Verify file integrity:
     - File is not corrupted
     - File can be restored
     - Checksum matches (if implemented)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: File verification is NOT implemented (missing)
- ✅ **When implemented**: Backup file is verified
- ✅ File content is correct
- ✅ File integrity is maintained

---

## Test Case 14: Backup Schedule Configuration - Custom Frequency - Missing Feature

**Objective**: Verify custom backup frequency can be configured (currently missing).

**Preconditions**:
- User is logged in as Account Holder/Admin
- Custom frequency option is implemented

**Steps**:
1. Navigate to backup settings
2. Verify one of the following:
   - **If NOT implemented**: Custom frequency option is not available (this is expected - feature missing)
   - **If implemented**: Custom frequency option is available
3. If implemented:
   - Configure custom frequency:
     - Select "Custom" frequency option
     - Configure custom schedule:
       - Interval: Every X hours/days/weeks
       - Time: Select backup time
       - Days: Select specific days (if applicable)
     - Save settings
   - Verify custom schedule:
     - Custom schedule is saved
     - Next backup time is calculated correctly
     - Schedule is displayed correctly
   - Wait for scheduled backup time (or trigger manually)
   - Verify backup executes:
     - Backup executes at configured custom time
     - Backup file is created
   - Verify next backup:
     - Next backup is scheduled according to custom frequency
     - Schedule is maintained correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Custom frequency is NOT implemented (missing)
- ✅ **When implemented**: Custom frequency can be configured
- ✅ Backup executes according to custom schedule
- ✅ Schedule is maintained correctly

---

## Test Case 15: Backup Multiple Workspaces - Missing Feature

**Objective**: Verify backup works correctly for multiple workspaces (currently missing).

**Preconditions**:
- User is logged in as Account Holder/Admin
- User is in multiple workspaces
- Backup is configured for each workspace

**Steps**:
1. Switch to Workspace A
2. Configure scheduled backup for Workspace A:
   - Enable scheduled backup
   - Configure schedule
   - Save settings
3. Switch to Workspace B
4. Configure scheduled backup for Workspace B:
   - Enable scheduled backup
   - Configure different schedule
   - Save settings
5. Verify one of the following:
   - **If NOT implemented**: Multi-workspace backup is not supported (this is expected - feature missing)
   - **If implemented**: Multi-workspace backup is supported
6. If implemented:
   - Verify workspace isolation:
     - Each workspace has independent backup settings
     - Backup settings are workspace-scoped
   - Verify backup execution:
     - Backup executes for each workspace independently
     - Backup files are workspace-specific
     - Backup schedules don't interfere with each other
   - Verify backup files:
     - Backup files are organized by workspace
     - Backup files contain only workspace-specific data
     - Backup files can be restored to correct workspace

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Multi-workspace backup is NOT implemented (missing)
- ✅ **When implemented**: Backup works for multiple workspaces
- ✅ Workspace isolation is maintained
- ✅ Backup files are workspace-specific

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Role guard works (Account Holder/Admin access) (missing)
- [ ] Role guard works (Member access denied) (missing)
- [ ] Scheduled backup to OneDrive works (missing)
- [ ] Scheduled backup to Firebase Storage works (missing)
- [ ] Daily backup executes correctly (missing)
- [ ] Weekly backup executes correctly (missing)
- [ ] Failure notification works (missing)
- [ ] Storage quota check works (missing)
- [ ] Disable backup works (missing)
- [ ] Manual backup works (missing)
- [ ] Progress indicator works (missing)
- [ ] File verification works (missing)
- [ ] Custom frequency works (missing)
- [ ] Multi-workspace backup works (missing)

---

## Known Issues (Based on Audit Report)

1. **Scheduled Backup Not Implemented**:
   - No backup scheduler/service
   - No role guard
   - **Status**: ⛔ Missing

2. **Existing Components**:
   - `BackupService` exists with `startScheduledBackups()` and `runScheduledBackupIfDue()` methods
   - `exportDataToOneDrive()` is empty (not implemented)
   - `OneDriveService` exists with `backupAppData()` method
   - No Firebase Storage service
   - No role guard in backup methods

3. **Missing Components**:
   - No role guard for backup access
   - No Firebase Storage backup service
   - No backup scheduler configuration UI
   - No failure notification system
   - No storage quota checking
   - No backup progress indicator
   - No backup file verification

---

## Notes for Testers

1. **Current Status**: Scheduled backup is completely missing:
   - No backup scheduler/service
   - No role guard
   - `exportDataToOneDrive()` is empty

2. **Existing Components**: Some components exist but are incomplete:
   - `BackupService.startScheduledBackups()` exists but calls empty `exportDataToOneDrive()`
   - `OneDriveService.backupAppData()` exists but not integrated with scheduled backup
   - No Firebase Storage backup support

3. **Design Considerations**: When implementing, consider:
   - Add role guard (Account Holder/Admin only)
   - Implement `exportDataToOneDrive()` method
   - Create Firebase Storage backup service
   - Add backup scheduler configuration UI
   - Add failure notification system
   - Add storage quota checking
   - Add backup progress indicator
   - Add backup file verification
   - Support multiple backup destinations
   - Support custom backup frequencies

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
- Whether role guard works
- Whether scheduled backup works
- Whether failure notification works
- Workspace and user role information

