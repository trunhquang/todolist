import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:todolist/core/services/invitation_service.dart';
import 'package:todolist/core/services/firebase_database_service_enhanced.dart';
import 'package:todolist/features/invitations/domain/entities/invitation.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';

import 'invitation_service_test.mocks.dart';

@GenerateMocks([
  firebase_auth.FirebaseAuth,
  firebase_auth.User,
  firebase_auth.UserCredential,
  FirebaseDatabaseServiceEnhanced,
])
void main() {
  group('InvitationService', () {
    late InvitationService invitationService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockFirebaseDatabaseServiceEnhanced mockDatabaseService;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockDatabaseService = MockFirebaseDatabaseServiceEnhanced();
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();
      
      invitationService = InvitationService(
        firebaseAuth: mockFirebaseAuth,
        databaseService: mockDatabaseService,
      );
    });

    group('sendEnhancedInvitation', () {
      test('should create invitation for new user and send email verification', () async {
        // Arrange
        const email = 'test@example.com';
        const workspaceId = 'workspace123';
        const role = 'member';
        const invitedByUserId = 'user123';

        when(mockDatabaseService.getUserByEmail(email))
            .thenAnswer((_) async => null);
        
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: anyNamed('password'),
        )).thenAnswer((_) async => mockUserCredential);
        
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test-user-id');
        when(mockUser.sendEmailVerification()).thenAnswer((_) async {});
        
        when(mockDatabaseService.createInvitation(any))
            .thenAnswer((_) async {});
        when(mockDatabaseService.createUserWithPasswordChangeFlag(
          userId: anyNamed('userId'),
          email: anyNamed('email'),
          mustChangePassword: anyNamed('mustChangePassword'),
        )).thenAnswer((_) async {});

        // Act
        final result = await invitationService.sendEnhancedInvitation(
          workspaceId: workspaceId,
          email: email,
          role: role,
          invitedByUserId: invitedByUserId,
        );

        // Assert
        expect(result.isRight(), true);
        verify(mockDatabaseService.getUserByEmail(email)).called(1);
        verify(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: anyNamed('password'),
        )).called(1);
        verify(mockUser.sendEmailVerification()).called(1);
        verify(mockDatabaseService.createInvitation(any)).called(1);
        verify(mockDatabaseService.createUserWithPasswordChangeFlag(
          userId: anyNamed('userId'),
          email: anyNamed('email'),
          mustChangePassword: anyNamed('mustChangePassword'),
        )).called(1);
      });

      test('should create notification for existing user', () async {
        // Arrange
        const email = 'existing@example.com';
        const workspaceId = 'workspace123';
        const role = 'member';
        const invitedByUserId = 'user123';

        // Create a mock user entity for existing user
        final mockUserEntity = User(
          id: 'existing-user-id',
          email: email,
          name: 'Existing User',
          profileImageUrl: null,
          role: 'regularUser',
          workspaceId: '',
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );
        
        when(mockDatabaseService.getUserByEmail(email))
            .thenAnswer((_) async => mockUserEntity);
        
        when(mockDatabaseService.createInvitation(any))
            .thenAnswer((_) async {});
        when(mockDatabaseService.createNotification(
          userId: anyNamed('userId'),
          type: anyNamed('type'),
          title: anyNamed('title'),
          message: anyNamed('message'),
          data: anyNamed('data'),
        )).thenAnswer((_) async {});

        // Act
        final result = await invitationService.sendEnhancedInvitation(
          workspaceId: workspaceId,
          email: email,
          role: role,
          invitedByUserId: invitedByUserId,
        );

        // Assert
        expect(result.isRight(), true);
        verify(mockDatabaseService.getUserByEmail(email)).called(2);
        verify(mockDatabaseService.createInvitation(any)).called(1);
        verify(mockDatabaseService.createNotification(
          userId: anyNamed('userId'),
          type: anyNamed('type'),
          title: anyNamed('title'),
          message: anyNamed('message'),
          data: anyNamed('data'),
        )).called(1);
      });

      test('should handle errors gracefully', () async {
        // Arrange
        const email = 'test@example.com';
        const workspaceId = 'workspace123';
        const role = 'member';
        const invitedByUserId = 'user123';

        when(mockDatabaseService.getUserByEmail(email))
            .thenThrow(Exception('Network error'));

        // Act
        final result = await invitationService.sendEnhancedInvitation(
          workspaceId: workspaceId,
          email: email,
          role: role,
          invitedByUserId: invitedByUserId,
        );

        // Assert
        expect(result.isLeft(), true);
        expect(result.fold((l) => l.message, (r) => ''), contains('Failed to send enhanced invitation'));
      });
    });

    group('acceptInvitation', () {
      test('should accept invitation and add user to workspace', () async {
        // Arrange
        const invitationId = 'invitation123';
        const userId = 'user123';
        const workspaceId = 'workspace123';
        const role = 'member';

        final mockInvitation = Invitation(
          id: invitationId,
          workspaceId: workspaceId,
          email: 'test@example.com',
          role: role,
          invitedByUserId: 'admin123',
          createdAt: DateTime.now(),
        );

        when(mockDatabaseService.getInvitation(invitationId))
            .thenAnswer((_) async => mockInvitation);
        when(mockDatabaseService.addWorkspaceMember(any))
            .thenAnswer((_) async {});
        when(mockDatabaseService.updateInvitationStatus(
          invitationId: invitationId,
          status: 'accepted',
        )).thenAnswer((_) async {});
        when(mockDatabaseService.removeNotificationByType(
          userId: userId,
          type: 'workspace_invitation',
          invitationId: invitationId,
        )).thenAnswer((_) async {});

        // Act
        final result = await invitationService.acceptInvitation(
          invitationId: invitationId,
          userId: userId,
        );

        // Assert
        expect(result.isRight(), true);
        verify(mockDatabaseService.getInvitation(invitationId)).called(1);
        verify(mockDatabaseService.addWorkspaceMember(any)).called(1);
        verify(mockDatabaseService.updateInvitationStatus(
          invitationId: invitationId,
          status: 'accepted',
        )).called(1);
        verify(mockDatabaseService.removeNotificationByType(
          userId: userId,
          type: 'workspace_invitation',
          invitationId: invitationId,
        )).called(1);
      });

      test('should handle invitation not found', () async {
        // Arrange
        const invitationId = 'nonexistent';
        const userId = 'user123';

        when(mockDatabaseService.getInvitation(invitationId))
            .thenAnswer((_) async => null);

        // Act
        final result = await invitationService.acceptInvitation(
          invitationId: invitationId,
          userId: userId,
        );

        // Assert
        expect(result.isLeft(), true);
        expect(result.fold((l) => l.message, (r) => ''), 'Invitation not found');
      });
    });

    group('generateStrongPassword', () {
      test('should generate password with correct length', () {
        // Act
        final password = invitationService.generateStrongPassword();

        // Assert
        expect(password.length, 16);
      });

      test('should generate different passwords', () {
        // Act
        final password1 = invitationService.generateStrongPassword();
        final password2 = invitationService.generateStrongPassword();

        // Assert
        expect(password1, isNot(equals(password2)));
      });
    });
  });
}
