import 'package:dartz/dartz.dart';
import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/core/usecases/usecase.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_settings.dart';
import 'package:todolist/features/workspace/domain/repositories/workspace_repository.dart';

/// Use case for updating workspace settings
class UpdateWorkspaceSettings implements UseCase<Workspace, UpdateWorkspaceSettingsParams> {
  final WorkspaceRepository repository;

  UpdateWorkspaceSettings(this.repository);

  @override
  Future<Either<Failure, Workspace>> call(UpdateWorkspaceSettingsParams params) async {
    // Get current workspace
    final workspaceResult = await repository.getWorkspace(params.workspaceId);
    
    return workspaceResult.fold(
      (failure) => Left(failure),
      (workspace) async {
        // Update workspace with new settings
        final updatedWorkspace = workspace.copyWith(
          settings: params.settings.toMap(),
          updatedAt: DateTime.now(),
        );

        // Save updated workspace
        final updateResult = await repository.updateWorkspace(updatedWorkspace);
        
        return updateResult.fold(
          (failure) => Left(failure),
          (updated) => Right(updated),
        );
      },
    );
  }
}

/// Parameters for updating workspace settings
class UpdateWorkspaceSettingsParams {
  final String workspaceId;
  final WorkspaceSettings settings;

  UpdateWorkspaceSettingsParams({
    required this.workspaceId,
    required this.settings,
  });
}
