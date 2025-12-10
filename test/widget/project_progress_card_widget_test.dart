import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/entities/project_status.dart';
import 'package:todolist/features/tasks/domain/usecases/calculate_project_progress.dart';
import 'package:todolist/features/tasks/presentation/widgets/project_progress_card.dart';

void main() {
  group('ProjectProgressCard Widget Tests', () {
    late Project testProject;
    late ProjectProgressResult testProgress;

    setUp(() {
      testProject = Project(
        id: 'project-1',
        title: 'Test Project',
        description: 'Test Description',
        workspaceId: 'workspace-1',
        status: ProjectStatus.pending,
        createdBy: 'user-1',
        createdAt: DateTime.now(),
        deadline: DateTime.now().add(const Duration(days: 7)),
      );

      testProgress = ProjectProgressResult(
        isSuccess: true,
        progressPercentage: 75,
        totalTasks: 8,
        completedTasks: 6,
        pendingTasks: 1,
        inProgressTasks: 1,
        cancelledTasks: 0,
        project: testProject,
      );
    });

    tearDown(Get.reset);

    testWidgets('should display project title and description', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: testProject,
              progress: testProgress,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Project'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('should display project status chip', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: testProject,
              progress: testProgress,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('should display progress bar when progress is available', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: testProject,
              progress: testProgress,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Progress'), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('should display task statistics when progress is available', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: testProject,
              progress: testProgress,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('8'), findsOneWidget); // Total tasks
      expect(find.text('6'), findsOneWidget); // Completed tasks
      expect(find.text('1'), findsNWidgets(2)); // Pending and In Progress tasks
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('In Progress'), findsOneWidget);
    });

    testWidgets('should display project metadata', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: testProject,
              progress: testProgress,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.schedule), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('should display action buttons', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: testProject,
              progress: testProgress,
            ),
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
            body: ProjectProgressCard(
              project: testProject,
              progress: testProgress,
              onTap: () => onTapCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ProjectProgressCard));
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
            body: ProjectProgressCard(
              project: testProject,
              progress: testProgress,
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
            body: ProjectProgressCard(
              project: testProject,
              progress: testProgress,
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

    testWidgets('should display overdue chip when project is overdue', (tester) async {
      // Arrange
      final overdueProgress = ProjectProgressResult(
        isSuccess: true,
        progressPercentage: 50,
        totalTasks: 4,
        completedTasks: 2,
        pendingTasks: 1,
        inProgressTasks: 1,
        cancelledTasks: 0,
        isOverdue: true,
        project: testProject,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: testProject,
              progress: overdueProgress,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Overdue'), findsOneWidget);
    });

    testWidgets('should not display progress bar when progress is null', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: testProject,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Progress'), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('should not display task statistics when progress is null', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: testProject,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Total'), findsNothing);
      expect(find.text('Completed'), findsNothing);
      expect(find.text('Pending'), findsNothing);
      expect(find.text('In Progress'), findsNothing);
    });

    testWidgets('should handle project without description', (tester) async {
      // Arrange
      final projectWithoutDescription = testProject.copyWith();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: projectWithoutDescription,
              progress: testProgress,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Project'), findsOneWidget);
      expect(find.text('Test Description'), findsNothing);
    });

    testWidgets('should handle project without deadline', (tester) async {
      // Arrange
      final projectWithoutDeadline = testProject.copyWith();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: projectWithoutDeadline,
              progress: testProgress,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.schedule), findsNothing);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('should display different status chips correctly', (tester) async {
      // Test completed status
      final completedProject = testProject.copyWith(status: ProjectStatus.completed);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: completedProject,
              progress: testProgress,
            ),
          ),
        ),
      );

      expect(find.text('Completed'), findsOneWidget);

      // Test in_progress status
      final inProgressProject = testProject.copyWith(status: ProjectStatus.inProgress);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: inProgressProject,
              progress: testProgress,
            ),
          ),
        ),
      );

      expect(find.text('In Progress'), findsOneWidget);

      // Test cancelled status
      final cancelledProject = testProject.copyWith(status: ProjectStatus.cancelled);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: cancelledProject,
              progress: testProgress,
            ),
          ),
        ),
      );

      expect(find.text('Cancelled'), findsOneWidget);
    });
  });
}
