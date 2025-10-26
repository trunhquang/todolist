import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/constants/task_enums.dart';
import 'package:todolist/core/services/permission_service.dart';
import 'package:todolist/core/services/workspace_context_service.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';
import 'package:todolist/features/tasks/presentation/controllers/task_controller.dart';
import 'package:todolist/features/tasks/presentation/pages/task_list_page.dart';

import 'task_management_ui_test.mocks.dart';

@GenerateMocks([
  WorkspaceContextService,
  PermissionService,
  AuthController,
])
void main() {
  group('Task Management UI Tests', () {
    late MockWorkspaceContextService mockWorkspaceContext;
    late MockPermissionService mockPermissionService;
    late MockAuthController mockAuthController;
    late TaskController taskController;

    setUp(() {
      mockWorkspaceContext = MockWorkspaceContextService();
      mockPermissionService = MockPermissionService();
      mockAuthController = MockAuthController();

      taskController = TaskController(
        workspaceContext: mockWorkspaceContext,
        permissionService: mockPermissionService,
        authController: mockAuthController,
      );

      // Put TaskController in GetX for TaskListPage to find
      Get.put<TaskController>(taskController);

      // Setup default mocks
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
    });

    tearDown(Get.reset);

    testWidgets('should display task list page without errors', (tester) async {
      // Act
      await tester.pumpWidget(
        const GetMaterialApp(
          home: TaskListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Page should load without crashing
      expect(find.byType(TaskListPage), findsOneWidget);
    });

    testWidgets('should display tasks when available', (tester) async {
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

      taskController.addTaskForTest(testTask);

      // Act
      await tester.pumpWidget(
        const GetMaterialApp(
          home: TaskListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Task'), findsOneWidget);
    });

    testWidgets('should display empty state when no tasks', (tester) async {
      // Act
      await tester.pumpWidget(
        const GetMaterialApp(
          home: TaskListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text(AppStrings.noTasksFound), findsOneWidget);
    });

    testWidgets('should filter tasks by workspace', (tester) async {
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

      // Act
      await tester.pumpWidget(
        const GetMaterialApp(
          home: TaskListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Only task from current workspace should be displayed
      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsNothing);
    });

    testWidgets('should handle workspace context validation', (tester) async {
      // Arrange
      when(mockWorkspaceContext.hasValidWorkspace).thenReturn(false);

      // Act
      await tester.pumpWidget(
        const GetMaterialApp(
          home: TaskListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Should handle invalid workspace gracefully
      expect(find.text(AppStrings.noTasksFound), findsOneWidget);
    });
  });
}
