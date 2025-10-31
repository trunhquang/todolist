import 'package:get/get.dart';
import 'package:todolist/core/services/recurring_task_service.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';

class DashboardController extends GetxController {
  final RxList<Map<String, String>> recentTasks = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _checkAndGenerateRecurringTasks();
    _seedSampleTasks();
  }

  String get workspaceTitle {
    final WorkspaceController wsCtrl = Get.find<WorkspaceController>();
    return wsCtrl.currentWorkspace.value?.name ?? '';
  }

  Future<bool> canManageWorkspace() async {
    try {
      final WorkspaceController wsCtrl = Get.find<WorkspaceController>();
      return await wsCtrl.hasPermission('manage_workspace');
    } catch (_) {
      return false;
    }
  }

  Future<void> _checkAndGenerateRecurringTasks() async {
    try {
      final RecurringTaskService recurringTaskService = Get.find<RecurringTaskService>();
      final bool shouldRun = await recurringTaskService.shouldRunGeneration();
      if (shouldRun) {
        await recurringTaskService.generateRecurringTasks();
        await recurringTaskService.markGenerationRun();
      }
    } catch (_) {
      // Silent fail for background generation
    }
  }

  void _seedSampleTasks() {
    // Placeholder sample data until wired with real data source
    recentTasks.assignAll(<Map<String, String>>[
      <String, String>{
        'title': 'Complete project proposal',
        'type': 'Project',
        'status': 'In Progress',
        'priority': 'High',
      },
      <String, String>{
        'title': 'Daily standup meeting',
        'type': 'Daily',
        'status': 'Pending',
        'priority': 'Medium',
      },
      <String, String>{
        'title': 'Weekly team review',
        'type': 'Weekly',
        'status': 'Completed',
        'priority': 'Low',
      },
    ]);
  }
}


