import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';
import 'package:todolist/features/tasks/domain/repositories/project_repository.dart';
import 'package:todolist/features/tasks/domain/usecases/calculate_project_progress.dart';

import 'calculate_project_progress_test.mocks.dart';

@GenerateMocks([ProjectRepository])
void main() {
  group('CalculateProjectProgress', () {
    late MockProjectRepository mockRepository;
    late CalculateProjectProgress useCase;

    setUp(() {
      mockRepository = MockProjectRepository();
      useCase = CalculateProjectProgress(mockRepository);
    });

    group('Project Progress Calculation', () {
      test('should calculate progress successfully', () async {
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

        final testTasks = [
          TaskEntity(
            id: 'task-1',
            title: 'Task 1',
            workspaceId: 'workspace-1',
            taskType: 'daily',
            priority: 'medium',
            status: 'completed',
            assigner: 'user-1',
            hasDeadline: false,
            recurring: const RecurringConfig(isRecurring: false),
            createdAt: DateTime.now(),
            projectId: 'project-1',
          ),
          TaskEntity(
            id: 'task-2',
            title: 'Task 2',
            workspaceId: 'workspace-1',
            taskType: 'daily',
            priority: 'medium',
            status: 'pending',
            assigner: 'user-1',
            hasDeadline: false,
            recurring: const RecurringConfig(isRecurring: false),
            createdAt: DateTime.now(),
            projectId: 'project-1',
          ),
          TaskEntity(
            id: 'task-3',
            title: 'Task 3',
            workspaceId: 'workspace-1',
            taskType: 'daily',
            priority: 'medium',
            status: 'in_progress',
            assigner: 'user-1',
            hasDeadline: false,
            recurring: const RecurringConfig(isRecurring: false),
            createdAt: DateTime.now(),
            projectId: 'project-1',
          ),
        ];

        when(mockRepository.getProject(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async => testProject);

        when(mockRepository.getProjectTasks(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async => testTasks);

        // Act
        final result = await useCase.call(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
        );

        // Assert
        expect(result.isSuccess, true);
        expect(result.progressPercentage, 33); // 1 completed out of 3 total
        expect(result.totalTasks, 3);
        expect(result.completedTasks, 1);
        expect(result.pendingTasks, 1);
        expect(result.inProgressTasks, 1);
        expect(result.cancelledTasks, 0);
        expect(result.isCompleted, false);
        expect(result.isOverdue, false);
      });

      test('should handle project not found', () async {
        // Arrange
        when(mockRepository.getProject(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async => null);

        // Act
        final result = await useCase.call(
          workspaceId: 'workspace-1',
          projectId: 'non-existent-project',
        );

        // Assert
        expect(result.isSuccess, false);
        expect(result.error, 'Project not found');
        expect(result.progressPercentage, 0);
      });

      test('should handle repository error', () async {
        // Arrange
        when(mockRepository.getProject(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenThrow(Exception('Database error'));

        // Act
        final result = await useCase.call(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
        );

        // Assert
        expect(result.isSuccess, false);
        expect(result.error, contains('Database error'));
      });

      test('should calculate 100% progress for completed project', () async {
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

        final testTasks = [
          TaskEntity(
            id: 'task-1',
            title: 'Task 1',
            workspaceId: 'workspace-1',
            taskType: 'daily',
            priority: 'medium',
            status: 'completed',
            assigner: 'user-1',
            hasDeadline: false,
            recurring: const RecurringConfig(isRecurring: false),
            createdAt: DateTime.now(),
            projectId: 'project-1',
          ),
          TaskEntity(
            id: 'task-2',
            title: 'Task 2',
            workspaceId: 'workspace-1',
            taskType: 'daily',
            priority: 'medium',
            status: 'completed',
            assigner: 'user-1',
            hasDeadline: false,
            recurring: const RecurringConfig(isRecurring: false),
            createdAt: DateTime.now(),
            projectId: 'project-1',
          ),
        ];

        when(mockRepository.getProject(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async => testProject);

        when(mockRepository.getProjectTasks(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async => testTasks);

        // Act
        final result = await useCase.call(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
        );

        // Assert
        expect(result.isSuccess, true);
        expect(result.progressPercentage, 100);
        expect(result.isCompleted, true);
      });

      test('should detect overdue project', () async {
        // Arrange
        final testProject = Project(
          id: 'project-1',
          title: 'Test Project',
          description: 'Test Description',
          workspaceId: 'workspace-1',
          status: 'pending',
          createdBy: 'user-1',
          createdAt: DateTime.now(),
          deadline: DateTime.now().subtract(const Duration(days: 1)), // Overdue
        );

        final testTasks = [
          TaskEntity(
            id: 'task-1',
            title: 'Task 1',
            workspaceId: 'workspace-1',
            taskType: 'daily',
            priority: 'medium',
            status: 'pending', // Incomplete task
            assigner: 'user-1',
            hasDeadline: false,
            recurring: const RecurringConfig(isRecurring: false),
            createdAt: DateTime.now(),
            projectId: 'project-1',
          ),
        ];

        when(mockRepository.getProject(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async => testProject);

        when(mockRepository.getProjectTasks(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async => testTasks);

        // Act
        final result = await useCase.call(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
        );

        // Assert
        expect(result.isSuccess, true);
        expect(result.isOverdue, true);
      });
    });

    group('Multiple Projects Progress', () {
      test('should calculate progress for multiple projects', () async {
        // Arrange
        final projectIds = ['project-1', 'project-2'];
        
        final testProject1 = Project(
          id: 'project-1',
          title: 'Project 1',
          description: 'Description 1',
          workspaceId: 'workspace-1',
          status: 'pending',
          createdBy: 'user-1',
          createdAt: DateTime.now(),
        );

        final testProject2 = Project(
          id: 'project-2',
          title: 'Project 2',
          description: 'Description 2',
          workspaceId: 'workspace-1',
          status: 'pending',
          createdBy: 'user-1',
          createdAt: DateTime.now(),
        );

        when(mockRepository.getProject(
          workspaceId: anyNamed('workspaceId'),
          projectId: 'project-1',
        )).thenAnswer((_) async => testProject1);

        when(mockRepository.getProject(
          workspaceId: anyNamed('workspaceId'),
          projectId: 'project-2',
        )).thenAnswer((_) async => testProject2);

        when(mockRepository.getProjectTasks(
          workspaceId: anyNamed('workspaceId'),
          projectId: 'project-1',
        )).thenAnswer((_) async => []);

        when(mockRepository.getProjectTasks(
          workspaceId: anyNamed('workspaceId'),
          projectId: 'project-2',
        )).thenAnswer((_) async => []);

        // Act
        final results = await useCase.callForMultiple(
          workspaceId: 'workspace-1',
          projectIds: projectIds,
        );

        // Assert
        expect(results.length, 2);
        expect(results[0].isSuccess, true);
        expect(results[1].isSuccess, true);
      });
    });

    group('Progress Summary', () {
      test('should calculate progress summary', () async {
        // Arrange
        final testProjects = [
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
            workspaceId: 'workspace-1',
            status: 'pending',
            createdBy: 'user-1',
            createdAt: DateTime.now(),
          ),
        ];

        when(mockRepository.getProjects(
          workspaceId: anyNamed('workspaceId'),
        )).thenAnswer((_) async => testProjects);

        // Mock progress calculation for each project
        when(mockRepository.getProject(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async => testProjects.first);

        when(mockRepository.getProjectTasks(
          workspaceId: anyNamed('workspaceId'),
          projectId: anyNamed('projectId'),
        )).thenAnswer((_) async => []);

        // Act
        final summary = await useCase.getProgressSummary(
          workspaceId: 'workspace-1',
        );

        // Assert
        expect(summary.isSuccess, true);
        expect(summary.totalProjects, 2);
        expect(summary.completedProjects, 0);
        expect(summary.overdueProjects, 0);
        expect(summary.totalTasks, 0);
        expect(summary.completedTasks, 0);
        expect(summary.overallProgress, 0);
      });

      test('should handle summary calculation error', () async {
        // Arrange
        when(mockRepository.getProjects(
          workspaceId: anyNamed('workspaceId'),
        )).thenThrow(Exception('Database error'));

        // Act
        final summary = await useCase.getProgressSummary(
          workspaceId: 'workspace-1',
        );

        // Assert
        expect(summary.isSuccess, false);
        expect(summary.error, contains('Database error'));
      });
    });
  });
}
