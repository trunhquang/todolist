import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/theme/app_colors.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/app/routes/app_router.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/app/pages/projects/widgets/project_detail_overview_tab.dart';
import 'package:todolist/app/pages/projects/widgets/project_members_tab.dart';
import 'package:todolist/app/pages/projects/widgets/project_add_member_dialog.dart';

import '../../../features/workspace/presentation/controllers/workspace_controller.dart';
import '../tasks/controllers/task_controller.dart';
import 'controller/project_controller.dart';

class ProjectDetailPage extends StatefulWidget {
  const ProjectDetailPage({super.key, required this.project});

  final Project project;

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ProjectController _projectController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _projectController = Get.find<ProjectController>();
    _projectController.project = widget.project;
    Get.find<TaskController>().watchTasks(
      project: widget.project,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = _projectController.project;
    final members = _projectController.getProjectMembers(project.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
        bottom: PreferredSize(
          // 48.0 là chiều cao tiêu chuẩn của TabBar
          preferredSize: const Size.fromHeight(48.0),
          child: ColoredBox(
            // --- CHỈNH MÀU TẠI ĐÂY ---
            // Ví dụ: Dùng màu xám rất nhạt để tách biệt với AppBar màu trắng
            color: Colors.grey.shade100,
            // Hoặc nếu AppBar màu Indigo, bạn có thể để màu này là White

            child: TabBar(
              controller: _tabController,

              // --- Cấu hình màu sắc (Giữ nguyên như bạn đã thiết lập) ---
              labelColor: Colors.indigo,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              unselectedLabelColor: Colors.grey.shade600,
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),

              indicatorColor: Colors.indigo,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,

              // Overlay
              overlayColor:
                  WidgetStateProperty.all<Color>(AppColors.surface.withValues(
                alpha: 0.1,
              )),
              tabs: const [
                Tab(text: AppStrings.overview),
                Tab(text: AppStrings.projectMembers),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task),
            onPressed: () => _openCreateTaskPage(project),
            tooltip: AppStrings.createTask,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ProjectDetailOverviewTab(
            project: project,
          ),
          ProjectMembersTab(
            members: members,
            onAddMemberTap: () => _openAddMemberDialog(project),
          ),
        ],
      ),
    );
  }

  Future<void> _openCreateTaskPage(Project project) async {
    await NavigationService().toNamed<void>(
      AppRouter.taskCreate,
      arguments: project,
    );
  }

  Future<void> _openAddMemberDialog(Project project) async {
    final workspaceContext = Get.find<WorkspaceController>().workspaceMembers;
    final existing = project.memberIds.toSet();
    final candidates =
        workspaceContext.where((u) => !existing.contains(u.userId)).toList();

    if (candidates.isEmpty) {
      SnackbarService().showInfo(
        title: AppStrings.info,
        message: AppStrings.permissionDenied,
      );
      return;
    }

    await NavigationService().showDialog<void>(
      child: ProjectAddMemberDialog(
        candidates: candidates,
        onSubmit: (user) async {
          await _projectController.addProjectMember(
            projectId: project.id,
            userId: user.userId,
          );
        },
      ),
    );
  }
}
