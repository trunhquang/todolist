# Task Assignment (Team/Group/Member, Reassign, Unassign, Bulk Assign) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Task Assignment** feature (team/group/member, reassign, unassign, bulk assign). Currently, this feature is **PARTIAL** - single assignee assignment exists, but team/group assignment, bulk operations, and proper reassign/unassign flows are missing.

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `TaskEntity` has `assignee` field - single member assignment works
- ✅ `TaskController.assignTask()` method exists - can assign task to single member
- ✅ Permission checks exist (`canAssignTask`)
- ✅ Workspace member validation exists
- ✅ `TeamGroup` entity exists with `leadGroupUserId` and `members` list

### What's Missing/Broken:
- ⛔ No `teamId` or `groupId` fields in TaskEntity - cannot assign to teams/groups
- ⛔ No team/group assignment UI - cannot select team/group when assigning
- ⛔ No team/group assignment logic - no cascade to lead/members
- ⛔ No bulk assign operations - cannot assign multiple tasks at once
- ⛔ No proper reassign flow - reassign just overwrites assignee
- ⛔ No unassign functionality - cannot unassign tasks
- ⛔ No bulk reassign/unassign - cannot reassign/unassign multiple tasks at once
- ⛔ No cascade behavior - no automatic assignment to team lead/members

---

## Task List

### Task 1: Add Team/Group Assignment Fields to TaskEntity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add `teamId` and `groupId` fields to `TaskEntity` to support team/group assignment.

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

2. Update `fromMap` factory:
   ```dart
   factory TaskEntity.fromMap(Map<dynamic, dynamic> map) {
     return TaskEntity(
       // ... existing fields ...
       assignee: map['assignee'] as String?,
       teamId: map['teamId'] as String?,
       groupId: map['groupId'] as String?,
     );
   }
   ```

3. Update `toMap` method:
   ```dart
   Map<String, dynamic> toMap() {
     return <String, dynamic>{
       // ... existing fields ...
       'assignee': assignee,
       'teamId': teamId,
       'groupId': groupId,
     };
   }
   ```

4. Update `copyWith` method to include teamId and groupId

**Expected Results**:
- ✅ TeamId and groupId fields are added to TaskEntity
- ✅ Entity supports team/group assignment
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity creation with teamId/groupId
- Test: Verify teamId/groupId are included in toMap/fromMap

---

### Task 2: Create Assign Task to Team Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to assign task to team with cascade options.

**Files to Create**:
- `lib/features/tasks/domain/usecases/assign_task_to_team.dart` (new file)

**Implementation Steps**:
1. Create `AssignTaskToTeam` use case:
   ```dart
   class AssignTaskToTeam {
     final TaskRepository _taskRepository;
     final TeamRepository _teamRepository;
     final PermissionService _permissionService;
     
     AssignTaskToTeam(
       this._taskRepository,
       this._teamRepository,
       this._permissionService,
     );
     
     Future<Either<Failure, TaskEntity>> call({
       required String workspaceId,
       required String taskId,
       required String teamId,
       required TeamAssignmentOption option, // lead_only, all_members, team_only
     }) async {
       // 1. Get task
       // 2. Get team
       // 3. Validate user has permission to assign
       // 4. Validate team belongs to workspace
       // 5. Update task with teamId
       // 6. Cascade assignment based on option:
       //    - lead_only: Also set assignee to team lead
       //    - all_members: Create assignments for all members (or use visibility)
       //    - team_only: Just set teamId
       // 7. Return updated task
     }
   }
   ```

2. Create `TeamAssignmentOption` enum:
   ```dart
   enum TeamAssignmentOption {
     leadOnly('lead_only'),
     allMembers('all_members'),
     teamOnly('team_only');
     
     const TeamAssignmentOption(this.value);
     final String value;
   }
   ```

3. Add cascade logic:
   - If `leadOnly`: Set `assignee` to team lead
   - If `allMembers`: Set `assignee` to team lead (or use visibility)
   - If `teamOnly`: Just set `teamId`

**Expected Results**:
- ✅ Use case exists
- ✅ Team assignment works correctly
- ✅ Cascade options work correctly
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test assign task to team
- Test: Verify cascade options work
- Test: Verify permission checks

---

### Task 3: Create Assign Task to Group Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to assign task to group (similar to team assignment).

**Files to Create**:
- `lib/features/tasks/domain/usecases/assign_task_to_group.dart` (new file)

