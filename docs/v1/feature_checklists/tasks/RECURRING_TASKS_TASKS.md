# Recurring Tasks - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Recurring Tasks** feature. Currently, this feature is **PARTIAL** - `TaskEntity.recurring` + `generate_recurring_tasks.dart` use case exist; UI wiring unclear; no scheduler hook observed in controllers.

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `TaskEntity.recurring` field with `RecurringConfig` (isRecurring, frequency, interval, endDate)
- ✅ `GenerateRecurringTasks` use case with generation logic
- ✅ `RecurringTaskService` with generation methods
- ✅ `RecurringTaskController` with manual generation methods
- ✅ `RecurringTaskRepository` and implementation
- ✅ UI in `task_edit_page.dart` for setting recurring config (frequency, interval, end date)
- ✅ Dashboard controller calls `_checkAndGenerateRecurringTasks()` in `onInit()` (partial - only when dashboard opens)

### What's Missing/Broken:
- ⚠️ UI wiring unclear - recurring config may not be properly saved/loaded
- ⛔ No scheduler hook - no automatic periodic generation (only manual trigger in dashboard onInit)
- ⚠️ Manual generation not wired to UI - controller exists but may not be accessible from UI
- ⚠️ Generation cooldown may not be enforced everywhere
- ⚠️ Statistics may not be displayed in UI

---

## Task List

### Task 1: Verify and Fix UI Wiring for Recurring Config

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Verify that recurring configuration is properly saved when creating/editing tasks and properly loaded when editing tasks. Fix any wiring issues.

**Files to Modify**:
- `lib/app/pages/tasks/task_edit_page.dart`
- `lib/features/tasks/presentation/controllers/task_controller.dart`
- `lib/features/tasks/presentation/widgets/create_task_form.dart` (if used)

**Implementation Steps**:
1. Review `task_edit_page.dart`:
   - Verify recurring config is saved when creating task:
     ```dart
     recurring: RecurringConfig(
       isRecurring: _isRecurring,
       frequency: _isRecurring ? _frequency : null,
       interval: _isRecurring ? _interval : null,
       endDate: _isRecurring ? _endDate : null,
     ),
     ```
   - Verify recurring config is loaded when editing task:
     ```dart
     _isRecurring = arg.recurring.isRecurring;
     _frequency = arg.recurring.frequency ?? 'daily';
     _interval = arg.recurring.interval ?? 1;
     _endDate = arg.recurring.endDate;
     ```

2. Test save/load:
   - Create task with recurring config
   - Verify config is saved to Firebase
   - Edit task
   - Verify config is loaded correctly

3. Fix any issues:
   - Ensure `RecurringConfig` is properly serialized/deserialized
   - Ensure UI state matches entity state
   - Ensure validation works (e.g., interval >= 1)

4. Add validation:
   - Interval must be >= 1
   - End date must be in future (if set)
   - Frequency must be valid (daily/weekly/monthly)

**Expected Results**:
- ✅ Recurring config is properly saved when creating tasks
- ✅ Recurring config is properly loaded when editing tasks
- ✅ Validation works correctly
- ✅ UI state matches entity state

**Test Criteria**:
- Test: Create task with recurring config, verify it's saved
- Test: Edit task, verify config is loaded
- Test: Validation works (interval, end date)

---

### Task 2: Wire Manual Generation to UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add UI button/option to manually trigger recurring task generation.

**Files to Create/Modify**:
- `lib/app/pages/tasks/task_list_page.dart` (add button)
- OR `lib/app/pages/settings/recurring_tasks_page.dart` (new page)
- `lib/features/tasks/presentation/controllers/recurring_task_controller.dart` (already exists)

**Implementation Steps**:
1. Option 1: Add button to task list page:
   ```dart
   FloatingActionButton(
     onPressed: () async {
       final controller = Get.find<RecurringTaskController>();
       await controller.generateRecurringTasks();
     },
     child: Icon(Icons.refresh),
     tooltip: AppStrings.generateRecurringTasks,
   )
   ```

2. Option 2: Create dedicated recurring tasks page:
   ```dart
   class RecurringTasksPage extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       final controller = Get.find<RecurringTaskController>();
       return Scaffold(
         appBar: AppBar(title: Text(AppStrings.recurringTasks)),
         body: Column(
           children: [
             TDButton(
               onPressed: () => controller.generateRecurringTasks(),
               text: AppStrings.generateRecurringTasks,
             ),
             // Show statistics
             Obx(() => Text('Last: ${controller.formattedLastGenerationTime}')),
           ],
         ),
       );
     }
   }
   ```

