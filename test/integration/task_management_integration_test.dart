import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/constants/task_enums.dart';
import 'package:todolist/core/services/permission_service.dart';
import 'package:todolist/core/services/workspace_context_service.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';
import 'package:todolist/features/tasks/presentation/controllers/task_controller.dart';
import 'package:todolist/features/tasks/presentation/pages/task_list_page.dart';
import 'package:todolist/features/tasks/presentation/widgets/create_task_form.dart';

import 'task_management_integration_test.mocks.dart';

@GenerateMocks([
  WorkspaceContextService,
  PermissionService,
  AuthController,
])
void main() {
  group('Task Management Integration Tests', () {
    late MockWorkspaceContextService mockWorkspaceContext;
    late MockPermissionService mockPermissionService;
    late MockAuthController mockAuthController;
    late TaskController taskController;

    setUp(() {
      mockWorkspaceContext = MockWorkspaceContextService();
      mockPermissionService = MockPermissionService();
      mockAuthController = MockAuthController();

      // Setup GetX dependencies
      Get.put<WorkspaceContextService>(mockWorkspaceContext);
      Get.put<PermissionService>(mockPermissionService);
      Get.put<AuthController>(mockAuthController);

      taskController = TaskController(
        workspaceContext: mockWorkspaceContext,
        permissionService: mockPermissionService,
      );

      // Setup default mocks
      when(mockWorkspaceContext.hasValidWorkspace).thenReturn(true);
      when(mockWorkspaceContext.currentWorkspaceId).thenReturn('workspace-1');
      when(mockWorkspaceContext.workspaceMembers).thenReturn([
        User(
          id: 'user-1',
          email: 'user1@example.com',
          name: 'User 1',
          role: 'member',
          companyId: 'company-1',
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        ),
        User(
          id: 'user-2',
          email: 'user2@example.com',
          name: 'User 2',
          role: 'member',
          companyId: 'company-1',
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
          companyId: 'company-1',
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

    tearDown(() {
      Get.reset();
    });

    testWidgets('should complete full task creation flow', (tester) async {
      // Arrange
      await tester.pumpWidget(
        GetMaterialApp(
          home: const TaskListPage(),
        ),
      );

      // Wait for initial load
      await tester.pumpAndSettle();

      // Act - Tap create task button
      await tester.tap(find.text(AppStrings.createTask));
      await tester.pumpAndSettle();

      // Fill task form
      await tester.enterText(find.byKey(const Key('task_title_field')), 'Integration Test Task');
      await tester.enterText(find.byKey(const Key('task_description_field')), 'This is an integration test task');
      
      // Select assignee
      await tester.tap(find.byType(DropdownButtonFormField<User>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('User 1'));
      await tester.pumpAndSettle();

      // Select priority
      await tester.tap(find.byType(DropdownButtonFormField<TaskPriority>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('High'));
      await tester.pumpAndSettle();

      // Select type
      await tester.tap(find.byType(DropdownButtonFormField<TaskType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Daily'));
      await tester.pumpAndSettle();

      // Tap create button
      await tester.tap(find.text(AppStrings.create));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Integration Test Task'), findsOneWidget);
      expect(find.text('This is an integration test task'), findsOneWidget);
      expect(find.text('High'), findsOneWidget);
      expect(find.text('Daily'), findsOneWidget);
    });

    testWidgets('should complete task assignment flow', (tester) async {
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

      taskController._tasks.add(testTask);

      await tester.pumpWidget(
        GetMaterialApp(
          home: const TaskListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Tap on task card
      await tester.tap(find.text('Test Task'));
      await tester.pumpAndSettle();

      // Assert - Task should be displayed
      expect(find.text('Test Task'), findsOneWidget);
    });

    testWidgets('should complete task status update flow', (tester) async {
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

      taskController._tasks.add(testTask);

      await tester.pumpWidget(
        GetMaterialApp(
          home: const TaskListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Change task status
      await tester.tap(find.byType(DropdownButtonFormField<TaskStatus>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Completed'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('should complete task deletion flow', (tester) async {
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

      taskController._tasks.add(testTask);

      await tester.pumpWidget(
        GetMaterialApp(
          home: const TaskListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Tap delete button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Confirm deletion
      await tester.tap(find.text(AppStrings.delete));
      await tester.pumpAndSettle();

      // Assert - Task should be removed
      expect(find.text('Test Task'), findsNothing);
    });

    testWidgets('should display empty state when no tasks', (tester) async {
      // Arrange
      when(mockWorkspaceContext.hasValidWorkspace).thenReturn(true);
      when(mockWorkspaceContext.currentWorkspaceId).thenReturn('workspace-1');

      // Act
      await tester.pumpWidget(
        GetMaterialApp(
          home: const TaskListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text(AppStrings.noTasksFound), findsOneWidget);
      expect(find.text(AppStrings.createFirstTask), findsOneWidget);
    });

    testWidgets('should display loading state', (tester) async {
      // Arrange
      when(mockWorkspaceContext.hasValidWorkspace).thenReturn(true);
      when(mockWorkspaceContext.currentWorkspaceId).thenReturn('workspace-1');

      // Act
      await tester.pumpWidget(
        GetMaterialApp(
          home: const TaskListPage(),
        ),
      );

      // Assert - Should show loading initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
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

      taskController._tasks.addAll([task1, task2]);

      // Act
      await tester.pumpWidget(
        GetMaterialApp(
          home: const TaskListPage(),
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
        GetMaterialApp(
          home: const TaskListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Should handle invalid workspace gracefully
      expect(find.text(AppStrings.noTasksFound), findsOneWidget);
    });

    testWidgets('should handle permission errors gracefully', (tester) async {
      // Arrange
      when(mockPermissionService.canCreateTask(any, any))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(
        GetMaterialApp(
          home: const TaskListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Try to create task
      await tester.tap(find.text(AppStrings.createTask));
      await tester.pumpAndSettle();

      // Fill form
      await tester.enterText(find.byKey(const Key('task_title_field')), 'Test Task');
      await tester.tap(find.text(AppStrings.create));
      await tester.pumpAndSettle();

      // Assert - Should show error message
      expect(find.text('InsufficientPermissionException'), findsOneWidget);
    });
  });
}
