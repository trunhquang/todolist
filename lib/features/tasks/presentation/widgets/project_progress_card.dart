import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/widgets/td_card.dart';
import 'package:todolist/app/widgets/td_chip.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/usecases/calculate_project_progress.dart';

/// ProjectProgressCard widget for Sprint 6 project progress display
/// 
/// This widget provides:
/// - Project progress visualization
/// - Task statistics display
/// - Progress indicators
/// - Status indicators
class ProjectProgressCard extends StatelessWidget {
  final Project project;
  final ProjectProgressResult? progress;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProjectProgressCard({
    Key? key,
    required this.project,
    this.progress,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TDCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project header
          _buildProjectHeader(),
          
          const SizedBox(height: 12),
          
          // Progress bar
          if (progress != null) ...[
            _buildProgressBar(),
            const SizedBox(height: 12),
          ],
          
          // Task statistics
          if (progress != null) ...[
            _buildTaskStatistics(),
            const SizedBox(height: 12),
          ],
          
          // Project metadata
          _buildProjectMetadata(),
          
          const SizedBox(height: 12),
          
          // Action buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// Build project header
  Widget _buildProjectHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.title,
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (project.description != null && project.description!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  project.description!,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        _buildStatusChip(),
      ],
    );
  }

  /// Build status chip
  Widget _buildStatusChip() {
    Color chipColor;
    String statusText;
    
    switch (project.status) {
      case 'pending':
        chipColor = Colors.orange;
        statusText = 'Pending';
        break;
      case 'in_progress':
        chipColor = Colors.blue;
        statusText = 'In Progress';
        break;
      case 'completed':
        chipColor = Colors.green;
        statusText = 'Completed';
        break;
      case 'cancelled':
        chipColor = Colors.red;
        statusText = 'Cancelled';
        break;
      default:
        chipColor = Colors.grey;
        statusText = project.status;
    }
    
    return TDChip(
      label: statusText,
      type: TDChipType.primary,
    );
  }

  /// Build progress bar
  Widget _buildProgressBar() {
    final percentage = progress!.progressPercentage;
    final isOverdue = progress!.isOverdue;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: Get.textTheme.labelMedium,
            ),
            Text(
              '$percentage%',
              style: Get.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isOverdue ? Colors.red : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            isOverdue ? Colors.red : Colors.green,
          ),
        ),
      ],
    );
  }

  /// Build task statistics
  Widget _buildTaskStatistics() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Total',
            progress!.totalTasks.toString(),
            Colors.blue,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            'Completed',
            progress!.completedTasks.toString(),
            Colors.green,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            'Pending',
            progress!.pendingTasks.toString(),
            Colors.orange,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            'In Progress',
            progress!.inProgressTasks.toString(),
            Colors.blue,
          ),
        ),
      ],
    );
  }

  /// Build stat item
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Get.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Build project metadata
  Widget _buildProjectMetadata() {
    return Row(
      children: [
        if (project.deadline != null) ...[
          Icon(
            Icons.schedule,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            _formatDeadline(project.deadline!),
            style: Get.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 16),
        ],
        Icon(
          Icons.calendar_today,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          _formatDate(project.createdAt),
          style: Get.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
          tooltip: 'Edit Project',
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
          tooltip: 'Delete Project',
          color: Colors.red,
        ),
        const Spacer(),
        if (progress != null && progress!.isOverdue)
          TDChip(
            label: 'Overdue',
            type: TDChipType.error,
          ),
      ],
    );
  }

  /// Format deadline
  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now).inDays;
    
    if (difference < 0) {
      return 'Overdue by ${(-difference)} days';
    } else if (difference == 0) {
      return 'Due today';
    } else if (difference == 1) {
      return 'Due tomorrow';
    } else {
      return 'Due in $difference days';
    }
  }

  /// Format date
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