3. Use TD widgets and AppStrings:
   - Use `TDButton` instead of `FloatingActionButton`
   - Use `AppStrings` for all text
   - Use `SnackbarService` instead of `Get.snackbar`

4. Update `RecurringTaskController` to use `SnackbarService`:
   ```dart
   // Replace Get.snackbar with:
   SnackbarService().showSuccess(
     title: AppStrings.success,
     message: AppStrings.recurringTasksGenerated(result.totalGenerated),
   );
   ```

**Expected Results**:
- ✅ Manual generation button/option exists in UI
- ✅ Button triggers generation
- ✅ User sees generation progress and results
- ✅ UI follows project rules (TD widgets, AppStrings, SnackbarService)

**Test Criteria**:
- Test: Button exists and is accessible
- Test: Button triggers generation
- Test: User sees results

---

### Task 3: Implement Automatic Scheduler Hook

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Implement automatic periodic scheduler to generate recurring tasks without user interaction.

**Files to Create/Modify**:
- `lib/core/services/recurring_task_scheduler_service.dart` (new file)
- `lib/app/app.dart` (initialize scheduler)
- `lib/features/tasks/presentation/controllers/recurring_task_controller.dart` (optional - integrate)

**Implementation Steps**:
1. Create `RecurringTaskSchedulerService`:
   ```dart
   class RecurringTaskSchedulerService extends GetxService {
     Timer? _generationTimer;
     final RecurringTaskService _recurringTaskService = Get.find<RecurringTaskService>();
     
     @override
     void onInit() {
       super.onInit();
       _startScheduler();
     }
     
     void _startScheduler() {
       // Run generation check every hour
       _generationTimer = Timer.periodic(
         Duration(hours: 1),
         (_) => _checkAndGenerate(),
       );
       
       // Also run immediately on startup
       _checkAndGenerate();
     }
     
     Future<void> _checkAndGenerate() async {
       try {
         final shouldRun = await _recurringTaskService.shouldRunGeneration();
         if (shouldRun) {
           await _recurringTaskService.generateRecurringTasks();
           await _recurringTaskService.markGenerationRun();
         }
       } catch (e) {
         // Log error but don't throw
         print('Scheduled generation failed: $e');
       }
     }
     
     @override
     void onClose() {
       _generationTimer?.cancel();
       super.onClose();
     }
   }
   ```

2. Initialize scheduler in `app.dart`:
   ```dart
   // After initializing RecurringTaskService
   Get.put(RecurringTaskSchedulerService());
   ```

3. Add app lifecycle handling:
   - Resume scheduler when app resumes
   - Pause scheduler when app is backgrounded (optional)

4. Add configuration:
   - Make interval configurable (default: 1 hour)
   - Allow disabling scheduler (for testing)

**Expected Results**:
- ✅ Scheduler service exists
- ✅ Scheduler runs periodically (every hour)
- ✅ Generation happens automatically
- ✅ Scheduler respects cooldown
- ✅ Scheduler handles errors gracefully

**Test Criteria**:
- Test: Scheduler runs periodically
- Test: Generation happens automatically
- Test: Cooldown is respected
- Test: Errors are handled

---

### Task 4: Add Recurring Task Statistics UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI to display recurring task generation statistics.

**Files to Create/Modify**:
- `lib/app/pages/settings/recurring_tasks_page.dart` (new file, OR add to existing settings)
- `lib/features/tasks/presentation/controllers/recurring_task_controller.dart` (already has stats)

**Implementation Steps**:
1. Create recurring tasks settings page:
   ```dart
   class RecurringTasksPage extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       final controller = Get.find<RecurringTaskController>();
       
       return Scaffold(
         appBar: AppBar(title: Text(AppStrings.recurringTasks)),
         body: GetBuilder<RecurringTaskController>(
           builder: (ctrl) {
             final stats = ctrl.generationStats;
             return ListView(
               padding: EdgeInsets.all(AppSpacing.md),
               children: [
                 // Statistics card
                 TDCard(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(AppStrings.statistics, style: AppTextStyles.heading),
                       SizedBox(height: AppSpacing.sm),
                       Text('${AppStrings.totalRecurringTasks}: ${stats?.totalRecurringTasks ?? 0}'),
                       if (stats?.lastGenerationTime != null)
                         Text('${AppStrings.lastGeneration}: ${ctrl.formattedLastGenerationTime}'),
                       if (stats?.nextScheduledGeneration != null)
                         Text('${AppStrings.nextGeneration}: ${ctrl.formattedNextScheduledGeneration}'),
                     ],
                   ),
                 ),
                 
                 // Manual generation button
                 TDButton(
                   onPressed: () => ctrl.generateRecurringTasks(),
                   text: AppStrings.generateRecurringTasks,
                   isLoading: ctrl.isGenerating,
                 ),
                 
                 // Force generation button (for testing)
                 if (kDebugMode)
                   TDButton(
                     onPressed: () => ctrl.forceGenerateRecurringTasks(),
                     text: AppStrings.forceGenerate,
                     variant: ButtonVariant.outlined,
                   ),
               ],
             );
           },
         ),
       );
     }
   }
   ```

