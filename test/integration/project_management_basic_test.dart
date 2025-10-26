import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/presentation/widgets/project_progress_card.dart';

void main() {
  group('Project Management Basic Integration Tests', () {
    late Project testProject;

    setUp(() {
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

    testWidgets('should display project progress card', (WidgetTester tester) async {
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
      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('should handle project with different statuses', (WidgetTester tester) async {
      // Test completed project
      final completedProject = Project(
        id: 'project-2',
        title: 'Completed Project',
        description: 'A completed project',
        workspaceId: 'workspace-1',
        status: 'completed',
        createdBy: 'user-1',
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: completedProject,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Completed Project'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('should handle project without description', (WidgetTester tester) async {
      // Arrange
      final projectWithoutDescription = Project(
        id: 'project-3',
        title: 'Project Without Description',
        description: null,
        workspaceId: 'workspace-1',
        status: 'pending',
        createdBy: 'user-1',
        createdAt: DateTime.now(),
      );

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
      expect(find.text('Project Without Description'), findsOneWidget);
    });

    testWidgets('should handle project without deadline', (WidgetTester tester) async {
      // Arrange
      final projectWithoutDeadline = Project(
        id: 'project-4',
        title: 'Project Without Deadline',
        description: 'A project without deadline',
        workspaceId: 'workspace-1',
        status: 'pending',
        createdBy: 'user-1',
        createdAt: DateTime.now(),
        deadline: null,
      );

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
      expect(find.text('Project Without Deadline'), findsOneWidget);
    });

    testWidgets('should handle project with deadline', (WidgetTester tester) async {
      // Arrange
      final projectWithDeadline = Project(
        id: 'project-5',
        title: 'Project With Deadline',
        description: 'A project with deadline',
        workspaceId: 'workspace-1',
        status: 'pending',
        createdBy: 'user-1',
        createdAt: DateTime.now(),
        deadline: DateTime.now().add(Duration(days: 7)),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectProgressCard(
              project: projectWithDeadline,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Project With Deadline'), findsOneWidget);
    });
  });
}
