import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todolist/core/services/workspace_context_service.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/repositories/project_repository.dart';
import 'package:todolist/features/tasks/domain/usecases/calculate_project_progress.dart';
import 'package:todolist/features/tasks/presentation/controllers/project_controller.dart';
import 'package:todolist/features/tasks/presentation/pages/project_list_page.dart';

import 'project_management_integration_test.mocks.dart';

@GenerateMocks([
  ProjectRepository,
  CalculateProjectProgress,
  WorkspaceContextService,
  AuthController,
])
void main() {
  group('Project Management Integration Tests', () {
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
        authController: mockAuthController,
      );

      // Put ProjectController in GetX for ProjectListPage to find
      Get.put<ProjectController>(projectController);

      // Setup default mocks
      when(mockWorkspaceContext.hasValidWorkspace).thenReturn(true);
      when(mockWorkspaceContext.currentWorkspaceId).thenReturn('workspace-1');
      when(mockAuthController.currentUser).thenReturn(
        User(
          id: 'user-1',
          email: 'user@example.com',
          name: 'Test User',
          role: 'admin',
          workspaceId: 'company-1',
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        ),
      );
    });

    tearDown(Get.reset);

    testWidgets('should complete full project creation flow', (tester) async {
      // Arrange
      final testProject = Project(
        id: 'project-1',
        title: 'Integration Test Project',
        description: 'This is an integration test project',
        workspaceId: 'workspace-1',
        status: 'pending',
        createdBy: 'user-1',
        createdAt: DateTime.now(),
      );

      when(mockRepository.createProject(
        workspaceId: anyNamed('workspaceId'),
        project: anyNamed('project'),
      )).thenAnswer((_) async => testProject);

      when(mockRepository.getProjects(
        workspaceId: anyNamed('workspaceId'),
      )).thenAnswer((_) async => [testProject]);

      when(mockCalculateProgress.call(
        workspaceId: anyNamed('workspaceId'),
        projectId: anyNamed('projectId'),
      )).thenAnswer((_) async => ProjectProgressResult(
        isSuccess: true,
        progressPercentage: 0,
        totalTasks: 0,
        completedTasks: 0,
        pendingTasks: 0,
        inProgressTasks: 0,
        cancelledTasks: 0,
      ));

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProjectListPage(),
        ),
      );

      // Wait for initial load
      await tester.pumpAndSettle();

      // Act - Tap create project button
      await tester.tap(find.text('Create Project'));
      await tester.pumpAndSettle();

      // Fill project form
      await tester.enterText(find.byKey(const Key('project_title_field')), 'Integration Test Project');
      await tester.enterText(find.byKey(const Key('project_description_field')), 'This is an integration test project');
      
      // Tap create button
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Assert - Check for project creation success
      expect(find.text('Integration Test Project'), findsOneWidget);
    });

    testWidgets('should complete project progress tracking flow', (tester) async {
      // Arrange
      final testProject = Project(
        id: 'project-1',
        title: 'Test Project',
        description: 'Test Description',
        workspaceId: 'workspace-1',
        status: 'pending',
        createdBy: 'user-1',
        createdAt: DateTime.now(),
      );

      final progressResult = ProjectProgressResult(
        isSuccess: true,
        progressPercentage: 75,
        totalTasks: 8,
        completedTasks: 6,
        pendingTasks: 1,
        inProgressTasks: 1,
        cancelledTasks: 0,
        project: testProject,
      );

      when(mockRepository.getProjects(
        workspaceId: anyNamed('workspaceId'),
      )).thenAnswer((_) async => [testProject]);

      when(mockCalculateProgress.call(
        workspaceId: anyNamed('workspaceId'),
        projectId: anyNamed('projectId'),
      )).thenAnswer((_) async => progressResult);

      // Act
      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProjectListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Check for progress display
      expect(find.text('Test Project'), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
      expect(find.text('8'), findsOneWidget); // Total tasks
      expect(find.text('6'), findsOneWidget); // Completed tasks
    });

    testWidgets('should complete project deletion flow', (tester) async {
      // Arrange
      final testProject = Project(
        id: 'project-1',
        title: 'Test Project',
        description: 'Test Description',
        workspaceId: 'workspace-1',
        status: 'pending',
        createdBy: 'user-1',
        createdAt: DateTime.now(),
      );

      when(mockRepository.getProjects(
        workspaceId: anyNamed('workspaceId'),
      )).thenAnswer((_) async => [testProject]);

      when(mockRepository.deleteProject(
        workspaceId: anyNamed('workspaceId'),
        projectId: anyNamed('projectId'),
      )).thenAnswer((_) async {});

      when(mockCalculateProgress.call(
        workspaceId: anyNamed('workspaceId'),
        projectId: anyNamed('projectId'),
      )).thenAnswer((_) async => ProjectProgressResult(
        isSuccess: true,
        progressPercentage: 0,
        totalTasks: 0,
        completedTasks: 0,
        pendingTasks: 0,
        inProgressTasks: 0,
        cancelledTasks: 0,
      ));

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProjectListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Tap delete button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Confirm deletion
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Assert - Project should be removed
      expect(find.text('Test Project'), findsNothing);
    });

    testWidgets('should display empty state when no projects', (tester) async {
      // Arrange
      when(mockRepository.getProjects(
        workspaceId: anyNamed('workspaceId'),
      )).thenAnswer((_) async => []);

      // Act
      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProjectListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Check for empty state
      expect(find.text('No projects found'), findsOneWidget);
    });

    testWidgets('should display loading state', (tester) async {
      // Arrange
      when(mockRepository.getProjects(
        workspaceId: anyNamed('workspaceId'),
      )).thenAnswer((_) async => []);

      // Act
      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProjectListPage(),
        ),
      );

      // Assert - Should show loading initially
      await tester.pump(); // Give it a frame to show loading
    });

    testWidgets('should filter projects by workspace', (tester) async {
      // Arrange
      final project1 = Project(
        id: 'project-1',
        title: 'Project 1',
        description: 'Description 1',
        workspaceId: 'workspace-1',
        status: 'pending',
        createdBy: 'user-1',
        createdAt: DateTime.now(),
      );

      final project2 = Project(
        id: 'project-2',
        title: 'Project 2',
        description: 'Description 2',
        workspaceId: 'workspace-2', // Different workspace
        status: 'pending',
        createdBy: 'user-1',
        createdAt: DateTime.now(),
      );

      when(mockRepository.getProjects(
        workspaceId: anyNamed('workspaceId'),
      )).thenAnswer((_) async => [project1, project2]);

      when(mockCalculateProgress.call(
        workspaceId: anyNamed('workspaceId'),
        projectId: anyNamed('projectId'),
      )).thenAnswer((_) async => ProjectProgressResult(
        isSuccess: true,
        progressPercentage: 0,
        totalTasks: 0,
        completedTasks: 0,
        pendingTasks: 0,
        inProgressTasks: 0,
        cancelledTasks: 0,
      ));

      // Act
      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProjectListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Only project from current workspace should be displayed
      expect(find.text('Project 1'), findsOneWidget);
      expect(find.text('Project 2'), findsNothing);
    });

    testWidgets('should handle workspace context validation', (tester) async {
      // Arrange
      when(mockWorkspaceContext.hasValidWorkspace).thenReturn(false);

      // Act
      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProjectListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Should handle invalid workspace gracefully
      expect(find.text('No projects found'), findsOneWidget);
    });

    testWidgets('should handle project creation error gracefully', (tester) async {
      // Arrange
      when(mockRepository.createProject(
        workspaceId: anyNamed('workspaceId'),
        project: anyNamed('project'),
      )).thenThrow(Exception('Database error'));

      when(mockRepository.getProjects(
        workspaceId: anyNamed('workspaceId'),
      )).thenAnswer((_) async => []);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProjectListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Try to create project
      await tester.tap(find.text('Create Project'));
      await tester.pumpAndSettle();

      // Fill form
      await tester.enterText(find.byKey(const Key('project_title_field')), 'Test Project');
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Assert - Should show error message
      expect(find.text('Database error'), findsOneWidget);
    });
  });
}
