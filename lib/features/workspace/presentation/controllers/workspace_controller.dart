import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';
import 'package:todolist/features/workspace/domain/usecases/create_workspace.dart';
import 'package:todolist/features/workspace/domain/usecases/switch_workspace.dart';
import 'package:todolist/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:todolist/features/invitations/domain/entities/invitation.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';

import '../../../../core/services/firebase_database_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../tasks/domain/entities/project.dart';

/// Workspace controller following GetX patterns
class WorkspaceController extends GetxController {

  WorkspaceController({
    CreateWorkspace? createWorkspace,
    SwitchWorkspace? switchWorkspace,
    required WorkspaceRepository workspaceRepository,
  })  : _workspaceRepository = workspaceRepository,
        _createWorkspace =
            createWorkspace ?? CreateWorkspace(workspaceRepository),
        _switchWorkspace =
            switchWorkspace ?? SwitchWorkspace(workspaceRepository);
  final CreateWorkspace _createWorkspace;
  final SwitchWorkspace _switchWorkspace;
  final WorkspaceRepository _workspaceRepository;

  // Private observables
  final RxBool _isLoading = false.obs;
  final RxList<Workspace> _workspaces = <Workspace>[].obs;
  final _currentWorkspace = Rxn<Workspace>();
  final RxList<WorkspaceMember> _workspaceMembers = <WorkspaceMember>[].obs;
  final Rxn<WorkspaceMember> _loggedInMember = Rxn<WorkspaceMember>();
  final RxList<Invitation> _invitations = <Invitation>[].obs;
  final RxString _errorMessage = ''.obs;

  //Projects in workspace
  final RxList<Project> projects = <Project>[].obs;
  StreamSubscription<List<Project>>? _projectsSubscription;
  final FirebaseDatabaseService _databaseService = FirebaseDatabaseService.instance;
  final _storageService = StorageService();


  String get _userId =>  Get.find<AuthController>().currentUser?.id ?? '';

  // Public getters
  bool get isLoading => _isLoading.value;

  List<Workspace> get workspaces => _workspaces;

  Rxn<Workspace> get currentWorkspace => _currentWorkspace;

  List<WorkspaceMember> get workspaceMembers => _workspaceMembers;

  WorkspaceMember? get loggedInMember => _loggedInMember.value;
  Rxn<WorkspaceMember> get loggedInMemberObservable => _loggedInMember;

