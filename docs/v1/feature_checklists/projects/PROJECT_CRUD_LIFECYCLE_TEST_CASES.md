# Project CRUD & Lifecycle (Create/Edit/Archive/Restore/Delete with Permissions) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Project CRUD & Lifecycle** feature (create/edit/archive/restore/delete with permissions). This feature is currently **PARTIAL** - create/edit/delete flows exist via project controllers/repository, but archive/restore support is not evident, and permissions are enforced indirectly (workspace-based, not role-based UI checks).

## Prerequisites
- User must be logged in
- User should have different roles (Account Holder, Admin, Member)
- Workspace should exist
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: Create Project - Happy Path

**Objective**: Verify project can be created successfully.

**Preconditions**:
- User is logged in
- User has `createProjects` permission
- Workspace exists
- Create project feature is implemented

**Steps**:
1. Navigate to Project List page
2. Tap "Create Project" or "+" button
3. Verify create project dialog/page appears:
   - Title field
   - Description field (optional)
   - Deadline field (optional)
   - Status field (if applicable)
   - Create/Cancel buttons
4. Fill in project details:
   - Enter project title: "Test Project"
   - Enter description: "Test project description"
   - Select deadline (optional)
5. Tap "Create" or "Save" button
6. Verify loading indicator appears
7. Wait for project creation to complete
8. Verify success message appears: "Project created successfully"
9. Verify project appears in project list:
   - Project title is displayed
   - Project status is displayed
   - Project is in current workspace
10. Verify project is saved to Firebase:
    - Check Firebase data
    - Verify project has correct workspaceId
    - Verify project has correct createdBy

**Expected Results**:
- ✅ Project can be created
- ✅ Project appears in list
- ✅ Project is saved to Firebase
- ✅ Success message appears

---

## Test Case 2: Create Project - Permission Check

**Objective**: Verify only users with `createProjects` permission can create projects.

**Preconditions**:
- User is logged in as Member (without `createProjects` permission)
- Workspace exists
- Permission check feature is implemented

**Steps**:
1. Navigate to Project List page
2. Verify one of the following:
   - **If NOT implemented**: "Create Project" button is visible (this is expected - permission check missing)
   - **If implemented**: "Create Project" button is not visible or disabled
3. If implemented:
   - Verify "Create Project" button is hidden/disabled
   - Try to access create project directly (if possible):
     - Navigate to create project URL/route
     - Verify error message appears: "Permission denied" or "You don't have permission to create projects"
4. As Admin (with `createProjects` permission):
   - Verify "Create Project" button is visible
   - Verify can create project
5. As Account Holder:
   - Verify "Create Project" button is visible
   - Verify can create project

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permission check in UI is NOT available (missing)
- ✅ **When implemented**: Only users with `createProjects` permission can create projects
- ✅ Permission checks are enforced in UI
- ✅ Appropriate error messages are shown

---

## Test Case 3: Edit Project - Happy Path

**Objective**: Verify project can be edited successfully.

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Edit project feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap "Edit" button or project card
4. Verify edit project page/dialog appears:
   - Title field (pre-filled)
   - Description field (pre-filled)
   - Deadline field (pre-filled)
   - Status field (if applicable)
   - Save/Cancel buttons
5. Modify project details:
   - Change title: "Updated Project Title"
   - Change description: "Updated description"
   - Change deadline (if applicable)
6. Tap "Save" button
7. Verify loading indicator appears
8. Wait for update to complete
9. Verify success message appears: "Project updated successfully"
10. Verify project is updated in list:
    - Updated title is displayed
    - Updated description is displayed
    - Updated deadline is displayed (if changed)
11. Verify project is updated in Firebase:
    - Check Firebase data
    - Verify changes are saved

**Expected Results**:
- ✅ Project can be edited
- ✅ Changes are saved
- ✅ Project is updated in Firebase
- ✅ Success message appears

---

## Test Case 4: Edit Project - Permission Check

**Objective**: Verify only users with `manageProjects` permission can edit projects.

**Preconditions**:
- User is logged in as Member (without `manageProjects` permission)
- Project exists
- Permission check feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Verify one of the following:
   - **If NOT implemented**: "Edit" button is visible (this is expected - permission check missing)
   - **If implemented**: "Edit" button is not visible or disabled
4. If implemented:
   - Verify "Edit" button is hidden/disabled
   - Try to access edit project directly (if possible):
     - Navigate to edit project URL/route
     - Verify error message appears: "Permission denied"
5. As Admin (with `manageProjects` permission):
   - Verify "Edit" button is visible
   - Verify can edit project
6. As Account Holder:
   - Verify "Edit" button is visible
   - Verify can edit project

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permission check in UI is NOT available (missing)
- ✅ **When implemented**: Only users with `manageProjects` permission can edit projects
- ✅ Permission checks are enforced in UI

