# Tasks Within Project (Add/Remove/Edit; Assign Team/Group/Member; Filters; Status Breakdown) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Tasks Within Project** feature (add/remove/edit; assign team/group/member; filters by status/priority/assignee/tag; status breakdown). Currently, this feature is **PARTIAL** - tasks link via `projectId`, but no team/group assignment support exists, filter/tag coverage is unclear, and status breakdown is not implemented.

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `TaskEntity` has `projectId` field - tasks can be linked to projects
- ✅ `ProjectRepository.getProjectTasks()` method exists - can get tasks for a project
- ✅ `FirebaseDatabaseService` supports filtering by `projectId`
- ✅ Task assignment to single member exists (`assignee` field)
- ✅ Basic `ProjectStatistics` exists (totalTasks, completedTasks, etc.)

### What's Missing/Broken:
- ⛔ Team/group assignment support - no `teamId` or `groupId` fields in TaskEntity
- ⛔ Tag support - no `tags` field in TaskEntity
- ⛔ Tag filter - cannot filter tasks by tag
- ⛔ Team filter - cannot filter tasks by team
- ⛔ Status breakdown per project - detailed breakdown not implemented
- ⛔ UI for viewing tasks within project - may be missing or incomplete
- ⛔ UI for adding tasks to project - may be missing or incomplete
- ⛔ UI for removing tasks from project - may be missing

---

## Task List

### Task 1: Add Tags Field to TaskEntity

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add tags field to `TaskEntity` to support task tagging.

**Files to Modify**:
- `lib/features/tasks/domain/entities/task.dart`

**Implementation Steps**:
1. Add tags field to `TaskEntity`:
   ```dart
   class TaskEntity {
     // ... existing fields ...
     final String? projectId;
     final List<String> tags; // Add tags field
     
     const TaskEntity({
       // ... existing parameters ...
       this.projectId,
       this.tags = const [], // Default to empty list
     });
   }
   ```

2. Update `fromMap` factory:
   ```dart
   factory TaskEntity.fromMap(Map<dynamic, dynamic> map) {
     return TaskEntity(
       // ... existing fields ...
       projectId: map['projectId'] as String?,
       tags: (map['tags'] as List<dynamic>?)
           ?.map((e) => e.toString())
           .toList() ?? <String>[],
     );
   }
   ```

3. Update `toMap` method:
   ```dart
   Map<String, dynamic> toMap() {
     return <String, dynamic>{
       // ... existing fields ...
       'projectId': projectId,
       'tags': tags,
     };
   }
   ```

4. Update `copyWith` method to include tags

**Expected Results**:
- ✅ Tags field is added to TaskEntity
- ✅ Entity supports multiple tags
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity creation with tags
- Test: Verify tags are included in toMap/fromMap

---

### Task 2: Add Team/Group Assignment Fields to TaskEntity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add team and group assignment fields to `TaskEntity` to support team/group assignment.

**Files to Modify**:
- `lib/features/tasks/domain/entities/task.dart`

**Implementation Steps**:
1. Add team/group fields to `TaskEntity`:
   ```dart
   class TaskEntity {
     // ... existing fields ...
     final String? assignee; // Existing single assignee
     final String? teamId; // Add team assignment
     final String? groupId; // Add group assignment
     
     const TaskEntity({
       // ... existing parameters ...
       this.assignee,
       this.teamId,
       this.groupId,
     });
   }
   ```

2. Update `fromMap` factory to include teamId and groupId

3. Update `toMap` method to include teamId and groupId

4. Update `copyWith` method to include teamId and groupId

**Expected Results**:
- ✅ Team/group fields are added to TaskEntity
- ✅ Entity supports team/group assignment
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity creation with team/group
- Test: Verify team/group are included in toMap/fromMap

---

### Task 3: Create Project Tasks View UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI to view tasks within a project.

**Files to Create/Modify**:
- `lib/app/pages/projects/project_detail_page.dart` (new file)
- `lib/features/tasks/presentation/pages/project_detail_page.dart` (new file)

