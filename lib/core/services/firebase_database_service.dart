import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/features/auth/domain/entities/user.dart' as app_user;
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';
import 'package:todolist/features/reports/domain/entities/report.dart';

class FirebaseDatabaseService extends GetxService {
  static FirebaseDatabaseService get instance =>
      Get.find<FirebaseDatabaseService>();

  late FirebaseDatabase _database;
  late DatabaseReference _companiesRef;
  late DatabaseReference _usersRef;

  DatabaseReference _projectsRef(String workspaceId) =>
      _companiesRef.child(workspaceId).child('projects');

  DatabaseReference _tasksRef(String workspaceId) =>
      _companiesRef.child(workspaceId).child('tasks');

  DatabaseReference _reportsRef(String workspaceId) =>
      _companiesRef.child(workspaceId).child('reports');

  @override
  Future<void> onInit() async {
    super.onInit();
    _database = FirebaseDatabase.instance;
    _companiesRef = _database.ref('companies');
    _usersRef = _database.ref('users');
  }

  // Config Management
  Future<String?> getConfigValue(String key) async {
    try {
      final snapshot = await _database.ref('config').child(key).get();
      if (!snapshot.exists) return null;
      return snapshot.value as String?;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to get config value: $e');
    }
  }

  // User Management
  Future<void> createUser(app_user.User user) async {
    try {
      await _usersRef.child(user.id).set({
        'id': user.id,
        'email': user.email,
        'name': user.name,
        'profileImageUrl': user.profileImageUrl,
        'role': user.role,
        'workspaceId': user.workspaceId,
        'workspaceId': user.workspaceId,
        'managerUserId': user.managerUserId,
        'invitedByUserId': user.invitedByUserId,
        'mustChangePassword': user.mustChangePassword,
        'createdAt': user.createdAt.millisecondsSinceEpoch,
        'lastLoginAt': user.lastLoginAt?.millisecondsSinceEpoch,
      });
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to create user: $e');
    }
  }

  Future<app_user.User?> getUser(String userId) async {
    try {
      final snapshot = await _usersRef.child(userId).get();
      if (!snapshot.exists) return null;

      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return null;

      return app_user.User(
        id: (data['id'] as String?) ?? '',
        email: (data['email'] as String?) ?? '',
        name: (data['name'] as String?) ?? '',
        profileImageUrl: data['profileImageUrl'] as String?,
        role: (data['role'] as String?) ?? 'user',
        workspaceId: (data['workspaceId'] as String?) ?? '',
        managerUserId: data['managerUserId'] as String?,
        invitedByUserId: data['invitedByUserId'] as String?,
        mustChangePassword: (data['mustChangePassword'] as bool?) ?? false,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            (data['createdAt'] as int?) ?? 0),
        lastLoginAt: data['lastLoginAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(data['lastLoginAt'] as int)
            : null,
      );
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to get user: $e');
    }
  }

  // Project Management
  Future<String> createProject({
    required String workspaceId,
    required Project project,
  }) async {
    try {
      final ref = _projectsRef(workspaceId).push();
      final id = ref.key!;
      await ref.set({
        ...project.copyWith(id: id).toMap(),
      });
      return id;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to create project: $e');
    }
  }

  Future<Project?> getProject({
    required String workspaceId,
    required String projectId,
  }) async {
    try {
      final snapshot = await _projectsRef(workspaceId).child(projectId).get();
      if (!snapshot.exists) return null;
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return null;
      return Project.fromMap(data);
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to get project: $e');
    }
  }

  Future<List<Project>> listProjects({
    required String workspaceId,
    String? departmentId,
    String? status,
  }) async {
    try {
      final ref = _projectsRef(workspaceId);
      final snapshot = await ref.get();
      if (!snapshot.exists) return <Project>[];
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return <Project>[];
      final items = <Project>[];
      data.forEach((key, value) {
        final map = value as Map<dynamic, dynamic>;
        final project = Project.fromMap(map);
        final matchesWorkspace =
            departmentId == null || project.workspaceId == departmentId;
        final matchesStatus = status == null || project.status == status;
        if (matchesWorkspace && matchesStatus) {
          items.add(project.copyWith(
              id: (project.id.isEmpty ? key as String : project.id)));
        }
      });
      return items;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to list projects: $e');
    }
  }

  // Realtime streams
  Stream<List<Project>> watchProjects({
    required String workspaceId,
    String? departmentId,
    String? status,
  }) {
    final ref = _projectsRef(workspaceId);
    return ref.onValue.map((event) {
      final snapshot = event.snapshot;
      if (!snapshot.exists) return <Project>[];
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return <Project>[];
      final items = <Project>[];
      data.forEach((key, value) {
        final map = value as Map<dynamic, dynamic>;
        final project = Project.fromMap(map);
        final matchesWorkspace =
            departmentId == null || project.workspaceId == departmentId;
        final matchesStatus = status == null || project.status == status;
        if (matchesWorkspace && matchesStatus) {
          items.add(project.copyWith(
              id: (project.id.isEmpty ? key as String : project.id)));
        }
      });
      return items;
    });
  }