**Implementation Steps**:
1. Create `AssignTaskToGroup` use case similar to `AssignTaskToTeam`

2. Use `TeamGroup` entity (groups are also TeamGroup entities)

3. Add cascade logic similar to team assignment

**Expected Results**:
- ✅ Use case exists
- ✅ Group assignment works correctly
- ✅ Cascade options work correctly

**Test Criteria**:
- Unit test: Test assign task to group
- Test: Verify cascade options work

---

### Task 4: Create Reassign Task Use Case

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create use case to properly reassign task (not just overwrite assignee).

**Files to Create**:
- `lib/features/tasks/domain/usecases/reassign_task.dart` (new file)

**Implementation Steps**:
1. Create `ReassignTask` use case:
   ```dart
   class ReassignTask {
     final TaskRepository _taskRepository;
     final TaskActivityLogService _activityLogService;
     
     ReassignTask(
       this._taskRepository,
       this._activityLogService,
     );
     
     Future<Either<Failure, TaskEntity>> call({
       required String workspaceId,
       required String taskId,
       String? newAssigneeId,
       String? newTeamId,
       String? newGroupId,
     }) async {
       // 1. Get task
       // 2. Validate user has permission to reassign
       // 3. Store previous assignment
       // 4. Clear previous assignment (assignee/teamId/groupId)
       // 5. Set new assignment
       // 6. Log activity: "Reassigned from [Old] to [New]"
       // 7. Return updated task
     }
   }
   ```

2. Add activity logging:
   - Log previous assignment
   - Log new assignment
   - Log reassignment action

**Expected Results**:
- ✅ Use case exists
- ✅ Previous assignment is cleared
- ✅ New assignment is set
- ✅ Activity is logged

**Test Criteria**:
- Unit test: Test reassign task
- Test: Verify previous assignment is cleared
- Test: Verify activity is logged

---

### Task 5: Create Unassign Task Use Case

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create use case to unassign task.

**Files to Create**:
- `lib/features/tasks/domain/usecases/unassign_task.dart` (new file)

**Implementation Steps**:
1. Create `UnassignTask` use case:
   ```dart
   class UnassignTask {
     final TaskRepository _taskRepository;
     final TaskActivityLogService _activityLogService;
     
     UnassignTask(
       this._taskRepository,
       this._activityLogService,
     );
     
     Future<Either<Failure, TaskEntity>> call({
       required String workspaceId,
       required String taskId,
     }) async {
       // 1. Get task
       // 2. Validate user has permission to unassign
       // 3. Store previous assignment (for activity log)
       // 4. Clear assignment (assignee/teamId/groupId set to null)
       // 5. Log activity: "Unassigned by [User]"
       // 6. Return updated task
     }
   }
   ```

2. Add activity logging:
   - Log previous assignment
   - Log unassignment action

**Expected Results**:
- ✅ Use case exists
- ✅ Assignment fields are cleared
- ✅ Activity is logged

**Test Criteria**:
- Unit test: Test unassign task
- Test: Verify assignment fields are cleared
- Test: Verify activity is logged

---

### Task 6: Create Bulk Assign Tasks Use Case

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create use case to assign multiple tasks at once.

**Files to Create**:
- `lib/features/tasks/domain/usecases/bulk_assign_tasks.dart` (new file)

**Implementation Steps**:
1. Create `BulkAssignTasks` use case:
   ```dart
   class BulkAssignTasks {
     final TaskRepository _taskRepository;
     final TaskActivityLogService _activityLogService;
     
     BulkAssignTasks(
       this._taskRepository,
       this._activityLogService,
     );
     
     Future<Either<Failure, List<TaskEntity>>> call({
       required String workspaceId,
       required List<String> taskIds,
       String? assigneeId,
       String? teamId,
       String? groupId,
       TeamAssignmentOption? teamOption,
     }) async {
       // 1. Validate all tasks belong to workspace
       // 2. Validate user has permission to assign
       // 3. For each task:
       //    - Clear previous assignment
       //    - Set new assignment
       //    - Log activity
       // 4. Return updated tasks
     }
   }
   ```

2. Add batch update logic:
   - Update all tasks in batch
   - Log activities for all tasks

**Expected Results**:
- ✅ Use case exists
- ✅ Multiple tasks can be assigned at once
- ✅ All tasks are updated correctly
- ✅ Activities are logged

