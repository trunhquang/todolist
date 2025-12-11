# Governance & Safety Test Cases

## Overview
This document contains step-by-step test cases for testing the **Governance & Safety** feature (audit log, quota cảnh báo, backup/restore). This feature is currently **MISSING** - no audit logging around workspace updates/deletes, no quota checks, and no workspace-level backup/restore hooks.

## Prerequisites
- User must be logged into the application
- User must be Account Holder or Admin (for some operations)
- Workspace should have some data (projects, tasks, members)
- Device should have internet connection (for Firebase sync and OneDrive backup)

---

## Test Case 1: Audit Log - Workspace Creation

**Objective**: Verify workspace creation is logged in audit log.

**Preconditions**:
- User is logged in
- User has permission to create workspace
- Audit logging is implemented

**Steps**:
1. Navigate to Create Workspace screen
2. Create a new workspace:
   - Enter workspace name: "Test Workspace"
   - Select workspace type: Company
   - Fill other required fields
   - Tap "Create" button
3. Verify workspace is created successfully
4. Navigate to Audit Log or Workspace History screen (if implemented)
5. Verify audit log entry is created:
   - Action: "workspace_created" or "create"
   - User: Current user ID/name
   - Workspace: New workspace ID/name
   - Timestamp: Current date/time
   - Details: Workspace information (name, type, etc.)
6. Verify audit log entry is stored in Firebase

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Audit logging is NOT implemented
- ✅ **When implemented**: Workspace creation is logged
- ✅ Audit log entry contains correct information
- ✅ Audit log is stored in Firebase

---

## Test Case 2: Audit Log - Workspace Update

**Objective**: Verify workspace updates are logged in audit log.

**Preconditions**:
- User is logged in
- User has permission to update workspace
- Workspace exists
- Audit logging is implemented

**Steps**:
1. Navigate to Workspace Settings screen
2. Update workspace information:
   - Change workspace name: "Updated Workspace Name"
   - Change description: "Updated description"
   - Save changes
3. Verify workspace is updated successfully
4. Navigate to Audit Log screen
5. Verify audit log entry is created:
   - Action: "workspace_updated" or "update"
   - User: Current user ID/name
   - Workspace: Workspace ID/name
   - Timestamp: Current date/time
   - Previous values: Old workspace name, description
   - New values: New workspace name, description
   - Changed fields: List of fields that changed
6. Verify audit log entry shows what changed

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Audit logging is NOT implemented
- ✅ **When implemented**: Workspace updates are logged
- ✅ Audit log shows previous and new values
- ✅ Changed fields are tracked

---

## Test Case 3: Audit Log - Workspace Deletion

**Objective**: Verify workspace deletion is logged in audit log.

**Preconditions**:
- User is logged in as Account Holder
- Workspace exists
- Audit logging is implemented

**Steps**:
1. Navigate to Workspace Management screen
2. Delete workspace:
   - Tap "Delete Workspace" button
   - Confirm deletion
   - Verify workspace is deleted
3. Navigate to Audit Log screen
4. Verify audit log entry is created:
   - Action: "workspace_deleted" or "delete"
   - User: Current user ID/name
   - Workspace: Deleted workspace ID/name
   - Timestamp: Current date/time
   - Workspace metadata: Name, type, member count, etc.
   - Reason: Deletion reason (if provided)
5. Verify audit log entry is created BEFORE deletion (so it's not lost)
6. Verify audit log entry is stored in Firebase

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Audit logging is NOT implemented
- ✅ **When implemented**: Workspace deletion is logged
- ✅ Audit log includes workspace metadata
- ✅ Log is created before deletion

---

## Test Case 4: Audit Log - Member Added

**Objective**: Verify member addition is logged in audit log.

**Preconditions**:
- User is logged in
- User has permission to invite users
- Workspace exists
- Audit logging is implemented

**Steps**:
1. Navigate to User Management screen
2. Invite a user to workspace:
   - Tap "Invite User" button
   - Enter email: "newuser@example.com"
   - Select role: Member
   - Send invitation
3. Verify invitation is sent successfully
4. Navigate to Audit Log screen
5. Verify audit log entry is created:
   - Action: "member_added" or "invite_user"
   - User: Current user ID/name (who invited)
   - Workspace: Workspace ID/name
   - Member: Invited user email/ID
   - Role: Assigned role
   - Timestamp: Current date/time
6. Verify audit log entry is stored

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Audit logging is NOT implemented
- ✅ **When implemented**: Member addition is logged
- ✅ Audit log includes member and role information

---

## Test Case 5: Audit Log - Member Removed

**Objective**: Verify member removal is logged in audit log.

**Preconditions**:
- User is logged in
- User has permission to remove users
- Workspace has members
- Audit logging is implemented

**Steps**:
1. Navigate to User Management screen
2. Remove a member from workspace:
   - Select a member
   - Tap "Remove" button
   - Confirm removal
3. Verify member is removed successfully
4. Navigate to Audit Log screen
5. Verify audit log entry is created:
   - Action: "member_removed" or "remove_user"
   - User: Current user ID/name (who removed)
   - Workspace: Workspace ID/name
   - Member: Removed user ID/name
   - Timestamp: Current date/time
   - Reason: Removal reason (if provided)
6. Verify audit log entry is stored

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Audit logging is NOT implemented
- ✅ **When implemented**: Member removal is logged
- ✅ Audit log includes member information

---

## Test Case 6: Audit Log - Permission Changes

**Objective**: Verify permission changes are logged in audit log.

**Preconditions**:
- User is logged in
- User has permission to assign permissions
- Workspace has members
- Audit logging is implemented

**Steps**:
1. Navigate to Permission Management screen
2. Change a member's permissions:
   - Select a member
   - Grant a permission (e.g., "create_tasks")
   - Save changes
3. Verify permission is updated successfully
4. Navigate to Audit Log screen
5. Verify audit log entry is created:
   - Action: "permission_changed" or "update_permissions"
   - User: Current user ID/name (who changed)
   - Workspace: Workspace ID/name
   - Member: Member ID/name (whose permissions changed)
   - Previous permissions: List of previous permissions
   - New permissions: List of new permissions
   - Changed permissions: List of added/removed permissions
   - Timestamp: Current date/time
6. Verify audit log entry shows permission changes

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Audit logging is NOT implemented
- ✅ **When implemented**: Permission changes are logged
- ✅ Audit log shows previous and new permissions

---

## Test Case 7: View Audit Log

**Objective**: Verify audit log can be viewed.

**Preconditions**:
- User is logged in
- User has permission to view audit log (Account Holder/Admin)
- Workspace has audit log entries
- Audit log UI is implemented

**Steps**:
1. Navigate to Audit Log or Workspace History screen
2. Verify audit log is displayed:
   - List of audit log entries
   - Each entry shows: Action, User, Timestamp, Details
   - Entries are sorted by timestamp (newest first or oldest first)
3. Verify audit log entries are filtered by workspace:
   - Only current workspace's audit logs are shown
   - Other workspaces' logs are not shown
4. Verify audit log can be filtered:
   - Filter by action type (create, update, delete, etc.)
   - Filter by user
   - Filter by date range
5. Verify audit log can be searched:
   - Search by action, user, or details
6. Verify audit log can be exported (if implemented):
   - Export to CSV, PDF, or Excel

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Audit log UI is NOT implemented
- ✅ **When implemented**: Audit log can be viewed
- ✅ Audit log is filtered by workspace
- ✅ Filtering and search work correctly

---

## Test Case 8: Quota Check - Workspace Storage Usage

**Objective**: Verify workspace storage usage is checked and displayed.

**Preconditions**:
- User is logged in
- Workspace has data (projects, tasks, members)
- Quota checking is implemented

**Steps**:
1. Navigate to Workspace Settings or Workspace Management screen
2. Locate "Storage Usage" or "Quota" section
3. Verify storage usage is displayed:
   - Total storage used
   - Storage limit (if applicable)
   - Storage percentage used
   - Breakdown by data type (tasks, projects, files, etc.)
4. Verify storage usage is calculated correctly:
   - Check Firebase for actual data size
   - Compare with displayed usage
5. Verify storage usage updates when data changes:
   - Create a new task
   - Verify storage usage increases
   - Delete a task
   - Verify storage usage decreases

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Quota checking is NOT implemented
- ✅ **When implemented**: Storage usage is displayed
- ✅ Storage usage is calculated correctly
- ✅ Storage usage updates in real-time

---

## Test Case 9: Quota Warning - Approaching Limit

**Objective**: Verify quota warnings are shown when approaching storage limit.

**Preconditions**:
- User is logged in
- Workspace has storage limit configured
- Workspace storage is approaching limit (e.g., 80% used)
- Quota warning system is implemented

**Steps**:
1. Navigate to Workspace Settings or Dashboard
2. Verify quota warning is displayed:
   - Warning message: "Storage usage is at X%"
   - Warning appears when usage exceeds threshold (e.g., 80%)
   - Warning is visible and clear
3. Verify warning appears in multiple places:
   - Dashboard
   - Workspace Settings
   - When creating new data (tasks, projects)
4. Verify warning actions are available:
   - "Upgrade Plan" button (if applicable)
   - "Clean Up Data" button (if applicable)
   - "View Details" link
5. Increase storage usage to exceed limit:
   - Create more data until limit is reached
   - Verify warning changes to error/critical
   - Verify new data creation is blocked (if limit is enforced)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Quota warnings are NOT implemented
- ✅ **When implemented**: Quota warnings are shown
- ✅ Warnings appear at appropriate thresholds
- ✅ Warnings are clear and actionable

---

## Test Case 10: Quota Check - Member Limit

**Objective**: Verify member limit is checked and enforced.

**Preconditions**:
- User is logged in
- Workspace has member limit configured
- Workspace is approaching member limit
- Quota checking is implemented

**Steps**:
1. Navigate to User Management screen
2. Verify member count is displayed:
   - Current member count
   - Member limit
   - Member count percentage
3. Try to invite new member when at limit:
   - Invite a new user
   - Verify error message appears: "Member limit reached"
   - Verify invitation is blocked
4. Verify member limit warning:
   - Warning appears when approaching limit (e.g., 90% of limit)
   - Warning is clear and actionable
5. Verify member limit is enforced:
   - Cannot add members beyond limit
   - Appropriate error messages are shown

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Member limit checking is NOT implemented
- ✅ **When implemented**: Member limit is checked and enforced
- ✅ Warnings are shown when approaching limit
- ✅ Limit is enforced when reached

---

## Test Case 11: Workspace Backup - Manual Backup

**Objective**: Verify workspace can be manually backed up.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Workspace has data (projects, tasks, members, settings)
- OneDrive is connected (if using OneDrive backup)
- Backup functionality is implemented

**Steps**:
1. Navigate to Workspace Settings or Backup screen
2. Locate "Backup Workspace" or "Export Data" option
3. Tap "Backup Now" or "Create Backup" button
4. Verify backup process:
   - Loading indicator appears
   - Progress is shown (if available)
   - Backup completes successfully
5. Verify backup is created:
   - Backup file is created in OneDrive (or backup location)
   - Backup file name includes timestamp
   - Backup file contains workspace data
6. Verify backup includes:
   - Workspace settings
   - Projects
   - Tasks
   - Members (if configured)
   - Metadata (backup date, workspace ID, etc.)
7. Verify success message appears

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Workspace backup is NOT fully implemented
- ✅ **When implemented**: Workspace can be backed up
- ✅ Backup includes all workspace data
- ✅ Backup is stored securely

---

## Test Case 12: Workspace Backup - Automatic Backup

**Objective**: Verify automatic workspace backups are scheduled and executed.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has data
- Automatic backup is configured
- Backup scheduling is implemented

**Steps**:
1. Navigate to Workspace Settings or Backup screen
2. Enable automatic backup:
   - Toggle "Automatic Backup" ON
   - Select backup frequency (daily, weekly, monthly)
   - Save settings
3. Verify backup schedule is set:
   - Backup schedule is saved
   - Next backup time is displayed
4. Wait for scheduled backup time (or trigger manually for testing)
5. Verify automatic backup executes:
   - Backup runs automatically
   - Backup completes successfully
   - Backup file is created
6. Verify backup history:
   - Previous backups are listed
   - Backup dates and sizes are shown
   - Backup files can be accessed

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Automatic backup is NOT implemented
- ✅ **When implemented**: Automatic backups are scheduled
- ✅ Backups execute automatically
- ✅ Backup history is maintained

---

## Test Case 13: Workspace Restore - From Backup

**Objective**: Verify workspace can be restored from backup.

**Preconditions**:
- User is logged in as Account Holder
- Backup file exists
- Workspace restore functionality is implemented

**Steps**:
1. Navigate to Backup or Restore screen
2. View available backups:
   - List of backup files is displayed
   - Backup dates and sizes are shown
   - Backup details are available
3. Select a backup to restore:
   - Tap on a backup file
   - Verify backup details are shown
4. Start restore process:
   - Tap "Restore" button
   - Verify confirmation dialog appears
   - Confirm restore
5. Verify restore process:
   - Loading indicator appears
   - Progress is shown (if available)
   - Restore completes successfully
6. Verify workspace is restored:
   - Workspace settings are restored
   - Projects are restored
   - Tasks are restored
   - Members are restored (if included in backup)
7. Verify restore is logged in audit log (if audit logging exists)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Workspace restore is NOT fully implemented
- ✅ **When implemented**: Workspace can be restored from backup
- ✅ All workspace data is restored correctly
- ✅ Restore is logged

---

## Test Case 14: Backup/Restore - Data Integrity

**Objective**: Verify backup and restore maintain data integrity.

**Preconditions**:
- User is logged in as Account Holder
- Workspace has complex data (projects with tasks, members with permissions)
- Backup and restore are implemented

**Steps**:
1. Create backup of current workspace
2. Make changes to workspace:
   - Add new project
   - Add new task
   - Update workspace settings
3. Restore from backup
4. Verify data integrity:
   - Original data is restored
   - Changes made after backup are reverted
   - Data relationships are maintained (tasks linked to projects, etc.)
   - Permissions are restored correctly
5. Verify no data corruption:
   - All data is accessible
   - No missing relationships
   - No duplicate data

**Expected Results**:
- ✅ Backup and restore maintain data integrity
- ✅ All data relationships are preserved
- ✅ No data corruption occurs

---

## Test Case 15: Backup/Restore - Permission Check

**Objective**: Verify only Account Holder/Admin can backup/restore workspace.

**Preconditions**:
- User is logged in as Member (not Account Holder/Admin)
- Backup/restore functionality is implemented

**Steps**:
1. Navigate to Backup or Restore screen
2. Verify one of the following:
   - Backup/Restore options are not visible
   - OR Backup/Restore options are disabled
   - OR Error message appears when trying to access
3. Try to create backup:
   - Tap "Backup" button (if visible)
   - Verify error message: "Permission denied" or "Only Account Holder/Admin can backup workspace"
4. Try to restore backup:
   - Tap "Restore" button (if visible)
   - Verify error message: "Permission denied" or "Only Account Holder/Admin can restore workspace"
5. As Account Holder:
   - Verify backup/restore options are available
   - Verify backup/restore works correctly

**Expected Results**:
- ✅ Only Account Holder/Admin can backup/restore
- ✅ Permission checks are enforced
- ✅ Appropriate error messages are shown

---

## Test Case 16: Quota Check - Project Limit

**Objective**: Verify project limit is checked and enforced.

**Preconditions**:
- User is logged in
- Workspace has project limit configured
- Workspace is approaching project limit
- Quota checking is implemented

**Steps**:
1. Navigate to Projects screen
2. Verify project count is displayed:
   - Current project count
   - Project limit
   - Project count percentage
3. Try to create new project when at limit:
   - Tap "Create Project" button
   - Fill project details
   - Tap "Save" button
   - Verify error message: "Project limit reached"
   - Verify project creation is blocked
4. Verify project limit warning:
   - Warning appears when approaching limit (e.g., 90% of limit)
   - Warning is clear and actionable
5. Verify project limit is enforced:
   - Cannot create projects beyond limit
   - Appropriate error messages are shown

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Project limit checking is NOT implemented
- ✅ **When implemented**: Project limit is checked and enforced
- ✅ Warnings are shown when approaching limit
- ✅ Limit is enforced when reached

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Workspace creation is logged in audit log
- [ ] Workspace updates are logged in audit log
- [ ] Workspace deletion is logged in audit log
- [ ] Member addition is logged in audit log
- [ ] Member removal is logged in audit log
- [ ] Permission changes are logged in audit log
- [ ] Audit log can be viewed
- [ ] Storage usage is checked and displayed
- [ ] Quota warnings are shown when approaching limit
- [ ] Member limit is checked and enforced
- [ ] Workspace can be manually backed up
- [ ] Automatic workspace backups are scheduled
- [ ] Workspace can be restored from backup
- [ ] Backup and restore maintain data integrity
- [ ] Only Account Holder/Admin can backup/restore
- [ ] Project limit is checked and enforced

---

## Known Issues (Based on Audit Report)

1. **No Audit Logging**:
   - No audit logging around workspace updates/deletes
   - No audit log entity or service for workspace operations
   - **Status**: ⛔ Missing

2. **No Quota Checks**:
   - No quota checks for workspace storage, members, projects
   - No quota warning system
   - **Status**: ⛔ Missing

3. **No Workspace-Level Backup/Restore Hooks**:
   - `BackupService` exists but `exportDataToOneDrive()` is empty
   - No workspace-level backup/restore hooks
   - **Status**: ⛔ Missing

---

## Notes for Testers

1. **Audit Logging**: Currently missing. When implemented, should log all workspace operations (create, update, delete, member changes, permission changes).

2. **Quota Checks**: Currently missing. When implemented, should check storage usage, member limits, project limits, and show warnings.

3. **Backup/Restore**: `BackupService` exists but workspace-level backup is not fully implemented. OneDrive backup exists but may not include workspace-specific hooks.

4. **Permission Requirements**: Most governance features require Account Holder or Admin permissions.

5. **Data Integrity**: When testing backup/restore, verify all data relationships are preserved.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- User role and permissions
- Current workspace
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Backup file details (if testing backup/restore)