---

## Test Case 5: Delete Project - Happy Path

**Objective**: Verify project can be deleted successfully.

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Delete project feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap "Delete" button
4. Verify one of the following:
   - **If NOT implemented**: Confirmation dialog may not appear (this is expected - confirmation missing)
   - **If implemented**: Confirmation dialog appears
5. If implemented:
   - Verify confirmation dialog:
     - Warning message about deleting project
     - Project name displayed
     - Cancel button
     - Delete button (red/danger style)
   - Tap "Cancel":
     - Verify dialog closes
     - Verify project is NOT deleted
   - Tap "Delete":
     - Verify loading indicator appears
     - Wait for deletion to complete
6. If not implemented:
   - Tap "Delete" button
   - Verify project is deleted immediately
7. Verify success message appears: "Project deleted successfully"
8. Verify project is removed from list:
   - Project no longer appears
   - List updates correctly
9. Verify project is soft-deleted in Firebase:
   - Check Firebase data
   - Verify `deletedAt` field is set
   - Verify project is not permanently deleted

**Expected Results**:
- ✅ Project can be deleted
- ✅ Project is soft-deleted (deletedAt is set)
- ✅ Project is removed from list
- ✅ Confirmation dialog appears (if implemented)
- ✅ Success message appears

---

## Test Case 6: Delete Project - Permission Check

**Objective**: Verify only users with `manageProjects` permission can delete projects.

**Preconditions**:
- User is logged in as Member (without `manageProjects` permission)
- Project exists
- Permission check feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Verify one of the following:
   - **If NOT implemented**: "Delete" button is visible (this is expected - permission check missing)
   - **If implemented**: "Delete" button is not visible or disabled
4. If implemented:
   - Verify "Delete" button is hidden/disabled
   - Try to delete project directly (if possible):
     - Verify error message appears: "Permission denied"
5. As Admin (with `manageProjects` permission):
   - Verify "Delete" button is visible
   - Verify can delete project
6. As Account Holder:
   - Verify "Delete" button is visible
   - Verify can delete project

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permission check in UI is NOT available (missing)
- ✅ **When implemented**: Only users with `manageProjects` permission can delete projects
- ✅ Permission checks are enforced in UI

---

## Test Case 7: Archive Project - Missing Feature

**Objective**: Verify project can be archived (currently missing).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Archive project feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Verify one of the following:
   - **If NOT implemented**: "Archive" option is not available (this is expected - feature missing)
   - **If implemented**: "Archive" or "Archive Project" option is available
4. If implemented:
   - Tap "Archive" option
   - Verify confirmation dialog appears (if required):
     - Warning message about archiving project
     - Confirmation button
   - Confirm archiving
   - Verify loading indicator appears
   - Wait for archive to complete
   - Verify success message appears: "Project archived successfully"
   - Verify project is archived:
     - Project no longer appears in active projects list
     - Project appears in archived projects list (if exists)
     - Project has `isArchived: true` or `archivedAt` field set
   - Verify project is archived in Firebase:
     - Check Firebase data
     - Verify `isArchived` or `archivedAt` field is set
     - Verify project data is preserved

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Archive project is NOT available (missing)
- ✅ **When implemented**: Project can be archived
- ✅ Project is hidden from active list
- ✅ Project data is preserved
- ✅ Project can be restored later

---

## Test Case 8: Restore Project - Missing Feature

**Objective**: Verify archived project can be restored (currently missing).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Archived project exists
- Restore project feature is implemented

**Steps**:
1. Navigate to Archived Projects list or Project List page
2. Locate an archived project
3. Verify one of the following:
   - **If NOT implemented**: "Restore" option is not available (this is expected - feature missing)
   - **If implemented**: "Restore" or "Restore Project" option is available
4. If implemented:
   - Tap "Restore" option
   - Verify confirmation dialog appears (if required):
     - Confirmation message
     - Confirm button
   - Confirm restoration
   - Verify loading indicator appears
   - Wait for restore to complete
   - Verify success message appears: "Project restored successfully"
   - Verify project is restored:
     - Project appears in active projects list
     - Project no longer appears in archived list
     - Project has `isArchived: false` or `archivedAt: null`
   - Verify project is restored in Firebase:
     - Check Firebase data
     - Verify `isArchived` or `archivedAt` field is cleared
     - Verify project data is intact

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Restore project is NOT available (missing)
- ✅ **When implemented**: Archived project can be restored
- ✅ Project appears in active list
- ✅ Project data is intact

---

## Test Case 9: View Archived Projects - Missing Feature

**Objective**: Verify archived projects can be viewed (currently missing).

**Preconditions**:
- User is logged in
- User has permission to view projects
- Archived projects exist
- View archived projects feature is implemented

