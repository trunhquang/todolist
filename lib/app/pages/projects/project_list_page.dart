import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/theme/app_colors.dart';
import 'package:todolist/app/widgets/td_app_bar.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/tasks/domain/usecases/calculate_workspace_projects_summary.dart';
import 'controller/project_list_page_controller.dart';
import 'widgets/project_list_body.dart';

class ProjectListPage extends StatelessWidget {
  const ProjectListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectListPageController>(
      init: ProjectListPageController(
        calculateSummary: Get.isRegistered<CalculateWorkspaceProjectsSummary>()
            ? Get.find<CalculateWorkspaceProjectsSummary>()
            : null,
      ),
      builder: (controller) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: TDAppBar(
          title: AppStrings.projects,
          actions: [
            TDButton(
              text: AppStrings.createProject,
              icon: Icons.add,
              onPressed: controller.onCreateProjectTap,
            ),
          ],
        ),
        body: ProjectListBody(controller: controller),
      ),
    );
  }
}