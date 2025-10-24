import 'package:get/get.dart';

import '../../features/tasks/domain/usecases/generate_recurring_tasks.dart';
import '../../features/tasks/data/repositories/recurring_task_repository_impl.dart';
import 'storage_service.dart';

/// Service for managing recurring task generation
/// Follows Clean Architecture - Service layer
class RecurringTaskService extends GetxService {
  static RecurringTaskService get instance => Get.find<RecurringTaskService>();
  
  late GenerateRecurringTasks _generateRecurringTasks;
  late StorageService _storageService;

  @override
  Future<void> onInit() async {
    super.onInit();
    _storageService = Get.find<StorageService>();
    
    // Initialize the use case with repository implementation
    final repository = RecurringTaskRepositoryImpl();
    _generateRecurringTasks = GenerateRecurringTasks(repository);
  }

  /// Generate recurring tasks for the current company
  Future<RecurringGenerationResult> generateRecurringTasks() async {
    try {
      final workspaceId = _storageService.getWorkspaceId();
      if (workspaceId == null || workspaceId.isEmpty) {
        return RecurringGenerationResult(
          isSuccess: false,
          error: 'No company ID found',
          totalGenerated: 0,
          totalSkipped: 0,
          results: [],
        );
      }

      return await _generateRecurringTasks(workspaceId: workspaceId);
    } catch (e) {
      return RecurringGenerationResult(
        isSuccess: false,
        error: 'Failed to generate recurring tasks: $e',
        totalGenerated: 0,
        totalSkipped: 0,
        results: [],
      );
    }
  }

  /// Check if recurring task generation should run
  /// This prevents running generation too frequently
  Future<bool> shouldRunGeneration() async {
    try {
      final lastRun = _storageService.getUserData<int>('last_recurring_generation');
      if (lastRun == null) return true;

      final lastRunTime = DateTime.fromMillisecondsSinceEpoch(lastRun);
      final now = DateTime.now();
      
      // Run generation at most once per hour
      return now.difference(lastRunTime).inHours >= 1;
    } catch (e) {
      // If there's an error, allow generation to run
      return true;
    }
  }

  /// Mark that generation has been run
  Future<void> markGenerationRun() async {
    try {
      await _storageService.setUserData(
        'last_recurring_generation',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      // Log error but don't throw
      print('Failed to mark generation run: $e');
    }
  }

  /// Force generation to run (for testing or manual triggers)
  Future<RecurringGenerationResult> forceGenerateRecurringTasks() async {
    try {
      final result = await generateRecurringTasks();
      await markGenerationRun();
      return result;
    } catch (e) {
      return RecurringGenerationResult(
        isSuccess: false,
        error: 'Failed to force generate recurring tasks: $e',
        totalGenerated: 0,
        totalSkipped: 0,
        results: [],
      );
    }
  }

  /// Get generation statistics
  Future<GenerationStats> getGenerationStats() async {
    try {
      final workspaceId = _storageService.getWorkspaceId();
      if (workspaceId == null || workspaceId.isEmpty) {
        return GenerationStats(
          totalRecurringTasks: 0,
          lastGenerationTime: null,
          nextScheduledGeneration: null,
        );
      }

      final repository = RecurringTaskRepositoryImpl();
      final recurringTasks = await repository.getRecurringTasksForGeneration(
        workspaceId: workspaceId,
      );

      final lastRun = _storageService.getUserData<int>('last_recurring_generation');
      DateTime? lastGenerationTime;
      DateTime? nextScheduledGeneration;

      if (lastRun != null) {
        lastGenerationTime = DateTime.fromMillisecondsSinceEpoch(lastRun);
        nextScheduledGeneration = lastGenerationTime.add(const Duration(hours: 1));
      }

      return GenerationStats(
        totalRecurringTasks: recurringTasks.length,
        lastGenerationTime: lastGenerationTime,
        nextScheduledGeneration: nextScheduledGeneration,
      );
    } catch (e) {
      return GenerationStats(
        totalRecurringTasks: 0,
        lastGenerationTime: null,
        nextScheduledGeneration: null,
      );
    }
  }
}

/// Statistics about recurring task generation
class GenerationStats {
  final int totalRecurringTasks;
  final DateTime? lastGenerationTime;
  final DateTime? nextScheduledGeneration;

  GenerationStats({
    required this.totalRecurringTasks,
    this.lastGenerationTime,
    this.nextScheduledGeneration,
  });
}
