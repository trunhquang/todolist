# Project Status Enum (planned/in_progress/on_hold/completed/canceled) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Project Status Enum** feature. This feature is currently **PARTIAL** - `ProjectStatus` enum exists in `task_enums.dart` with values (pending, active, completed, cancelled, onHold), but the `Project` entity uses `String status` instead of the enum, and the enum is not enforced through controllers/UI.

## Prerequisites
- User must be logged in
- Workspace should exist
- Projects should exist
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: Verify ProjectStatus Enum Exists

**Objective**: Verify `ProjectStatus` enum exists in `task_enums.dart` with correct values.

**Preconditions**:
- Codebase is accessible
- `task_enums.dart` file exists

**Steps**:
1. Open `lib/core/constants/task_enums.dart`
2. Locate `ProjectStatus` enum
3. Verify enum has the following values:
   - `pending('pending')`
   - `active('active')`
   - `completed('completed')`
   - `cancelled('cancelled')`
   - `onHold('on_hold')`
4. Verify enum has `fromString` method:
   - Method exists
   - Returns correct enum from string value
   - Returns `ProjectStatus.pending` as default if value not found
5. Verify enum has `displayText` getter:
   - Returns display text for each status
   - Text is user-friendly

**Expected Results**:
- ✅ `ProjectStatus` enum exists
- ✅ Enum has all required values
- ✅ `fromString` method works correctly
- ✅ `displayText` getter works correctly

---

## Test Case 2: Verify Project Entity Uses String Status (Current Issue)

**Objective**: Verify `Project` entity currently uses `String status` instead of `ProjectStatus` enum.

**Preconditions**:
- Codebase is accessible
- `Project` entity exists

**Steps**:
1. Open `lib/features/tasks/domain/entities/project.dart`
2. Locate `status` field
3. Verify current implementation:
   - Field type is `String` (not `ProjectStatus`)
   - Comment says "// use TaskConstants.status*" or similar
4. Verify `fromMap` factory:
   - Uses string directly: `status: (map['status'] as String?) ?? 'pending'`
   - Does not use `ProjectStatus.fromString()`
5. Verify `toMap` method:
   - Uses string directly: `'status': status`
   - Does not use `status.value`

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Project entity uses `String status` (not enum)
- ⚠️ This is the issue that needs to be fixed
- ✅ **When fixed**: Project entity should use `ProjectStatus` enum

---

## Test Case 3: Create Project with Status - String vs Enum

**Objective**: Verify project creation uses string status (current) vs enum (when fixed).

**Preconditions**:
- User is logged in
- User has `createProjects` permission
- Workspace exists
- Create project feature is implemented

**Steps**:
1. Navigate to Project List page
2. Tap "Create Project" button
3. Fill in project details:
   - Enter project title: "Test Project"
   - Enter description: "Test project"
   - Select status (if status selector exists)
4. Verify one of the following:
   - **If NOT fixed**: Status is stored as string (e.g., "pending")
   - **If fixed**: Status is stored using enum (e.g., `ProjectStatus.pending.value`)
5. Create project
6. Verify project is created
7. Check Firebase data:
   - **If NOT fixed**: Status field is string: `"status": "pending"`
   - **If fixed**: Status field is string (enum value): `"status": "pending"` (but code uses enum)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Project creation uses string status
- ✅ **When fixed**: Project creation uses `ProjectStatus` enum
- ✅ Firebase stores string value (enum.value)

---

## Test Case 4: View Project Status - Display Text

**Objective**: Verify project status is displayed correctly in UI.

**Preconditions**:
- User is logged in
- Projects exist with different statuses
- View project feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate projects with different statuses:
   - Pending project
   - Active project
   - Completed project
   - Cancelled project
   - On Hold project
3. Verify one of the following:
   - **If NOT fixed**: Status is displayed as raw string (e.g., "pending", "in_progress")
   - **If fixed**: Status is displayed using enum `displayText` (e.g., "Pending", "Active")
4. Verify status display:
   - Text is user-friendly
   - Text matches enum `displayText` values
   - No raw enum values shown (e.g., "pending", "on_hold")

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Status may be displayed as raw string
- ✅ **When fixed**: Status is displayed using enum `displayText`
- ✅ Display text is user-friendly

---

## Test Case 5: Update Project Status - String vs Enum

**Objective**: Verify project status update uses string (current) vs enum (when fixed).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Edit project feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap "Edit" button
4. Change project status:
   - If status dropdown exists, select different status
   - If status is text field, enter new status
