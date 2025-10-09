import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';

class TaskStatisticsPage extends StatelessWidget {
  const TaskStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.taskStatistics),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.overview,
              style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _StatCard(title: AppStrings.totalTasks, value: '—'),
            const SizedBox(height: 16),
            Text(
              AppStrings.byStatus,
              style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _PlaceholderChart(label: AppStrings.statusDistribution),
            const SizedBox(height: 16),
            Text(
              AppStrings.completionTrend,
              style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _PlaceholderChart(label: AppStrings.tasksCompletedOverTime),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLarge.copyWith(color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 8),
                Text(value, style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderChart extends StatelessWidget {
  const _PlaceholderChart({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface.withOpacity(0.7)),
        textAlign: TextAlign.center,
      ),
    );
  }
}


