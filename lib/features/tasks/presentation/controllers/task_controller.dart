import 'package:get/get.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/constants/task_enums.dart';
// import 'package:todolist/core/services/navigation_service.dart'; // Removed unused import
import 'package:todolist/core/services/permission_service.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/core/services/workspace_context_service.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';

/// TaskController manages task operations with workspace context for Sprint 5
/// 
/// This controller handles:
/// - Task creation with workspace validation
/// - Task assignment with permission checks
/// - Task filtering by current workspace
/// - Real-time task updates
class TaskController extends GetxController {
  // Dependencies
  final WorkspaceContextService _workspaceContext;
  final PermissionService _permissionService;
  final AuthController? _authController;

  // Private observables
  final _tasks = <TaskEntity>[].obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;

  // Constructor
  TaskController({
    required WorkspaceContextService workspaceContext,
    required PermissionService permissionService,
    AuthController? authController, // Optional for testing
  }) : _workspaceContext = workspaceContext,
       _permissionService = permissionService,
       _authController = authController;

  // Public getters
  List<TaskEntity> get tasks => _tasks.where((task) => 
    task.workspaceId == _workspaceContext.currentWorkspaceId
  ).toList();
  
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  List<User> get workspaceMembers => _workspaceContext.workspaceMembers;
  List<Project> get workspaceProjects => _workspaceContext.workspaceProjects;

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

