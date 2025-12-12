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
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  bool get isLoading {
    return _isLoading.value;
  }

  String get errorMessage => _errorMessage.value;

  List<Project> get workspaceProjects => _workspaceContext.workspaceProjects;

  Project? getProject(String projectId) =>
      _workspaceContext.getWorkspaceProject(projectId);

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
    TaskEntity? initialTask,
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

        // If task has project, ensure assignee (if any) is project member
        if (projectId != null && assigneeId != null) {
          final project = getProject(projectId);
          if (project == null) {
            throw WorkspaceMismatchException('Project not found in workspace');
          }
        }

        // Create task entity
        final now = DateTime.now();
        final localTask = TaskEntity(
          id: initialTask?.id ?? '',
          title: title,
          description:
              description?.trim().isEmpty ?? false ? null : description?.trim(),
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
          if (initialTask != null) {
            await FirebaseDatabaseService.instance.updateTask(
              workspaceId: _workspaceContext.currentWorkspaceId,
              task: localTask,
            );
          } else {
            final firebaseId =
                await FirebaseDatabaseService.instance.createTask(
              workspaceId: _workspaceContext.currentWorkspaceId,
              task: localTask,
            );
            final savedTask = localTask.copyWith(id: firebaseId);
          }
        } on DatabaseFailure {
          // Fallback: enqueue for offline sync and keep local copy with generated ID
          await OfflineQueueService.instance.createTask(
            workspaceId: _workspaceContext.currentWorkspaceId,
            task: localTask,
          );
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
