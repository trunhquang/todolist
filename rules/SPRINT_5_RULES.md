# 🚀 Sprint 5: Task Management with Workspace Context - Development Rules

## 📋 MANDATORY SPRINT 5 RULES

### ❌ NEVER DO THESE IN SPRINT 5:
- **NEVER create tasks without workspace context** - ALWAYS include workspaceId in TaskEntity
- **NEVER assign tasks to users outside current workspace** - ALWAYS validate workspace membership
- **NEVER bypass permission checks for task operations** - ALWAYS verify user permissions
- **NEVER hardcode workspace IDs** - ALWAYS use WorkspaceContextService
- **NEVER create tasks without proper validation** - ALWAYS validate all required fields
- **NEVER use hardcoded strings for task status/priority/type** - ALWAYS use enums from task_enums.dart
- **NEVER implement client-side pagination for task lists** - ALWAYS use server-side pagination
- **NEVER create widgets larger than 100 lines** - ALWAYS break down complex widgets
- **NEVER create files larger than 400 lines** - ALWAYS split large files
- **NEVER write code without comprehensive tests** - Minimum 80% test coverage required

### ✅ ALWAYS DO THESE IN SPRINT 5:
- **ALWAYS include workspace context in all task operations**
- **ALWAYS validate workspace membership before task assignment**
- **ALWAYS check user permissions before task operations**
- **ALWAYS use WorkspaceContextService for workspace management**
- **ALWAYS validate task data before creation/update**
- **ALWAYS use enums from task_enums.dart for status/priority/type**
- **ALWAYS use server-side pagination for task lists**
- **ALWAYS use GetX controllers with StatelessWidget for state management**
- **ALWAYS use TD prefix for all custom widgets**
- **ALWAYS use AppStrings for all user-facing text**
- **ALWAYS use SnackbarService for all notifications**
- **ALWAYS use NavigationService for all navigation**
- **ALWAYS write comprehensive tests with minimum 80% coverage**
- **ALWAYS follow Clean Architecture patterns**
- **ALWAYS use proper error handling and user feedback**

## 🏗️ SPRINT 5 ARCHITECTURE RULES

### 1. Task Entity with Workspace Context (MANDATORY)
```dart
// ✅ CORRECT: TaskEntity with workspace context
class TaskEntity {
  final String id;
  final String title;
  final String description;
  final String workspaceId; // MANDATORY: Workspace context
  final String assigneeId;
  final String assignerId;
  final TaskStatus status; // Use enum from task_enums.dart
  final TaskPriority priority; // Use enum from task_enums.dart
  final TaskType taskType; // Use enum from task_enums.dart
  final String? projectId;
  final DateTime? deadline;
  final bool hasDeadline;
  final RecurringConfig? recurring;
  final String? parentTaskId;
  final bool stoppedByProjectClose;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Workspace validation
  bool isValidForWorkspace(String workspaceId) {
    return this.workspaceId == workspaceId;
  }
}

// ❌ WRONG: TaskEntity without workspace context
class TaskEntity {
  final String id;
  final String title;
  // Missing workspaceId - MANDATORY for Sprint 5
}
```

### 2. Workspace Context Service (MANDATORY)
```dart
// ✅ CORRECT: WorkspaceContextService implementation
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

// ❌ WRONG: Missing workspace context management
class TaskController extends GetxController {
  // Missing workspace context integration
}
```

### 3. Task Controller with Workspace Context (MANDATORY)
```dart
// ✅ CORRECT: TaskController with workspace context
class TaskController extends GetxController {
  final CreateTask _createTask;
  final GetTasks _getTasks;
  final UpdateTask _updateTask;
  final WorkspaceContextService _workspaceContext;

  final _tasks = <Task>[].obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;

  // Filter tasks by current workspace
  List<Task> get tasks => _tasks.where((task) => 
    task.workspaceId == _workspaceContext.currentWorkspaceId
  ).toList();

  Future<void> createTask(CreateTaskRequest request) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // MANDATORY: Validate workspace context
      if (request.workspaceId != _workspaceContext.currentWorkspaceId) {
        throw WorkspaceMismatchException();
      }

      // MANDATORY: Check permissions
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
            title: AppStrings.I.success,
            message: AppStrings.I.taskCreated,
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

// ❌ WRONG: TaskController without workspace context
class TaskController extends GetxController {
  final _tasks = <Task>[].obs;
  
  // Missing workspace context validation
  // Missing permission checks
  // Missing proper error handling
}
```