**Steps**:
1. Navigate to Project List page
2. Verify one of the following:
   - **If NOT implemented**: "View Archived" or "Archived Projects" option is not available (this is expected - feature missing)
   - **If implemented**: "View Archived" or "Archived Projects" option is available
3. If implemented:
   - Tap "View Archived" option
   - Verify archived projects list appears:
     - List of archived projects
     - Archive date displayed
     - Archived by (if available)
   - Verify archived projects are filtered:
     - Only archived projects are shown
     - Active projects are NOT shown
   - Verify restore option is available for each archived project

**Expected Results**:
- ⚠️ **CURRENT STATUS**: View archived projects is NOT available (missing)
- ✅ **When implemented**: Archived projects can be viewed
- ✅ Only archived projects are shown
- ✅ Restore option is available

---

## Test Case 10: Archive Project - Permission Check

**Objective**: Verify only users with `manageProjects` permission can archive projects.

**Preconditions**:
- User is logged in as Member (without `manageProjects` permission)
- Project exists
- Archive project feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Verify one of the following:
   - **If NOT implemented**: "Archive" option may not exist (this is expected - feature missing)
   - **If implemented**: "Archive" option is not visible or disabled
4. If implemented:
   - Verify "Archive" option is hidden/disabled
   - Try to archive project directly (if possible):
     - Verify error message appears: "Permission denied"
5. As Admin (with `manageProjects` permission):
   - Verify "Archive" option is visible
   - Verify can archive project
6. As Account Holder:
   - Verify "Archive" option is visible
   - Verify can archive project

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permission check for archive is NOT available (missing)
- ✅ **When implemented**: Only users with `manageProjects` permission can archive projects
- ✅ Permission checks are enforced

---

## Test Case 11: Restore Project - Permission Check

**Objective**: Verify only users with `manageProjects` permission can restore projects.

**Preconditions**:
- User is logged in as Member (without `manageProjects` permission)
- Archived project exists
- Restore project feature is implemented

**Steps**:
1. Navigate to Archived Projects list
2. Locate an archived project
3. Verify one of the following:
   - **If NOT implemented**: "Restore" option may not exist (this is expected - feature missing)
   - **If implemented**: "Restore" option is not visible or disabled
4. If implemented:
   - Verify "Restore" option is hidden/disabled
   - Try to restore project directly (if possible):
     - Verify error message appears: "Permission denied"
5. As Admin (with `manageProjects` permission):
   - Verify "Restore" option is visible
   - Verify can restore project
6. As Account Holder:
   - Verify "Restore" option is visible
   - Verify can restore project

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permission check for restore is NOT available (missing)
- ✅ **When implemented**: Only users with `manageProjects` permission can restore projects
- ✅ Permission checks are enforced

---

## Test Case 12: Delete Project - Confirmation Dialog

**Objective**: Verify confirmation dialog appears before deleting project (if implemented).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Confirmation dialog feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap "Delete" button
4. Verify one of the following:
   - **If NOT implemented**: Confirmation dialog does not appear (this is expected - feature missing)
   - **If implemented**: Confirmation dialog appears
5. If implemented:
   - Verify confirmation dialog:
     - Title: "Delete Project" or similar
     - Message: Warning about deleting project
     - Project name displayed
     - Cancel button
     - Delete button (red/danger style)
   - Tap "Cancel":
     - Verify dialog closes
     - Verify project is NOT deleted
   - Tap "Delete":
     - Verify project is deleted
     - Verify success message appears

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Confirmation dialog may not be implemented (missing)
- ✅ **When implemented**: Confirmation dialog appears before deletion
- ✅ Confirmation cannot be bypassed

---

## Test Case 13: Project Lifecycle - Archive Then Restore

**Objective**: Verify project can be archived and then restored (if implemented).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Archive and restore features are implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Archive the project:
   - Tap "Archive" option
   - Confirm archiving
   - Verify project is archived
4. Verify project is no longer in active list
5. Navigate to Archived Projects list
6. Locate the archived project
7. Restore the project:
   - Tap "Restore" option
   - Confirm restoration
   - Verify project is restored
8. Verify project appears in active list again:
   - Project title is correct
   - Project description is correct
   - Project data is intact
9. Verify project can be used normally:
   - Can edit project
   - Can add tasks to project
   - Project functions correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Archive and restore are NOT available (missing)
- ✅ **When implemented**: Project can be archived and restored
- ✅ Project data is preserved
- ✅ Project functions correctly after restore

---

## Test Case 14: Project Lifecycle - Delete After Archive

**Objective**: Verify project can be permanently deleted after archiving (if implemented).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Archived project exists
- Permanent delete feature is implemented

