import 'dart:async';

import 'package:get/get.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';


class DashboardController extends GetxController {


  final RxList<Map<String, String>> recentTasks = <Map<String, String>>[].obs;


  @override
  void onInit() {
    super.onInit();
    _seedSampleTasks();
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


