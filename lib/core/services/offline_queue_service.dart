import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';

import 'firebase_database_service.dart';
import 'conflict_resolution_service.dart';
import '../../features/tasks/domain/entities/project.dart';
import '../../features/tasks/domain/entities/task.dart';
import '../../features/reports/domain/entities/report.dart';

class OfflineQueueService {
  OfflineQueueService._();
  static OfflineQueueService? _instance;
  static OfflineQueueService get instance => _instance ??= OfflineQueueService._();

  Box<dynamic>? _mutationsBox;
  ConflictResolutionService? _conflictService;

  Future<void> _ensureInitialized() async {
    _mutationsBox ??= await Hive.openBox<dynamic>('mutations_box');
    _conflictService ??= Get.find<ConflictResolutionService>();
  }

  Future<void> flush() async {
    await _ensureInitialized();
    final keys = _mutationsBox!.keys.toList();
    for (final key in keys) {
      final raw = _mutationsBox!.get(key) as String?;
      if (raw == null) continue;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final op = map['op'] as String;
      final companyId = map['companyId'] as String;
      
      try {
        // Use retry with backoff for all operations
        await _conflictService!.retryWithBackoff(
          () async {
            switch (op) {
              case 'create_project':
                await FirebaseDatabaseService.instance.createProject(
                  companyId: companyId,
                  project: Project.fromMap(map['payload'] as Map<String, dynamic>),
                );
                break;
              case 'update_project':
                await _handleUpdateWithConflictResolution(
                  companyId: companyId,
                  operation: op,
                  payload: map['payload'] as Map<String, dynamic>,
                  entityType: 'project',
                );
                break;
              case 'delete_project':
                await FirebaseDatabaseService.instance.softDeleteProject(
                  companyId: companyId,
                  projectId: map['projectId'] as String,
                );
                break;
              case 'create_task':
                await FirebaseDatabaseService.instance.createTask(
                  companyId: companyId,
                  task: TaskEntity.fromMap(map['payload'] as Map<String, dynamic>),
                );
                break;
              case 'update_task':
                await _handleUpdateWithConflictResolution(
                  companyId: companyId,
                  operation: op,
                  payload: map['payload'] as Map<String, dynamic>,
                  entityType: 'task',
                );
                break;
              case 'delete_task':
                await FirebaseDatabaseService.instance.softDeleteTask(
                  companyId: companyId,
                  taskId: map['taskId'] as String,
                );
                break;
              case 'create_recurring_task':
                await FirebaseDatabaseService.instance.createTask(
                  companyId: companyId,
                  task: TaskEntity.fromMap(map['payload'] as Map<String, dynamic>),
                );
                break;
              case 'create_report':
                await FirebaseDatabaseService.instance.createReport(
                  companyId: companyId,
                  report: ReportEntity.fromMap(map['payload'] as Map<String, dynamic>),
                );
                break;
              case 'update_report':
                await FirebaseDatabaseService.instance.updateReport(
                  companyId: companyId,
                  report: ReportEntity.fromMap(map['payload'] as Map<String, dynamic>),
                );
                break;
              case 'submit_report':
                await FirebaseDatabaseService.instance.submitReport(
                  companyId: companyId,
                  reportId: map['reportId'] as String,
                );
                break;
            }
          },
          operationKey: '${op}_${key}',
        );
        
        await _mutationsBox!.delete(key);
      } catch (e) {
        // Keep in queue; stop processing to avoid hot loop
        print('Failed to process mutation $op: $e');
        break;
      }
    }
  }

  Future<void> enqueue(Map<String, dynamic> mutation) async {
    await _ensureInitialized();
    final key = DateTime.now().microsecondsSinceEpoch.toString();
    await _mutationsBox!.put(key, jsonEncode(mutation));
  }

  Future<void> createProject({required String companyId, required Project project}) async {
    try {
      await FirebaseDatabaseService.instance.createProject(companyId: companyId, project: project);
    } catch (_) {
      await enqueue({
        'op': 'create_project',
        'companyId': companyId,
        'payload': project.toMap(),
      });
    }
  }

  Future<void> updateProject({required String companyId, required Project project}) async {
    try {
      await FirebaseDatabaseService.instance.updateProject(companyId: companyId, project: project);
    } catch (_) {
      await enqueue({
        'op': 'update_project',
        'companyId': companyId,
        'payload': project.toMap(),
      });
    }
  }

