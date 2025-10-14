import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';

/// Workspace analytics service for tracking workspace-related events
class WorkspaceAnalytics {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Track workspace creation
  static Future<void> trackWorkspaceCreated({
    required String workspaceId,
    required WorkspaceType type,
    required String createdBy,
  }) async {
    await _analytics.logEvent(
      name: 'workspace_created',
      parameters: {
        'workspace_id': workspaceId,
        'workspace_type': type.value,
        'created_by': createdBy,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Track workspace switching
  static Future<void> trackWorkspaceSwitched({
    required String fromWorkspaceId,
    required String toWorkspaceId,
    required String userId,
  }) async {
    await _analytics.logEvent(
      name: 'workspace_switched',
      parameters: {
        'from_workspace_id': fromWorkspaceId,
        'to_workspace_id': toWorkspaceId,
        'user_id': userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Track workspace settings updated
  static Future<void> trackWorkspaceSettingsUpdated({
    required String workspaceId,
    required String userId,
    required List<String> updatedSettings,
  }) async {
    await _analytics.logEvent(
      name: 'workspace_settings_updated',
      parameters: {
        'workspace_id': workspaceId,
        'user_id': userId,
        'updated_settings': updatedSettings.join(','),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Track member added to workspace
  static Future<void> trackMemberAdded({
    required String workspaceId,
    required String memberId,
    required WorkspaceRole role,
    required String addedBy,
  }) async {
    await _analytics.logEvent(
      name: 'workspace_member_added',
      parameters: {
        'workspace_id': workspaceId,
        'member_id': memberId,
        'member_role': role.value,
        'added_by': addedBy,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Track member removed from workspace
  static Future<void> trackMemberRemoved({
    required String workspaceId,
    required String memberId,
    required String removedBy,
  }) async {
    await _analytics.logEvent(
      name: 'workspace_member_removed',
      parameters: {
        'workspace_id': workspaceId,
        'member_id': memberId,
        'removed_by': removedBy,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Track member permissions updated
  static Future<void> trackMemberPermissionsUpdated({
    required String workspaceId,
    required String memberId,
    required List<String> newPermissions,
    required String updatedBy,
  }) async {
    await _analytics.logEvent(
      name: 'workspace_member_permissions_updated',
      parameters: {
        'workspace_id': workspaceId,
        'member_id': memberId,
        'permissions_count': newPermissions.length,
        'updated_by': updatedBy,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Track workspace deleted
  static Future<void> trackWorkspaceDeleted({
    required String workspaceId,
    required String deletedBy,
    required WorkspaceType type,
  }) async {
    await _analytics.logEvent(
      name: 'workspace_deleted',
      parameters: {
        'workspace_id': workspaceId,
        'deleted_by': deletedBy,
        'workspace_type': type.value,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Track workspace access attempt
  static Future<void> trackWorkspaceAccessAttempt({
    required String workspaceId,
    required String userId,
    required bool success,
    String? failureReason,
  }) async {
    await _analytics.logEvent(
      name: 'workspace_access_attempt',
      parameters: {
        'workspace_id': workspaceId,
        'user_id': userId,
        'success': success,
        'failure_reason': failureReason ?? '',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Track permission check
  static Future<void> trackPermissionCheck({
    required String workspaceId,
    required String userId,
    required String permission,
    required bool granted,
  }) async {
    await _analytics.logEvent(
      name: 'workspace_permission_check',
      parameters: {
        'workspace_id': workspaceId,
        'user_id': userId,
        'permission': permission,
        'granted': granted,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Track workspace performance metrics
  static Future<void> trackWorkspacePerformance({
    required String workspaceId,
    required String operation,
    required int durationMs,
    required bool success,
  }) async {
    await _analytics.logEvent(
      name: 'workspace_performance',
      parameters: {
        'workspace_id': workspaceId,
        'operation': operation,
        'duration_ms': durationMs,
        'success': success,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Set user properties for workspace analytics
  static Future<void> setUserProperties({
    required String userId,
    required int workspaceCount,
    required List<WorkspaceType> workspaceTypes,
  }) async {
    await _analytics.setUserProperty(
      name: 'workspace_count',
      value: workspaceCount.toString(),
    );
    
    await _analytics.setUserProperty(
      name: 'workspace_types',
      value: workspaceTypes.map((type) => type.value).join(','),
    );
  }

  /// Track workspace creation flow completion
  static Future<void> trackWorkspaceCreationFlowCompleted({
    required String userId,
    required WorkspaceType type,
    required int stepCount,
    required int durationSeconds,
  }) async {
    await _analytics.logEvent(
      name: 'workspace_creation_flow_completed',
      parameters: {
        'user_id': userId,
        'workspace_type': type.value,
        'step_count': stepCount,
        'duration_seconds': durationSeconds,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Track workspace creation flow abandoned
  static Future<void> trackWorkspaceCreationFlowAbandoned({
    required String userId,
    required WorkspaceType type,
    required int stepReached,
    required int durationSeconds,
  }) async {
    await _analytics.logEvent(
      name: 'workspace_creation_flow_abandoned',
      parameters: {
        'user_id': userId,
        'workspace_type': type.value,
        'step_reached': stepReached,
        'duration_seconds': durationSeconds,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}
