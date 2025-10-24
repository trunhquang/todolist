# 🚀 Sprint 5: Task Management with Workspace Context - Implementation Guide

## 📋 Sprint Overview
**Duration**: Week 7 (1 week)  
**Story Points**: 22 points  
**Team Capacity**: 2 developers × 5 days × 8 hours = 80 hours  
**Goal**: Implement task creation and management within workspace context

## 🎯 Sprint 5 Flow Description

### 1. Task Creation Flow with Workspace Context
```
User Action → Workspace Validation → Task Creation → Permission Check → Firebase Sync → UI Update
```

**Detailed Flow:**
1. **User Initiates Task Creation**
   - User clicks "Create Task" button
   - System validates current workspace context
   - System checks user permissions for task creation

2. **Task Form Display**
   - System displays task creation form
   - Pre-fills workspace context (current workspace ID)
   - Shows available assignees based on workspace membership
   - Displays project options for current workspace

3. **Task Data Validation**
   - Validate task title (required, min 3 characters)
   - Validate task description (optional, max 500 characters)
   - Validate assignee (must be workspace member)
   - Validate project (must belong to current workspace)
   - Validate deadline (must be future date if set)

4. **Permission Verification**
   - Check if user has `create_tasks` permission
   - Check if user can assign to selected assignee
   - Verify project access permissions

5. **Task Creation Process**
   - Create task entity with workspace context
   - Set task status to `pending`
   - Assign task to selected user
   - Link task to project (if selected)
   - Set creation timestamp

6. **Firebase Synchronization**
   - Save task to Firebase under workspace_data/{workspaceId}/tasks
   - Update task counters in workspace
   - Trigger real-time updates for team members

7. **UI State Update**
   - Add task to local task list
   - Update task counters
   - Show success notification
   - Refresh task list view

### 2. Task Assignment Flow
```
Task Selection → Assignee Selection → Permission Check → Assignment Update → Notification
```

**Detailed Flow:**
1. **Task Selection**
   - User selects task from list
   - System shows task details
   - System displays assignment options

2. **Assignee Selection**
   - Show available workspace members
   - Filter by user permissions
   - Display user hierarchy (if applicable)

3. **Permission Verification**
   - Check `assign_tasks` permission
   - Verify assignee is workspace member
   - Check manager-employee relationship (if applicable)

4. **Assignment Update**
   - Update task assignee
   - Set assignment timestamp
   - Update task status if needed

5. **Notification Process**
   - Send notification to assignee
   - Update task list for all team members
   - Log assignment activity

### 3. Workspace Filtering Flow
```
User Login → Workspace Selection → Data Filtering → UI Update → Real-time Sync
```

**Detailed Flow:**
1. **Workspace Context Loading**
   - Load user's current workspace
   - Validate workspace access permissions
   - Set workspace context in local state

2. **Data Filtering**
   - Filter tasks by current workspace
   - Filter projects by current workspace
   - Filter team members by workspace membership
   - Apply user permission filters

3. **UI State Management**
   - Update task list with filtered data
   - Update project list with workspace projects
   - Update team member list
   - Update workspace-specific counters

4. **Real-time Synchronization**
   - Listen to workspace-specific Firebase changes
   - Update UI when data changes
   - Handle offline/online state transitions

## 🏗️ Technical Implementation Requirements

### 1. Task Entity with Workspace Context
```dart
class TaskEntity {
  final String id;
  final String title;
  final String description;
  final String workspaceId; // MANDATORY: Workspace context
  final String assigneeId;
  final String assignerId;
  final TaskStatus status;
  final TaskPriority priority;
  final TaskType taskType;
  final String? projectId;
  final DateTime? deadline;
  final bool hasDeadline;
  final RecurringConfig? recurring;
  final String? parentTaskId;
  final bool stoppedByProjectClose;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Workspace-specific validation
  bool isValidForWorkspace(String workspaceId) {
    return this.workspaceId == workspaceId;
  }
}
```

### 2. Workspace Context Service
```dart
class WorkspaceContextService {
  final _currentWorkspaceId = ''.obs;
  final _workspaceMembers = <User>[].obs;
  final _workspaceProjects = <Project>[].obs;

  String get currentWorkspaceId => _currentWorkspaceId.value;
  List<User> get workspaceMembers => _workspaceMembers;
  List<Project> get workspaceProjects => _workspaceProjects;

  Future<void> setCurrentWorkspace(String workspaceId) async {
    _currentWorkspaceId.value = workspaceId;
    await _loadWorkspaceData();
  }

  Future<void> _loadWorkspaceData() async {
    // Load workspace members
    // Load workspace projects
    // Validate user permissions
  }
}
```