**Implementation Steps**:
1. Create `ProjectDetailPage`:
   ```dart
   class ProjectDetailPage extends StatelessWidget {
     final Project project;
     
     @override
     Widget build(BuildContext context) {
       return GetBuilder<ProjectController>(
         builder: (controller) => Scaffold(
           appBar: TDAppBar(
             title: project.title,
           ),
           body: Column(
             children: [
               _buildProjectInfo(project),
               _buildTasksSection(project, controller),
             ],
           ),
         ),
       );
     }
     
     Widget _buildTasksSection(Project project, ProjectController controller) {
       return Expanded(
         child: FutureBuilder<List<TaskEntity>>(
           future: controller.getProjectTasks(project.id),
           builder: (context, snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting) {
               return TDLoadingIndicator();
             }
             
             if (snapshot.hasError) {
               return TDErrorWidget(message: snapshot.error.toString());
             }
             
             final tasks = snapshot.data ?? [];
             
             if (tasks.isEmpty) {
               return _buildEmptyState();
             }
             
             return ListView.builder(
               itemCount: tasks.length,
               itemBuilder: (context, index) {
                 return TaskCard(task: tasks[index]);
               },
             );
           },
         ),
       );
     }
   }
   ```

2. Add navigation to project detail page from project list

3. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Project detail page exists
- ✅ Tasks section displays tasks with matching projectId
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: View project detail page
- Test: Verify tasks are displayed correctly
- Test: Verify only matching tasks are shown

---

