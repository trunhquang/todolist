import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/constants/app_spacing.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/core/services/storage_service.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/app/routes/app_router.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/usecases/calculate_project_progress.dart';
import 'package:todolist/features/tasks/presentation/controllers/project_controller.dart';
import 'package:todolist/features/tasks/presentation/controllers/task_controller.dart';
import 'package:todolist/features/tasks/presentation/widgets/project_progress_card.dart';
import 'package:todolist/app/pages/projects/widgets/project_detail_overview_tab.dart';
import 'package:todolist/app/pages/projects/widgets/project_members_tab.dart';
import 'package:todolist/app/pages/projects/widgets/project_add_member_dialog.dart';

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
  late final TaskController _taskController;
  Future<ProjectProgressResult>? _progressFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _projectController = Get.find<ProjectController>();
    _taskController = Get.find<TaskController>();
    _progressFuture = _loadProgress();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final tasks = _taskController.getTasksByProject(project.id);
    final members = _projectController.getProjectMembers(project.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: AppStrings.overview),
            Tab(text: AppStrings.projectMembers),
          ],
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
            tasks: tasks,
            progressFuture: _progressFuture,
          ),
          ProjectMembersTab(
            members: members,
            onAddMemberTap: () => _openAddMemberDialog(project),
          ),
        ],
      ),
    );
  }

  Future<ProjectProgressResult> _loadProgress() async {
    final useCase = Get.find<CalculateProjectProgress>();
    final workspaceId =
        StorageService().getWorkspaceId() ?? widget.project.workspaceId;
    return useCase.call(
      workspaceId: workspaceId,
      projectId: widget.project.id,
    );
  }

  Future<void> _openCreateTaskPage(Project project) async {
    await NavigationService().toNamed<void>(
      AppRouter.taskCreate,
      arguments: project,
    );
  }

  Future<void> _openAddMemberDialog(Project project) async {
    final workspaceContext = Get.find<TaskController>().workspaceMembers;
    final existing = project.memberIds.toSet();
    final candidates =
        workspaceContext.where((u) => !existing.contains(u.id)).toList();

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
            userId: user.id,
          );
          setState(() {
            _progressFuture = _loadProgress();
          });
        },
      ),
    );
  }
}

