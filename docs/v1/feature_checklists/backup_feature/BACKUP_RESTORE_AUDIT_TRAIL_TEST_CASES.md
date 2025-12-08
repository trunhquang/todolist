# Backup Restore Audit Trail: Restore Logging - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Backup Restore Audit Trail** feature. Currently, this feature is **MISSING** - Not implemented. Restore audit trail should log: who restored (ai khôi phục), from which backup (từ bản nào), and when (thời gian).

## Prerequisites
- User must be logged in
- User must have Account Holder or Admin role (for restore operations)
- Backup file must exist in OneDrive
- Restore feature should be implemented (or test cases should document expected behavior)
- Audit logging system should be implemented (or test cases should document expected behavior)
- Audit log viewing UI should be accessible (if implemented)

---

## Test Case 1: Restore Audit Trail - Who Restored (User Information)

**Objective**: Verify that restore audit trail logs who performed the restore operation (user ID, name, role).

**Preconditions**:
- User is logged in as Account Holder
- User name: "John Doe"
- User email: "john.doe@example.com"
- User ID: "user-123"
- User role: Account Holder
- At least one backup file exists in OneDrive
- Restore feature is implemented
- Audit logging is implemented
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. Perform restore operation:
   - **If NOT implemented**: Restore feature is not available (this is expected - feature missing)
   - **If implemented**: 
     - Select backup file from the list
     - Tap on "Restore" button
     - Verify permission check passes
     - Confirm restore in confirmation dialog
     - Wait for restore to complete
     - Verify success message is displayed

3. Verify restore is logged with user information:
   - Navigate to audit log or activity log screen
   - **If NOT implemented**: Audit log is not available (this is expected - feature missing)
   - **If implemented**: 
     - Find restore log entry (most recent entry)
     - Verify log entry type is "restore" or "backup_restore"
     - Verify log entry contains user information:
       - **User ID**: "user-123" (matches current user ID)
       - **User Name**: "John Doe" (matches current user name)
       - **User Email**: "john.doe@example.com" (matches current user email, if logged)
       - **User Role**: "account_holder" or "Account Holder" (matches current user role)

4. Verify user information is accurate:
   - Compare logged user information with current user information
   - Verify all fields match
   - Verify user information is not null or empty

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Restore audit trail is NOT implemented (missing)
- ✅ **When implemented**: Restore audit trail logs who performed restore
- ✅ User ID is logged correctly
- ✅ User name is logged correctly
- ✅ User email is logged (if available)
- ✅ User role is logged correctly
- ✅ User information is accurate and complete

---

## Test Case 2: Restore Audit Trail - From Which Backup (Backup File Information)

**Objective**: Verify that restore audit trail logs from which backup file the restore was performed (backup file ID, name, date).

**Preconditions**:
- User is logged in as Account Holder or Admin
- At least one backup file exists in OneDrive:
  - Backup file ID: "backup-file-123"
  - Backup file name: "backup_2024-01-15T10-30-00.json"
  - Backup date: January 15, 2024, 10:30:00 AM
- Restore feature is implemented
- Audit logging is implemented
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. Note backup file information:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - View list of backup files
     - Note the backup file you will restore:
       - Backup file ID
       - Backup file name
       - Backup file date/time
       - Backup file size (if available)

3. Perform restore operation:
   - Select the noted backup file
   - Tap on "Restore" button
   - Verify permission check passes
   - Confirm restore in confirmation dialog
   - Wait for restore to complete
   - Verify success message is displayed

4. Verify restore is logged with backup file information:
   - Navigate to audit log or activity log screen
   - **If NOT implemented**: Audit log is not available (this is expected - feature missing)
   - **If implemented**: 
     - Find restore log entry (most recent entry)
     - Verify log entry contains backup file information:
       - **Backup File ID**: "backup-file-123" (matches selected backup file ID)
       - **Backup File Name**: "backup_2024-01-15T10-30-00.json" (matches selected backup file name)
       - **Backup File Date**: January 15, 2024, 10:30:00 AM (matches selected backup file date)
       - **Backup Workspace ID**: Matches workspace ID from backup file
       - **Backup Type**: "complete", "partial", or similar (matches backup type)

5. Verify backup file information is accurate:
   - Compare logged backup file information with selected backup file
   - Verify all fields match
   - Verify backup file information is not null or empty

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Restore audit trail is NOT implemented (missing)
- ✅ **When implemented**: Restore audit trail logs from which backup file restore was performed
- ✅ Backup file ID is logged correctly
- ✅ Backup file name is logged correctly
- ✅ Backup file date is logged correctly
- ✅ Backup workspace ID is logged correctly
- ✅ Backup type is logged correctly
- ✅ Backup file information is accurate and complete

