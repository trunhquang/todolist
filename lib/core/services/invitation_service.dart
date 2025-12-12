import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:dartz/dartz.dart';
import 'package:todolist/core/errors/exceptions.dart';
import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/core/services/firebase_database_service.dart';
import 'package:todolist/core/services/credential_service.dart';
import 'package:todolist/features/invitations/domain/entities/invitation.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';


/// Service to handle complex invitation logic
class InvitationService {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseDatabaseService _databaseService;
  final CredentialService _credentialService = CredentialService();

  InvitationService({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required FirebaseDatabaseService databaseService,
  })  : _firebaseAuth = firebaseAuth,
        _databaseService = databaseService;

  /// Generate a strong random password
  String generateStrongPassword() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()_+-=[]{}|;:,.<>?';
    final Random random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(16, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  /// Check if email exists in Firebase Realtime Database
  Future<bool> _emailExists(String email) async {
    try {
      final user = await _databaseService.getUserByEmail(email);
      return user != null;
    } catch (e) {
      return false;
    }
  }

  /// Create user account with random password
  Future<firebase_auth.UserCredential> _createUserAccount(String email) async {
    final password = generateStrongPassword();
    
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw ServerException(message: 'Failed to create user account');
      }

      return credential;
    } catch (e) {
      throw ServerException(message: 'Failed to create user account: $e');
    }
  }

  Future<void> _reLogin() async {
    // Save current user credentials before creating new account
    final currentCredentials = await _credentialService.getCredentials();
    final currentEmail = currentCredentials['email'];
    final currentPassword = currentCredentials['password'];

    if (currentEmail != null && currentPassword != null) {
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: currentEmail,
          password: currentPassword,
        );
      } catch (e) {
        rethrow;
      }
    }
  }

  /// Enhanced invitation logic
  Future<Either<Failure, Invitation>> sendEnhancedInvitation({
    required String workspaceId,
    required String workspaceName, // new
    required String email,
    required String role,
    required String invitedByUserId,
    required String inviterName, // new
    String? name,
  }) async {
    try {
      // 1. Create invitation record in Firebase Database
      final invitation = Invitation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        workspaceId: workspaceId,
        email: email,
        role: role,
        invitedByUserId: invitedByUserId,
        createdAt: DateTime.now(),
        inviterName: inviterName,
        workspaceName: workspaceName,
        name: name,
        isWaiting: true
      );

      // Save invitation to database
      await _databaseService.createInvitation(invitation);

      // 2. Check if email exists in Firebase Realtime Database
      final emailExists = await _emailExists(email);

      if (!emailExists) {
        // 3. Create new user account with random password
        final credential = await _createUserAccount(email);
        
        // 4. Create user document in database with flag for password change
        await _databaseService.createUserWithPasswordChangeFlag(
          userId: credential.user!.uid,
          email: email,
          name: name,
          mustChangePassword: false, // user sẽ sử dụng tính năng quên mật khẩu để đặt lại mật khẩu
        );

        //keep current login
        _reLogin();
        
      } else {
        // 7. Get existing user from Firebase Realtime Database
        final user = await _databaseService.getUserByEmail(email);
        if (user != null) {
          // 7.1. Update user name if provided and user doesn't have name
          if (name != null && name.isNotEmpty && (user.name.isEmpty || user.name == '')) {
            final updatedUser = user.copyWith(name: name);
            await _databaseService.updateUser(updatedUser);
          }
          
        }
      }

      return Right(invitation);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to send enhanced invitation: $e'));
    }
  }

}
