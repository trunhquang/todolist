# Task Classification (Daily/Project) & Color by Status - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Task Classification (Daily/Project) & Color by Status** feature. Currently, this feature is **PARTIAL** - taskType string supports daily/project but not enforced by enum, and color mapping is not centralized/consistent.

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `TaskType` enum exists in `task_enums.dart` with `daily` and `project` values
- ✅ `TaskStatus` enum exists in `task_enums.dart` with status values
- ✅ `AppColors` has task type colors (dailyTask, weeklyTask, monthlyTask, projectTask)
- ✅ `AppColors` has status colors (pendingStatus, inProgressStatus, completedStatus, cancelledStatus)
- ✅ Some UI components display task types and statuses
- ✅ `TaskConstants` has display names and icons for types/statuses

### What's Missing/Broken:
- ⛔ `TaskEntity` uses `String taskType` instead of `TaskType` enum - no enum enforcement
- ⛔ Color mapping is not centralized - hardcoded colors in multiple UI components
- ⛔ Status color mapping is not mapped to enum - no centralized function
- ⛔ Type color mapping is not mapped to enum - no centralized function
- ⛔ Colors are inconsistent across UI components
- ⛔ Icon mapping is not consistently used

---

## Task List

### Task 1: Update TaskEntity to Use TaskType Enum

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update `TaskEntity` to use `TaskType` enum instead of `String taskType`. This overlaps with TASK_CRUD_DETAILS_TASKS.md but is critical for classification.

**Files to Modify**:
- `lib/features/tasks/domain/entities/task.dart`

**Implementation Steps**:
1. Import enum:
   ```dart
   import 'package:todolist/core/constants/task_enums.dart';
   ```

2. Update TaskEntity field:
   ```dart
   class TaskEntity {
     // ... existing fields ...
     final TaskType taskType; // Changed from String to TaskType
     
     const TaskEntity({
       // ... existing parameters ...
       required this.taskType,
     });
   }
   ```

3. Update `fromMap` factory:
   ```dart
   factory TaskEntity.fromMap(Map<dynamic, dynamic> map) {
     return TaskEntity(
       // ... existing fields ...
       taskType: TaskType.fromString((map['taskType'] as String?) ?? 'daily'),
     );
   }
   ```

4. Update `toMap` method:
   ```dart
   Map<String, dynamic> toMap() {
     return <String, dynamic>{
       // ... existing fields ...
       'taskType': taskType.value,
     };
   }
   ```

5. Update `copyWith` method to use enum

**Expected Results**:
- ✅ TaskEntity uses TaskType enum
- ✅ Type safety is enforced
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity creation with enum
- Test: Verify enum conversion in toMap/fromMap
- Test: Verify type safety

**Note**: This task may overlap with TASK_CRUD_DETAILS_TASKS.md Task 1. Coordinate to avoid duplicate work.

---

### Task 2: Add Color Getter to TaskType Enum

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add color getter to `TaskType` enum for centralized color mapping.

**Files to Modify**:
- `lib/core/constants/task_enums.dart`

**Implementation Steps**:
1. Import Flutter Material:
   ```dart
   import 'package:flutter/material.dart';
   import 'package:todolist/app/theme/app_colors.dart';
   ```

2. Add color getter to `TaskType` enum:
   ```dart
   enum TaskType {
     daily('daily'),
     project('project');
     
     const TaskType(this.value);
     final String value;
     
     // ... existing methods ...
     
     /// Get color for the task type
     Color get color {
       switch (this) {
         case TaskType.daily:
           return AppColors.dailyTask;
         case TaskType.project:
           return AppColors.projectTask;
       }
     }
   }
   ```

**Expected Results**:
- ✅ TaskType enum has color getter
- ✅ Colors are centralized
- ✅ Colors come from AppColors

**Test Criteria**:
- Unit test: Test color getter
- Test: Verify colors match AppColors

---

### Task 3: Add Color Getter to TaskStatus Enum

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add color getter to `TaskStatus` enum for centralized color mapping.

**Files to Modify**:
- `lib/core/constants/task_enums.dart`

