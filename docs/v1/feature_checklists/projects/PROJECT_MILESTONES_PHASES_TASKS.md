# Milestones/Phases Linked to Tasks - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Milestones/Phases Linked to Tasks** feature. Currently, this feature is **MISSING** - no milestone entity/UI exists, and tasks cannot be linked to milestones/phases.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `Project` entity exists - projects can be created
- ✅ `TaskEntity` has `projectId` field - tasks can be linked to projects
- ✅ Project repository exists - can manage projects

### What's Missing/Broken:
- ⛔ No `Milestone` entity - no milestone data structure
- ⛔ No `Phase` entity - no phase data structure
- ⛔ No `milestoneId` or `phaseId` field in `TaskEntity` - tasks cannot be linked
- ⛔ No milestone/phase repository - cannot store/retrieve milestones/phases
- ⛔ No milestone/phase CRUD operations - cannot create/edit/delete
- ⛔ No milestone/phase UI - no UI to manage milestones/phases
- ⛔ No task linkage UI - cannot link tasks to milestones/phases
- ⛔ No progress tracking - cannot track milestone/phase progress
- ⛔ No completion detection - cannot detect when milestone/phase is completed

---

## Task List

### Task 1: Create Milestone Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create `Milestone` entity to represent project milestones.

**Files to Create**:
- `lib/features/tasks/domain/entities/milestone.dart` (new file)

**Implementation Steps**:
1. Create `Milestone` entity:
   ```dart
   class Milestone {
     final String id;
     final String projectId;
     final String workspaceId;
     final String title;
     final String? description;
     final DateTime? deadline;
     final MilestoneStatus status;
     final int order; // For ordering milestones
     final String createdBy;
     final DateTime createdAt;
     final DateTime? updatedAt;
     final DateTime? completedAt;
     final bool isActive;
     
     const Milestone({
       required this.id,
       required this.projectId,
       required this.workspaceId,
       required this.title,
       required this.status,
       required this.order,
       required this.createdBy,
       required this.createdAt,
       this.description,
       this.deadline,
       this.updatedAt,
       this.completedAt,
       this.isActive = true,
     });
   }
   ```

2. Create `MilestoneStatus` enum:
   ```dart
   enum MilestoneStatus {
     planned('planned'),
     inProgress('in_progress'),
     completed('completed'),
     cancelled('cancelled');
     
     const MilestoneStatus(this.value);
     final String value;
     
     static MilestoneStatus fromString(String value) {
       return MilestoneStatus.values.firstWhere(
         (status) => status.value == value,
         orElse: () => MilestoneStatus.planned,
       );
     }
   }
   ```

3. Add `fromMap` and `toMap` methods

4. Add `copyWith` method

**Expected Results**:
- ✅ Milestone entity exists
- ✅ Entity supports all required fields
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity creation
- Test: Verify entity serialization

---

### Task 2: Add MilestoneId Field to TaskEntity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add `milestoneId` field to `TaskEntity` to link tasks to milestones.

**Files to Modify**:
- `lib/features/tasks/domain/entities/task.dart`

**Implementation Steps**:
1. Add `milestoneId` field:
   ```dart
   class TaskEntity {
     // ... existing fields ...
     final String? projectId;
     final String? milestoneId; // Add milestone linkage
     
     const TaskEntity({
       // ... existing parameters ...
       this.projectId,
       this.milestoneId,
     });
   }
   ```

2. Update `fromMap` factory:
   ```dart
   factory TaskEntity.fromMap(Map<dynamic, dynamic> map) {
     return TaskEntity(
       // ... existing fields ...
       projectId: map['projectId'] as String?,
       milestoneId: map['milestoneId'] as String?,
     );
   }
   ```

3. Update `toMap` method:
   ```dart
   Map<String, dynamic> toMap() {
     return <String, dynamic>{
       // ... existing fields ...
       'projectId': projectId,
       'milestoneId': milestoneId,
     };
   }
   ```

4. Update `copyWith` method to include milestoneId

**Expected Results**:
- ✅ MilestoneId field is added to TaskEntity
- ✅ Entity supports milestone linkage
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity creation with milestoneId
- Test: Verify milestoneId is included in toMap/fromMap

---

### Task 3: Create MilestoneRepository

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create repository interface and implementation for milestone operations.

**Files to Create**:
- `lib/features/tasks/domain/repositories/milestone_repository.dart` (new file)
- `lib/features/tasks/data/repositories/milestone_repository_impl.dart` (new file)

