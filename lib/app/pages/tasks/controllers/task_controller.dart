import 'package:get/get.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/constants/task_enums.dart';

// import 'package:todolist/core/services/navigation_service.dart'; // Removed unused import
import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/core/services/firebase_database_service.dart';
import 'package:todolist/core/services/offline_queue_service.dart';
import 'package:todolist/core/services/permission_service.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/core/services/workspace_context_service.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';

import '../../../../core/services/storage_service.dart';

/// TaskController manages task operations with workspace context for Sprint 5
///
/// This controller handles:
/// - Task creation with workspace validation
/// - Task assignment with permission checks
/// - Task filtering by current workspace
/// - Real-time task updates
class TaskController extends GetxController {
  // Constructor
  TaskController({
    required WorkspaceContextService workspaceContext,
    required PermissionService permissionService,
    AuthController? authController, // Optional for testing
  })  : _workspaceContext = workspaceContext,
        _permissionService = permissionService,
        _authController = authController;

  // Dependencies
  final WorkspaceContextService _workspaceContext;
  final PermissionService _permissionService;
  final AuthController? _authController;

  // Private observables
  final RxList<TaskEntity> _tasks = <TaskEntity>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Public getters
  List<TaskEntity> get tasks => _tasks
      .where((task) => task.workspaceId == _workspaceContext.currentWorkspaceId)
      .toList();

  List<TaskEntity> getTasksByProject(String projectId) =>
      tasks.where((task) => task.projectId == projectId).toList();

  bool get isLoading {
    return _isLoading.value;
  }

  String get errorMessage => _errorMessage.value;

  List<User> get workspaceMembers => _workspaceContext.workspaceMembers;

  List<Project> get workspaceProjects => _workspaceContext.workspaceProjects;

  Project? getProject(String projectId) =>
      _workspaceContext.getWorkspaceProject(projectId);

  @override
  void onInit() {
    super.onInit();
    _loadTasks();
  }

  /// Load tasks for current workspace
  Future<void> _loadTasks() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      if (!_workspaceContext.hasValidWorkspace) {
        _tasks.value = [];
        _isLoading.value = false;
        return;
      }

      final workspaceId = _workspaceContext.currentWorkspaceId;

      // Load all tasks for current workspace (no pagination for now)
      final items = await FirebaseDatabaseService.instance.listTasks(
        workspaceId: workspaceId,
      );