## 🔐 PERMISSION RULES FOR SPRINT 5

### 1. Permission Checking (MANDATORY)
```dart
// ✅ CORRECT: Permission checking for task operations
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

  Future<bool> canUpdateTaskStatus(String userId, String workspaceId, String taskId) async {
    final permissions = await _getUserPermissions(userId, workspaceId);
    return permissions.contains(WorkspacePermissions.updateTaskStatus);
  }
}

// ❌ WRONG: Missing permission checks
class TaskController extends GetxController {
  Future<void> createTask(Task task) async {
    // Missing permission check
    await _createTask.call(task);
  }
}
```

### 2. Task Assignment with Permission Check (MANDATORY)
```dart
// ✅ CORRECT: Task assignment with permission validation
class TaskAssignmentService {
  Future<void> assignTask(String taskId, String assigneeId) async {
    final currentUserId = Get.find<AuthController>().currentUser.id;
    final currentWorkspaceId = Get.find<WorkspaceContextService>().currentWorkspaceId;

    // MANDATORY: Check permissions
    final canAssign = await PermissionService().canAssignTask(
      currentUserId,
      currentWorkspaceId,
      assigneeId,
    );

    if (!canAssign) {
      throw InsufficientPermissionException();
    }

    // MANDATORY: Validate assignee is in same workspace
    final assignee = await _getUser(assigneeId);
    if (assignee.workspaceId != currentWorkspaceId) {
      throw WorkspaceMismatchException();
    }

    // Update task assignment
    await _updateTaskAssignment(taskId, assigneeId);
  }
}

// ❌ WRONG: Task assignment without permission check
class TaskAssignmentService {
  Future<void> assignTask(String taskId, String assigneeId) async {
    // Missing permission check
    // Missing workspace validation
    await _updateTaskAssignment(taskId, assigneeId);
  }
}
```

## 📱 UI/UX RULES FOR SPRINT 5

### 1. Task Creation Form (MANDATORY)
```dart
// ✅ CORRECT: Task creation form with workspace context
class CreateTaskForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (controller) => TDCard(
        child: Column(
          children: [
            TDTextField(
              label: AppStrings.I.taskTitle,
              controller: _titleController,
              validator: _validateTitle,
            ),
            TDTextField(
              label: AppStrings.I.taskDescription,
              controller: _descriptionController,
              maxLines: 3,
            ),
            TDDropdown<User>(
              label: AppStrings.I.assignee,
              items: controller.workspaceMembers, // MANDATORY: Use workspace members
              onChanged: _onAssigneeChanged,
            ),
            TDDropdown<Project>(
              label: AppStrings.I.project,
              items: controller.workspaceProjects, // MANDATORY: Use workspace projects
              onChanged: _onProjectChanged,
            ),
            TDDatePicker(
              label: AppStrings.I.deadline,
              onDateSelected: _onDeadlineSelected,
            ),
            TDPrioritySelector(
              onPriorityChanged: _onPriorityChanged,
            ),
            TDTaskTypeSelector(
              onTypeChanged: _onTypeChanged,
            ),
            TDButton(
              text: AppStrings.I.createTask,
              onPressed: _onCreateTask,
              isLoading: controller.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

// ❌ WRONG: Task creation form without workspace context
class CreateTaskForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Task Title'),
          ),
          // Missing workspace context
          // Missing proper validation
          // Missing TD prefix widgets
        ],
      ),
    );
  }
}
```