**Steps**:
1. Navigate to Archived Projects list
2. Locate an archived project
3. Verify one of the following:
   - **If NOT implemented**: "Delete Permanently" option is not available (this is expected - feature missing)
   - **If implemented**: "Delete Permanently" option is available
4. If implemented:
   - Tap "Delete Permanently" option
   - Verify strong confirmation dialog appears:
     - Warning about permanent deletion
     - Confirmation text input (e.g., "DELETE")
     - Cancel button
     - Delete button
   - Enter confirmation text
   - Tap "Delete" button
   - Verify project is permanently deleted:
     - Project is removed from archived list
     - Project is removed from Firebase
     - Project cannot be restored

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Permanent delete after archive is NOT available (missing)
- ✅ **When implemented**: Project can be permanently deleted after archiving
- ✅ Strong confirmation is required
- ✅ Project is permanently removed

---

## Test Case 15: Project CRUD - Workspace Filtering

**Objective**: Verify projects are filtered by workspace correctly.

**Preconditions**:
- User is logged in
- User is member of multiple workspaces
- Each workspace has projects
- Workspace filtering is implemented

**Steps**:
1. Switch to Workspace A
2. Navigate to Project List page
3. Verify only Workspace A's projects are displayed:
   - Projects from Workspace A are shown
   - Projects from other workspaces are NOT shown
4. Create a project in Workspace A:
   - Verify project is created
   - Verify project appears in list
   - Verify project has Workspace A's workspaceId
5. Switch to Workspace B
6. Navigate to Project List page
7. Verify only Workspace B's projects are displayed:
   - Projects from Workspace B are shown
   - Projects from Workspace A are NOT shown
   - Project created in Workspace A is NOT shown

**Expected Results**:
- ✅ Projects are filtered by workspace
- ✅ Only current workspace's projects are shown
- ✅ Workspace switching updates project list

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Project can be created
- [ ] Only users with `createProjects` permission can create (if implemented)
- [ ] Project can be edited
- [ ] Only users with `manageProjects` permission can edit (if implemented)
- [ ] Project can be deleted
- [ ] Only users with `manageProjects` permission can delete (if implemented)
- [ ] Project can be archived (if implemented)
- [ ] Only users with `manageProjects` permission can archive (if implemented)
- [ ] Project can be restored (if implemented)
- [ ] Only users with `manageProjects` permission can restore (if implemented)
- [ ] Archived projects can be viewed (if implemented)
- [ ] Confirmation dialog appears before deletion (if implemented)
- [ ] Project can be archived and restored (if implemented)
- [ ] Project can be permanently deleted after archiving (if implemented)
- [ ] Projects are filtered by workspace

---

## Known Issues (Based on Audit Report)

1. **Archive/Restore Missing**:
   - Archive/restore support is not evident
   - No archive/restore methods in repository
   - No archive/restore UI
   - **Status**: ⛔ Missing

2. **Permission Checks Missing in UI**:
   - Permissions are enforced indirectly (workspace-based)
   - No role-based UI checks
   - Create/Edit/Delete buttons may be visible to all users
   - **Status**: ⚠️ Partial (permissions exist but not enforced in UI)

3. **Soft Delete Exists**:
   - `softDeleteProject` method exists in FirebaseDatabaseService
   - `deletedAt` field exists in Project entity
   - But no restore functionality
   - **Status**: ⚠️ Partial (delete exists, restore missing)

4. **Permission Service Exists**:
   - `PermissionService.canCreateProject` exists
   - `PermissionService.canManageProject` exists
   - But not used in ProjectController
   - **Status**: ⚠️ Partial (service exists, not integrated)

---

## Notes for Testers

1. **Current Status**: Project CRUD is partially implemented. Create/edit/delete flows exist, but archive/restore is missing, and permission checks are not enforced in UI.

2. **Soft Delete**: `softDeleteProject` exists and sets `deletedAt` field, but there's no restore functionality. Projects are soft-deleted but cannot be restored.

3. **Archive vs Delete**: Archive should be different from delete:
   - Archive: Hide project but keep data (can be restored)
   - Delete: Soft delete (sets deletedAt, may be restorable)
   - Permanent Delete: Remove completely (cannot be restored)

4. **Permission Checks**: PermissionService has methods for checking permissions, but they're not used in ProjectController or UI. Need to add permission checks:
   - Create: Check `createProjects` permission
   - Edit/Delete/Archive/Restore: Check `manageProjects` permission

5. **Workspace Filtering**: Projects are filtered by workspace (workspaceId), which is good. This is workspace-based filtering, not role-based.

6. **Role-Based UI Checks**: Need to add role-based UI checks to show/hide buttons based on user permissions, not just workspace membership.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- User roles (Account Holder, Admin, Member)
- Workspace context
- Project context
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase data (if accessible) showing project data
- Whether permission checks are working
- Whether archive/restore is working

