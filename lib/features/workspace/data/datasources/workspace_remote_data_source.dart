import 'package:firebase_database/firebase_database.dart';
import 'package:todolist/core/errors/exceptions.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';

/// Remote data source for workspace operations
abstract class WorkspaceRemoteDataSource {
  Future<String> createWorkspace(Workspace workspace);
  Future<Workspace?> getWorkspace(String workspaceId);
  Future<List<Workspace>> getUserWorkspaces(String userId);
  Future<void> updateWorkspace(Workspace workspace);
  Future<void> deleteWorkspace(String workspaceId);
  Future<void> switchToWorkspace(String userId, String workspaceId);
  Future<Workspace?> getCurrentWorkspace(String userId);
  Future<void> addMember(WorkspaceMember member);
  Future<void> removeMember(String workspaceId, String userId);
  Future<void> updateMemberPermissions(String workspaceId, String userId, List<String> permissions);
  Future<List<WorkspaceMember>> getWorkspaceMembers(String workspaceId);
  Future<WorkspaceMember?> getUserWorkspaceRole(String userId, String workspaceId);
}

/// Firebase implementation of workspace remote data source
class WorkspaceRemoteDataSourceImpl implements WorkspaceRemoteDataSource {
  final FirebaseDatabase _database;

  WorkspaceRemoteDataSourceImpl({required FirebaseDatabase database}) : _database = database;

  @override
  Future<String> createWorkspace(Workspace workspace) async {
    try {
      final workspacesRef = _database.ref('workspaces');
      final workspaceRef = workspacesRef.push();
      final workspaceId = workspaceRef.key!;
      
      await workspaceRef.set(workspace.copyWith(id: workspaceId).toMap());
      
      return workspaceId;
    } catch (e) {
      throw ServerException(message:'Failed to create workspace: $e');
    }
  }

  @override
  Future<Workspace?> getWorkspace(String workspaceId) async {
    try {
      final workspaceRef = _database.ref('workspaces/$workspaceId');
      final snapshot = await workspaceRef.get();
      
      if (!snapshot.exists) return null;
      
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return null;
      
      return Workspace.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      throw ServerException(message:'Failed to get workspace: $e');
    }
  }

  @override
  Future<List<Workspace>> getUserWorkspaces(String userId) async {
    try {
      final workspacesRef = _database.ref('workspaces');
      final snapshot = await workspacesRef.get();
      
      if (!snapshot.exists) return [];
      
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      
      final workspaces = <Workspace>[];
      
      // Get workspaces created by user
      for (final entry in data.entries) {
        final workspaceData = entry.value as Map<dynamic, dynamic>;
        if (workspaceData['createdBy'] == userId) {
          workspaces.add(Workspace.fromMap(Map<String, dynamic>.from(workspaceData)));
        }
      }
      
      // Get workspaces where user is a member
      final membersRef = _database.ref('workspace_members');
      final membersSnapshot = await membersRef.get();
      
      if (membersSnapshot.exists) {
        final membersData = membersSnapshot.value as Map<dynamic, dynamic>?;
        if (membersData != null) {
          for (final workspaceEntry in membersData.entries) {
            final workspaceId = workspaceEntry.key as String;
            final members = workspaceEntry.value as Map<dynamic, dynamic>;
            
            if (members.containsKey(userId)) {
              // Check if workspace is not already in the list
              if (!workspaces.any((w) => w.id == workspaceId)) {
                final workspace = await getWorkspace(workspaceId);
                if (workspace != null) {
                  workspaces.add(workspace);
                }
              }
            }
          }
        }
      }
      
      return workspaces;
    } catch (e) {
      throw ServerException(message:'Failed to get user workspaces: $e');
    }
  }

  @override
  Future<void> updateWorkspace(Workspace workspace) async {
    try {
      final workspaceRef = _database.ref('workspaces/${workspace.id}');
      
      await workspaceRef.update({
        'name': workspace.name,
        'description': workspace.description,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw ServerException(message:'Failed to update workspace: $e');
    }
  }

  @override
  Future<void> deleteWorkspace(String workspaceId) async {
    try {
      // Delete workspace
      await _database.ref('workspaces/$workspaceId').remove();
      
      // Delete workspace members
      await _database.ref('workspace_members/$workspaceId').remove();
      
      // Delete workspace data
      await _database.ref('workspace_data/$workspaceId').remove();
    } catch (e) {
      throw ServerException(message:'Failed to delete workspace: $e');
    }
  }

  @override
  Future<void> switchToWorkspace(String userId, String workspaceId) async {
    try {
      final userRef = _database.ref('users/$userId/preferences');
      
      await userRef.update({
        'currentWorkspaceId': workspaceId,
      });
    } catch (e) {
      throw ServerException(message:'Failed to switch workspace: $e');
    }
  }

  @override
  Future<Workspace?> getCurrentWorkspace(String userId) async {
    try {
      final userRef = _database.ref('users/$userId/preferences/currentWorkspaceId');
      final snapshot = await userRef.get();
      
      if (!snapshot.exists) return null;
      
      final workspaceId = snapshot.value as String?;
      if (workspaceId == null || workspaceId.isEmpty) return null;
      
      return await getWorkspace(workspaceId);
    } catch (e) {
      throw ServerException(message:'Failed to get current workspace: $e');
    }
  }

  @override
  Future<void> addMember(WorkspaceMember member) async {
    try {
      final memberRef = _database.ref('workspace_members/${member.workspaceId}/${member.userId}');
      await memberRef.set(member.toMap());
    } catch (e) {
      throw ServerException(message:'Failed to add member: $e');
    }
  }

  @override
  Future<void> removeMember(String workspaceId, String userId) async {
    try {
      final memberRef = _database.ref('workspace_members/$workspaceId/$userId');
      await memberRef.remove();
    } catch (e) {
      throw ServerException(message:'Failed to remove member: $e');
    }
  }

  @override
  Future<void> updateMemberPermissions(
    String workspaceId,
    String userId,
    List<String> permissions,
  ) async {
    try {
      final memberRef = _database.ref('workspace_members/$workspaceId/$userId');
      
      await memberRef.update({
        'permissions': permissions,
      });
    } catch (e) {
      throw ServerException(message:'Failed to update member permissions: $e');
    }
  }

  @override
  Future<List<WorkspaceMember>> getWorkspaceMembers(String workspaceId) async {
    try {
      final membersRef = _database.ref('workspace_members/$workspaceId');
      final snapshot = await membersRef.get();
      
      if (!snapshot.exists) return [];
      
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      
      final members = <WorkspaceMember>[];
      
      for (final entry in data.entries) {
        final memberData = entry.value as Map<dynamic, dynamic>;
        members.add(WorkspaceMember.fromMap(Map<String, dynamic>.from(memberData)));
      }
      
      return members;
    } catch (e) {
      throw ServerException(message:'Failed to get workspace members: $e');
    }
  }

  @override
  Future<WorkspaceMember?> getUserWorkspaceRole(String userId, String workspaceId) async {
    try {
      final memberRef = _database.ref('workspace_members/$workspaceId/$userId');
      final snapshot = await memberRef.get();
      
      if (!snapshot.exists) return null;
      
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return null;
      
      return WorkspaceMember.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      throw ServerException(message:'Failed to get user workspace role: $e');
    }
  }
}