**Implementation Steps**:
1. Create `MilestoneRepository` interface:
   ```dart
   abstract class MilestoneRepository {
     Future<Milestone?> getMilestone({
       required String workspaceId,
       required String projectId,
       required String milestoneId,
     });
     
     Future<List<Milestone>> getMilestones({
       required String workspaceId,
       required String projectId,
     });
     
     Future<Milestone> createMilestone({
       required String workspaceId,
       required String projectId,
       required Milestone milestone,
     });
     
     Future<Milestone> updateMilestone({
       required String workspaceId,
       required String projectId,
       required Milestone milestone,
     });
     
     Future<void> deleteMilestone({
       required String workspaceId,
       required String projectId,
       required String milestoneId,
     });
     
     Future<List<TaskEntity>> getMilestoneTasks({
       required String workspaceId,
       required String projectId,
       required String milestoneId,
     });
   }
   ```

2. Implement in `MilestoneRepositoryImpl`:
   - Use `FirebaseDatabaseService` to store/retrieve milestones
   - Store in path: `workspaces/{workspaceId}/projects/{projectId}/milestones/{milestoneId}`

**Expected Results**:
- ✅ Repository interface exists
- ✅ Repository implementation exists
- ✅ All CRUD operations work correctly

**Test Criteria**:
- Unit test: Test repository methods
- Integration test: Test with Firebase

---

### Task 4: Create Create Milestone Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to create a milestone.

**Files to Create**:
- `lib/features/tasks/domain/usecases/create_milestone.dart` (new file)

**Implementation Steps**:
1. Create `CreateMilestone` use case:
   ```dart
   class CreateMilestone {
     final MilestoneRepository _repository;
     
     CreateMilestone(this._repository);
     
     Future<Either<Failure, Milestone>> call({
       required String workspaceId,
       required String projectId,
       required String title,
       String? description,
       DateTime? deadline,
       required String createdBy,
     }) async {
       // 1. Validate project exists
       // 2. Validate milestone title is not empty
       // 3. Get next order number
       // 4. Create Milestone entity
       // 5. Save to repository
       // 6. Return created milestone
     }
   }
   ```

2. Add validation:
   - Project must exist
   - Title must not be empty
   - Deadline must be in future (if provided)

3. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Validation works correctly
- ✅ Milestone is created
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test create milestone
- Test: Verify validation works
- Test: Verify milestone is created

---

### Task 5: Create Update Milestone Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to update a milestone.

**Files to Create**:
- `lib/features/tasks/domain/usecases/update_milestone.dart` (new file)

**Implementation Steps**:
1. Create `UpdateMilestone` use case similar to `CreateMilestone`

2. Add validation:
   - Milestone must exist
   - Title must not be empty
   - Deadline must be in future (if provided)

3. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Validation works correctly
- ✅ Milestone is updated
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test update milestone
- Test: Verify validation works
- Test: Verify milestone is updated

---

### Task 6: Create Delete Milestone Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to delete a milestone, with option to unlink tasks.

**Files to Create**:
- `lib/features/tasks/domain/usecases/delete_milestone.dart` (new file)

**Implementation Steps**:
1. Create `DeleteMilestone` use case:
   ```dart
   class DeleteMilestone {
     final MilestoneRepository _milestoneRepository;
     final TaskRepository _taskRepository;
     
     DeleteMilestone(this._milestoneRepository, this._taskRepository);
     
     Future<Either<Failure, void>> call({
       required String workspaceId,
       required String projectId,
       required String milestoneId,
       bool unlinkTasks = true, // Unlink tasks when deleting milestone
     }) async {
       // 1. Get milestone
       // 2. Get all tasks linked to milestone
       // 3. If unlinkTasks is true, unlink all tasks
       // 4. Delete milestone
       // 5. Return success
     }
   }
   ```

2. Add task unlinking logic:
   - Get all tasks with matching milestoneId
   - Update tasks to set milestoneId to null

3. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Milestone is deleted
- ✅ Tasks are unlinked (if option is enabled)
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test delete milestone
- Test: Verify tasks are unlinked
- Test: Verify milestone is deleted

---

### Task 7: Create Link Task to Milestone Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to link a task to a milestone.

**Files to Create**:
- `lib/features/tasks/domain/usecases/link_task_to_milestone.dart` (new file)

