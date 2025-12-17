import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../controllers/dashboard_controller.dart';

class TDStatisticsTask extends StatelessWidget {
  const TDStatisticsTask({super.key, required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.I.taskStatistics,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          // View chỉ kiểm tra dữ liệu, không tính toán
          if (controller.recentTasks.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              // 1. Biểu đồ Status (Dùng getter statusCounts từ controller)
              _buildModernChartCard(
                title: AppStrings.I.tasksByStatus,
                dataMap: controller.statusCounts,
                colorMapper: _getColorForStatus,
              ),
              const SizedBox(height: 16),

              // 2. Biểu đồ Priority (Dùng getter priorityCounts từ controller)
              _buildModernChartCard(
                title: AppStrings.I.tasksByPriority,
                dataMap: controller.priorityCounts,
                colorMapper: _getColorForPriority,
              ),
              const SizedBox(height: 16),

              // 3. Biểu đồ Project Type (Dùng getter projectCounts từ controller)
              _buildModernChartCard(
                title: AppStrings.I.tasksByProject,
                dataMap: controller.projectCounts,
                colorMapper: _getColorForProjectType,
              ),
            ],
          );
        }),
      ],
    );
  }

  // --- UI Helpers (Color Logic - Thuộc về View) ---

  Color _getColorForStatus(String statusKey) {
    switch (statusKey.toLowerCase()) {
      case 'overdue':
      case 'late':
        return AppColors.error;   // Đỏ (Quan trọng nhất)
      case 'pending':
        return AppColors.warning; // Cam
      case 'inprogress':
      case 'in progress':
        return AppColors.info;    // Xanh dương
      case 'completed':
      case 'done':
        return AppColors.success; // Xanh lá
      case 'cancelled':
        return AppColors.error.withOpacity(0.7); // Đỏ nhạt hoặc Xám
      default:
        return AppColors.secondary;
    }
  }

  Color _getColorForPriority(String priorityKey) {
    switch (priorityKey.toLowerCase()) {
      case 'high': return AppColors.error;
      case 'medium': return AppColors.warning;
      case 'low': return AppColors.success;
      default: return AppColors.secondary;
    }
  }

  Color _getColorForProjectType(String typeKey) {
    switch (typeKey.toLowerCase()) {
      case 'project': return AppColors.projectTask;
      case 'daily': return AppColors.dailyTask;
      case 'weekly': return AppColors.weeklyTask;
      default: return AppColors.primary;
    }
  }

  // --- UI Builders (Pure UI) ---

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.pie_chart_outline, size: 48, color: AppColors.onSurface.withOpacity(0.5)),
          const SizedBox(height: 8),
          Text(
            "Chưa có dữ liệu thống kê",
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildModernChartCard({
    required String title,
    required Map<String, int> dataMap,
    required Color Function(String key) colorMapper,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(
                height: 140,
                width: 140,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: dataMap.entries.map((entry) {
                      return PieChartSectionData(
                        color: colorMapper(entry.key),
                        value: entry.value.toDouble(),
                        title: '',
                        radius: 25,
                        showTitle: false,
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: dataMap.entries.map((entry) {
                    final color = colorMapper(entry.key);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              entry.key,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${entry.value}',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}