2. Use TD widgets and AppStrings:
   - Use `TDCard`, `TDButton`
   - Use `AppStrings` for all text
   - Use `AppSpacing` for spacing
   - Use `AppTextStyles` for text styles

3. Add route:
   ```dart
   GetPage(
     name: AppRoutes.recurringTasks,
     page: () => RecurringTasksPage(),
   ),
   ```

**Expected Results**:
- ✅ Statistics page exists
- ✅ Statistics are displayed correctly
- ✅ Manual generation button works
- ✅ UI follows project rules

**Test Criteria**:
- Test: Statistics are displayed
- Test: Statistics are accurate
- Test: Manual generation works

---

### Task 5: Use TaskFrequency Enum Instead of String

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Update `RecurringConfig` to use `TaskFrequency` enum instead of string for frequency.

**Files to Modify**:
- `lib/features/tasks/domain/entities/task.dart` (RecurringConfig)
- `lib/features/tasks/domain/usecases/generate_recurring_tasks.dart`
- `lib/app/pages/tasks/task_edit_page.dart`
- All places that use frequency

**Implementation Steps**:
1. Update `RecurringConfig`:
   ```dart
   class RecurringConfig {
     final bool isRecurring;
     final TaskFrequency? frequency; // Change from String? to TaskFrequency?
     final int? interval;
     final DateTime? endDate;
     
     // Update fromMap to use enum:
     factory RecurringConfig.fromMap(Map<dynamic, dynamic>? map) {
       if (map == null) {
         return const RecurringConfig(isRecurring: false);
       }
       return RecurringConfig(
         isRecurring: (map['isRecurring'] as bool?) ?? false,
         frequency: map['frequency'] != null
             ? TaskFrequency.fromString(map['frequency'] as String)
             : null,
         interval: map['interval'] as int?,
         endDate: map['endDate'] != null
             ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int)
             : null,
       );
     }
     
     // Update toMap to use enum value:
     Map<String, dynamic> toMap() {
       return <String, dynamic>{
         'isRecurring': isRecurring,
         'frequency': frequency?.value,
         'interval': interval,
         'endDate': endDate?.millisecondsSinceEpoch,
       };
     }
   }
   ```

2. Update `GenerateRecurringTasks` use case:
   ```dart
   switch (frequency) {
     case TaskFrequency.daily:
       return calculateDailyInstances(startDate, endDate, interval);
     case TaskFrequency.weekly:
       return calculateWeeklyInstances(startDate, endDate, interval);
     case TaskFrequency.monthly:
       return calculateMonthlyInstances(startDate, endDate, interval);
     default:
       return 0;
   }
   ```

3. Update UI to use enum:
   ```dart
   DropdownButtonFormField<TaskFrequency>(
     value: _frequency,
     items: TaskFrequency.values.map((freq) {
       return DropdownMenuItem(
         value: freq,
         child: Text(freq.displayText),
       );
     }).toList(),
     onChanged: (v) => setState(() => _frequency = v ?? TaskFrequency.daily),
   )
   ```

**Expected Results**:
- ✅ `RecurringConfig` uses `TaskFrequency` enum
- ✅ All code uses enum instead of strings
- ✅ Type safety is improved
- ✅ UI uses enum

**Test Criteria**:
- Test: Enum is used everywhere
- Test: No string literals for frequency
- Test: Type safety works

---

### Task 6: Add Recurring Task Indicator in Task List

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add visual indicator in task list to show which tasks are recurring.

**Files to Modify**:
- `lib/app/pages/tasks/task_list_page.dart`
- `lib/features/tasks/presentation/widgets/task_card.dart`