**Implementation Steps**:
1. Create `LinkTaskToMilestone` use case:
   ```dart
   class LinkTaskToMilestone {
     final TaskRepository _taskRepository;
     final MilestoneRepository _milestoneRepository;
     
     LinkTaskToMilestone(this._taskRepository, this._milestoneRepository);
     
     Future<Either<Failure, TaskEntity>> call({
       required String workspaceId,
       required String projectId,
       required String taskId,
       required String milestoneId,
     }) async {
       // 1. Validate task exists
       // 2. Validate milestone exists
       // 3. Validate task belongs to project
       // 4. Validate milestone belongs to project
       // 5. Update task with milestoneId
       // 6. Return updated task
     }
   }
   ```

2. Add validation:
   - Task must exist
   - Milestone must exist
   - Task must belong to project
   - Milestone must belong to project

3. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Validation works correctly
- ✅ Task is linked to milestone
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test link task to milestone
- Test: Verify validation works
- Test: Verify task is updated

---

### Task 8: Create Unlink Task from Milestone Use Case

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create use case to unlink a task from a milestone.

**Files to Create**:
- `lib/features/tasks/domain/usecases/unlink_task_from_milestone.dart` (new file)

**Implementation Steps**:
1. Create `UnlinkTaskFromMilestone` use case similar to `LinkTaskToMilestone`

2. Update task to set milestoneId to null

3. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Task is unlinked from milestone
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test unlink task from milestone
- Test: Verify task milestoneId is set to null

---

### Task 9: Create Calculate Milestone Progress Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to calculate milestone progress based on linked tasks.

**Files to Create**:
- `lib/features/tasks/domain/usecases/calculate_milestone_progress.dart` (new file)

**Implementation Steps**:
1. Create `CalculateMilestoneProgress` use case:
   ```dart
   class CalculateMilestoneProgress {
     final MilestoneRepository _milestoneRepository;
     
     CalculateMilestoneProgress(this._milestoneRepository);
     
     Future<MilestoneProgressResult> call({
       required String workspaceId,
       required String projectId,
       required String milestoneId,
     }) async {
       // 1. Get milestone
       // 2. Get all tasks linked to milestone
       // 3. Calculate progress:
       //    - Total tasks
       //    - Completed tasks
       //    - Progress percentage
       //    - Is completed (all tasks completed)
       //    - Is overdue (deadline passed and not completed)
       // 4. Return progress result
     }
   }
   ```

2. Create `MilestoneProgressResult` class:
   ```dart
   class MilestoneProgressResult {
     final int totalTasks;
     final int completedTasks;
     final int pendingTasks;
     final int inProgressTasks;
     final double progressPercentage;
     final bool isCompleted;
     final bool isOverdue;
   }
   ```

3. Calculate completion status:
   - Milestone is completed if all linked tasks are completed
   - Milestone is overdue if deadline passed and not completed

**Expected Results**:
- ✅ Use case exists
- ✅ Progress is calculated correctly
- ✅ Completion status is accurate
- ✅ Overdue detection works

**Test Criteria**:
- Unit test: Test progress calculation
- Test: Verify completion detection
- Test: Verify overdue detection

---

### Task 10: Create Milestone Management UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI for managing milestones (view, create, edit, delete).

**Files to Create/Modify**:
- `lib/app/pages/projects/milestones_page.dart` (new file)
- `lib/app/pages/projects/project_detail_page.dart` (modify)

**Implementation Steps**:
1. Create `MilestonesPage`:
   ```dart
   class MilestonesPage extends StatelessWidget {
     final Project project;
     
     @override
     Widget build(BuildContext context) {
       return GetBuilder<MilestoneController>(
         builder: (controller) => Scaffold(
           appBar: TDAppBar(
             title: AppStrings.milestones,
           ),
           body: Column(
             children: [
               _buildCreateMilestoneButton(controller),
               _buildMilestonesList(controller),
             ],
           ),
         ),
       );
     }
   }
   ```

2. Add "Milestones" button to project detail page

3. Create milestone card with:
   - Milestone info (title, description, deadline)
   - Progress indicator
   - Status indicator
   - Task count
   - Action buttons (Edit, Delete)

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Milestones page exists
- ✅ Can view milestones
- ✅ Can create milestones
- ✅ Can edit milestones
- ✅ Can delete milestones
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: View milestones
- Test: Create milestone
- Test: Edit milestone
- Test: Delete milestone

---

### Task 11: Create MilestoneController

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create GetX controller for managing milestones.

**Files to Create**:
- `lib/features/tasks/presentation/controllers/milestone_controller.dart` (new file)

