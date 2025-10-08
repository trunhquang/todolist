import '../entities/task.dart';
import '../entities/project.dart';

/// Repository interface for recurring task operations
/// Follows Clean Architecture - Domain layer
abstract class RecurringTaskRepository {
  /// Get all recurring tasks that need generation
  Future<List<TaskEntity>> getRecurringTasksForGeneration({
    required String companyId,
  });

  /// Get project by ID to check if it's closed
  Future<Project?> getProject({
    required String companyId,
    required String projectId,
  });

  /// Create a new recurring task instance
  Future<String> createRecurringTaskInstance({
    required String companyId,
    required TaskEntity task,
  });

  /// Update the last generation timestamp for a recurring task
  Future<void> updateLastGenerationTime({
    required String companyId,
    required String taskId,
    required DateTime lastGenerated,
  });

  /// Get the last generation time for a recurring task
  Future<DateTime?> getLastGenerationTime({
    required String companyId,
    required String taskId,
  });
}
