import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/core/usecases/usecase.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_permissions.dart';
import 'package:todolist/features/workspace/domain/repositories/workspace_repository.dart';

/// Use case for creating a new workspace
class CreateWorkspace implements UseCase<Workspace, CreateWorkspaceParams> {

  CreateWorkspace(this.repository);
  final WorkspaceRepository repository;
  
  // Get AuthController to access current user name and email
  AuthController get _authController => Get.find<AuthController>();

  @override
  Future<Either<Failure, Workspace>> call(CreateWorkspaceParams params) async {
    // Create the workspace
    final workspace = Workspace(
      id: '', // Will be set by repository
      name: params.name,
      type: params.type,
      description: params.description,
      createdBy: params.createdBy,
      createdAt: DateTime.now(),
      settings: params.settings,
    );

    final result = await repository.createWorkspace(workspace);

    return result.fold(
      Left.new,
      (createdWorkspace) async {
        // Get current user name and email (required for WorkspaceMember)
        final currentUser = _authController.currentUser;
        if (currentUser == null) {
          return Left(ServerFailure(message: 'User not authenticated'));
        }
        
        final userName = currentUser.name.isNotEmpty 
            ? currentUser.name 
            : currentUser.email.isNotEmpty 
                ? currentUser.email 
                : params.createdBy;
        final userEmail = currentUser.email.isNotEmpty 
            ? currentUser.email 
            : '${params.createdBy}@unknown.com';
        
        // Add the creator as Account Holder
        final member = WorkspaceMember(
          userId: params.createdBy,
          workspaceId: createdWorkspace.id,
          role: WorkspaceRole.accountHolder,
          permissions: DefaultPermissionSets.accountHolderPermissions,
          assignedBy: params.createdBy,
          assignedAt: DateTime.now(),
          name: userName,
          email: userEmail,
        );

        final memberResult = await repository.addMember(member);

        return memberResult.fold(
          Left.new,
          (_) => Right(createdWorkspace),
        );
      },
    );
  }
}

/// Parameters for creating a workspace
class CreateWorkspaceParams {

  CreateWorkspaceParams({
    required this.name,
    required this.type,
    this.description,
    required this.createdBy,
    this.settings,
  });
  final String name;
  final WorkspaceType type;
  final String? description;
  final String createdBy;
  final Map<String, dynamic>? settings;
}