5. Verify one of the following:
   - **If NOT fixed**: Status is updated as string (e.g., "active")
   - **If fixed**: Status is updated using enum (e.g., `ProjectStatus.active.value`)
6. Save changes
7. Verify project is updated
8. Check Firebase data:
   - Status field is updated correctly
   - Status value is valid enum value

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Status update uses string
- ✅ **When fixed**: Status update uses `ProjectStatus` enum
- ✅ Status value is validated (only enum values allowed)

---

## Test Case 6: Project Status Dropdown - Enum Values

**Objective**: Verify project status dropdown uses enum values (when fixed).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Status dropdown UI is implemented

**Steps**:
1. Navigate to Project Edit page
2. Locate status dropdown/selector
3. Verify one of the following:
   - **If NOT fixed**: Dropdown may not exist or uses hardcoded strings
   - **If fixed**: Dropdown uses `ProjectStatus` enum values
4. If fixed:
   - Verify dropdown shows all enum values:
     - Pending
     - Active
     - Completed
     - Cancelled
     - On Hold
   - Verify dropdown uses `ProjectStatus.values`
   - Verify display text uses `status.displayText`
   - Verify selected value is enum (not string)
5. Select different status
6. Verify status is updated correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Status dropdown may not exist or uses hardcoded strings
- ✅ **When fixed**: Status dropdown uses `ProjectStatus` enum
- ✅ All enum values are available
- ✅ Display text is user-friendly

---

## Test Case 7: Project Status Color Mapping

**Objective**: Verify project status has color mapping (when fixed).

**Preconditions**:
- User is logged in
- Projects exist with different statuses
- Status color mapping is implemented

**Steps**:
1. Navigate to Project List page
2. Locate projects with different statuses
3. Verify one of the following:
   - **If NOT fixed**: Status colors may be hardcoded or missing
   - **If fixed**: Status colors are mapped from enum
4. If fixed:
   - Verify each status has a color:
     - Pending: Orange/Grey
     - Active: Blue
     - Completed: Green
     - Cancelled: Red
     - On Hold: Yellow/Orange
   - Verify colors are consistent across UI
   - Verify colors use `AppColors` or similar
5. Verify status chips/cards show correct colors

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Status colors may be hardcoded or missing
- ✅ **When fixed**: Status colors are mapped from enum
- ✅ Colors are consistent
- ✅ Colors use AppColors

---

## Test Case 8: Project Status Validation - Invalid Values

**Objective**: Verify project status validation rejects invalid values (when fixed).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Status validation is implemented

**Steps**:
1. Navigate to Project Edit page
2. Try to set invalid status:
   - If text field: Enter invalid value (e.g., "invalid_status")
   - If dropdown: Try to select invalid value (if possible)
3. Verify one of the following:
   - **If NOT fixed**: Invalid status may be accepted
   - **If fixed**: Invalid status is rejected
4. If fixed:
   - Verify error message appears: "Invalid status" or similar
   - Verify status is not updated
   - Verify only enum values are accepted
5. Try to set valid status:
   - Verify status is accepted
   - Verify status is updated

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Invalid status may be accepted
- ✅ **When fixed**: Invalid status is rejected
- ✅ Only enum values are accepted
- ✅ Error messages are clear

---

## Test Case 9: Project Status Filter - Enum Values

**Objective**: Verify project status filter uses enum values (when fixed).

**Preconditions**:
- User is logged in
- Projects exist with different statuses
- Status filter is implemented

**Steps**:
1. Navigate to Project List page
2. Locate status filter dropdown/selector
3. Verify one of the following:
   - **If NOT fixed**: Filter may use hardcoded strings
   - **If fixed**: Filter uses `ProjectStatus` enum values
4. If fixed:
   - Verify filter shows all enum values:
     - All
     - Pending
     - Active
     - Completed
     - Cancelled
     - On Hold
   - Verify filter uses `ProjectStatus.values`
   - Verify display text uses `status.displayText`
5. Select "Pending" filter:
   - Verify only pending projects are shown
   - Verify filter works correctly
6. Select "Active" filter:
   - Verify only active projects are shown
   - Verify filter works correctly
7. Select "All" filter:
   - Verify all projects are shown
   - Verify filter works correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Filter may use hardcoded strings
- ✅ **When fixed**: Filter uses `ProjectStatus` enum
- ✅ Filter works correctly
- ✅ All enum values are available

---

## Test Case 10: Project Status from Firebase - String to Enum Conversion

**Objective**: Verify project status is converted from string to enum when loading from Firebase (when fixed).

**Preconditions**:
- User is logged in
- Projects exist in Firebase with string status values
- Project loading is implemented

**Steps**:
1. Navigate to Project List page
2. Projects are loaded from Firebase
3. Verify one of the following:
   - **If NOT fixed**: Status is loaded as string
   - **If fixed**: Status is converted from string to enum using `ProjectStatus.fromString()`
4. If fixed:
   - Verify `Project.fromMap()` uses `ProjectStatus.fromString()`
   - Verify invalid status values default to `ProjectStatus.pending`
   - Verify valid status values are converted correctly
5. Check project entity:
   - Status field is `ProjectStatus` enum (not string)
   - Status value is correct

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Status is loaded as string
- ✅ **When fixed**: Status is converted to enum
- ✅ Invalid values default to pending
- ✅ Valid values are converted correctly

---

## Test Case 11: Project Status to Firebase - Enum to String Conversion

**Objective**: Verify project status is converted from enum to string when saving to Firebase (when fixed).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission
- Project exists
- Project save is implemented

**Steps**:
1. Navigate to Project Edit page
2. Change project status to `ProjectStatus.active`
3. Save project
4. Verify one of the following:
   - **If NOT fixed**: Status is saved as string directly
   - **If fixed**: Status is converted from enum to string using `status.value`
5. If fixed:
   - Verify `Project.toMap()` uses `status.value`
   - Verify Firebase stores string value (e.g., "active")
   - Verify enum is converted correctly
6. Check Firebase data:
   - Status field is string: `"status": "active"`
   - Status value is correct

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Status is saved as string directly
- ✅ **When fixed**: Status is converted from enum to string
- ✅ Firebase stores string value (enum.value)
- ✅ Conversion works correctly

---

## Test Case 12: Project Status Comparison - Type Safety

**Objective**: Verify project status comparison uses enum (type-safe) instead of string (when fixed).

**Preconditions**:
- User is logged in
- Projects exist
- Status comparison is implemented

**Steps**:
1. Navigate to code that compares project status
2. Verify one of the following:
   - **If NOT fixed**: Status comparison uses string: `project.status == 'pending'`
   - **If fixed**: Status comparison uses enum: `project.status == ProjectStatus.pending`
3. If fixed:
   - Verify type-safe comparisons:
     - `project.status == ProjectStatus.pending`
     - `project.status == ProjectStatus.active`
     - No string comparisons
   - Verify switch statements use enum:
     ```dart
     switch (project.status) {
       case ProjectStatus.pending:
         // ...
       case ProjectStatus.active:
         // ...
     }
     ```
4. Verify no hardcoded string comparisons exist

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Status comparison uses strings
- ✅ **When fixed**: Status comparison uses enum (type-safe)
- ✅ No hardcoded string comparisons
- ✅ Compiler catches type errors

---

## Test Case 13: Project Status AppStrings Mapping

**Objective**: Verify project status display text uses AppStrings (when fixed).

**Preconditions**:
- User is logged in
- Projects exist
- AppStrings mapping is implemented

**Steps**:
1. Navigate to Project List page
2. Locate project status display
3. Verify one of the following:
   - **If NOT fixed**: Status text may be hardcoded
   - **If fixed**: Status text uses AppStrings or enum `displayText`
4. If fixed:
   - Verify status text mapping:
     - Pending → AppStrings.I.projectStatusPending or "Pending"
     - Active → AppStrings.I.projectStatusActive or "Active"
     - Completed → AppStrings.I.projectStatusCompleted or "Completed"
     - Cancelled → AppStrings.I.projectStatusCancelled or "Cancelled"
     - On Hold → AppStrings.I.projectStatusOnHold or "On Hold"
   - Verify no hardcoded strings in UI
   - Verify text is consistent across UI

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Status text may be hardcoded
- ✅ **When fixed**: Status text uses AppStrings or enum `displayText`
- ✅ No hardcoded strings
- ✅ Text is consistent

---

## Test Case 14: Project Status Migration - Existing Data

**Objective**: Verify existing projects with string status are handled correctly (when fixed).

**Preconditions**:
- User is logged in
- Existing projects exist in Firebase with string status values
- Status migration is implemented

**Steps**:
1. Navigate to Project List page
2. Load existing projects from Firebase
3. Verify one of the following:
   - **If NOT fixed**: Projects load with string status
   - **If fixed**: Projects load with enum status (converted from string)
