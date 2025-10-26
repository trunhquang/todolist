import 'package:dartz/dartz.dart';
import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/core/usecases/usecase.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_settings.dart';
import 'package:todolist/features/workspace/domain/repositories/workspace_repository.dart';

/// Use case for updating workspace settings
class UpdateWorkspaceSettings implements UseCase<Workspace, UpdateWorkspaceSettingsParams> {

  UpdateWorkspaceSettings(this.repository);
  final WorkspaceRepository repository;

  @override
  Future<Either<Failure, Workspace>> call(UpdateWorkspaceSettingsParams params) async {
    // Get current workspace
    final workspaceResult = await repository.getWorkspace(params.workspaceId);
    
    return workspaceResult.fold(
      Left.new,
      (workspace) async {
        // Update workspace with new settings
        final updatedWorkspace = workspace.copyWith(
          settings: params.settings.toMap(),
          updatedAt: DateTime.now(),
        );

        // Save updated workspace
        final updateResult = await repository.updateWorkspace(updatedWorkspace);
        
        return updateResult.fold(
          Left.new,
          Right.new,
        );
      },
    );
  }
}

/// Parameters for updating workspace settings
class UpdateWorkspaceSettingsParams {

  UpdateWorkspaceSettingsParams({
    required this.workspaceId,
    required this.settings,
  });
  final String workspaceId;
  final WorkspaceSettings settings;
}
