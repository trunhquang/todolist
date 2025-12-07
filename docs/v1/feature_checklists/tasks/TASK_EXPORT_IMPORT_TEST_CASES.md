# Task Export/Import Subset (Backup Linkage) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Task Export/Import Subset (Backup Linkage)** feature. This feature is currently **MISSING** - Not implemented; no export/import flow.

## Prerequisites
- User must be logged in
- Workspace should exist
- Tasks should exist
- User should have permission to export/import (Account Holder/Admin)
- OneDrive integration should be configured (for backup linkage)

---

## Test Case 1: Export Tasks to JSON - Missing Feature

**Objective**: Verify tasks can be exported to JSON format (currently missing).

**Preconditions**:
- User is logged in
- Tasks exist in workspace
- User has export permission
- Export feature is implemented

**Steps**:
1. Navigate to Task List page
2. Verify one of the following:
   - **If NOT implemented**: No export option (this is expected - feature missing)
   - **If implemented**: Export option exists
3. If implemented:
   - Tap "Export" button or menu option
   - Select export format: JSON
   - Select export options:
     - Workspace: Current workspace
     - Date range: All tasks or specific range
     - Status: All statuses or specific status
     - Project: All projects or specific project
   - Tap "Export" button
   - Verify export process:
     - Loading indicator appears
     - Export completes
     - Success message is shown
   - Verify exported file:
     - File is created (JSON format)
     - File contains task data
     - File includes metadata (export date, workspace, etc.)

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Tasks can be exported to JSON
- ✅ Export includes selected tasks
- ✅ File is generated correctly

---

## Test Case 2: Export Tasks to Excel - Missing Feature

**Objective**: Verify tasks can be exported to Excel format (currently missing).

**Preconditions**:
- User is logged in
- Tasks exist in workspace
- User has export permission
- Excel export is implemented

**Steps**:
1. Navigate to Task List page
2. Verify one of the following:
   - **If NOT implemented**: No Excel export option (this is expected - feature missing)
   - **If implemented**: Excel export option exists
3. If implemented:
   - Tap "Export" button
   - Select export format: Excel
   - Configure export options
   - Tap "Export" button
   - Verify export process:
     - Export completes successfully
     - Excel file is generated
   - Verify Excel file:
     - File can be opened in Excel
     - File contains task data in columns
     - Headers are correct
     - Data is formatted correctly

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Tasks can be exported to Excel
- ✅ Excel file is generated correctly
- ✅ File can be opened and viewed

---

## Test Case 3: Export Tasks to CSV - Missing Feature

**Objective**: Verify tasks can be exported to CSV format (currently missing).

**Preconditions**:
- User is logged in
- Tasks exist in workspace
- User has export permission
- CSV export is implemented

**Steps**:
1. Navigate to Task List page
2. Verify one of the following:
   - **If NOT implemented**: No CSV export option (this is expected - feature missing)
   - **If implemented**: CSV export option exists
3. If implemented:
   - Tap "Export" button
   - Select export format: CSV
   - Configure export options
   - Tap "Export" button
   - Verify export process:
     - Export completes successfully
     - CSV file is generated
   - Verify CSV file:
     - File can be opened in spreadsheet app
     - File contains task data
     - Headers are correct
     - Data is comma-separated correctly

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Tasks can be exported to CSV
- ✅ CSV file is generated correctly
- ✅ File can be opened and viewed

---

## Test Case 4: Export Filtered Tasks - Missing Feature

**Objective**: Verify only filtered tasks are exported (currently missing).

**Preconditions**:
- User is logged in
- Multiple tasks exist with different statuses/priorities/projects
- Export with filters is implemented

**Steps**:
1. Navigate to Task List page
2. Apply filters:
   - Status: Completed
   - Priority: High
   - Project: Project A
3. Verify one of the following:
   - **If NOT implemented**: Cannot export filtered tasks (this is expected - feature missing)
   - **If implemented**: Export respects filters
4. If implemented:
   - Tap "Export" button
   - Verify export options show current filters
   - Tap "Export" button
   - Verify exported file:
     - Only filtered tasks are included
     - Tasks match filter criteria
     - All filtered tasks are included

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Export respects filters
- ✅ Only filtered tasks are exported
- ✅ Export is accurate

---

## Test Case 5: Export Tasks with Date Range - Missing Feature

**Objective**: Verify tasks can be exported for specific date range (currently missing).

**Preconditions**:
- User is logged in
- Tasks exist with different creation dates
- Date range export is implemented

