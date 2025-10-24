import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/widgets/td_card.dart';
import 'package:todolist/app/widgets/td_chip.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/constants/task_enums.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';

/// TaskCard widget for Sprint 5 task display with workspace context
/// 
/// This widget provides:
/// - Task information display
/// - Status and priority indicators
/// - Action buttons for task operations
/// - Workspace context validation
class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(TaskStatus)? onStatusChange;

  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onStatusChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TDCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task header with title and status
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildStatusChip(),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Task description
          if (task.description != null && task.description!.isNotEmpty) ...[
            Text(
              task.description!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
          ],
          
          // Task metadata
          _buildTaskMetadata(),
          
          const SizedBox(height: 12),
          
          // Task actions
          _buildTaskActions(),
        ],
      ),
    );
  }

  /// Build status chip
  Widget _buildStatusChip() {
    final status = TaskStatus.fromString(task.status);
    Color chipColor;
    
    switch (status) {
      case TaskStatus.pending:
        chipColor = Colors.orange;
        break;
      case TaskStatus.inProgress:
        chipColor = Colors.blue;
        break;
      case TaskStatus.completed:
        chipColor = Colors.green;
        break;
      case TaskStatus.cancelled:
        chipColor = Colors.red;
        break;
      case TaskStatus.onHold:
        chipColor = Colors.grey;
        break;
    }
    
    return TDChip(
      label: status.displayText,
      type: _getChipType(status),
    );
  }

  /// Build task metadata
  Widget _buildTaskMetadata() {
    return Column(
      children: [
        // Priority and Type
        Row(
          children: [
            _buildPriorityChip(),
            const SizedBox(width: 8),
            _buildTypeChip(),
            const Spacer(),
            if (task.hasDeadline && task.deadline != null)
              _buildDeadlineChip(),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Assignee and Project
        Row(
          children: [
            if (task.assignee != null) ...[
              Icon(
                Icons.person,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                'Assigned',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
            const Spacer(),
            if (task.projectId != null) ...[
              Icon(
                Icons.folder,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                'Project',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// Build priority chip
  Widget _buildPriorityChip() {
    final priority = TaskPriority.fromString(task.priority);
    Color chipColor;
    
    switch (priority) {
      case TaskPriority.low:
        chipColor = Colors.green;
        break;
      case TaskPriority.medium:
        chipColor = Colors.blue;
        break;
      case TaskPriority.high:
        chipColor = Colors.orange;
        break;
      case TaskPriority.urgent:
        chipColor = Colors.red;
        break;
    }
    
    return TDChip(
      label: priority.displayText,
      type: _getChipTypeForPriority(priority),
    );
  }

  /// Build type chip
  Widget _buildTypeChip() {
    final type = TaskType.fromString(task.taskType);
    Color chipColor;
    
    switch (type) {
      case TaskType.daily:
        chipColor = Colors.purple;
        break;
      case TaskType.project:
        chipColor = Colors.indigo;
        break;
    }
    
    return TDChip(
      label: type.displayText,
      type: _getChipTypeForType(type),
    );
  }

  /// Build deadline chip
  Widget _buildDeadlineChip() {
    final now = DateTime.now();
    final deadline = task.deadline!;
    final isOverdue = deadline.isBefore(now);
    final isToday = deadline.day == now.day && 
                   deadline.month == now.month && 
                   deadline.year == now.year;
    
    Color chipColor;
    String label;
    
    if (isOverdue) {
      chipColor = Colors.red;
      label = 'Overdue';
    } else if (isToday) {
      chipColor = Colors.orange;
      label = 'Due Today';
    } else {
      chipColor = Colors.blue;
      label = '${deadline.day}/${deadline.month}/${deadline.year}';
    }
    
    return TDChip(
      label: label,
      type: TDChipType.info,
    );
  }

  /// Build task actions
  Widget _buildTaskActions() {
    return Row(
      children: [
        // Status change dropdown
        Expanded(
          child: _buildStatusDropdown(),
        ),
        
        const SizedBox(width: 8),
        
        // Edit button
        IconButton(
          onPressed: onEdit,
          icon: const Icon(Icons.edit),
          iconSize: 20,
          color: Colors.blue,
        ),
        
        // Delete button
        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete),
          iconSize: 20,
          color: Colors.red,
        ),
      ],
    );
  }

  /// Build status dropdown
  Widget _buildStatusDropdown() {
    final currentStatus = TaskStatus.fromString(task.status);
    
    return DropdownButtonFormField<TaskStatus>(
      value: currentStatus,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        isDense: true,
      ),
      items: TaskStatus.values.map((status) {
        return DropdownMenuItem<TaskStatus>(
          value: status,
          child: Text(
            status.displayText,
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
      onChanged: (TaskStatus? status) {
        if (status != null && status != currentStatus) {
          onStatusChange?.call(status);
        }
      },
    );
  }

  TDChipType _getChipType(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return TDChipType.warning;
      case TaskStatus.inProgress:
        return TDChipType.info;
      case TaskStatus.completed:
        return TDChipType.success;
      case TaskStatus.cancelled:
        return TDChipType.error;
      case TaskStatus.onHold:
        return TDChipType.secondary;
    }
  }

  TDChipType _getChipTypeForPriority(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return TDChipType.success;
      case TaskPriority.medium:
        return TDChipType.info;
      case TaskPriority.high:
        return TDChipType.warning;
      case TaskPriority.urgent:
        return TDChipType.error;
    }
  }

  TDChipType _getChipTypeForType(TaskType type) {
    switch (type) {
      case TaskType.daily:
        return TDChipType.primary;
      case TaskType.project:
        return TDChipType.warning;
    }
  }
}
