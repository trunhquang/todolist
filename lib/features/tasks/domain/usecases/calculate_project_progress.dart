import '../../../../core/constants/task_enums.dart';
import '../entities/project.dart';
import '../entities/task.dart';

/// Use case for calculating project progress
/// Follows Clean Architecture - Domain layer
class CalculateProjectProgress {
  CalculateProjectProgress();

  /// Calculate progress for a specific project
  Future<ProjectProgressResult> call({
    List<TaskEntity>? tasks,
    Project? project,
  }) async {
    if (tasks == null) {
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
    // Calculate progress metrics
    final totalTasks = tasks.length;
    final completedTasks =
        tasks.where((task) => task.status == TaskStatus.completed.value).length;
    final pendingTasks =
        tasks.where((task) => task.status == TaskStatus.pending.value).length;
    final inProgressTasks = tasks
        .where((task) => task.status == TaskStatus.inProgress.value)
        .length;
    final cancelledTasks =
        tasks.where((task) => task.status == TaskStatus.cancelled.value).length;

    // Calculate progress percentage
    final progressPercentage =
        totalTasks > 0 ? (completedTasks / totalTasks * 100).round() : 0;

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
  }

  /// Check if project is overdue
  bool _isProjectOverdue(Project? project, List<TaskEntity> tasks) {
    if (project?.deadline == null || project == null) return false;

    final now = DateTime.now();
    final isDeadlinePassed = now.isAfter(project.deadline!);

    if (!isDeadlinePassed) return false;

    // Check if there are incomplete tasks
    final hasIncompleteTasks = tasks.any((task) =>
        task.status != TaskStatus.completed.value &&
        task.status != TaskStatus.cancelled.value);

    return hasIncompleteTasks;
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
