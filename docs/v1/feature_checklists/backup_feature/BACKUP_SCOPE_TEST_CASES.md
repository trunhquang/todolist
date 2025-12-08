# Backup Scope: Tasks, Projects, Workspace Settings, Members - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Backup Scope** feature. Currently, this feature is **MISSING** - Not implemented; no data selection or packaging logic for tasks, projects, workspace settings, and members.

## Prerequisites
- User must be logged in
- User must have Account Holder or Admin role
- Workspace must exist
- At least one task should exist in the workspace
- At least one project should exist in the workspace
- Workspace settings should be configured
- At least one workspace member should exist (optional for backup)
- OneDrive authentication should be configured
- Backup feature UI should be accessible

---

## Test Case 1: Backup Scope - Tasks Included - Missing Feature

**Objective**: Verify that tasks are included in the backup data when creating a backup.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Current workspace has at least 3 tasks with different statuses (pending, in_progress, completed)
- Tasks have different properties:
  - Task 1: Title "Test Task 1", Status "pending", Priority "high", Type "daily"
  - Task 2: Title "Test Task 2", Status "in_progress", Priority "medium", Type "project", has projectId
  - Task 3: Title "Test Task 3", Status "completed", Priority "low", Type "weekly", has deadline
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Verify backup scope options:
   - **If NOT implemented**: Backup scope selection is not visible (this is expected - feature missing)
   - **If implemented**: Verify backup scope includes "Tasks" option:
     - Checkbox or toggle for "Include Tasks" is visible
     - Option is checked by default
     - Option can be toggled on/off

3. If implemented, create backup with tasks:
   - Ensure "Include Tasks" is checked
   - Tap on "Create Backup" or "Backup Now" button
   - Wait for backup process to complete
   - Verify success message is displayed

4. Verify backup file contains tasks:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Verify backup file structure:
     - Root object contains "tasks" array
     - "tasks" array contains all 3 tasks
   - Verify each task contains required fields:
     - Task 1: id, title ("Test Task 1"), status ("pending"), priority ("high"), taskType ("daily"), workspaceId
     - Task 2: id, title ("Test Task 2"), status ("in_progress"), priority ("medium"), taskType ("project"), projectId, workspaceId
     - Task 3: id, title ("Test Task 3"), status ("completed"), priority ("low"), taskType ("weekly"), deadline, workspaceId
   - Verify sensitive data is NOT included:
     - No token fields
     - No deviceId fields
     - No internal system fields

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Tasks backup is NOT implemented (missing)
- ✅ **When implemented**: Tasks are included in backup file
- ✅ All task fields are correctly backed up
- ✅ Sensitive data (tokens, deviceId) is excluded
- ✅ Backup file structure is valid JSON

---

## Test Case 2: Backup Scope - Projects Included - Missing Feature

**Objective**: Verify that projects are included in the backup data when creating a backup.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Current workspace has at least 2 projects with different statuses
- Projects have different properties:
  - Project 1: Title "Test Project 1", Status "pending", has description, has deadline
  - Project 2: Title "Test Project 2", Status "completed", no description, no deadline
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Verify backup scope options:
   - **If NOT implemented**: Backup scope selection is not visible (this is expected - feature missing)
   - **If implemented**: Verify backup scope includes "Projects" option:
     - Checkbox or toggle for "Include Projects" is visible
     - Option is checked by default
     - Option can be toggled on/off

3. If implemented, create backup with projects:
   - Ensure "Include Projects" is checked
   - Tap on "Create Backup" or "Backup Now" button
   - Wait for backup process to complete
   - Verify success message is displayed

4. Verify backup file contains projects:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Verify backup file structure:
     - Root object contains "projects" array
     - "projects" array contains all 2 projects
   - Verify each project contains required fields:
     - Project 1: id, title ("Test Project 1"), status ("pending"), description, deadline, workspaceId, createdAt
     - Project 2: id, title ("Test Project 2"), status ("completed"), workspaceId, createdAt
   - Verify sensitive data is NOT included:
     - No token fields
     - No deviceId fields
     - No internal system fields

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Projects backup is NOT implemented (missing)
- ✅ **When implemented**: Projects are included in backup file
- ✅ All project fields are correctly backed up
- ✅ Sensitive data (tokens, deviceId) is excluded
- ✅ Backup file structure is valid JSON

---

## Test Case 3: Backup Scope - Workspace Settings Included - Missing Feature

