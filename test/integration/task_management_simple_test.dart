import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todolist/core/constants/task_enums.dart';
import 'package:todolist/core/services/permission_service.dart';
import 'package:todolist/core/services/workspace_context_service.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';
import 'package:todolist/features/tasks/presentation/controllers/task_controller.dart';

import 'task_management_simple_test.mocks.dart';

@GenerateMocks([
  WorkspaceContextService,
  PermissionService,
  AuthController,
])
void main() {
  group('Task Management Simple Tests', () {
    late MockWorkspaceContextService mockWorkspaceContext;
    late MockPermissionService mockPermissionService;
    late MockAuthController mockAuthController;
    late TaskController taskController;

    setUp(() {
      mockWorkspaceContext = MockWorkspaceContextService();
      mockPermissionService = MockPermissionService();
      mockAuthController = MockAuthController();

      // Setup mocks without GetX dependency injection
      when(mockWorkspaceContext.hasValidWorkspace).thenReturn(true);
      when(mockWorkspaceContext.currentWorkspaceId).thenReturn('workspace-1');
      when(mockWorkspaceContext.workspaceMembers).thenReturn([
        User(
          id: 'user-1',
          email: 'user1@example.com',
          name: 'User 1',
          role: 'member',
          workspaceId: 'company-1',
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        ),
      ]);
      when(mockWorkspaceContext.workspaceProjects).thenReturn([]);
      when(mockAuthController.currentUser).thenReturn(
        User(
          id: 'current-user',
          email: 'current@example.com',
          name: 'Current User',
          role: 'admin',
          workspaceId: 'company-1',
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        ),
      );
      when(mockPermissionService.canCreateTask(any, any))
          .thenAnswer((_) async => true);
      when(mockPermissionService.canAssignTask(any, any, any))
          .thenAnswer((_) async => true);
      when(mockPermissionService.canUpdateTaskStatus(any, any))
          .thenAnswer((_) async => true);
      when(mockPermissionService.canDeleteTask(any, any))
          .thenAnswer((_) async => true);
      when(mockWorkspaceContext.isWorkspaceMember(any)).thenReturn(true);

      taskController = TaskController(
        workspaceContext: mockWorkspaceContext,
        permissionService: mockPermissionService,
      );
    });

    tearDown(Get.reset);

    test('should create task successfully', () async {
      // Arrange
      final testTask = TaskEntity(
        id: 'task-1',
        title: 'Test Task',
        workspaceId: 'workspace-1',
        taskType: TaskType.daily.value,
        priority: TaskPriority.medium.value,
        status: TaskStatus.pending.value,
        assigner: 'current-user',
        hasDeadline: false,
        recurring: const RecurringConfig(isRecurring: false),
        createdAt: DateTime.now(),
      );

      // Act
      taskController.addTaskForTest(testTask);

      // Assert
      expect(taskController.tasks.length, 1);
      expect(taskController.tasks.first.title, 'Test Task');
    });

    test('should filter tasks by workspace', () async {
      // Arrange
      final task1 = TaskEntity(
        id: 'task-1',
        title: 'Task 1',
        workspaceId: 'workspace-1',
        taskType: TaskType.daily.value,
        priority: TaskPriority.medium.value,
        status: TaskStatus.pending.value,
        assigner: 'current-user',
        hasDeadline: false,
        recurring: const RecurringConfig(isRecurring: false),
        createdAt: DateTime.now(),
      );

      final task2 = TaskEntity(
        id: 'task-2',
        title: 'Task 2',
        workspaceId: 'workspace-2', // Different workspace
        taskType: TaskType.daily.value,
        priority: TaskPriority.medium.value,
        status: TaskStatus.pending.value,
        assigner: 'current-user',
        hasDeadline: false,
        recurring: const RecurringConfig(isRecurring: false),
        createdAt: DateTime.now(),
      );

      taskController.addTasksForTest([task1, task2]);

      // Assert - Only task from current workspace should be visible
      expect(taskController.tasks.length, 1);
      expect(taskController.tasks.first.title, 'Task 1');
    });

    test('should handle empty task list', () async {
      // Assert
      expect(taskController.tasks.length, 0);
      expect(taskController.isLoading, false);
    });
  });
}
