import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/widgets/td_app_bar.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/app/widgets/td_empty_state.dart';
import 'package:todolist/app/widgets/td_loading_indicator.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/constants/task_enums.dart';
import 'package:todolist/features/tasks/presentation/controllers/task_controller.dart';
import 'package:todolist/features/tasks/presentation/widgets/create_task_form.dart';
import 'package:todolist/features/tasks/presentation/widgets/task_card.dart';

import '../../domain/entities/task.dart';

/// TaskListPage for Sprint 5 task management with workspace context
/// 
/// This page provides:
/// - Task list with workspace filtering
/// - Task creation functionality
/// - Task management operations
/// - Workspace context awareness
class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (controller) => Scaffold(
        appBar: TDAppBar(
          title: AppStrings.tasks,
          actions: [
            TDButton(
              text: AppStrings.createTask,
              onPressed: () => _showCreateTaskDialog(context),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading) {
            return const Center(
              child: TDLoadingIndicator(),
            );
          }

          if (controller.tasks.isEmpty) {
            return TDEmptyState(
              title: AppStrings.noTasksFound,
              icon: Icons.task_alt,
              actionText: AppStrings.createTask,
              onAction: () => _showCreateTaskDialog(context),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshTasks,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.tasks.length,
              itemBuilder: (context, index) {
                final task = controller.tasks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskCard(
                    task: task,
                    onTap: () => _onTaskTap(task),
                    onEdit: () => _onTaskEdit(task),
                    onDelete: () => _onTaskDelete(controller, task),
                    onStatusChange: (status) => _onTaskStatusChange(controller, task, status),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  /// Show create task dialog
  void _showCreateTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(
            maxWidth: 500,
            maxHeight: 600, // Add max height constraint
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.createTask,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              const Expanded( // Make form scrollable
                child: SingleChildScrollView(
                  child: CreateTaskForm(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TDButton(
                      text: AppStrings.cancel,
                      onPressed: () => Navigator.of(context).pop(),
                      variant: TDButtonVariant.outlined,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TDButton(
                      text: AppStrings.create,
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Task creation is handled by CreateTaskForm
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle task tap
  void _onTaskTap(task) {
    // TODO: Navigate to task details page
    // This should show task details with edit capabilities
    print('Task tapped: ${task.title}');
  }

  /// Handle task edit
  void _onTaskEdit(task) {
    // TODO: Navigate to task edit page
    // This should open task edit form
    print('Edit task: ${task.title}');
  }

  /// Handle task delete
  void _onTaskDelete(TaskController controller, TaskEntity task) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.confirmDelete),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.deleteTask(task.id);
            },
            child: const Text(
              AppStrings.delete,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle task status change
  void _onTaskStatusChange(TaskController controller, TaskEntity task, TaskStatus status) {
    controller.updateTaskStatus(task.id, status);
  }
}