**Objective**: Verify that workspace settings are included in the backup data when creating a backup.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Current workspace has configured settings:
  - Description: "Test Workspace Description"
  - Logo URL: "https://example.com/logo.png"
  - Timezone: "Asia/Ho_Chi_Minh"
  - Language: "vi"
  - Date Format: "dd/MM/yyyy"
  - Time Format: "24h"
  - Currency: "VND"
  - Notifications: enabled
  - Auto Save: enabled
  - Theme: "dark"
  - Custom Fields: {"field1": "value1", "field2": "value2"}
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Verify backup scope options:
   - **If NOT implemented**: Backup scope selection is not visible (this is expected - feature missing)
   - **If implemented**: Verify backup scope includes "Workspace Settings" option:
     - Checkbox or toggle for "Include Workspace Settings" is visible
     - Option is checked by default
     - Option can be toggled on/off

3. If implemented, create backup with workspace settings:
   - Ensure "Include Workspace Settings" is checked
   - Tap on "Create Backup" or "Backup Now" button
   - Wait for backup process to complete
   - Verify success message is displayed

4. Verify backup file contains workspace settings:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Verify backup file structure:
     - Root object contains "workspace" object
     - "workspace" object contains "settings" object
   - Verify workspace settings contain all configured fields:
     - description: "Test Workspace Description"
     - logoUrl: "https://example.com/logo.png"
     - timezone: "Asia/Ho_Chi_Minh"
     - language: "vi"
     - dateFormat: "dd/MM/yyyy"
     - timeFormat: "24h"
     - currency: "VND"
     - notifications: true
     - autoSave: true
     - theme: "dark"
     - customFields: {"field1": "value1", "field2": "value2"}
   - Verify workspace basic info is included:
     - id, name, type, createdBy, createdAt
   - Verify sensitive data is NOT included:
     - No token fields
     - No deviceId fields
     - No internal system fields

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Workspace settings backup is NOT implemented (missing)
- ✅ **When implemented**: Workspace settings are included in backup file
- ✅ All workspace settings fields are correctly backed up
- ✅ Sensitive data (tokens, deviceId) is excluded
- ✅ Backup file structure is valid JSON

---

## Test Case 4: Backup Scope - Members Included (Optional) - Missing Feature

**Objective**: Verify that workspace members can be optionally included in the backup data when creating a backup.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Current workspace has at least 3 members:
  - Member 1: Account Holder, name "User 1", email "user1@example.com"
  - Member 2: Admin, name "User 2", email "user2@example.com"
  - Member 3: Member, name "User 3", email "user3@example.com"
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Verify backup scope options:
   - **If NOT implemented**: Backup scope selection is not visible (this is expected - feature missing)
   - **If implemented**: Verify backup scope includes "Members" option:
     - Checkbox or toggle for "Include Members" is visible
     - Option is NOT checked by default (optional)
     - Option can be toggled on/off

3. If implemented, create backup WITHOUT members:
   - Ensure "Include Members" is NOT checked
   - Tap on "Create Backup" or "Backup Now" button
   - Wait for backup process to complete
   - Verify success message is displayed

4. Verify backup file does NOT contain members:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Verify backup file structure:
     - Root object does NOT contain "members" array
     - OR "members" array is empty/null

5. Create backup WITH members:
   - Navigate back to backup/export screen
   - Ensure "Include Members" is checked
   - Tap on "Create Backup" or "Backup Now" button
   - Wait for backup process to complete
   - Verify success message is displayed

6. Verify backup file contains members:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Verify backup file structure:
     - Root object contains "members" array
     - "members" array contains all 3 members
   - Verify each member contains required fields:
     - Member 1: userId, workspaceId, role ("account_holder"), name ("User 1"), email ("user1@example.com"), joinedAt
     - Member 2: userId, workspaceId, role ("admin"), name ("User 2"), email ("user2@example.com"), joinedAt
     - Member 3: userId, workspaceId, role ("member"), name ("User 3"), email ("user3@example.com"), joinedAt
   - Verify sensitive data is NOT included:
     - No password fields
     - No token fields
     - No deviceId fields
     - No authentication tokens
     - Only metadata (name, email, role, permissions)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Members backup is NOT implemented (missing)
- ✅ **When implemented**: Members can be optionally included in backup file
- ✅ When included, all member metadata fields are correctly backed up
- ✅ Sensitive data (passwords, tokens, deviceId) is excluded
- ✅ Backup file structure is valid JSON

