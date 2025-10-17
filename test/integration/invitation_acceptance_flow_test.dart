import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

import 'package:todolist/features/workspace/data/repositories/workspace_repository_impl.dart';
import 'package:todolist/features/workspace/data/datasources/workspace_remote_data_source.dart';
import 'package:todolist/features/workspace/data/datasources/workspace_local_data_source.dart';
import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/core/errors/exceptions.dart';
import 'package:todolist/core/services/storage_service.dart';
import 'package:todolist/features/invitations/domain/entities/invitation.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';

class TestWorkspaceRemoteDataSource implements WorkspaceRemoteDataSource {
  Invitation? sendInvitationResult;
  WorkspaceMember? acceptInvitationResult;

  @override
  Future<Invitation> sendInvitation({
    required String workspaceId,
    required String email,
    required String role,
    required String invitedByUserId,
  }) async {
    final result = sendInvitationResult;
    if (result == null) throw ServerException(message: 'no invitation');
    return result;
  }

  @override
  Future<WorkspaceMember> acceptInvitation({
    required String invitationId,
    required String userId,
  }) async {
    final member = acceptInvitationResult;
    if (member == null) throw ServerException(message: 'no member');
    return member;
  }

  // Unused methods for this test
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class DummyWorkspaceLocalDataSource implements WorkspaceLocalDataSource {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockStorageService extends Fake implements StorageService {
  String? _userId;
  void setMockUserId(String id) => _userId = id;
  @override
  String? getUserId() => _userId;
}

void main() {
  group('Integration - Invitation Acceptance Flow', () {
    late TestWorkspaceRemoteDataSource remote;
    late DummyWorkspaceLocalDataSource local;
    late MockStorageService storage;
    late WorkspaceRepositoryImpl repo;

    const workspaceId = 'w1';
    const inviterId = 'admin1';
    const invitedEmail = 'new.user@example.com';
    const invitationId = 'inv-123';
    const invitedUserId = 'u-new';

    setUp(() {
      remote = TestWorkspaceRemoteDataSource();
      local = DummyWorkspaceLocalDataSource();
      storage = MockStorageService();

      repo = WorkspaceRepositoryImpl(
        remoteDataSource: remote,
        localDataSource: local,
        storageService: storage,
      );
    });

    test('send -> accept creates membership successfully', () async {
      final invitation = Invitation(
        id: invitationId,
        workspaceId: workspaceId,
        email: invitedEmail,
        role: WorkspaceRole.member.value,
        invitedByUserId: inviterId,
        createdAt: DateTime.now(),
      );

      final member = WorkspaceMember(
        userId: invitedUserId,
        workspaceId: workspaceId,
        role: WorkspaceRole.member,
        permissions: const <String>[],
        assignedBy: inviterId,
        assignedAt: DateTime.now(),
      );

      // Arrange storage and remote behaviors
      storage.setMockUserId(inviterId);
      remote.sendInvitationResult = invitation;
      remote.acceptInvitationResult = member;

      // Act: send invitation
      final sendResult = await repo.sendInvitation(
        workspaceId: workspaceId,
        email: invitedEmail,
        role: WorkspaceRole.member.value,
      );

      // Assert send
      expect(sendResult.isRight(), isTrue);
      final sent = sendResult.getOrElse(() => throw UnknownFailure(message: 'no'));
      expect(sent.id, invitationId);
      expect(sent.email, invitedEmail);

      // Act: accept invitation
      final acceptResult = await repo.acceptInvitation(
        invitationId: invitationId,
        userId: invitedUserId,
      );

      // Assert accept
      expect(acceptResult.isRight(), isTrue);
      final createdMember = acceptResult.getOrElse(() => throw UnknownFailure(message: 'no'));
      expect(createdMember.userId, invitedUserId);
      expect(createdMember.workspaceId, workspaceId);
      expect(createdMember.role, WorkspaceRole.member);

      // No verification needed for test doubles
    });
  });
}


