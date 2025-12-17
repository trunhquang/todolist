import 'dart:async';

import 'package:get/get.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/backend/api_gateway.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';

import '../../../../core/backend/api_gateway_impl.dart';


class DashboardController extends GetxController {
  DashboardController({BackendLayerInterface? apiGateway})
      : _apiGateway = apiGateway ?? Get.find<ApiGatewayImpl>();

  final BackendLayerInterface _apiGateway;


  final RxList<TaskEntity> recentTasks = <TaskEntity>[].obs;

  /// Loading state for reload action
  final RxBool isReloadingTasks = false.obs;

  // --- LOGIC TÍNH TOÁN THỐNG KÊ (Computed Properties) ---

  /// 1. Thống kê theo Trạng thái (Bao gồm logic Overdue)
  Map<String, int> get statusCounts {
    final counts = <String, int>{};
    final now = DateTime.now();

    for (final task in recentTasks) {
      String status = task.status;

      // -- LOGIC CHECK TRỄ HẠN --
      final isDone = ['completed', 'cancelled', 'done'].contains(status.toLowerCase());
      final dueDateTime = task.deadline;

      // Nếu quá hạn -> Đổi status thành 'Overdue'
      if (!isDone && dueDateTime != null && dueDateTime.isBefore(now)) {
        status = 'Overdue';
      }
      // --------------------------

      counts[status] = (counts[status] ?? 0) + 1;
    }
    return counts;
  }

  /// 2. Thống kê theo Mức độ ưu tiên
  Map<String, int> get priorityCounts {
    final counts = <String, int>{};
    for (final task in recentTasks) {
      final priority = task.priority;
      counts[priority] = (counts[priority] ?? 0) + 1;
    }
    return counts;
  }

  /// 3. Thống kê theo Loại dự án
  Map<String, int> get projectCounts {
    final counts = <String, int>{};
    for (final task in recentTasks) {
      final type = task.taskType;
      counts[type] = (counts[type] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadRecentTasks();

    // Listen to workspace changes
    final wsCtrl = Get.find<WorkspaceController>();
    ever(wsCtrl.currentWorkspace, (_) => _loadRecentTasks());
  }


  String get workspaceTitle {
    final wsCtrl = Get.find<WorkspaceController>();
    final currentName = wsCtrl.currentWorkspace.value?.name;
    if (currentName == null || currentName.isEmpty) {
      return AppStrings.I.overview;
    }
    return currentName;
  }

  String get workspaceRoleLabel {
    final wsCtrl = Get.find<WorkspaceController>();
    final roleDisplay =
        wsCtrl.loggedInMemberObservable.value?.role.displayName ?? '';
    if (roleDisplay.isEmpty) return '';
    return '${AppStrings.I.roleLabel}: $roleDisplay';
  }

  Future<bool> canManageWorkspace() async {
    final wsCtrl = Get.find<WorkspaceController>();
    return wsCtrl.hasPermission('manage_workspace');
  }

  /// Public method to reload recent tasks
  Future<void> reloadRecentTasks() async {
    if (isReloadingTasks.value) return; // Prevent multiple calls
    isReloadingTasks.value = true;
    try {
      await _loadRecentTasks();
    } finally {
      isReloadingTasks.value = false;
    }
  }

  Future<void> _loadRecentTasks() async {
    try {
      final wsCtrl = Get.find<WorkspaceController>();
      final workspaceId = wsCtrl.currentWorkspace.value?.id;
      if (workspaceId == null) return;

      final request = GetTasksRequest(
        workspaceId: workspaceId,
        pageSize: 50, // Load recent 50 tasks
      );

      final response = await _apiGateway.getTasks(request);
      if (response.success && response.data != null) {
        final tasks = response.data!;
        // Take only first 20 for recent tasks
        final recentTasksList = tasks.take(5).toList();
        recentTasks.assignAll(recentTasksList);
      }
    } on Exception catch (e) {
      // Handle error, maybe show snackbar or log
      print('Error loading recent tasks: $e');
    }
  }
}