### Task 4: Add Get Project Tasks Method to ProjectController

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add method to `ProjectController` to get tasks for a project.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/project_controller.dart`

**Implementation Steps**:
1. Add method to get project tasks:
   ```dart
   Future<List<TaskEntity>> getProjectTasks(String projectId) async {
     try {
       return await _projectRepository.getProjectTasks(
         workspaceId: _workspaceContext.currentWorkspaceId,
         projectId: projectId,
       );
     } catch (e) {
       throw ProjectControllerException('Failed to get project tasks: $e');
     }
   }
   ```

2. Add method to get filtered project tasks:
   ```dart
   Future<List<TaskEntity>> getProjectTasksFiltered({
     required String projectId,
     TaskStatus? status,
     TaskPriority? priority,
     String? assigneeId,
     String? teamId,
     List<String>? tags,
   }) async {
     // Get all project tasks
     final allTasks = await getProjectTasks(projectId);
     
     // Apply filters
     var filtered = allTasks;
     if (status != null) {
       filtered = filtered.where((t) => TaskStatus.fromString(t.status) == status).toList();
     }
     if (priority != null) {
       filtered = filtered.where((t) => TaskPriority.fromString(t.priority) == priority).toList();
     }
     if (assigneeId != null) {
       filtered = filtered.where((t) => t.assignee == assigneeId).toList();
     }
     if (teamId != null) {
       filtered = filtered.where((t) => t.teamId == teamId).toList();
     }
     if (tags != null && tags.isNotEmpty) {
       filtered = filtered.where((t) => tags.any((tag) => t.tags.contains(tag))).toList();
     }
     
     return filtered;
   }
   ```

**Expected Results**:
- ✅ Method exists to get project tasks
- ✅ Method supports filtering
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test get project tasks
- Test: Verify filtering works correctly

---

### Task 5: Create Add Task to Project UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI to add task to a project.

**Files to Create/Modify**:
- `lib/app/pages/projects/project_detail_page.dart` (modify)
- `lib/features/tasks/presentation/widgets/create_task_form.dart` (modify)

**Implementation Steps**:
1. Add "Add Task" button to project detail page:
   ```dart
   floatingActionButton: FloatingActionButton(
     onPressed: () => _showAddTaskDialog(context, project),
     child: Icon(Icons.add),
   ),
   ```

2. Create add task dialog:
   ```dart
   Future<void> _showAddTaskDialog(BuildContext context, Project project) async {
     await showDialog(
       context: context,
       builder: (context) => CreateTaskDialog(
         projectId: project.id,
         onTaskCreated: () {
           // Refresh tasks list
         },
       ),
     );
   }
   ```

3. Update `CreateTaskForm` to support pre-filled project:
   ```dart
   class CreateTaskForm extends StatelessWidget {
     final String? projectId; // Pre-filled project ID
     
     // ... existing code ...
     
     @override
     Widget build(BuildContext context) {
       // Pre-fill project field if projectId is provided
       if (projectId != null && _selectedProject == null) {
         // Load project and set as selected
       }
       
       // ... rest of form ...
     }
   }
   ```

**Expected Results**:
- ✅ Add task button exists on project detail page
- ✅ Create task dialog appears
- ✅ Project is pre-filled
- ✅ Task is created with correct projectId

**Test Criteria**:
- Manual test: Add task to project
- Test: Verify task is created with projectId
- Test: Verify task appears in project tasks list

---

### Task 6: Create Remove Task from Project UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI to remove task from a project (unlink, not delete).

**Files to Create/Modify**:
- `lib/app/pages/projects/project_detail_page.dart` (modify)
- `lib/features/tasks/presentation/widgets/task_card.dart` (modify)

**Implementation Steps**:
1. Add "Remove from Project" option to task card menu:
   ```dart
   PopupMenuButton<String>(
     onSelected: (value) {
       if (value == 'remove_from_project') {
         _removeTaskFromProject(task);
       }
     },
     itemBuilder: (context) => [
       PopupMenuItem(
         value: 'remove_from_project',
         child: Row(
           children: [
             Icon(Icons.link_off),
             SizedBox(width: 8),
             Text(AppStrings.removeFromProject),
           ],
         ),
       ),
     ],
   )
   ```

2. Create remove task method:
   ```dart
   Future<void> _removeTaskFromProject(TaskEntity task) async {
     final confirmed = await _showRemoveConfirmationDialog(context, task);
     if (!confirmed) return;
     
     // Update task to remove projectId
     final updatedTask = task.copyWith(projectId: null);
     await _taskController.updateTask(updatedTask);
     
     SnackbarService().showSuccess(
       title: AppStrings.success,
       message: AppStrings.taskRemovedFromProject,
     );
   }
   ```

3. Add confirmation dialog

4. Add AppStrings:
   ```dart
   static const String removeFromProject = 'Remove from Project';
   static const String taskRemovedFromProject = 'Task removed from project';
   ```

**Expected Results**:
- ✅ Remove from project option exists
- ✅ Confirmation dialog appears
- ✅ Task is unlinked (projectId set to null)
- ✅ Task is not deleted

**Test Criteria**:
- Manual test: Remove task from project
- Test: Verify task projectId is set to null
- Test: Verify task is not deleted

---

### Task 7: Create Assign Task to Team Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to assign task to a team.

**Files to Create**:
- `lib/features/tasks/domain/usecases/assign_task_to_team.dart` (new file)

**Implementation Steps**:
1. Create `AssignTaskToTeam` use case:
   ```dart
   class AssignTaskToTeam {
     final TaskRepository _taskRepository;
     final WorkspaceRepository _workspaceRepository;
     
     AssignTaskToTeam(this._taskRepository, this._workspaceRepository);
     
     Future<Either<Failure, TaskEntity>> call({
       required String workspaceId,
       required String taskId,
       required String teamId,
     }) async {
       // 1. Get task
       // 2. Validate task exists
       // 3. Validate team exists
       // 4. Update task: teamId = teamId
       // 5. Save to repository
       // 6. Return updated task
     }
   }
   ```

2. Add validation:
   - Task must exist
   - Team must exist
   - User must have `assignTasks` permission
   - Task must belong to workspace

3. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Validation works correctly
- ✅ Task is assigned to team
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test assign task to team
- Test: Verify validation works
- Test: Verify task is updated

---

### Task 8: Create Assign Task to Group Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to assign task to a group.

**Files to Create**:
- `lib/features/tasks/domain/usecases/assign_task_to_group.dart` (new file)

**Implementation Steps**:
1. Create `AssignTaskToGroup` use case similar to `AssignTaskToTeam`

2. Add validation:
   - Task must exist
   - Group must exist
   - User must have `assignTasks` permission
   - Task must belong to workspace

3. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Validation works correctly
- ✅ Task is assigned to group
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test assign task to group
- Test: Verify validation works
- Test: Verify task is updated

---

### Task 9: Create Task Filters UI for Project

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI for filtering tasks within a project (status, priority, assignee, tag, team).

**Files to Create/Modify**:
- `lib/app/pages/projects/project_detail_page.dart` (modify)
- `lib/app/widgets/task_filters_widget.dart` (new file)

**Implementation Steps**:
1. Create `TaskFiltersWidget`:
   ```dart
   class TaskFiltersWidget extends StatelessWidget {
     final ValueChanged<TaskFilters> onFiltersChanged;
     final TaskFilters filters;
     
     @override
     Widget build(BuildContext context) {
       return Container(
         padding: EdgeInsets.all(16),
         child: Column(
           children: [
             _buildStatusFilter(),
             _buildPriorityFilter(),
             _buildAssigneeFilter(),
             _buildTagFilter(),
             _buildTeamFilter(),
             _buildClearFiltersButton(),
           ],
         ),
       );
     }
   }
   ```

2. Add filter state management:
   ```dart
   class TaskFilters {
     TaskStatus? status;
     TaskPriority? priority;
     String? assigneeId;
     String? teamId;
     List<String> tags;
   }
   ```

3. Integrate filters with project detail page

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Filter UI exists
- ✅ All filter types are available
- ✅ Filters work correctly
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Filter tasks by status
- Test: Filter tasks by priority
- Test: Filter tasks by assignee
- Test: Filter tasks by tag
- Test: Filter tasks by team
- Test: Combine multiple filters

---

### Task 10: Add Tag Filter to FirebaseDatabaseService

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add tag filter support to `FirebaseDatabaseService` for querying tasks by tags.

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`