  Future<void> deleteProject({required String companyId, required String projectId}) async {
    try {
      await FirebaseDatabaseService.instance.softDeleteProject(companyId: companyId, projectId: projectId);
    } catch (_) {
      await enqueue({
        'op': 'delete_project',
        'companyId': companyId,
        'projectId': projectId,
      });
    }
  }

  Future<void> createTask({required String companyId, required TaskEntity task}) async {
    try {
      await FirebaseDatabaseService.instance.createTask(companyId: companyId, task: task);
    } catch (_) {
      await enqueue({
        'op': 'create_task',
        'companyId': companyId,
        'payload': task.toMap(),
      });
    }
  }

  Future<void> updateTask({required String companyId, required TaskEntity task}) async {
    try {
      await FirebaseDatabaseService.instance.updateTask(companyId: companyId, task: task);
    } catch (_) {
      await enqueue({
        'op': 'update_task',
        'companyId': companyId,
        'payload': task.toMap(),
      });
    }
  }

  Future<void> createRecurringTask({required String companyId, required TaskEntity task}) async {
    try {
      await FirebaseDatabaseService.instance.createTask(companyId: companyId, task: task);
    } catch (_) {
      await enqueue({
        'op': 'create_recurring_task',
        'companyId': companyId,
        'payload': task.toMap(),
      });
    }
  }

  Future<void> deleteTask({required String companyId, required String taskId}) async {
    try {
      await FirebaseDatabaseService.instance.softDeleteTask(companyId: companyId, taskId: taskId);
    } catch (_) {
      await enqueue({
        'op': 'delete_task',
        'companyId': companyId,
        'taskId': taskId,
      });
    }
  }

  /// Handle update operations with conflict resolution
  Future<void> _handleUpdateWithConflictResolution({
    required String companyId,
    required String operation,
    required Map<String, dynamic> payload,
    required String entityType,
  }) async {
    try {
      // Get current remote data
      Map<String, dynamic>? remoteData;
      if (entityType == 'task') {
        final task = await FirebaseDatabaseService.instance.getTask(
          companyId: companyId,
          taskId: payload['id'] as String,
        );
        remoteData = task?.toMap();
      } else if (entityType == 'project') {
        final project = await FirebaseDatabaseService.instance.getProject(
          companyId: companyId,
          projectId: payload['id'] as String,
        );
        remoteData = project?.toMap();
      }

      // If no remote data, proceed with normal update
      if (remoteData == null) {
        if (entityType == 'task') {
          await FirebaseDatabaseService.instance.updateTask(
            companyId: companyId,
            task: TaskEntity.fromMap(payload),
          );
        } else if (entityType == 'project') {
          await FirebaseDatabaseService.instance.updateProject(
            companyId: companyId,
            project: Project.fromMap(payload),
          );
        }
        return;
      }

      // Check for conflicts and resolve
      final resolution = await _conflictService!.resolveConflict(
        entityType: entityType,
        entityId: payload['id'] as String,
        localData: payload,
        remoteData: remoteData,
        userId: payload['assigner'] as String? ?? payload['createdBy'] as String? ?? 'unknown',
      );

      if (resolution.isSuccess && resolution.resolvedData != null) {
        // Apply resolved data
        if (entityType == 'task') {
          await FirebaseDatabaseService.instance.updateTask(
            companyId: companyId,
            task: TaskEntity.fromMap(resolution.resolvedData!),
          );
        } else if (entityType == 'project') {
          await FirebaseDatabaseService.instance.updateProject(
            companyId: companyId,
            project: Project.fromMap(resolution.resolvedData!),
          );
        }
      } else {
        // If resolution failed, use remote data (server wins)
        if (entityType == 'task') {
          await FirebaseDatabaseService.instance.updateTask(
            companyId: companyId,
            task: TaskEntity.fromMap(remoteData),
          );
        } else if (entityType == 'project') {
          await FirebaseDatabaseService.instance.updateProject(
            companyId: companyId,
            project: Project.fromMap(remoteData),
          );
        }
      }
    } catch (e) {
      // If conflict resolution fails, throw error to trigger retry
      throw Exception('Conflict resolution failed: $e');
    }
  }
}