**Implementation Steps**:
1. Import Flutter Material:
   ```dart
   import 'package:flutter/material.dart';
   import 'package:todolist/app/theme/app_colors.dart';
   ```

2. Add color getter to `TaskStatus` enum:
   ```dart
   enum TaskStatus {
     pending('pending'),
     inProgress('in_progress'),
     completed('completed'),
     cancelled('cancelled'),
     onHold('on_hold');
     
     const TaskStatus(this.value);
     final String value;
     
     // ... existing methods ...
     
     /// Get color for the task status
     Color get color {
       switch (this) {
         case TaskStatus.pending:
           return AppColors.pendingStatus;
         case TaskStatus.inProgress:
           return AppColors.inProgressStatus;
         case TaskStatus.completed:
           return AppColors.completedStatus;
         case TaskStatus.cancelled:
           return AppColors.cancelledStatus;
         case TaskStatus.onHold:
           return AppColors.warning; // or create AppColors.onHoldStatus
       }
     }
   }
   ```

3. Add missing color to AppColors if needed:
   ```dart
   static Color onHoldStatus = const Color(0xFFFF9800); // Orange
   ```

**Expected Results**:
- ✅ TaskStatus enum has color getter
- ✅ Colors are centralized
- ✅ Colors come from AppColors

**Test Criteria**:
- Unit test: Test color getter
- Test: Verify colors match AppColors

---

### Task 4: Add Icon Getter to TaskType Enum

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add icon getter to `TaskType` enum for centralized icon mapping.

**Files to Modify**:
- `lib/core/constants/task_enums.dart`

**Implementation Steps**:
1. Add icon getter to `TaskType` enum:
   ```dart
   enum TaskType {
     // ... existing code ...
     
     /// Get icon name for the task type
     String get iconName {
       switch (this) {
         case TaskType.daily:
           return 'calendar_today';
         case TaskType.project:
           return 'work';
       }
     }
   }
   ```

2. Or use existing `TaskConstants.taskTypeIcons` mapping:
   ```dart
   String get iconName {
     return TaskConstants.taskTypeIcons[value] ?? 'task';
   }
   ```

**Expected Results**:
- ✅ TaskType enum has icon getter
- ✅ Icons are centralized
- ✅ Icons come from TaskConstants or enum

**Test Criteria**:
- Unit test: Test icon getter
- Test: Verify icons are correct

---

### Task 5: Add Icon Getter to TaskStatus Enum

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add icon getter to `TaskStatus` enum for centralized icon mapping.

**Files to Modify**:
- `lib/core/constants/task_enums.dart`

**Implementation Steps**:
1. Add icon getter to `TaskStatus` enum:
   ```dart
   enum TaskStatus {
     // ... existing code ...
     
     /// Get icon name for the task status
     String get iconName {
       switch (this) {
         case TaskStatus.pending:
           return 'schedule';
         case TaskStatus.inProgress:
           return 'play_circle';
         case TaskStatus.completed:
           return 'check_circle';
         case TaskStatus.cancelled:
           return 'cancel';
         case TaskStatus.onHold:
           return 'pause_circle';
       }
     }
   }
   ```

2. Or use existing `TaskConstants.statusIcons` mapping

**Expected Results**:
- ✅ TaskStatus enum has icon getter
- ✅ Icons are centralized
- ✅ Icons come from TaskConstants or enum

**Test Criteria**:
- Unit test: Test icon getter
- Test: Verify icons are correct

---

### Task 6: Update Task Card to Use Centralized Color Mapping

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update `task_card.dart` to use centralized color mapping from enums instead of hardcoded colors.

**Files to Modify**:
- `lib/features/tasks/presentation/widgets/task_card.dart`

**Implementation Steps**:
1. Import enums:
   ```dart
   import 'package:todolist/core/constants/task_enums.dart';
   ```

2. Update type color logic:
   ```dart
   // Before:
   final type = TaskType.fromString(task.taskType);
   Color chipColor;
   switch (type) {
     case TaskType.daily:
       chipColor = Colors.purple; // Hardcoded
     case TaskType.project:
       chipColor = Colors.indigo; // Hardcoded
   }
   
   // After:
   final type = task.taskType; // Now it's already TaskType enum
   final chipColor = type.color; // Use enum color getter
   ```

