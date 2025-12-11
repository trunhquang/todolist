# Backup Restore: Workspace/Project Restore with Permission Checks - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Backup Restore** feature. Currently, this feature is **MISSING** - Not implemented; no restore flows, no audit trail. Restore should include permission checks to ensure only authorized users can restore backups.

## Prerequisites
- User must be logged in
- Backup file must exist in OneDrive
- Workspace must exist (for restoring to existing workspace)
- Backup feature should be implemented (or test cases should document expected behavior)
- OneDrive authentication should be configured
- Backup restore UI should be accessible

---

## Test Case 1: Restore Permission Check - Account Holder Can Restore

**Objective**: Verify that Account Holder can restore workspace/project from backup.

**Preconditions**:
- User is logged in as Account Holder
- At least one backup file exists in OneDrive
- Backup file contains workspace data (tasks, projects, workspace settings)
- Restore feature is implemented
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. View available backups:
   - **If NOT implemented**: Restore option is not visible (this is expected - feature missing)
   - **If implemented**: 
     - List of backup files is displayed
     - Backup files show:
       - Backup date/time
       - Backup size
       - Workspace name (if available)
       - Backup type (complete, partial, etc.)

3. Select backup to restore:
   - Tap on a backup file from the list
   - Verify backup details are shown:
     - Backup date
     - Workspace ID
     - Number of tasks (if included)
     - Number of projects (if included)
     - Workspace settings included (yes/no)
     - Members included (yes/no)

4. Start restore process:
   - Tap on "Restore" button
   - Verify permission check is performed:
     - System checks if user is Account Holder
     - Permission check passes (Account Holder has restore permission)
   - Verify confirmation dialog appears:
     - Warning message about data being overwritten
     - Option to confirm or cancel
   - Tap "Confirm" to proceed

5. Verify restore process:
   - Loading indicator appears
   - Progress indicator shows restore progress (if available)
   - Restore completes successfully
   - Success message is displayed

6. Verify workspace is restored:
   - Navigate to workspace
   - Verify workspace settings are restored
   - Navigate to projects list
   - Verify projects are restored
   - Navigate to tasks list
   - Verify tasks are restored
   - Verify data relationships are maintained (tasks linked to projects)

7. Verify restore is logged:
   - Check audit log (if available)
   - Verify log entry contains:
     - Who restored (user ID, name)
     - When restored (timestamp)
     - From which backup (backup file ID, date)
     - What was restored (workspace, projects, tasks)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Restore with permission check is NOT implemented (missing)
- ✅ **When implemented**: Account Holder can restore workspace/project
- ✅ Permission check is performed before restore
- ✅ Confirmation dialog appears before restore
- ✅ Restore completes successfully
- ✅ All data is restored correctly
- ✅ Restore is logged in audit trail

---

## Test Case 2: Restore Permission Check - Admin Can Restore

**Objective**: Verify that Admin can restore workspace/project from backup.

**Preconditions**:
- User is logged in as Admin (not Account Holder)
- At least one backup file exists in OneDrive
- Backup file contains workspace data
- Restore feature is implemented
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. View available backups:
   - **If NOT implemented**: Restore option is not visible (this is expected - feature missing)
   - **If implemented**: 
     - List of backup files is displayed
     - Backup files are visible to Admin

3. Select backup to restore:
   - Tap on a backup file from the list
   - Verify backup details are shown

4. Start restore process:
   - Tap on "Restore" button
   - Verify permission check is performed:
     - System checks if user is Admin or Account Holder
     - Permission check passes (Admin has restore permission)
   - Verify confirmation dialog appears
   - Tap "Confirm" to proceed

5. Verify restore process:
   - Loading indicator appears
   - Progress indicator shows restore progress
   - Restore completes successfully
   - Success message is displayed

6. Verify workspace is restored:
   - Navigate to workspace
   - Verify workspace settings are restored
   - Verify projects are restored
   - Verify tasks are restored

7. Verify restore is logged:
   - Check audit log
   - Verify log entry contains Admin user information

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Restore with permission check is NOT implemented (missing)
- ✅ **When implemented**: Admin can restore workspace/project
- ✅ Permission check is performed before restore
- ✅ Restore completes successfully
- ✅ Restore is logged in audit trail