**Implementation Steps**:
1. Create `MilestoneController`:
   ```dart
   class MilestoneController extends GetxController {
     final MilestoneRepository _milestoneRepository;
     final CreateMilestone _createMilestone;
     final UpdateMilestone _updateMilestone;
     final DeleteMilestone _deleteMilestone;
     final CalculateMilestoneProgress _calculateProgress;
     
     final RxList<Milestone> _milestones = <Milestone>[].obs;
     final RxMap<String, MilestoneProgressResult> _progress = <String, MilestoneProgressResult>{}.obs;
     final RxBool _isLoading = false.obs;
     
     List<Milestone> get milestones => _milestones.toList();
     bool get isLoading => _isLoading.value;
     
     Future<void> loadMilestones(String projectId) async {
       // Load milestones for project
     }
     
     Future<void> createMilestone({/* ... */}) async {
       // Create milestone with permission check
     }
     
     Future<void> updateMilestone(Milestone milestone) async {
       // Update milestone with permission check
     }
     
     Future<void> deleteMilestone(String milestoneId) async {
       // Delete milestone with permission check
     }
   }
   ```

2. Add permission checks to all methods

3. Add error handling

**Expected Results**:
- ✅ Controller exists
- ✅ Permission checks are enforced
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test controller methods
- Test: Verify permission checks
- Test: Verify error handling

---

### Task 12: Add Milestone Selector to Task Edit UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add milestone selector to task edit/create UI.

**Files to Modify**:
- `lib/app/pages/tasks/task_edit_page.dart`
- `lib/features/tasks/presentation/widgets/create_task_form.dart`

**Implementation Steps**:
1. Add milestone dropdown to task edit form:
   ```dart
   DropdownButtonFormField<String?>(
     decoration: InputDecoration(
       labelText: AppStrings.milestone,
     ),
     value: _selectedMilestoneId,
     items: [
       DropdownMenuItem<String?>(
         value: null,
         child: Text(AppStrings.none),
       ),
       ...milestones.map((milestone) {
         return DropdownMenuItem<String?>(
           value: milestone.id,
           child: Text(milestone.title),
         );
       }),
     ],
     onChanged: (value) {
       setState(() {
         _selectedMilestoneId = value;
       });
     },
   )
   ```

2. Load milestones when project is selected

3. Save milestoneId when task is saved

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Milestone selector exists in task edit UI
- ✅ Milestones are loaded correctly
- ✅ MilestoneId is saved with task
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Edit task, select milestone
- Test: Verify milestoneId is saved
- Test: Verify milestones are loaded

---

### Task 13: Create Milestone Progress Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create widget to display milestone progress.

**Files to Create**:
- `lib/app/widgets/milestone_progress_widget.dart` (new file)

**Implementation Steps**:
1. Create `MilestoneProgressWidget`:
   ```dart
   class MilestoneProgressWidget extends StatelessWidget {
     final Milestone milestone;
     final MilestoneProgressResult progress;
     
     @override
     Widget build(BuildContext context) {
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text(
                 '${progress.progressPercentage}%',
                 style: AppTextStyles.titleMedium,
               ),
               if (progress.isCompleted)
                 TDChip(
                   label: AppStrings.completed,
                   type: TDChipType.success,
                 ),
               if (progress.isOverdue)
                 TDChip(
                   label: AppStrings.overdue,
                   type: TDChipType.error,
                 ),
             ],
           ),
           SizedBox(height: 8),
           LinearProgressIndicator(
             value: progress.progressPercentage / 100,
           ),
           SizedBox(height: 8),
           Text(
             '${progress.completedTasks} of ${progress.totalTasks} tasks completed',
             style: AppTextStyles.bodySmall,
           ),
         ],
       );
     }
   }
   ```

2. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Progress widget exists
- ✅ Progress is displayed correctly
- ✅ Completion/overdue indicators work
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test progress widget
- Manual test: Verify progress displays correctly

---

### Task 14: Create Milestone Completion Detection

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create service to detect when milestone is completed and update status.

**Files to Create**:
- `lib/core/services/milestone_completion_service.dart` (new file)

**Implementation Steps**:
1. Create `MilestoneCompletionService`:
   ```dart
   class MilestoneCompletionService {
     final MilestoneRepository _milestoneRepository;
     final CalculateMilestoneProgress _calculateProgress;
     
     MilestoneCompletionService(
       this._milestoneRepository,
       this._calculateProgress,
     );
     
     Future<void> checkAndUpdateMilestone({
       required String workspaceId,
       required String projectId,
       required String milestoneId,
     }) async {
       // 1. Calculate milestone progress
       // 2. If all tasks are completed and milestone is not completed:
       //    - Update milestone status to completed
       //    - Set completedAt timestamp
       //    - Send notification (if applicable)
       // 3. Save updated milestone
     }
   }
   ```

