import 'package:get/get.dart';

import '../../domain/entities/task.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/recurring_task_repository.dart';
import '../../../../core/services/firebase_database_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/offline_queue_service.dart';

/// Implementation of RecurringTaskRepository
/// Follows Clean Architecture - Data layer
class RecurringTaskRepositoryImpl implements RecurringTaskRepository {
  final FirebaseDatabaseService _databaseService;
  final StorageService _storageService;
  final OfflineQueueService _offlineQueueService;

  RecurringTaskRepositoryImpl({
    FirebaseDatabaseService? databaseService,
    StorageService? storageService,
    OfflineQueueService? offlineQueueService,
  }) : _databaseService = databaseService ?? Get.find<FirebaseDatabaseService>(),
       _storageService = storageService ?? Get.find<StorageService>(),
       _offlineQueueService = offlineQueueService ?? Get.find<OfflineQueueService>();

  @override
  Future<List<TaskEntity>> getRecurringTasksForGeneration({
    required String companyId,
  }) async {
    try {
      // Get all tasks for the company
      final allTasks = await _databaseService.listTasks(companyId: companyId);
      
      // Filter for recurring tasks that are not instances (no parentTaskId)
      final recurringTasks = allTasks.where((task) {
        return task.recurring.isRecurring &&
               task.parentTaskId == null &&
               task.deletedAt == null;
      }).toList();

      return recurringTasks;
    } catch (e) {
      throw Exception('Failed to get recurring tasks: $e');
    }
  }

  @override
  Future<Project?> getProject({
    required String companyId,
    required String projectId,
  }) async {
    try {
      return await _databaseService.getProject(
        companyId: companyId,
        projectId: projectId,
      );
    } catch (e) {
      throw Exception('Failed to get project: $e');
    }
  }

  @override
  Future<String> createRecurringTaskInstance({
    required String companyId,
    required TaskEntity task,
  }) async {
    try {
      // Use offline queue service for offline support
      await _offlineQueueService.createRecurringTask(
        companyId: companyId,
        task: task,
      );
      
      // Return a temporary ID for the task
      // The actual ID will be set by Firebase when the task is created
      return 'temp_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      throw Exception('Failed to create recurring task instance: $e');
    }
  }

  @override
  Future<void> updateLastGenerationTime({
    required String companyId,
    required String taskId,
    required DateTime lastGenerated,
  }) async {
    try {
      // Store in local storage for now
      // In a production app, this could be stored in Firebase or a separate service
      await _storageService.setUserData(
        'last_generation_${taskId}',
        lastGenerated.millisecondsSinceEpoch,
      );
    } catch (e) {
      throw Exception('Failed to update last generation time: $e');
    }
  }

  @override
  Future<DateTime?> getLastGenerationTime({
    required String companyId,
    required String taskId,
  }) async {
    try {
      final timestamp = _storageService.getUserData<int>('last_generation_${taskId}');
      if (timestamp == null) return null;
      
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      throw Exception('Failed to get last generation time: $e');
    }
  }
}