**Implementation Steps**:
1. Add recurring indicator to task card:
   ```dart
   if (task.recurring.isRecurring)
     Row(
       children: [
         Icon(Icons.repeat, size: 16, color: AppColors.primary),
         SizedBox(width: 4),
         Text(
           '${task.recurring.frequency?.displayText ?? ''}',
           style: AppTextStyles.caption,
         ),
       ],
     ),
   ```

2. Use AppColors and AppTextStyles:
   - Use `AppColors.primary` for icon color
   - Use `AppTextStyles.caption` for text

3. Add tooltip:
   - Show frequency and interval on hover/long press

**Expected Results**:
- ✅ Recurring tasks are visually identified
- ✅ Indicator shows frequency
- ✅ UI follows project rules

**Test Criteria**:
- Test: Indicator is shown for recurring tasks
- Test: Indicator is not shown for non-recurring tasks
- Test: Indicator shows correct frequency

---

### Task 7: Add Recurring Task Instance Relationship Display

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Show relationship between recurring task instances and parent task.

**Files to Modify**:
- `lib/features/tasks/presentation/widgets/task_card.dart`
- `lib/app/pages/tasks/task_detail_page.dart` (if exists)

**Implementation Steps**:
1. Add parent task link to instance:
   ```dart
   if (task.parentTaskId != null)
     InkWell(
       onTap: () {
         // Navigate to parent task
         NavigationService().toNamed<void>(
           AppRoutes.taskDetail,
           arguments: task.parentTaskId,
         );
       },
       child: Row(
         children: [
           Icon(Icons.link, size: 16),
           SizedBox(width: 4),
           Text(
             AppStrings.recurringInstance,
             style: AppTextStyles.caption,
           ),
         ],
       ),
     ),
   ```

2. Add "View Instances" link to parent task:
   ```dart
   if (task.recurring.isRecurring && task.parentTaskId == null)
     InkWell(
       onTap: () {
         // Filter tasks by parentTaskId
         // Show instances in task list
       },
       child: Text(AppStrings.viewInstances),
     ),
   ```

3. Use NavigationService and AppStrings

**Expected Results**:
- ✅ Instance relationship is shown
- ✅ User can navigate to parent task
- ✅ User can view all instances
- ✅ UI follows project rules

**Test Criteria**:
- Test: Instance shows parent link
- Test: Parent shows instances link
- Test: Navigation works

---

### Task 8: Add Recurring Task Validation

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add comprehensive validation for recurring task configuration.

**Files to Modify**:
- `lib/app/pages/tasks/task_edit_page.dart`
- `lib/features/tasks/domain/entities/task.dart` (add validation method)

**Implementation Steps**:
1. Add validation method to `RecurringConfig`:
   ```dart
   bool isValid() {
     if (!isRecurring) return true; // Non-recurring is always valid
     
     if (frequency == null) return false;
     if (interval == null || interval! < 1) return false;
     if (endDate != null && endDate!.isBefore(DateTime.now())) return false;
     
     return true;
   }
   
   String? get validationError {
     if (!isRecurring) return null;
     
     if (frequency == null) return AppStrings.frequencyRequired;
     if (interval == null || interval! < 1) return AppStrings.invalidInterval;
     if (endDate != null && endDate!.isBefore(DateTime.now())) {
       return AppStrings.endDateMustBeFuture;
     }
     
     return null;
   }
   ```

2. Add validation in UI:
   ```dart
   if (_isRecurring) {
     final error = RecurringConfig(
       isRecurring: true,
       frequency: TaskFrequency.fromString(_frequency),
       interval: _interval,
       endDate: _endDate,
     ).validationError;
     
     if (error != null) {
       SnackbarService().showError(
         title: AppStrings.validationError,
         message: error,
       );
       return;
     }
   }
   ```

3. Use AppStrings for error messages

**Expected Results**:
- ✅ Validation works correctly
- ✅ User sees clear error messages
- ✅ Invalid config is prevented

**Test Criteria**:
- Test: Validation catches invalid config
- Test: Error messages are clear
- Test: Invalid config cannot be saved

---

### Task 9: Add Recurring Task Generation Logging

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add logging for recurring task generation for debugging and monitoring.

**Files to Modify**:
- `lib/features/tasks/domain/usecases/generate_recurring_tasks.dart`
- `lib/core/services/recurring_task_service.dart`

**Implementation Steps**:
1. Add logging service (if not exists):
   ```dart
   class LoggingService {
     void logInfo(String message) {
       if (kDebugMode) print('[INFO] $message');
     }
     
     void logError(String message, [Object? error]) {
       if (kDebugMode) print('[ERROR] $message: $error');
     }
   }
   ```