**Steps**:
1. Navigate to Task List page
2. Tap "Export" button
3. Verify one of the following:
   - **If NOT implemented**: No date range option (this is expected - feature missing)
   - **If implemented**: Date range option exists
4. If implemented:
   - Select date range:
     - From: 1 month ago
     - To: Today
   - Tap "Export" button
   - Verify exported file:
     - Only tasks within date range are included
     - Tasks outside range are excluded
     - Date range is accurate

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Date range export works
- ✅ Only tasks in range are exported

---

## Test Case 6: Export Tasks to OneDrive - Missing Feature

**Objective**: Verify tasks can be exported directly to OneDrive (backup linkage) (currently missing).

**Preconditions**:
- User is logged in
- OneDrive is configured
- User has export permission
- OneDrive export is implemented

**Steps**:
1. Navigate to Task List page
2. Tap "Export" button
3. Verify one of the following:
   - **If NOT implemented**: No OneDrive export option (this is expected - feature missing)
   - **If implemented**: OneDrive export option exists
4. If implemented:
   - Select export destination: OneDrive
   - Configure export options
   - Tap "Export to OneDrive" button
   - Verify export process:
     - Export completes
     - File is uploaded to OneDrive
     - Success message is shown
   - Verify OneDrive file:
     - File exists in OneDrive backup folder
     - File can be downloaded
     - File contains correct data

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Tasks can be exported to OneDrive
- ✅ File is uploaded successfully
- ✅ File is accessible in OneDrive

---

## Test Case 7: Import Tasks from JSON - Missing Feature

**Objective**: Verify tasks can be imported from JSON file (currently missing).

**Preconditions**:
- User is logged in
- JSON file with task data exists
- User has import permission
- Import feature is implemented

**Steps**:
1. Navigate to Task List page or Settings page
2. Verify one of the following:
   - **If NOT implemented**: No import option (this is expected - feature missing)
   - **If implemented**: Import option exists
3. If implemented:
   - Tap "Import" button
   - Select import source: File
   - Select JSON file
   - Configure import options:
     - Workspace: Select workspace
     - Conflict resolution: Skip/Overwrite/Merge
   - Tap "Import" button
   - Verify import process:
     - Loading indicator appears
     - Import completes
     - Success message is shown
   - Verify imported tasks:
     - Tasks are created in workspace
     - Tasks have correct data
     - Tasks are visible in task list

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Tasks can be imported from JSON
- ✅ Import works correctly
- ✅ Tasks are created correctly

---

## Test Case 8: Import Tasks from Excel - Missing Feature

**Objective**: Verify tasks can be imported from Excel file (currently missing).

**Preconditions**:
- User is logged in
- Excel file with task data exists
- User has import permission
- Excel import is implemented

**Steps**:
1. Navigate to Task List page or Settings page
2. Tap "Import" button
3. Verify one of the following:
   - **If NOT implemented**: No Excel import option (this is expected - feature missing)
   - **If implemented**: Excel import option exists
4. If implemented:
   - Select import source: File
   - Select Excel file
   - Configure import options:
     - Column mapping (if needed)
     - Workspace selection
     - Conflict resolution
   - Tap "Import" button
   - Verify import process:
     - Import completes
     - Success message is shown
   - Verify imported tasks:
     - Tasks are created correctly
     - Data is mapped correctly
     - Tasks are visible

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Tasks can be imported from Excel
- ✅ Import works correctly
- ✅ Data mapping is accurate

---

## Test Case 9: Import Tasks from CSV - Missing Feature

**Objective**: Verify tasks can be imported from CSV file (currently missing).

**Preconditions**:
- User is logged in
- CSV file with task data exists
- User has import permission
- CSV import is implemented

**Steps**:
1. Navigate to Task List page or Settings page
2. Tap "Import" button
3. Verify one of the following:
   - **If NOT implemented**: No CSV import option (this is expected - feature missing)
   - **If implemented**: CSV import option exists
4. If implemented:
   - Select import source: File
   - Select CSV file
   - Configure import options:
     - Column mapping
     - Workspace selection
     - Conflict resolution
   - Tap "Import" button
   - Verify import process:
     - Import completes
     - Success message is shown
   - Verify imported tasks:
     - Tasks are created correctly
     - Data is parsed correctly
     - Tasks are visible

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Tasks can be imported from CSV
- ✅ Import works correctly
- ✅ Data parsing is accurate

---

## Test Case 10: Import Tasks from OneDrive Backup - Missing Feature

