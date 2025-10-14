import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/theme/app_colors.dart';
import 'package:todolist/app/theme/app_text_styles.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/app/widgets/td_text_field.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';

/// Page for creating a new workspace
class CreateWorkspacePage extends StatefulWidget {
  const CreateWorkspacePage({super.key});

  @override
  State<CreateWorkspacePage> createState() => _CreateWorkspacePageState();
}

class _CreateWorkspacePageState extends State<CreateWorkspacePage> {
  final _formKey = GlobalKey<FormState>();
  final _workspaceNameController = TextEditingController();
  final _workspaceDescriptionController = TextEditingController();
  final WorkspaceController _workspaceController = Get.find<WorkspaceController>();

  WorkspaceType _selectedType = WorkspaceType.company;

  @override
  void dispose() {
    _workspaceNameController.dispose();
    _workspaceDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateWorkspace() async {
    if (_formKey.currentState!.validate()) {
      await _workspaceController.createWorkspace(
        name: _workspaceNameController.text.trim(),
        type: _selectedType,
        description: _workspaceDescriptionController.text.trim().isEmpty
            ? null
            : _workspaceDescriptionController.text.trim(),
      );

      // Navigate back on success
      if (!_workspaceController.isLoading) {
        NavigationService().back<void>();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.createWorkspace),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.onBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
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
                  controller: _workspaceNameController,
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
                  controller: _workspaceDescriptionController,
                  label: AppStrings.workspaceDescription,
                  hint: AppStrings.enterWorkspaceDescription,
                  prefixIcon: Icons.description_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                // Create Button
                Obx(() => TDButton(
                  text: AppStrings.createWorkspace,
                  onPressed: _workspaceController.isLoading ? null : _handleCreateWorkspace,
                  isLoading: _workspaceController.isLoading,
                )),
                const SizedBox(height: 16),
                // Cancel Button
                Obx(() => TDButton(
                  text: AppStrings.cancel,
                  onPressed: _workspaceController.isLoading ? null : () => NavigationService().back<void>(),
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
    return Column(
      children: [
        _buildWorkspaceTypeOption(
          type: WorkspaceType.personal,
          title: AppStrings.personalWorkspace,
          description: 'For personal use and individual tasks',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 12),
        _buildWorkspaceTypeOption(
          type: WorkspaceType.company,
          title: AppStrings.companyWorkspace,
          description: 'For team collaboration and company projects',
          icon: Icons.business_outlined,
        ),
      ],
    );
  }

  Widget _buildWorkspaceTypeOption({
    required WorkspaceType type,
    required String title,
    required String description,
    required IconData icon,
  }) {
    final isSelected = _selectedType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
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
  }
}
