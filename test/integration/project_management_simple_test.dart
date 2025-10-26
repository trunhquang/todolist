import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/core/services/workspace_context_service.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/repositories/project_repository.dart';
import 'package:todolist/features/tasks/domain/usecases/calculate_project_progress.dart';
import 'package:todolist/features/tasks/presentation/controllers/project_controller.dart';
import 'package:todolist/features/tasks/presentation/pages/project_list_page.dart';

import 'project_management_simple_test.mocks.dart';

@GenerateMocks([
  ProjectRepository,
  CalculateProjectProgress,
  WorkspaceContextService,
  AuthController,
])
void main() {
  group('Project Management Simple Integration Tests', () {
    late MockProjectRepository mockRepository;
    late MockCalculateProjectProgress mockCalculateProgress;
    late MockWorkspaceContextService mockWorkspaceContext;
    late MockAuthController mockAuthController;
    late ProjectController projectController;

    setUp(() {
      mockRepository = MockProjectRepository();
      mockCalculateProgress = MockCalculateProjectProgress();
      mockWorkspaceContext = MockWorkspaceContextService();
      mockAuthController = MockAuthController();

      projectController = ProjectController(
        projectRepository: mockRepository,
        calculateProgress: mockCalculateProgress,
        workspaceContext: mockWorkspaceContext,
      );

      when(mockWorkspaceContext.currentWorkspaceId).thenReturn('workspace-1');
      when(mockWorkspaceContext.currentUser).thenReturn(User(
        id: 'user-1',
        email: 'test@example.com',
        name: 'Test User',
        role: 'admin',
        workspaceId: 'workspace-1',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      ));
    });

    testWidgets('should display project list page', (WidgetTester tester) async {
      // Arrange
      when(mockRepository.getProjects(
        workspaceId: anyNamed('workspaceId'),
        status: anyNamed('status'),
      )).thenAnswer((_) async => []);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProjectListPage(),
        ),
      );

      // Assert
      expect(find.text('Projects'), findsOneWidget);
    });

    testWidgets('should display empty state when no projects', (WidgetTester tester) async {
      // Arrange
      when(mockRepository.getProjects(
        workspaceId: anyNamed('workspaceId'),
        status: anyNamed('status'),
      )).thenAnswer((_) async => []);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProjectListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No projects found.'), findsOneWidget);
    });

    testWidgets('should display projects when available', (WidgetTester tester) async {
      // Arrange
      final testProjects = [
        Project(
          id: 'project-1',
          title: 'Test Project 1',
          description: 'Test Description 1',
          workspaceId: 'workspace-1',
          status: 'pending',
          createdBy: 'user-1',
          createdAt: DateTime.now(),
        ),
        Project(
          id: 'project-2',
          title: 'Test Project 2',
          description: 'Test Description 2',
          workspaceId: 'workspace-1',
          status: 'in_progress',
          createdBy: 'user-1',
          createdAt: DateTime.now(),
        ),
      ];

      when(mockRepository.getProjects(
        workspaceId: anyNamed('workspaceId'),
        status: anyNamed('status'),
      )).thenAnswer((_) async => testProjects);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProjectListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Project 1'), findsOneWidget);
      expect(find.text('Test Project 2'), findsOneWidget);
    });

    testWidgets('should handle project creation', (WidgetTester tester) async {
      // Arrange
      final newProject = Project(
        id: 'project-3',
        title: 'New Project',
        description: 'New Description',
        workspaceId: 'workspace-1',
        status: 'pending',
        createdBy: 'user-1',
        createdAt: DateTime.now(),
      );

      when(mockRepository.getProjects(
        workspaceId: anyNamed('workspaceId'),
        status: anyNamed('status'),
      )).thenAnswer((_) async => []);

      when(mockRepository.createProject(
        workspaceId: anyNamed('workspaceId'),
        project: anyNamed('project'),
      )).thenAnswer((_) async => newProject);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProjectListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Projects'), findsOneWidget);
    });
  });
}
