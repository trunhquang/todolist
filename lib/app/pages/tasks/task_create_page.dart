import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/constants/app_spacing.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/presentation/widgets/create_task_form.dart';

import '../../../core/services/snackbar_service.dart';

class TaskCreatePage extends StatelessWidget {
  const TaskCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final project = Get.arguments as Project?;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.createTask),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: CreateTaskForm(
              initialProject: project,
              onTaskCreated: () {
                NavigationService().back<void>();
                // Show success message
                SnackbarService().showSuccess(
                  title: AppStrings.success,
                  message: AppStrings.taskCreated,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
