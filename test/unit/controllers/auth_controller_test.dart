import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get/get.dart';

import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/core/services/firebase_database_service.dart';
import 'package:todolist/core/services/storage_service.dart';
import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/test/fixtures/users.dart';
import 'package:todolist/test/fixtures/companies.dart';

class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}
class MockUserCredential extends Mock implements firebase_auth.UserCredential {}
class MockFirebaseUser extends Mock implements firebase_auth.User {}
class MockDatabaseService extends Mock implements FirebaseDatabaseService {}
class MockStorageService extends Mock implements StorageService {}

void main() {
  group('AuthController', () {
    late MockFirebaseAuth mockAuth;
    late MockDatabaseService mockDb;
    late MockStorageService mockStorage;
    late AuthController controller;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockDb = MockDatabaseService();
      mockStorage = MockStorageService();
      controller = AuthController(
        firebaseAuth: mockAuth,
        databaseService: mockDb,
        storageService: mockStorage,
      );
    });

    tearDown(() {
      reset(mockAuth);
      reset(mockDb);
      reset(mockStorage);
      Get.reset();
    });

    group('signUpWithEmailAndPassword', () {
      test('should create user and personal workspace successfully', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const name = 'Test User';
        const userId = 'test-uid';

        final mockCredential = MockUserCredential();
        final mockUser = MockFirebaseUser();
        final testUser = UserTestFixtures.createUser(
          id: userId,
          email: email,
          name: name,
          role: 'admin',
        );
        final testCompany = CompanyTestFixtures.createPersonalWorkspace(
          userName: name,
          createdBy: userId,
        );

        // Setup Firebase Auth mocks
        when(mockAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockCredential);
        
        when(mockCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(userId);
        when(mockUser.updateDisplayName(name)).thenAnswer((_) async {});

        // Setup Database mocks
        when(mockDb.createUser(any)).thenAnswer((_) async {});
        when(mockDb.createCompany(any)).thenAnswer((_) async => 'company-1');
        when(mockDb.addUserToCompany(
          userId: userId,
          companyId: 'company-1',
        )).thenAnswer((_) async {});
        when(mockDb.updateUser(any)).thenAnswer((_) async {});

        // Setup Storage mocks
        when(mockStorage.setCompanyId('company-1')).thenAnswer((_) async {});
        when(mockStorage.setUserData('current_user', any)).thenAnswer((_) async {});

        // Act
        await controller.signUpWithEmailAndPassword(
          email: email,
          password: password,
          name: name,
        );

        // Assert
        verify(mockAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).called(1);
        verify(mockUser.updateDisplayName(name)).called(1);
        verify(mockDb.createUser(any)).called(1);
        verify(mockDb.createCompany(any)).called(1);
        verify(mockDb.addUserToCompany(
          userId: userId,
          companyId: 'company-1',
        )).called(1);
        verify(mockDb.updateUser(any)).called(1);
        verify(mockStorage.setCompanyId('company-1')).called(1);
        verify(mockStorage.setUserData('current_user', any)).called(1);
      });

      test('should throw AuthenticationFailure when email already exists', () async {
        // Arrange
        const email = 'existing@example.com';
        const password = 'password123';
        const name = 'Test User';

        when(mockAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(firebase_auth.FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'Email already in use',
        ));

        // Act & Assert
        expect(
          () => controller.signUpWithEmailAndPassword(
            email: email,
            password: password,
            name: name,
          ),
          throwsA(isA<AuthenticationFailure>()),
        );
      });

      test('should throw AuthenticationFailure when password is weak', () async {
        // Arrange
        const email = 'test@example.com';
        const password = '123'; // Weak password
        const name = 'Test User';

        when(mockAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(firebase_auth.FirebaseAuthException(
          code: 'weak-password',
          message: 'Password is too weak',
        ));

        // Act & Assert
        expect(
          () => controller.signUpWithEmailAndPassword(
            email: email,
            password: password,
            name: name,
          ),
          throwsA(isA<AuthenticationFailure>()),
        );
      });

      test('should handle database creation failure', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const name = 'Test User';
        const userId = 'test-uid';

        final mockCredential = MockUserCredential();
        final mockUser = MockFirebaseUser();

        when(mockAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockCredential);
        
        when(mockCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(userId);
        when(mockUser.updateDisplayName(name)).thenAnswer((_) async {});

        // Database fails
        when(mockDb.createUser(any)).thenThrow(Exception('Database error'));

        // Act & Assert
        expect(
          () => controller.signUpWithEmailAndPassword(
            email: email,
            password: password,
            name: name,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('signInWithEmailAndPassword', () {
      test('should sign in successfully with valid credentials', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const userId = 'test-uid';

        final mockCredential = MockUserCredential();
        final mockUser = MockFirebaseUser();
        final testUser = UserTestFixtures.createUser(id: userId, email: email);

        when(mockAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockCredential);
        
        when(mockCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(userId);

        when(mockDb.getUser(userId)).thenAnswer((_) async => testUser);
        when(mockDb.updateUser(any)).thenAnswer((_) async {});
        when(mockStorage.setUserData('current_user', any)).thenAnswer((_) async {});
        when(mockStorage.setUserId(userId)).thenAnswer((_) async {});
        when(mockUser.getIdToken()).thenAnswer((_) async => 'test-token');
        when(mockStorage.setUserToken('test-token')).thenAnswer((_) async {});

        // Act
        await controller.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        verify(mockAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).called(1);
        verify(mockDb.getUser(userId)).called(1);
        verify(mockDb.updateUser(any)).called(1);
        verify(mockStorage.setUserData('current_user', any)).called(1);
        verify(mockStorage.setUserId(userId)).called(1);
        verify(mockStorage.setUserToken('test-token')).called(1);
      });

      test('should throw AuthenticationFailure when credentials are invalid', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'wrongpassword';

        when(mockAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(firebase_auth.FirebaseAuthException(
          code: 'invalid-credential',
          message: 'Invalid credentials',
        ));

        // Act & Assert
        expect(
          () => controller.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<AuthenticationFailure>()),
        );
      });

      test('should throw AuthenticationFailure when user is disabled', () async {
        // Arrange
        const email = 'disabled@example.com';
        const password = 'password123';

        when(mockAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(firebase_auth.FirebaseAuthException(
          code: 'user-disabled',
          message: 'User account has been disabled',
        ));

        // Act & Assert
        expect(
          () => controller.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<AuthenticationFailure>()),
        );
      });
    });

    group('signOut', () {
      test('should sign out successfully', () async {
        // Arrange
        when(mockAuth.signOut()).thenAnswer((_) async {});

        // Act
        await controller.signOut();

        // Assert
        verify(mockAuth.signOut()).called(1);
      });

      test('should handle sign out failure', () async {
        // Arrange
        when(mockAuth.signOut()).thenThrow(firebase_auth.FirebaseAuthException(
          code: 'network-request-failed',
          message: 'Network error',
        ));

        // Act & Assert
        expect(
          () => controller.signOut(),
          throwsA(isA<AuthenticationFailure>()),
        );
      });
    });

    group('resetPassword', () {
      test('should send password reset email successfully', () async {
        // Arrange
        const email = 'test@example.com';
        when(mockAuth.sendPasswordResetEmail(email: email)).thenAnswer((_) async {});

        // Act
        await controller.resetPassword(email);

        // Assert
        verify(mockAuth.sendPasswordResetEmail(email: email)).called(1);
      });

      test('should throw AuthenticationFailure when email is invalid', () async {
        // Arrange
        const email = 'invalid-email';
        when(mockAuth.sendPasswordResetEmail(email: email)).thenThrow(
          firebase_auth.FirebaseAuthException(
            code: 'invalid-email',
            message: 'Invalid email address',
          ),
        );

        // Act & Assert
        expect(
          () => controller.resetPassword(email),
          throwsA(isA<AuthenticationFailure>()),
        );
      });
    });

    group('Edge Cases', () {
      test('should handle empty email', () async {
        // Arrange
        const email = '';
        const password = 'password123';
        const name = 'Test User';

        // Act & Assert
        expect(
          () => controller.signUpWithEmailAndPassword(
            email: email,
            password: password,
            name: name,
          ),
          throwsA(isA<firebase_auth.FirebaseAuthException>()),
        );
      });

      test('should handle empty password', () async {
        // Arrange
        const email = 'test@example.com';
        const password = '';
        const name = 'Test User';

        // Act & Assert
        expect(
          () => controller.signUpWithEmailAndPassword(
            email: email,
            password: password,
            name: name,
          ),
          throwsA(isA<firebase_auth.FirebaseAuthException>()),
        );
      });

      test('should handle very long email', () async {
        // Arrange
        final longEmail = 'a' * 300 + '@example.com';
        const password = 'password123';
        const name = 'Test User';

        when(mockAuth.createUserWithEmailAndPassword(
          email: longEmail,
          password: password,
        )).thenThrow(firebase_auth.FirebaseAuthException(
          code: 'invalid-email',
          message: 'Email is too long',
        ));

        // Act & Assert
        expect(
          () => controller.signUpWithEmailAndPassword(
            email: longEmail,
            password: password,
            name: name,
          ),
          throwsA(isA<AuthenticationFailure>()),
        );
      });
    });
  });
}