---

## Test Case 3: Restore Audit Trail - When Restored (Timestamp)

**Objective**: Verify that restore audit trail logs when the restore operation was performed (timestamp, date, time).

**Preconditions**:
- User is logged in as Account Holder or Admin
- At least one backup file exists in OneDrive
- Restore feature is implemented
- Audit logging is implemented
- User is on the backup/restore screen
- Device time is accurate

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. Note current time:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Note current date and time (e.g., January 20, 2024, 2:45:30 PM)
     - This will be used to verify restore timestamp

3. Perform restore operation:
   - Select backup file from the list
   - Tap on "Restore" button
   - Verify permission check passes
   - Confirm restore in confirmation dialog
   - Note the exact time when restore is confirmed (e.g., 2:45:35 PM)
   - Wait for restore to complete
   - Note the exact time when restore completes (e.g., 2:46:10 PM)
   - Verify success message is displayed

4. Verify restore is logged with timestamp:
   - Navigate to audit log or activity log screen
   - **If NOT implemented**: Audit log is not available (this is expected - feature missing)
   - **If implemented**: 
     - Find restore log entry (most recent entry)
     - Verify log entry contains timestamp information:
       - **Timestamp**: ISO 8601 format (e.g., "2024-01-20T14:46:10.123Z")
       - **Date**: January 20, 2024 (matches restore date)
       - **Time**: 2:46:10 PM (approximately matches restore completion time)
       - **Timezone**: UTC or local timezone (as configured)

5. Verify timestamp is accurate:
   - Compare logged timestamp with restore completion time
   - Verify timestamp is within reasonable range (e.g., within 1-2 seconds of restore completion)
   - Verify timestamp is not in the future
   - Verify timestamp is not too far in the past (e.g., not more than 1 minute before restore started)

6. Verify timestamp format:
   - Verify timestamp is in ISO 8601 format
   - Verify timestamp includes date, time, and timezone
   - Verify timestamp is parseable and valid

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Restore audit trail is NOT implemented (missing)
- ✅ **When implemented**: Restore audit trail logs when restore was performed
- ✅ Timestamp is logged correctly
- ✅ Timestamp is accurate (within reasonable range)
- ✅ Timestamp is in ISO 8601 format
- ✅ Timestamp includes date, time, and timezone

---

## Test Case 4: Restore Audit Trail - Complete Log Entry

**Objective**: Verify that restore audit trail log entry contains all required information (who, from which backup, when, what was restored).

**Preconditions**:
- User is logged in as Account Holder
- User name: "Jane Smith"
- User ID: "user-456"
- User role: Account Holder
- Backup file exists in OneDrive:
  - Backup file ID: "backup-file-456"
  - Backup file name: "backup_2024-01-18T09-15-00.json"
  - Backup date: January 18, 2024, 9:15:00 AM
  - Backup contains: 5 projects, 20 tasks, workspace settings, 3 members
- Restore feature is implemented
- Audit logging is implemented
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. Perform complete restore:
   - **If NOT implemented**: Restore feature is not available (this is expected - feature missing)
   - **If implemented**: 
     - Select backup file from the list
     - Tap on "Restore" button
     - Verify permission check passes
     - Confirm restore in confirmation dialog
     - Wait for restore to complete
     - Verify success message is displayed

3. Verify complete restore log entry:
   - Navigate to audit log or activity log screen
   - **If NOT implemented**: Audit log is not available (this is expected - feature missing)
   - **If implemented**: 
     - Find restore log entry (most recent entry)
     - Verify log entry contains all required information:
       - **Who Restored**:
         - User ID: "user-456"
         - User Name: "Jane Smith"
         - User Role: "account_holder"
       - **From Which Backup**:
         - Backup File ID: "backup-file-456"
         - Backup File Name: "backup_2024-01-18T09-15-00.json"
         - Backup Date: January 18, 2024, 9:15:00 AM
         - Backup Workspace ID: Matches workspace ID
       - **When Restored**:
         - Timestamp: ISO 8601 format
         - Date: Current date
         - Time: Current time (approximately)
       - **What Was Restored**:
         - Workspace Restored: true/false
         - Projects Restored: 5 (count)
         - Tasks Restored: 20 (count)
         - Workspace Settings Restored: true/false
         - Members Restored: true/false (if applicable)
         - Members Restored Count: 3 (if applicable)
         - Restore Type: "complete", "selective", or similar

