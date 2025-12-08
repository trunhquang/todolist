# Backup Data Exclusion: Token/DeviceId Exclusion - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Backup Data Exclusion** feature. Currently, this feature is **MISSING** - No backup logic to enforce exclusions of tokens, deviceId, and other sensitive data. Only metadata should be backed up.

## Prerequisites
- User must be logged in
- User must have Account Holder or Admin role
- Workspace must exist with data containing potential sensitive fields
- Backup feature should be implemented (or test cases should document expected behavior)
- OneDrive authentication should be configured
- Backup feature UI should be accessible

---

## Test Case 1: Token Exclusion - Authentication Tokens Not Backed Up

**Objective**: Verify that authentication tokens (ID token, FCM token, access token, refresh token) are excluded from backup.

**Preconditions**:
- User is logged in (authentication tokens exist in StorageService)
- Current workspace has:
  - At least 1 task
  - At least 1 project
  - Configured workspace settings
- FCM token is registered (if notification feature is implemented)
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Verify authentication tokens exist in app storage:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Check StorageService contains:
       - `user_token` (ID token from Firebase Auth)
       - `fcm_token` (FCM token for push notifications, if implemented)
     - Note: These tokens should NOT appear in backup file

3. Create backup:
   - **If NOT implemented**: Backup feature is not available (this is expected - feature missing)
   - **If implemented**: 
     - Ensure all scope options are checked
     - Tap on "Create Backup" or "Backup Now" button
     - Wait for backup process to complete
     - Verify success message is displayed

4. Verify authentication tokens are excluded from backup file:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Search for authentication token keywords (case-insensitive):
     - Search for "user_token" - should NOT be found
     - Search for "fcm_token" - should NOT be found
     - Search for "id_token" - should NOT be found
     - Search for "accessToken" - should NOT be found
     - Search for "refreshToken" - should NOT be found
     - Search for "authToken" - should NOT be found
   - Verify backup file structure:
     - Root object does NOT contain token fields
     - "workspace" object does NOT contain token fields
     - "tasks" array items do NOT contain token fields
     - "projects" array items do NOT contain token fields
     - "members" array items do NOT contain token fields

5. Verify only metadata is included:
   - Tasks contain business data only (id, title, description, status, etc.)
   - Projects contain business data only (id, title, description, status, etc.)
   - Workspace contains business data only (id, name, type, settings, etc.)
   - Members contain metadata only (userId, name, email, role, permissions)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Token exclusion is NOT implemented (missing)
- ✅ **When implemented**: Authentication tokens are excluded from backup
- ✅ No token fields appear in backup file
- ✅ Only metadata and business data is included
- ✅ Backup file is safe to share or store

---

## Test Case 2: DeviceId Exclusion - Device Identifiers Not Backed Up

**Objective**: Verify that device identifiers (deviceId, device_id) are excluded from backup.

**Preconditions**:
- User is logged in
- Device ID is registered (if notification feature is implemented)
- Current workspace has:
  - At least 1 task
  - At least 1 project
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Verify deviceId exists in app storage:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Check StorageService contains:
       - `device_id` (device identifier for push notifications)
     - Note: This deviceId should NOT appear in backup file

3. Create backup:
   - **If NOT implemented**: Backup feature is not available (this is expected - feature missing)
   - **If implemented**: 
     - Ensure all scope options are checked
     - Tap on "Create Backup" or "Backup Now" button
     - Wait for backup process to complete
     - Verify success message is displayed

4. Verify deviceId is excluded from backup file:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Search for device identifier keywords (case-insensitive):
     - Search for "deviceId" - should NOT be found
     - Search for "device_id" - should NOT be found
     - Search for "device-id" - should NOT be found
     - Search for "deviceIdentifier" - should NOT be found
   - Verify backup file structure:
     - Root object does NOT contain deviceId fields
     - "workspace" object does NOT contain deviceId fields
     - "tasks" array items do NOT contain deviceId fields
     - "projects" array items do NOT contain deviceId fields
     - "members" array items do NOT contain deviceId fields

5. Verify device information is not included:
   - No device model information
   - No device OS information
   - No device identifiers
   - Only business data and metadata is included

**Expected Results**:
- ⚠️ **CURRENT STATUS**: DeviceId exclusion is NOT implemented (missing)
- ✅ **When implemented**: Device identifiers are excluded from backup
- ✅ No deviceId fields appear in backup file
- ✅ Only metadata and business data is included
- ✅ Backup file is safe to share or store

---

## Test Case 3: Password Exclusion - User Passwords Not Backed Up