---

## Test Case 3: Restore Permission Check - Member Cannot Restore

**Objective**: Verify that Member (non-Admin, non-Account Holder) cannot restore workspace/project from backup.

**Preconditions**:
- User is logged in as Member (not Account Holder, not Admin)
- At least one backup file exists in OneDrive
- Restore feature is implemented
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Verify one of the following:
     - **If NOT implemented**: Restore option is not visible (this is expected - feature missing)
     - **If implemented**: 
       - Restore option is NOT visible
       - OR Restore option is visible but disabled
       - OR Error message appears when trying to access restore

2. If restore option is visible but disabled:
   - Tap on "Restore" button (should be disabled/grayed out)
   - Verify button does not respond to tap
   - Verify tooltip or message explains permission requirement

3. If restore option is visible and enabled (should not happen):
   - Tap on "Restore" button
   - Verify permission check is performed:
     - System checks if user is Admin or Account Holder
     - Permission check fails (Member does not have restore permission)
   - Verify error message is displayed:
     - "Permission denied" or similar message
     - Message explains that only Account Holder and Admin can restore
   - Verify restore process does not start

4. Verify no restore occurred:
   - Check workspace data
   - Verify no data was restored
   - Verify workspace remains unchanged

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Restore permission check is NOT implemented (missing)
- ✅ **When implemented**: Member cannot restore workspace/project
- ✅ Restore option is hidden or disabled for Members
- ✅ Permission check prevents unauthorized restore
- ✅ Error message is displayed if Member tries to restore
- ✅ No data is restored

---

## Test Case 4: Restore Workspace - Complete Restore

**Objective**: Verify that complete workspace restore restores all data (tasks, projects, workspace settings, members).

**Preconditions**:
- User is logged in as Account Holder or Admin
- Backup file exists in OneDrive containing:
  - Workspace settings
  - At least 2 projects
  - At least 3 tasks (linked to projects)
  - At least 2 workspace members (if members were included in backup)
- Current workspace may have different data (to verify overwrite)
- Restore feature is implemented
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. Note current workspace state:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Note current number of projects
     - Note current number of tasks
     - Note current workspace settings (timezone, language, etc.)
     - Note current workspace members

3. Select backup to restore:
   - Tap on a complete backup file from the list
   - Verify backup details show:
     - Type: "complete" or "full"
     - Tasks included: Yes (with count)
     - Projects included: Yes (with count)
     - Workspace settings included: Yes
     - Members included: Yes/No (depending on backup)

4. Start restore process:
   - Tap on "Restore" button
   - Verify permission check passes
   - Verify confirmation dialog appears:
     - Warning: "This will overwrite current workspace data. Continue?"
     - Option to confirm or cancel
   - Tap "Confirm" to proceed

5. Verify restore process:
   - Loading indicator appears
   - Progress indicator shows restore progress
   - Restore completes successfully
   - Success message is displayed

6. Verify workspace settings are restored:
   - Navigate to workspace settings
   - Verify settings match backup:
     - Timezone matches backup
     - Language matches backup
     - Date format matches backup
     - Time format matches backup
     - Currency matches backup
     - Theme matches backup
     - Custom fields match backup (if applicable)

7. Verify projects are restored:
   - Navigate to projects list
   - Verify number of projects matches backup
   - Verify each project from backup is present:
     - Project titles match
     - Project descriptions match
     - Project statuses match
     - Project deadlines match (if applicable)
   - Verify projects that were not in backup are removed (if overwriting)

8. Verify tasks are restored:
   - Navigate to tasks list
   - Verify number of tasks matches backup
   - Verify each task from backup is present:
     - Task titles match
     - Task descriptions match
     - Task statuses match
     - Task priorities match
     - Task types match
   - Verify task-project relationships are maintained:
     - Tasks are linked to correct projects
     - Task.projectId matches project.id

9. Verify members are restored (if included in backup):
   - Navigate to workspace members
   - Verify members from backup are present
   - Verify member roles match backup
   - Verify member permissions match backup

