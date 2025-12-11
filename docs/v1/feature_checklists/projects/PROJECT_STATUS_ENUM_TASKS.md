# Project Status Enum (planned/in_progress/on_hold/completed/canceled) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Project Status Enum** feature. Currently, this feature is **PARTIAL** - `ProjectStatus` enum exists in `task_enums.dart` with values (pending, active, completed, cancelled, onHold), but the `Project` entity uses `String status` instead of the enum, and the enum is not enforced through controllers/UI.

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `ProjectStatus` enum exists in `lib/core/constants/task_enums.dart`
- ✅ Enum has values: pending, active, completed, cancelled, onHold
- ✅ Enum has `fromString()` method
- ✅ Enum has `displayText` getter
- ✅ `AppStrings` has project status strings (projectStatusPending, projectStatusActive, etc.)

### What's Missing/Broken:
- ⛔ `Project` entity uses `String status` instead of `ProjectStatus` enum
- ⛔ Controllers/UI don't enforce enum usage
- ⛔ Status comparisons use strings instead of enum
- ⛔ Status dropdown may use hardcoded strings
- ⛔ No color mapping from enum
- ⛔ No consistent AppStrings mapping from enum

---

## Task List

### Task 1: Update Project Entity to Use ProjectStatus Enum

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Change `Project` entity to use `ProjectStatus` enum instead of `String status`.

**Files to Modify**:
- `lib/features/tasks/domain/entities/project.dart`

**Implementation Steps**:
1. Import `ProjectStatus` enum:
   ```dart
   import 'package:todolist/core/constants/task_enums.dart';
   ```

2. Change status field type:
   ```dart
   class Project {
     // ... existing fields ...
     final ProjectStatus status; // Changed from String to ProjectStatus
     
     const Project({
       // ... existing parameters ...
       required this.status, // Changed from required String status
     });
   }
   ```

3. Update `fromMap` factory to convert string to enum:
   ```dart
   factory Project.fromMap(Map<dynamic, dynamic> map) {
     return Project(
       // ... existing fields ...
       status: ProjectStatus.fromString((map['status'] as String?) ?? 'pending'),
     );
   }
   ```

4. Update `toMap` method to convert enum to string:
   ```dart
   Map<String, dynamic> toMap() {
     return <String, dynamic>{
       // ... existing fields ...
       'status': status.value, // Changed from status to status.value
     };
   }
   ```

5. Update `copyWith` method:
   ```dart
   Project copyWith({
     // ... existing parameters ...
     ProjectStatus? status,
   }) {
     return Project(
       // ... existing fields ...
       status: status ?? this.status,
     );
   }
   ```

6. Remove comment "// use TaskConstants.status*" and replace with enum comment

**Expected Results**:
- ✅ Project entity uses `ProjectStatus` enum
- ✅ Entity converts string to enum when loading from Firebase
- ✅ Entity converts enum to string when saving to Firebase
- ✅ Type safety is enforced

**Test Criteria**:
- Unit test: Test entity creation with enum
- Test: Verify enum conversion in fromMap/toMap
- Test: Verify invalid status defaults to pending

---

