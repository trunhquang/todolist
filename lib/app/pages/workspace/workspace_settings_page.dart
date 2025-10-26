import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../features/workspace/presentation/controllers/workspace_controller.dart';
import '../../widgets/td_app_bar.dart';
import '../../widgets/td_button.dart';
import '../../widgets/td_text_field.dart';

class WorkspaceSettingsPage extends StatefulWidget {
  const WorkspaceSettingsPage({super.key});

  @override
  State<WorkspaceSettingsPage> createState() => _WorkspaceSettingsPageState();
}

class _WorkspaceSettingsPageState extends State<WorkspaceSettingsPage> {
  final WorkspaceController _workspaceController = Get.find<WorkspaceController>();
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _logoUrlController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _checkPermissions();
  }

  /// Check if user has permission to access workspace settings
  Future<void> _checkPermissions() async {
    try {
      final canManageWorkspace = await _workspaceController.hasPermission('manage_workspace');
      if (!canManageWorkspace) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: AppStrings.permissionDenied,
        );
        NavigationService().back<void>();
        return;
      }
    } catch (e) {
      SnackbarService().showError(
        title: AppStrings.error,
        message: AppStrings.permissionDenied,
      );
      NavigationService().back<void>();
    }
  }

  void _initializeControllers() {
    final currentWorkspace = _workspaceController.currentWorkspace.value;
    _nameController = TextEditingController(text: currentWorkspace?.name ?? '');
    _descriptionController = TextEditingController(text: currentWorkspace?.description ?? '');
    _logoUrlController = TextEditingController(text: currentWorkspace?.logoUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _logoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDAppBar(
        title: AppStrings.workspaceSettings,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationService().back<void>(),
        ),
      ),
      body: Obx(() {
        if (_workspaceController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Workspace Information Section
                _buildSectionHeader(AppStrings.workspaceInformation),
                const SizedBox(height: 16),
                
                // Workspace Name
                TDTextField(
                  controller: _nameController,
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
                
                // Workspace Description
                TDTextField(
                  controller: _descriptionController,
                  label: AppStrings.workspaceDescription,
                  hint: AppStrings.enterWorkspaceDescription,
                  prefixIcon: Icons.description_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                
                // Logo URL
                TDTextField(
                  controller: _logoUrlController,
                  label: AppStrings.workspaceLogoUrl,
                  hint: AppStrings.enterLogoUrl,
                  prefixIcon: Icons.image_outlined,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final uri = Uri.tryParse(value);
                      final isValid = uri != null && (uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https'));
                      if (!isValid) {
                        return AppStrings.pleaseEnterValidUrl;
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                
                // Danger Zone Section
                _buildSectionHeader(AppStrings.dangerZone),
                const SizedBox(height: 16),
                
                // Delete Workspace Button
                TDButton(
                  text: AppStrings.deleteWorkspace,
                  onPressed: _handleDeleteWorkspace,
                  variant: TDButtonVariant.outlined,
                ),
                const SizedBox(height: 32),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: TDButton(
                        text: AppStrings.cancel,
                        onPressed: () => NavigationService().back<void>(),
                        variant: TDButtonVariant.outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TDButton(
                        text: AppStrings.saveChanges,
                        onPressed: _handleSaveSettings,
                        isLoading: _workspaceController.isLoading,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Future<void> _handleSaveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _workspaceController.updateWorkspaceSettings(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        logoUrl: _logoUrlController.text.trim().isEmpty 
            ? null 
            : _logoUrlController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.workspaceSettingsUpdated),
            backgroundColor: Colors.green,
          ),
        );
        NavigationService().back<void>();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.failedToUpdateSettings}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleDeleteWorkspace() async {
    // Check if user is account holder (only account holders can delete workspace)
    try {
      final currentWorkspace = _workspaceController.currentWorkspace.value;
      if (currentWorkspace == null) return;
      
      final userRole = await _workspaceController.getUserWorkspaceRole();
      if (userRole == null || !userRole.isAccountHolder) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: AppStrings.onlyAccountHolderCanDelete,
        );
        return;
      }
    } catch (e) {
      SnackbarService().showError(
        title: AppStrings.error,
        message: AppStrings.permissionDenied,
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteWorkspace),
        content: const Text(AppStrings.deleteWorkspaceConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      try {
        await _workspaceController.deleteCurrentWorkspace();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.workspaceDeleted),
              backgroundColor: Colors.green,
            ),
          );
          NavigationService().offAllNamed<void>('/dashboard');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${AppStrings.failedToDeleteWorkspace}: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