**Implementation Steps**:
1. Update `getPaginatedTasks` to support tag filter:
   ```dart
   Future<pagination.PaginatedResult<TaskEntity>> getPaginatedTasks({
     // ... existing parameters ...
     List<String>? tags, // Add tags parameter
   }) async {
     // ... existing code ...
     
     if (tags != null && tags.isNotEmpty) {
       // Filter tasks that have any of the specified tags
       // Note: Firebase doesn't support array-contains-any directly
       // May need to filter client-side or use multiple queries
     }
   }
   ```

2. Update `listTasks` to support tag filter:
   ```dart
   Future<List<TaskEntity>> listTasks({
     // ... existing parameters ...
     List<String>? tags,
   }) async {
     // ... existing code ...
     
     if (tags != null && tags.isNotEmpty) {
       items = items.where((task) => 
         tags.any((tag) => task.tags.contains(tag))
       ).toList();
     }
   }
   ```

**Expected Results**:
- ✅ Tag filter is supported
- ✅ Filter works correctly
- ✅ Performance is acceptable

**Test Criteria**:
- Test: Filter tasks by tag
- Test: Filter tasks by multiple tags
- Test: Verify performance

---

### Task 11: Add Team Filter to FirebaseDatabaseService

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add team filter support to `FirebaseDatabaseService` for querying tasks by team.

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`

**Implementation Steps**:
1. Update `getPaginatedTasks` to support team filter:
   ```dart
   Future<pagination.PaginatedResult<TaskEntity>> getPaginatedTasks({
     // ... existing parameters ...
     String? teamId, // Add teamId parameter
   }) async {
     // ... existing code ...
     
     if (teamId != null) {
       filters['teamId'] = teamId;
     }
   }
   ```

2. Update `listTasks` to support team filter similarly

**Expected Results**:
- ✅ Team filter is supported
- ✅ Filter works correctly

**Test Criteria**:
- Test: Filter tasks by team
- Test: Verify filter works correctly

---

### Task 12: Create Project Task Status Breakdown

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create status breakdown display for tasks within a project.

**Files to Create/Modify**:
- `lib/app/pages/projects/project_detail_page.dart` (modify)
- `lib/app/widgets/project_status_breakdown_widget.dart` (new file)

**Implementation Steps**:
1. Create `ProjectStatusBreakdownWidget`:
   ```dart
   class ProjectStatusBreakdownWidget extends StatelessWidget {
     final List<TaskEntity> tasks;
     
     @override
     Widget build(BuildContext context) {
       final breakdown = _calculateBreakdown(tasks);
       
       return Container(
         padding: EdgeInsets.all(16),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(AppStrings.taskStatusBreakdown, style: AppTextStyles.titleMedium),
             SizedBox(height: 16),
             _buildStatusRow('Pending', breakdown.pending, breakdown.total),
             _buildStatusRow('In Progress', breakdown.inProgress, breakdown.total),
             _buildStatusRow('Completed', breakdown.completed, breakdown.total),
             _buildStatusRow('Cancelled', breakdown.cancelled, breakdown.total),
             _buildStatusRow('On Hold', breakdown.onHold, breakdown.total),
             SizedBox(height: 16),
             _buildProgressBar(breakdown),
           ],
         ),
       );
     }
     
     StatusBreakdown _calculateBreakdown(List<TaskEntity> tasks) {
       return StatusBreakdown(
         total: tasks.length,
         pending: tasks.where((t) => t.status == 'pending').length,
         inProgress: tasks.where((t) => t.status == 'in_progress').length,
         completed: tasks.where((t) => t.status == 'completed').length,
         cancelled: tasks.where((t) => t.status == 'cancelled').length,
         onHold: tasks.where((t) => t.status == 'on_hold').length,
       );
     }
   }
   ```

2. Integrate breakdown widget into project detail page

3. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Status breakdown widget exists
- ✅ Breakdown shows accurate counts
- ✅ Breakdown is visual (progress bars/charts)
- ✅ Breakdown updates in real-time

**Test Criteria**:
- Manual test: View status breakdown
- Test: Verify counts are accurate
- Test: Verify breakdown updates when tasks change

---

### Task 13: Add Unit Tests for Project Tasks Feature

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for project tasks functionality.

**Files to Create**:
- `test/features/tasks/domain/usecases/assign_task_to_team_test.dart`
- `test/features/tasks/domain/usecases/assign_task_to_group_test.dart`
- `test/features/tasks/presentation/controllers/project_controller_tasks_test.dart`

**Implementation Steps**:
1. Test `AssignTaskToTeam` use case:
   - Test assigning task to team
   - Test validation (task not found, team not found)
   - Test permission checks

2. Test `AssignTaskToGroup` use case similarly

3. Test `ProjectController.getProjectTasks`:
   - Test getting project tasks
   - Test filtering
   - Test error handling

**Expected Results**:
- ✅ Unit tests cover project tasks feature
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 2**: Add Team/Group Assignment Fields to TaskEntity (High Priority - Foundation)
2. **Task 1**: Add Tags Field to TaskEntity (Medium Priority - Foundation)
3. **Task 3**: Create Project Tasks View UI (High Priority - UI)
4. **Task 4**: Add Get Project Tasks Method to ProjectController (High Priority - Controller Layer)
5. **Task 5**: Create Add Task to Project UI (High Priority - UI)
6. **Task 6**: Create Remove Task from Project UI (Medium Priority - UI)
7. **Task 7**: Create Assign Task to Team Use Case (High Priority - Business Logic)
8. **Task 8**: Create Assign Task to Group Use Case (High Priority - Business Logic)
9. **Task 9**: Create Task Filters UI for Project (Medium Priority - Feature Enhancement)
10. **Task 10**: Add Tag Filter to FirebaseDatabaseService (Medium Priority - Data Layer)
11. **Task 11**: Add Team Filter to FirebaseDatabaseService (Medium Priority - Data Layer)
12. **Task 12**: Create Project Task Status Breakdown (Medium Priority - Feature Enhancement)
13. **Task 13**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Tasks can be viewed within a project
- ✅ Tasks can be added to a project
- ✅ Tasks can be removed from a project (unlinked)
- ✅ Tasks can be edited within a project
- ✅ Tasks can be assigned to teams
- ✅ Tasks can be assigned to groups
- ✅ Tasks can be assigned to members
- ✅ Tasks can be filtered by status, priority, assignee, tag, team
- ✅ Multiple filters can be combined
- ✅ Project shows task status breakdown
- ✅ Task count is displayed correctly
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ No known bugs or issues

---

## Dependencies

- **TaskEntity**: Needs tags, teamId, groupId fields
- **ProjectRepository**: Already has `getProjectTasks` method
- **TeamGroup**: Exists for team assignment
- **Firebase Realtime Database**: Required for storing tasks
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications

---

## Notes

1. **Task Linkage**: Tasks already link to projects via `projectId` field. This is good and working.

2. **Team/Group Assignment**: Currently, tasks only have single `assignee` field. Need to add `teamId` and `groupId` fields to support team/group assignment.

3. **Tags**: Tags are completely missing. Need to add `tags` field (List<String>) to TaskEntity.

4. **Filters**: Status/priority/assignee filters may exist but need verification. Tag and team filters are missing.

5. **Status Breakdown**: Basic `ProjectStatistics` exists but may not show detailed breakdown. Need to create visual breakdown widget.

6. **UI**: Project detail page may be missing or incomplete. Need to create comprehensive UI for viewing/managing tasks within project.

7. **Migration**: When adding new fields (tags, teamId, groupId), need to handle existing tasks:
   - Tags: Default to empty list
   - TeamId/GroupId: Default to null

---

## Related Documentation

- `PROJECTS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `PROJECT_TASKS_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/tasks/TASKS_IMPLEMENTATION_AUDIT_REPORT.md` - Task implementation status
- `docs/v1/feature_checklists/user_management/MEMBERS_TEAMS_TASKS.md` - Team management tasks
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture

