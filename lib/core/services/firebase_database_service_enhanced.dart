import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/features/auth/domain/entities/user.dart' as app_user;
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';
import 'package:todolist/features/reports/domain/entities/report.dart';
import 'package:todolist/core/constants/task_enums.dart';
import 'package:todolist/core/services/firebase_pagination_service.dart';
import 'package:todolist/core/services/pagination_service.dart' as pagination;

/// Enhanced Firebase Database Service with server-side pagination support
class FirebaseDatabaseServiceEnhanced extends GetxService {
  static FirebaseDatabaseServiceEnhanced get instance => Get.find<FirebaseDatabaseServiceEnhanced>();
  
  late FirebaseDatabase _database;
  late DatabaseReference _companiesRef;
  late DatabaseReference _usersRef;
  late FirebasePaginationService _paginationService;
  
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
    _paginationService = Get.find<FirebasePaginationService>();
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
      return await _paginationService.getPaginatedResultsWithFilters<TaskEntity>(
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
      throw ServerFailure(message: 'Failed to fetch paginated tasks: $e');
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
      throw ServerFailure(message: 'Failed to fetch paginated projects: $e');
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
        query = query.orderByChild('createdAt').startAt(startDate.millisecondsSinceEpoch);
      }
      if (endDate != null) {
        query = query.orderByChild('createdAt').endAt(endDate.millisecondsSinceEpoch);
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
            final report = ReportEntity.fromMap(Map<String, dynamic>.from(entry.value as Map));
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
        totalCount: reports.length, // Note: Firebase doesn't provide total count efficiently
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
        throw ServerFailure(message: 'Failed to fetch paginated reports: $e');
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
            final task = TaskEntity.fromMap(Map<String, dynamic>.from(entry.value as Map));
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
        throw ServerFailure(message: 'Failed to fetch optimized tasks: $e');
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
            final project = Project.fromMap(Map<String, dynamic>.from(entry.value as Map));
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
        throw ServerFailure(message: 'Failed to fetch optimized projects: $e');
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
    if (startDate != null) filters.add('startDate:${startDate.millisecondsSinceEpoch}');
    if (endDate != null) filters.add('endDate:${endDate.millisecondsSinceEpoch}');
    
    return 'reports_${workspaceId}_${filters.join('_')}';
  }

  // ============================================================================
  // EXISTING METHODS (delegated to original service)
  // ============================================================================

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
        throw ServerFailure(message: 'Failed to create user: $e');
    }
  }

  Future<app_user.User?> getUser(String userId) async {
    try {
      final snapshot = await _usersRef.child(userId).get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value! as Map);
        return app_user.User.fromMap(data);
      }
      return null;
    } catch (e) {
        throw ServerFailure(message: 'Failed to get user: $e');
    }
  }

  Future<void> updateUser(app_user.User user) async {
    try {
      await _usersRef.child(user.id).update({
        'name': user.name,
        'profileImageUrl': user.profileImageUrl,
        'role': user.role,
        'workspaceId': user.workspaceId,
        'managerUserId': user.managerUserId,
        'mustChangePassword': user.mustChangePassword,
        'lastLoginAt': user.lastLoginAt?.millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
        throw ServerFailure(message: 'Failed to update user: $e');
    }
  }

  Future<void> addUserToCompany({
    required String userId,
    required String workspaceId,
  }) async {
    try {
      await _companiesRef.child(workspaceId).child('users').child(userId).set({
        'userId': userId,
        'joinedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
        throw ServerFailure(message: 'Failed to add user to company: $e');
    }
  }

  // Task Management
  Future<String> createTask(TaskEntity task) async {
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
        throw ServerFailure(message: 'Failed to create task: $e');
    }
  }

  Future<TaskEntity?> getTask(String taskId, String workspaceId) async {
    try {
      final snapshot = await _tasksRef(workspaceId).child(taskId).get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value! as Map);
        return TaskEntity.fromMap(data);
      }
      return null;
    } catch (e) {
        throw ServerFailure(message: 'Failed to get task: $e');
    }
  }

  Future<void> updateTask(TaskEntity task) async {
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
      throw ServerFailure(message: 'Failed to update task: $e');
    }
  }

  Future<void> deleteTask(String taskId, String workspaceId) async {
    try {
      await _tasksRef(workspaceId).child(taskId).remove();
    } catch (e) {
        throw ServerFailure(message: 'Failed to delete task: $e');
    }
  }

  // Project Management
  Future<String> createProject(Project project) async {
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
      throw ServerFailure(message: 'Failed to create project: $e');
    }
  }

  Future<Project?> getProject(String projectId, String workspaceId) async {
    try {
      final snapshot = await _projectsRef(workspaceId).child(projectId).get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value! as Map);
        return Project.fromMap(data);
      }
      return null;
    } catch (e) {
        throw ServerFailure(message: 'Failed to get project: $e');
    }
  }

  Future<void> updateProject(Project project) async {
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
      throw ServerFailure(message: 'Failed to update project: $e');
    }
  }

  Future<void> deleteProject(String projectId, String workspaceId) async {
    try {
      await _projectsRef(workspaceId).child(projectId).remove();
    } catch (e) {
        throw ServerFailure(message: 'Failed to delete project: $e');
    }
  }

  // Report Management
  Future<String> createReport(ReportEntity report) async {
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
      throw ServerFailure(message: 'Failed to create report: $e');
    }
  }

  Future<ReportEntity?> getReport(String reportId, String workspaceId) async {
    try {
      final snapshot = await _reportsRef(workspaceId).child(reportId).get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value! as Map);
        return ReportEntity.fromMap(data);
      }
      return null;
    } catch (e) {
        throw ServerFailure(message: 'Failed to get report: $e');
    }
  }

  Future<void> updateReport(ReportEntity report) async {
    try {
      await _reportsRef(report.workspaceId).child(report.id).update({
        'summary': report.summary,
        'completedTaskIds': report.completedTaskIds,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
        throw ServerFailure(message: 'Failed to update report: $e');
    }
  }

  Future<void> deleteReport(String reportId, String workspaceId) async {
    try {
      await _reportsRef(workspaceId).child(reportId).remove();
    } catch (e) {
        throw ServerFailure(message: 'Failed to delete report: $e');
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