### 3. Task Controller with Workspace Context
```dart
class TaskController extends GetxController {
  final CreateTask _createTask;
  final GetTasks _getTasks;
  final UpdateTask _updateTask;
  final WorkspaceContextService _workspaceContext;

  final _tasks = <Task>[].obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;

  List<Task> get tasks => _tasks.where((task) => 
    task.workspaceId == _workspaceContext.currentWorkspaceId
  ).toList();

  Future<void> createTask(CreateTaskRequest request) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Validate workspace context
      if (request.workspaceId != _workspaceContext.currentWorkspaceId) {
        throw WorkspaceMismatchException();
      }

      // Check permissions
      await _checkCreateTaskPermission();

      final result = await _createTask.call(CreateTaskParams(
        task: request.toTaskEntity(),
        workspaceId: _workspaceContext.currentWorkspaceId,
      ));

      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (success) {
          _tasks.add(success);
          SnackbarService().showSuccess(
            title: AppStrings.success,
            message: AppStrings.taskCreated,
          );
        },
      );
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }
}
```

## 📱 UI Implementation Requirements

### 1. Task Creation Form
```dart
class CreateTaskForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (controller) => TDCard(
        child: Column(
          children: [
            TDTextField(
              label: AppStrings.taskTitle,
              controller: _titleController,
              validator: _validateTitle,
            ),
            TDTextField(
              label: AppStrings.taskDescription,
              controller: _descriptionController,
              maxLines: 3,
            ),
            TDDropdown<User>(
              label: AppStrings.assignee,
              items: controller.workspaceMembers,
              onChanged: _onAssigneeChanged,
            ),
            TDDropdown<Project>(
              label: AppStrings.project,
              items: controller.workspaceProjects,
              onChanged: _onProjectChanged,
            ),
            TDDatePicker(
              label: AppStrings.deadline,
              onDateSelected: _onDeadlineSelected,
            ),
            TDPrioritySelector(
              onPriorityChanged: _onPriorityChanged,
            ),
            TDTaskTypeSelector(
              onTypeChanged: _onTypeChanged,
            ),
            TDButton(
              text: AppStrings.createTask,
              onPressed: _onCreateTask,
              isLoading: controller.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
```

### 2. Task List with Workspace Filtering
```dart
class TaskListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (controller) => Scaffold(
        appBar: TDAppBar(
          title: AppStrings.tasks,
          actions: [
            TDButton(
              text: AppStrings.createTask,
              onPressed: () => NavigationService().toNamed<void>(AppRoutes.createTask),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading) {
            return TDLoadingIndicator();
          }

          if (controller.tasks.isEmpty) {
            return TDEmptyState(
              message: AppStrings.noTasksFound,
              actionText: AppStrings.createFirstTask,
              onAction: () => NavigationService().toNamed<void>(AppRoutes.createTask),
            );
          }

          return ListView.builder(
            itemCount: controller.tasks.length,
            itemBuilder: (context, index) => TaskCard(
              task: controller.tasks[index],
              onTap: () => _onTaskTap(controller.tasks[index]),
              onStatusChange: (status) => _onStatusChange(controller.tasks[index], status),
            ),
          );
        }),
      ),
    );
  }
}
```

## 🔐 Permission Implementation

### 1. Permission Checking Service
```dart
class PermissionService {
  Future<bool> canCreateTask(String userId, String workspaceId) async {
    final permissions = await _getUserPermissions(userId, workspaceId);
    return permissions.contains(WorkspacePermissions.createTasks);
  }

  Future<bool> canAssignTask(String userId, String workspaceId, String assigneeId) async {
    final permissions = await _getUserPermissions(userId, workspaceId);
    if (!permissions.contains(WorkspacePermissions.assignTasks)) {
      return false;
    }

    // Check if assignee is in same workspace
    final assignee = await _getUser(assigneeId);
    return assignee.workspaceId == workspaceId;
  }

  Future<List<String>> _getUserPermissions(String userId, String workspaceId) async {
    // Implementation to get user permissions from Firebase
  }
}
```

