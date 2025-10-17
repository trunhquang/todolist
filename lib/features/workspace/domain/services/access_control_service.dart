import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/core/services/storage_service.dart';
import 'package:todolist/features/workspace/domain/repositories/workspace_repository.dart';

/// Access control service for workspace permission checks
class AccessControlService {
  AccessControlService({
    required WorkspaceRepository workspaceRepository,
    StorageService? storageService,
    String Function()? currentWorkspaceIdProvider,
    String Function()? currentUserIdProvider,
  })  : _workspaceRepository = workspaceRepository,
        _storageService = storageService ?? StorageService(),
        _currentWorkspaceIdProvider = currentWorkspaceIdProvider,
        _currentUserIdProvider = currentUserIdProvider;

  final WorkspaceRepository _workspaceRepository;
  final StorageService _storageService;
  final String Function()? _currentWorkspaceIdProvider;
  final String Function()? _currentUserIdProvider;

  String? _getCurrentUserId() => _currentUserIdProvider?.call() ?? _storageService.getUserId();

  String? _getCurrentWorkspaceId() => _currentWorkspaceIdProvider?.call();

  /// Check if current user has a permission in current workspace
  Future<bool> has(String permission) async {
    final String? userId = _getCurrentUserId();
    final String? workspaceId = _getCurrentWorkspaceId();
    if (userId == null || userId.isEmpty || workspaceId == null || workspaceId.isEmpty) {
      return false;
    }
    final result = await _workspaceRepository.hasPermission(userId, workspaceId, permission);
    return result.fold((Failure _) => false, (bool allowed) => allowed);
  }

  /// Ensure current user has a permission, throw on denial
  Future<void> ensure(String permission) async {
    final allowed = await has(permission);
    if (!allowed) {
      throw PermissionFailure(message: AppStrings.permissionDenied);
    }
  }

  /// List permissions for current user in current workspace
  Future<List<String>> list() async {
    final String? userId = _getCurrentUserId();
    final String? workspaceId = _getCurrentWorkspaceId();
    if (userId == null || userId.isEmpty || workspaceId == null || workspaceId.isEmpty) {
      return <String>[];
    }
    final result = await _workspaceRepository.getUserPermissions(userId, workspaceId);
    return result.fold((Failure _) => <String>[], (List<String> permissions) => permissions);
  }
}


