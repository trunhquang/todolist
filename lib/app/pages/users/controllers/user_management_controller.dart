import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../features/invitations/domain/entities/invitation.dart';
import '../../../../features/workspace/domain/entities/workspace_member.dart';
import '../../../../features/workspace/presentation/controllers/workspace_controller.dart';

class UserManagementController extends GetxController {
  final WorkspaceController _workspaceController =
      Get.find<WorkspaceController>();

  // Text controllers
  final _searchController = TextEditingController();
  final _inviteEmailController = TextEditingController();
  final _inviteNameController = TextEditingController();
  final _inviteFormKey = GlobalKey<FormState>();

  // Reactive state
  final RxBool _canManageUsers = false.obs;
  final RxBool _isLoading = false.obs;
  final RxString _searchQuery = ''.obs;

  // Getters
  TextEditingController get searchController => _searchController;

  TextEditingController get inviteEmailController => _inviteEmailController;

  TextEditingController get inviteNameController => _inviteNameController;

  GlobalKey<FormState> get inviteFormKey => _inviteFormKey;

  bool get canManageUsers => _canManageUsers.value;

  bool get isLoading => _isLoading.value;

  String get searchQuery => _searchQuery.value;

  List<WorkspaceMember> get workspaceMembers =>
      _workspaceController.workspaceMembers;

  List<Invitation> get invitations => _workspaceController.invitations;

  @override
  void onInit() {
    super.onInit();
    _initializePage();
  }

  @override
  void onClose() {
    _searchController.dispose();
    _inviteEmailController.dispose();
    _inviteNameController.dispose();
    super.onClose();
  }

  /// Initialize page data
  Future<void> _initializePage() async {
    _isLoading.value = true;
    await _checkPermissions();
    await _loadWorkspaceMembers();
    _isLoading.value = false;
  }

  /// Check if user has permission to access user management
  Future<void> _checkPermissions() async {
    try {
      final canManage =
          await _workspaceController.hasPermission('manage_users');
      _canManageUsers.value = canManage;

      if (!canManage) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: AppStrings.permissionDenied,
        );
        NavigationService().back<void>();
        return;
      }
    } catch (e) {
      _canManageUsers.value = false;
      SnackbarService().showError(
        title: AppStrings.error,
        message: AppStrings.permissionDenied,
      );
      NavigationService().back<void>();
    }
  }

  /// Load workspace members and invitations
  Future<void> _loadWorkspaceMembers() async {
    await _workspaceController.loadWorkspaceMembers();
    await _workspaceController.loadInvitations();
  }

  /// Update search query
  Future<void> updateSearchQuery(String query) async {
    _searchQuery.value = query;
  }

  /// Refresh data
  Future<void> refreshData() async {
    _isLoading.value = true;
    await _loadWorkspaceMembers();
    _isLoading.value = false;
  }

  Future<void> revokeInvitation(String id) async {
    return _workspaceController.revokeInvitation(id);
  }

  Future<void> inviteUserToWorkspace() async {
    return _workspaceController.inviteUserToWorkspace(
        inviteEmailController.text.trim(),
        name: inviteNameController.text.trim());
  }

  Future<void> updateUserRole(String userId, String newRole) async {
    return _workspaceController.updateUserRole(userId, newRole);
  }

  Future<void> removeUserFromWorkspace(String userId) async {
    return _workspaceController.removeUserFromWorkspace(userId);
  }
}