### Task 2: Update ProjectController to Use ProjectStatus Enum

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update `ProjectController` to use `ProjectStatus` enum instead of string status.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/project_controller.dart`

**Implementation Steps**:
1. Import `ProjectStatus` enum:
   ```dart
   import 'package:todolist/core/constants/task_enums.dart';
   ```

2. Update `createProject` method:
   ```dart
   Future<void> createProject({
     required String title,
     String? description,
     DateTime? deadline,
     ProjectStatus? status, // Add optional status parameter
   }) async {
     // ... existing code ...
     
     final project = Project(
       // ... existing fields ...
       status: status ?? ProjectStatus.pending, // Use enum instead of 'pending'
     );
     
     // ... rest of method ...
   }
   ```

3. Update status comparisons to use enum:
   ```dart
   // ❌ OLD: if (project.status == 'pending')
   // ✅ NEW: if (project.status == ProjectStatus.pending)
   ```

4. Update any switch statements:
   ```dart
   switch (project.status) {
     case ProjectStatus.pending:
       // ...
     case ProjectStatus.active:
       // ...
     case ProjectStatus.completed:
       // ...
     case ProjectStatus.cancelled:
       // ...
     case ProjectStatus.onHold:
       // ...
   }
   ```

5. Remove any hardcoded string status values

**Expected Results**:
- ✅ Controller uses `ProjectStatus` enum
- ✅ No hardcoded string status values
- ✅ Type-safe status comparisons
- ✅ All status operations use enum

**Test Criteria**:
- Unit test: Test controller with enum
- Test: Verify status comparisons use enum
- Test: Verify no string comparisons

---

### Task 3: Update ProjectRepository to Use ProjectStatus Enum

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update `ProjectRepository` interface and implementation to use `ProjectStatus` enum.

**Files to Modify**:
- `lib/features/tasks/domain/repositories/project_repository.dart`
- `lib/features/tasks/data/repositories/project_repository_impl.dart`

**Implementation Steps**:
1. Import `ProjectStatus` enum in both files

2. Update `getProjects` method signature:
   ```dart
   // In ProjectRepository interface
   Future<List<Project>> getProjects({
     required String workspaceId,
     ProjectStatus? status, // Changed from String? status
   });
   ```

3. Update implementation:
   ```dart
   @override
   Future<List<Project>> getProjects({
     required String workspaceId,
     ProjectStatus? status,
   }) async {
     try {
       return await _firebaseService.listProjects(
         workspaceId: workspaceId,
         status: status?.value, // Convert enum to string for Firebase
       );
     } catch (e) {
       throw ProjectRepositoryException('Failed to get projects: $e');
     }
   }
   ```

4. Update `searchProjects` method similarly

5. Update any status filtering to use enum

**Expected Results**:
- ✅ Repository uses `ProjectStatus` enum
- ✅ Enum is converted to string for Firebase
- ✅ Type safety is enforced

**Test Criteria**:
- Unit test: Test repository with enum
- Integration test: Test with Firebase
- Test: Verify enum to string conversion

---

### Task 4: Update FirebaseDatabaseService to Support ProjectStatus Enum

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update `FirebaseDatabaseService` to accept `ProjectStatus` enum and convert to string for Firebase.

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`

**Implementation Steps**:
1. Import `ProjectStatus` enum

2. Update `listProjects` method:
   ```dart
   Stream<List<Project>> watchProjects({
     required String workspaceId,
     ProjectStatus? status, // Changed from String? status
   }) {
     // ... existing code ...
     
     final matchesStatus = status == null || project.status == status;
     // Note: project.status is now enum, so direct comparison works
     
     // ... rest of method ...
   }
   ```

3. Update `searchProjects` method similarly

4. Ensure all methods that filter by status accept enum

**Expected Results**:
- ✅ FirebaseDatabaseService accepts `ProjectStatus` enum
- ✅ Enum is converted to string for Firebase queries
- ✅ Type safety is enforced

**Test Criteria**:
- Test: Verify Firebase queries work with enum
- Test: Verify enum to string conversion

---

### Task 5: Add ProjectStatus Color Mapping

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add color mapping for `ProjectStatus` enum values.

**Files to Create/Modify**:
- `lib/core/constants/task_enums.dart` (add color getter)
- OR `lib/core/theme/app_colors.dart` (add helper method)

**Implementation Steps**:
1. Option 1: Add color getter to `ProjectStatus` enum:
   ```dart
   enum ProjectStatus {
     // ... existing code ...
     
     /// Get color for the status
     Color get color {
       switch (this) {
         case ProjectStatus.pending:
           return AppColors.pendingStatus;
         case ProjectStatus.active:
           return AppColors.inProgressStatus; // or create AppColors.activeStatus
         case ProjectStatus.completed:
           return AppColors.completedStatus;
         case ProjectStatus.cancelled:
           return AppColors.cancelledStatus;
         case ProjectStatus.onHold:
           return AppColors.warning; // or create AppColors.onHoldStatus
       }
     }
   }
   ```