---

## Test Case 5: Backup Scope - Complete Backup (All Items) - Missing Feature

**Objective**: Verify that a complete backup includes all items (tasks, projects, workspace settings, and optionally members).

**Preconditions**:
- User is logged in as Account Holder or Admin
- Current workspace has:
  - At least 2 tasks
  - At least 2 projects
  - Configured workspace settings
  - At least 2 workspace members
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Configure complete backup:
   - **If NOT implemented**: Backup scope selection is not visible (this is expected - feature missing)
   - **If implemented**: 
     - Ensure "Include Tasks" is checked
     - Ensure "Include Projects" is checked
     - Ensure "Include Workspace Settings" is checked
     - Ensure "Include Members" is checked (optional)

3. Create complete backup:
   - Tap on "Create Backup" or "Backup Now" button
   - Wait for backup process to complete
   - Verify success message is displayed
   - Note the backup file name and timestamp

4. Verify complete backup file structure:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Verify backup file contains all sections:
     - Root object with metadata:
       - "workspaceId": current workspace ID
       - "exportedAt": ISO 8601 timestamp
       - "type": "complete" or "full"
       - "version": backup format version
     - "workspace" object:
       - Contains workspace basic info (id, name, type, etc.)
       - Contains "settings" object with all workspace settings
     - "tasks" array:
       - Contains all tasks in the workspace
       - Each task has all required fields
     - "projects" array:
       - Contains all projects in the workspace
       - Each project has all required fields
     - "members" array (if included):
       - Contains all workspace members
       - Each member has metadata fields only

5. Verify data integrity:
   - Count tasks in backup file matches tasks in workspace
   - Count projects in backup file matches projects in workspace
   - Workspace settings in backup match current workspace settings
   - If members included, count matches workspace members
   - All IDs are preserved correctly
   - All relationships are maintained (e.g., task.projectId matches project.id)

6. Verify sensitive data exclusion:
   - No token fields anywhere in backup file
   - No deviceId fields anywhere in backup file
   - No password fields anywhere in backup file
   - No authentication tokens anywhere in backup file
   - Only metadata and business data is included

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Complete backup is NOT implemented (missing)
- ✅ **When implemented**: Complete backup includes all selected items
- ✅ Backup file structure is valid and complete
- ✅ All data is correctly backed up
- ✅ Sensitive data is excluded
- ✅ Data integrity is maintained

---

## Test Case 6: Backup Scope - Partial Backup (Selected Items) - Missing Feature

**Objective**: Verify that a partial backup includes only selected items.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Current workspace has:
  - At least 2 tasks
  - At least 2 projects
  - Configured workspace settings
  - At least 2 workspace members
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Configure partial backup (Tasks only):
   - **If NOT implemented**: Backup scope selection is not visible (this is expected - feature missing)
   - **If implemented**: 
     - Ensure "Include Tasks" is checked
     - Ensure "Include Projects" is NOT checked
     - Ensure "Include Workspace Settings" is NOT checked
     - Ensure "Include Members" is NOT checked

3. Create partial backup (Tasks only):
   - Tap on "Create Backup" or "Backup Now" button
   - Wait for backup process to complete
   - Verify success message is displayed

4. Verify partial backup file (Tasks only):
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Verify backup file contains:
     - Root object with metadata
     - "tasks" array with all tasks
   - Verify backup file does NOT contain:
     - "projects" array (or empty/null)
     - "workspace.settings" (or empty/null)
     - "members" array (or empty/null)

5. Configure partial backup (Projects + Settings):
   - Navigate back to backup/export screen
   - Ensure "Include Tasks" is NOT checked
   - Ensure "Include Projects" is checked
   - Ensure "Include Workspace Settings" is checked
   - Ensure "Include Members" is NOT checked

6. Create partial backup (Projects + Settings):
   - Tap on "Create Backup" or "Backup Now" button
   - Wait for backup process to complete
   - Verify success message is displayed

7. Verify partial backup file (Projects + Settings):
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Verify backup file contains:
     - Root object with metadata
     - "projects" array with all projects
     - "workspace.settings" with all settings
   - Verify backup file does NOT contain:
     - "tasks" array (or empty/null)
     - "members" array (or empty/null)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Partial backup is NOT implemented (missing)
- ✅ **When implemented**: Partial backup includes only selected items
- ✅ Unselected items are excluded from backup
- ✅ Backup file structure is valid
- ✅ Data integrity is maintained for included items

