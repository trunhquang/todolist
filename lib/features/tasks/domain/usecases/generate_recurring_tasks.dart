import '../entities/task.dart';
import '../repositories/recurring_task_repository.dart';

/// Use case for generating recurring task instances
/// Follows Clean Architecture - Domain layer
class GenerateRecurringTasks {

  GenerateRecurringTasks(this._repository);
  final RecurringTaskRepository _repository;

  /// Generate recurring task instances for all eligible tasks
  Future<RecurringGenerationResult> call({
    required String workspaceId,
  }) async {
    try {
      final recurringTasks = await _repository.getRecurringTasksForGeneration(
        workspaceId: workspaceId,
      );

      final results = <TaskGenerationResult>[];
      var generatedCount = 0;
      var skippedCount = 0;

      for (final task in recurringTasks) {
        final result = await _generateTaskInstances(
          workspaceId: workspaceId,
          parentTask: task,
        );
        
        results.add(result);
        if (result.isSuccess) {
          generatedCount += result.generatedInstances;
        } else {
          skippedCount++;
        }
      }

      return RecurringGenerationResult(
        isSuccess: true,
        totalGenerated: generatedCount,
        totalSkipped: skippedCount,
        results: results,
      );
    } catch (e) {
      return RecurringGenerationResult(
        isSuccess: false,
        error: e.toString(),
        totalGenerated: 0,
        totalSkipped: 0,
        results: [],
      );
    }
  }

  /// Generate instances for a specific recurring task
  Future<TaskGenerationResult> _generateTaskInstances({
    required String workspaceId,
    required TaskEntity parentTask,
  }) async {
    try {
      // Check if project is closed (if task is linked to a project)
      if (parentTask.projectId != null) {
        final project = await _repository.getProject(
          workspaceId: workspaceId,
          projectId: parentTask.projectId!,
        );
        
        if (project == null || project.status == 'closed') {
          return TaskGenerationResult(
            taskId: parentTask.id,
            isSuccess: false,
            reason: 'Project is closed',
            generatedInstances: 0,
          );
        }
      }

      // Check if task is cancelled
      if (parentTask.status == 'cancelled') {
        return TaskGenerationResult(
          taskId: parentTask.id,
          isSuccess: false,
          reason: 'Parent task is cancelled',
          generatedInstances: 0,
        );
      }

      // Check if end date has passed
      if (parentTask.recurring.endDate != null &&
          DateTime.now().isAfter(parentTask.recurring.endDate!)) {
        return TaskGenerationResult(
          taskId: parentTask.id,
          isSuccess: false,
          reason: 'Recurring end date has passed',
          generatedInstances: 0,
        );
      }

      // Get last generation time
      final lastGenerated = await _repository.getLastGenerationTime(
        workspaceId: workspaceId,
        taskId: parentTask.id,
      );

      // Calculate how many instances to generate
      final instancesToGenerate = _calculateInstancesToGenerate(
        parentTask: parentTask,
        lastGenerated: lastGenerated,
      );

      if (instancesToGenerate == 0) {
        return TaskGenerationResult(
          taskId: parentTask.id,
          isSuccess: true,
          reason: 'No instances needed',
          generatedInstances: 0,
        );
      }

      // Generate instances
      var generatedCount = 0;
      for (var i = 0; i < instancesToGenerate; i++) {
        final instanceDate = calculateNextInstanceDate(
          parentTask: parentTask,
          lastGenerated: lastGenerated,
          instanceIndex: i,
        );

        final instance = createTaskInstance(
          parentTask: parentTask,
          instanceDate: instanceDate,
        );

        await _repository.createRecurringTaskInstance(
          workspaceId: workspaceId,
          task: instance,
        );
        generatedCount++;
      }

      // Update last generation time
      await _repository.updateLastGenerationTime(
        workspaceId: workspaceId,
        taskId: parentTask.id,
        lastGenerated: DateTime.now(),
      );

      return TaskGenerationResult(
        taskId: parentTask.id,
        isSuccess: true,
        reason: 'Generated $generatedCount instances',
        generatedInstances: generatedCount,
      );
    } catch (e) {
      return TaskGenerationResult(
        taskId: parentTask.id,
        isSuccess: false,
        reason: 'Error: $e',
        generatedInstances: 0,
      );
    }
  }