10. Verify restore is logged:
    - Check audit log
    - Verify log entry contains complete restore information

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Complete workspace restore is NOT implemented (missing)
- ✅ **When implemented**: Complete workspace restore restores all data
- ✅ Workspace settings are restored correctly
- ✅ Projects are restored correctly
- ✅ Tasks are restored correctly
- ✅ Data relationships are maintained
- ✅ Restore is logged in audit trail

---

## Test Case 5: Restore Project - Selective Restore

**Objective**: Verify that selective project restore restores only selected project and its tasks.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Backup file exists in OneDrive containing:
  - At least 2 projects
  - Tasks linked to each project
- Current workspace has different projects
- Restore feature is implemented with selective restore option
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. Select backup to restore:
   - **If NOT implemented**: Selective restore is not available (this is expected - feature missing)
   - **If implemented**: 
     - Tap on a backup file from the list
     - Verify backup details are shown
     - Verify "Selective Restore" or "Restore Selected" option is available

3. Select project to restore:
   - Tap on "Selective Restore" or "Restore Selected"
   - Verify project selection screen appears:
     - List of projects from backup is displayed
     - Checkboxes or selection mechanism for each project
   - Select one project from the list
   - Verify selected project is highlighted or checked
   - Tap "Continue" or "Next"

4. Start restore process:
   - Verify confirmation dialog appears:
     - Warning: "This will restore selected project and its tasks. Continue?"
     - List of selected projects
     - Option to confirm or cancel
   - Tap "Confirm" to proceed

5. Verify restore process:
   - Loading indicator appears
   - Progress indicator shows restore progress
   - Restore completes successfully
   - Success message is displayed

6. Verify selected project is restored:
   - Navigate to projects list
   - Verify selected project is present:
     - Project title matches backup
     - Project description matches backup
     - Project status matches backup
   - Verify other projects from backup are NOT restored
   - Verify existing projects (not in backup) remain unchanged

7. Verify tasks for selected project are restored:
   - Navigate to tasks list
   - Filter by restored project
   - Verify tasks linked to restored project are present:
     - Task titles match backup
     - Task statuses match backup
     - Tasks are linked to restored project (task.projectId matches project.id)
   - Verify tasks from other projects are NOT restored

