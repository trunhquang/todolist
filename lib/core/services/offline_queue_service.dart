import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_database_service.dart';
import '../../features/tasks/domain/entities/project.dart';
import '../../features/tasks/domain/entities/task.dart';

class OfflineQueueService {
  OfflineQueueService._();
  static OfflineQueueService? _instance;
  static OfflineQueueService get instance => _instance ??= OfflineQueueService._();

  Box<dynamic>? _mutationsBox;

  Future<void> _ensureInitialized() async {
    _mutationsBox ??= await Hive.openBox<dynamic>('mutations_box');
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
        switch (op) {
          case 'create_project':
            await FirebaseDatabaseService.instance.createProject(
              companyId: companyId,
              project: Project.fromMap(map['payload'] as Map<String, dynamic>),
            );
            break;
          case 'update_project':
            await FirebaseDatabaseService.instance.updateProject(
              companyId: companyId,
              project: Project.fromMap(map['payload'] as Map<String, dynamic>),
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
            await FirebaseDatabaseService.instance.updateTask(
              companyId: companyId,
              task: TaskEntity.fromMap(map['payload'] as Map<String, dynamic>),
            );
            break;
          case 'delete_task':
            await FirebaseDatabaseService.instance.softDeleteTask(
              companyId: companyId,
              taskId: map['taskId'] as String,
            );
            break;
        }
        await _mutationsBox!.delete(key);
      } catch (_) {
        // Keep in queue; stop processing to avoid hot loop
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
}


