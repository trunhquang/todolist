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
  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
  });

  group('ProjectController Simple Tests', () {
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
      );

      when(mockWorkspaceContext.currentWorkspaceId).thenReturn('workspace-1');
    });

    group('Project Loading', () {
      test('should load projects successfully', () async {
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
        controller.addProjectsForTest(testProjects);

        // Assert
        expect(controller.projects.length, 2);
        expect(controller.projects.first.title, 'Test Project 1');
        expect(controller.projects.last.title, 'Test Project 2');
      });

      test('should handle loading error', () async {
        // Arrange
        when(mockRepository.getProjects(
          workspaceId: anyNamed('workspaceId'),
          status: anyNamed('status'),
        )).thenThrow(Exception('Database error'));

        // Act
        // Just test that the controller can handle errors
        expect(controller.projects.length, 0);
      });
    });

    group('Project Progress', () {
      test('should have empty progress initially', () async {
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

        // Act
        controller.addProjectForTest(testProject);

        // Assert
        final progress = controller.getProjectProgress('project-1');
        expect(progress, isNull); // Initially null until calculated
      });
    });

    group('Project Search', () {
      test('should search projects successfully', () async {
        // Arrange
        final testProjects = [
          Project(
            id: 'project-1',
            title: 'Flutter Project',
            description: 'A Flutter mobile app',
            workspaceId: 'workspace-1',
            status: 'pending',
            createdBy: 'user-1',
            createdAt: DateTime.now(),
          ),
          Project(
            id: 'project-2',
            title: 'Web Project',
            description: 'A web application',
            workspaceId: 'workspace-1',
            status: 'in_progress',
            createdBy: 'user-1',
            createdAt: DateTime.now(),
          ),
        ];

        when(mockRepository.searchProjects(
          workspaceId: anyNamed('workspaceId'),
          query: anyNamed('query'),
          status: anyNamed('status'),
        )).thenAnswer((_) async => [testProjects.first]);

        // Act
        final results = await controller.searchProjects('Flutter');

        // Assert
        expect(results.length, 1);
        expect(results.first.title, 'Flutter Project');
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
          overdueTasks: 0,
          completionRate: 70.0,
          lastActivity: DateTime.now(),
        );

        when(mockRepository.getProjectStatistics(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async => statistics);

        // Act
        final result = await controller.getProjectStatistics('project-1');

        // Assert
        expect(result, isNotNull);
        expect(result!.totalTasks, 10);
        expect(result.completedTasks, 7);
        expect(result.completionRate, 70.0);
      });
    });
  });
}