8. Verify workspace settings are NOT changed:
   - Navigate to workspace settings
   - Verify workspace settings remain unchanged (selective restore doesn't change settings)

9. Verify restore is logged:
   - Check audit log
   - Verify log entry contains:
     - Selected project information
     - Selective restore indication

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Selective project restore is NOT implemented (missing)
- ✅ **When implemented**: Selective project restore restores only selected project
- ✅ Selected project and its tasks are restored
- ✅ Other projects are not restored
- ✅ Workspace settings remain unchanged
- ✅ Restore is logged in audit trail

---

## Test Case 6: Restore Validation - Invalid Backup File

**Objective**: Verify that restore process validates backup file before restoring.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Invalid or corrupted backup file exists in OneDrive (or can be simulated)
- Restore feature is implemented
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. Select invalid backup file:
   - **If NOT implemented**: Validation is not performed (this is expected - feature missing)
   - **If implemented**: 
     - Tap on an invalid/corrupted backup file from the list
     - OR Create test scenario with invalid backup file

3. Attempt to restore:
   - Tap on "Restore" button
   - Verify validation is performed:
     - System validates backup file format
     - System validates backup file structure
     - System validates backup file integrity
   - Verify validation fails:
     - Error message is displayed
     - Error message explains validation failure (e.g., "Invalid backup file format", "Corrupted backup file")
   - Verify restore process does not start

4. Verify no data is restored:
   - Check workspace data
   - Verify no data was restored
   - Verify workspace remains unchanged

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Restore validation is NOT implemented (missing)
- ✅ **When implemented**: Restore validates backup file before restoring
- ✅ Invalid backup files are rejected
- ✅ Error messages are clear and actionable
- ✅ No data is restored from invalid backup

---

## Test Case 7: Restore Validation - Workspace Mismatch

**Objective**: Verify that restore process validates workspace ID match when restoring to existing workspace.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Backup file exists in OneDrive for a different workspace
- Current workspace is different from backup workspace
- Restore feature is implemented
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. Select backup from different workspace:
   - **If NOT implemented**: Validation is not performed (this is expected - feature missing)
   - **If implemented**: 
     - Tap on a backup file from different workspace
     - Verify backup details show workspace ID different from current workspace

3. Attempt to restore:
   - Tap on "Restore" button
   - Verify validation is performed:
     - System checks if backup workspace ID matches current workspace ID
     - System validates workspace match
   - Verify one of the following:
     - **Option A**: Validation fails with error:
       - Error message: "Backup is for a different workspace"
       - Restore is blocked
     - **Option B**: Warning dialog appears:
       - Warning: "This backup is for a different workspace. Restore anyway?"
       - Option to confirm or cancel
       - If confirmed, restore proceeds (creating new workspace or merging)

4. Verify appropriate action:
   - If validation failed: No data is restored
   - If warning was shown and user confirmed: Data is restored appropriately

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Workspace mismatch validation is NOT implemented (missing)
- ✅ **When implemented**: Restore validates workspace match
- ✅ Workspace mismatch is detected
- ✅ User is warned or restore is blocked
- ✅ Appropriate action is taken based on validation result

---

## Test Case 8: Restore Conflict Resolution - Data Conflicts

**Objective**: Verify that restore process handles data conflicts (e.g., same task/project ID exists in both backup and current workspace).

**Preconditions**:
- User is logged in as Account Holder or Admin
- Backup file exists in OneDrive
- Current workspace has data with same IDs as backup (conflicts)
- Restore feature is implemented with conflict resolution
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. Note conflicting data:
   - **If NOT implemented**: Conflict resolution is not performed (this is expected - feature missing)
   - **If implemented**: 
     - Note current workspace has project with ID "project-123"
     - Backup file also has project with ID "project-123" but different data

3. Start restore process:
   - Tap on backup file
   - Tap on "Restore" button
   - Verify permission check passes
   - Verify confirmation dialog appears
   - Tap "Confirm" to proceed

4. Verify conflict detection:
   - System detects conflicts during restore:
     - Same project IDs exist
     - Same task IDs exist
   - Verify conflict resolution dialog appears:
     - List of conflicts is shown
     - Options for each conflict:
       - "Overwrite" - Replace current data with backup data
       - "Keep Current" - Keep current data, skip backup data
       - "Rename" - Create new item with different ID
     - Option to apply to all conflicts

5. Resolve conflicts:
   - Select resolution option for each conflict
   - OR Select "Apply to all: Overwrite"
   - Tap "Continue" or "Resolve"

6. Verify restore completes:
   - Loading indicator appears
   - Progress indicator shows restore progress
   - Restore completes successfully
   - Success message is displayed

7. Verify conflicts are resolved correctly:
   - Check projects:
     - If "Overwrite" was selected: Project data matches backup
     - If "Keep Current" was selected: Project data remains unchanged
     - If "Rename" was selected: New project exists with different ID
   - Check tasks:
     - Tasks are linked correctly after conflict resolution
     - No orphaned tasks exist

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Conflict resolution is NOT implemented (missing)
- ✅ **When implemented**: Restore detects and resolves conflicts
- ✅ Conflict resolution dialog appears
- ✅ User can choose resolution strategy
- ✅ Conflicts are resolved correctly
- ✅ Data integrity is maintained after conflict resolution

---

## Test Case 9: Restore Audit Trail - Restore Logging

**Objective**: Verify that restore operations are logged in audit trail with complete information.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Backup file exists in OneDrive
- Audit logging feature is implemented (or should be implemented)
- Restore feature is implemented
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. Perform restore:
   - **If NOT implemented**: Audit logging is not performed (this is expected - feature missing)
   - **If implemented**: 
     - Select backup file
     - Tap on "Restore" button
     - Verify permission check passes
     - Confirm restore
     - Wait for restore to complete

3. Verify restore is logged:
   - Navigate to audit log or activity log (if available)
   - Verify restore log entry exists:
     - Log entry type: "restore" or "backup_restore"
     - Log entry timestamp: Matches restore time
   - Verify log entry contains:
     - **Who restored**: 
       - User ID
       - User name/email
       - User role (Account Holder/Admin)
     - **When restored**: 
       - Timestamp (ISO 8601 format)
       - Date and time
     - **From which backup**: 
       - Backup file ID
       - Backup file name
       - Backup date/time
       - Backup workspace ID
     - **What was restored**: 
       - Workspace restored: Yes/No
       - Projects restored: Count
       - Tasks restored: Count
       - Workspace settings restored: Yes/No
       - Members restored: Yes/No (if applicable)
     - **Restore type**: 
       - Complete restore
       - Selective restore (if applicable)
       - Project restore (if applicable)

4. Verify log entry is accessible:
   - Log entry can be viewed
   - Log entry can be searched/filtered
   - Log entry provides complete audit trail

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Restore audit trail is NOT implemented (missing)
- ✅ **When implemented**: Restore operations are logged in audit trail
- ✅ Log entries contain complete information (who, when, from which backup, what was restored)
- ✅ Log entries are accessible and searchable
- ✅ Audit trail provides complete history of restore operations

---

## Test Case 10: Restore Error Handling - Partial Restore Failure

**Objective**: Verify that restore process handles partial failures gracefully (e.g., some data restores successfully, some fails).

**Preconditions**:
- User is logged in as Account Holder or Admin
- Backup file exists in OneDrive
- Simulate partial failure scenario (e.g., network interruption, invalid data in backup)
- Restore feature is implemented
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. Start restore process:
   - **If NOT implemented**: Error handling is not implemented (this is expected - feature missing)
   - **If implemented**: 
     - Select backup file
     - Tap on "Restore" button
     - Verify permission check passes
     - Confirm restore
     - Simulate partial failure during restore (e.g., disconnect network mid-restore)

3. Verify error handling:
   - System detects partial failure:
     - Some data restored successfully
     - Some data failed to restore
   - Verify error message is displayed:
     - Error message explains partial failure
     - List of what was restored successfully
     - List of what failed to restore
     - Option to retry failed items
   - Verify restore process completes (with errors)

4. Verify data state after partial failure:
   - Check what was restored:
     - Successfully restored data is present
     - Data integrity is maintained for restored items
   - Check what failed:
     - Failed data is not present
     - No corrupted data exists

5. Verify rollback option (if implemented):
   - Option to rollback restore is available
   - If rollback is selected:
     - All restored data is reverted
     - Workspace returns to pre-restore state
     - Rollback is logged

6. Verify retry option (if implemented):
   - Option to retry failed items is available
   - If retry is selected:
     - Only failed items are retried
     - Successfully restored items are not affected
     - Retry is logged

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Partial restore failure handling is NOT implemented (missing)
- ✅ **When implemented**: Restore handles partial failures gracefully
- ✅ Error messages are clear and actionable
- ✅ User can see what succeeded and what failed
- ✅ Rollback option is available (if implemented)
- ✅ Retry option is available (if implemented)
- ✅ Data integrity is maintained

---

## Summary

### Current Status: ⛔ MISSING
All backup restore features are currently **NOT IMPLEMENTED**. The `restoreBackup()` method in `BackupService` only downloads and parses backup file, but does not implement actual restore logic, permission checks, or audit trail.

### What Needs to Be Implemented:
1. ✅ Restore permission checks (Account Holder/Admin only)
2. ✅ Complete workspace restore (tasks, projects, workspace settings, members)
3. ✅ Selective project restore
4. ✅ Restore validation (backup file format, workspace match)
5. ✅ Conflict resolution (data conflicts during restore)
6. ✅ Restore audit trail (who, when, from which backup, what was restored)
7. ✅ Error handling (partial failures, rollback, retry)
8. ✅ Restore confirmation dialogs
9. ✅ Restore progress tracking
10. ✅ Data integrity verification after restore

### Test Execution Notes:
- All test cases should be executed after implementation
- Test cases marked as "Missing Feature" should be updated once implemented
- Focus on permission checks and data integrity
- Test with various backup scenarios (complete, partial, selective)
- Test with various user roles (Account Holder, Admin, Member)
- Verify audit trail is complete and accurate

### Security Considerations:
- **Critical**: Only Account Holder and Admin should be able to restore
- Permission checks must be performed before restore
- Restore operations must be logged in audit trail
- Data validation must be performed before restore
- Conflict resolution must maintain data integrity

