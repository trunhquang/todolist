import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/widgets/td_empty_state.dart';
import 'package:todolist/core/constants/app_spacing.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';

import '../../tasks/controllers/task_controller.dart';
import '../../tasks/widgets/list_task_widget.dart';
import '../../tasks/widgets/project_progress_card.dart';

class ProjectDetailOverviewTab extends StatelessWidget {
  const ProjectDetailOverviewTab({
    super.key,
    required this.project,
  });

  final Project project;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () {
              var progress = Get.find<TaskController>().projectProgressResult;
              return ProjectProgressCard(
                project: project,
                progress: progress.value,
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.tasks,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Obx(
            () {
              var items = Get.find<TaskController>().tasks;
              if (items.isEmpty) {
                return const TDEmptyState(
                  title: AppStrings.noTasksFound,
                  icon: Icons.checklist,
                );
              }
              return ListTaskWidget(
                items: items,
              );
            },
          ),
        ],
      ),
    );
  }
}