3. Update status color logic:
   ```dart
   // Before:
   Color chipColor;
   switch (status) {
     case 'completed':
       chipColor = Colors.green; // Hardcoded
     // ...
   }
   
   // After:
   final statusEnum = task.status; // Now it's TaskStatus enum
   final chipColor = statusEnum.color; // Use enum color getter
   ```

4. Update icon logic to use enum icon getter

5. Remove all hardcoded colors

**Expected Results**:
- ✅ Task card uses centralized color mapping
- ✅ No hardcoded colors
- ✅ Colors are consistent

**Test Criteria**:
- Manual test: Verify task card colors
- Test: Verify no hardcoded colors remain

---

### Task 7: Update Task List Page to Use Centralized Color Mapping

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update task list page to use centralized color mapping.

**Files to Modify**:
- `lib/app/pages/tasks/task_list_page.dart`
- `lib/features/tasks/presentation/pages/task_list_page.dart`

**Implementation Steps**:
1. Import enums

2. Replace hardcoded colors with enum color getters:
   ```dart
   // Use task.taskType.color instead of hardcoded colors
   // Use task.status.color instead of hardcoded colors
   ```

3. Update any color helper methods to use enum getters

**Expected Results**:
- ✅ Task list uses centralized color mapping
- ✅ No hardcoded colors
- ✅ Colors are consistent

**Test Criteria**:
- Manual test: Verify task list colors
- Test: Verify no hardcoded colors remain

---

### Task 8: Update Dashboard to Use Centralized Color Mapping

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Update dashboard page to use centralized color mapping instead of helper methods with hardcoded colors.

**Files to Modify**:
- `lib/app/pages/home/dashboard_page.dart`

**Implementation Steps**:
1. Import enums

2. Replace helper methods with enum getters:
   ```dart
   // Before:
   Color _getTypeColor(String type) {
     switch (type.toLowerCase()) {
       case 'daily':
         return AppColors.dailyTask;
       // ...
     }
   }
   
   // After:
   // Use task.taskType.color directly
   ```

3. Replace `_getStatusColor` method with enum getter:
   ```dart
   // Use task.status.color directly
   ```

4. Remove helper methods

**Expected Results**:
- ✅ Dashboard uses centralized color mapping
- ✅ No hardcoded colors
- ✅ Colors are consistent

**Test Criteria**:
- Manual test: Verify dashboard colors
- Test: Verify no hardcoded colors remain

---

### Task 9: Update Task Edit Form to Use Enum

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update task edit/create form to use `TaskType` enum instead of string.

**Files to Modify**:
- `lib/app/pages/tasks/task_edit_page.dart`
- `lib/features/tasks/presentation/widgets/create_task_form.dart`

**Implementation Steps**:
1. Import enum:
   ```dart
   import 'package:todolist/core/constants/task_enums.dart';
   ```

2. Update type selector to use enum:
   ```dart
   // Before:
   DropdownButton<String>(
     value: _type,
     items: ['daily', 'project'].map((type) {
       return DropdownMenuItem<String>(
         value: type,
         child: Text(type),
       );
     }).toList(),
   )
   
   // After:
   DropdownButton<TaskType>(
     value: _selectedType,
     items: TaskType.values.map((type) {
       return DropdownMenuItem<TaskType>(
         value: type,
         child: Text(type.displayText), // Use enum displayText
       );
     }).toList(),
   )
   ```

3. Update state variable:
   ```dart
   TaskType _selectedType = TaskType.daily; // Instead of String
   ```

4. Update save logic to use enum

**Expected Results**:
- ✅ Task edit form uses enum
- ✅ Type selector shows enum values
- ✅ Type is saved as enum

**Test Criteria**:
- Manual test: Create/edit task with type
- Test: Verify enum is used

---

