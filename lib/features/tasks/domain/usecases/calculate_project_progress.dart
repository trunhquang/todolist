import '../entities/project.dart';
import '../entities/task.dart';
import '../repositories/project_repository.dart';

/// Use case for calculating project progress
/// Follows Clean Architecture - Domain layer
class CalculateProjectProgress {

  CalculateProjectProgress(this._repository);
  final ProjectRepository _repository;

  /// Calculate progress for a specific project
  Future<ProjectProgressResult> call({
    required String workspaceId,
    required String projectId,
  }) async {
    try {
      // Get project details
      final project = await _repository.getProject(
        workspaceId: workspaceId,
        projectId: projectId,
      );

      if (project == null) {
        return ProjectProgressResult(
          isSuccess: false,
          error: 'Project not found',
          progressPercentage: 0,
          totalTasks: 0,
          completedTasks: 0,
          pendingTasks: 0,
          inProgressTasks: 0,
          cancelledTasks: 0,
        );
      }

      // Get all tasks for this project
      final tasks = await _repository.getProjectTasks(
        workspaceId: workspaceId,
        projectId: projectId,
      );

      // Calculate progress metrics
      final totalTasks = tasks.length;
      final completedTasks = tasks.where((task) => task.status == 'completed').length;
      final pendingTasks = tasks.where((task) => task.status == 'pending').length;
      final inProgressTasks = tasks.where((task) => task.status == 'in_progress').length;
      final cancelledTasks = tasks.where((task) => task.status == 'cancelled').length;

      // Calculate progress percentage
      final progressPercentage = totalTasks > 0 
          ? (completedTasks / totalTasks * 100).round()
          : 0;

      // Calculate completion status
      final isCompleted = progressPercentage == 100;
      final isOverdue = _isProjectOverdue(project, tasks);

      return ProjectProgressResult(
        isSuccess: true,
        progressPercentage: progressPercentage,
        totalTasks: totalTasks,
        completedTasks: completedTasks,
        pendingTasks: pendingTasks,
        inProgressTasks: inProgressTasks,
        cancelledTasks: cancelledTasks,
        isCompleted: isCompleted,
        isOverdue: isOverdue,
        project: project,
        tasks: tasks,
      );
    } catch (e) {
      return ProjectProgressResult(
        isSuccess: false,
        error: e.toString(),
        progressPercentage: 0,
        totalTasks: 0,
        completedTasks: 0,
        pendingTasks: 0,
        inProgressTasks: 0,
        cancelledTasks: 0,
      );
    }
  }

  /// Calculate progress for multiple projects
  Future<List<ProjectProgressResult>> callForMultiple({
    required String workspaceId,
    required List<String> projectIds,
  }) async {
    final results = <ProjectProgressResult>[];
    
    for (final projectId in projectIds) {
      final result = await call(
        workspaceId: workspaceId,
        projectId: projectId,
      );
      results.add(result);
    }
    
    return results;
  }

  /// Check if project is overdue
  bool _isProjectOverdue(Project project, List<TaskEntity> tasks) {
    if (project.deadline == null) return false;
    
    final now = DateTime.now();
    final isDeadlinePassed = now.isAfter(project.deadline!);
    
    if (!isDeadlinePassed) return false;
    
    // Check if there are incomplete tasks
    final hasIncompleteTasks = tasks.any((task) => 
        task.status != 'completed' && task.status != 'cancelled');
    
    return hasIncompleteTasks;
  }

  /// Get project progress summary
  Future<ProjectProgressSummary> getProgressSummary({
    required String workspaceId,
  }) async {
    try {
      // Get all projects in workspace
      final projects = await _repository.getProjects(workspaceId: workspaceId);
      
      int totalProjects = projects.length;
      int completedProjects = 0;
      int overdueProjects = 0;
      int totalTasks = 0;
      int completedTasks = 0;
      
      // Calculate summary for each project
      for (final project in projects) {
        final progress = await call(
          workspaceId: workspaceId,
          projectId: project.id,
        );
        
        if (progress.isSuccess) {
          if (progress.isCompleted) completedProjects++;
          if (progress.isOverdue) overdueProjects++;
          
          totalTasks += progress.totalTasks;
          completedTasks += progress.completedTasks;
        }
      }
      
      // Calculate overall progress
      final overallProgress = totalTasks > 0 
          ? (completedTasks / totalTasks * 100).round()
          : 0;
      
      return ProjectProgressSummary(
        isSuccess: true,
        totalProjects: totalProjects,
        completedProjects: completedProjects,
        overdueProjects: overdueProjects,
        totalTasks: totalTasks,
        completedTasks: completedTasks,
        overallProgress: overallProgress,
      );
    } catch (e) {
      return ProjectProgressSummary(
        isSuccess: false,
        error: e.toString(),
        totalProjects: 0,
        completedProjects: 0,
        overdueProjects: 0,
        totalTasks: 0,
        completedTasks: 0,
        overallProgress: 0,
      );
    }
  }
}

/// Result of project progress calculation
class ProjectProgressResult {

  ProjectProgressResult({
    required this.isSuccess,
    this.error,
    required this.progressPercentage,
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.inProgressTasks,
    required this.cancelledTasks,
    this.isCompleted = false,
    this.isOverdue = false,
    this.project,
    this.tasks,
  });
  final bool isSuccess;
  final String? error;
  final int progressPercentage;
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int inProgressTasks;
  final int cancelledTasks;
  final bool isCompleted;
  final bool isOverdue;
  final Project? project;
  final List<TaskEntity>? tasks;
}

/// Summary of all projects progress
class ProjectProgressSummary {

  ProjectProgressSummary({
    required this.isSuccess,
    this.error,
    required this.totalProjects,
    required this.completedProjects,
    required this.overdueProjects,
    required this.totalTasks,
    required this.completedTasks,
    required this.overallProgress,
  });
  final bool isSuccess;
  final String? error;
  final int totalProjects;
  final int completedProjects;
  final int overdueProjects;
  final int totalTasks;
  final int completedTasks;
  final int overallProgress;
}
