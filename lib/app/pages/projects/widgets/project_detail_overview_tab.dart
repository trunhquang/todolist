import 'package:flutter/material.dart';
import 'package:todolist/app/widgets/td_card.dart';
import 'package:todolist/app/widgets/td_empty_state.dart';
import 'package:todolist/app/widgets/td_loading_indicator.dart';
import 'package:todolist/core/constants/app_spacing.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';
import 'package:todolist/features/tasks/domain/usecases/calculate_project_progress.dart';
import 'package:todolist/features/tasks/presentation/widgets/project_progress_card.dart';

class ProjectDetailOverviewTab extends StatelessWidget {
  const ProjectDetailOverviewTab({
    super.key,
    required this.project,
    required this.tasks,
    required this.progressFuture,
  });

  final Project project;
  final List<TaskEntity> tasks;
  final Future<ProjectProgressResult>? progressFuture;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<ProjectProgressResult>(
            future: progressFuture,
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
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.tasks,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
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
}
