import 'package:dartz/dartz.dart';
import 'package:todolist/core/errors/exceptions.dart';
import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/core/services/storage_service.dart';
import 'package:todolist/features/workspace/data/datasources/workspace_local_data_source.dart';
import 'package:todolist/features/workspace/data/datasources/workspace_remote_data_source.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_permissions.dart';
import 'package:todolist/features/workspace/domain/repositories/workspace_repository.dart';

/// Workspace repository implementation following Clean Architecture
class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final WorkspaceRemoteDataSource _remoteDataSource;
  final WorkspaceLocalDataSource _localDataSource;
  final StorageService _storageService;

  WorkspaceRepositoryImpl({
    required WorkspaceRemoteDataSource remoteDataSource,
    required WorkspaceLocalDataSource localDataSource,
    required StorageService storageService,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _storageService = storageService;

  @override
  Future<Either<Failure, Workspace>> createWorkspace(Workspace workspace) async {
    try {
      final workspaceId = await _remoteDataSource.createWorkspace(workspace);
      final createdWorkspace = workspace.copyWith(id: workspaceId);
      
      // Cache the created workspace
      await _localDataSource.cacheCurrentWorkspace(createdWorkspace);
      
      return Right(createdWorkspace);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to create workspace: $e'));
    }
  }

  @override
  Future<Either<Failure, Workspace>> getWorkspace(String workspaceId) async {
    try {
      // Try to get from cache first
      final cachedWorkspace = await _localDataSource.getCachedCurrentWorkspace();
      if (cachedWorkspace?.id == workspaceId) {
        return Right(cachedWorkspace!);
      }

      // Get from remote
      final workspace = await _remoteDataSource.getWorkspace(workspaceId);
      if (workspace == null) {
        return Left(NotFoundFailure(message: 'Workspace not found'));
      }

      // Cache the workspace
      await _localDataSource.cacheCurrentWorkspace(workspace);

      return Right(workspace);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to get workspace: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Workspace>>> getUserWorkspaces(String userId) async {
    try {
      // Try to get from cache first
      final cachedWorkspaces = await _localDataSource.getCachedWorkspaces();
      if (cachedWorkspaces.isNotEmpty) {
        return Right(cachedWorkspaces);
      }

      // Get from remote
      final workspaces = await _remoteDataSource.getUserWorkspaces(userId);

      // Cache the workspaces
      await _localDataSource.cacheWorkspaces(workspaces);

      return Right(workspaces);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to get user workspaces: $e'));
    }
  }

  @override
  Future<Either<Failure, Workspace>> updateWorkspace(Workspace workspace) async {
    try {
      await _remoteDataSource.updateWorkspace(workspace);
      
      // Update cache
      await _localDataSource.cacheCurrentWorkspace(workspace);
      
      return Right(workspace);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to update workspace: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWorkspace(String workspaceId) async {
    try {
      await _remoteDataSource.deleteWorkspace(workspaceId);
      
      // Clear cache
      await _localDataSource.clearCache();
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to delete workspace: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> switchToWorkspace(String userId, String workspaceId) async {
    try {
      // Save current workspace to local storage
      await _storageService.setCompanyId(workspaceId);
      
      // Update user preferences in Firebase
      await _remoteDataSource.switchToWorkspace(userId, workspaceId);
      
      // Get and cache the new workspace
      final workspace = await _remoteDataSource.getWorkspace(workspaceId);
      if (workspace != null) {
        await _localDataSource.cacheCurrentWorkspace(workspace);
      }
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to switch workspace: $e'));
    }
  }

  @override
  Future<Either<Failure, Workspace?>> getCurrentWorkspace(String userId) async {
    try {
      // Try to get from cache first
      final cachedWorkspace = await _localDataSource.getCachedCurrentWorkspace();
      if (cachedWorkspace != null) {
        return Right(cachedWorkspace);
      }

      // Get from remote
      final workspace = await _remoteDataSource.getCurrentWorkspace(userId);
      
      // Cache the workspace
      if (workspace != null) {
        await _localDataSource.cacheCurrentWorkspace(workspace);
      }
      
      return Right(workspace);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to get current workspace: $e'));
    }
  }

  @override
  Future<Either<Failure, WorkspaceMember>> addMember(WorkspaceMember member) async {
    try {
      await _remoteDataSource.addMember(member);
      
      // Update cache
      final members = await _remoteDataSource.getWorkspaceMembers(member.workspaceId);
      await _localDataSource.cacheWorkspaceMembers(member.workspaceId, members);
      
      return Right(member);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to add member: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removeMember(String workspaceId, String userId) async {
    try {
      await _remoteDataSource.removeMember(workspaceId, userId);
      
      // Update cache
      final members = await _remoteDataSource.getWorkspaceMembers(workspaceId);
      await _localDataSource.cacheWorkspaceMembers(workspaceId, members);
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to remove member: $e'));
    }
  }

  @override
  Future<Either<Failure, WorkspaceMember>> updateMemberPermissions(
    String workspaceId,
    String userId,
    List<String> permissions,
  ) async {
    try {
      await _remoteDataSource.updateMemberPermissions(workspaceId, userId, permissions);
      
      // Get updated member
      final member = await _remoteDataSource.getUserWorkspaceRole(userId, workspaceId);
      if (member == null) {
        return Left(NotFoundFailure(message: 'Member not found'));
      }
      
      // Update cache
      final members = await _remoteDataSource.getWorkspaceMembers(workspaceId);
      await _localDataSource.cacheWorkspaceMembers(workspaceId, members);
      
      return Right(member);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to update member permissions: $e'));
    }
  }

  @override
  Future<Either<Failure, List<WorkspaceMember>>> getWorkspaceMembers(String workspaceId) async {
    try {
      // Try to get from cache first
      final cachedMembers = await _localDataSource.getCachedWorkspaceMembers(workspaceId);
      if (cachedMembers.isNotEmpty) {
        return Right(cachedMembers);
      }

      // Get from remote
      final members = await _remoteDataSource.getWorkspaceMembers(workspaceId);
      
      // Cache the members
      await _localDataSource.cacheWorkspaceMembers(workspaceId, members);
      
      return Right(members);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to get workspace members: $e'));
    }
  }

  @override
  Future<Either<Failure, WorkspaceMember?>> getUserWorkspaceRole(
    String userId,
    String workspaceId,
  ) async {
    try {
      final member = await _remoteDataSource.getUserWorkspaceRole(userId, workspaceId);
      return Right(member);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to get user workspace role: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasPermission(
    String userId,
    String workspaceId,
    String permission,
  ) async {
    try {
      final memberResult = await getUserWorkspaceRole(userId, workspaceId);
      return memberResult.fold(
        (failure) => Left(failure),
        (member) {
          if (member == null || !member.isActive) {
            return const Right(false);
          }
          return Right(member.hasPermission(permission));
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to check permission: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getUserPermissions(
    String userId,
    String workspaceId,
  ) async {
    try {
      final memberResult = await getUserWorkspaceRole(userId, workspaceId);
      return memberResult.fold(
        (failure) => Left(failure),
        (member) {
          if (member == null || !member.isActive) {
            return const Right(<String>[]);
          }
          return Right(member.permissions);
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to get user permissions: $e'));
    }
  }
}