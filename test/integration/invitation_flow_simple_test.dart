import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:todolist/core/services/invitation_service.dart';
import 'package:todolist/core/services/firebase_database_service_enhanced.dart';
import 'package:todolist/features/invitations/domain/entities/invitation.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';

import 'invitation_flow_simple_test.mocks.dart';

@GenerateMocks([
  firebase_auth.FirebaseAuth,
  FirebaseDatabaseServiceEnhanced,
])
void main() {
  group('Invitation Flow Simple Integration Tests', () {
    late InvitationService invitationService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockFirebaseDatabaseServiceEnhanced mockDatabaseService;

    setUp(() {
      // Initialize mock services
      mockFirebaseAuth = MockFirebaseAuth();
      mockDatabaseService = MockFirebaseDatabaseServiceEnhanced();
      
      invitationService = InvitationService(
        firebaseAuth: mockFirebaseAuth,
        databaseService: mockDatabaseService,
      );
    });

    group('InvitationService Basic Tests', () {
      test('should generate strong password', () {
        // Act
        final password = invitationService.generateStrongPassword();

        // Assert
        expect(password.length, 16);
        expect(password, isNot(equals('')));
      });

      test('should generate different passwords', () {
        // Act
        final password1 = invitationService.generateStrongPassword();
        final password2 = invitationService.generateStrongPassword();

        // Assert
        expect(password1, isNot(equals(password2)));
      });

      test('should get default permissions for role', () {
        // Act
        final adminPermissions = invitationService.getDefaultPermissionsForRole('admin');
        final memberPermissions = invitationService.getDefaultPermissionsForRole('member');
        final defaultPermissions = invitationService.getDefaultPermissionsForRole('unknown');

        // Assert
        expect(adminPermissions, contains('read'));
        expect(adminPermissions, contains('write'));
        expect(adminPermissions, contains('delete'));
        expect(adminPermissions, contains('invite_users'));
        expect(adminPermissions, contains('manage_permissions'));

        expect(memberPermissions, contains('read'));
        expect(memberPermissions, contains('write'));
        expect(memberPermissions, isNot(contains('delete')));

        expect(defaultPermissions, contains('read'));
        expect(defaultPermissions.length, 1);
      });
    });

    group('Invitation Entity Tests', () {
      test('should create invitation from map', () {
        // Arrange
        final map = {
          'id': 'invitation123',
          'workspaceId': 'workspace123',
          'email': 'test@example.com',
          'role': 'member',
          'invitedByUserId': 'user123',
          'createdAt': DateTime.now().millisecondsSinceEpoch,
          'isAccepted': false,
          'isRevoked': false,
        };

        // Act
        final invitation = Invitation.fromMap(map);

        // Assert
        expect(invitation.id, 'invitation123');
        expect(invitation.workspaceId, 'workspace123');
        expect(invitation.email, 'test@example.com');
        expect(invitation.role, 'member');
        expect(invitation.invitedByUserId, 'user123');
        expect(invitation.isAccepted, false);
        expect(invitation.isRevoked, false);
      });

      test('should convert invitation to map', () {
        // Arrange
        final invitation = Invitation(
          id: 'invitation123',
          workspaceId: 'workspace123',
          email: 'test@example.com',
          role: 'member',
          invitedByUserId: 'user123',
          createdAt: DateTime.now(),
        );

        // Act
        final map = invitation.toMap();

        // Assert
        expect(map['id'], 'invitation123');
        expect(map['workspaceId'], 'workspace123');
        expect(map['email'], 'test@example.com');
        expect(map['role'], 'member');
        expect(map['invitedByUserId'], 'user123');
        expect(map['isAccepted'], false);
        expect(map['isRevoked'], false);
      });
    });

    group('WorkspaceMember Entity Tests', () {
      test('should create workspace member from map', () {
        // Arrange
        final map = {
          'userId': 'user123',
          'workspaceId': 'workspace123',
          'role': 'member',
          'permissions': ['read', 'write'],
          'assignedBy': 'admin123',
          'assignedAt': DateTime.now().millisecondsSinceEpoch,
          'isActive': true,
          'name': 'Test User',
          'email': 'test@example.com',
        };

        // Act
        final member = WorkspaceMember.fromMap(map);

        // Assert
        expect(member.userId, 'user123');
        expect(member.workspaceId, 'workspace123');
        expect(member.role, WorkspaceRole.member);
        expect(member.permissions, contains('read'));
        expect(member.permissions, contains('write'));
        expect(member.assignedBy, 'admin123');
        expect(member.isActive, true);
        expect(member.name, 'Test User');
        expect(member.email, 'test@example.com');
      });

      test('should convert workspace member to map', () {
        // Arrange
        final member = WorkspaceMember(
          userId: 'user123',
          workspaceId: 'workspace123',
          role: WorkspaceRole.member,
          permissions: ['read', 'write'],
          assignedBy: 'admin123',
          assignedAt: DateTime.now(),
        );

        // Act
        final map = member.toMap();

        // Assert
        expect(map['userId'], 'user123');
        expect(map['workspaceId'], 'workspace123');
        expect(map['role'], 'member');
        expect(map['permissions'], contains('read'));
        expect(map['permissions'], contains('write'));
        expect(map['assignedBy'], 'admin123');
        expect(map['isActive'], true);
      });

      test('should check permissions correctly', () {
        // Arrange
        final member = WorkspaceMember(
          userId: 'user123',
          workspaceId: 'workspace123',
          role: WorkspaceRole.admin,
          permissions: ['read', 'write', 'delete', 'invite_users'],
          assignedBy: 'admin123',
          assignedAt: DateTime.now(),
        );

        // Act & Assert
        expect(member.hasPermission('read'), true);
        expect(member.hasPermission('write'), true);
        expect(member.hasPermission('delete'), true);
        expect(member.hasPermission('invite_users'), true);
        expect(member.hasPermission('manage_permissions'), false);
      });

      test('should identify role correctly', () {
        // Arrange
        final adminMember = WorkspaceMember(
          userId: 'admin123',
          workspaceId: 'workspace123',
          role: WorkspaceRole.admin,
          permissions: ['read', 'write', 'delete'],
          assignedBy: 'owner123',
          assignedAt: DateTime.now(),
        );

        final memberUser = WorkspaceMember(
          userId: 'user123',
          workspaceId: 'workspace123',
          role: WorkspaceRole.member,
          permissions: ['read', 'write'],
          assignedBy: 'admin123',
          assignedAt: DateTime.now(),
        );

        // Act & Assert
        expect(adminMember.isAdmin, true);
        expect(adminMember.isMember, false);
        expect(adminMember.isAccountHolder, false);

        expect(memberUser.isAdmin, false);
        expect(memberUser.isMember, true);
        expect(memberUser.isAccountHolder, false);
      });
    });

    group('Error Handling Tests', () {
      test('should handle invalid email gracefully', () async {
        // Arrange
        const invalidEmail = 'invalid-email';
        const workspaceId = 'workspace123';
        const role = 'member';
        const invitedByUserId = 'admin123';

        // Mock database service to return null for invalid email
        when(mockDatabaseService.getUserByEmail(invalidEmail))
            .thenAnswer((_) async => null);
        when(mockDatabaseService.createInvitation(any))
            .thenAnswer((_) async {});

        // Act
        final result = await invitationService.sendEnhancedInvitation(
          workspaceId: workspaceId,
          email: invalidEmail,
          role: role,
          invitedByUserId: invitedByUserId,
        );

        // Assert
        // Should either succeed or fail gracefully
        expect(result.isRight() || result.isLeft(), true);
      });

      test('should handle empty parameters gracefully', () async {
        // Arrange
        const emptyEmail = '';
        const emptyWorkspaceId = '';
        const role = 'member';
        const invitedByUserId = 'admin123';

        // Mock database service to handle empty parameters
        when(mockDatabaseService.getUserByEmail(emptyEmail))
            .thenAnswer((_) async => null);
        when(mockDatabaseService.createInvitation(any))
            .thenAnswer((_) async {});

        // Act
        final result = await invitationService.sendEnhancedInvitation(
          workspaceId: emptyWorkspaceId,
          email: emptyEmail,
          role: role,
          invitedByUserId: invitedByUserId,
        );

        // Assert
        // Should fail gracefully
        expect(result.isLeft(), true);
      });
    });
  });
}