  /// Calculate how many instances need to be generated
  int _calculateInstancesToGenerate({
    required TaskEntity parentTask,
    DateTime? lastGenerated,
  }) {
    final now = DateTime.now();
    final startDate = lastGenerated ?? parentTask.createdAt;
    final endDate = parentTask.recurring.endDate ?? now;

    if (startDate.isAfter(endDate)) {
      return 0;
    }

    final frequency = parentTask.recurring.frequency!;
    final interval = parentTask.recurring.interval ?? 1;

    switch (frequency) {
      case 'daily':
        return calculateDailyInstances(startDate, endDate, interval);
      case 'weekly':
        return calculateWeeklyInstances(startDate, endDate, interval);
      case 'monthly':
        return calculateMonthlyInstances(startDate, endDate, interval);
      default:
        return 0;
    }
  }

  int calculateDailyInstances(DateTime start, DateTime end, int interval) {
    final daysDiff = end.difference(start).inDays;
    return (daysDiff / interval).floor();
  }

  int calculateWeeklyInstances(DateTime start, DateTime end, int interval) {
    final weeksDiff = end.difference(start).inDays / 7;
    return (weeksDiff / interval).floor();
  }

  int calculateMonthlyInstances(DateTime start, DateTime end, int interval) {
    final monthsDiff = (end.year - start.year) * 12 + (end.month - start.month);
    return (monthsDiff / interval).floor();
  }

  /// Calculate the date for the next instance
  DateTime calculateNextInstanceDate({
    required TaskEntity parentTask,
    DateTime? lastGenerated,
    required int instanceIndex,
  }) {
    final baseDate = lastGenerated ?? parentTask.createdAt;
    final frequency = parentTask.recurring.frequency!;
    final interval = parentTask.recurring.interval ?? 1;
    final multiplier = instanceIndex + 1;

    switch (frequency) {
      case 'daily':
        return baseDate.add(Duration(days: interval * multiplier));
      case 'weekly':
        return baseDate.add(Duration(days: 7 * interval * multiplier));
      case 'monthly':
        final newDate = DateTime(baseDate.year, baseDate.month, baseDate.day);
        return DateTime(
          newDate.year,
          newDate.month + (interval * multiplier),
          newDate.day,
        );
      default:
        return baseDate;
    }
  }

  /// Create a new task instance from parent task
  TaskEntity createTaskInstance({
    required TaskEntity parentTask,
    required DateTime instanceDate,
  }) {
    // Calculate deadline for the instance
    DateTime? instanceDeadline;
    if (parentTask.hasDeadline && parentTask.deadline != null) {
      final originalDeadline = parentTask.deadline!;
      final daysDiff = originalDeadline.difference(parentTask.createdAt).inDays;
      instanceDeadline = instanceDate.add(Duration(days: daysDiff));
    }

    return parentTask.copyWith(
      id: '', // Will be set by the repository
      parentTaskId: parentTask.id,
      status: 'pending',
      deadline: instanceDeadline,
      createdAt: instanceDate,
      // Reset recurring config for instances
      recurring: const RecurringConfig(isRecurring: false),
    );
  }
}

/// Result of recurring task generation
class RecurringGenerationResult {

  RecurringGenerationResult({
    required this.isSuccess,
    this.error,
    required this.totalGenerated,
    required this.totalSkipped,
    required this.results,
  });
  final bool isSuccess;
  final String? error;
  final int totalGenerated;
  final int totalSkipped;
  final List<TaskGenerationResult> results;
}

/// Result of generating instances for a specific task
class TaskGenerationResult {

  TaskGenerationResult({
    required this.taskId,
    required this.isSuccess,
    required this.reason,
    required this.generatedInstances,
  });
  final String taskId;
  final bool isSuccess;
  final String reason;
  final int generatedInstances;
}