2. Integrate with task completion:
   - When task is completed, check if milestone should be completed
   - Update milestone status if needed

3. Add notification (optional):
   - Send notification when milestone is completed

**Expected Results**:
- ✅ Service exists
- ✅ Completion is detected correctly
- ✅ Milestone status is updated
- ✅ Notification is sent (if applicable)

**Test Criteria**:
- Unit test: Test completion detection
- Test: Verify milestone status is updated
- Test: Verify notification is sent

---

### Task 15: Add Milestone Filter to Task List

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add milestone filter to task list within project.

**Files to Modify**:
- `lib/app/pages/projects/project_detail_page.dart` (modify)
- `lib/features/tasks/presentation/pages/project_detail_page.dart` (modify)

**Implementation Steps**:
1. Add milestone filter dropdown:
   ```dart
   DropdownButton<String?>(
     value: _selectedMilestoneId,
     items: [
       DropdownMenuItem<String?>(
         value: null,
         child: Text(AppStrings.allTasks),
       ),
       DropdownMenuItem<String?>(
         value: 'unlinked',
         child: Text(AppStrings.unlinkedTasks),
       ),
       ...milestones.map((milestone) {
         return DropdownMenuItem<String?>(
           value: milestone.id,
           child: Text(milestone.title),
         );
       }),
     ],
     onChanged: (value) {
       setState(() {
         _selectedMilestoneId = value;
       });
       _filterTasks();
     },
   )
   ```

2. Filter tasks based on selected milestone

3. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Milestone filter exists
- ✅ Filter works correctly
- ✅ All filter options are available
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Filter tasks by milestone
- Test: Verify filter works correctly

---

### Task 16: Create Phase Entity (If Phases Are Separate from Milestones)

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Create `Phase` entity if phases are separate from milestones (optional).

**Files to Create**:
- `lib/features/tasks/domain/entities/phase.dart` (new file)

**Implementation Steps**:
1. Create `Phase` entity similar to `Milestone`:
   ```dart
   class Phase {
     final String id;
     final String projectId;
     final String workspaceId;
     final String title;
     final String? description;
     final DateTime? startDate;
     final DateTime? endDate;
     final PhaseStatus status;
     final int order;
     // ... other fields
   }
   ```

2. Add `phaseId` field to `TaskEntity` if phases are separate

3. Create phase repository and use cases if needed

**Expected Results**:
- ✅ Phase entity exists (if needed)
- ✅ Entity supports all required fields
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity creation
- Test: Verify entity serialization

---

### Task 17: Add Milestone Ordering Support

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add support for ordering milestones (drag and drop or up/down buttons).

**Files to Modify**:
- `lib/features/tasks/domain/entities/milestone.dart` (modify)
- `lib/app/pages/projects/milestones_page.dart` (modify)

**Implementation Steps**:
1. Add `order` field to `Milestone` entity (already in Task 1)

2. Add reorder methods to repository:
   ```dart
   Future<void> reorderMilestones({
     required String workspaceId,
     required String projectId,
     required List<String> milestoneIds, // Ordered list
   }) async {
     // Update order field for each milestone
   }
   ```

3. Add reorder UI:
   - Drag and drop support
   - Or up/down arrow buttons

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Milestone ordering is supported
- ✅ Order is persisted
- ✅ UI is intuitive

**Test Criteria**:
- Manual test: Reorder milestones
- Test: Verify order is persisted

---

### Task 18: Add Bulk Link Tasks to Milestone

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add feature to link multiple tasks to a milestone at once.

**Files to Create/Modify**:
- `lib/features/tasks/domain/usecases/bulk_link_tasks_to_milestone.dart` (new file)
- `lib/app/pages/projects/project_detail_page.dart` (modify)

**Implementation Steps**:
1. Create `BulkLinkTasksToMilestone` use case:
   ```dart
   class BulkLinkTasksToMilestone {
     final TaskRepository _taskRepository;
     
     Future<Either<Failure, void>> call({
       required String workspaceId,
       required String projectId,
       required List<String> taskIds,
       required String milestoneId,
     }) async {
       // Update all tasks with milestoneId
     }
   }
   ```

