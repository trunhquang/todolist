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
    required CreateWorkspace createWorkspace,
    required SwitchWorkspace switchWorkspace,
    required WorkspaceRepository workspaceRepository,
  })  : _createWorkspace = createWorkspace,
        _switchWorkspace = switchWorkspace,
        _workspaceRepository = workspaceRepository;

  // Private observables
  final _isLoading = false.obs;
  final _workspaces = <Workspace>[].obs;
  final _currentWorkspace = Rxn<Workspace>();
  final _workspaceMembers = <WorkspaceMember>[].obs;
  final _errorMessage = ''.obs;

  // Public getters
  bool get isLoading => _isLoading.value;
  List<Workspace> get workspaces => _workspaces;
  Workspace? get currentWorkspace => _currentWorkspace.value;
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

  /// Load workspace members
  Future<void> _loadWorkspaceMembers(String workspaceId) async {
    final result = await _workspaceRepository.getWorkspaceMembers(workspaceId);
    
    result.fold(
      (failure) => _errorMessage.value = failure.message,
      (members) => _workspaceMembers.value = members,
    );
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
