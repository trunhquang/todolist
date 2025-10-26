import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:todolist/features/workspace/data/repositories/workspace_repository_impl.dart';
import 'package:todolist/features/workspace/data/datasources/workspace_remote_data_source.dart';
import 'package:todolist/features/workspace/data/datasources/workspace_local_data_source.dart';
import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/core/errors/exceptions.dart';
import 'package:todolist/core/services/storage_service.dart';
import 'package:todolist/core/services/firebase_database_service_enhanced.dart';
import 'package:todolist/features/invitations/domain/entities/invitation.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';

import 'invitation_acceptance_flow_test.mocks.dart';

@GenerateMocks([
  FirebaseDatabaseServiceEnhanced, 
  firebase_auth.FirebaseAuth,
  firebase_auth.UserCredential,
  firebase_auth.User,
])

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
    if (result == null) throw const ServerException(message: 'no invitation');
    return result;
  }

  @override
  Future<WorkspaceMember> acceptInvitation({
    required String invitationId,
    required String userId,
  }) async {
    final member = acceptInvitationResult;
    if (member == null) throw const ServerException(message: 'no member');
    return member;
  }

  // Unused methods for this test
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class DummyWorkspaceLocalDataSource implements WorkspaceLocalDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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

      final mockDatabaseService = MockFirebaseDatabaseServiceEnhanced();
      
      // Mock database service methods
      when(mockDatabaseService.getUserByEmail(any))
          .thenAnswer((_) async => null);
      when(mockDatabaseService.createInvitation(any))
          .thenAnswer((_) async {});
      when(mockDatabaseService.createUserWithPasswordChangeFlag(
        userId: anyNamed('userId'),
        email: anyNamed('email'),
        mustChangePassword: anyNamed('mustChangePassword'),
      )).thenAnswer((_) async {});
      when(mockDatabaseService.createNotification(
        userId: anyNamed('userId'),
        type: anyNamed('type'),
        title: anyNamed('title'),
        message: anyNamed('message'),
        data: anyNamed('data'),
      )).thenAnswer((_) async {});
      
      final mockFirebaseAuth = MockFirebaseAuth();
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();
      
      // Mock Firebase Auth methods
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);
      
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('test-user-id');
      when(mockUser.sendEmailVerification()).thenAnswer((_) async {});
      
      repo = WorkspaceRepositoryImpl(
        remoteDataSource: remote,
        localDataSource: local,
        storageService: storage,
        databaseService: mockDatabaseService,
        firebaseAuth: mockFirebaseAuth,
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
      final sent = sendResult.getOrElse(() => throw const UnknownFailure(message: 'no'));
      expect(sent.email, invitedEmail);
      expect(sent.workspaceId, workspaceId);
      expect(sent.role, WorkspaceRole.member.value);

      // Act: accept invitation
      final acceptResult = await repo.acceptInvitation(
        invitationId: invitationId,
        userId: invitedUserId,
      );

      // Assert accept
      expect(acceptResult.isRight(), isTrue);
      final createdMember = acceptResult.getOrElse(() => throw const UnknownFailure(message: 'no'));
      expect(createdMember.userId, invitedUserId);
      expect(createdMember.workspaceId, workspaceId);
      expect(createdMember.role, WorkspaceRole.member);

      // No verification needed for test doubles
    });
  });
}