**Test Criteria**:
- Unit test: Test bulk assign tasks
- Test: Verify all tasks are assigned
- Test: Verify activities are logged

---

### Task 7: Create Bulk Reassign Tasks Use Case

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Create use case to reassign multiple tasks at once.

**Files to Create**:
- `lib/features/tasks/domain/usecases/bulk_reassign_tasks.dart` (new file)

**Implementation Steps**:
1. Create `BulkReassignTasks` use case similar to `BulkAssignTasks`

2. Use `ReassignTask` logic for each task

**Expected Results**:
- ✅ Use case exists
- ✅ Multiple tasks can be reassigned at once

**Test Criteria**:
- Unit test: Test bulk reassign tasks
- Test: Verify all tasks are reassigned

---

### Task 8: Create Bulk Unassign Tasks Use Case

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Create use case to unassign multiple tasks at once.

**Files to Create**:
- `lib/features/tasks/domain/usecases/bulk_unassign_tasks.dart` (new file)

**Implementation Steps**:
1. Create `BulkUnassignTasks` use case similar to `BulkAssignTasks`

2. Use `UnassignTask` logic for each task

**Expected Results**:
- ✅ Use case exists
- ✅ Multiple tasks can be unassigned at once

**Test Criteria**:
- Unit test: Test bulk unassign tasks
- Test: Verify all tasks are unassigned

---