2. Option 2: Add helper method in `AppColors`:
   ```dart
   class AppColors {
     // ... existing code ...
     
     static Color getProjectStatusColor(ProjectStatus status) {
       switch (status) {
         case ProjectStatus.pending:
           return pendingStatus;
         case ProjectStatus.active:
           return inProgressStatus;
         case ProjectStatus.completed:
           return completedStatus;
         case ProjectStatus.cancelled:
           return cancelledStatus;
         case ProjectStatus.onHold:
           return warning;
       }
     }
   }
   ```

3. Add missing colors to `AppColors` if needed:
   ```dart
   static Color activeStatus = const Color(0xFF2196F3); // Blue
   static Color onHoldStatus = const Color(0xFFFF9800); // Orange
   ```

**Expected Results**:
- ✅ Color mapping exists for all enum values
- ✅ Colors are consistent across UI
- ✅ Colors use AppColors

**Test Criteria**:
- Test: Verify each status has a color
- Test: Verify colors are consistent
- Manual test: Verify colors look good in UI

---

### Task 6: Update Project UI to Use ProjectStatus Enum

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update project UI components to use `ProjectStatus` enum instead of string status.

**Files to Modify**:
- `lib/app/pages/projects/project_list_page.dart`
- `lib/features/tasks/presentation/pages/project_list_page.dart`
- `lib/features/tasks/presentation/widgets/project_progress_card.dart`
- Any other UI components that display project status

**Implementation Steps**:
1. Import `ProjectStatus` enum in all UI files

2. Update status display to use enum:
   ```dart
   // ❌ OLD: Text(project.status)
   // ✅ NEW: Text(project.status.displayText)
   ```

3. Update status color to use enum:
   ```dart
   // ❌ OLD: _getStatusColor(project.status) // string-based
   // ✅ NEW: project.status.color // or AppColors.getProjectStatusColor(project.status)
   ```

4. Update `project_progress_card.dart`:
   ```dart
   Widget _buildStatusChip() {
     return TDChip(
       label: project.status.displayText, // Use enum displayText
       type: _getChipType(project.status), // Use enum
     );
   }
   
   TDChipType _getChipType(ProjectStatus status) {
     switch (status) {
       case ProjectStatus.pending:
         return TDChipType.warning;
       case ProjectStatus.active:
         return TDChipType.info;
       case ProjectStatus.completed:
         return TDChipType.success;
       case ProjectStatus.cancelled:
         return TDChipType.error;
       case ProjectStatus.onHold:
         return TDChipType.warning;
     }
   }
   ```

5. Remove hardcoded string comparisons:
   ```dart
   // ❌ OLD:
   switch (project.status) {
     case 'pending':
       // ...
   }
   
   // ✅ NEW:
   switch (project.status) {
     case ProjectStatus.pending:
       // ...
   }
   ```

**Expected Results**:
- ✅ UI uses `ProjectStatus` enum
- ✅ Status display uses enum `displayText`
- ✅ Status colors use enum color mapping
- ✅ No hardcoded string comparisons

**Test Criteria**:
- Manual test: Verify status display is correct
- Test: Verify status colors are correct
- Test: Verify no hardcoded strings

---

### Task 7: Create ProjectStatus Dropdown Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create a reusable dropdown widget for selecting project status using enum.

**Files to Create**:
- `lib/app/widgets/project_status_dropdown.dart` (new file)

**Implementation Steps**:
1. Create `ProjectStatusDropdown` widget:
   ```dart
   class ProjectStatusDropdown extends StatelessWidget {
     final ProjectStatus? value;
     final ValueChanged<ProjectStatus?>? onChanged;
     final bool enabled;
     
     const ProjectStatusDropdown({
       Key? key,
       this.value,
       this.onChanged,
       this.enabled = true,
     }) : super(key: key);
     
     @override
     Widget build(BuildContext context) {
       return DropdownButtonFormField<ProjectStatus>(
         value: value,
         decoration: InputDecoration(
           labelText: AppStrings.projectStatus,
         ),
         items: ProjectStatus.values.map((status) {
           return DropdownMenuItem<ProjectStatus>(
             value: status,
             child: Row(
               children: [
                 Container(
                   width: 12,
                   height: 12,
                   decoration: BoxDecoration(
                     color: status.color,
                     shape: BoxShape.circle,
                   ),
                 ),
                 const SizedBox(width: 8),
                 Text(status.displayText),
               ],
             ),
           );
         }).toList(),
         onChanged: enabled ? onChanged : null,
       );
     }
   }
   ```

