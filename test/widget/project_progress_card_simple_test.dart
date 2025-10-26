import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/usecases/calculate_project_progress.dart';
import 'package:todolist/features/tasks/presentation/controllers/project_controller.dart';
import 'package:todolist/features/tasks/presentation/widgets/project_progress_card.dart';

import 'project_progress_card_widget_test.mocks.dart';

@GenerateMocks([ProjectController])
void main() {
  group('ProjectProgressCard Simple Tests', () {
    late MockProjectController mockController;
    late Project testProject;

    setUp(() {
      mockController = MockProjectController();
      testProject = Project(
        id: 'project-1',
        title: 'Test Project',
        description: 'Test Description',
        workspaceId: 'workspace-1',
        status: 'pending',
        createdBy: 'user-1',
        createdAt: DateTime.now(),
      );
    });

    testWidgets('should display project title and description', (WidgetTester tester) async {
      // Arrange
      when(mockController.getProjectProgress(any)).thenReturn(null);

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
      expect(find.text('Test Project'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('should display project status', (WidgetTester tester) async {
      // Arrange
      when(mockController.getProjectProgress(any)).thenReturn(null);

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
      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('should display progress when available', (WidgetTester tester) async {
      // Arrange
      final progress = ProjectProgressResult(
        isSuccess: true,
        progressPercentage: 75,
        totalTasks: 8,
        completedTasks: 6,
        pendingTasks: 2,
        inProgressTasks: 0,
        cancelledTasks: 0,
        isCompleted: false,
        isOverdue: false,
        project: testProject,
      );

      when(mockController.getProjectProgress(any)).thenReturn(progress);

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
      expect(find.text('75%'), findsOneWidget);
      expect(find.text('6/8 tasks completed'), findsOneWidget);
    });

    testWidgets('should handle project without description', (WidgetTester tester) async {
      // Arrange
      final projectWithoutDescription = Project(
        id: 'project-2',
        title: 'Test Project 2',
        description: null,
        workspaceId: 'workspace-1',
        status: 'pending',
        createdBy: 'user-1',
        createdAt: DateTime.now(),
      );

      when(mockController.getProjectProgress(any)).thenReturn(null);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: projectWithoutDescription,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Project 2'), findsOneWidget);
      expect(find.text('No description'), findsOneWidget);
    });

    testWidgets('should handle project without deadline', (WidgetTester tester) async {
      // Arrange
      final projectWithoutDeadline = Project(
        id: 'project-3',
        title: 'Test Project 3',
        description: 'Test Description',
        workspaceId: 'workspace-1',
        status: 'pending',
        createdBy: 'user-1',
        createdAt: DateTime.now(),
        deadline: null,
      );

      when(mockController.getProjectProgress(any)).thenReturn(null);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: projectWithoutDeadline,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Project 3'), findsOneWidget);
      expect(find.text('No deadline'), findsOneWidget);
    });
  });
}
