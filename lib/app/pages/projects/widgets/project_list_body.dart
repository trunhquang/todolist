import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/widgets/td_empty_state.dart';
import 'package:todolist/app/widgets/td_loading_indicator.dart';
import 'package:todolist/core/constants/app_spacing.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/tasks/presentation/controllers/project_list_page_controller.dart';

import 'project_card.dart';
import 'project_filters.dart';
import 'project_summary.dart';

class ProjectListBody extends StatelessWidget {
  const ProjectListBody({super.key, required this.controller});

  final ProjectListPageController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingProjects) {
        return const Center(child: TDLoadingIndicator());
      }

      final projects = controller.filteredProjects;

      return Column(
        children: [
          if (controller.isSummaryLoading || controller.summary != null)
            Padding(
              padding: const EdgeInsets.only(
                  top: AppSpacing.md,
                  left: AppSpacing.md,
                  right: AppSpacing.md),
              child: ProjectSummary(
                summary: controller.summary,
                isLoading: controller.isSummaryLoading,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(
                top: AppSpacing.md, left: AppSpacing.md, right: AppSpacing.md),
            child: ProjectFilters(controller: controller),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: projects.isEmpty
                ? TDEmptyState(
                    title: AppStrings.noProjectsFound,
                    subtitle: AppStrings.manageProjects,
                    icon: Icons.folder_open,
                    actionText: AppStrings.createProject,
                    onAction: controller.onCreateProjectTap,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: projects.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (_, index) => ProjectCard(
                      project: projects[index],
                      controller: controller,
                    ),
                  ),
          ),
        ],
      );
    });
  }
}