**Objective**: Verify tasks can be imported from OneDrive backup file (currently missing).

**Preconditions**:
- User is logged in
- Backup file exists in OneDrive
- User has import permission
- OneDrive import is implemented

**Steps**:
1. Navigate to Task List page or Settings page
2. Tap "Import" button
3. Verify one of the following:
   - **If NOT implemented**: No OneDrive import option (this is expected - feature missing)
   - **If implemented**: OneDrive import option exists
4. If implemented:
   - Select import source: OneDrive
   - Browse backup files
   - Select backup file
   - Preview backup contents:
     - Show number of tasks
     - Show backup date
     - Show workspace info
   - Configure import options:
     - Workspace selection
     - Conflict resolution
   - Tap "Import" button
   - Verify import process:
     - Import completes
     - Success message is shown
   - Verify imported tasks:
     - Tasks are created correctly
     - Tasks match backup data

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Tasks can be imported from OneDrive
- ✅ Import works correctly
- ✅ Backup linkage works

---

## Test Case 11: Export/Import Task Metadata - Missing Feature

**Objective**: Verify task metadata is included in export/import (currently missing).

**Preconditions**:
- User is logged in
- Tasks with full metadata exist
- Export/import is implemented

**Steps**:
1. Export tasks to JSON
2. Verify exported file includes:
   - Task ID
   - Title, description
   - Status, priority, type
   - Deadline
   - Assignee, assigner
   - Project ID
   - Created date, updated date
   - Recurring config
   - Tags (if implemented)
   - Checklist (if implemented)
   - Attachments (if implemented)
3. Import the exported file
4. Verify imported tasks:
   - All metadata is preserved
   - Data matches original tasks

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Metadata is included in export/import
- ✅ All fields are preserved

---

## Test Case 12: Conflict Resolution During Import - Missing Feature

**Objective**: Verify conflict resolution works during import (currently missing).

**Preconditions**:
- User is logged in
- Task with same ID exists in workspace
- Import file contains task with same ID
- Conflict resolution is implemented

**Steps**:
1. Create a task in workspace (Task A)
2. Export tasks to file
3. Modify Task A in exported file
4. Import the file back
5. Verify one of the following:
   - **If NOT implemented**: Conflict is not handled (this is expected - feature missing)
   - **If implemented**: Conflict resolution works
6. If implemented:
   - Verify conflict detection:
     - System detects duplicate task ID
     - Conflict resolution dialog is shown
   - Verify resolution options:
     - "Skip" - existing task is kept
     - "Overwrite" - existing task is replaced
     - "Create New" - new task is created with new ID
   - Test each option:
     - Select "Skip" - verify existing task unchanged
     - Select "Overwrite" - verify task is updated
     - Select "Create New" - verify new task is created

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Conflict resolution works
- ✅ All resolution options work correctly

---

## Test Case 13: Export Progress Indicator - Missing Feature

**Objective**: Verify export progress is shown to user (currently missing).

**Preconditions**:
- User is logged in
- Large number of tasks exist
- Export progress indicator is implemented

**Steps**:
1. Navigate to Task List page
2. Tap "Export" button
3. Start export
4. Verify one of the following:
   - **If NOT implemented**: No progress indicator (this is expected - feature missing)
   - **If implemented**: Progress indicator is shown
5. If implemented:
   - Verify progress display:
     - Progress bar or percentage is shown
     - Progress updates during export
     - Progress reaches 100% when complete
   - Verify cancellation:
     - Can cancel export
     - Cancellation works correctly

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Progress indicator is shown
- ✅ Progress is accurate
- ✅ Cancellation works

---

## Test Case 14: Import Validation - Missing Feature

**Objective**: Verify imported data is validated (currently missing).

**Preconditions**:
- User is logged in
- Invalid task data file exists
- Import validation is implemented

**Steps**:
1. Create invalid task data file:
   - Missing required fields
   - Invalid data types
   - Invalid enum values
2. Attempt to import file
3. Verify one of the following:
   - **If NOT implemented**: Invalid data is imported (this is expected - validation missing)
   - **If implemented**: Validation works
4. If implemented:
   - Verify validation errors:
     - Errors are shown for invalid data
     - Invalid tasks are skipped or rejected
     - Valid tasks are imported
   - Verify error messages:
     - Error messages are clear
     - User knows which tasks failed
     - User can fix and retry

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Validation works correctly
- ✅ Invalid data is rejected
- ✅ Error messages are helpful

---

## Test Case 15: Export/Import Permission Check - Missing Feature

