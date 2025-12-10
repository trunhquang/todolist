import '../entities/project.dart';
import '../repositories/project_repository.dart';

/// Summary data for all projects in a workspace.
class WorkspaceProjectsSummary {
  const WorkspaceProjectsSummary({
    required this.totalProjects,
    required this.totalTasks,
    required this.completedTasks,
    required this.overdueProjects,
  });

  final int totalProjects;
  final int totalTasks;
  final int completedTasks;
  final int overdueProjects;
}

/// Use case to calculate aggregated project statistics for a workspace.
class CalculateWorkspaceProjectsSummary {
  CalculateWorkspaceProjectsSummary(this._repository);

  final ProjectRepository _repository;

  Future<WorkspaceProjectsSummary> call({required String workspaceId}) async {
    final projects = await _repository.getProjects(workspaceId: workspaceId);

    var totalTasks = 0;
    var completedTasks = 0;
    var overdueProjects = 0;

    for (final project in projects) {
      final tasks = await _repository.getProjectTasks(
        workspaceId: workspaceId,
        projectId: project.id,
      );

      totalTasks += tasks.length;
      completedTasks +=
          tasks.where((task) => task.status == 'completed').length;

      if (_isProjectOverdue(project, tasks)) {
        overdueProjects++;
      }
    }

    return WorkspaceProjectsSummary(
      totalProjects: projects.length,
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      overdueProjects: overdueProjects,
    );
  }

  bool _isProjectOverdue(Project project, List tasks) {
    if (project.deadline == null) return false;
    final now = DateTime.now();
    final isDeadlinePassed = now.isAfter(project.deadline!);
    if (!isDeadlinePassed) return false;
    final hasIncompleteTasks = tasks.any(
      (task) =>
          task.status != 'completed' &&
          task.status != 'cancelled',
    );
    return hasIncompleteTasks;
  }
}