  List<Invitation> get invitations => _invitations;

  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    _listenToAuthChanges();
    ever<List<WorkspaceMember>>(
      _workspaceMembers,
      (_) => _updateLoggedInMember(),
    );
  }

  @override
  void onClose() {
    _projectsSubscription?.cancel();
    super.onClose();
  }

  /// Listen to authentication state changes and reload workspaces when user logs in
  Future<void> _listenToAuthChanges() async {
    await  _loadCurrentWorkspaces();
     _listenToProjects();

    // Listen to AuthController currentUser changes
    if (Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      // Use the public observable to listen to auth state changes
      ever(authController.currentUserObservable, (user) {
        // debugPrint(">>> ever triggered | user = $user");
        // debugPrint(StackTrace.current.toString());

        if (user != null) {
          // User logged in, reload workspaces
          _loadCurrentWorkspaces();
          _listenToProjects();
        } else {
          // User logged out, clear workspaces
          _workspaces.clear();
          _currentWorkspace.value = null;
          _workspaceMembers.clear();
          _loggedInMember.value = null;
          _invitations.clear();
        }
      });
    }
  }
  void _listenToProjects() {
    final workspaceId = currentWorkspace.value?.id ?? '';
    _projectsSubscription?.cancel();

    if (workspaceId.isEmpty) {
      projects.clear();
      return;
    }

    _projectsSubscription = _databaseService.watchProjects(
      workspaceId: workspaceId,
    ).listen(
          (projects) {
        this.projects
          ..clear()
          ..addAll(projects);
      },
      onError: (_) {
      },
    );
  }

  /// Load user's workspaces
  Future<void> _loadCurrentWorkspaces() async {
    await _executeAsync(() async {
      if (_userId.isEmpty) {
        _errorMessage.value = AppStrings.I.errorOccurred;
        return;
      }

      // Hydrate current workspace from cache (fast path) before fetching list
      final currentWorkspaceResult =
          await _workspaceRepository.getCurrentWorkspace(_userId);

      Workspace? cachedWorkspace;
      currentWorkspaceResult.fold(
        (failure) => _errorMessage.value = failure.message,
        (workspace) => cachedWorkspace = workspace,
      );

      if (cachedWorkspace != null) {
        await _setCurrentWorkspaceAndMembers(cachedWorkspace!);
      }

      final result = await _workspaceRepository.getUserWorkspaces(_userId);

      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (workspaces) async {
          _workspaces.value = workspaces;
          if (workspaces.isNotEmpty && _currentWorkspace.value == null) {
            await _setCurrentWorkspaceAndMembers(workspaces.first);
          }
        },
      );
    });
  }


  /// Load workspace members by workspaceId
  Future<void> _loadWorkspaceMembers(String workspaceId) async {
    final result = await _workspaceRepository.getWorkspaceMembers(workspaceId);

    result.fold(
          (failure) => _errorMessage.value = failure.message,
          (members) {
        _workspaceMembers.value = members;
        _updateLoggedInMember();
      },
    );
  }

  Future<void> _setCurrentWorkspaceAndMembers(Workspace workspace) async {
    _currentWorkspace.value = workspace;
    _storageService.setWorkspaceId(workspace.id);

    _listenToProjects();
    _loadWorkspaceMembers(workspace.id);

  }

  Future<void> loadCurrentWorkspaces() async {
    await _loadCurrentWorkspaces();
    _listenToProjects();
  }

  /// Create a new workspace
  Future<void> createWorkspace({
    required String name,
    required WorkspaceType type,
    String? description,
    Map<String, dynamic>? settings,
  }) async {
    await _executeAsync(() async {
      if (_userId.isEmpty) {
        _errorMessage.value = AppStrings.I.errorOccurred;
        return;
      }

      final params = CreateWorkspaceParams(
        name: name,
        type: type,
        description: description,
        createdBy: _userId,
        settings: settings,
      );

      final result = await _createWorkspace.call(params);

      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (workspace) {
          _workspaces.add(workspace);
          _setCurrentWorkspaceAndMembers(workspace);
          NavigationService().back<void>();
          SnackbarService().showSuccess(
            title: AppStrings.I.success,
            message: AppStrings.I.workspaceCreatedSuccessfully,
          );
        },
      );
    });
  }

  /// Switch to a different workspace
  Future<void> switchToWorkspace(String workspaceId) async {
    if (_currentWorkspace.value?.id == workspaceId) return;

    await _executeAsync(() async {
      if (_userId.isEmpty) {
        _errorMessage.value = AppStrings.I.errorOccurred;
        return;
      }

      final params = SwitchWorkspaceParams(
        userId: _userId,
        workspaceId: workspaceId,
      );

      final result = await _switchWorkspace.call(params);

      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (_) {
          final workspace =
              _workspaces.firstWhereOrNull((w) => w.id == workspaceId);
          if (workspace != null) {
            _setCurrentWorkspaceAndMembers(workspace);
          }
        },
      );
    });
  }

  /// Load workspace members (public wrapper uses current workspace)
  Future<void> loadWorkspaceMembers() async {
    final workspaceId = _currentWorkspace.value?.id;
    if (workspaceId == null || workspaceId.isEmpty) return;
    await _loadWorkspaceMembers(workspaceId);
  }

  void _updateLoggedInMember() {
    if (_userId.isEmpty) {
      _loggedInMember.value = null;
      return;
    }
    _loggedInMember.value = _workspaceMembers
        .firstWhereOrNull((member) => member.userId == _userId);
  }

  /// Load invitations for current workspace
  Future<void> loadInvitations() async {
    final workspaceId = _currentWorkspace.value?.id;
    if (workspaceId == null || workspaceId.isEmpty) return;
    await _executeAsync(() async {
      final result = await _workspaceRepository.listInvitations(workspaceId);
      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (list) => _invitations.value = list,
      );
    });
  }

  /// Set or clear a member's manager
  Future<void> setManager(
      {required String userId, String? managerUserId}) async {
    // Permission: manage users
    final canManageUsers = await hasPermission('manage_users');
    if (!canManageUsers) {
      SnackbarService().showError(
          title: AppStrings.I.error, message: AppStrings.I.permissionDenied);
      return;
    }
    final workspaceId = _currentWorkspace.value?.id;
    if (workspaceId == null || workspaceId.isEmpty) return;

    await _executeAsync(() async {
      final result = await _workspaceRepository.updateManager(
        workspaceId: workspaceId,
        userId: userId,
        managerUserId: managerUserId,
      );
      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (member) {
          final idx = _workspaceMembers.indexWhere((m) => m.userId == userId);
          if (idx >= 0) {
            _workspaceMembers[idx] = member;
          }
        },
      );
    });
  }

  /// Load team members for a manager
  Future<List<WorkspaceMember>> loadTeam(String managerUserId) async {
    final workspaceId = _currentWorkspace.value?.id;
    if (workspaceId == null || workspaceId.isEmpty) return <WorkspaceMember>[];
    final result = await _workspaceRepository.listTeam(
      workspaceId: workspaceId,
      managerUserId: managerUserId,
    );
    return result.fold((_) => <WorkspaceMember>[], (list) => list);
  }

  /// Check if current user can view target user's data based on hierarchy
  bool canViewUserData(String targetUserId) {
    final ws = _currentWorkspace.value;
    if (_userId.isEmpty || ws == null) {
      return false;
    }

    if (targetUserId == _userId) return true; // self access

    final me =
        _workspaceMembers.firstWhereOrNull((m) => m.userId == _userId);
    if (me == null) return false;
    if (me.isAdmin || me.isAccountHolder) return true;

    // Direct manager rule: I can view users whose managerUserId == my userId
    final target =
        _workspaceMembers.firstWhereOrNull((m) => m.userId == targetUserId);
    if (target == null) return false;
    return target.managerUserId == _userId;
  }

  /// Send invitation to email for current workspace
  Future<void> inviteUserToWorkspace(String email, {String? role, required String name}) async {
    final canInvite = await hasPermission('invite_users');
    if (!canInvite) {
      SnackbarService().showError(title: AppStrings.I.error, message: AppStrings.I.permissionDenied);
      return;
    }
    final workspace = _currentWorkspace.value;
    final workspaceId = workspace?.id;
    final workspaceName = workspace?.name ?? '';
    if (workspaceId == null || workspaceId.isEmpty) return;

    final authController = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;

    final inviterName = authController?.currentUser?.displayName ?? '';
    debugPrint(authController?.currentUser?.displayName ?? '');

    await _executeAsync(() async {
      final result = await _workspaceRepository.sendInvitation(
        workspaceId: workspaceId,
        workspaceName: workspaceName,
        email: email.trim(),
        role: role ?? WorkspaceRole.member.value,
        name: name.trim(),
        inviterName: inviterName,
      );
      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (inv) {
          _invitations.add(inv);
          SnackbarService().showSuccess(title: AppStrings.I.success, message: AppStrings.I.invitationSent);
        },
      );
    });
  }

  /// Revoke an invitation by id
  Future<void> revokeInvitation(String invitationId) async {
    final canInvite = await hasPermission('invite_users');
    if (!canInvite) {
      SnackbarService().showError(
          title: AppStrings.I.error, message: AppStrings.I.permissionDenied);
      return;
    }
    final workspaceId = _currentWorkspace.value?.id;
    if (workspaceId == null || workspaceId.isEmpty) return;

    await _executeAsync(() async {
      final result = await _workspaceRepository.revokeInvitation(
        workspaceId: workspaceId,
        invitationId: invitationId,
      );
      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (_) {
          final idx = _invitations.indexWhere((i) => i.id == invitationId);
          if (idx >= 0) {
            _invitations[idx] = _invitations[idx]
                .copyWith(isRevoked: true, revokedAt: DateTime.now(), isWaiting: true);
          }
        },
      );
    });
  }


  /// Update user role in workspace
  Future<void> updateUserRole(String userId, String newRoleDisplay) async {
    // Permission: manage users
    final canManageUsers = await hasPermission('manage_users');
    if (!canManageUsers) {
      SnackbarService().showError(
          title: AppStrings.I.error, message: AppStrings.I.permissionDenied);
      return;
    }
    final workspaceId = _currentWorkspace.value?.id;
    if (workspaceId == null) return;

    final role = newRoleDisplay.toLowerCase() == 'admin'
        ? WorkspaceRole.admin
        : WorkspaceRole.member;

    // Fetch existing member or create baseline
    final existing =
        _workspaceMembers.firstWhereOrNull((m) => m.userId == userId);

    if (existing == null) {
      SnackbarService().showError(
        title: AppStrings.I.error,
        message: AppStrings.I.failedToUpdateRole,
      );
      return;
    }

    final updated = existing.copyWith(role: role);

    await _executeAsync(() async {
      // Use updateMemberPermissions to persist role changes if repository supports dedicated method; otherwise reuse addMember semantics
      final result = await _workspaceRepository.updateMemberPermissions(
        workspaceId,
        userId,
        updated.permissions,
      );
      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (member) {
          final idx = _workspaceMembers.indexWhere((m) => m.userId == userId);
          if (idx >= 0) {
            _workspaceMembers[idx] = member.copyWith(role: role);
          }
        },
      );
    });
  }

  /// Remove user from workspace
  Future<void> removeUserFromWorkspace(String userId) async {
    // Permission: remove users
    final canRemove = await hasPermission('remove_users');
    if (!canRemove) {
      SnackbarService().showError(
          title: AppStrings.I.error, message: AppStrings.I.permissionDenied);
      return;
    }
    final workspaceId = _currentWorkspace.value?.id;
    if (workspaceId == null) return;

    await _executeAsync(() async {
      final result =
          await _workspaceRepository.removeMember(workspaceId, userId);
      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (_) {
          _workspaceMembers.removeWhere((m) => m.userId == userId);
        },
      );
    });
  }

  /// Grant a permission to a user
  Future<void> grantPermission(String userId, String permissionId) async {
    await _togglePermission(userId, permissionId, true);
  }

  /// Revoke a permission from a user
  Future<void> revokePermission(String userId, String permissionId) async {
    await _togglePermission(userId, permissionId, false);
  }

  Future<void> _togglePermission(
      String userId, String permissionId, bool grant) async {
    // Permission: assign permissions
    final canAssign = await hasPermission('assign_permissions');
    if (!canAssign) {
      SnackbarService().showError(
          title: AppStrings.I.error, message: AppStrings.I.permissionDenied);
      return;
    }
    final workspaceId = _currentWorkspace.value?.id;
    if (workspaceId == null) return;

    final memberIndex = _workspaceMembers.indexWhere((m) => m.userId == userId);
    if (memberIndex < 0) return;
    final current = _workspaceMembers[memberIndex];
    final updatedPermissions = List<String>.from(current.permissions);
    if (grant) {
      if (!updatedPermissions.contains(permissionId)) {
        updatedPermissions.add(permissionId);
      }
    } else {
      updatedPermissions.remove(permissionId);
    }

    await _executeAsync(() async {
      final result = await _workspaceRepository.updateMemberPermissions(
        workspaceId,
        userId,
        updatedPermissions,
      );
      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (member) {
          _workspaceMembers[memberIndex] = member;
        },
      );
    });
  }

  /// Update current workspace settings (name/description/logo)
  Future<void> updateWorkspaceSettings({
    required String name,
    String? description,
    String? logoUrl,
  }) async {
    // Permission: manage workspace
    final canManage = await hasPermission('manage_workspace');
    if (!canManage) {
      SnackbarService().showError(
          title: AppStrings.I.error, message: AppStrings.I.permissionDenied);
      return;
    }
    final current = _currentWorkspace.value;
    if (current == null) return;
    final updated = current.copyWith(
      name: name,
      description: description,
      logoUrl: logoUrl,
      updatedAt: DateTime.now(),
    );
    await updateWorkspace(updated);
  }

  /// Delete current workspace convenience
  Future<void> deleteCurrentWorkspace() async {
    final id = _currentWorkspace.value?.id;
    if (id == null) return;
    await deleteWorkspace(id);
  }

  /// Update workspace
  Future<void> updateWorkspace(Workspace workspace) async {
    await _executeAsync(() async {
      final result = await _workspaceRepository.updateWorkspace(workspace);

      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (updatedWorkspace) {
          final index =
              _workspaces.indexWhere((w) => w.id == updatedWorkspace.id);
          if (index != -1) {
            _workspaces[index] = updatedWorkspace;
            if (_currentWorkspace.value?.id == updatedWorkspace.id) {
              _setCurrentWorkspaceAndMembers(updatedWorkspace);
            }
          }
          SnackbarService().showSuccess(
            title: AppStrings.I.success,
            message: AppStrings.I.workspaceUpdatedSuccessfully,
          );
        },
      );
    });
  }

  /// Delete workspace
  Future<void> deleteWorkspace(String workspaceId) async {
    // Permission: manage workspace
    final canManage = await hasPermission('manage_workspace');
    if (!canManage) {
      SnackbarService().showError(
          title: AppStrings.I.error, message: AppStrings.I.permissionDenied);
      return;
    }
    await _executeAsync(() async {
      final result = await _workspaceRepository.deleteWorkspace(workspaceId);

      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (_) {
          _workspaces.removeWhere((w) => w.id == workspaceId);
          if (_currentWorkspace.value?.id == workspaceId) {
            _currentWorkspace.value =
                _workspaces.isNotEmpty ? _workspaces.first : null;
          }
          SnackbarService().showSuccess(
            title: AppStrings.I.success,
            message: AppStrings.I.workspaceDeletedSuccessfully,
          );
        },
      );
    });
  }

  /// Check if user has permission in current workspace
  Future<bool> hasPermission(String permission) async {
    if (_currentWorkspace.value == null) return false;
    if (_userId.isEmpty) return false;

    final result = await _workspaceRepository.hasPermission(
      _userId,
      _currentWorkspace.value!.id,
      permission,
    );

    return result.fold(
      (failure) => false,
      (hasPermission) => hasPermission,
    );
  }

  /// Get user's permissions in current workspace
  Future<List<String>> getUserPermissions() async {
    if (_currentWorkspace.value == null) return [];
    if (_userId.isEmpty) return <String>[];

    final result = await _workspaceRepository.getUserPermissions(
      _userId,
      _currentWorkspace.value!.id,
    );

    return result.fold(
      (failure) => [],
      (permissions) => permissions,
    );
  }

  /// Get user's role in current workspace
  Future<WorkspaceMember?> getUserWorkspaceRole() async {
    if (_currentWorkspace.value == null) return null;
    if (_userId.isEmpty) return null;

    final result = await _workspaceRepository.getUserWorkspaceRole(
      _userId,
      _currentWorkspace.value!.id,
    );

    return result.fold(
      (failure) => null,
      (userRole) => userRole,
    );
  }

  /// Execute async operation with loading state
  Future<void> _executeAsync(Future<void> Function() operation) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      await operation();
    } catch (e) {
      _errorMessage.value = e.toString();
      SnackbarService().showError(
        title: AppStrings.I.error,
        message: e.toString(),
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
