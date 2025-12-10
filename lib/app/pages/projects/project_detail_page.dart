import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/app/widgets/td_card.dart';
import 'package:todolist/app/widgets/td_empty_state.dart';
import 'package:todolist/app/widgets/td_loading_indicator.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/core/services/storage_service.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';
import 'package:todolist/features/tasks/domain/usecases/calculate_project_progress.dart';
import 'package:todolist/features/tasks/presentation/controllers/project_controller.dart';
import 'package:todolist/features/tasks/presentation/controllers/task_controller.dart';
import 'package:todolist/features/tasks/presentation/widgets/create_task_form.dart';
import 'package:todolist/features/tasks/presentation/widgets/project_progress_card.dart';

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
            onPressed: () => _openCreateTaskDialog(project),
            tooltip: AppStrings.createTask,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(project),
          _buildMembersTab(project),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(Project project) {
    final tasks = _taskController.getTasksByProject(project.id);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<ProjectProgressResult>(
            future: _progressFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const TDLoadingIndicator();
              }
              return ProjectProgressCard(
                project: project,
                progress: snapshot.data,
              );
            },
          ),
          const SizedBox(height: 16),
          Text(AppStrings.tasks, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (tasks.isEmpty)
            const TDEmptyState(
              title: AppStrings.noTasksFound,
              icon: Icons.checklist,
            )
          else
            Column(
              children: tasks
                  .map(
                    (task) => TDCard(
                      child: ListTile(
                        title: Text(task.title),
                        subtitle: Text(task.status),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildMembersTab(Project project) {
    final members = _projectController.getProjectMembers(project.id);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TDButton(
              text: AppStrings.addMember,
              onPressed: () => _openAddMemberDialog(project),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: members.isEmpty
                ? const TDEmptyState(
                    title: AppStrings.projectMembers,
                    icon: Icons.group_outlined,
                  )
                : ListView.separated(
                    itemCount: members.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, index) {
                      final member = members[index];
                      return TDCard(
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(member.name),
                          subtitle: Text(member.email),
                        ),
                      );
                    },
                  ),
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

  Future<void> _openCreateTaskDialog(Project project) async {
    await NavigationService().showDialog<void>(
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: 480,
            child: CreateTaskForm(initialProject: project),
          ),
        ),
      ),
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

    User? selected;
    await NavigationService().showDialog<void>(
      child: StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text(AppStrings.addMember),
          content: DropdownButton<User>(
            isExpanded: true,
            value: selected,
            hint: const Text(AppStrings.selectAssignee),
            items: candidates
                .map(
                  (u) => DropdownMenuItem<User>(
                    value: u,
                    child: Text(u.name),
                  ),
                )
                .toList(),
            onChanged: (val) {
              setStateDialog(() {
                selected = val;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () => NavigationService().back<void>(),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: selected == null
                  ? null
                  : () async {
                      await _projectController.addProjectMember(
                        projectId: project.id,
                        userId: selected!.id,
                      );
                      setState(() {
                        _progressFuture = _loadProgress();
                      });
                      NavigationService().back<void>();
                    },
              child: const Text(AppStrings.addMember),
            ),
          ],
        ),
      ),
    );
  }
}