2. Use TD widgets and AppStrings

3. Add color indicator to each option

**Expected Results**:
- ✅ Reusable status dropdown widget exists
- ✅ Widget uses `ProjectStatus` enum
- ✅ Widget shows color indicators
- ✅ Widget uses TD widgets and AppStrings

**Test Criteria**:
- Widget test: Test dropdown widget
- Manual test: Verify dropdown works correctly
- Test: Verify all enum values are available

---

### Task 8: Update Project Edit Page to Use Status Enum

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update project edit page to use `ProjectStatus` enum dropdown.

**Files to Modify**:
- `lib/app/pages/projects/project_edit_page.dart`

**Implementation Steps**:
1. Import `ProjectStatus` enum and dropdown widget

2. Replace status input with dropdown:
   ```dart
   // ❌ OLD: TextField for status (if exists)
   // ✅ NEW: ProjectStatusDropdown
   
   ProjectStatusDropdown(
     value: _selectedStatus,
     onChanged: (status) {
       setState(() {
         _selectedStatus = status;
       });
     },
   )
   ```

3. Update project creation/update to use enum:
   ```dart
   final project = Project(
     // ... existing fields ...
     status: _selectedStatus ?? ProjectStatus.pending,
   );
   ```

4. Initialize `_selectedStatus` from existing project:
   ```dart
   ProjectStatus? _selectedStatus;
   
   @override
   void initState() {
     super.initState();
     if (widget.project != null) {
       _selectedStatus = widget.project!.status; // Now enum, not string
     }
   }
   ```

**Expected Results**:
- ✅ Edit page uses `ProjectStatus` enum dropdown
- ✅ Status can be selected from dropdown
- ✅ Status is saved as enum

**Test Criteria**:
- Manual test: Create project with different statuses
- Test: Update project status
- Test: Verify status is saved correctly

---

### Task 9: Update Project Status Filter to Use Enum

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Update project status filter to use `ProjectStatus` enum.

**Files to Modify**:
- `lib/app/pages/projects/project_list_page.dart`
- `lib/features/tasks/presentation/pages/project_list_page.dart`

**Implementation Steps**:
1. Import `ProjectStatus` enum

2. Update filter state:
   ```dart
   // ❌ OLD: String _statusFilter = 'all';
   // ✅ NEW: ProjectStatus? _statusFilter;
   
   ProjectStatus? _statusFilter; // null means "all"
   ```

3. Update filter dropdown:
   ```dart
   DropdownButton<ProjectStatus?>(
     value: _statusFilter,
     items: [
       DropdownMenuItem<ProjectStatus?>(
         value: null,
         child: Text(AppStrings.all),
       ),
       ...ProjectStatus.values.map((status) {
         return DropdownMenuItem<ProjectStatus?>(
           value: status,
           child: Text(status.displayText),
         );
       }),
     ],
     onChanged: (value) => setState(() => _statusFilter = value),
   )
   ```

4. Update filter logic:
   ```dart
   if (_statusFilter != null) {
     items = items.where((p) => p.status == _statusFilter).toList();
   }
   ```

**Expected Results**:
- ✅ Filter uses `ProjectStatus` enum
- ✅ Filter shows all enum values
- ✅ Filter works correctly

**Test Criteria**:
- Manual test: Filter projects by status
- Test: Verify filter works for all statuses
- Test: Verify "all" shows all projects

---

### Task 10: Update Use Cases to Use ProjectStatus Enum

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Update use cases that check project status to use `ProjectStatus` enum.