### Task 9: Update TaskController with Assignment Methods

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update `TaskController` to include new assignment methods.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/task_controller.dart`

**Implementation Steps**:
1. Inject new use cases:
   ```dart
   class TaskController extends GetxController {
     final AssignTaskToTeam _assignTaskToTeam;
     final AssignTaskToGroup _assignTaskToGroup;
     final ReassignTask _reassignTask;
     final UnassignTask _unassignTask;
     final BulkAssignTasks _bulkAssignTasks;
     
     TaskController(
       // ... existing dependencies ...
       this._assignTaskToTeam,
       this._assignTaskToGroup,
       this._reassignTask,
       this._unassignTask,
       this._bulkAssignTasks,
     );
   }
   ```

2. Add methods:
   ```dart
   Future<void> assignTaskToTeam({
     required String taskId,
     required String teamId,
     required TeamAssignmentOption option,
   }) async {
     // Call use case with permission checks
   }
   
   Future<void> assignTaskToGroup({
     required String taskId,
     required String groupId,
     required TeamAssignmentOption option,
   }) async {
     // Call use case with permission checks
   }
   
   Future<void> reassignTask({
     required String taskId,
     String? newAssigneeId,
     String? newTeamId,
     String? newGroupId,
   }) async {
     // Call use case with permission checks
   }
   
   Future<void> unassignTask(String taskId) async {
     // Call use case with permission checks
   }
   
   Future<void> bulkAssignTasks({
     required List<String> taskIds,
     String? assigneeId,
     String? teamId,
     String? groupId,
   }) async {
     // Call use case with permission checks
   }
   ```

3. Add permission checks to all methods

4. Add error handling

**Expected Results**:
- ✅ Controller has all assignment methods
- ✅ Permission checks are enforced
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test controller methods
- Test: Verify permission checks
- Test: Verify error handling

---

### Task 10: Create Assignment Selector Widget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI widget for selecting assignment type (member/team/group).

**Files to Create**:
- `lib/app/widgets/task_assignment_selector_widget.dart` (new file)

**Implementation Steps**:
1. Create `TaskAssignmentSelectorWidget`:
   ```dart
   class TaskAssignmentSelectorWidget extends StatelessWidget {
     final Function(String? assigneeId, String? teamId, String? groupId) onAssignmentSelected;
     
     @override
     Widget build(BuildContext context) {
       return Column(
         children: [
           _buildAssignmentTypeSelector(),
           _buildMemberSelector(),
           _buildTeamSelector(),
           _buildGroupSelector(),
         ],
       );
     }
   }
   ```

2. Add assignment type selector:
   - Radio buttons or tabs: "Member", "Team", "Group"
   - Show relevant selector based on selection

3. Add member selector:
   - Dropdown or list of workspace members
   - Search field (optional)

4. Add team selector:
   - Dropdown or list of teams
   - Show team lead and member count
   - Cascade options (lead only, all members, team only)

5. Add group selector:
   - Similar to team selector

6. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Assignment selector widget exists
- ✅ All assignment types can be selected
- ✅ Cascade options are available
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test assignment selector
- Manual test: Select different assignment types

---

### Task 11: Update Task Edit UI with Assignment Selector

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add assignment selector to task edit/create form.

**Files to Modify**:
- `lib/app/pages/tasks/task_edit_page.dart`
- `lib/features/tasks/presentation/widgets/create_task_form.dart`

**Implementation Steps**:
1. Replace current assignee dropdown with `TaskAssignmentSelectorWidget`

2. Initialize assignment from task (when editing):
   ```dart
   _selectedAssigneeId = task.assignee;
   _selectedTeamId = task.teamId;
   _selectedGroupId = task.groupId;
   ```

3. Save assignment when task is saved:
   ```dart
   final entity = TaskEntity(
     // ... existing fields ...
     assignee: _selectedAssigneeId,
     teamId: _selectedTeamId,
     groupId: _selectedGroupId,
   );
   ```

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Assignment selector is in task edit form
- ✅ All assignment types can be selected
- ✅ Assignment is saved correctly
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Edit task assignment
- Test: Verify assignment is saved

---

### Task 12: Create Reassign Task UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI for reassigning tasks.

**Files to Create/Modify**:
- `lib/app/widgets/reassign_task_dialog.dart` (new file)
- `lib/app/pages/tasks/task_detail_page.dart` (modify - add reassign button)

**Implementation Steps**:
1. Create `ReassignTaskDialog`:
   ```dart
   class ReassignTaskDialog extends StatelessWidget {
     final TaskEntity task;
     
     @override
     Widget build(BuildContext context) {
       return Dialog(
         child: Column(
           children: [
             _buildCurrentAssignment(),
             _buildNewAssignmentSelector(),
             _buildActions(),
           ],
         ),
       );
     }
   }
   ```

2. Show current assignment:
   - Current assignee/team/group
   - Clear indication of what will change

3. Add new assignment selector:
   - Use `TaskAssignmentSelectorWidget`

4. Add action buttons:
   - "Reassign" button
   - "Cancel" button

5. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Reassign dialog exists
- ✅ Current assignment is shown
- ✅ New assignment can be selected
- ✅ Reassignment works correctly
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Reassign task
- Test: Verify reassignment works

---

### Task 13: Create Unassign Task UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI for unassigning tasks.

**Files to Create/Modify**:
- `lib/app/widgets/unassign_task_dialog.dart` (new file)
- `lib/app/pages/tasks/task_detail_page.dart` (modify - add unassign button)

**Implementation Steps**:
1. Create `UnassignTaskDialog`:
   ```dart
   class UnassignTaskDialog extends StatelessWidget {
     final TaskEntity task;
     
     @override
     Widget build(BuildContext context) {
       return AlertDialog(
         title: Text(AppStrings.unassignTask),
         content: Text('Are you sure you want to unassign this task?'),
         actions: [
           TDButton(
             label: AppStrings.cancel,
             onPressed: () => Navigator.of(context).pop(),
           ),
           TDButton(
             label: AppStrings.unassign,
             type: TDButtonType.danger,
             onPressed: () {
               // Call unassign use case
               Navigator.of(context).pop();
             },
           ),
         ],
       );
     }
   }
   ```

2. Show current assignment in dialog

3. Add confirmation message

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Unassign dialog exists
- ✅ Confirmation is shown
- ✅ Unassignment works correctly
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Unassign task
- Test: Verify unassignment works

---

### Task 14: Create Bulk Selection UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI for bulk selecting tasks.

**Files to Modify**:
- `lib/app/pages/tasks/task_list_page.dart`

**Implementation Steps**:
1. Add bulk selection mode:
   ```dart
   final RxBool _isSelectionMode = false.obs;
   final RxSet<String> _selectedTaskIds = <String>{}.obs;
   ```

2. Add "Select" button to toggle selection mode

3. Add checkboxes to task cards when in selection mode:
   ```dart
   if (_isSelectionMode.value)
     Checkbox(
       value: _selectedTaskIds.contains(task.id),
       onChanged: (value) {
         if (value == true) {
           _selectedTaskIds.add(task.id);
         } else {
           _selectedTaskIds.remove(task.id);
         }
       },
     )
   ```

4. Show selection count:
   - "X tasks selected" indicator

5. Add bulk action buttons:
   - "Bulk Assign" button
   - "Bulk Reassign" button
   - "Bulk Unassign" button

6. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Bulk selection mode exists
- ✅ Multiple tasks can be selected
- ✅ Selection count is shown
- ✅ Bulk action buttons are available
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Select multiple tasks
- Test: Verify selection works

---

### Task 15: Create Bulk Assign Dialog

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI dialog for bulk assigning tasks.

**Files to Create**:
- `lib/app/widgets/bulk_assign_tasks_dialog.dart` (new file)

**Implementation Steps**:
1. Create `BulkAssignTasksDialog`:
   ```dart
   class BulkAssignTasksDialog extends StatelessWidget {
     final List<String> taskIds;
     
     @override
     Widget build(BuildContext context) {
       return Dialog(
         child: Column(
           children: [
             _buildTaskCount(),
             _buildAssignmentSelector(),
             _buildActions(),
           ],
         ),
       );
     }
   }
   ```

2. Show task count:
   - "Assign X tasks to:"

3. Add assignment selector:
   - Use `TaskAssignmentSelectorWidget`

4. Add action buttons:
   - "Assign" button
   - "Cancel" button

5. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Bulk assign dialog exists
- ✅ Task count is shown
- ✅ Assignment can be selected
- ✅ Bulk assignment works correctly
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Bulk assign tasks
- Test: Verify bulk assignment works

---

### Task 16: Add Team Filter to Task List

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add team filter to task list (requires team assignment feature).

**Files to Modify**:
- `lib/app/pages/tasks/task_list_page.dart`
- `lib/features/tasks/presentation/controllers/task_controller.dart`

**Implementation Steps**:
1. Add team filter dropdown to task list UI

2. Update controller to filter by team:
   ```dart
   Future<List<TaskEntity>> getTasks({
     String? teamId, // Add team filter
   }) async {
     // Filter tasks by teamId
   }
   ```

3. Update Firebase query to filter by teamId (if supported)

**Expected Results**:
- ✅ Team filter exists
- ✅ Tasks can be filtered by team
- ✅ Filter works correctly

**Test Criteria**:
- Manual test: Filter tasks by team
- Test: Verify filter works

---

### Task 17: Update Task Visibility Based on Assignment

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Update task visibility logic to include team/group assignments.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/task_controller.dart`
- Task filtering logic

