import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/core/services/firebase_database_service.dart';
import 'package:todolist/core/services/storage_service.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/core/errors/failures.dart';
import '../../fixtures/users.dart';

import 'auth_controller_comprehensive_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  User,
  UserCredential,
  FirebaseDatabaseService,
  StorageService,
  NavigationService,
  SnackbarService,
])
void main() {
  group('AuthController Comprehensive Tests', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;
    late MockFirebaseDatabaseService mockDatabaseService;
    late MockStorageService mockStorageService;
    late MockNavigationService mockNavigationService;
    late MockSnackbarService mockSnackbarService;
    late AuthController authController;

    setUp(() {
      // Initialize mocks
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();
      mockDatabaseService = MockFirebaseDatabaseService();
      mockStorageService = MockStorageService();
      mockNavigationService = MockNavigationService();
      mockSnackbarService = MockSnackbarService();

      // Note: onStart stub will be set up in individual tests if needed

      // Setup GetX dependencies using lazyPut to avoid onStart lifecycle
      Get.lazyPut<FirebaseDatabaseService>(() => mockDatabaseService, tag: 'test');
      Get.lazyPut<StorageService>(() => mockStorageService, tag: 'test');
      Get.lazyPut<NavigationService>(() => mockNavigationService, tag: 'test');
      Get.lazyPut<SnackbarService>(() => mockSnackbarService, tag: 'test');

      // Initialize controller
      authController = AuthController(
        firebaseAuth: mockFirebaseAuth,
        databaseService: mockDatabaseService,
        storageService: mockStorageService,
      );
    });

    tearDown(() {
      Get.reset();
    });

    // Helper function to setup GetX lifecycle stubs
    void _setupGetXStubs() {
      when(mockDatabaseService.onStart()).thenAnswer((_) async {});
    }

    group('signUpWithEmailAndPassword', () {
      test('should create user and personal workspace successfully', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const name = 'Test User';
        const uid = 'test-uid-123';
        
        // Setup GetX lifecycle stubs
        _setupGetXStubs();
        
        when(mockUser.uid).thenReturn(uid);
        when(mockUser.email).thenReturn(email);
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => mockUserCredential);
        
        when(mockDatabaseService.createUser(any)).thenAnswer((_) async {});
        when(mockDatabaseService.createCompany(any)).thenAnswer((_) async => 'company-1');
        when(mockDatabaseService.addUserToCompany(
          userId: anyNamed('userId'),
          companyId: anyNamed('companyId'),
        )).thenAnswer((_) async {});
        when(mockDatabaseService.updateUser(any)).thenAnswer((_) async {});
        when(mockStorageService.setUserId(any)).thenAnswer((_) async {});
        when(mockStorageService.setCompanyId(any)).thenAnswer((_) async {});
        when(mockNavigationService.offAllNamed<void>(any)).thenAnswer((_) async {});

        // Act
        await authController.signUpWithEmailAndPassword(
          email: email,
          password: password,
          name: name,
        );

        // Assert
        verify(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).called(1);
        verify(mockDatabaseService.createUser(any)).called(1);
        verify(mockDatabaseService.createCompany(any)).called(1);
        verify(mockDatabaseService.addUserToCompany(
          userId: uid,
          companyId: 'company-1',
        )).called(1);
        verify(mockDatabaseService.updateUser(any)).called(1);
        verify(mockStorageService.setUserId(uid)).called(1);
        verify(mockStorageService.setCompanyId('company-1')).called(1);
        verify(mockNavigationService.offAllNamed<void>(any)).called(1);
      });

      test('should throw AuthenticationFailure when email already exists', () async {
        // Arrange
        // Setup GetX lifecycle stubs
        _setupGetXStubs();
        
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'Email already in use',
        ));

        // Act & Assert
        expect(
          () => authController.signUpWithEmailAndPassword(
            email: 'existing@example.com',
            password: 'password123',
            name: 'Test User',
          ),
          throwsA(isA<AuthenticationFailure>()),
        );
      });

      test('should throw AuthenticationFailure when password is weak', () async {
        // Arrange
        // Setup GetX lifecycle stubs
        _setupGetXStubs();
        
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(FirebaseAuthException(
          code: 'weak-password',
          message: 'Password is too weak',
        ));

        // Act & Assert
        expect(
          () => authController.signUpWithEmailAndPassword(
            email: 'test@example.com',
            password: '123',
            name: 'Test User',
          ),
          throwsA(isA<AuthenticationFailure>()),
        );
      });

      test('should handle network error during signup', () async {
        // Arrange
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(FirebaseAuthException(
          code: 'network-request-failed',
          message: 'Network request failed',
        ));

        // Act & Assert
        expect(
          () => authController.signUpWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
            name: 'Test User',
          ),
          throwsA(isA<AuthenticationFailure>()),
        );
      });
    });

    group('signInWithEmailAndPassword', () {
      test('should sign in successfully and navigate to dashboard', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const uid = 'test-uid-123';
        
        when(mockUser.uid).thenReturn(uid);
        when(mockUser.email).thenReturn(email);
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => mockUserCredential);
        
        when(mockDatabaseService.getUser(uid)).thenAnswer((_) async => UserTestFixtures.createUser());
        when(mockStorageService.setUserId(any)).thenAnswer((_) async {});
        when(mockStorageService.setCompanyId(any)).thenAnswer((_) async {});
        when(mockNavigationService.offAllNamed<void>(any)).thenAnswer((_) async {});

        // Act
        await authController.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        verify(mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).called(1);
        verify(mockDatabaseService.getUser(uid)).called(1);
        verify(mockStorageService.setUserId(uid)).called(1);
        verify(mockNavigationService.offAllNamed<void>(any)).called(1);
      });

      test('should throw AuthenticationFailure when user not found', () async {
        // Arrange
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(FirebaseAuthException(
          code: 'user-not-found',
          message: 'User not found',
        ));

        // Act & Assert
        expect(
          () => authController.signInWithEmailAndPassword(
            email: 'nonexistent@example.com',
            password: 'password123',
          ),
          throwsA(isA<AuthenticationFailure>()),
        );
      });

      test('should throw AuthenticationFailure when wrong password', () async {
        // Arrange
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(FirebaseAuthException(
          code: 'wrong-password',
          message: 'Wrong password',
        ));

        // Act & Assert
        expect(
          () => authController.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'wrongpassword',
          ),
          throwsA(isA<AuthenticationFailure>()),
        );
      });
    });

    group('signOut', () {
      test('should sign out successfully and clear storage', () async {
        // Arrange
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});
        when(mockStorageService.clear()).thenAnswer((_) async => true);
        when(mockNavigationService.offAllNamed<void>(any)).thenAnswer((_) async {});

        // Act
        await authController.signOut();

        // Assert
        verify(mockFirebaseAuth.signOut()).called(1);
        verify(mockStorageService.clear()).called(1);
        verify(mockNavigationService.offAllNamed<void>(any)).called(1);
      });

      test('should handle sign out error gracefully', () async {
        // Arrange
        when(mockFirebaseAuth.signOut()).thenThrow(Exception('Sign out failed'));

        // Act & Assert
        expect(
          () => authController.signOut(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getCurrentUser', () {
      test('should return current user when authenticated', () async {
        // Arrange
        const uid = 'test-uid-123';
        when(mockUser.uid).thenReturn(uid);
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockDatabaseService.getUser(uid)).thenAnswer((_) async => UserTestFixtures.createUser());

        // Act
        final user = await authController.currentUser;

        // Assert
        expect(user, isNotNull);
        expect(user?.id, equals(uid));
        verify(mockDatabaseService.getUser(uid)).called(1);
      });

      test('should return null when not authenticated', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        // Act
        final user = await authController.currentUser;

        // Assert
        expect(user, isNull);
        verifyNever(mockDatabaseService.getUser(any));
      });
    });

    group('Authentication State', () {
      test('should return user when authenticated', () {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

        // Act
        final user = authController.currentUser;

        // Assert
        expect(user, isNotNull);
      });

      test('should return null when not authenticated', () {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        // Act
        final user = authController.currentUser;

        // Assert
        expect(user, isNull);
      });
    });

    group('Error Handling', () {
      test('should map FirebaseAuthException to AuthenticationFailure', () async {
        // Arrange
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(FirebaseAuthException(
          code: 'invalid-credential',
          message: 'Invalid credential',
        ));

        // Act & Assert
        expect(
          () => authController.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'wrongpassword',
          ),
          throwsA(isA<AuthenticationFailure>()),
        );
      });

      test('should handle generic exceptions', () async {
        // Arrange
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(Exception('Generic error'));

        // Act & Assert
        expect(
          () => authController.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('State Management', () {
      test('should update loading state during signup', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const name = 'Test User';
        
        when(mockUser.uid).thenReturn('test-uid');
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 100));
          return mockUserCredential;
        });
        
        when(mockDatabaseService.createUser(any)).thenAnswer((_) async {});
        when(mockDatabaseService.createCompany(any)).thenAnswer((_) async => 'company-1');
        when(mockDatabaseService.addUserToCompany(
          userId: anyNamed('userId'),
          companyId: anyNamed('companyId'),
        )).thenAnswer((_) async {});
        when(mockDatabaseService.updateUser(any)).thenAnswer((_) async {});
        when(mockStorageService.setUserId(any)).thenAnswer((_) async {});
        when(mockStorageService.setCompanyId(any)).thenAnswer((_) async {});
        when(mockNavigationService.offAllNamed<void>(any)).thenAnswer((_) async {});

        // Act
        final future = authController.signUpWithEmailAndPassword(
          email: email,
          password: password,
          name: name,
        );

        // Assert - loading should be true during operation
        expect(authController.isLoading, isTrue);
        
        await future;
        
        // Assert - loading should be false after completion
        expect(authController.isLoading, isFalse);
      });
    });
  });
}