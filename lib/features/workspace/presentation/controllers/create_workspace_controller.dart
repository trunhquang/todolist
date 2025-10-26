import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/services/workspace_validator.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';

/// Controller for CreateWorkspacePage
class CreateWorkspaceController extends GetxController {
  final WorkspaceController _workspaceController = Get.find<WorkspaceController>();

  final formKey = GlobalKey<FormState>();
  final workspaceNameController = TextEditingController();
  final workspaceDescriptionController = TextEditingController();

  final Rx<WorkspaceType> _selectedType = WorkspaceType.company.obs;
  final RxBool _isLoading = false.obs;

  WorkspaceType get selectedType => _selectedType.value;
  bool get isLoading => _isLoading.value;

  void setSelectedType(WorkspaceType type) {
    _selectedType.value = type;
    update();
  }

  /// Check if workspace name is available (not duplicate)
  bool isWorkspaceNameAvailable(String name) {
    final existingWorkspaces = _workspaceController.workspaces;
    return WorkspaceValidator.isWorkspaceNameAvailable(name, existingWorkspaces);
  }

  Future<void> handleCreateWorkspace() async {
    if (formKey.currentState!.validate()) {
      _isLoading.value = true;
      try {
        await _workspaceController.createWorkspace(
          name: workspaceNameController.text.trim(),
          type: _selectedType.value,
          description: workspaceDescriptionController.text.trim().isEmpty
              ? null
              : workspaceDescriptionController.text.trim(),
        );
      } finally {
        _isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    workspaceNameController.dispose();
    workspaceDescriptionController.dispose();
    super.onClose();
  }
}