### 2. Task List with Workspace Filtering (MANDATORY)
```dart
// ✅ CORRECT: Task list with workspace filtering
class TaskListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (controller) => Scaffold(
        appBar: TDAppBar(
          title: AppStrings.I.tasks,
          actions: [
            TDButton(
              text: AppStrings.I.createTask,
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
              message: AppStrings.I.noTasksFound,
              actionText: AppStrings.I.createFirstTask,
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

// ❌ WRONG: Task list without workspace filtering
class TaskListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) => TaskCard(
          task: controller.tasks[index], // Missing workspace filtering
        ),
      ),
    );
  }
}
```

## 🧪 TESTING RULES FOR SPRINT 5

### 1. Unit Tests (90% coverage required)
```dart
// ✅ CORRECT: Comprehensive unit tests
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

  test('should filter tasks by current workspace', () async {
    // Arrange
    controller._tasks.addAll([
      TaskEntity(id: '1', workspaceId: 'workspace-1'),
      TaskEntity(id: '2', workspaceId: 'workspace-2'),
    ]);
    controller._workspaceContext.currentWorkspaceId = 'workspace-1';

    // Act
    final filteredTasks = controller.tasks;

    // Assert
    expect(filteredTasks.length, 1);
    expect(filteredTasks.first.id, '1');
  });
});

// ❌ WRONG: Missing comprehensive tests
group('TaskController', () {
  test('should create task', () async {
    // Missing workspace context validation
    // Missing permission checks
    // Missing error handling tests
  });
});
```

### 2. Widget Tests (80% coverage required)
```dart
// ✅ CORRECT: Widget tests with workspace context
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

// ❌ WRONG: Missing widget tests
// No widget tests for Sprint 5 features
```

### 3. Integration Tests (70% coverage required)
```dart
// ✅ CORRECT: Integration tests for task management
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

// ❌ WRONG: Missing integration tests
// No integration tests for Sprint 5 features
```

## 📊 PERFORMANCE RULES FOR SPRINT 5

### 1. Server-side Pagination (MANDATORY)
```dart
// ✅ CORRECT: Server-side pagination for task lists
class TaskController extends GetxController {
  Future<void> loadTasks({int page = 1, int pageSize = 20}) async {
    final result = await _getTasks.call(GetTasksParams(
      workspaceId: _workspaceContext.currentWorkspaceId,
      page: page,
      pageSize: pageSize,
    ));

    result.fold(
      (failure) => _errorMessage.value = failure.message,
      (success) => _tasks.addAll(success),
    );
  }
}

// ❌ WRONG: Client-side pagination
class TaskController extends GetxController {
  Future<void> loadTasks() async {
    final allTasks = await _getAllTasks();
    _tasks.value = allTasks.sublist(startIndex, endIndex); // Wrong approach
  }
}
```

### 2. Workspace Filtering Optimization (MANDATORY)
```dart
// ✅ CORRECT: Optimized workspace filtering
class TaskController extends GetxController {
  List<Task> get tasks => _tasks.where((task) => 
    task.workspaceId == _workspaceContext.currentWorkspaceId
  ).toList();

  Future<void> _loadWorkspaceTasks() async {
    final result = await _getTasks.call(GetTasksParams(
      workspaceId: _workspaceContext.currentWorkspaceId,
      page: 1,
      pageSize: 20,
    ));

    result.fold(
      (failure) => _errorMessage.value = failure.message,
      (success) => _tasks.value = success,
    );
  }
}

// ❌ WRONG: Inefficient workspace filtering
class TaskController extends GetxController {
  List<Task> get tasks => _allTasks.where((task) => 
    task.workspaceId == _workspaceContext.currentWorkspaceId
  ).toList(); // Loading all tasks then filtering
}
```

## 🚨 ERROR HANDLING RULES FOR SPRINT 5