4. Verify log entry structure:
   - Verify log entry is a valid JSON object or map
   - Verify all required fields are present
   - Verify no required fields are null or empty
   - Verify log entry can be parsed and displayed

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Restore audit trail is NOT implemented (missing)
- ✅ **When implemented**: Restore audit trail log entry contains all required information
- ✅ Who restored information is complete
- ✅ From which backup information is complete
- ✅ When restored information is complete
- ✅ What was restored information is complete
- ✅ Log entry structure is valid and complete

---

## Test Case 5: Restore Audit Trail - Multiple Restore Operations

**Objective**: Verify that restore audit trail logs multiple restore operations correctly, with each operation having its own log entry.

**Preconditions**:
- User is logged in as Account Holder or Admin
- At least 2 backup files exist in OneDrive
- Restore feature is implemented
- Audit logging is implemented
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. Perform first restore operation:
   - **If NOT implemented**: Restore feature is not available (this is expected - feature missing)
   - **If implemented**: 
     - Select first backup file from the list
     - Note backup file ID and date
     - Tap on "Restore" button
     - Verify permission check passes
     - Confirm restore
     - Wait for restore to complete
     - Note the time: Restore 1 completed at 10:00 AM

3. Wait a few minutes:
   - Wait at least 2-3 minutes between restores
   - This ensures timestamps are different

4. Perform second restore operation:
   - Navigate back to backup/restore screen
   - Select second backup file from the list
   - Note backup file ID and date (different from first)
   - Tap on "Restore" button
   - Verify permission check passes
   - Confirm restore
   - Wait for restore to complete
   - Note the time: Restore 2 completed at 10:05 AM

5. Verify multiple restore log entries:
   - Navigate to audit log or activity log screen
   - **If NOT implemented**: Audit log is not available (this is expected - feature missing)
   - **If implemented**: 
     - Find restore log entries (should be at least 2 entries)
     - Verify each restore operation has its own log entry
     - Verify log entries are ordered by timestamp (most recent first)
     - Verify first restore log entry (Restore 2):
       - Backup File ID: Matches second backup file
       - Timestamp: Approximately 10:05 AM
       - User information: Matches current user
     - Verify second restore log entry (Restore 1):
       - Backup File ID: Matches first backup file
       - Timestamp: Approximately 10:00 AM
       - User information: Matches current user

6. Verify log entries are distinct:
   - Verify each log entry has unique timestamp
   - Verify each log entry has different backup file information
   - Verify log entries are not duplicated
   - Verify log entries can be distinguished from each other

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Restore audit trail is NOT implemented (missing)
- ✅ **When implemented**: Multiple restore operations are logged correctly
- ✅ Each restore operation has its own log entry
- ✅ Log entries are ordered by timestamp
- ✅ Log entries contain correct information for each restore
- ✅ Log entries are distinct and not duplicated

---

## Test Case 6: Restore Audit Trail - Different Users Restore

**Objective**: Verify that restore audit trail logs different users who perform restore operations correctly.

**Preconditions**:
- Two users are available:
  - User 1: Account Holder, name "Admin User", ID "user-admin-1"
  - User 2: Admin, name "Manager User", ID "user-admin-2"
- At least one backup file exists in OneDrive
- Restore feature is implemented
- Audit logging is implemented

**Steps**:
1. First user performs restore:
   - Log in as User 1 (Account Holder)
   - Navigate to backup/restore screen
   - **If NOT implemented**: Restore feature is not available (this is expected - feature missing)
   - **If implemented**: 
     - Select backup file
     - Tap on "Restore" button
     - Verify permission check passes
     - Confirm restore
     - Wait for restore to complete
     - Note: Restore 1 by User 1

2. Log out and log in as second user:
   - Log out from User 1
   - Log in as User 2 (Admin)
   - Navigate to backup/restore screen

3. Second user performs restore:
   - Select backup file (can be same or different)
   - Tap on "Restore" button
   - Verify permission check passes
   - Confirm restore
   - Wait for restore to complete
   - Note: Restore 2 by User 2

4. Verify restore log entries for different users:
   - Navigate to audit log or activity log screen
   - **If NOT implemented**: Audit log is not available (this is expected - feature missing)
   - **If implemented**: 
     - Find restore log entries (should be at least 2 entries)
     - Verify first restore log entry (Restore 2):
       - User ID: "user-admin-2" (matches User 2)
       - User Name: "Manager User" (matches User 2)
       - User Role: "admin" (matches User 2)
     - Verify second restore log entry (Restore 1):
       - User ID: "user-admin-1" (matches User 1)
       - User Name: "Admin User" (matches User 1)
       - User Role: "account_holder" (matches User 1)