**Files to Modify**:
- `lib/features/tasks/domain/usecases/generate_recurring_tasks.dart`
- Any other use cases that check project status

**Implementation Steps**:
1. Import `ProjectStatus` enum

2. Update status comparisons:
   ```dart
   // ❌ OLD: if (project == null || project.status == 'closed')
   // ✅ NEW: if (project == null || project.status == ProjectStatus.cancelled)
   // Note: Check if 'closed' should be 'cancelled' or 'completed'
   ```

3. Update any other status checks to use enum

**Expected Results**:
- ✅ Use cases use `ProjectStatus` enum
- ✅ Status comparisons are type-safe
- ✅ No hardcoded string comparisons

**Test Criteria**:
- Unit test: Test use cases with enum
- Test: Verify status checks work correctly

---

### Task 11: Add ProjectStatus Validation

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add validation to ensure only valid `ProjectStatus` enum values are accepted.

**Files to Modify**:
- `lib/features/tasks/domain/entities/project.dart`
- `lib/features/tasks/presentation/controllers/project_controller.dart`

**Implementation Steps**:
1. Add validation in `Project.fromMap`:
   ```dart
   factory Project.fromMap(Map<dynamic, dynamic> map) {
     final statusString = (map['status'] as String?) ?? 'pending';
     final status = ProjectStatus.fromString(statusString);
     
     // Validation: Ensure status is valid
     if (!ProjectStatus.values.contains(status)) {
       // Log warning and default to pending
       print('Warning: Invalid project status "$statusString", defaulting to pending');
       return Project(
         // ... other fields ...
         status: ProjectStatus.pending,
       );
     }
     
     return Project(
       // ... other fields ...
       status: status,
     );
   }
   ```

2. Add validation in controller when creating/updating:
   ```dart
   Future<void> updateProject(Project project) async {
     // Validate status is valid enum value
     if (!ProjectStatus.values.contains(project.status)) {
       throw ProjectControllerException('Invalid project status');
     }
     
     // ... rest of method ...
   }
   ```

**Expected Results**:
- ✅ Invalid status values are rejected
- ✅ Invalid values default to pending
- ✅ Validation errors are logged

**Test Criteria**:
- Test: Try to create project with invalid status
- Test: Verify invalid status defaults to pending
- Test: Verify validation errors are logged

---

### Task 12: Update AppStrings for Project Status

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Ensure AppStrings has all project status strings and update enum to use them (optional enhancement).

**Files to Modify**:
- `lib/core/constants/app_strings.dart`
- `lib/core/constants/task_enums.dart` (optional)

**Implementation Steps**:
1. Verify AppStrings has project status strings:
   ```dart
   static const String projectStatusPending = 'Pending';
   static const String projectStatusActive = 'Active';
   static const String projectStatusCompleted = 'Completed';
   static const String projectStatusCancelled = 'Cancelled';
   static const String projectStatusOnHold = 'On Hold';
   ```

2. Optionally update enum `displayText` to use AppStrings:
   ```dart
   String get displayText {
     switch (this) {
       case ProjectStatus.pending:
         return AppStrings.projectStatusPending;
       case ProjectStatus.active:
         return AppStrings.projectStatusActive;
       // ... etc
     }
   }
   ```

**Expected Results**:
- ✅ AppStrings has all project status strings
- ✅ Enum uses AppStrings (optional)
- ✅ All text is centralized

**Test Criteria**:
- Test: Verify AppStrings has all status strings
- Test: Verify enum uses AppStrings (if implemented)

---

### Task 13: Add Unit Tests for ProjectStatus Enum

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for `ProjectStatus` enum usage.

**Files to Create**:
- `test/features/tasks/domain/entities/project_status_test.dart`
- `test/features/tasks/domain/entities/project_entity_test.dart` (update)

**Implementation Steps**:
1. Test `ProjectStatus` enum:
   - Test all enum values exist
   - Test `fromString` method
   - Test `displayText` getter
   - Test `color` getter (if implemented)
   - Test invalid string defaults to pending