---

## Test Case 7: Backup Scope - Empty Workspace Backup - Missing Feature

**Objective**: Verify that backup works correctly for an empty workspace (no tasks, no projects).

**Preconditions**:
- User is logged in as Account Holder or Admin
- Current workspace is empty:
  - No tasks
  - No projects
  - Workspace settings may or may not be configured
  - At least 1 workspace member (the Account Holder)
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Configure backup for empty workspace:
   - **If NOT implemented**: Backup scope selection is not visible (this is expected - feature missing)
   - **If implemented**: 
     - Ensure "Include Tasks" is checked
     - Ensure "Include Projects" is checked
     - Ensure "Include Workspace Settings" is checked
     - Ensure "Include Members" is checked (optional)

3. Create backup for empty workspace:
   - Tap on "Create Backup" or "Backup Now" button
   - Wait for backup process to complete
   - Verify success message is displayed (backup should succeed even with empty data)

4. Verify empty workspace backup file:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Verify backup file structure:
     - Root object with metadata
     - "workspace" object with workspace basic info
     - "tasks" array is empty array [] (not null, not missing)
     - "projects" array is empty array [] (not null, not missing)
     - "workspace.settings" may be null or empty object
     - "members" array (if included) contains at least the Account Holder

5. Verify backup file is valid:
   - Backup file is valid JSON
   - Backup file can be parsed without errors
   - Backup file structure is consistent with non-empty backups

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Empty workspace backup is NOT implemented (missing)
- ✅ **When implemented**: Empty workspace backup succeeds
- ✅ Backup file structure is valid
- ✅ Empty arrays are represented as [] (not null)
- ✅ Workspace basic info is always included

---

## Test Case 8: Backup Scope - Large Workspace Backup (Performance) - Missing Feature

**Objective**: Verify that backup works correctly for a large workspace with many items.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Current workspace has large amount of data:
  - At least 100 tasks
  - At least 50 projects
  - Configured workspace settings
  - At least 20 workspace members
- Backup feature is implemented
- User is on the backup/export screen
- Device has stable internet connection

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Configure complete backup:
   - **If NOT implemented**: Backup scope selection is not visible (this is expected - feature missing)
   - **If implemented**: 
     - Ensure "Include Tasks" is checked
     - Ensure "Include Projects" is checked
     - Ensure "Include Workspace Settings" is checked
     - Ensure "Include Members" is checked

3. Create backup for large workspace:
   - Note the start time
   - Tap on "Create Backup" or "Backup Now" button
   - Verify progress indicator is displayed (if implemented)
   - Wait for backup process to complete
   - Note the end time
   - Calculate backup duration
   - Verify success message is displayed

4. Verify backup performance:
   - Backup completes within reasonable time (< 5 minutes for 100 tasks + 50 projects)
   - Progress indicator updates (if implemented)
   - No memory errors or crashes
   - App remains responsive during backup

5. Verify large workspace backup file:
   - Download backup file from OneDrive
   - Verify file size is reasonable (< 10 MB for 100 tasks + 50 projects)
   - Open backup file (JSON format)
   - Verify backup file contains all items:
     - "tasks" array contains all 100+ tasks
     - "projects" array contains all 50+ projects
     - "members" array contains all 20+ members
   - Verify data integrity:
     - All tasks are present
     - All projects are present
     - All members are present
     - No data is missing or corrupted

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Large workspace backup is NOT implemented (missing)
- ✅ **When implemented**: Large workspace backup succeeds
- ✅ Backup completes within reasonable time
- ✅ Progress indicator is displayed (if implemented)
- ✅ All data is correctly backed up
- ✅ Backup file size is reasonable
- ✅ No performance issues or crashes

---

## Test Case 9: Backup Scope - Data Exclusion (Tokens, DeviceId) - Missing Feature

**Objective**: Verify that sensitive data (tokens, deviceId) is excluded from backup.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Current workspace has:
  - At least 1 task
  - At least 1 project
  - Configured workspace settings
  - At least 1 workspace member
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Create complete backup:
   - **If NOT implemented**: Backup scope selection is not visible (this is expected - feature missing)
   - **If implemented**: 
     - Ensure all scope options are checked
     - Tap on "Create Backup" or "Backup Now" button
     - Wait for backup process to complete
     - Verify success message is displayed