5. Verify user information is accurate:
   - Verify each log entry correctly identifies the user who performed restore
   - Verify user information matches the user who was logged in during restore
   - Verify user information is not mixed up between log entries

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Restore audit trail is NOT implemented (missing)
- ✅ **When implemented**: Different users' restore operations are logged correctly
- ✅ Each log entry correctly identifies the user who performed restore
- ✅ User information is accurate for each restore
- ✅ User information is not mixed up between log entries

---

## Test Case 7: Restore Audit Trail - Failed Restore Logging

**Objective**: Verify that restore audit trail logs failed restore operations with error information.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Invalid or corrupted backup file exists in OneDrive (or can be simulated)
- Restore feature is implemented
- Audit logging is implemented
- User is on the backup/restore screen

**Steps**:
1. Navigate to backup/restore screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Restore" or "Restore" option
   - Verify restore screen is displayed

2. Attempt restore with failure:
   - **If NOT implemented**: Restore feature is not available (this is expected - feature missing)
   - **If implemented**: 
     - Select invalid/corrupted backup file
     - OR Simulate restore failure (e.g., disconnect network)
     - Tap on "Restore" button
     - Verify permission check passes
     - Confirm restore
     - Wait for restore to fail
     - Note error message displayed

3. Verify failed restore is logged:
   - Navigate to audit log or activity log screen
   - **If NOT implemented**: Audit log is not available (this is expected - feature missing)
   - **If implemented**: 
     - Find restore log entry (most recent entry)
     - Verify log entry indicates restore failure:
       - **Status**: "failed" or "error"
       - **Error Message**: Contains error description
       - **Error Code**: Error code (if available)
     - Verify log entry still contains:
       - Who attempted restore (user information)
       - From which backup (backup file information)
       - When restore was attempted (timestamp)
     - Verify log entry may not contain "What was restored" (since restore failed)

4. Verify error information is useful:
   - Verify error message is clear and actionable
   - Verify error information helps identify the cause of failure
   - Verify error information is not too technical for end users

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Failed restore logging is NOT implemented (missing)
- ✅ **When implemented**: Failed restore operations are logged
- ✅ Log entry indicates restore failure
- ✅ Error message is logged
- ✅ User, backup, and timestamp information is still logged
- ✅ Error information is useful for troubleshooting

---

## Test Case 8: Restore Audit Trail - Log Entry Viewing and Filtering

**Objective**: Verify that restore audit trail log entries can be viewed and filtered in audit log UI.

**Preconditions**:
- User is logged in as Account Holder or Admin
- At least 2 restore operations have been performed (with different users, backups, or dates)
- Restore feature is implemented
- Audit logging is implemented
- Audit log viewing UI is implemented
- User has permission to view audit logs

**Steps**:
1. Navigate to audit log screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Audit Log" or "Activity Log" option
   - **If NOT implemented**: Audit log screen is not available (this is expected - feature missing)
   - **If implemented**: 
     - Verify audit log screen is displayed
     - Verify list of log entries is displayed

2. View restore log entries:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Verify restore log entries are displayed in the list
     - Verify each log entry shows:
       - Who restored (user name or ID)
       - From which backup (backup file name or date)
       - When restored (timestamp or date)
       - What was restored (summary or details)
     - Verify log entries are ordered by timestamp (most recent first)

3. Filter restore log entries:
   - **If NOT implemented**: Filtering is not available (this is expected - feature missing)
   - **If implemented**: 
     - Tap on "Filter" or filter icon
     - Verify filter options are available:
       - Filter by action type: "restore" or "backup_restore"
       - Filter by user: Select specific user
       - Filter by date range: Select start and end date
       - Filter by backup file: Select specific backup file
     - Apply filter (e.g., filter by "restore" action type)
     - Verify only restore log entries are displayed
     - Verify other log entries are hidden

4. Search restore log entries:
   - **If NOT implemented**: Search is not available (this is expected - feature missing)
   - **If implemented**: 
     - Tap on search field
     - Enter search term (e.g., backup file name, user name)
     - Verify matching restore log entries are displayed
     - Verify search works correctly

5. View restore log entry details:
   - **If NOT implemented**: Details view is not available (this is expected - feature missing)
   - **If implemented**: 
     - Tap on a restore log entry
     - Verify log entry details are displayed:
       - Complete user information
       - Complete backup file information
       - Complete timestamp information
       - Complete restore details (what was restored)
       - Error information (if restore failed)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Restore audit trail viewing is NOT implemented (missing)
- ✅ **When implemented**: Restore log entries can be viewed in audit log UI
- ✅ Log entries are displayed correctly
- ✅ Log entries can be filtered
- ✅ Log entries can be searched
- ✅ Log entry details can be viewed
- ✅ UI is user-friendly and accessible