### Task 10: Update Task Controllers to Use TaskType Enum

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update task controllers to use `TaskType` enum instead of string.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/task_controller.dart`
- `lib/features/tasks/presentation/controllers/paginated_task_controller.dart`

**Implementation Steps**:
1. Import enum

2. Update method signatures:
   ```dart
   // Before:
   Future<void> createTask({
     String taskType = 'daily',
   }) async {
     // ...
   }
   
   // After:
   Future<void> createTask({
     TaskType taskType = TaskType.daily,
   }) async {
     // Use enum directly
   }
   ```

3. Update type comparisons to use enum:
   ```dart
   // Before: if (task.taskType == 'daily')
   // After: if (task.taskType == TaskType.daily)
   ```

4. Update filters to use enum

**Expected Results**:
- ✅ Controllers use enum
- ✅ Type safety is enforced
- ✅ All comparisons use enum

**Test Criteria**:
- Unit test: Test controller methods with enum
- Test: Verify enum comparisons work

---

### Task 11: Add Task Type Filter Using Enum

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add or update task type filter to use enum.

**Files to Modify**:
- `lib/app/pages/tasks/task_list_page.dart`
- `lib/features/tasks/presentation/controllers/task_controller.dart`

**Implementation Steps**:
1. Add type filter dropdown:
   ```dart
   DropdownButton<TaskType?>(
     value: _selectedType,
     items: [
       DropdownMenuItem<TaskType?>(
         value: null,
         child: Text(AppStrings.allTypes),
       ),
       ...TaskType.values.map((type) {
         return DropdownMenuItem<TaskType?>(
           value: type,
           child: Text(type.displayText),
         );
       }),
     ],
     onChanged: (type) {
       setState(() {
         _selectedType = type;
       });
       _filterTasks();
     },
   )
   ```

2. Update controller filter method to use enum:
   ```dart
   Future<List<TaskEntity>> getTasks({
     TaskType? type, // Changed from String?
   }) async {
     // Filter by enum
   }
   ```

**Expected Results**:
- ✅ Type filter uses enum
- ✅ Filter works correctly
- ✅ All filter options are available

**Test Criteria**:
- Manual test: Filter tasks by type
- Test: Verify filter works with enum

---

### Task 12: Create Color Helper Utility (Optional)

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Create optional utility class for color mapping if needed (alternative to enum getters).

**Files to Create**:
- `lib/core/utils/task_color_helper.dart` (new file, optional)

**Implementation Steps**:
1. Create `TaskColorHelper` class:
   ```dart
   class TaskColorHelper {
     static Color getTaskTypeColor(TaskType type) {
       return type.color; // Delegate to enum
     }
     
     static Color getTaskStatusColor(TaskStatus status) {
       return status.color; // Delegate to enum
     }
     
     // Additional helper methods if needed
   }
   ```

2. Use this only if enum getters are not sufficient

**Expected Results**:
- ✅ Color helper exists (if needed)
- ✅ Helper delegates to enum getters

**Test Criteria**:
- Test: Verify helper methods work

**Note**: This is optional. Prefer using enum getters directly.

---

### Task 13: Update All UI Components to Use Centralized Colors

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update all UI components that display task types/statuses to use centralized color mapping.

**Files to Modify**:
- All task-related UI components
- Search for hardcoded colors: `Colors.purple`, `Colors.indigo`, `Colors.green`, etc.

**Implementation Steps**:
1. Search codebase for hardcoded task colors:
   ```bash
   grep -r "Colors.purple\|Colors.indigo\|Colors.green" lib/
   ```

2. Replace hardcoded colors with enum getters:
   ```dart
   // Replace:
   Colors.purple
   // With:
   task.taskType.color
   
   // Replace:
   Colors.green
   // With:
   task.status.color
   ```

3. Update components:
   - Task card
   - Task list
   - Task detail
   - Dashboard
   - Project detail (if applicable)
   - Any other components showing task types/statuses

**Expected Results**:
- ✅ All components use centralized colors
- ✅ No hardcoded colors remain
- ✅ Colors are consistent everywhere

**Test Criteria**:
- Manual test: Check all UI components
- Test: Verify no hardcoded colors remain
- Test: Verify colors are consistent

---

### Task 14: Add Missing Colors to AppColors

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add any missing colors to `AppColors` if needed for status/type colors.

**Files to Modify**:
- `lib/app/theme/app_colors.dart`

**Implementation Steps**:
1. Review existing colors in `AppColors`

2. Add missing colors if needed:
   ```dart
   class AppColors {
     // ... existing colors ...
     
     // Add if missing:
     static Color onHoldStatus = const Color(0xFFFF9800); // Orange
   }
   ```

3. Ensure all status colors exist:
   - pendingStatus ✅
   - inProgressStatus ✅
   - completedStatus ✅
   - cancelledStatus ✅
   - onHoldStatus (add if missing)

**Expected Results**:
- ✅ All required colors exist in AppColors
- ✅ Colors are properly defined

**Test Criteria**:
- Test: Verify all colors exist
- Test: Verify colors are accessible

---

### Task 15: Update Task Display Text to Use Enum

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Update all UI components to use enum `displayText` instead of hardcoded strings.

**Files to Modify**:
- All task-related UI components

**Implementation Steps**:
1. Search for hardcoded type/status display text:
   ```bash
   grep -r "'Daily'\|'Project'\|'Pending'\|'In Progress'" lib/
   ```

2. Replace with enum displayText:
   ```dart
   // Before:
   Text('Daily')
   
   // After:
   Text(task.taskType.displayText)
   
   // Before:
   Text('Pending')
   
   // After:
   Text(task.status.displayText)
   ```

3. Update all components:
   - Task card
   - Task list
   - Task detail
   - Dropdowns
   - Filters

**Expected Results**:
- ✅ All components use enum displayText
- ✅ No hardcoded display text
- ✅ Display text is consistent

**Test Criteria**:
- Manual test: Check all UI components
- Test: Verify no hardcoded text remains

---

### Task 16: Update Task Icons to Use Enum

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Update all UI components to use enum icon getters instead of hardcoded icon names.

**Files to Modify**:
- All task-related UI components

**Implementation Steps**:
1. Search for hardcoded icon names

2. Replace with enum icon getter:
   ```dart
   // Before:
   Icon(Icons.calendar_today)
   
   // After:
   Icon(IconData(
     task.taskType.iconName.codePoint,
     fontFamily: 'MaterialIcons',
   ))
   // Or use a helper method
   ```

3. Update all components showing task type/status icons

**Expected Results**:
- ✅ All components use enum icons
- ✅ Icons are consistent

**Test Criteria**:
- Manual test: Check all icons
- Test: Verify icons are correct

---

### Task 17: Add Unit Tests for Color Mapping

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write unit tests for color mapping functionality.

**Files to Create**:
- `test/core/constants/task_enums_test.dart` (new file or update existing)

**Implementation Steps**:
1. Test TaskType color getter:
   ```dart
   test('TaskType.daily.color returns correct color', () {
     expect(TaskType.daily.color, AppColors.dailyTask);
   });
   
   test('TaskType.project.color returns correct color', () {
     expect(TaskType.project.color, AppColors.projectTask);
   });
   ```

2. Test TaskStatus color getter:
   ```dart
   test('TaskStatus.pending.color returns correct color', () {
     expect(TaskStatus.pending.color, AppColors.pendingStatus);
   });
   // Test all statuses
   ```

3. Test icon getters (if implemented)

4. Test displayText getters

**Expected Results**:
- ✅ Unit tests cover color mapping
- ✅ All tests pass
- ✅ Test coverage meets requirements

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass

---

### Task 18: Add Visual Regression Tests (Optional)

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add visual regression tests to ensure color consistency (optional).

**Files to Create**:
- `test/widgets/task_color_consistency_test.dart` (new file, optional)

**Implementation Steps**:
1. Create widget tests that verify colors:
   ```dart
   testWidgets('Task card uses correct type color', (tester) async {
     final task = TaskEntity(/* ... */, taskType: TaskType.daily);
     await tester.pumpWidget(TaskCard(task: task));
     
     final chip = find.byType(Chip);
     expect(chip, findsOneWidget);
     // Verify color matches enum color
   });
   ```

2. Test all UI components for color consistency

**Expected Results**:
- ✅ Visual tests exist (if implemented)
- ✅ Tests verify color consistency

**Test Criteria**:
- Run widget tests
- Verify colors are consistent

---

## Implementation Priority Order

1. **Task 1**: Update TaskEntity to Use TaskType Enum (Critical - Foundation)
2. **Task 2**: Add Color Getter to TaskType Enum (High Priority - Core Feature)
3. **Task 3**: Add Color Getter to TaskStatus Enum (High Priority - Core Feature)
4. **Task 6**: Update Task Card to Use Centralized Color Mapping (High Priority - UI)
5. **Task 7**: Update Task List Page to Use Centralized Color Mapping (High Priority - UI)
6. **Task 9**: Update Task Edit Form to Use Enum (High Priority - UI)
7. **Task 10**: Update Task Controllers to Use TaskType Enum (High Priority - Business Logic)
8. **Task 13**: Update All UI Components to Use Centralized Colors (High Priority - Consistency)
9. **Task 4**: Add Icon Getter to TaskType Enum (Medium Priority - Enhancement)
10. **Task 5**: Add Icon Getter to TaskStatus Enum (Medium Priority - Enhancement)
11. **Task 8**: Update Dashboard to Use Centralized Color Mapping (Medium Priority - UI)
12. **Task 11**: Add Task Type Filter Using Enum (Medium Priority - Feature Enhancement)
13. **Task 14**: Add Missing Colors to AppColors (Medium Priority - Foundation)
14. **Task 15**: Update Task Display Text to Use Enum (Medium Priority - Consistency)
15. **Task 17**: Add Unit Tests for Color Mapping (Medium Priority - Quality Assurance)
16. **Task 16**: Update Task Icons to Use Enum (Low Priority - Enhancement)
17. **Task 12**: Create Color Helper Utility (Low Priority - Optional)
18. **Task 18**: Add Visual Regression Tests (Low Priority - Optional)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ TaskEntity uses TaskType enum
- ✅ TaskType enum has color getter
- ✅ TaskStatus enum has color getter
- ✅ All UI components use centralized color mapping
- ✅ No hardcoded colors remain
- ✅ Colors are consistent across all components
- ✅ Task type filter uses enum
- ✅ All display text uses enum
- ✅ All icons use enum (if implemented)
- ✅ Unit tests cover color mapping
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ No known bugs or issues

---

## Dependencies

- **TaskEntity**: Must use TaskType enum
- **task_enums.dart**: Must have color/icon getters
- **AppColors**: Must have all required colors
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants

---

## Notes

1. **Enum Enforcement**: This overlaps with TASK_CRUD_DETAILS_TASKS.md Task 1. Coordinate to avoid duplicate work. The focus here is on classification and color mapping.

2. **Color Centralization**: The goal is to have a single source of truth for colors:
   - Colors defined in `AppColors`
   - Colors accessed via enum getters
   - No hardcoded colors in UI components

3. **Status Colors**: Map all status values to colors:
   - Pending: Gray
   - In Progress: Blue
   - Completed: Green/Primary
   - Cancelled: Red
   - On Hold: Orange/Warning

4. **Type Colors**: Map all type values to colors:
   - Daily: Primary color (ties to app theme)
   - Project: Blue

5. **Consistency**: All UI components must use the same color mapping to ensure visual consistency across the app.

6. **Icons**: Icons can be added to enums or kept in `TaskConstants`. Prefer enum getters for consistency.

7. **Display Text**: All display text should come from enum `displayText` getter or `AppStrings` constants.

8. **Migration**: When updating TaskEntity to use enum, existing tasks with string types will be converted via `fromMap`. No data migration needed.

---

## Related Documentation

- `TASKS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `TASK_CLASSIFICATION_COLOR_TEST_CASES.md` - Test cases for this feature
- `TASK_CRUD_DETAILS_TASKS.md` - Overlaps with enum enforcement (coordinate)
- `docs/v1/feature_checklists/tasks/tasks.md` - Task requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