3. Verify sensitive data exclusion in backup file:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Search for sensitive data keywords:
     - Search for "token" (case-insensitive) - should NOT be found
     - Search for "deviceId" (case-insensitive) - should NOT be found
     - Search for "device_id" (case-insensitive) - should NOT be found
     - Search for "password" (case-insensitive) - should NOT be found
     - Search for "authToken" (case-insensitive) - should NOT be found
     - Search for "accessToken" (case-insensitive) - should NOT be found
     - Search for "refreshToken" (case-insensitive) - should NOT be found
   - Verify task objects do NOT contain:
     - token fields
     - deviceId fields
     - authentication fields
   - Verify project objects do NOT contain:
     - token fields
     - deviceId fields
     - authentication fields
   - Verify workspace object does NOT contain:
     - token fields
     - deviceId fields
     - authentication fields
   - Verify member objects do NOT contain:
     - password fields
     - token fields
     - deviceId fields
     - authentication tokens
     - Only metadata (name, email, role, permissions) is included

4. Verify only metadata is included:
   - Tasks contain: id, title, description, status, priority, taskType, workspaceId, assignee, assigner, projectId, deadline, createdAt, updatedAt
   - Projects contain: id, title, description, status, workspaceId, deadline, createdAt
   - Workspace contains: id, name, type, description, logoUrl, settings, createdBy, createdAt
   - Members contain: userId, workspaceId, role, name, email, permissions, joinedAt

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Data exclusion is NOT implemented (missing)
- ✅ **When implemented**: Sensitive data is excluded from backup
- ✅ Only metadata and business data is included
- ✅ No tokens, deviceId, or passwords in backup file
- ✅ Backup file is safe to share or store

---

## Test Case 10: Backup Scope - Backup File Format Validation - Missing Feature

**Objective**: Verify that backup file format is valid and follows expected structure.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Current workspace has:
  - At least 1 task
  - At least 1 project
  - Configured workspace settings
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Create backup:
   - **If NOT implemented**: Backup scope selection is not visible (this is expected - feature missing)
   - **If implemented**: 
     - Ensure all scope options are checked
     - Tap on "Create Backup" or "Backup Now" button
     - Wait for backup process to complete
     - Verify success message is displayed
     - Note the backup file name

3. Verify backup file format:
   - Download backup file from OneDrive
   - Verify file extension is ".json"
   - Verify file name format: "backup_YYYY-MM-DDTHH-MM-SS.json" or similar
   - Verify file is valid JSON:
     - File can be opened in JSON viewer/editor
     - File can be parsed without errors
     - File structure is valid JSON object

4. Verify backup file structure:
   - Root is a JSON object (not array)
   - Root object contains required metadata fields:
     - "workspaceId": string
     - "exportedAt": ISO 8601 timestamp string
     - "type": string ("complete", "full", or similar)
     - "version": string or number (backup format version)
   - Root object contains data sections:
     - "workspace": object (workspace info and settings)
     - "tasks": array (list of tasks)
     - "projects": array (list of projects)
     - "members": array (if included, list of members)

5. Verify data types:
   - All IDs are strings
   - All timestamps are ISO 8601 strings or numbers (milliseconds since epoch)
   - All booleans are boolean values (not strings)
   - All numbers are numbers (not strings)
   - All arrays are arrays (not objects)
   - All objects are objects (not arrays)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Backup file format validation is NOT implemented (missing)
- ✅ **When implemented**: Backup file format is valid JSON
- ✅ Backup file structure follows expected format
- ✅ All data types are correct
- ✅ Backup file can be parsed and validated

---

## Summary

### Current Status: ⛔ MISSING
All backup scope features are currently **NOT IMPLEMENTED**. The `exportDataToOneDrive()` method in `BackupService` is empty and does not include any data selection or packaging logic.

### What Needs to Be Implemented:
1. ✅ Data selection logic for tasks, projects, workspace settings, and members
2. ✅ Data packaging logic to create backup JSON structure
3. ✅ Sensitive data exclusion (tokens, deviceId)
4. ✅ Backup scope selection UI (checkboxes/toggles)
5. ✅ Backup file format validation
6. ✅ Progress indicator for large backups
7. ✅ Error handling for backup failures

### Test Execution Notes:
- All test cases should be executed after implementation
- Test cases marked as "Missing Feature" should be updated once implemented
- Focus on data integrity and sensitive data exclusion
- Test with various workspace sizes (empty, small, large)
- Verify backup file format and structure
