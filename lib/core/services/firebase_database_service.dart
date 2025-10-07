import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/features/auth/domain/entities/user.dart' as app_user;
import 'package:todolist/features/auth/domain/entities/company.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';

class FirebaseDatabaseService extends GetxService {
  static FirebaseDatabaseService get instance => Get.find<FirebaseDatabaseService>();
  
  late FirebaseDatabase _database;
  late DatabaseReference _companiesRef;
  late DatabaseReference _usersRef;
  
  DatabaseReference _projectsRef(String companyId) =>
      _companiesRef.child(companyId).child('projects');
  DatabaseReference _tasksRef(String companyId) =>
      _companiesRef.child(companyId).child('tasks');

  @override
  Future<void> onInit() async {
    super.onInit();
    _database = FirebaseDatabase.instance;
    _companiesRef = _database.ref('companies');
    _usersRef = _database.ref('users');
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
        'companyId': user.companyId,
        'departmentId': user.departmentId,
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
        companyId: (data['companyId'] as String?) ?? '',
        departmentId: data['departmentId'] as String?,
        managerUserId: data['managerUserId'] as String?,
        invitedByUserId: data['invitedByUserId'] as String?,
        mustChangePassword: (data['mustChangePassword'] as bool?) ?? false,
        createdAt: DateTime.fromMillisecondsSinceEpoch((data['createdAt'] as int?) ?? 0),
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
    required String companyId,
    required Project project,
  }) async {
    try {
      final ref = _projectsRef(companyId).push();
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
    required String companyId,
    required String projectId,
  }) async {
    try {
      final snapshot = await _projectsRef(companyId).child(projectId).get();
      if (!snapshot.exists) return null;
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return null;
      return Project.fromMap(data);
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to get project: $e');
    }
  }

  Future<void> updateProject({
    required String companyId,
    required Project project,
  }) async {
    try {
      await _projectsRef(companyId).child(project.id).update(project.toMap());
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to update project: $e');
    }
  }

  Future<void> softDeleteProject({
    required String companyId,
    required String projectId,
  }) async {
    try {
      await _projectsRef(companyId)
          .child(projectId)
          .update({'deletedAt': DateTime.now().millisecondsSinceEpoch});
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to delete project: $e');
    }
  }

  // Task Management
  Future<String> createTask({
    required String companyId,
    required TaskEntity task,
  }) async {
    try {
      final ref = _tasksRef(companyId).push();
      final id = ref.key!;
      await ref.set({
        ...task.copyWith(id: id, createdAt: DateTime.now()).toMap(),
      });
      return id;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to create task: $e');
    }
  }

  Future<TaskEntity?> getTask({
    required String companyId,
    required String taskId,
  }) async {
    try {
      final snapshot = await _tasksRef(companyId).child(taskId).get();
      if (!snapshot.exists) return null;
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return null;
      return TaskEntity.fromMap(data);
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to get task: $e');
    }
  }

  Future<void> updateTask({
    required String companyId,
    required TaskEntity task,
  }) async {
    try {
      await _tasksRef(companyId).child(task.id).update({
        ...task.toMap(),
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to update task: $e');
    }
  }

  Future<void> softDeleteTask({
    required String companyId,
    required String taskId,
  }) async {
    try {
      await _tasksRef(companyId)
          .child(taskId)
          .update({'deletedAt': DateTime.now().millisecondsSinceEpoch});
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to delete task: $e');
    }
  }

  Future<void> updateUser(app_user.User user) async {
    try {
      await _usersRef.child(user.id).update({
        'name': user.name,
        'profileImageUrl': user.profileImageUrl,
        'role': user.role,
        'companyId': user.companyId,
        'departmentId': user.departmentId,
        'managerUserId': user.managerUserId,
        'invitedByUserId': user.invitedByUserId,
        'mustChangePassword': user.mustChangePassword,
        'lastLoginAt': user.lastLoginAt?.millisecondsSinceEpoch,
      });
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to update user: $e');
    }
  }

  // Company Management
  Future<String> createCompany(Company company) async {
    try {
      final companyRef = _companiesRef.push();
      final companyId = companyRef.key!;
      
      await companyRef.set(<String, dynamic>{
        'id': companyId,
        'name': company.name,
        'description': company.description,
        'createdBy': company.createdBy,
        'createdAt': company.createdAt.millisecondsSinceEpoch,
        'departments': <String, dynamic>{},
        'projects': <String, dynamic>{},
        'tasks': <String, dynamic>{},
        'reports': <String, dynamic>{},
      });

      return companyId;
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to create company: $e');
    }
  }

  Future<Company?> getCompany(String companyId) async {
    try {
      final snapshot = await _companiesRef.child(companyId).get();
      if (!snapshot.exists) return null;

      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return null;
      
      return Company(
        id: (data['id'] as String?) ?? '',
        name: (data['name'] as String?) ?? '',
        description: data['description'] as String?,
        createdBy: (data['createdBy'] as String?) ?? '',
        createdAt: DateTime.fromMillisecondsSinceEpoch((data['createdAt'] as int?) ?? 0),
      );
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to get company: $e');
    }
  }

  Future<void> updateCompany(Company company) async {
    try {
      await _companiesRef.child(company.id).update(<String, dynamic>{
        'name': company.name,
        'description': company.description,
      });
    } catch (e) {
      throw DatabaseFailure(message: 'Failed to update company: $e');
    }
  }

  // Department Management
  Future<String> createDepartment({
    required String companyId,
    required String name,
    required String createdBy,
  }) async {
    try {
      final departmentRef = _companiesRef.child(companyId).child('departments').push();
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
    required String companyId,
    String? departmentId,
  }) async {
    try {
      // Update user's company and department
      await _usersRef.child(userId).update(<String, dynamic>{
        'companyId': companyId,
        'departmentId': departmentId,
      });

      // Add user to company's user list
      if (departmentId != null) {
        await _companiesRef
            .child(companyId)
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
  Future<bool> companyExists(String companyId) async {
    try {
      final snapshot = await _companiesRef.child(companyId).get();
      return snapshot.exists;
    } on Exception catch (e) {
      return false;
    }
  }

  // Get user's company
  Future<Company?> getUserCompany(String userId) async {
    try {
      final user = await getUser(userId);
      if (user == null || user.companyId.isEmpty) return null;
      
      return await getCompany(user.companyId);
    } on Exception catch (e) {
      return null;
    }
  }
}
