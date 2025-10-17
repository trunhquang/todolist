import 'dart:io';
import 'package:flutter_test/flutter_test.dart' show TestWidgetsFlutterBinding;
import 'package:get/get.dart' as getx;
import 'package:hive/hive.dart' as hive;
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';
import 'package:todolist/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';
import 'package:todolist/features/invitations/domain/entities/invitation.dart';
import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/core/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestWorkspaceRepository implements WorkspaceRepository {
  bool allowInvite = true;
  Invitation? sendInvitationResult;
  List<Invitation> listInvitationsResult = const <Invitation>[];
  bool revokeOk = true;
  WorkspaceMember? acceptInvitationResult;

  @override
  Future<Either<Failure, bool>> hasPermission(String userId, String workspaceId, String permission) async {
    return Right(allowInvite);
  }

  @override
  Future<Either<Failure, Invitation>> sendInvitation({
    required String workspaceId,
    required String email,
    required String role,
  }) async {
    final result = sendInvitationResult;
    if (result == null) return Left(UnknownFailure(message: 'no result'));
    return Right(result);
  }

  @override
  Future<Either<Failure, List<Invitation>>> listInvitations(String workspaceId) async {
    return Right(listInvitationsResult);
  }

  @override
  Future<Either<Failure, void>> revokeInvitation({
    required String workspaceId,
    required String invitationId,
  }) async {
    if (!revokeOk) return Left(UnknownFailure(message: 'revoke failed'));
    return const Right(null);
  }

  @override
  Future<Either<Failure, WorkspaceMember>> acceptInvitation({
    required String invitationId,
    required String userId,
  }) async {
    final member = acceptInvitationResult;
    if (member == null) return Left(UnknownFailure(message: 'no member'));
    return Right(member);
  }

  // Unused methods in these tests
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('WorkspaceController - Invitations', () {
    late TestWorkspaceRepository repo;
    late WorkspaceController controller;
    const workspaceId = 'w1';
    const userId = 'u1';

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      getx.Get.testMode = true;
      SharedPreferences.setMockInitialValues(<String, Object>{});
      // Initialize Hive to a temp directory for tests
      final String tempPath = Directory.systemTemp.createTempSync().path;
      hive.Hive.init(tempPath);
      try {
        await StorageService().initialize();
      } catch (_) {}
      await StorageService().setUserId(userId);
      repo = TestWorkspaceRepository();
      controller = WorkspaceController(workspaceRepository: repo);
      controller.currentWorkspace.value = Workspace(
        id: workspaceId,
        name: 'W',
        type: WorkspaceType.company,
        createdBy: userId,
        createdAt: DateTime.now(),
      );

      // Default permission checks
      repo.allowInvite = true;
    });

    test('inviteUserToWorkspace sends invitation and updates list', () async {
      final inv = Invitation(
        id: 'inv1',
        workspaceId: workspaceId,
        email: 'test@example.com',
        role: WorkspaceRole.member.value,
        invitedByUserId: userId,
        createdAt: DateTime.now(),
      );

      repo.sendInvitationResult = inv;

      await controller.inviteUserToWorkspace('test@example.com');

      expect(controller.invitations.any((i) => i.id == 'inv1'), isTrue);
    });

    test('loadInvitations loads repository list', () async {
      final items = [
        Invitation(
          id: 'inv2',
          workspaceId: workspaceId,
          email: 'a@a.com',
          role: WorkspaceRole.member.value,
          invitedByUserId: userId,
          createdAt: DateTime.now(),
        ),
      ];
      repo.listInvitationsResult = items;

      await controller.loadInvitations();

      expect(controller.invitations.length, 1);
      expect(controller.invitations.first.id, 'inv2');
    });

    test('revokeInvitation marks item as revoked locally on success', () async {
      final inv = Invitation(
        id: 'inv3',
        workspaceId: workspaceId,
        email: 'b@b.com',
        role: WorkspaceRole.member.value,
        invitedByUserId: userId,
        createdAt: DateTime.now(),
      );
      controller.invitations.add(inv);

      repo.revokeOk = true;

      await controller.revokeInvitation('inv3');

      final updated = controller.invitations.firstWhere((i) => i.id == 'inv3');
      expect(updated.isRevoked, isTrue);
    });

    test('acceptInvitation removes invitation and adds member if same workspace', () async {
      final member = WorkspaceMember(
        userId: userId,
        workspaceId: workspaceId,
        role: WorkspaceRole.member,
        permissions: const <String>[],
        assignedBy: 'admin',
        assignedAt: DateTime.now(),
      );
      controller.invitations.add(Invitation(
        id: 'inv4',
        workspaceId: workspaceId,
        email: 'c@c.com',
        role: WorkspaceRole.member.value,
        invitedByUserId: 'admin',
        createdAt: DateTime.now(),
      ));

      repo.acceptInvitationResult = member;

      await controller.acceptInvitation('inv4');

      expect(controller.invitations.any((i) => i.id == 'inv4'), isFalse);
      expect(controller.workspaceMembers.any((mbr) => mbr.userId == userId), isTrue);
    });
  });
}


