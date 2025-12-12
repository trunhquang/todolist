import 'package:flutter/material.dart';
import 'package:todolist/app/widgets/td_chip.dart';
import 'package:todolist/app/widgets/td_text_field.dart';
import 'package:todolist/core/constants/app_spacing.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/tasks/domain/entities/project_status.dart';

import '../controller/project_list_page_controller.dart';
import 'project_status_chip.dart';

class ProjectFilters extends StatelessWidget {
  const ProjectFilters({super.key, required this.controller});

  final ProjectListPageController controller;

  @override
  Widget build(BuildContext context) {
    final statuses = <ProjectStatus?>[null, ...ProjectStatus.values];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TDTextField(
          controller: controller.searchController,
          hint: AppStrings.searchProjects,
          prefixIcon: Icons.search,
          onChanged: controller.updateSearch,
        ),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: statuses
                .map(
                  (status) => Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: TDChip(
                      label: status == null ? AppStrings.anyStatus : status.displayText,
                      isSelected: controller.statusFilter == status,
                      type: projectStatusChipType(status),
                      onTap: () => controller.updateStatus(status),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