### 1. Workspace Context Validation (MANDATORY)
```dart
// ✅ CORRECT: Workspace context validation
class TaskController extends GetxController {
  Future<void> createTask(CreateTaskRequest request) async {
    try {
      // MANDATORY: Validate workspace context
      if (request.workspaceId != _workspaceContext.currentWorkspaceId) {
        throw WorkspaceMismatchException();
      }

      // MANDATORY: Check permissions
      final canCreate = await PermissionService().canCreateTask(
        Get.find<AuthController>().currentUser.id,
        _workspaceContext.currentWorkspaceId,
      );

      if (!canCreate) {
        throw InsufficientPermissionException();
      }

      // Create task
      final result = await _createTask.call(CreateTaskParams(
        task: request.toTaskEntity(),
        workspaceId: _workspaceContext.currentWorkspaceId,
      ));

      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (success) {
          _tasks.add(success);
          SnackbarService().showSuccess(
            title: AppStrings.I.success,
            message: AppStrings.I.taskCreated,
          );
        },
      );
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: ${e.toString()}';
      SnackbarService().showError(
        title: AppStrings.I.error,
        message: e.toString(),
      );
    } finally {
      _isLoading.value = false;
    }
  }
}

// ❌ WRONG: Missing workspace context validation
class TaskController extends GetxController {
  Future<void> createTask(CreateTaskRequest request) async {
    // Missing workspace context validation
    // Missing permission checks
    // Missing proper error handling
    await _createTask.call(request);
  }
}
```

## 📚 DOCUMENTATION RULES FOR SPRINT 5

### 1. Code Documentation (MANDATORY)
```dart
// ✅ CORRECT: Proper code documentation
/// TaskController manages task operations within workspace context
/// 
/// This controller handles:
/// - Task creation with workspace validation
/// - Task assignment with permission checks
/// - Task filtering by current workspace
/// - Real-time task updates
class TaskController extends GetxController {
  /// Creates a new task in the current workspace
  /// 
  /// [request] The task creation request with workspace context
  /// 
  /// Throws [WorkspaceMismatchException] if workspace doesn't match
  /// Throws [InsufficientPermissionException] if user lacks permissions
  Future<void> createTask(CreateTaskRequest request) async {
    // Implementation
  }
}

// ❌ WRONG: Missing code documentation
class TaskController extends GetxController {
  Future<void> createTask(CreateTaskRequest request) async {
    // Missing documentation
  }
}
```

### 2. API Documentation (MANDATORY)
```dart
// ✅ CORRECT: API documentation
/// Task Management API Endpoints
/// 
/// ## Create Task
/// POST /api/tasks
/// 
/// Request Body:
/// ```json
/// {
///   "title": "Task Title",
///   "description": "Task Description",
///   "workspaceId": "workspace-id",
///   "assigneeId": "user-id",
///   "projectId": "project-id",
///   "priority": "high",
///   "taskType": "daily"
/// }
/// ```
/// 
/// Response:
/// ```json
/// {
///   "success": true,
///   "data": {
///     "id": "task-id",
///     "title": "Task Title",
///     "workspaceId": "workspace-id",
///     "status": "pending",
///     "createdAt": "2025-01-01T00:00:00Z"
///   }
/// }
/// ```
```

## 🎯 SPRINT 5 SUCCESS CRITERIA

### Technical Requirements
- [ ] Task creation with workspace context (100%)
- [ ] Task assignment with permission checks (100%)
- [ ] Workspace filtering for task lists (100%)
- [ ] Task status updates with validation (100%)
- [ ] Permission enforcement for all operations (100%)
- [ ] Server-side pagination implementation (100%)
- [ ] Comprehensive test coverage (80%+)
- [ ] Error handling for all scenarios (100%)

### User Experience Requirements
- [ ] Intuitive task creation form
- [ ] Clear workspace context indication
- [ ] Smooth task assignment process
- [ ] Responsive task list interface
- [ ] Proper loading states and feedback
- [ ] Error messages in user-friendly language

### Performance Requirements
- [ ] Task creation response time < 500ms
- [ ] Task list loading time < 1s
- [ ] Workspace switching time < 1s
- [ ] Permission check response time < 200ms
- [ ] Memory usage optimization
- [ ] Network efficiency

---

**Remember**: These Sprint 5 rules ensure consistent, maintainable, and reliable task management with workspace context. Always follow these guidelines when implementing Sprint 5 features.