2. Add bulk link UI:
   - Checkboxes for task selection
   - "Link to Milestone" button
   - Milestone selector

3. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Bulk link use case exists
- ✅ Bulk link UI exists
- ✅ Multiple tasks can be linked at once

**Test Criteria**:
- Test: Bulk link tasks to milestone
- Test: Verify all tasks are linked

---

### Task 19: Add Unit Tests for Milestones/Phases

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for milestones/phases functionality.

**Files to Create**:
- `test/features/tasks/domain/entities/milestone_test.dart`
- `test/features/tasks/domain/usecases/create_milestone_test.dart`
- `test/features/tasks/domain/usecases/calculate_milestone_progress_test.dart`
- `test/features/tasks/presentation/controllers/milestone_controller_test.dart`

**Implementation Steps**:
1. Test `Milestone` entity
2. Test use cases (create, update, delete, link, calculate progress)
3. Test controller methods
4. Test progress calculation

**Expected Results**:
- ✅ Unit tests cover milestones/phases
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Create Milestone Entity (Critical - Foundation)
2. **Task 2**: Add MilestoneId Field to TaskEntity (Critical - Foundation)
3. **Task 3**: Create MilestoneRepository (High Priority - Data Layer)
4. **Task 4**: Create Create Milestone Use Case (High Priority - Business Logic)
5. **Task 5**: Create Update Milestone Use Case (High Priority - Business Logic)
6. **Task 6**: Create Delete Milestone Use Case (High Priority - Business Logic)
7. **Task 7**: Create Link Task to Milestone Use Case (High Priority - Business Logic)
8. **Task 8**: Create Unlink Task from Milestone Use Case (Medium Priority - Business Logic)
9. **Task 9**: Create Calculate Milestone Progress Use Case (High Priority - Business Logic)
10. **Task 11**: Create MilestoneController (High Priority - Controller Layer)
11. **Task 10**: Create Milestone Management UI (High Priority - UI)
12. **Task 12**: Add Milestone Selector to Task Edit UI (High Priority - UI)
13. **Task 13**: Create Milestone Progress Widget (Medium Priority - UI)
14. **Task 14**: Create Milestone Completion Detection (Medium Priority - Feature Enhancement)
15. **Task 15**: Add Milestone Filter to Task List (Medium Priority - Feature Enhancement)
16. **Task 17**: Add Milestone Ordering Support (Low Priority - Enhancement)
17. **Task 18**: Add Bulk Link Tasks to Milestone (Low Priority - Enhancement)
18. **Task 16**: Create Phase Entity (Low Priority - Optional)
19. **Task 19**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Milestone entity exists
- ✅ TaskEntity has milestoneId field
- ✅ Milestone repository exists
- ✅ Use cases exist for CRUD and linking
- ✅ Milestone management UI exists
- ✅ Tasks can be linked to milestones
- ✅ Milestone progress is tracked
- ✅ Milestone completion is detected
- ✅ Tasks can be filtered by milestone
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ No known bugs or issues

---

## Dependencies

- **Project Entity**: Required for project linkage
- **TaskEntity**: Needs milestoneId field
- **MilestoneRepository**: Required for milestone operations
- **Firebase Realtime Database**: Required for storing milestones
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications

---

## Notes

1. **Milestone vs Phase**: Need to clarify if milestones and phases are the same or different:
   - **Option 1**: Combine into one entity (Milestone) with a type field
   - **Option 2**: Keep separate (Milestone and Phase entities)
   - **Recommendation**: Start with Milestone only, add Phase later if needed

2. **Task Linkage**: Tasks need `milestoneId` field to link to milestones. Can add `phaseId` later if phases are separate.

3. **Progress Tracking**: Milestone progress should be calculated based on linked tasks:
   - Total tasks in milestone
   - Completed tasks
   - Progress percentage
   - Completion status

4. **Completion Detection**: Milestone should be marked as completed when all linked tasks are completed. This can be automatic or manual.

5. **Deadline Tracking**: Milestones can have deadlines. Should track overdue status similar to projects.

6. **Ordering**: Milestones should be orderable to reflect project timeline. Can use `order` field or drag-and-drop.

7. **Bulk Operations**: Bulk linking tasks to milestones can be useful for efficiency.

8. **Migration**: When implementing, existing tasks will have `milestoneId = null`. No migration needed.

---

## Related Documentation

- `PROJECTS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `PROJECT_MILESTONES_PHASES_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/projects/projects.md` - Project requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