      // TODO: Implement actual task loading from Firebase
      // This should call the appropriate service to get tasks for current workspace
      // For now, using empty list as placeholder
      _tasks.value = [];
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
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
    DateTime? deadline,
  }) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Validate workspace context
      if (!_workspaceContext.hasValidWorkspace) {
        throw WorkspaceMismatchException('No valid workspace selected');
      }

      // Check create task permission
      final authController = _authController ?? (Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null);
      if (authController == null) {
        SnackbarService().showError(title: AppStrings.error, message: 'Auth controller not found');
        return;
      }
      try {
        final currentUser = authController.currentUser;
        if (currentUser == null) {
          SnackbarService().showError(title: AppStrings.error, message: 'User not logged in');
          return;
        }
        final currentUserId = currentUser.id;
      final canCreate = await _permissionService.canCreateTask(
        currentUserId,
        _workspaceContext.currentWorkspaceId,
      );

      if (!canCreate) {
        throw InsufficientPermissionException('Cannot create tasks in this workspace');
      }

      // Validate assignee if provided
      if (assigneeId != null && !_workspaceContext.isWorkspaceMember(assigneeId)) {
        throw WorkspaceMismatchException('Assignee is not a member of current workspace');
      }

      // Validate project if provided
      if (projectId != null && !_workspaceContext.isWorkspaceProject(projectId)) {
        throw WorkspaceMismatchException('Project does not belong to current workspace');
      }

      // Create task entity
      final task = TaskEntity(
        id: _generateTaskId(),
        title: title,
        description: description,
        workspaceId: _workspaceContext.currentWorkspaceId,
        taskType: taskType.value,
        priority: priority.value,
        status: TaskStatus.pending.value,
        assignee: assigneeId,
        assigner: currentUserId,
        projectId: projectId,
        hasDeadline: deadline != null,
        deadline: deadline,
        recurring: const RecurringConfig(isRecurring: false),
        createdAt: DateTime.now(),
      );

      // TODO: Save task to Firebase
      // This should call the appropriate service to save task
      // For now, adding to local list
      _tasks.add(task);

      // Show success message
      SnackbarService().showSuccess(
        title: AppStrings.success,
        message: AppStrings.taskCreated,
      );
      } catch (e) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: 'Failed to get user info: ${e.toString()}',
        );
        return;
      }
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: ${e.toString()}';
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
        throw WorkspaceMismatchException('Task does not belong to current workspace');
      }

      // Check assign permission
      final authController = _authController ?? (Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null);
      if (authController == null) {
        SnackbarService().showError(title: AppStrings.error, message: 'Auth controller not found');
        return;
      }
      try {
        final currentUser = authController.currentUser;
        if (currentUser == null) {
          SnackbarService().showError(title: AppStrings.error, message: 'User not logged in');
          return;
        }
        final currentUserId = currentUser.id;
      final canAssign = await _permissionService.canAssignTask(
        currentUserId,
        _workspaceContext.currentWorkspaceId,
        assigneeId,
      );

      if (!canAssign) {
        throw InsufficientPermissionException('Cannot assign tasks in this workspace');
      }

      // Validate assignee is workspace member
      if (!_workspaceContext.isWorkspaceMember(assigneeId)) {
        throw WorkspaceMismatchException('Assignee is not a member of current workspace');
      }

      // Update task assignment
      final updatedTask = task.copyWith(
        assignee: assigneeId,
        updatedAt: DateTime.now(),
      );

      _tasks[taskIndex] = updatedTask;

      // TODO: Update task in Firebase
      // This should call the appropriate service to update task

      // Show success message
      SnackbarService().showSuccess(
        title: AppStrings.success,
        message: 'Task assigned successfully',
      );
      } catch (e) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: 'Failed to get user info: ${e.toString()}',
        );
        return;
      }
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: ${e.toString()}';
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
        throw WorkspaceMismatchException('Task does not belong to current workspace');
      }

      // Check update permission
      final authController = _authController ?? (Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null);
      if (authController == null) {
        SnackbarService().showError(title: AppStrings.error, message: 'Auth controller not found');
        return;
      }
      try {
        final currentUser = authController.currentUser;
        if (currentUser == null) {
          SnackbarService().showError(title: AppStrings.error, message: 'User not logged in');
          return;
        }
        final currentUserId = currentUser.id;
      final canUpdate = await _permissionService.canUpdateTaskStatus(
        currentUserId,
        _workspaceContext.currentWorkspaceId,
      );

      if (!canUpdate) {
        throw InsufficientPermissionException('Cannot update task status in this workspace');
      }

      // Update task status
      final updatedTask = task.copyWith(
        status: status.value,
        updatedAt: DateTime.now(),
      );

      _tasks[taskIndex] = updatedTask;

      // TODO: Update task in Firebase
      // This should call the appropriate service to update task

      // Show success message
      SnackbarService().showSuccess(
        title: AppStrings.success,
        message: 'Task status updated successfully',
      );
      } catch (e) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: 'Failed to get user info: ${e.toString()}',
        );
        return;
      }
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: ${e.toString()}';
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
        throw WorkspaceMismatchException('Task does not belong to current workspace');
      }

      // Check delete permission
      final authController = _authController ?? (Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null);
      if (authController == null) {
        SnackbarService().showError(title: AppStrings.error, message: 'Auth controller not found');
        return;
      }
      try {
        final currentUser = authController.currentUser;
        if (currentUser == null) {
          SnackbarService().showError(title: AppStrings.error, message: 'User not logged in');
          return;
        }
        final currentUserId = currentUser.id;
      final canDelete = await _permissionService.canDeleteTask(
        currentUserId,
        _workspaceContext.currentWorkspaceId,
      );

      if (!canDelete) {
        throw InsufficientPermissionException('Cannot delete tasks in this workspace');
      }

      // Remove task from list
      _tasks.removeAt(taskIndex);

      // TODO: Delete task from Firebase
      // This should call the appropriate service to delete task

      // Show success message
      SnackbarService().showSuccess(
        title: AppStrings.success,
        message: AppStrings.taskDeleted,
      );
      } catch (e) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: 'Failed to get user info: ${e.toString()}',
        );
        return;
      }
    } catch (e) {
      _errorMessage.value = '${AppStrings.errorOccurred}: ${e.toString()}';
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
  final String message;
  WorkspaceMismatchException(this.message);
  
  @override
  String toString() => 'WorkspaceMismatchException: $message';
}

class InsufficientPermissionException implements Exception {
  final String message;
  InsufficientPermissionException(this.message);
  
  @override
  String toString() => 'InsufficientPermissionException: $message';
}

class TaskNotFoundException implements Exception {
  final String message;
  TaskNotFoundException(this.message);
  
  @override
  String toString() => 'TaskNotFoundException: $message';
}
