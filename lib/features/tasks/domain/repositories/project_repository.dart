import 'dart:async';

import '../entities/project.dart';
import '../entities/project_status.dart';
import '../entities/task.dart';

/// Abstract repository interface for project operations
/// Follows Clean Architecture - Domain layer
abstract class ProjectRepository {
  /// Get a specific project
  Future<Project?> getProject({
    required String workspaceId,
    required String projectId,
  });

  /// Get all projects in a workspace
  Future<List<Project>> getProjects({
    required String workspaceId,
    ProjectStatus? status,
  });

  /// Create a new project
  Future<Project> createProject({
    required String workspaceId,
    required Project project,
  });

  /// Update an existing project
  Future<Project> updateProject({
    required String workspaceId,
    required Project project,
  });

  /// Add a member to project
  Future<Project> addMember({
    required String workspaceId,
    required String projectId,
    required String userId,
  });

  /// Remove a member from project
  Future<Project> removeMember({
    required String workspaceId,
    required String projectId,
    required String userId,
  });

  /// Delete a project (soft delete)
  Future<void> deleteProject({
    required String workspaceId,
    required String projectId,
  });

  /// Get all tasks for a specific project
  Future<List<TaskEntity>> getProjectTasks({
    required String workspaceId,
    required String projectId,
  });

  /// Get project statistics
  Future<ProjectStatistics> getProjectStatistics({
    required String workspaceId,
    required String projectId,
  });

  /// Search projects
  Future<List<Project>> searchProjects({
    required String workspaceId,
    required String query,
    ProjectStatus? status,
  });
}

/// Project statistics data
class ProjectStatistics {

  ProjectStatistics({
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.inProgressTasks,
    required this.cancelledTasks,
    required this.overdueTasks,
    required this.completionRate,
    this.lastActivity,
  });
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int inProgressTasks;
  final int cancelledTasks;
  final int overdueTasks;
  final double completionRate;
  final DateTime? lastActivity;
}