2. Test `Project` entity with enum:
   - Test entity creation with enum
   - Test `fromMap` converts string to enum
   - Test `toMap` converts enum to string
   - Test invalid status defaults to pending
   - Test `copyWith` with enum

3. Test controller with enum:
   - Test create project with enum
   - Test update project with enum
   - Test status comparisons use enum

**Expected Results**:
- ✅ Unit tests cover enum usage
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Update Project Entity to Use ProjectStatus Enum (Critical - Foundation)
2. **Task 2**: Update ProjectController to Use ProjectStatus Enum (High Priority - Controller Layer)
3. **Task 3**: Update ProjectRepository to Use ProjectStatus Enum (High Priority - Data Layer)
4. **Task 4**: Update FirebaseDatabaseService to Support ProjectStatus Enum (High Priority - Data Layer)
5. **Task 6**: Update Project UI to Use ProjectStatus Enum (High Priority - UI)
6. **Task 8**: Update Project Edit Page to Use Status Enum (High Priority - UI)
7. **Task 5**: Add ProjectStatus Color Mapping (Medium Priority - UX)
8. **Task 7**: Create ProjectStatus Dropdown Widget (Medium Priority - UI Component)
9. **Task 9**: Update Project Status Filter to Use Enum (Medium Priority - Feature Enhancement)
10. **Task 10**: Update Use Cases to Use ProjectStatus Enum (Medium Priority - Business Logic)
11. **Task 11**: Add ProjectStatus Validation (Medium Priority - Data Integrity)
12. **Task 12**: Update AppStrings for Project Status (Low Priority - Enhancement)
13. **Task 13**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ `Project` entity uses `ProjectStatus` enum (not string)
- ✅ All controllers use enum
- ✅ All repositories use enum
- ✅ All UI components use enum
- ✅ Status dropdown uses enum values
- ✅ Status filter uses enum values
- ✅ Status colors are mapped from enum
- ✅ Status display text uses enum `displayText` or AppStrings
- ✅ Status comparisons are type-safe (use enum, not strings)
- ✅ Invalid status values are rejected
- ✅ Existing projects with string status are handled correctly
- ✅ Unit tests have minimum 80% coverage
- ✅ No hardcoded string status values
- ✅ No known bugs or issues

---

## Dependencies

- **ProjectStatus Enum**: Already exists in `task_enums.dart`
- **Project Entity**: Needs to be updated to use enum
- **AppStrings**: Has project status strings (may need verification)
- **AppColors**: Has status colors (may need to add active/onHold colors)
- **TD Widgets**: Must use TD prefix widgets
- **GetX**: Required for state management (project rule)

---

## Notes

1. **Enum Already Exists**: `ProjectStatus` enum already exists in `task_enums.dart` with all required values. The main task is to update `Project` entity and all code that uses it to use the enum instead of string.

2. **Backward Compatibility**: Need to handle existing projects in Firebase with string status values. `ProjectStatus.fromString()` already handles this by converting strings to enum and defaulting to pending for invalid values.

3. **Type Safety**: Using enum provides type safety - compiler catches errors, no typos in string values, IDE autocomplete works.

4. **Color Mapping**: Need to add color mapping for all enum values. Can add as getter in enum or helper method in AppColors.

5. **AppStrings**: AppStrings already has project status strings. Can optionally update enum `displayText` to use AppStrings for consistency.

6. **Migration Path**: 
   - Step 1: Update Project entity to use enum
   - Step 2: Update all code that uses project.status
   - Step 3: Update UI to use enum
   - Step 4: Test thoroughly
   - Step 5: Deploy

7. **Testing**: Need to test:
   - Creating projects with different statuses
   - Updating project status
   - Loading existing projects from Firebase
   - Invalid status handling
   - Status filter
   - Status display and colors

---

## Related Documentation

- `PROJECTS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `PROJECT_STATUS_ENUM_TEST_CASES.md` - Test cases for this feature
- `lib/core/constants/task_enums.dart` - ProjectStatus enum definition
- `rules/PERFORMANCE_AND_ENUM_RULES.md` - Enum usage rules
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture

