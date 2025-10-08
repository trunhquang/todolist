import 'package:get/get.dart';

import '../../../../core/services/recurring_task_service.dart';
import '../../domain/usecases/generate_recurring_tasks.dart';

/// Controller for managing recurring task generation
/// Follows Clean Architecture - Presentation layer
class RecurringTaskController extends GetxController {
  final RecurringTaskService _recurringTaskService;

  RecurringTaskController({
    RecurringTaskService? recurringTaskService,
  }) : _recurringTaskService = recurringTaskService ?? Get.find<RecurringTaskService>();

  // Private observables
  final _isGenerating = false.obs;
  final _lastGenerationResult = Rxn<RecurringGenerationResult>();
  final _generationStats = Rxn<GenerationStats>();

  // Public getters
  bool get isGenerating => _isGenerating.value;
  RecurringGenerationResult? get lastGenerationResult => _lastGenerationResult.value;
  GenerationStats? get generationStats => _generationStats.value;

  @override
  void onInit() {
    super.onInit();
    _loadGenerationStats();
  }

  /// Generate recurring tasks
  Future<void> generateRecurringTasks() async {
    if (_isGenerating.value) return;

    try {
      _isGenerating.value = true;
      
      final result = await _recurringTaskService.generateRecurringTasks();
      _lastGenerationResult.value = result;
      
      if (result.isSuccess) {
        await _recurringTaskService.markGenerationRun();
        await _loadGenerationStats();
        
        Get.snackbar(
          'Recurring Tasks Generated',
          'Generated ${result.totalGenerated} new task instances',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Generation Failed',
          result.error ?? 'Unknown error occurred',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Generation Error',
        'Failed to generate recurring tasks: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isGenerating.value = false;
    }
  }

  /// Force generate recurring tasks (for testing)
  Future<void> forceGenerateRecurringTasks() async {
    if (_isGenerating.value) return;

    try {
      _isGenerating.value = true;
      
      final result = await _recurringTaskService.forceGenerateRecurringTasks();
      _lastGenerationResult.value = result;
      
      if (result.isSuccess) {
        await _loadGenerationStats();
        
        Get.snackbar(
          'Recurring Tasks Generated',
          'Force generated ${result.totalGenerated} new task instances',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Force Generation Failed',
          result.error ?? 'Unknown error occurred',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Force Generation Error',
        'Failed to force generate recurring tasks: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isGenerating.value = false;
    }
  }

  /// Check if generation should run and run it if needed
  Future<void> checkAndGenerateIfNeeded() async {
    try {
      final shouldRun = await _recurringTaskService.shouldRunGeneration();
      if (shouldRun) {
        await generateRecurringTasks();
      }
    } catch (e) {
      // Silent fail for background checks
      print('Background generation check failed: $e');
    }
  }

  /// Load generation statistics
  Future<void> _loadGenerationStats() async {
    try {
      final stats = await _recurringTaskService.getGenerationStats();
      _generationStats.value = stats;
    } catch (e) {
      print('Failed to load generation stats: $e');
    }
  }

  /// Refresh generation statistics
  Future<void> refreshStats() async {
    await _loadGenerationStats();
  }

  /// Get formatted last generation time
  String? get formattedLastGenerationTime {
    final stats = _generationStats.value;
    if (stats?.lastGenerationTime == null) return null;
    
    final time = stats!.lastGenerationTime!;
    return '${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Get formatted next scheduled generation time
  String? get formattedNextScheduledGeneration {
    final stats = _generationStats.value;
    if (stats?.nextScheduledGeneration == null) return null;
    
    final time = stats!.nextScheduledGeneration!;
    return '${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Check if generation is overdue
  bool get isGenerationOverdue {
    final stats = _generationStats.value;
    if (stats?.nextScheduledGeneration == null) return false;
    
    return DateTime.now().isAfter(stats!.nextScheduledGeneration!);
  }
}