**Objective**: Verify that user passwords are excluded from backup, even if stored in secure storage.

**Preconditions**:
- User is logged in
- User credentials may be saved in CredentialService (secure storage)
- Current workspace has:
  - At least 1 task
  - At least 1 project
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Verify passwords exist in secure storage:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Check CredentialService contains:
       - `saved_user_password` (encrypted password in secure storage)
     - Note: This password should NOT appear in backup file

3. Create backup:
   - **If NOT implemented**: Backup feature is not available (this is expected - feature missing)
   - **If implemented**: 
     - Ensure all scope options are checked (including members if available)
     - Tap on "Create Backup" or "Backup Now" button
     - Wait for backup process to complete
     - Verify success message is displayed

4. Verify passwords are excluded from backup file:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Search for password keywords (case-insensitive):
     - Search for "password" - should NOT be found
     - Search for "pwd" - should NOT be found
     - Search for "pass" - should NOT be found (unless in business context like "passport")
     - Search for "saved_user_password" - should NOT be found
   - Verify backup file structure:
     - Root object does NOT contain password fields
     - "workspace" object does NOT contain password fields
     - "members" array items do NOT contain password fields
     - No encrypted password data
     - No password hashes

5. Verify member data contains only metadata:
   - Members contain: userId, name, email, role, permissions, joinedAt
   - Members do NOT contain: password, passwordHash, encryptedPassword

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Password exclusion is NOT implemented (missing)
- ✅ **When implemented**: Passwords are excluded from backup
- ✅ No password fields appear in backup file
- ✅ Member data contains only metadata (no passwords)
- ✅ Backup file is safe to share or store

---

## Test Case 4: API Keys and Secrets Exclusion - Sensitive Keys Not Backed Up

**Objective**: Verify that API keys, secrets, and private keys are excluded from backup.

**Preconditions**:
- User is logged in
- Current workspace has:
  - At least 1 task
  - At least 1 project
  - Workspace settings (may contain API keys if custom integrations exist)
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Create backup:
   - **If NOT implemented**: Backup feature is not available (this is expected - feature missing)
   - **If implemented**: 
     - Ensure all scope options are checked
     - Tap on "Create Backup" or "Backup Now" button
     - Wait for backup process to complete
     - Verify success message is displayed

3. Verify API keys and secrets are excluded from backup file:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Search for sensitive key keywords (case-insensitive):
     - Search for "apiKey" - should NOT be found
     - Search for "api_key" - should NOT be found
     - Search for "secret" - should NOT be found (unless in business context)
     - Search for "privateKey" - should NOT be found
     - Search for "private_key" - should NOT be found
     - Search for "secretKey" - should NOT be found
     - Search for "accessKey" - should NOT be found
   - Verify backup file structure:
     - Root object does NOT contain API key fields
     - "workspace" object does NOT contain API key fields
     - "workspace.settings" does NOT contain API key fields
     - "workspace.settings.customFields" does NOT contain API key fields

4. Verify workspace settings contain only safe metadata:
   - Workspace settings contain: timezone, language, dateFormat, timeFormat, currency, notifications, autoSave, theme
   - Workspace settings do NOT contain: API keys, secrets, private keys, authentication credentials

**Expected Results**:
- ⚠️ **CURRENT STATUS**: API key exclusion is NOT implemented (missing)
- ✅ **When implemented**: API keys and secrets are excluded from backup
- ✅ No API key fields appear in backup file
- ✅ Workspace settings contain only safe metadata
- ✅ Backup file is safe to share or store

---

## Test Case 5: Complete Sensitive Data Exclusion - All Sensitive Fields Excluded

**Objective**: Verify that all sensitive data fields are excluded from backup in a comprehensive test.

**Preconditions**:
- User is logged in
- Current workspace has:
  - At least 2 tasks (with various properties)
  - At least 2 projects
  - Configured workspace settings
  - At least 2 workspace members (if members backup is enabled)
- All sensitive data types may exist:
  - Authentication tokens (ID token, FCM token)
  - Device identifiers (deviceId)
  - Passwords (in secure storage)
  - API keys (if custom integrations exist)
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Create complete backup:
   - **If NOT implemented**: Backup feature is not available (this is expected - feature missing)
   - **If implemented**: 
     - Ensure all scope options are checked (tasks, projects, workspace settings, members)
     - Tap on "Create Backup" or "Backup Now" button
     - Wait for backup process to complete
     - Verify success message is displayed

