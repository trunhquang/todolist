import 'dart:math';
import 'package:get/get.dart';

import '../../features/tasks/domain/entities/activity_log.dart';
import '../../features/tasks/domain/entities/task.dart';
import '../../features/tasks/domain/entities/project.dart';
import 'storage_service.dart';

/// Service for handling conflict resolution and retry/backoff strategy
class ConflictResolutionService extends GetxService {
  static ConflictResolutionService get instance => Get.find<ConflictResolutionService>();
  
  late StorageService _storageService;
  final Map<String, int> _retryAttempts = {};
  final Map<String, DateTime> _lastRetryTime = {};

  @override
  Future<void> onInit() async {
    super.onInit();
    _storageService = Get.find<StorageService>();
  }

  /// Resolve conflicts using last-write-wins strategy
  Future<ConflictResolutionResult> resolveConflict({
    required String entityType,
    required String entityId,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> remoteData,
    required String userId,
  }) async {
    try {
      // Get activity logs for this entity
      final activityLogs = await _getActivityLogs(entityType, entityId);
      
      // Find the most recent activity
      final mostRecentLog = activityLogs.isNotEmpty 
          ? activityLogs.reduce((a, b) => a.timestamp.isAfter(b.timestamp) ? a : b)
          : null;

      // Apply last-write-wins strategy
      final resolvedData = _applyLastWriteWins(
        localData: localData,
        remoteData: remoteData,
        activityLogs: activityLogs,
        userId: userId,
      );

      // Log the conflict resolution
      await _logConflictResolution(
        entityType: entityType,
        entityId: entityId,
        localData: localData,
        remoteData: remoteData,
        resolvedData: resolvedData,
        userId: userId,
      );

      return ConflictResolutionResult(
        isSuccess: true,
        resolvedData: resolvedData,
        strategy: 'last-write-wins',
        conflictDetected: _hasConflict(localData, remoteData),
      );
    } catch (e) {
      return ConflictResolutionResult(
        isSuccess: false,
        error: 'Failed to resolve conflict: $e',
        conflictDetected: true,
      );
    }
  }

  /// Apply last-write-wins strategy
  Map<String, dynamic> _applyLastWriteWins({
    required Map<String, dynamic> localData,
    required Map<String, dynamic> remoteData,
    required List<ActivityLog> activityLogs,
    required String userId,
  }) {
    // If no activity logs, use remote data (server is source of truth)
    if (activityLogs.isEmpty) {
      return remoteData;
    }

    // Find the most recent activity
    final mostRecentLog = activityLogs.reduce(
      (a, b) => a.timestamp.isAfter(b.timestamp) ? a : b,
    );

    // If the most recent activity is from the current user, use local data
    if (mostRecentLog.userId == userId) {
      return localData;
    }

    // Otherwise, use remote data (last-write-wins)
    return remoteData;
  }

  /// Check if there's a conflict between local and remote data
  bool _hasConflict(Map<String, dynamic> localData, Map<String, dynamic> remoteData) {
    // Compare key fields that could conflict
    final keyFields = ['title', 'description', 'status', 'priority', 'assignee', 'deadline'];
    
    for (final field in keyFields) {
      if (localData[field] != remoteData[field]) {
        return true;
      }
    }
    
    return false;
  }

  /// Log conflict resolution activity
  Future<void> _logConflictResolution({
    required String entityType,
    required String entityId,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> remoteData,
    required Map<String, dynamic> resolvedData,
    required String userId,
  }) async {
    try {
      final log = ActivityLog(
        id: 'conflict_${DateTime.now().millisecondsSinceEpoch}',
        entityType: entityType,
        entityId: entityId,
        action: 'conflict_resolution',
        userId: userId,
        timestamp: DateTime.now(),
        data: resolvedData,
        previousData: {
          'local': localData,
          'remote': remoteData,
        },
        conflictResolved: true,
      );

      await _storageService.setUserData(
        'activity_log_${entityType}_${entityId}_${log.id}',
        log.toMap(),
      );
    } catch (e) {
      // Log error but don't throw
      print('Failed to log conflict resolution: $e');
    }
  }

  /// Get activity logs for an entity
  Future<List<ActivityLog>> _getActivityLogs(String entityType, String entityId) async {
    try {
      final keys = _storageService.getUserData<List<String>>('activity_logs_${entityType}_${entityId}') ?? [];
      final logs = <ActivityLog>[];

      for (final key in keys) {
        final logData = _storageService.getUserData<Map<String, dynamic>>(key);
        if (logData != null) {
          logs.add(ActivityLog.fromMap(logData));
        }
      }

      return logs;
    } catch (e) {
      return [];
    }
  }

  /// Retry operation with exponential backoff
  Future<T> retryWithBackoff<T>(
    Future<T> Function() operation, {
    String? operationKey,
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
  }) async {
    final key = operationKey ?? 'default';
    final attempts = _retryAttempts[key] ?? 0;
    
    if (attempts >= maxRetries) {
      throw Exception('Max retries exceeded for operation: $key');
    }

    try {
      final result = await operation();
      
      // Reset retry count on success
      _retryAttempts.remove(key);
      _lastRetryTime.remove(key);
      
      return result;
    } catch (e) {
      // Increment retry count
      _retryAttempts[key] = attempts + 1;
      _lastRetryTime[key] = DateTime.now();
      
      // Calculate delay with exponential backoff
      final delay = Duration(
        milliseconds: (initialDelay.inMilliseconds * pow(2, attempts)).round(),
      );
      
      // Wait before retry
      await Future.delayed(delay);
      
      // Recursive retry
      return retryWithBackoff(
        operation,
        operationKey: key,
        maxRetries: maxRetries,
        initialDelay: initialDelay,
      );
    }
  }

  /// Get retry statistics
  RetryStats getRetryStats(String operationKey) {
    final attempts = _retryAttempts[operationKey] ?? 0;
    final lastRetry = _lastRetryTime[operationKey];
    
    return RetryStats(
      operationKey: operationKey,
      attempts: attempts,
      lastRetryTime: lastRetry,
      isRetrying: attempts > 0,
    );
  }

  /// Clear retry data for an operation
  void clearRetryData(String operationKey) {
    _retryAttempts.remove(operationKey);
    _lastRetryTime.remove(operationKey);
  }

  /// Clear all retry data
  void clearAllRetryData() {
    _retryAttempts.clear();
    _lastRetryTime.clear();
  }
}

/// Result of conflict resolution
class ConflictResolutionResult {
  final bool isSuccess;
  final String? error;
  final Map<String, dynamic>? resolvedData;
  final String? strategy;
  final bool conflictDetected;

  ConflictResolutionResult({
    required this.isSuccess,
    this.error,
    this.resolvedData,
    this.strategy,
    required this.conflictDetected,
  });
}

/// Retry statistics
class RetryStats {
  final String operationKey;
  final int attempts;
  final DateTime? lastRetryTime;
  final bool isRetrying;

  RetryStats({
    required this.operationKey,
    required this.attempts,
    this.lastRetryTime,
    required this.isRetrying,
  });
}