**Objective**: Verify only authorized users can export/import (currently missing).

**Preconditions**:
- User is logged in
- User has Member role (not Admin/Account Holder)
- Permission check is implemented

**Steps**:
1. Navigate to Task List page
2. Verify one of the following:
   - **If NOT implemented**: Export/import option is visible to all users (this is expected - permission check missing)
   - **If implemented**: Permission check works
3. If implemented:
   - Verify for Member:
     - Export/import option is hidden or disabled
     - Cannot access export/import
   - Verify for Admin/Account Holder:
     - Export/import option is visible
     - Can access export/import
   - Verify permission error:
     - Error message is shown if unauthorized user tries to export/import
     - Error message is clear

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Permission check works
- ✅ Only authorized users can export/import

---

## Test Case 16: Export/Import Workspace Scoping - Missing Feature

**Objective**: Verify export/import is scoped to workspace (currently missing).

**Preconditions**:
- User is logged in
- User has access to multiple workspaces
- Tasks exist in different workspaces
- Workspace scoping is implemented

**Steps**:
1. Switch to Workspace A
2. Export tasks
3. Verify exported file:
   - Only tasks from Workspace A are included
   - Tasks from other workspaces are excluded
4. Switch to Workspace B
5. Import the file
6. Verify imported tasks:
   - Tasks are imported to Workspace B
   - Tasks have correct workspaceId
   - Tasks are not visible in other workspaces

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Workspace scoping works
- ✅ Data isolation is maintained

---

## Test Case 17: Export/Import Large Dataset - Missing Feature

**Objective**: Verify export/import works with large number of tasks (currently missing).

**Preconditions**:
- User is logged in
- Large number of tasks exist (1000+ tasks)
- Large dataset handling is implemented

**Steps**:
1. Navigate to Task List page
2. Export all tasks
3. Verify one of the following:
   - **If NOT implemented**: Export may fail or be slow (this is expected - optimization missing)
   - **If implemented**: Export works efficiently
4. If implemented:
   - Verify export performance:
     - Export completes in reasonable time
     - Memory usage is acceptable
     - No crashes or errors
   - Verify import performance:
     - Import completes in reasonable time
     - Memory usage is acceptable
     - All tasks are imported correctly

**Expected Results**:
- ⛔ **CURRENT STATUS**: Feature is NOT implemented (missing)
- ✅ **When implemented**: Large dataset export/import works
- ✅ Performance is acceptable

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Export to JSON works (missing)
- [ ] Export to Excel works (missing)
- [ ] Export to CSV works (missing)
- [ ] Export filtered tasks works (missing)
- [ ] Export with date range works (missing)
- [ ] Export to OneDrive works (missing)
- [ ] Import from JSON works (missing)
- [ ] Import from Excel works (missing)
- [ ] Import from CSV works (missing)
- [ ] Import from OneDrive works (missing)
- [ ] Metadata is preserved (missing)
- [ ] Conflict resolution works (missing)
- [ ] Progress indicator works (missing)
- [ ] Validation works (missing)
- [ ] Permission check works (missing)
- [ ] Workspace scoping works (missing)
- [ ] Large dataset handling works (missing)

---

## Known Issues (Based on Audit Report)

1. **Feature Not Implemented**:
   - No export/import flow
   - No export formats (JSON, Excel, CSV)
   - No import functionality
   - No backup linkage
   - **Status**: ⛔ Missing

2. **Partial Implementation**:
   - `BackupService.exportDataToOneDrive()` exists but is empty
   - `BackupService.exportReportsToOneDrive()` works for reports
   - `OneDriveService` has backup/restore methods
   - `BackupController` exists

---

## Notes for Testers

1. **Current Status**: Export/import subset tasks is completely missing:
   - No export functionality for tasks
   - No import functionality for tasks
   - No format support (JSON, Excel, CSV)
   - No backup linkage

2. **Existing Components**: Some components exist but may not be functional:
   - `BackupService` exists but `exportDataToOneDrive()` is empty
   - `OneDriveService` has backup methods but may not be used for tasks
   - `BackupController` exists but may not have task export/import

3. **Design Considerations**: When implementing, consider:
   - Multiple export formats (JSON, Excel, CSV)
   - Filtering and date range selection
   - OneDrive integration for backup
   - Import with conflict resolution
   - Validation and error handling
   - Permission checks
   - Workspace scoping
   - Large dataset handling

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
- Whether export/import feature exists
- Whether formats are supported
- Whether backup linkage works
- File size and number of tasks