3. Comprehensive sensitive data exclusion check:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Create a comprehensive search list for sensitive data:
     - Authentication tokens: "token", "user_token", "fcm_token", "id_token", "accessToken", "refreshToken", "authToken"
     - Device identifiers: "deviceId", "device_id", "device-id", "deviceIdentifier"
     - Passwords: "password", "pwd", "saved_user_password", "passwordHash", "encryptedPassword"
     - API keys: "apiKey", "api_key", "secret", "privateKey", "private_key", "secretKey", "accessKey"
     - Other sensitive: "sessionId", "session_id", "cookie", "credential"
   - Search for each keyword in backup file (case-insensitive)
   - Verify NONE of these keywords are found in backup file

4. Verify backup file contains only safe metadata:
   - Verify backup file structure contains:
     - Root metadata: workspaceId, exportedAt, type, version
     - Workspace: id, name, type, description, logoUrl, settings (safe fields only), createdBy, createdAt
     - Tasks: id, title, description, workspaceId, taskType, priority, status, assignee, assigner, projectId, deadline, createdAt, updatedAt
     - Projects: id, title, description, workspaceId, status, deadline, createdAt
     - Members (if included): userId, workspaceId, role, name, email, permissions, joinedAt
   - Verify backup file does NOT contain:
     - Any token fields
     - Any deviceId fields
     - Any password fields
     - Any API key fields
     - Any session/credential fields

5. Verify data integrity:
   - All business data is present and correct
   - All relationships are maintained (task.projectId matches project.id)
   - All metadata is present
   - No sensitive data is present

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Complete sensitive data exclusion is NOT implemented (missing)
- ✅ **When implemented**: All sensitive data is excluded from backup
- ✅ No sensitive keywords are found in backup file
- ✅ Only safe metadata and business data is included
- ✅ Backup file is safe to share or store
- ✅ Data integrity is maintained

---

## Test Case 6: Metadata Inclusion - Only Safe Metadata Backed Up

**Objective**: Verify that only safe metadata is included in backup, and all necessary business data is preserved.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Current workspace has:
  - At least 2 tasks with various properties:
    - Task 1: Has deadline, recurring, projectId, assignee
    - Task 2: No deadline, no recurring, no projectId
  - At least 2 projects with various properties
  - Configured workspace settings with all fields
  - At least 2 workspace members with different roles
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Create complete backup:
   - **If NOT implemented**: Backup feature is not available (this is expected - feature missing)
   - **If implemented**: 
     - Ensure all scope options are checked
     - Tap on "Create Backup" or "Backup Now" button
     - Wait for backup process to complete
     - Verify success message is displayed

3. Verify task metadata is included correctly:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Verify "tasks" array contains all tasks
   - For each task, verify included fields:
     - ✅ id, title, description, workspaceId
     - ✅ taskType, priority, status
     - ✅ assignee, assigner, projectId
     - ✅ hasDeadline, deadline (if applicable)
     - ✅ parentTaskId, stoppedByProjectClose
     - ✅ recurring (isRecurring, frequency, interval, endDate, daysOfWeek, dayOfMonth)
     - ✅ createdAt, updatedAt
   - Verify excluded fields:
     - ❌ token, deviceId, password, apiKey, secret
     - ❌ Any authentication or device-related fields

4. Verify project metadata is included correctly:
   - Verify "projects" array contains all projects
   - For each project, verify included fields:
     - ✅ id, title, description, workspaceId
     - ✅ status, deadline (if applicable)
     - ✅ createdBy, createdAt
   - Verify excluded fields:
     - ❌ token, deviceId, password, apiKey, secret
     - ❌ deletedAt (only active projects should be backed up)

5. Verify workspace metadata is included correctly:
   - Verify "workspace" object contains workspace info
   - Verify included fields:
     - ✅ id, name, type, description, logoUrl
     - ✅ createdBy, createdAt, updatedAt, isActive
     - ✅ settings (timezone, language, dateFormat, timeFormat, currency, notifications, autoSave, theme, customFields - safe fields only)
   - Verify excluded fields:
     - ❌ token, deviceId, password, apiKey, secret
     - ❌ Any authentication or device-related fields in settings

6. Verify member metadata is included correctly (if members backup is enabled):
   - Verify "members" array contains all members
   - For each member, verify included fields:
     - ✅ userId, workspaceId, role, name, email
     - ✅ permissions, joinedAt, managerUserId
   - Verify excluded fields:
     - ❌ password, passwordHash, encryptedPassword
     - ❌ token, deviceId, apiKey, secret
     - ❌ Any authentication or device-related fields

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Metadata inclusion is NOT implemented (missing)
- ✅ **When implemented**: Only safe metadata is included in backup
- ✅ All necessary business data is preserved
- ✅ All relationships are maintained
- ✅ No sensitive data is included
- ✅ Backup file is complete and safe

