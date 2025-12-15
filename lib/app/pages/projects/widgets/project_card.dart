import 'package:flutter/material.dart';
import 'package:todolist/app/theme/app_text_styles.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/app/widgets/td_card.dart';
import 'package:todolist/app/widgets/td_chip.dart';
import 'package:todolist/core/constants/app_spacing.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';

import '../controller/project_list_page_controller.dart';
import 'project_status_chip.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.controller,
  });

  final Project project;
  final ProjectListPageController controller;

  @override
  Widget build(BuildContext context) {
    return TDCard(
      isClickable: true,
      onTap: () => controller.onProjectTap(project),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                TDChip(
                  label: project.status.displayText,
                  type: projectStatusChipType(project.status),
                ),
              ],
            ),
          ),
          FutureBuilder<bool>(
            future: controller.canManageProject(project),
            builder: (context, snapshot) {
              final canManage = snapshot.data ?? false;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TDButton(
                    text: AppStrings.I.edit,
                    icon: Icons.edit_outlined,
                    variant: TDButtonVariant.text,
                    onPressed: canManage ? () => controller.onEditProject(project) : null,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  TDButton(
                    text: AppStrings.I.delete,
                    icon: Icons.delete_outline,
                    variant: TDButtonVariant.text,
                    onPressed: canManage ? () => controller.deleteProject(project) : null,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

