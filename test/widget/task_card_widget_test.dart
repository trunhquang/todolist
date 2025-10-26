import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:todolist/core/constants/task_enums.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';
import 'package:todolist/features/tasks/presentation/widgets/task_card.dart';

void main() {
  group('TaskCard Widget Tests', () {
    late TaskEntity testTask;

    setUp(() {
      testTask = TaskEntity(
        id: 'task-1',
        title: 'Test Task',
        description: 'Test Description',
        workspaceId: 'workspace-1',
        taskType: TaskType.daily.value,
        priority: TaskPriority.high.value,
        status: TaskStatus.pending.value,
        assignee: 'user-1',
        assigner: 'user-2',
        projectId: 'project-1',
        hasDeadline: true,
        deadline: DateTime.now().add(const Duration(days: 1)),
        recurring: const RecurringConfig(isRecurring: false),
        createdAt: DateTime.now(),
      );
    });

    tearDown(Get.reset);

    testWidgets('should display task title and description', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('should display task status chip', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask),
          ),
        ),
      );

      // Assert
      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('should display task priority chip', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask),
          ),
        ),
      );

      // Assert
      expect(find.text('High'), findsOneWidget);
    });

    testWidgets('should display task type chip', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask),
          ),
        ),
      );

      // Assert
      expect(find.text('Daily'), findsOneWidget);
    });

    testWidgets('should display deadline chip when task has deadline', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask),
          ),
        ),
      );

      // Assert
      expect(find.text('Due Today'), findsOneWidget);
    });

    testWidgets('should display assignee and project indicators', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask),
          ),
        ),
      );

      // Assert
      expect(find.text('Assigned'), findsOneWidget);
      expect(find.text('Project'), findsOneWidget);
    });

    testWidgets('should display status dropdown', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask),
          ),
        ),
      );

      // Assert
      expect(find.byType(DropdownButtonFormField<TaskStatus>), findsOneWidget);
    });

    testWidgets('should display edit and delete buttons', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('should call onTap when card is tapped', (tester) async {
      // Arrange
      var onTapCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask,
              onTap: () => onTapCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TaskCard));
      await tester.pump();

      // Assert
      expect(onTapCalled, true);
    });

    testWidgets('should call onEdit when edit button is tapped', (tester) async {
      // Arrange
      var onEditCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask,
              onEdit: () => onEditCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();

      // Assert
      expect(onEditCalled, true);
    });

    testWidgets('should call onDelete when delete button is tapped', (tester) async {
      // Arrange
      var onDeleteCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask,
              onDelete: () => onDeleteCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      // Assert
      expect(onDeleteCalled, true);
    });

    testWidgets('should call onStatusChange when status is changed', (tester) async {
      // Arrange
      TaskStatus? changedStatus;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask,
              onStatusChange: (status) => changedStatus = status,
            ),
          ),
        ),
      );

      // Tap on status dropdown
      await tester.tap(find.byType(DropdownButtonFormField<TaskStatus>));
      await tester.pumpAndSettle();

      // Select completed status
      await tester.tap(find.text('Completed'));
      await tester.pumpAndSettle();

      // Assert
      expect(changedStatus, TaskStatus.completed);
    });

    testWidgets('should display overdue chip when deadline is in the past', (tester) async {
      // Arrange
      final overdueTask = testTask.copyWith(
        deadline: DateTime.now().subtract(const Duration(days: 1)),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: overdueTask),
          ),
        ),
      );

      // Assert
      expect(find.text('Overdue'), findsOneWidget);
    });

    testWidgets('should display due today chip when deadline is today', (tester) async {
      // Arrange
      final todayTask = testTask.copyWith(
        deadline: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: todayTask),
          ),
        ),
      );

      // Assert
      expect(find.text('Due Today'), findsOneWidget);
    });

    testWidgets('should not display deadline chip when task has no deadline', (tester) async {
      // Arrange
      final noDeadlineTask = testTask.copyWith(
        hasDeadline: false,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: noDeadlineTask),
          ),
        ),
      );

      // Assert
      expect(find.text('Overdue'), findsNothing);
      expect(find.text('Due Today'), findsNothing);
    });

    testWidgets('should not display assignee indicator when task has no assignee', (tester) async {
      // Arrange
      final unassignedTask = testTask.copyWith();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: unassignedTask),
          ),
        ),
      );

      // Assert
      expect(find.text('Assigned'), findsNothing);
    });

    testWidgets('should not display project indicator when task has no project', (tester) async {
      // Arrange
      final noProjectTask = testTask.copyWith();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: noProjectTask),
          ),
        ),
      );

      // Assert
      expect(find.text('Project'), findsNothing);
    });
  });
}