---

## Test Case 7: Nested Data Exclusion - Sensitive Data in Nested Objects Excluded

**Objective**: Verify that sensitive data in nested objects (e.g., customFields, settings) is excluded from backup.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Current workspace has:
  - Workspace settings with customFields containing potentially sensitive data:
    - customField1: "api_key" with value "secret_api_key_12345"
    - customField2: "device_token" with value "device_token_abc"
    - customField3: "safe_field" with value "safe_value"
  - At least 1 task
  - At least 1 project
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Create backup:
   - **If NOT implemented**: Backup feature is not available (this is expected - feature missing)
   - **If implemented**: 
     - Ensure "Include Workspace Settings" is checked
     - Tap on "Create Backup" or "Backup Now" button
     - Wait for backup process to complete
     - Verify success message is displayed

3. Verify nested sensitive data is excluded:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Navigate to "workspace.settings.customFields" in backup file
   - Verify customFields structure:
     - ✅ "safe_field" is included with value "safe_value"
     - ❌ "api_key" is excluded (field name contains sensitive keyword)
     - ❌ "device_token" is excluded (field name contains sensitive keyword)
   - Search for sensitive values in backup file:
     - Search for "secret_api_key_12345" - should NOT be found
     - Search for "device_token_abc" - should NOT be found

4. Verify exclusion logic works recursively:
   - Check if exclusion logic filters nested objects
   - Verify that sensitive fields are excluded at all nesting levels
   - Verify that safe fields are preserved at all nesting levels

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Nested data exclusion is NOT implemented (missing)
- ✅ **When implemented**: Sensitive data in nested objects is excluded
- ✅ Exclusion logic works recursively
- ✅ Safe nested data is preserved
- ✅ Backup file is safe even with nested sensitive data

---

## Test Case 8: Case-Insensitive Exclusion - Sensitive Field Names Excluded Regardless of Case

**Objective**: Verify that sensitive data exclusion works case-insensitively (e.g., "Token", "TOKEN", "token" are all excluded).

**Preconditions**:
- User is logged in as Account Holder or Admin
- Current workspace has:
  - Workspace settings with customFields containing case variations:
    - "Token": "some_token_value"
    - "DEVICE_ID": "device_123"
    - "ApiKey": "api_key_value"
    - "safeField": "safe_value"
  - At least 1 task
  - At least 1 project
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Create backup:
   - **If NOT implemented**: Backup feature is not available (this is expected - feature missing)
   - **If implemented**: 
     - Ensure "Include Workspace Settings" is checked
     - Tap on "Create Backup" or "Backup Now" button
     - Wait for backup process to complete
     - Verify success message is displayed

3. Verify case-insensitive exclusion:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Navigate to "workspace.settings.customFields" in backup file
   - Verify exclusion works for all case variations:
     - "Token" (PascalCase) - should be excluded
     - "TOKEN" (UPPERCASE) - should be excluded
     - "token" (lowercase) - should be excluded
     - "ToKeN" (mixed case) - should be excluded
   - Verify safe fields are preserved:
     - "safeField" - should be included

4. Search for case variations in backup file:
   - Search for "Token" - should NOT be found
   - Search for "TOKEN" - should NOT be found
   - Search for "token" - should NOT be found
   - Search for "some_token_value" - should NOT be found
   - Search for "device_123" - should NOT be found
   - Search for "api_key_value" - should NOT be found

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Case-insensitive exclusion is NOT implemented (missing)
- ✅ **When implemented**: Sensitive data is excluded regardless of case
- ✅ All case variations of sensitive keywords are excluded
- ✅ Safe fields are preserved regardless of case
- ✅ Backup file is safe

---

## Test Case 9: Partial Match Exclusion - Fields Containing Sensitive Keywords Excluded

**Objective**: Verify that fields containing sensitive keywords (e.g., "user_token", "device_id", "api_key") are excluded, even if the keyword is part of a larger field name.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Current workspace has:
  - Workspace settings with customFields containing partial matches:
    - "user_token_backup": "token_value"
    - "device_id_backup": "device_value"
    - "api_key_backup": "key_value"
    - "safe_token_field": "safe_value" (should be excluded if "token" is in name)
  - At least 1 task
  - At least 1 project
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Create backup:
   - **If NOT implemented**: Backup feature is not available (this is expected - feature missing)
   - **If implemented**: 
     - Ensure "Include Workspace Settings" is checked
     - Tap on "Create Backup" or "Backup Now" button
     - Wait for backup process to complete
     - Verify success message is displayed