---

## Test Case 9: Restore Audit Trail - Log Entry Export

**Objective**: Verify that restore audit trail log entries can be exported (if export feature is implemented).

**Preconditions**:
- User is logged in as Account Holder or Admin
- At least 2 restore operations have been performed
- Restore feature is implemented
- Audit logging is implemented
- Audit log viewing UI is implemented
- Export feature is implemented (optional)

**Steps**:
1. Navigate to audit log screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Audit Log" or "Activity Log" option
   - **If NOT implemented**: Audit log screen is not available (this is expected - feature missing)
   - **If implemented**: 
     - Verify audit log screen is displayed

2. Export restore log entries:
   - **If NOT implemented**: Export is not available (this is expected - feature missing)
   - **If implemented**: 
     - Tap on "Export" or export icon
     - Verify export options are available:
       - Export format: CSV, JSON, Excel, PDF
       - Export scope: All entries, Filtered entries, Selected entries
       - Date range: All time, Last 30 days, Custom range
     - Select export options (e.g., CSV format, All restore entries)
     - Tap "Export" or "Download"
     - Wait for export to complete

3. Verify exported file:
   - Download exported file
   - Open exported file
   - Verify exported file contains restore log entries:
     - Each restore operation is a row (CSV/Excel) or entry (JSON)
     - Columns/fields include:
       - Who restored (user ID, name, role)
       - From which backup (backup file ID, name, date)
       - When restored (timestamp)
       - What was restored (details)
     - Verify data is accurate and matches audit log entries

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Restore audit trail export is NOT implemented (missing)
- ✅ **When implemented**: Restore log entries can be exported
- ✅ Export formats are available (CSV, JSON, Excel, PDF)
- ✅ Export scope options work correctly
- ✅ Exported file contains accurate restore log data
- ✅ Exported file is properly formatted

---

## Test Case 10: Restore Audit Trail - Log Entry Retention

**Objective**: Verify that restore audit trail log entries are retained for appropriate period and not deleted prematurely.

**Preconditions**:
- User is logged in as Account Holder or Admin
- At least one restore operation was performed 30+ days ago (if possible)
- Restore feature is implemented
- Audit logging is implemented
- Audit log retention policy is configured (if implemented)

**Steps**:
1. Navigate to audit log screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Audit Log" or "Activity Log" option
   - **If NOT implemented**: Audit log screen is not available (this is expected - feature missing)
   - **If implemented**: 
     - Verify audit log screen is displayed

2. Verify old restore log entries are retained:
   - **If NOT implemented**: Retention policy is not implemented (this is expected - feature missing)
   - **If implemented**: 
     - Navigate to older log entries (if available)
     - OR Filter by date range to include old entries
     - Verify restore log entries from 30+ days ago are still present
     - Verify restore log entries are not deleted prematurely
     - Verify log entries are accessible and viewable

3. Verify retention policy (if configured):
   - Check audit log retention settings (if available)
   - Verify retention period is configured (e.g., 90 days, 1 year, indefinite)
   - Verify retention policy is applied correctly
   - Verify log entries older than retention period are handled appropriately (archived or deleted)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Restore audit trail retention is NOT implemented (missing)
- ✅ **When implemented**: Restore log entries are retained for appropriate period
- ✅ Old log entries are not deleted prematurely
- ✅ Retention policy is configurable
- ✅ Retention policy is applied correctly

---

## Summary

### Current Status: ⛔ MISSING
Restore audit trail feature is currently **NOT IMPLEMENTED**. No logging system exists to track restore operations with information about who restored, from which backup, and when.

### What Needs to Be Implemented:
1. ✅ Restore audit log entity/service
2. ✅ Logging who restored (user ID, name, role)
3. ✅ Logging from which backup (backup file ID, name, date)
4. ✅ Logging when restored (timestamp)
5. ✅ Logging what was restored (details)
6. ✅ Logging failed restore operations
7. ✅ Audit log viewing UI
8. ✅ Audit log filtering and search
9. ✅ Audit log export (optional)
10. ✅ Audit log retention policy

### Test Execution Notes:
- All test cases should be executed after implementation
- Test cases marked as "Missing Feature" should be updated once implemented
- Focus on complete and accurate logging
- Test with various restore scenarios
- Test with different users
- Verify log entries are accessible and useful

### Security and Compliance Considerations:
- **Critical**: Restore audit trail is essential for security and compliance
- Audit logs must be tamper-proof (read-only after creation)
- Audit logs must be accessible to Account Holders and Admins
- Audit logs should be retained for compliance requirements
- Audit logs should be exportable for compliance reporting