2. Add logging to generation:
   ```dart
   LoggingService().logInfo('Starting recurring task generation for workspace: $workspaceId');
   LoggingService().logInfo('Found ${recurringTasks.length} recurring tasks');
   LoggingService().logInfo('Generated $generatedCount instances, skipped $skippedCount');
   ```

3. Log errors:
   ```dart
   LoggingService().logError('Failed to generate recurring tasks', e);
   ```

**Expected Results**:
- ✅ Generation is logged
- ✅ Errors are logged
- ✅ Logs are helpful for debugging

**Test Criteria**:
- Test: Logs are generated
- Test: Logs are helpful

---

### Task 10: Add Unit Tests for Recurring Tasks

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for recurring task functionality.

**Files to Create**:
- `test/features/tasks/domain/usecases/generate_recurring_tasks_test.dart`
- `test/core/services/recurring_task_service_test.dart`
- `test/features/tasks/presentation/controllers/recurring_task_controller_test.dart`
- `test/features/tasks/domain/entities/recurring_config_test.dart`

**Implementation Steps**:
1. Test `GenerateRecurringTasks` use case:
   - Test daily frequency
   - Test weekly frequency
   - Test monthly frequency
   - Test interval
   - Test end date
   - Test closed project check
   - Test error handling

2. Test `RecurringTaskService`:
   - Test generation
   - Test cooldown
   - Test statistics
   - Test error handling

3. Test `RecurringTaskController`:
   - Test manual generation
   - Test force generation
   - Test statistics loading
   - Test error handling

4. Test `RecurringConfig`:
   - Test serialization/deserialization
   - Test validation
   - Test enum usage

**Expected Results**:
- ✅ Unit tests cover recurring tasks
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Verify and Fix UI Wiring for Recurring Config (Critical - Foundation)
2. **Task 2**: Wire Manual Generation to UI (High Priority - User Experience)
3. **Task 3**: Implement Automatic Scheduler Hook (High Priority - Core Feature)
4. **Task 5**: Use TaskFrequency Enum Instead of String (Medium Priority - Code Quality)
5. **Task 8**: Add Recurring Task Validation (Medium Priority - Data Integrity)
6. **Task 4**: Add Recurring Task Statistics UI (Medium Priority - User Experience)
7. **Task 10**: Add Unit Tests (Medium Priority - Quality Assurance)
8. **Task 6**: Add Recurring Task Indicator in Task List (Low Priority - UI Enhancement)
9. **Task 7**: Add Recurring Task Instance Relationship Display (Low Priority - UI Enhancement)
10. **Task 9**: Add Recurring Task Generation Logging (Low Priority - Debugging)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Recurring config is properly saved/loaded (UI wiring fixed)
- ✅ Manual generation is accessible from UI
- ✅ Automatic scheduler runs periodically
- ✅ Recurring tasks use `TaskFrequency` enum
- ✅ Validation works correctly
- ✅ Statistics are displayed in UI
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, SnackbarService, NavigationService)
- ✅ No known bugs or issues

---

## Dependencies

- **Firebase Realtime Database**: Required for storing recurring tasks and instances
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **SnackbarService**: Must use SnackbarService instead of Get.snackbar
- **NavigationService**: Must use NavigationService for navigation
- **TaskFrequency Enum**: Must use enum from `task_enums.dart`

---

## Notes

1. **UI Wiring**: The UI exists but need to verify:
   - Recurring config is saved when creating tasks
   - Recurring config is loaded when editing tasks
   - Changes are persisted correctly

2. **Scheduler**: Currently only runs when dashboard opens. Need to implement:
   - Periodic timer (every hour)
   - Background generation
   - App lifecycle handling

3. **Manual Generation**: Controller exists but may not be wired to UI. Need to:
   - Add button/option in UI
   - Use SnackbarService instead of Get.snackbar
   - Show generation progress

4. **Enum Usage**: Currently uses strings for frequency. Should use `TaskFrequency` enum for type safety.

5. **Validation**: Need to add validation for:
   - Interval >= 1
   - End date in future (if set)
   - Frequency is valid

6. **Statistics**: Service has statistics but may not be displayed in UI. Need to create UI page.

---

## Related Documentation

- `TASKS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `RECURRING_TASKS_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/tasks/tasks.md` - Task requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `lib/core/constants/task_enums.dart` - TaskFrequency enum