      _tasks
        ..clear()
        ..addAll(items);
      _isLoading.value = false;
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: $e';
      _isLoading.value = false;
    }
  }

  Stream<List<TaskEntity>> watchTasks(
      {String? type,
      String? status,
      String? priority,
      String? projectId,
      String? assignee}) {
    final storage = StorageService();
    final workspaceId = storage.getWorkspaceId() ?? '';
    if (workspaceId.isEmpty) return const Stream<List<TaskEntity>>.empty();
    return FirebaseDatabaseService.instance.watchTasks(
      workspaceId: workspaceId,
      type: type,
      status: status,
      priority: priority,
      projectId: projectId,
    );
  }

  Future<List<Project>> loadProjects() async {
    final storage = StorageService();
    final workspaceId = storage.getWorkspaceId() ?? '';
    if (workspaceId.isEmpty) return <Project>[];
    return FirebaseDatabaseService.instance
        .listProjects(workspaceId: workspaceId);
  }

  /// Create new task with workspace context
  ///
  /// [title] Task title
  /// [description] Task description (optional)
  /// [assigneeId] Assignee user ID (optional)
  /// [projectId] Project ID (optional)
  /// [priority] Task priority
  /// [taskType] Task type
  /// [deadline] Task deadline (optional)
  Future<void> createTask({
    required String title,
    String? description,
    String? assigneeId,
    String? projectId,
    TaskPriority priority = TaskPriority.medium,
    TaskType taskType = TaskType.daily,
    TaskStatus status = TaskStatus.pending,
    DateTime? deadline,
  }) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Basic validation
      final trimmedTitle = title.trim();
      if (trimmedTitle.isEmpty || trimmedTitle.length < 3) {
        throw ValidationFailure(message: 'Title must be at least 3 characters');
      }

      if (deadline != null) {
        final now = DateTime.now();
        final startOfToday = DateTime(now.year, now.month, now.day);
        if (deadline.isBefore(startOfToday)) {
          throw ValidationFailure(
              message: 'Deadline must be today or later for task creation');
        }
      }

      // Validate workspace context
      if (!_workspaceContext.hasValidWorkspace) {
        throw WorkspaceMismatchException('No valid workspace selected');
      }

      // Check create task permission
      final authController = _authController ??
          (Get.isRegistered<AuthController>()
              ? Get.find<AuthController>()
              : null);
      if (authController == null) {
        SnackbarService().showError(
            title: AppStrings.error, message: 'Auth controller not found');
        return;
      }
      try {
        final currentUser = authController.currentUser;
        if (currentUser == null) {
          SnackbarService().showError(
              title: AppStrings.error, message: 'User not logged in');
          return;
        }
        final currentUserId = currentUser.id;
        final canCreate = await _permissionService.canCreateTask(
          currentUserId,
          _workspaceContext.currentWorkspaceId,
        );

        if (!canCreate) {
          throw InsufficientPermissionException(
              'Cannot create tasks in this workspace');
        }

        // If assigning task while creating, ensure assign permission + membership
        if (assigneeId != null) {
          final canAssignTask = await _permissionService.canAssignTask(
            currentUserId,
            _workspaceContext.currentWorkspaceId,
            assigneeId,
          );
          if (!canAssignTask) {
            throw InsufficientPermissionException(
                'Cannot assign task to selected user');
          }
        }

        // Validate assignee if provided
        if (assigneeId != null &&
            !_workspaceContext.isWorkspaceMember(assigneeId)) {
          throw WorkspaceMismatchException(
              'Assignee is not a member of current workspace');
        }

        // Validate project if provided
        if (projectId != null &&
            !_workspaceContext.isWorkspaceProject(projectId)) {
          throw WorkspaceMismatchException(
              'Project does not belong to current workspace');
        }

        // If task has project, ensure assignee (if any) is project member
        if (projectId != null && assigneeId != null) {
          final project = getProject(projectId);
          if (project == null) {
            throw WorkspaceMismatchException('Project not found in workspace');
          }
          if (!project.memberIds.contains(assigneeId)) {
            throw WorkspaceMismatchException(
                'Assignee is not a member of the project');
          }
        }

        // Create task entity
        final now = DateTime.now();
        final localTask = TaskEntity(
          id: _generateTaskId(),
          // local placeholder; will be replaced by Firebase ID when online
          title: title,
          description:
              description?.trim().isEmpty == true ? null : description?.trim(),
          workspaceId: _workspaceContext.currentWorkspaceId,
          taskType: taskType.value,
          priority: priority.value,
          status: status.value,
          assignee: assigneeId,
          assigner: currentUserId,
          projectId: projectId,
          hasDeadline: deadline != null,
          deadline: deadline,
          recurring: const RecurringConfig(isRecurring: false),
          createdAt: now,
        );

        // Persist task (online -> Firebase, offline -> queue)
        try {
          final firebaseId = await FirebaseDatabaseService.instance.createTask(
            workspaceId: _workspaceContext.currentWorkspaceId,
            task: localTask,
          );
          final savedTask = localTask.copyWith(id: firebaseId);
          _tasks.add(savedTask);
        } on DatabaseFailure {
          // Fallback: enqueue for offline sync and keep local copy with generated ID
          await OfflineQueueService.instance.createTask(
            workspaceId: _workspaceContext.currentWorkspaceId,
            task: localTask,
          );
          _tasks.add(localTask);
        }
      } catch (e) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: 'Failed to get user info: $e',
        );
        return;
      }
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: $e';
      SnackbarService().showError(
        title: AppStrings.error,
        message: e.toString(),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Assign task to user with permission check
  ///
  /// [taskId] Task ID to assign
  /// [assigneeId] User ID to assign task to
  Future<void> assignTask(String taskId, String assigneeId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Find task
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) {
        throw TaskNotFoundException('Task not found');
      }

      final task = _tasks[taskIndex];

      // Validate workspace context
      if (task.workspaceId != _workspaceContext.currentWorkspaceId) {
        throw WorkspaceMismatchException(
            'Task does not belong to current workspace');
      }

      // Check assign permission
      final authController = _authController ??
          (Get.isRegistered<AuthController>()
              ? Get.find<AuthController>()
              : null);
      if (authController == null) {
        SnackbarService().showError(
            title: AppStrings.error, message: 'Auth controller not found');
        return;
      }
      try {
        final currentUser = authController.currentUser;
        if (currentUser == null) {
          SnackbarService().showError(
              title: AppStrings.error, message: 'User not logged in');
          return;
        }
        final currentUserId = currentUser.id;
        final canAssign = await _permissionService.canAssignTask(
          currentUserId,
          _workspaceContext.currentWorkspaceId,
          assigneeId,
        );

        if (!canAssign) {
          throw InsufficientPermissionException(
              'Cannot assign tasks in this workspace');
        }

        // Validate assignee is workspace member
        if (!_workspaceContext.isWorkspaceMember(assigneeId)) {
          throw WorkspaceMismatchException(
              'Assignee is not a member of current workspace');
        }

        // Update task assignment
        final updatedTask = task.copyWith(
          assignee: assigneeId,
          updatedAt: DateTime.now(),
        );

        _tasks[taskIndex] = updatedTask;

        // Update task in Firebase (with offline fallback)
        try {
          await FirebaseDatabaseService.instance
              .updateTaskFromEntity(updatedTask);
        } on DatabaseFailure {
          await OfflineQueueService.instance.updateTask(
            workspaceId: _workspaceContext.currentWorkspaceId,
            task: updatedTask,
          );
        }

        // Show success message
        SnackbarService().showSuccess(
          title: AppStrings.success,
          message: 'Task assigned successfully',
        );
      } catch (e) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: 'Failed to get user info: $e',
        );
        return;
      }
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: $e';
      SnackbarService().showError(
        title: AppStrings.error,
        message: e.toString(),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Update task status with permission check
  ///
  /// [taskId] Task ID to update
  /// [status] New task status
  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Find task
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) {
        throw TaskNotFoundException('Task not found');
      }

      final task = _tasks[taskIndex];

      // Validate workspace context
      if (task.workspaceId != _workspaceContext.currentWorkspaceId) {
        throw WorkspaceMismatchException(
            'Task does not belong to current workspace');
      }

      // Check update permission
      final authController = _authController ??
          (Get.isRegistered<AuthController>()
              ? Get.find<AuthController>()
              : null);
      if (authController == null) {
        SnackbarService().showError(
            title: AppStrings.error, message: 'Auth controller not found');
        return;
      }
      try {
        final currentUser = authController.currentUser;
        if (currentUser == null) {
          SnackbarService().showError(
              title: AppStrings.error, message: 'User not logged in');
          return;
        }
        final currentUserId = currentUser.id;
        final canUpdate = await _permissionService.canUpdateTaskStatus(
          currentUserId,
          _workspaceContext.currentWorkspaceId,
        );

        if (!canUpdate) {
          throw InsufficientPermissionException(
              'Cannot update task status in this workspace');
        }

        // Update task status
        final updatedTask = task.copyWith(
          status: status.value,
          updatedAt: DateTime.now(),
        );

        _tasks[taskIndex] = updatedTask;

        // Update task in Firebase (with offline fallback)
        try {
          await FirebaseDatabaseService.instance
              .updateTaskFromEntity(updatedTask);
        } on DatabaseFailure {
          await OfflineQueueService.instance.updateTask(
            workspaceId: _workspaceContext.currentWorkspaceId,
            task: updatedTask,
          );
        }

        // Show success message
        SnackbarService().showSuccess(
          title: AppStrings.success,
          message: 'Task status updated successfully',
        );
      } catch (e) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: 'Failed to get user info: $e',
        );
        return;
      }
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: $e';
      SnackbarService().showError(
        title: AppStrings.error,
        message: e.toString(),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Delete task with permission check
  ///
  /// [taskId] Task ID to delete
  Future<void> deleteTask(String taskId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Find task
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) {
        throw TaskNotFoundException('Task not found');
      }

      final task = _tasks[taskIndex];

      // Validate workspace context
      if (task.workspaceId != _workspaceContext.currentWorkspaceId) {
        throw WorkspaceMismatchException(
            'Task does not belong to current workspace');
      }

      // Check delete permission
      final authController = _authController ??
          (Get.isRegistered<AuthController>()
              ? Get.find<AuthController>()
              : null);
      if (authController == null) {
        SnackbarService().showError(
            title: AppStrings.error, message: 'Auth controller not found');
        return;
      }
      try {
        final currentUser = authController.currentUser;
        if (currentUser == null) {
          SnackbarService().showError(
              title: AppStrings.error, message: 'User not logged in');
          return;
        }
        final currentUserId = currentUser.id;
        final canDelete = await _permissionService.canDeleteTask(
          currentUserId,
          _workspaceContext.currentWorkspaceId,
        );

        if (!canDelete) {
          throw InsufficientPermissionException(
              'Cannot delete tasks in this workspace');
        }

        // Remove task from list
        _tasks.removeAt(taskIndex);

        // Delete task from Firebase (with offline fallback)
        try {
          await FirebaseDatabaseService.instance.softDeleteTask(
            workspaceId: _workspaceContext.currentWorkspaceId,
            taskId: taskId,
          );
        } on DatabaseFailure {
          await OfflineQueueService.instance.deleteTask(
            workspaceId: _workspaceContext.currentWorkspaceId,
            taskId: taskId,
          );
        }

        // Show success message
        SnackbarService().showSuccess(
          title: AppStrings.success,
          message: AppStrings.taskDeleted,
        );
      } catch (e) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: 'Failed to get user info: $e',
        );
        return;
      }
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: $e';
      SnackbarService().showError(
        title: AppStrings.error,
        message: e.toString(),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Refresh tasks for current workspace
  Future<void> refreshTasks() async {
    await _loadTasks();
  }

  /// Generate unique task ID
  String _generateTaskId() {
    return 'task_${DateTime.now().millisecondsSinceEpoch}_${_tasks.length}';
  }

  /// Test helper method to add tasks directly (for testing only)
  /// This method should only be used in test environments
  void addTaskForTest(TaskEntity task) {
    _tasks.add(task);
  }

  /// Test helper method to add multiple tasks directly (for testing only)
  /// This method should only be used in test environments
  void addTasksForTest(List<TaskEntity> tasks) {
    _tasks.addAll(tasks);
  }
}

/// Custom exceptions for Sprint 5
class WorkspaceMismatchException implements Exception {
  WorkspaceMismatchException(this.message);

  final String message;

  @override
  String toString() => 'WorkspaceMismatchException: $message';
}

class InsufficientPermissionException implements Exception {
  InsufficientPermissionException(this.message);

  final String message;

  @override
  String toString() => 'InsufficientPermissionException: $message';
}

class TaskNotFoundException implements Exception {
  TaskNotFoundException(this.message);

  final String message;

  @override
  String toString() => 'TaskNotFoundException: $message';
}
