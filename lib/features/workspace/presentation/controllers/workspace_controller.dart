import 'package:get/get.dart';
import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';
import 'package:todolist/features/workspace/domain/usecases/create_workspace.dart';
import 'package:todolist/features/workspace/domain/usecases/switch_workspace.dart';
import 'package:todolist/features/workspace/domain/repositories/workspace_repository.dart';

/// Workspace controller following GetX patterns
class WorkspaceController extends GetxController {
  final CreateWorkspace _createWorkspace;
  final SwitchWorkspace _switchWorkspace;
  final WorkspaceRepository _workspaceRepository;

  WorkspaceController({
    CreateWorkspace? createWorkspace,
    SwitchWorkspace? switchWorkspace,
    required WorkspaceRepository workspaceRepository,
  })  : _workspaceRepository = workspaceRepository,
        _createWorkspace = createWorkspace ?? CreateWorkspace(workspaceRepository),
        _switchWorkspace = switchWorkspace ?? SwitchWorkspace(workspaceRepository);

  // Private observables
  final _isLoading = false.obs;
  final _workspaces = <Workspace>[].obs;
  final _currentWorkspace = Rxn<Workspace>();
  final _workspaceMembers = <WorkspaceMember>[].obs;
  final _errorMessage = ''.obs;

  // Public getters
  bool get isLoading => _isLoading.value;
  List<Workspace> get workspaces => _workspaces;
  Rxn<Workspace> get currentWorkspace => _currentWorkspace;
  List<WorkspaceMember> get workspaceMembers => _workspaceMembers;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    _loadUserWorkspaces();
  }

  /// Load user's workspaces
  Future<void> _loadUserWorkspaces() async {
    await _executeAsync(() async {
      // TODO: Get current user ID from auth service
      const userId = 'current_user_id'; // Replace with actual user ID
      
      final result = await _workspaceRepository.getUserWorkspaces(userId);
      
      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (workspaces) {
          _workspaces.value = workspaces;
          if (workspaces.isNotEmpty && _currentWorkspace.value == null) {
            _currentWorkspace.value = workspaces.first;
          }
        },
      );
    });
  }

  /// Public wrapper for tests to trigger loading
  Future<void> loadUserWorkspaces() async {
    await _loadUserWorkspaces();
  }

  /// Create a new workspace
  Future<void> createWorkspace({
    required String name,
    required WorkspaceType type,
    String? description,
    Map<String, dynamic>? settings,
  }) async {
    await _executeAsync(() async {
      // TODO: Get current user ID from auth service
      const userId = 'current_user_id'; // Replace with actual user ID
      
      final params = CreateWorkspaceParams(
        name: name,
        type: type,
        description: description,
        createdBy: userId,
        settings: settings,
      );

      final result = await _createWorkspace.call(params);

      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (workspace) {
          _workspaces.add(workspace);
          _currentWorkspace.value = workspace;
          SnackbarService().showSuccess(
            title: AppStrings.success,
            message: AppStrings.workspaceCreatedSuccessfully,
          );
        },
      );
    });
  }

  /// Switch to a different workspace
  Future<void> switchToWorkspace(String workspaceId) async {
    if (_currentWorkspace.value?.id == workspaceId) return;

    await _executeAsync(() async {
      // TODO: Get current user ID from auth service
      const userId = 'current_user_id'; // Replace with actual user ID
      
      final params = SwitchWorkspaceParams(
        userId: userId,
        workspaceId: workspaceId,
      );

      final result = await _switchWorkspace.call(params);

      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (_) {
          final workspace = _workspaces.firstWhereOrNull((w) => w.id == workspaceId);
          if (workspace != null) {
            _currentWorkspace.value = workspace;
            _loadWorkspaceMembers(workspaceId);
            SnackbarService().showSuccess(
              title: AppStrings.success,
              message: AppStrings.switchWorkspace,
            );
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

  /// Load workspace members by workspaceId
  Future<void> _loadWorkspaceMembers(String workspaceId) async {
    final result = await _workspaceRepository.getWorkspaceMembers(workspaceId);
    
    result.fold(
      (failure) => _errorMessage.value = failure.message,
      (members) => _workspaceMembers.value = members,
    );
  }

  /// Invite user to workspace by email (delegates to repository addMember after resolving userId)
  Future<void> inviteUserToWorkspace(String email) async {
    // TODO: Resolve userId by email via user service. Using placeholder.
    const String invitedUserId = 'invited_user_id';
    final String? workspaceId = _currentWorkspace.value?.id;
    if (workspaceId == null) return;

    final WorkspaceMember member = WorkspaceMember(
      userId: invitedUserId,
      workspaceId: workspaceId,
      role: WorkspaceRole.member,
      permissions: const <String>[],
      assignedBy: 'current_user_id',
      assignedAt: DateTime.now(),
    );

    await _executeAsync(() async {
      final result = await _workspaceRepository.addMember(member);
      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (created) {
          _workspaceMembers.add(created);
        },
      );
    });
  }

  /// Update user role in workspace
  Future<void> updateUserRole(String userId, String newRoleDisplay) async {
    final String? workspaceId = _currentWorkspace.value?.id;
    if (workspaceId == null) return;

    final WorkspaceRole role = newRoleDisplay.toLowerCase() == 'admin'
        ? WorkspaceRole.admin
        : WorkspaceRole.member;

    // Fetch existing member or create baseline
    final existing = _workspaceMembers.firstWhereOrNull((m) => m.userId == userId);
    final WorkspaceMember updated = (existing ?? WorkspaceMember(
      userId: userId,
      workspaceId: workspaceId,
      role: role,
      permissions: const <String>[],
      assignedBy: 'current_user_id',
      assignedAt: DateTime.now(),
    )).copyWith(role: role);

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
    final String? workspaceId = _currentWorkspace.value?.id;
    if (workspaceId == null) return;

    await _executeAsync(() async {
      final result = await _workspaceRepository.removeMember(workspaceId, userId);
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

  Future<void> _togglePermission(String userId, String permissionId, bool grant) async {
    final String? workspaceId = _currentWorkspace.value?.id;
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
          final index = _workspaces.indexWhere((w) => w.id == updatedWorkspace.id);
          if (index != -1) {
            _workspaces[index] = updatedWorkspace;
            if (_currentWorkspace.value?.id == updatedWorkspace.id) {
              _currentWorkspace.value = updatedWorkspace;
            }
          }
          SnackbarService().showSuccess(
            title: AppStrings.success,
            message: AppStrings.workspaceUpdatedSuccessfully,
          );
        },
      );
    });
  }

  /// Delete workspace
  Future<void> deleteWorkspace(String workspaceId) async {
    await _executeAsync(() async {
      final result = await _workspaceRepository.deleteWorkspace(workspaceId);

      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (_) {
          _workspaces.removeWhere((w) => w.id == workspaceId);
          if (_currentWorkspace.value?.id == workspaceId) {
            _currentWorkspace.value = _workspaces.isNotEmpty ? _workspaces.first : null;
          }
          SnackbarService().showSuccess(
            title: AppStrings.success,
            message: AppStrings.workspaceDeletedSuccessfully,
          );
        },
      );
    });
  }

  /// Check if user has permission in current workspace
  Future<bool> hasPermission(String permission) async {
    if (_currentWorkspace.value == null) return false;
    
    // TODO: Get current user ID from auth service
    const userId = 'current_user_id'; // Replace with actual user ID
    
    final result = await _workspaceRepository.hasPermission(
      userId,
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
    
    // TODO: Get current user ID from auth service
    const userId = 'current_user_id'; // Replace with actual user ID
    
    final result = await _workspaceRepository.getUserPermissions(
      userId,
      _currentWorkspace.value!.id,
    );

    return result.fold(
      (failure) => [],
      (permissions) => permissions,
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
        title: AppStrings.error,
        message: e.toString(),
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
