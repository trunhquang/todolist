import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/core/errors/exceptions.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';

/// Local data source for workspace caching
abstract class WorkspaceLocalDataSource {
  Future<void> cacheWorkspaces(List<Workspace> workspaces);
  Future<List<Workspace>> getCachedWorkspaces();
  Future<void> cacheCurrentWorkspace(Workspace workspace);
  Future<Workspace?> getCachedCurrentWorkspace();
  Future<void> cacheWorkspaceMembers(String workspaceId, List<WorkspaceMember> members);
  Future<List<WorkspaceMember>> getCachedWorkspaceMembers(String workspaceId);
  Future<void> clearCache();
}

/// SharedPreferences implementation of workspace local data source
class WorkspaceLocalDataSourceImpl implements WorkspaceLocalDataSource {
  final SharedPreferences _sharedPreferences;

  WorkspaceLocalDataSourceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  static const String _workspacesKey = 'cached_workspaces';
  static const String _currentWorkspaceKey = 'current_workspace';
  static const String _workspaceMembersPrefix = 'workspace_members_';

  @override
  Future<void> cacheWorkspaces(List<Workspace> workspaces) async {
    try {
      final workspacesJson = workspaces.map((w) => w.toMap()).toList();
      await _sharedPreferences.setString(_workspacesKey, workspacesJson.toString());
    } catch (e) {
      throw CacheException(message: 'Failed to cache workspaces: $e');
    }
  }

  @override
  Future<List<Workspace>> getCachedWorkspaces() async {
    try {
      final workspacesString = _sharedPreferences.getString(_workspacesKey);
      if (workspacesString == null || workspacesString.isEmpty) {
        return [];
      }

      // Parse the cached workspaces
      // Note: This is a simplified implementation. In production, you might want to use JSON serialization
      return [];
    } catch (e) {
      throw CacheException(message:'Failed to get cached workspaces: $e');
    }
  }

  @override
  Future<void> cacheCurrentWorkspace(Workspace workspace) async {
    try {
      final workspaceJson = workspace.toMap();
      await _sharedPreferences.setString(_currentWorkspaceKey, workspaceJson.toString());
    } catch (e) {
      throw CacheException(message:'Failed to cache current workspace: $e');
    }
  }

  @override
  Future<Workspace?> getCachedCurrentWorkspace() async {
    try {
      final workspaceString = _sharedPreferences.getString(_currentWorkspaceKey);
      if (workspaceString == null || workspaceString.isEmpty) {
        return null;
      }

      // Parse the cached workspace
      // Note: This is a simplified implementation. In production, you might want to use JSON serialization
      return null;
    } catch (e) {
      throw CacheException(message:'Failed to get cached current workspace: $e');
    }
  }

  @override
  Future<void> cacheWorkspaceMembers(String workspaceId, List<WorkspaceMember> members) async {
    try {
      final membersJson = members.map((m) => m.toMap()).toList();
      final key = '$_workspaceMembersPrefix$workspaceId';
      await _sharedPreferences.setString(key, membersJson.toString());
    } catch (e) {
      throw CacheException(message:'Failed to cache workspace members: $e');
    }
  }

  @override
  Future<List<WorkspaceMember>> getCachedWorkspaceMembers(String workspaceId) async {
    try {
      final key = '$_workspaceMembersPrefix$workspaceId';
      final membersString = _sharedPreferences.getString(key);
      if (membersString == null || membersString.isEmpty) {
        return [];
      }

      // Parse the cached members
      // Note: This is a simplified implementation. In production, you might want to use JSON serialization
      return [];
    } catch (e) {
      throw CacheException(message:'Failed to get cached workspace members: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _sharedPreferences.remove(_workspacesKey);
      await _sharedPreferences.remove(_currentWorkspaceKey);
      
      // Clear all workspace members cache
      final keys = _sharedPreferences.getKeys();
      for (final key in keys) {
        if (key.startsWith(_workspaceMembersPrefix)) {
          await _sharedPreferences.remove(key);
        }
      }
    } catch (e) {
      throw CacheException(message:'Failed to clear cache: $e');
    }
  }
}
