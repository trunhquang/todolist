import 'package:flutter/material.dart';
import 'package:todolist/app/theme/app_text_styles.dart';
import 'package:todolist/app/widgets/td_card.dart';
import 'package:todolist/app/widgets/td_loading_indicator.dart';
import 'package:todolist/core/constants/app_spacing.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/tasks/domain/usecases/calculate_workspace_projects_summary.dart';

class ProjectSummary extends StatelessWidget {
  const ProjectSummary({
    super.key,
    required this.summary,
    required this.isLoading,
  });

  final WorkspaceProjectsSummary? summary;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final summaryData = summary;

    if (isLoading && summaryData == null) {
      return const TDCard(
        child: TDLoadingIndicator(
          size: 20,
          showMessage: false,
        ),
      );
    }

    if (summaryData == null) {
      return const SizedBox.shrink();
    }

    return TDCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.I.overview,
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatTile(
                label: AppStrings.I.projects,
                value: summaryData.totalProjects.toString(),
              ),
              _StatTile(
                label: AppStrings.I.totalTasks,
                value: summaryData.totalTasks.toString(),
              ),
              _StatTile(
                label: AppStrings.I.statusCompleted,
                value: summaryData.completedTasks.toString(),
              ),
              _StatTile(
                label: AppStrings.I.overdue,
                value: summaryData.overdueProjects.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

