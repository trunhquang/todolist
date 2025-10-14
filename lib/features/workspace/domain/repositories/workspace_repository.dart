import 'package:dartz/dartz.dart';
import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';

/// Workspace repository interface following Clean Architecture
abstract class WorkspaceRepository {
  /// Create a new workspace
  Future<Either<Failure, Workspace>> createWorkspace(Workspace workspace);

  /// Get workspace by ID
  Future<Either<Failure, Workspace>> getWorkspace(String workspaceId);

  /// Get all workspaces for a user
  Future<Either<Failure, List<Workspace>>> getUserWorkspaces(String userId);

  /// Update workspace
  Future<Either<Failure, Workspace>> updateWorkspace(Workspace workspace);

  /// Delete workspace
  Future<Either<Failure, void>> deleteWorkspace(String workspaceId);

  /// Switch to a workspace
  Future<Either<Failure, void>> switchToWorkspace(String userId, String workspaceId);

  /// Get current workspace for user
  Future<Either<Failure, Workspace?>> getCurrentWorkspace(String userId);

  /// Add member to workspace
  Future<Either<Failure, WorkspaceMember>> addMember(WorkspaceMember member);

  /// Remove member from workspace
  Future<Either<Failure, void>> removeMember(String workspaceId, String userId);

  /// Update member permissions
  Future<Either<Failure, WorkspaceMember>> updateMemberPermissions(
    String workspaceId,
    String userId,
    List<String> permissions,
  );

  /// Get workspace members
  Future<Either<Failure, List<WorkspaceMember>>> getWorkspaceMembers(String workspaceId);

  /// Get user's role in workspace
  Future<Either<Failure, WorkspaceMember?>> getUserWorkspaceRole(
    String userId,
    String workspaceId,
  );

  /// Check if user has permission in workspace
  Future<Either<Failure, bool>> hasPermission(
    String userId,
    String workspaceId,
    String permission,
  );

  /// Get user's permissions in workspace
  Future<Either<Failure, List<String>>> getUserPermissions(
    String userId,
    String workspaceId,
  );
}
