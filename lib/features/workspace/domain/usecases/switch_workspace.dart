import 'package:dartz/dartz.dart';
import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/core/usecases/usecase.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_permissions.dart';
import 'package:todolist/features/workspace/domain/repositories/workspace_repository.dart';

/// Use case for switching to a different workspace
class SwitchWorkspace implements UseCase<void, SwitchWorkspaceParams> {

  SwitchWorkspace(this.repository);
  final WorkspaceRepository repository;

  @override
  Future<Either<Failure, void>> call(SwitchWorkspaceParams params) async {
    // Check if user has access to the workspace
    final hasAccessResult = await repository.hasPermission(
      params.userId,
      params.workspaceId,
      WorkspacePermissions.viewPersonalData, // Basic access permission
    );

    return hasAccessResult.fold(
      Left.new,
      (hasAccess) {
        if (!hasAccess) {
          return const Left(UnauthorizedFailure(message: 'User does not have access to this workspace'));
        }

        // Switch to the workspace
        return repository.switchToWorkspace(params.userId, params.workspaceId);
      },
    );
  }
}

/// Parameters for switching workspace
class SwitchWorkspaceParams {

  SwitchWorkspaceParams({
    required this.userId,
    required this.workspaceId,
  });
  final String userId;
  final String workspaceId;
}

/// Unauthorized failure for access control
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required super.message});
}