### 2. Task Assignment with Permission Check
```dart
class TaskAssignmentService {
  Future<void> assignTask(String taskId, String assigneeId) async {
    // Check permissions
    final canAssign = await PermissionService().canAssignTask(
      Get.find<AuthController>().currentUser.id,
      Get.find<WorkspaceContextService>().currentWorkspaceId,
      assigneeId,
    );

    if (!canAssign) {
      throw InsufficientPermissionException();
    }

    // Update task assignment
    await _updateTaskAssignment(taskId, assigneeId);
  }
}
```

## 🧪 Testing Requirements

### 1. Unit Tests (90% coverage required)
```dart
// Task Controller Tests
group('TaskController', () {
  test('should create task with workspace context', () async {
    // Arrange
    final request = CreateTaskRequest(
      title: 'Test Task',
      workspaceId: 'workspace-1',
      assigneeId: 'user-1',
    );

    // Act
    await controller.createTask(request);

    // Assert
    expect(controller.tasks.length, 1);
    expect(controller.tasks.first.workspaceId, 'workspace-1');
  });

  test('should throw exception when workspace mismatch', () async {
    // Arrange
    final request = CreateTaskRequest(
      title: 'Test Task',
      workspaceId: 'different-workspace',
      assigneeId: 'user-1',
    );

    // Act & Assert
    expect(
      () => controller.createTask(request),
      throwsA(isA<WorkspaceMismatchException>()),
    );
  });
});
```

### 2. Widget Tests (80% coverage required)
```dart
// Task List Widget Tests
testWidgets('should display tasks for current workspace', (tester) async {
  // Arrange
  final mockController = MockTaskController();
  when(mockController.tasks).thenReturn([
    TaskEntity(id: '1', title: 'Task 1', workspaceId: 'workspace-1'),
    TaskEntity(id: '2', title: 'Task 2', workspaceId: 'workspace-1'),
  ]);

  // Act
  await tester.pumpWidget(
    GetMaterialApp(
      home: TaskListPage(),
    ),
  );

  // Assert
  expect(find.text('Task 1'), findsOneWidget);
  expect(find.text('Task 2'), findsOneWidget);
});
```

### 3. Integration Tests (70% coverage required)
```dart
// Task Management Integration Tests
group('Task Management Integration', () {
  testWidgets('should complete full task creation flow', (tester) async {
    // Arrange
    await tester.pumpWidget(MyApp());

    // Act
    await tester.tap(find.byKey(Key('create_task_button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key('task_title_field')), 'Test Task');
    await tester.tap(find.byKey(Key('create_button')));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Test Task'), findsOneWidget);
    expect(find.text(AppStrings.taskCreated), findsOneWidget);
  });
});
```

## 📊 Success Metrics

### Technical Metrics
- Task creation success rate > 95%
- Task assignment accuracy 100%
- Workspace filtering accuracy 100%
- Task status update response time < 500ms
- Permission check response time < 200ms

### User Experience Metrics
- Task creation completion rate > 90%
- Task assignment success rate > 95%
- User satisfaction score > 4.5/5
- Workspace context awareness > 95%

## 🚨 Risk Mitigation

### Technical Risks
- **Data Complexity**: Implement proper workspace filtering
- **Permission Complexity**: Implement comprehensive permission checks
- **UI Complexity**: Use consistent task management patterns
- **Performance**: Optimize queries with workspace context

### Mitigation Strategies
- Implement data pagination per workspace
- Add retry mechanisms for workspace operations
- Optimize database queries with workspace filtering
- Implement conflict resolution for multi-workspace
- Use proper error handling and user feedback

## 📚 Documentation Requirements

### Technical Documentation
- [ ] API documentation for task management endpoints
- [ ] User guide for task creation and management
- [ ] Technical documentation for workspace filtering
- [ ] Permission system documentation

### Code Documentation
- [ ] Controller documentation with examples
- [ ] Service documentation with usage patterns
- [ ] Widget documentation with props
- [ ] Test documentation with coverage reports

---

**Sprint 5 Implementation Status**: Ready for Development  
**Next Steps**: Begin implementation following the defined flow and technical requirements  
**Dependencies**: Phase 1 completion (Multi-Workspace Authentication & User Management)