4. If fixed:
   - Verify `Project.fromMap()` handles existing string values:
     - "pending" → `ProjectStatus.pending`
     - "active" → `ProjectStatus.active`
     - "completed" → `ProjectStatus.completed`
     - "cancelled" → `ProjectStatus.cancelled`
     - "on_hold" → `ProjectStatus.onHold`
   - Verify invalid values default to `ProjectStatus.pending`
   - Verify all existing projects load correctly
5. Edit an existing project:
   - Verify status is displayed correctly
   - Verify status can be changed
   - Verify changes are saved correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Projects load with string status
- ✅ **When fixed**: Projects load with enum status (converted)
- ✅ Existing data is handled correctly
- ✅ No data loss

---

## Test Case 15: Project Status Enum - All Values Test

**Objective**: Verify all ProjectStatus enum values work correctly (when fixed).

**Preconditions**:
- User is logged in
- User has `createProjects` and `manageProjects` permissions
- Workspace exists
- Project status enum is implemented

**Steps**:
1. For each ProjectStatus enum value:
   - Pending
   - Active
   - Completed
   - Cancelled
   - On Hold
2. Create a project with that status:
   - Navigate to Create Project page
   - Enter project title: "Test Project - [Status]"
   - Select status from dropdown
   - Create project
3. Verify project is created with correct status:
   - Status is displayed correctly
   - Status color is correct
   - Status value in Firebase is correct
4. Update project to different status:
   - Edit project
   - Change status to another enum value
   - Save project
5. Verify project is updated correctly:
   - Status is displayed correctly
   - Status color is correct
   - Status value in Firebase is correct

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Status may not use enum
- ✅ **When fixed**: All enum values work correctly
- ✅ Status can be set to any enum value
- ✅ Status can be changed to any enum value
- ✅ Status display and colors are correct

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] `ProjectStatus` enum exists in `task_enums.dart`
- [ ] Project entity uses `ProjectStatus` enum (not string)
- [ ] Project creation uses enum
- [ ] Project status update uses enum
- [ ] Project status display uses enum `displayText`
- [ ] Project status dropdown uses enum values
- [ ] Project status colors are mapped
- [ ] Project status validation rejects invalid values
- [ ] Project status filter uses enum values
- [ ] Project status is converted from string to enum when loading
- [ ] Project status is converted from enum to string when saving
- [ ] Project status comparison uses enum (type-safe)
- [ ] Project status text uses AppStrings or enum `displayText`
- [ ] Existing projects with string status are handled correctly
- [ ] All enum values work correctly

---

## Known Issues (Based on Audit Report)

1. **Project Entity Uses String Status**:
   - `Project` entity uses `String status` instead of `ProjectStatus` enum
   - Comment says "// use TaskConstants.status*" but should use enum
   - **Status**: ⚠️ Partial (enum exists but not used)

2. **No Enum Enforcement**:
   - Controllers/UI don't enforce enum usage
   - Status comparisons use strings
   - Status dropdown may use hardcoded strings
   - **Status**: ⚠️ Partial (enum exists but not enforced)

3. **No Color Mapping**:
   - Status colors may be hardcoded
   - No consistent color mapping from enum
   - **Status**: ⚠️ Partial (colors may exist but not mapped from enum)

4. **No AppStrings Mapping**:
   - Status text may be hardcoded
   - No consistent text mapping from enum
   - **Status**: ⚠️ Partial (AppStrings may exist but not used)

---

## Notes for Testers

1. **Current Status**: `ProjectStatus` enum EXISTS in `task_enums.dart`, but `Project` entity doesn't use it. The entity uses `String status` instead.

2. **Enum Values**: The enum has these values:
   - `pending('pending')`
   - `active('active')`
   - `completed('completed')`
   - `cancelled('cancelled')`
   - `onHold('on_hold')`

3. **Migration**: When fixing, need to:
   - Change Project entity to use `ProjectStatus` enum
   - Update all code that uses `project.status` to use enum
   - Convert string to enum when loading from Firebase
   - Convert enum to string when saving to Firebase
   - Update UI to use enum values
   - Add color mapping
   - Add AppStrings mapping

4. **Type Safety**: Using enum provides type safety - compiler catches errors, no typos in string values.

5. **Backward Compatibility**: Need to handle existing projects with string status values - convert them to enum when loading.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- Project status value (if applicable)
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase data (if accessible) showing project status
- Code location (if applicable) showing string vs enum usage