**Implementation Steps**:
1. Update task visibility logic:
   ```dart
   bool isTaskVisibleToUser(TaskEntity task, String userId) {
     // Check direct assignment
     if (task.assignee == userId) return true;
     
     // Check team assignment
     if (task.teamId != null) {
       final team = _teamRepository.getTeam(task.teamId);
       if (team.leadGroupUserId == userId) return true; // Team lead
       if (team.members.contains(userId)) return true; // Team member
     }
     
     // Check group assignment
     if (task.groupId != null) {
       final group = _groupRepository.getGroup(task.groupId);
       if (group.leadGroupUserId == userId) return true; // Group lead
       if (group.members.contains(userId)) return true; // Group member
     }
     
     return false;
   }
   ```

2. Update task list to filter by visibility

**Expected Results**:
- ✅ Task visibility includes team/group assignments
- ✅ Team/group members can see assigned tasks
- ✅ Visibility logic works correctly

**Test Criteria**:
- Test: Verify team members can see team tasks
- Test: Verify group members can see group tasks

---

### Task 18: Add Assignment Display to Task Card

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Update task card to display team/group assignments.

**Files to Modify**:
- `lib/features/tasks/presentation/widgets/task_card.dart`

**Implementation Steps**:
1. Update task card to show assignment:
   ```dart
   if (task.assignee != null)
     Text('Assigned to: ${_getUserName(task.assignee)}')
   else if (task.teamId != null)
     Text('Assigned to team: ${_getTeamName(task.teamId)}')
   else if (task.groupId != null)
     Text('Assigned to group: ${_getGroupName(task.groupId)}')
   else
     Text('Unassigned')
   ```

2. Add assignment badges/chips:
   - Member badge
   - Team badge
   - Group badge

3. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Task card shows assignment type
- ✅ Assignment is displayed correctly
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Verify assignment is displayed
- Test: Verify different assignment types are shown

---

### Task 19: Add Unit Tests for Assignment

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for assignment functionality.

