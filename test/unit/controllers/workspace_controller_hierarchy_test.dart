import 'dart:io';
import 'package:get/get.dart' as getx;
import 'package:hive/hive.dart' as hive;
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';
import 'package:todolist/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';
import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/core/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestWorkspaceRepository implements WorkspaceRepository {
  bool allowManageUsers = true;
  WorkspaceMember? updateManagerResult;
  List<WorkspaceMember> listTeamResult = const <WorkspaceMember>[];

  @override
  Future<Either<Failure, bool>> hasPermission(String userId, String workspaceId, String permission) async {
    return Right(allowManageUsers);
  }

  @override
  Future<Either<Failure, WorkspaceMember>> updateManager({
    required String workspaceId,
    required String userId,
    required String? managerUserId,
  }) async {
    if (updateManagerResult == null) {
      return const Left(UnknownFailure(message: 'no result'));
    }
    return Right(updateManagerResult!);
  }

  @override
  Future<Either<Failure, List<WorkspaceMember>>> listTeam({
    required String workspaceId,
    required String managerUserId,
  }) async {
    return Right(listTeamResult);
  }

  // Unused methods in these tests
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('WorkspaceController - Hierarchy', () {
    late TestWorkspaceRepository repo;
    late WorkspaceController controller;
    const workspaceId = 'w1';
    const managerId = 'm1';
    const userId = 'u1';

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      getx.Get.testMode = true;
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final tempPath = Directory.systemTemp.createTempSync().path;
      hive.Hive.init(tempPath);
      repo = TestWorkspaceRepository();
      controller = WorkspaceController(workspaceRepository: repo);
      try {
        await StorageService().initialize();
      } catch (_) {}
      await StorageService().setUserId(managerId);
      controller.currentWorkspace.value = Workspace(
        id: workspaceId,
        name: 'W',
        type: WorkspaceType.company,
        createdBy: managerId,
        createdAt: DateTime.now(),
      );
      controller.workspaceMembers.addAll([
        WorkspaceMember(
          userId: managerId,
          workspaceId: workspaceId,
          role: WorkspaceRole.admin,
          permissions: const <String>[],
          assignedBy: 'sys',
          assignedAt: DateTime.now(),
          name: 'Manager',
          email: 'manager@example.com',
        ),
        WorkspaceMember(
          userId: userId,
          workspaceId: workspaceId,
          role: WorkspaceRole.member,
          permissions: const <String>[],
          assignedBy: 'sys',
          assignedAt: DateTime.now(),
          name: 'Member',
          email: 'member@example.com',
        ),
      ]);

      // Allow manage users
      repo.allowManageUsers = true;
    });

    test('setManager updates member and persists', () async {
      final updated = controller.workspaceMembers
          .firstWhere((m) => m.userId == userId)
          .copyWith(managerUserId: managerId);
      repo.updateManagerResult = updated;

      await controller.setManager(userId: userId, managerUserId: managerId);

      final result = controller.workspaceMembers.firstWhere((m) => m.userId == userId);
      expect(result.managerUserId, managerId);
    });

    test('loadTeam returns members with given manager', () async {
      final team = [
        WorkspaceMember(
          userId: userId,
          workspaceId: workspaceId,
          role: WorkspaceRole.member,
          permissions: const <String>[],
          assignedBy: 'sys',
          assignedAt: DateTime.now(),
          managerUserId: managerId,
          name: 'Member',
          email: 'member@example.com',
        ),
      ];
      repo.listTeamResult = team;

      final result = await controller.loadTeam(managerId);
      expect(result.length, 1);
      expect(result.first.managerUserId, managerId);
    });
  });
}


