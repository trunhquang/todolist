import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/presentation/widgets/project_progress_card.dart';

void main() {
  group('ProjectProgressCard Basic Tests', () {
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

    testWidgets('should display project title and description', (WidgetTester tester) async {
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

    testWidgets('should handle project without description', (WidgetTester tester) async {
      // Arrange
      final projectWithoutDescription = Project(
        id: 'project-2',
        title: 'Test Project 2',
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
      expect(find.text('Test Project 3'), findsOneWidget);
      expect(find.text('No deadline'), findsOneWidget);
    });

    testWidgets('should display different statuses', (WidgetTester tester) async {
      // Test completed status
      final completedProject = Project(
        id: 'project-4',
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

      expect(find.text('Completed'), findsOneWidget);
    });
  });
}
