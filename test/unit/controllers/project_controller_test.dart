import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
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

import 'project_controller_test.mocks.dart';

@GenerateMocks([
  ProjectRepository,
  CalculateProjectProgress,
  WorkspaceContextService,
  AuthController,
])
void main() {
  setUpAll(WidgetsFlutterBinding.ensureInitialized);

  group('ProjectController', () {
    late MockProjectRepository mockRepository;
    late MockCalculateProjectProgress mockCalculateProgress;
    late MockWorkspaceContextService mockWorkspaceContext;
    late MockAuthController mockAuthController;
    late ProjectController controller;

    setUp(() {
      mockRepository = MockProjectRepository();
      mockCalculateProgress = MockCalculateProjectProgress();
      mockWorkspaceContext = MockWorkspaceContextService();
      mockAuthController = MockAuthController();

      controller = ProjectController(
        projectRepository: mockRepository,
        calculateProgress: mockCalculateProgress,
        workspaceContext: mockWorkspaceContext,
        authController: mockAuthController,
      );

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

    group('Project Creation', () {
      test('should create project successfully', () async {
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

        when(mockRepository.createProject(
          workspaceId: anyNamed('workspaceId'),
          project: anyNamed('project'),
        )).thenAnswer((_) async => testProject);

        // Act
        await controller.createProject(
          title: 'Test Project',
          description: 'Test Description',
        );

        // Assert
        verify(mockRepository.createProject(
          workspaceId: 'workspace-1',
          project: anyNamed('project'),
        )).called(1);
        expect(controller.projects.length, 1);
        expect(controller.projects.first.title, 'Test Project');
      });

      test('should handle project creation error', () async {
        // Arrange
        when(mockRepository.createProject(
          workspaceId: anyNamed('workspaceId'),
          project: anyNamed('project'),
        )).thenThrow(Exception('Database error'));

        // Act
        await controller.createProject(
          title: 'Test Project',
          description: 'Test Description',
        );

        // Assert
        expect(controller.errorMessage, contains('Database error'));
      });

      test('should validate workspace context', () async {
        // Arrange
        when(mockWorkspaceContext.hasValidWorkspace).thenReturn(false);

        // Act
        await controller.createProject(
          title: 'Test Project',
          description: 'Test Description',
        );

        // Assert
        expect(controller.errorMessage, contains('No valid workspace selected'));
      });
    });

    group('Project Updates', () {
      test('should update project successfully', () async {
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

        final updatedProject = testProject.copyWith(
          title: 'Updated Project',
        );

        when(mockRepository.updateProject(
          workspaceId: anyNamed('workspaceId'),
          project: anyNamed('project'),
        )).thenAnswer((_) async => updatedProject);

        when(mockCalculateProgress.call(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async => ProjectProgressResult(
          isSuccess: true,
          progressPercentage: 50,
          totalTasks: 10,
          completedTasks: 5,
          pendingTasks: 3,
          inProgressTasks: 2,
          cancelledTasks: 0,
        ));

        // Add project to controller
        controller.addProjectForTest(testProject);

        // Act
        await controller.updateProject(updatedProject);

        // Assert
        verify(mockRepository.updateProject(
          workspaceId: 'workspace-1',
          project: anyNamed('project'),
        )).called(1);
        expect(controller.projects.first.title, 'Updated Project');
      });

      test('should handle workspace mismatch', () async {
        // Arrange
        final testProject = Project(
          id: 'project-1',
          title: 'Test Project',
          description: 'Test Description',
          workspaceId: 'workspace-2', // Different workspace
          status: 'pending',
          createdBy: 'user-1',
          createdAt: DateTime.now(),
        );

        controller.addProjectForTest(testProject);

        // Act
        await controller.updateProject(testProject);

        // Assert
        expect(controller.errorMessage, contains('Project does not belong to current workspace'));
      });
    });

    group('Project Deletion', () {
      test('should delete project successfully', () async {
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

        when(mockRepository.deleteProject(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async {});

        controller.addProjectForTest(testProject);

        // Act
        await controller.deleteProject('project-1');

        // Assert
        verify(mockRepository.deleteProject(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
        )).called(1);
        expect(controller.projects.length, 0);
      });

      test('should handle project not found', () async {
        // Arrange
        when(mockRepository.deleteProject(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenThrow(Exception('Project not found'));

        // Act
        await controller.deleteProject('non-existent-project');

        // Assert
        expect(controller.errorMessage, contains('Project not found'));
      });
    });

    group('Project Progress', () {
      test('should calculate project progress', () async {
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
        );

        when(mockCalculateProgress.call(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async => progressResult);

        controller.addProjectForTest(testProject);

        // Act
        await controller.refreshProjects();

        // Assert
        final progress = controller.getProjectProgress('project-1');
        expect(progress, isNotNull);
        expect(progress!.progressPercentage, 75);
        expect(progress.totalTasks, 8);
        expect(progress.completedTasks, 6);
      });

      test('should handle progress calculation error', () async {
        // Arrange
        when(mockCalculateProgress.call(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenThrow(Exception('Progress calculation error'));

        // Act
        await controller.refreshProjects();

        // Assert
        // Should not throw exception, just log error
        expect(controller.projects.length, 0);
      });
    });

    group('Project Search', () {
      test('should search projects successfully', () async {
        // Arrange
        final testProjects = [
          Project(
            id: 'project-1',
            title: 'Test Project 1',
            description: 'Description 1',
            workspaceId: 'workspace-1',
            status: 'pending',
            createdBy: 'user-1',
            createdAt: DateTime.now(),
          ),
          Project(
            id: 'project-2',
            title: 'Test Project 2',
            description: 'Description 2',
            workspaceId: 'workspace-1',
            status: 'pending',
            createdBy: 'user-1',
            createdAt: DateTime.now(),
          ),
        ];

        when(mockRepository.searchProjects(
          workspaceId: anyNamed('workspaceId'),
          query: anyNamed('query'),
        )).thenAnswer((_) async => testProjects);

        // Act
        final results = await controller.searchProjects('Test');

        // Assert
        expect(results.length, 2);
        expect(results.first.title, 'Test Project 1');
      });

      test('should handle search error', () async {
        // Arrange
        when(mockRepository.searchProjects(
          workspaceId: anyNamed('workspaceId'),
          query: anyNamed('query'),
        )).thenThrow(Exception('Search error'));

        // Act & Assert
        expect(
          () => controller.searchProjects('Test'),
          throwsA(isA<ProjectControllerException>()),
        );
      });
    });

    group('Project Statistics', () {
      test('should get project statistics successfully', () async {
        // Arrange
        final statistics = ProjectStatistics(
          totalTasks: 10,
          completedTasks: 7,
          pendingTasks: 2,
          inProgressTasks: 1,
          cancelledTasks: 0,
          overdueTasks: 1,
          completionRate: 0.7,
          lastActivity: DateTime.now(),
        );

        when(mockRepository.getProjectStatistics(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async => statistics);

        // Act
        final result = await controller.getProjectStatistics('project-1');

        // Assert
        expect(result.totalTasks, 10);
        expect(result.completedTasks, 7);
        expect(result.completionRate, 0.7);
      });

      test('should handle statistics error', () async {
        // Arrange
        when(mockRepository.getProjectStatistics(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenThrow(Exception('Statistics error'));

        // Act & Assert
        expect(
          () => controller.getProjectStatistics('project-1'),
          throwsA(isA<ProjectControllerException>()),
        );
      });
    });

    group('Workspace Context', () {
      test('should filter projects by workspace', () async {
        // Arrange
        final projects = [
          Project(
            id: 'project-1',
            title: 'Project 1',
            description: 'Description 1',
            workspaceId: 'workspace-1',
            status: 'pending',
            createdBy: 'user-1',
            createdAt: DateTime.now(),
          ),
          Project(
            id: 'project-2',
            title: 'Project 2',
            description: 'Description 2',
            workspaceId: 'workspace-2', // Different workspace
            status: 'pending',
            createdBy: 'user-1',
            createdAt: DateTime.now(),
          ),
        ];

        controller.addProjectsForTest(projects);

        // Act
        final filteredProjects = controller.projects;

        // Assert
        expect(filteredProjects.length, 1);
        expect(filteredProjects.first.id, 'project-1');
      });
    });
  });
}
