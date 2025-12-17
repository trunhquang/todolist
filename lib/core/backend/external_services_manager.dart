import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:todolist/core/backend/backend_service.dart';
// FirebasePaginationService removed; using client-side pagination fallback
import 'package:todolist/core/services/pagination_service.dart' as pagination;

import 'backend_service_interface.dart';

/// External Services Manager Implementation
class ExternalServicesManager extends GetxService implements ExternalServicesInterface {
  late FirebaseDatabase _database;
  late DatabaseReference _workspacesRef;
  late DatabaseReference _usersRef;

  @override
  Future<void> onInit() async {
    super.onInit();
    _database = FirebaseDatabase.instance;
    _workspacesRef = _database.ref('workspaces');
    _usersRef = _database.ref('users');
  }

  // ============================================================================
  // TASK OPERATIONS
  // ============================================================================

  @override
  Future<Map<String, dynamic>> createTask(Map<String, dynamic> data) async {
    try {
      final workspaceId = data['workspaceId'] as String;
      final taskRef = _workspacesRef.child(workspaceId).child('tasks').push();
      final taskId = taskRef.key!;
      
      final taskData = {
        ...data,
        'id': taskId,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };
      
      await taskRef.set(taskData);
      return taskData;
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTasks(String workspaceId) async {
    try {
      final snapshot = await _workspacesRef.child(workspaceId).child('tasks').get();
      if (!snapshot.exists) return [];
      
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      
      return data.entries.map((entry) {
        final taskData = entry.value as Map<dynamic, dynamic>;
        return Map<String, dynamic>.from(taskData);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateTask(String taskId, Map<String, dynamic> data) async {
    try {
      final workspaceId = data['workspaceId'] as String;
      final taskRef = _workspacesRef.child(workspaceId).child('tasks').child(taskId);
      
      final updatedData = {
        ...data,
        'id': taskId,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };
      
      await taskRef.update(updatedData);
      return updatedData;
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String taskId, String workspaceId) async {
    try {
      final taskRef = _workspacesRef.child(workspaceId).child('tasks').child(taskId);
      await taskRef.remove();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  // ============================================================================
  // USER OPERATIONS
  // ============================================================================

  @override
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> data) async {
    try {
      final userId = data['id'] as String;
      final userRef = _usersRef.child(userId);
      
      final userData = {
        ...data,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };
      
      await userRef.set(userData);
      return userData;
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUsers(String workspaceId) async {
    try {
      // Get workspace members
      final membersSnapshot = await _workspacesRef.child(workspaceId).child('members').get();
      if (!membersSnapshot.exists) return [];
      
      final Map<dynamic, dynamic>? membersData = membersSnapshot.value as Map<dynamic, dynamic>?;
      if (membersData == null) return [];
      
      final List<Map<String, dynamic>> users = [];
      for (final memberId in membersData.keys) {
        final userSnapshot = await _usersRef.child(memberId as String).get();
        if (userSnapshot.exists) {
          final userData = userSnapshot.value as Map<dynamic, dynamic>;
          users.add(Map<String, dynamic>.from(userData));
        }
      }
      
      return users;
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      final userRef = _usersRef.child(userId);
      
      final updatedData = {
        ...data,
        'id': userId,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };
      
      await userRef.update(updatedData);
      return updatedData;
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // ============================================================================
  // WORKSPACE OPERATIONS
  // ============================================================================

  @override
  Future<Map<String, dynamic>> createWorkspace(Map<String, dynamic> data) async {
    try {
      final workspaceRef = _workspacesRef.push();
      final workspaceId = workspaceRef.key!;
      
      final workspaceData = {
        ...data,
        'id': workspaceId,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };
      
      await workspaceRef.set(workspaceData);
      return workspaceData;
    } catch (e) {
      throw Exception('Failed to create workspace: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getWorkspaces(String userId) async {
    try {
      final snapshot = await _workspacesRef.get();
      if (!snapshot.exists) return [];
      
      final Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      
      final List<Map<String, dynamic>> workspaces = [];
      for (final entry in data.entries) {
        final workspaceData = entry.value as Map<dynamic, dynamic>;
        final workspaceId = entry.key as String;
        
        // Check if user is a member of this workspace
        final memberSnapshot = await _workspacesRef.child(workspaceId).child('members').child(userId).get();
        if (memberSnapshot.exists) {
          workspaces.add({
            ...Map<String, dynamic>.from(workspaceData),
            'id': workspaceId,
          });
        }
      }
      
      return workspaces;
    } catch (e) {
      throw Exception('Failed to get workspaces: $e');
    }
  }

  @override
  Future<void> switchWorkspace(String userId, String workspaceId) async {
    try {
      // Update user's current workspace preference
      await _usersRef.child(userId).child('preferences').child('currentWorkspaceId').set(workspaceId);
    } catch (e) {
      throw Exception('Failed to switch workspace: $e');
    }
  }

  // ============================================================================
  // PERMISSION OPERATIONS
  // ============================================================================

  @override
  Future<bool> checkPermission(String userId, String permission, String workspaceId) async {
    try {
      final memberSnapshot = await _workspacesRef
          .child(workspaceId)
          .child('members')
          .child(userId)
          .get();
      
      if (!memberSnapshot.exists) return false;
      
      final memberData = memberSnapshot.value as Map<dynamic, dynamic>;
      final permissions = memberData['permissions'] as List<dynamic>? ?? [];
      
      return permissions.contains(permission);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<String>> getUserPermissions(String userId, String workspaceId) async {
    try {
      final memberSnapshot = await _workspacesRef
          .child(workspaceId)
          .child('members')
          .child(userId)
          .get();
      
      if (!memberSnapshot.exists) return [];
      
      final memberData = memberSnapshot.value as Map<dynamic, dynamic>;
      final permissions = memberData['permissions'] as List<dynamic>? ?? [];
      
      return permissions.cast<String>();
    } catch (e) {
      return [];
    }
  }

  // ============================================================================
  // EVENT HANDLING
  // ============================================================================

  @override
  Future<void> handleEvent(Event event) async {
    try {
      // Log event to Firebase
      final eventRef = _database.ref('events').push();
      await eventRef.set({
        'type': event.type,
        'data': event.data,
        'timestamp': event.timestamp.millisecondsSinceEpoch,
        'userId': event.userId,
        'workspaceId': event.workspaceId,
      });
      
      // Handle specific event types
      switch (event.type) {
        case 'task_created':
          await _handleTaskCreatedEvent(event);
          break;
        case 'task_updated':
          await _handleTaskUpdatedEvent(event);
          break;
        case 'task_deleted':
          await _handleTaskDeletedEvent(event);
          break;
        default:
          // Handle other event types
          break;
      }
    } catch (e) {
      // Log error but don't throw to avoid breaking the main flow
      print('Error handling event: $e');
    }
  }

  Future<void> _handleTaskCreatedEvent(Event event) async {
    // Send notifications, update analytics, etc.
  }

  Future<void> _handleTaskUpdatedEvent(Event event) async {
    // Send notifications, update analytics, etc.
  }

  Future<void> _handleTaskDeletedEvent(Event event) async {
    // Clean up related data, send notifications, etc.
  }

  // ============================================================================
  // PAGINATION SUPPORT
  // ============================================================================

  /// Get paginated tasks with server-side pagination
  Future<pagination.PaginatedResult<Map<String, dynamic>>> getPaginatedTasks({
    required String workspaceId,
    int page = 1,
    int pageSize = 20,
    String? lastTaskId,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final tasksRef = _workspacesRef.child(workspaceId).child('tasks');

      final snapshot = await tasksRef.get();
      if (!snapshot.exists) {
        return pagination.PaginatedResult<Map<String, dynamic>>(
          data: [],
          page: page,
          pageSize: pageSize,
          hasNextPage: false,
          hasPreviousPage: page > 1,
          totalCount: 0,
          cacheKey: 'tasks_$workspaceId',
        );
      }

      final data = snapshot.value! as Map<dynamic, dynamic>;
      final entries = data.entries.map((e) {
        final map = Map<String, dynamic>.from(e.value as Map);
        map['id'] = e.key as String;
        return map;
      }).toList();

      // Apply filters (simple equality checks)
      final filtered = (filters == null || filters.isEmpty)
          ? entries
          : entries.where((item) {
              for (final f in filters.entries) {
                if (item[f.key] != f.value) return false;
              }
              return true;
            }).toList();

      // Sort by createdAt descending (most recent first)
      filtered.sort((a, b) {
        final aVal = a['createdAt'] as int? ?? 0;
        final bVal = b['createdAt'] as int? ?? 0;
        return bVal.compareTo(aVal);
      });

      final totalCount = filtered.length;
      final start = (page - 1) * pageSize;
      final pageItems = start >= totalCount
          ? <Map<String, dynamic>>[]
          : filtered.skip(start).take(pageSize).toList();

      return pagination.PaginatedResult<Map<String, dynamic>>(
        data: pageItems,
        page: page,
        pageSize: pageSize,
        hasNextPage: start + pageSize < totalCount,
        hasPreviousPage: page > 1,
        totalCount: totalCount,
        cacheKey: 'tasks_$workspaceId',
      );
    } catch (e) {
      throw Exception('Failed to get paginated tasks: $e');
    }
  }
}