  Future<void> updateProject({
    required String workspaceId,
    required Project project,
  }) async {
    try {
      await _projectsRef(workspaceId).child(project.id).update(project.toMap());
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to update project: $e');
    }
  }

  Future<void> softDeleteProject({
    required String workspaceId,
    required String projectId,
  }) async {
    try {
      await _projectsRef(workspaceId)
          .child(projectId)
          .update({'deletedAt': DateTime.now().millisecondsSinceEpoch});
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to delete project: $e');
    }
  }

  // Task Management
  Future<String> createTask({
    required String workspaceId,
    required TaskEntity task,
  }) async {
    try {
      final ref = _tasksRef(workspaceId).push();
      final id = ref.key!;
      await ref.set({
        ...task.copyWith(id: id, createdAt: DateTime.now()).toMap(),
      });
      return id;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to create task: $e');
    }
  }

  // Report Management
  Future<String> createReport({
    required String workspaceId,
    required ReportEntity report,
  }) async {
    try {
      final ref = _reportsRef(workspaceId).push();
      final id = ref.key!;
      await ref.set({
        ...report.copyWith(id: id, createdAt: DateTime.now()).toMap(),
      });
      return id;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to create report: $e');
    }
  }

  Future<void> updateReport({
    required String workspaceId,
    required ReportEntity report,
  }) async {
    try {
      await _reportsRef(workspaceId).child(report.id).update({
        ...report.toMap(),
      });
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to update report: $e');
    }
  }

  Future<void> submitReport({
    required String workspaceId,
    required String reportId,
  }) async {
    try {
      await _reportsRef(workspaceId).child(reportId).update({
        'status': 'submitted',
        'submittedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to submit report: $e');
    }
  }

  Future<ReportEntity?> getReport({
    required String workspaceId,
    required String reportId,
  }) async {
    try {
      final snapshot = await _reportsRef(workspaceId).child(reportId).get();
      if (!snapshot.exists) return null;
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return null;
      return ReportEntity.fromMap(data);
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to get report: $e');
    }
  }

  Future<List<ReportEntity>> listReportsByDate({
    required String workspaceId,
    required DateTime date,
    String? userId,
    String? departmentId,
  }) async {
    try {
      final snapshot = await _reportsRef(workspaceId).get();
      if (!snapshot.exists) return <ReportEntity>[];
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return <ReportEntity>[];
      final items = <ReportEntity>[];
      data.forEach((key, value) {
        final map = value as Map<dynamic, dynamic>;
        final report = ReportEntity.fromMap(map);
        final isSameDay =
            DateTime(report.date.year, report.date.month, report.date.day)
                .isAtSameMomentAs(DateTime(date.year, date.month, date.day));
        final matchesUser = userId == null || report.userId == userId;
        if (isSameDay && matchesUser) {
          items.add(report.copyWith(
              id: (report.id.isEmpty ? key as String : report.id)));
        }
      });
      return items;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to list reports: $e');
    }
  }

  Stream<List<ReportEntity>> watchUserReports({
    required String workspaceId,
    required String userId,
  }) {
    final ref = _reportsRef(workspaceId);
    return ref.onValue.map((event) {
      final snapshot = event.snapshot;
      if (!snapshot.exists) return <ReportEntity>[];
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return <ReportEntity>[];
      final items = <ReportEntity>[];
      data.forEach((key, value) {
        final map = value as Map<dynamic, dynamic>;
        final report = ReportEntity.fromMap(map);
        if (report.userId == userId) {
          items.add(report.copyWith(
              id: (report.id.isEmpty ? key as String : report.id)));
        }
      });
      return items;
    });
  }

  Future<TaskEntity?> getTask({
    required String workspaceId,
    required String taskId,
  }) async {
    try {
      final snapshot = await _tasksRef(workspaceId).child(taskId).get();
      if (!snapshot.exists) return null;
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return null;
      return TaskEntity.fromMap(data);
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to get task: $e');
    }
  }

  Future<void> updateTask({
    required String workspaceId,
    required TaskEntity task,
  }) async {
    try {
      await _tasksRef(workspaceId).child(task.id).update({
        ...task.toMap(),
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to update task: $e');
    }
  }

  Future<void> softDeleteTask({
    required String workspaceId,
    required String taskId,
  }) async {
    try {
      await _tasksRef(workspaceId)
          .child(taskId)
          .update({'deletedAt': DateTime.now().millisecondsSinceEpoch});
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to delete task: $e');
    }
  }

  Future<List<TaskEntity>> listTasks({
    required String workspaceId,
    String? type,
    String? status,
    String? priority,
    String? projectId,
    String? assignee,
  }) async {
    try {
      final snapshot = await _tasksRef(workspaceId).get();
      if (!snapshot.exists) return <TaskEntity>[];
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return <TaskEntity>[];
      final items = <TaskEntity>[];
      data.forEach((key, value) {
        final map = value as Map<dynamic, dynamic>;
        final task = TaskEntity.fromMap(map);
        final matchesType = type == null || task.taskType == type;
        final matchesStatus = status == null || task.status == status;
        final matchesPriority = priority == null || task.priority == priority;
        final matchesProject = projectId == null || task.projectId == projectId;
        final matchesAssignee = assignee == null || task.assignee == assignee;
        if (matchesType &&
            matchesStatus &&
            matchesPriority &&
            matchesProject &&
            matchesAssignee) {
          items.add(
              task.copyWith(id: (task.id.isEmpty ? key as String : task.id)));
        }
      });
      return items;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to list tasks: $e');
    }
  }

  Stream<List<TaskEntity>> watchTasks({
    required String workspaceId,
    String? type,
    String? status,
    String? priority,
    String? projectId,
    String? assignee,
  }) {
    final ref = _tasksRef(workspaceId);
    return ref.onValue.map((event) {
      final snapshot = event.snapshot;
      if (!snapshot.exists) return <TaskEntity>[];
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return <TaskEntity>[];
      final items = <TaskEntity>[];
      data.forEach((key, value) {
        final map = value as Map<dynamic, dynamic>;
        final task = TaskEntity.fromMap(map);
        final matchesType = type == null || task.taskType == type;
        final matchesStatus = status == null || task.status == status;
        final matchesPriority = priority == null || task.priority == priority;
        final matchesProject = projectId == null || task.projectId == projectId;
        final matchesAssignee = assignee == null || task.assignee == assignee;
        if (matchesType &&
            matchesStatus &&
            matchesPriority &&
            matchesProject &&
            matchesAssignee) {
          items.add(
              task.copyWith(id: (task.id.isEmpty ? key as String : task.id)));
        }
      });
      return items;
    });
  }

  Future<void> updateUser(app_user.User user) async {
    try {
      await _usersRef.child(user.id).update({
        'name': user.name,
        'profileImageUrl': user.profileImageUrl,
        'role': user.role,
        'workspaceId': user.workspaceId,
        'workspaceId': user.workspaceId,
        'managerUserId': user.managerUserId,
        'invitedByUserId': user.invitedByUserId,
        'mustChangePassword': user.mustChangePassword,
        'lastLoginAt': user.lastLoginAt?.millisecondsSinceEpoch,
      });
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to update user: $e');
    }
  }

  // List users within a company (for assignee selection)
  Future<List<app_user.User>> listUsersByCompany(String workspaceId) async {
    try {
      final snapshot = await _usersRef.get();
      if (!snapshot.exists) return <app_user.User>[];
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return <app_user.User>[];
      final users = <app_user.User>[];
      data.forEach((key, value) {
        final map = value as Map<dynamic, dynamic>;
        if (map['workspaceId'] == workspaceId) {
          users.add(app_user.User(
            id: (map['id'] as String?) ?? (key as String? ?? ''),
            email: (map['email'] as String?) ?? '',
            name: (map['name'] as String?) ?? '',
            profileImageUrl: map['profileImageUrl'] as String?,
            role: (map['role'] as String?) ?? 'user',
            workspaceId: (map['workspaceId'] as String?) ?? '',
            managerUserId: map['managerUserId'] as String?,
            invitedByUserId: map['invitedByUserId'] as String?,
            mustChangePassword: (map['mustChangePassword'] as bool?) ?? false,
            createdAt: DateTime.fromMillisecondsSinceEpoch(
                (map['createdAt'] as int?) ?? 0),
            lastLoginAt: map['lastLoginAt'] != null
                ? DateTime.fromMillisecondsSinceEpoch(map['lastLoginAt'] as int)
                : null,
          ));
        }
      });
      return users;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to list users: $e');
    }
  }

  // Department Management
  Future<String> createDepartment({
    required String workspaceId,
    required String name,
    required String createdBy,
  }) async {
    try {
      final departmentRef =
          _companiesRef.child(workspaceId).child('departments').push();
      final departmentId = departmentRef.key!;

      await departmentRef.set(<String, dynamic>{
        'id': departmentId,
        'name': name,
        'admins': <String>[createdBy],
        'users': <String>[createdBy],
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

      return departmentId;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to create department: $e');
    }
  }

  // User-Company Association
  Future<void> addUserToCompany({
    required String userId,
    required String workspaceId,
    String? departmentId,
  }) async {
    try {
      // Update user's company and department
      await _usersRef.child(userId).update(<String, dynamic>{
        'workspaceId': workspaceId,
        'departmentId': departmentId,
      });

      // Add user to company's user list
      if (departmentId != null) {
        await _companiesRef
            .child(workspaceId)
            .child('departments')
            .child(departmentId)
            .child('users')
            .child(userId)
            .set(true);
      }
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to add user to company: $e');
    }
  }

  // Check if company exists
  Future<bool> companyExists(String workspaceId) async {
    try {
      final snapshot = await _companiesRef.child(workspaceId).get();
      return snapshot.exists;
    } on Exception {
      return false;
    }
  }
}