**Files to Create**:
- `test/features/tasks/domain/usecases/assign_task_to_team_test.dart`
- `test/features/tasks/domain/usecases/assign_task_to_group_test.dart`
- `test/features/tasks/domain/usecases/reassign_task_test.dart`
- `test/features/tasks/domain/usecases/unassign_task_test.dart`
- `test/features/tasks/domain/usecases/bulk_assign_tasks_test.dart`
- `test/features/tasks/presentation/controllers/task_controller_test.dart` (update)

**Implementation Steps**:
1. Test team assignment use case
2. Test group assignment use case
3. Test reassign use case
4. Test unassign use case
5. Test bulk assign use case
6. Test controller methods
7. Test permission checks
8. Test cascade behavior

**Expected Results**:
- ✅ Unit tests cover all assignment features
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Add Team/Group Assignment Fields to TaskEntity (Critical - Foundation)
2. **Task 2**: Create Assign Task to Team Use Case (High Priority - Business Logic)
3. **Task 3**: Create Assign Task to Group Use Case (High Priority - Business Logic)
4. **Task 4**: Create Reassign Task Use Case (Medium Priority - Business Logic)
5. **Task 5**: Create Unassign Task Use Case (Medium Priority - Business Logic)
6. **Task 6**: Create Bulk Assign Tasks Use Case (Medium Priority - Business Logic)
7. **Task 9**: Update TaskController with Assignment Methods (High Priority - Controller Layer)
8. **Task 10**: Create Assignment Selector Widget (High Priority - UI)
9. **Task 11**: Update Task Edit UI with Assignment Selector (High Priority - UI)
10. **Task 12**: Create Reassign Task UI (Medium Priority - UI)
11. **Task 13**: Create Unassign Task UI (Medium Priority - UI)
12. **Task 14**: Create Bulk Selection UI (Medium Priority - UI)
13. **Task 15**: Create Bulk Assign Dialog (Medium Priority - UI)
14. **Task 17**: Update Task Visibility Based on Assignment (Medium Priority - Feature Enhancement)
15. **Task 7**: Create Bulk Reassign Tasks Use Case (Low Priority - Enhancement)
16. **Task 8**: Create Bulk Unassign Tasks Use Case (Low Priority - Enhancement)
17. **Task 16**: Add Team Filter to Task List (Low Priority - Enhancement)
18. **Task 18**: Add Assignment Display to Task Card (Low Priority - Enhancement)
19. **Task 19**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ TaskEntity has teamId and groupId fields
- ✅ Tasks can be assigned to teams/groups
- ✅ Tasks can be assigned to members
- ✅ Tasks can be reassigned properly
- ✅ Tasks can be unassigned
- ✅ Multiple tasks can be assigned at once
- ✅ Cascade to team lead/members works
- ✅ Task visibility includes team/group assignments
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ Unit tests have minimum 80% coverage
- ✅ No known bugs or issues

---

## Dependencies

- **TaskEntity**: Needs teamId and groupId fields
- **TeamGroup Entity**: Required for team/group assignment
- **TaskRepository**: Must support team/group assignment queries
- **Firebase Realtime Database**: Required for storing assignments
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications
- **PermissionService**: Required for permission checks

---

## Notes

1. **Team vs Group**: In this codebase, groups are also represented by `TeamGroup` entity. The distinction may be:
   - **Team**: Larger organizational unit
   - **Group**: Smaller working group within a team
   - Or they may be used interchangeably

2. **Cascade Behavior**: When assigning to team/group, options should be:
   - **Lead Only**: Assign to team/group lead (set assignee to lead)
   - **All Members**: Make visible to all team/group members (use visibility logic)
   - **Team/Group Only**: Just set teamId/groupId (members see via visibility)

3. **Assignment Priority**: If task has both assignee and teamId/groupId:
   - Direct assignee takes precedence for individual assignment
   - Team/group assignment provides visibility to all members
   - Can have both (assigned to member within team)

4. **Bulk Operations**: Bulk operations should:
   - Show progress indicator
   - Handle errors gracefully (some tasks may fail)
   - Show success count
   - Log activities for all tasks

5. **Reassign vs Assign**: 
   - **Assign**: First time assignment or changing assignment type
   - **Reassign**: Changing existing assignment (should clear previous)

6. **Unassign**: Should clear all assignment fields (assignee, teamId, groupId) and log activity.

7. **Migration**: When adding teamId/groupId fields, existing tasks will have these fields as null. No migration needed.

---

## Related Documentation

- `TASKS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `TASK_ASSIGNMENT_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/tasks/tasks.md` - Task requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture

