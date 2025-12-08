import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/features/auth/domain/entities/user.dart' as app_user;
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';
import 'package:todolist/features/reports/domain/entities/report.dart';
import 'package:todolist/core/constants/task_enums.dart';
import 'package:todolist/core/services/firebase_pagination_service.dart';
import 'package:todolist/core/services/pagination_service.dart' as pagination;

import '../../features/invitations/domain/entities/invitation.dart';

class FirebaseDatabaseService extends GetxService {
  static FirebaseDatabaseService get instance =>
      Get.find<FirebaseDatabaseService>();

  late FirebaseDatabase _database;
  late DatabaseReference _workspacesRef;
  late DatabaseReference _usersRef;
  late FirebasePaginationService _paginationService;

  DatabaseReference _projectsRef(String workspaceId) =>
      _workspacesRef.child(workspaceId).child('projects');

  DatabaseReference _tasksRef(String workspaceId) =>
      _workspacesRef.child(workspaceId).child('tasks');

  DatabaseReference _reportsRef(String workspaceId) =>
      _workspacesRef.child(workspaceId).child('reports');

  @override
  Future<void> onInit() async {
    super.onInit();
    _database = FirebaseDatabase.instance;
    _workspacesRef = _database.ref('workspaces');
    _usersRef = _database.ref('users');
    _paginationService = Get.find<FirebasePaginationService>();
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
          _workspacesRef.child(workspaceId).child('departments').push();
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
        await _workspacesRef
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
      final snapshot = await _workspacesRef.child(workspaceId).get();
      return snapshot.exists;
    } on Exception {
      return false;
    }
  }

  // ============================================================================
  // ENHANCED PAGINATION METHODS
  // ============================================================================

  /// Get paginated tasks with true server-side pagination
  Future<pagination.PaginatedResult<TaskEntity>> getPaginatedTasks({
    required String workspaceId,
    int page = 1,
    int pageSize = 20,
    String? lastTaskId,
    TaskStatus? status,
    TaskPriority? priority,
    TaskType? type,
    String? projectId,
    String? assigneeId,
    String? orderBy = 'createdAt',
    bool ascending = false,
  }) async {
    try {
      final tasksRef = _tasksRef(workspaceId);

      // Build filters map
      final filters = <String, dynamic>{};
      if (status != null) filters['status'] = status.value;
      if (priority != null) filters['priority'] = priority.value;
      if (type != null) filters['taskType'] = type.value;
      if (projectId != null) filters['projectId'] = projectId;
      if (assigneeId != null) filters['assignee'] = assigneeId;

      // Use FirebasePaginationService for true server-side pagination
      return await _paginationService
          .getPaginatedResultsWithFilters<TaskEntity>(
        ref: tasksRef,
        fromMap: TaskEntity.fromMap,
        idField: 'id',
        page: page,
        pageSize: pageSize,
        lastItemId: lastTaskId,
        orderBy: orderBy,
        ascending: ascending,
        filters: filters.isNotEmpty ? filters : null,
        cacheKey: _buildTaskCacheKey(
          workspaceId: workspaceId,
          status: status,
          priority: priority,
          type: type,
          projectId: projectId,
          assigneeId: assigneeId,
        ),
      );
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to fetch paginated tasks: $e');
    }
  }

  /// Get paginated projects with true server-side pagination
  Future<pagination.PaginatedResult<Project>> getPaginatedProjects({
    required String workspaceId,
    int page = 1,
    int pageSize = 20,
    String? lastProjectId,
    ProjectStatus? status,
    String? orderBy = 'createdAt',
    bool ascending = false,
  }) async {
    try {
      final projectsRef = _projectsRef(workspaceId);

      // Build filters map
      final filters = <String, dynamic>{};
      if (status != null) filters['status'] = status.value;
      filters['workspaceId'] = workspaceId;

      // Use FirebasePaginationService for true server-side pagination
      return await _paginationService.getPaginatedResultsWithFilters<Project>(
        ref: projectsRef,
        fromMap: Project.fromMap,
        idField: 'id',
        page: page,
        pageSize: pageSize,
        lastItemId: lastProjectId,
        orderBy: orderBy,
        ascending: ascending,
        filters: filters.isNotEmpty ? filters : null,
        cacheKey: _buildProjectCacheKey(
          workspaceId: workspaceId,
          status: status,
        ),
      );
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to fetch paginated projects: $e');
    }
  }

  /// Get paginated reports with server-side pagination
  Future<PaginatedResult<ReportEntity>> getPaginatedReports({
    required String workspaceId,
    int page = 1,
    int pageSize = 20,
    String? lastReportId,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    String? orderBy = 'createdAt',
    bool ascending = false,
  }) async {
    try {
      final reportsRef = _reportsRef(workspaceId);
      Query query = reportsRef;

      // Apply filters
      if (userId != null) {
        query = query.orderByChild('userId').equalTo(userId);
      }
      if (startDate != null) {
        query = query
            .orderByChild('createdAt')
            .startAt(startDate.millisecondsSinceEpoch);
      }
      if (endDate != null) {
        query = query
            .orderByChild('createdAt')
            .endAt(endDate.millisecondsSinceEpoch);
      }

      // Apply ordering
      if (orderBy != null) {
        query = query.orderByChild(orderBy);
      }
      if (!ascending) {
        query = query.limitToLast(pageSize);
      } else {
        query = query.limitToFirst(pageSize);
      }

      // Apply pagination
      if (lastReportId != null) {
        if (ascending) {
          query = query.startAt(lastReportId);
        } else {
          query = query.endAt(lastReportId);
        }
      }

      final snapshot = await query.get();
      final reports = <ReportEntity>[];

      if (snapshot.exists) {
        final data = snapshot.value! as Map<dynamic, dynamic>;
        for (final entry in data.entries) {
          try {
            final report = ReportEntity.fromMap(
                Map<String, dynamic>.from(entry.value as Map));
            reports.add(report);
          } catch (e) {
            // Skip invalid report data
            continue;
          }
        }
      }

      // Reverse if descending order was used
      if (!ascending) {
        reports.reversed.toList();
      }

      // Check if there are more pages
      final hasNextPage = reports.length == pageSize;
      final hasPreviousPage = page > 1;

      return PaginatedResult<ReportEntity>(
        data: reports,
        page: page,
        pageSize: pageSize,
        totalCount: reports.length,
        // Note: Firebase doesn't provide total count efficiently
        hasNextPage: hasNextPage,
        hasPreviousPage: hasPreviousPage,
        cacheKey: _buildReportCacheKey(
          workspaceId: workspaceId,
          userId: userId,
          startDate: startDate,
          endDate: endDate,
        ),
      );
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to fetch paginated reports: $e');
    }
  }

  // ============================================================================
  // OPTIMIZED QUERY METHODS
  // ============================================================================

  /// Get tasks with optimized queries for specific use cases
  Future<List<TaskEntity>> getTasksOptimized({
    required String workspaceId,
    TaskStatus? status,
    TaskPriority? priority,
    TaskType? type,
    String? projectId,
    String? assigneeId,
    int? limit,
    String? orderBy = 'createdAt',
    bool ascending = false,
  }) async {
    try {
      final tasksRef = _tasksRef(workspaceId);
      Query query = tasksRef;

      // Apply filters
      if (status != null) {
        query = query.orderByChild('status').equalTo(status.value);
      }
      if (priority != null) {
        query = query.orderByChild('priority').equalTo(priority.value);
      }
      if (type != null) {
        query = query.orderByChild('taskType').equalTo(type.value);
      }
      if (projectId != null) {
        query = query.orderByChild('projectId').equalTo(projectId);
      }
      if (assigneeId != null) {
        query = query.orderByChild('assigneeId').equalTo(assigneeId);
      }

      // Apply ordering and limit
      if (orderBy != null) {
        query = query.orderByChild(orderBy);
      }
      if (limit != null) {
        if (ascending) {
          query = query.limitToFirst(limit);
        } else {
          query = query.limitToLast(limit);
        }
      }

      final snapshot = await query.get();
      final tasks = <TaskEntity>[];

      if (snapshot.exists) {
        final data = snapshot.value! as Map<dynamic, dynamic>;
        for (final entry in data.entries) {
          try {
            final task = TaskEntity.fromMap(
                Map<String, dynamic>.from(entry.value as Map));
            tasks.add(task);
          } catch (e) {
            // Skip invalid task data
            continue;
          }
        }
      }

      // Reverse if descending order was used
      if (!ascending) {
        tasks.reversed.toList();
      }

      return tasks;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to fetch optimized tasks: $e');
    }
  }

  /// Get projects with optimized queries for specific use cases
  Future<List<Project>> getProjectsOptimized({
    required String workspaceId,
    ProjectStatus? status,
    int? limit,
    String? orderBy = 'createdAt',
    bool ascending = false,
  }) async {
    try {
      final projectsRef = _projectsRef(workspaceId);
      Query query = projectsRef;

      // Apply filters
      if (status != null) {
        query = query.orderByChild('status').equalTo(status.value);
      }
      query = query.orderByChild('workspaceId').equalTo(workspaceId);

      // Apply ordering and limit
      if (orderBy != null) {
        query = query.orderByChild(orderBy);
      }
      if (limit != null) {
        if (ascending) {
          query = query.limitToFirst(limit);
        } else {
          query = query.limitToLast(limit);
        }
      }

      final snapshot = await query.get();
      final projects = <Project>[];

      if (snapshot.exists) {
        final data = snapshot.value! as Map<dynamic, dynamic>;
        for (final entry in data.entries) {
          try {
            final project =
                Project.fromMap(Map<String, dynamic>.from(entry.value as Map));
            projects.add(project);
          } catch (e) {
            // Skip invalid project data
            continue;
          }
        }
      }

      // Reverse if descending order was used
      if (!ascending) {
        projects.reversed.toList();
      }

      return projects;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to fetch optimized projects: $e');
    }
  }

  // ============================================================================
  // CACHE KEY BUILDERS
  // ============================================================================

  String _buildTaskCacheKey({
    required String workspaceId,
    TaskStatus? status,
    TaskPriority? priority,
    TaskType? type,
    String? projectId,
    String? assigneeId,
  }) {
    final filters = <String>[];
    if (status != null) filters.add('status:${status.value}');
    if (priority != null) filters.add('priority:${priority.value}');
    if (type != null) filters.add('type:${type.value}');
    if (projectId != null) filters.add('projectId:$projectId');
    if (assigneeId != null) filters.add('assigneeId:$assigneeId');

    return 'tasks_${workspaceId}_${filters.join('_')}';
  }

  String _buildProjectCacheKey({
    required String workspaceId,
    ProjectStatus? status,
  }) {
    final filters = <String>[];
    if (status != null) filters.add('status:${status.value}');
    filters.add('workspaceId:$workspaceId');

    return 'projects_${workspaceId}_${filters.join('_')}';
  }

  String _buildReportCacheKey({
    required String workspaceId,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final filters = <String>[];
    if (userId != null) filters.add('userId:$userId');
    if (startDate != null)
      filters.add('startDate:${startDate.millisecondsSinceEpoch}');
    if (endDate != null)
      filters.add('endDate:${endDate.millisecondsSinceEpoch}');

    return 'reports_${workspaceId}_${filters.join('_')}';
  }

  // ============================================================================
  // ADDITIONAL METHODS FROM ENHANCED VERSION
  // ============================================================================

  /// Create task (alternative signature from enhanced version)
  Future<String> createTaskFromEntity(TaskEntity task) async {
    try {
      final taskRef = _tasksRef(task.workspaceId).push();
      final taskId = taskRef.key!;

      await taskRef.set({
        'id': taskId,
        'title': task.title,
        'description': task.description,
        'status': task.status,
        'priority': task.priority,
        'taskType': task.taskType,
        'projectId': task.projectId,
        'assignee': task.assignee,
        'assigner': task.assigner,
        'workspaceId': task.workspaceId,
        'createdAt': task.createdAt.millisecondsSinceEpoch,
        'updatedAt': task.updatedAt?.millisecondsSinceEpoch,
        'deadline': task.deadline?.millisecondsSinceEpoch,
        'recurring': task.recurring.toMap(),
      });

      return taskId;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to create task: $e');
    }
  }

  /// Get task (alternative signature from enhanced version)
  Future<TaskEntity?> getTaskById(String taskId, String workspaceId) async {
    return await getTask(workspaceId: workspaceId, taskId: taskId);
  }

  /// Update task (alternative signature from enhanced version)
  Future<void> updateTaskFromEntity(TaskEntity task) async {
    try {
      await _tasksRef(task.workspaceId).child(task.id).update({
        'title': task.title,
        'description': task.description,
        'status': task.status,
        'priority': task.priority,
        'taskType': task.taskType,
        'projectId': task.projectId,
        'assignee': task.assignee,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
        'deadline': task.deadline?.millisecondsSinceEpoch,
        'recurring': task.recurring.toMap(),
      });
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to update task: $e');
    }
  }

  /// Delete task (hard delete from enhanced version)
  Future<void> deleteTask(String taskId, String workspaceId) async {
    try {
      await _tasksRef(workspaceId).child(taskId).remove();
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to delete task: $e');
    }
  }

  /// Create project (alternative signature from enhanced version)
  Future<String> createProjectFromEntity(Project project) async {
    try {
      final projectRef = _projectsRef(project.workspaceId).push();
      final projectId = projectRef.key!;

      await projectRef.set({
        'id': projectId,
        'title': project.title,
        'description': project.description,
        'status': project.status,
        'workspaceId': project.workspaceId,
        'createdBy': project.createdBy,
        'createdAt': project.createdAt.millisecondsSinceEpoch,
        'deadline': project.deadline?.millisecondsSinceEpoch,
      });

      return projectId;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to create project: $e');
    }
  }

  /// Get project (alternative signature from enhanced version)
  Future<Project?> getProjectById(String projectId, String workspaceId) async {
    return await getProject(workspaceId: workspaceId, projectId: projectId);
  }

  /// Update project (alternative signature from enhanced version)
  Future<void> updateProjectFromEntity(Project project) async {
    try {
      await _projectsRef(project.workspaceId).child(project.id).update({
        'title': project.title,
        'description': project.description,
        'status': project.status,
        'workspaceId': project.workspaceId,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
        'deadline': project.deadline?.millisecondsSinceEpoch,
      });
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to update project: $e');
    }
  }

  /// Delete project (hard delete from enhanced version)
  Future<void> deleteProject(String projectId, String workspaceId) async {
    try {
      await _projectsRef(workspaceId).child(projectId).remove();
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to delete project: $e');
    }
  }

  /// Create report (alternative signature from enhanced version)
  Future<String> createReportFromEntity(ReportEntity report) async {
    try {
      final reportRef = _reportsRef(report.workspaceId).push();
      final reportId = reportRef.key!;

      await reportRef.set({
        'id': reportId,
        'userId': report.userId,
        'summary': report.summary,
        'completedTaskIds': report.completedTaskIds,
        'workspaceId': report.workspaceId,
        'createdAt': report.createdAt?.millisecondsSinceEpoch,
        'submittedAt': report.submittedAt?.millisecondsSinceEpoch,
      });

      return reportId;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to create report: $e');
    }
  }

  /// Get report (alternative signature from enhanced version)
  Future<ReportEntity?> getReportById(String reportId, String workspaceId) async {
    return await getReport(workspaceId: workspaceId, reportId: reportId);
  }

  /// Update report (alternative signature from enhanced version)
  Future<void> updateReportFromEntity(ReportEntity report) async {
    try {
      await _reportsRef(report.workspaceId).child(report.id).update({
        'summary': report.summary,
        'completedTaskIds': report.completedTaskIds,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to update report: $e');
    }
  }

  /// Delete report (hard delete from enhanced version)
  Future<void> deleteReport(String reportId, String workspaceId) async {
    try {
      await _reportsRef(workspaceId).child(reportId).remove();
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to delete report: $e');
    }
  }

  // ============================================================================
  // INVITATION METHODS
  // ============================================================================

  /// Create invitation in database
  Future<void> createInvitation(Invitation invitation) async {
    try {
      final ref = _database.ref(
          'workspace_invitations/${invitation.workspaceId}/${invitation.id}');
      await ref.set(invitation.toMap());
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to create invitation: $e');
    }
  }

  /// Get invitation by ID
  Future<Invitation?> getInvitation(String invitationId) async {
    try {
      final ref = _database.ref('workspace_invitations');
      final snapshot = await ref.orderByChild('id').equalTo(invitationId).get();

      if (!snapshot.exists) return null;

      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return null;

      // Find the invitation with matching ID and map to Invitation entity
      for (final entry in data.entries) {
        final workspaceInvitations = entry.value as Map<dynamic, dynamic>?;
        if (workspaceInvitations == null) continue;

        for (final invEntry in workspaceInvitations.entries) {
          final invitationData = invEntry.value as Map<dynamic, dynamic>?;
          if (invitationData == null) continue;

          if (invitationData['id']?.toString() == invitationId) {
            final mapped =
                Invitation.fromMap(Map<String, dynamic>.from(invitationData), id: invitationId);
            return mapped;
          }
        }
      }

      return null;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to get invitation: $e');
    }
  }

  /// Update invitation status
  Future<void> updateInvitationStatus({
    required String invitationId,
    required String workspaceId,
    required bool isAccepted,
  }) async {
    try {
      final ref = _database.ref('workspace_invitations/$workspaceId/$invitationId');
      await ref.update({
        'isAccepted': isAccepted,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
        'isWaiting': false
      });
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to update invitation status: $e');
    }
  }

  /// Create user with password change flag
  Future<void> createUserWithPasswordChangeFlag({
    required String userId,
    required String email,
    String? name,
    required bool mustChangePassword,
  }) async {
    try {
      final user = app_user.User(
        id: userId,
        email: email,
        name: name ?? '',
        profileImageUrl: null,
        role: 'regularUser',
        workspaceId: '',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        mustChangePassword: mustChangePassword,
      );

      await _usersRef.child(userId).set(user.toMap());
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to create user with password change flag: $e');
    }
  }

  /// Get user by email
  Future<app_user.User?> getUserByEmail(String email) async {
    try {
      final snapshot =
          await _usersRef.orderByChild('email').equalTo(email).get();

      if (!snapshot.exists) return null;

      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null || data.isEmpty) return null;

      final userData = data.values.first as Map<dynamic, dynamic>?;
      if (userData == null) return null;

      return app_user.User.fromMap(Map<String, dynamic>.from(userData));
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to get user by email: $e');
    }
  }

  /// Create notification
  Future<void> createNotification({
    required String userId,
    required String type,
    required String title,
    required String message,
    required Map<String, dynamic> data,
  }) async {
    try {
      final notificationId = DateTime.now().millisecondsSinceEpoch.toString();
      final notification = {
        'id': notificationId,
        'userId': userId,
        'type': type,
        'title': title,
        'message': message,
        'data': data,
        'isRead': false,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      };

      await _database
          .ref('notifications/$userId/$notificationId')
          .set(notification);
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to create notification: $e');
    }
  }

  /// Add workspace member
  Future<void> addWorkspaceMember(dynamic member) async {
    try {
      final ref =
          _database.ref('workspace_members/${member.workspaceId}/${member.id}');
      await ref.set(member.toMap());
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to add workspace member: $e');
    }
  }

  /// Get notifications for a user
  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    try {
      final ref = _database.ref('notifications/$userId');
      final snapshot = await ref.get();

      if (!snapshot.exists) return [];

      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];

      final notifications = <Map<String, dynamic>>[];
      for (final entry in data.entries) {
        final notificationData = entry.value as Map<dynamic, dynamic>?;
        if (notificationData != null) {
          notifications.add(Map<String, dynamic>.from(notificationData));
        }
      }

      return notifications;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to get notifications: $e');
    }
  }

  /// Get pending invitations for a user by email
  Future<List<Map<String, dynamic>>> getPendingInvitationsForUser(
      String email) async {
    try {
      final ref = _database.ref('workspace_invitations');
      final snapshot = await ref.get();

      if (!snapshot.exists) return [];

      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];

      final pendingInvitations = <Map<String, dynamic>>[];

      for (final workspaceEntry in data.entries) {
        final workspaceInvitations =
            workspaceEntry.value as Map<dynamic, dynamic>?;
        if (workspaceInvitations != null) {
          for (final invitationEntry in workspaceInvitations.entries) {
            final invitationData =
                invitationEntry.value as Map<dynamic, dynamic>?;
            if (invitationData != null &&
                invitationData['email'] == email &&
                invitationData['isAccepted'] == false &&
                invitationData['isRevoked'] == false) {
              pendingInvitations.add(Map<String, dynamic>.from(invitationData));
            }
          }
        }
      }

      return pendingInvitations;
    } catch (e) {
      debugPrint('$e');
      throw DatabaseFailure(message: 'Failed to get pending invitations: $e');
    }
  }
}

/// Paginated result model
class PaginatedResult<T> {
  const PaginatedResult({
    required this.data,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.cacheKey,
    this.error,
  });

  final List<T> data;
  final int page;
  final int pageSize;
  final int totalCount;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String cacheKey;
  final String? error;

  bool get hasError => error != null;
}
