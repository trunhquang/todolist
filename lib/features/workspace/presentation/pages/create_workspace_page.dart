import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/theme/app_colors.dart';
import 'package:todolist/app/theme/app_text_styles.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/app/widgets/td_text_field.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';

import '../controllers/create_workspace_controller.dart';

/// Page for creating a new workspace
class CreateWorkspacePage extends StatelessWidget {
  const CreateWorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateWorkspaceController>(
      init: CreateWorkspaceController(),
      builder: (controller) => _CreateWorkspaceView(controller: controller),
    );
  }
}

class _CreateWorkspaceView extends StatelessWidget {
  final CreateWorkspaceController controller;

  const _CreateWorkspaceView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.createWorkspace),
        backgroundColor: AppColors.primary,
        elevation: 0,
        foregroundColor: AppColors.onPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Title
                Text(
                  AppStrings.createWorkspace,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.enterWorkspaceDescription,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                // Workspace Type Selection
                Text(
                  AppStrings.workspaceType,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 12),
                _buildWorkspaceTypeSelector(),
                const SizedBox(height: 24),
                // Workspace Name Field
                TDTextField(
                  controller: controller.workspaceNameController,
                  label: AppStrings.workspaceName,
                  hint: AppStrings.enterWorkspaceName,
                  prefixIcon: Icons.work_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.pleaseEnterWorkspaceName;
                    }
                    if (value.length < 2) {
                      return AppStrings.workspaceNameMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Workspace Description Field
                TDTextField(
                  controller: controller.workspaceDescriptionController,
                  label: AppStrings.workspaceDescription,
                  hint: AppStrings.enterWorkspaceDescription,
                  prefixIcon: Icons.description_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                // Create Button
                Obx(() => TDButton(
                  text: AppStrings.createWorkspace,
                  onPressed: controller.isLoading ? null : controller.handleCreateWorkspace,
                  isLoading: controller.isLoading,
                )),
                const SizedBox(height: 16),
                // Cancel Button
                Obx(() => TDButton(
                  text: AppStrings.cancel,
                  onPressed: controller.isLoading ? null : () => NavigationService().back<void>(),
                  variant: TDButtonVariant.outlined,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkspaceTypeSelector() {
    return GetBuilder<CreateWorkspaceController>(
      builder: (controller) => Column(
        children: [
          _buildWorkspaceTypeOption(
            controller: controller,
            type: WorkspaceType.personal,
            title: AppStrings.personalWorkspace,
            description: AppStrings.personalWorkspaceDescription,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          _buildWorkspaceTypeOption(
            controller: controller,
            type: WorkspaceType.company,
            title: AppStrings.companyWorkspace,
            description: AppStrings.companyWorkspaceDescription,
            icon: Icons.business_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceTypeOption({
    required CreateWorkspaceController controller,
    required WorkspaceType type,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return GetBuilder<CreateWorkspaceController>(
      builder: (ctrl) {
        final isSelected = ctrl.selectedType == type;
        
        return GestureDetector(
          onTap: () => ctrl.setSelectedType(type),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.outline,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: isSelected ? AppColors.primary : AppColors.onBackground,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 24,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