3. Verify partial match exclusion:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Navigate to "workspace.settings.customFields" in backup file
   - Verify fields containing sensitive keywords are excluded:
     - "user_token_backup" - should be excluded (contains "token")
     - "device_id_backup" - should be excluded (contains "deviceId")
     - "api_key_backup" - should be excluded (contains "apiKey")
     - "safe_token_field" - should be excluded (contains "token")
   - Search for values in backup file:
     - Search for "token_value" - should NOT be found
     - Search for "device_value" - should NOT be found
     - Search for "key_value" - should NOT be found

4. Verify exclusion logic:
   - Check if exclusion uses partial matching (contains) or exact matching
   - Verify that any field name containing sensitive keyword is excluded
   - Verify that safe field names (without sensitive keywords) are preserved

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Partial match exclusion is NOT implemented (missing)
- ✅ **When implemented**: Fields containing sensitive keywords are excluded
- ✅ Partial matching works correctly
- ✅ Safe fields (without sensitive keywords) are preserved
- ✅ Backup file is safe

---

## Test Case 10: Exclusion Validation - Automated Check for Sensitive Data

**Objective**: Verify that backup process includes validation to detect and exclude sensitive data before creating backup file.

**Preconditions**:
- User is logged in as Account Holder or Admin
- Current workspace has:
  - At least 1 task
  - At least 1 project
  - Workspace settings
- Backup feature is implemented
- User is on the backup/export screen

**Steps**:
1. Navigate to backup/export screen:
   - From home screen, tap on "Settings" or "Workspace Settings"
   - Tap on "Backup & Export" or "Backup" option
   - Verify backup screen is displayed

2. Create backup:
   - **If NOT implemented**: Backup feature is not available (this is expected - feature missing)
   - **If implemented**: 
     - Ensure all scope options are checked
     - Tap on "Create Backup" or "Backup Now" button
     - Observe backup process:
       - Check if validation step is shown in progress
       - Check if any warnings are displayed
     - Wait for backup process to complete
     - Verify success message is displayed

3. Verify validation is performed:
   - **If NOT implemented**: Validation is not performed (this is expected - feature missing)
   - **If implemented**: 
     - Check backup logs or console for validation messages:
       - "Validating backup payload for sensitive data..."
       - "Sensitive data exclusion applied..."
       - "Backup payload validated successfully"
     - Verify validation runs before backup file is created
     - Verify validation catches sensitive data if present

4. Verify validation results:
   - Download backup file from OneDrive
   - Open backup file (JSON format)
   - Verify backup file does NOT contain sensitive data
   - Verify backup file contains only safe metadata
   - If validation warnings were shown, verify they were accurate

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Exclusion validation is NOT implemented (missing)
- ✅ **When implemented**: Validation is performed before backup creation
- ✅ Validation detects sensitive data
- ✅ Validation excludes sensitive data
- ✅ Validation logs are available for debugging
- ✅ Backup file is validated and safe

---

## Summary

### Current Status: ⛔ MISSING
All backup data exclusion features are currently **NOT IMPLEMENTED**. The backup service does not have logic to enforce exclusions of tokens, deviceId, passwords, API keys, or other sensitive data.

### What Needs to Be Implemented:
1. ✅ Sensitive data exclusion list (tokens, deviceId, passwords, API keys, secrets)
2. ✅ Exclusion logic for authentication tokens
3. ✅ Exclusion logic for device identifiers
4. ✅ Exclusion logic for passwords
5. ✅ Exclusion logic for API keys and secrets
6. ✅ Recursive exclusion for nested objects
7. ✅ Case-insensitive exclusion matching
8. ✅ Partial match exclusion (fields containing sensitive keywords)
9. ✅ Validation before backup creation
10. ✅ Logging and error handling for exclusion process

### Test Execution Notes:
- All test cases should be executed after implementation
- Test cases marked as "Missing Feature" should be updated once implemented
- Focus on comprehensive sensitive data exclusion
- Test with various data structures (nested, case variations, partial matches)
- Verify data integrity is maintained while excluding sensitive data
- Test with empty and large workspaces

### Security Considerations:
- **Critical**: Sensitive data must NEVER be included in backup files
- Backup files may be shared or stored in cloud storage
- Exclusion logic must be comprehensive and tested thoroughly
- Validation should be performed before backup file creation
- Logging should help identify any exclusion failures
