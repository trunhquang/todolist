import 'package:todolist/core/services/firebase_database_service.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';
import 'package:todolist/features/tasks/domain/repositories/project_repository.dart';

/// Concrete implementation of ProjectRepository
/// Follows Clean Architecture - Data layer
class ProjectRepositoryImpl implements ProjectRepository {

  ProjectRepositoryImpl(this._firebaseService);
  final FirebaseDatabaseService _firebaseService;

  @override
  Future<Project?> getProject({
    required String workspaceId,
    required String projectId,
  }) async {
    try {
      return await _firebaseService.getProject(
        workspaceId: workspaceId,
        projectId: projectId,
      );
    } catch (e) {
      throw ProjectRepositoryException('Failed to get project: ${e.toString()}');
    }
  }

  @override
  Future<List<Project>> getProjects({
    required String workspaceId,
    String? status,
  }) async {
    try {
      return await _firebaseService.listProjects(
        workspaceId: workspaceId,
        status: status,
      );
    } catch (e) {
      throw ProjectRepositoryException('Failed to get projects: ${e.toString()}');
    }
  }

  @override
  Future<Project> createProject({
    required String workspaceId,
    required Project project,
  }) async {
    try {
      final projectId = await _firebaseService.createProject(
        workspaceId: workspaceId,
        project: project,
      );
      
      // Return the created project with the generated ID
      return project.copyWith(id: projectId);
    } catch (e) {
      throw ProjectRepositoryException('Failed to create project: ${e.toString()}');
    }
  }

  @override
  Future<Project> updateProject({
    required String workspaceId,
    required Project project,
  }) async {
    try {
      await _firebaseService.updateProject(
        workspaceId: workspaceId,
        project: project,
      );
      
      // Return the updated project
      return project;
    } catch (e) {
      throw ProjectRepositoryException('Failed to update project: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteProject({
    required String workspaceId,
    required String projectId,
  }) async {
    try {
      await _firebaseService.softDeleteProject(
        workspaceId: workspaceId,
        projectId: projectId,
      );
    } catch (e) {
      throw ProjectRepositoryException('Failed to delete project: ${e.toString()}');
    }
  }

  @override
  Future<List<TaskEntity>> getProjectTasks({
    required String workspaceId,
    required String projectId,
  }) async {
    try {
      final allTasks = await _firebaseService.listTasks(
        workspaceId: workspaceId,
      );
      
      // Filter tasks by project ID
      return allTasks.where((task) => task.projectId == projectId).toList();
    } catch (e) {
      throw ProjectRepositoryException('Failed to get project tasks: ${e.toString()}');
    }
  }

  @override
  Future<ProjectStatistics> getProjectStatistics({
    required String workspaceId,
    required String projectId,
  }) async {
    try {
      final tasks = await getProjectTasks(
        workspaceId: workspaceId,
        projectId: projectId,
      );

      final totalTasks = tasks.length;
      final completedTasks = tasks.where((task) => task.status == 'completed').length;
      final pendingTasks = tasks.where((task) => task.status == 'pending').length;
      final inProgressTasks = tasks.where((task) => task.status == 'in_progress').length;
      final cancelledTasks = tasks.where((task) => task.status == 'cancelled').length;
      
      // Calculate overdue tasks
      final now = DateTime.now();
      final overdueTasks = tasks.where((task) {
        if (task.deadline == null || task.status == 'completed' || task.status == 'cancelled') {
          return false;
        }
        return now.isAfter(task.deadline!);
      }).length;

      // Calculate completion rate
      final completionRate = totalTasks > 0 ? (completedTasks / totalTasks) : 0.0;

      // Find last activity (most recent task update)
      DateTime? lastActivity;
      for (final task in tasks) {
        if (task.updatedAt != null) {
          if (lastActivity == null || task.updatedAt!.isAfter(lastActivity)) {
            lastActivity = task.updatedAt;
          }
        }
      }

      return ProjectStatistics(
        totalTasks: totalTasks,
        completedTasks: completedTasks,
        pendingTasks: pendingTasks,
        inProgressTasks: inProgressTasks,
        cancelledTasks: cancelledTasks,
        overdueTasks: overdueTasks,
        completionRate: completionRate,
        lastActivity: lastActivity,
      );
    } catch (e) {
      throw ProjectRepositoryException('Failed to get project statistics: ${e.toString()}');
    }
  }

  @override
  Future<List<Project>> searchProjects({
    required String workspaceId,
    required String query,
    String? status,
  }) async {
    try {
      final allProjects = await getProjects(
        workspaceId: workspaceId,
        status: status,
      );

      // Filter projects by search query
      final queryLower = query.toLowerCase();
      return allProjects.where((project) {
        return project.title.toLowerCase().contains(queryLower) ||
               (project.description?.toLowerCase().contains(queryLower) ?? false);
      }).toList();
    } catch (e) {
      throw ProjectRepositoryException('Failed to search projects: ${e.toString()}');
    }
  }
}

/// Exception for project repository operations
class ProjectRepositoryException implements Exception {

  ProjectRepositoryException(this.message);
  final String message;
  
  @override
  String toString() => 'ProjectRepositoryException: $message';
}
