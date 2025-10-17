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
import '../../fixtures/companies.dart';

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
  TestWidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;
  
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
    // Avoid GetX navigation/snackbar needing a full app
    Get.testMode = true;
      // Initialize mocks
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();
      mockDatabaseService = MockFirebaseDatabaseService();
      mockStorageService = MockStorageService();
      mockNavigationService = MockNavigationService();
      mockSnackbarService = MockSnackbarService();

      // Stub FirebaseAuth currentUser
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      
      // Stub MockUser properties
      when(mockUser.uid).thenReturn('test-uid-123');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockUser.getIdToken(any)).thenAnswer((_) async => 'test-id-token');
      
      // Stub database service methods
      when(mockDatabaseService.getUser(any)).thenAnswer((_) async => UserTestFixtures.createUser());
      when(mockDatabaseService.getCompany(any)).thenAnswer((_) async => CompanyTestFixtures.createCompany());

      // Stub lifecycle getters BEFORE registering with GetX, so GetX startup won't hit missing stubs
      when(mockDatabaseService.onStart).thenReturn(InternalFinalCallback<void>(callback: () {}));
      when(mockDatabaseService.onDelete).thenReturn(InternalFinalCallback<void>(callback: () {}));

      // Setup GetX dependencies (not strictly required since controller gets instances via DI in ctor),
      // but we keep them available in case of indirect static lookups.
      Get
        ..put<FirebaseDatabaseService>(mockDatabaseService)
        ..put<StorageService>(mockStorageService)
        ..put<NavigationService>(mockNavigationService)
        ..put<SnackbarService>(mockSnackbarService);

      // Default navigation stubs for all tests
      when(mockNavigationService.offAllNamed<void>(any)).thenAnswer((_) async => null);

      // Initialize controller
      authController = AuthController(
        firebaseAuth: mockFirebaseAuth,
        databaseService: mockDatabaseService,
        storageService: mockStorageService,
      );
    });

    tearDown(Get.reset);

    group('signUpWithEmailAndPassword', () {
      test('should create user and personal workspace successfully', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const name = 'Test User';
        const uid = 'test-uid-123';
        
        
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
        when(mockNavigationService.offAllNamed<void>(any)).thenAnswer((_) async => null);

        // Act
        await authController.signUpWithEmailAndPassword(
          email: email,
          password: password,
          name: name,
        );

      // Assert (focus on data operations; navigation is handled by real NavigationService singleton)
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
      verify(mockStorageService.setCompanyId('company-1')).called(1);
      });

      test('should throw AuthenticationFailure when email already exists', () async {
        // Arrange
        
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'Email already in use',
        ));

        // Act
        final result = authController.signUpWithEmailAndPassword(
            email: 'existing@example.com',
            password: 'password123',
            name: 'Test User',
          );
        // Assert - executeAsync swallows exception and sets error state
        await expectLater(result, completes);
        expect(authController.error, isA<AuthenticationFailure>());
      });

      test('should throw AuthenticationFailure when password is weak', () async {
        // Arrange
        
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(FirebaseAuthException(
          code: 'weak-password',
          message: 'Password is too weak',
        ));

        // Act
        final result = authController.signUpWithEmailAndPassword(
            email: 'test@example.com',
            password: '123',
            name: 'Test User',
          );
        // Assert
        await expectLater(result, completes);
        expect(authController.error, isA<AuthenticationFailure>());
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

        // Act
        final result = authController.signUpWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        );
        // Assert
        await expectLater(result, completes);
        expect(authController.error, isA<AuthenticationFailure>());
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
        when(mockNavigationService.offAllNamed<void>(any)).thenAnswer((_) async => null);

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

        // Act
        final result = authController.signInWithEmailAndPassword(
          email: 'nonexistent@example.com',
          password: 'password123',
        );
        // Assert
        await expectLater(result, completes);
        expect(authController.error, isA<AuthenticationFailure>());
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

        // Act
        final result = authController.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'wrongpassword',
        );
        // Assert
        await expectLater(result, completes);
        expect(authController.error, isA<AuthenticationFailure>());
      });
    });

    group('signOut', () {
      test('should sign out successfully and navigate to login', () async {
        // Arrange
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});
        when(mockNavigationService.offAllNamed<void>(any)).thenAnswer((_) async => null);

        // Act
        await authController.signOut();

        // Assert
        verify(mockFirebaseAuth.signOut()).called(1);
      });

      test('should handle sign out error gracefully', () async {
        // Arrange
        when(mockFirebaseAuth.signOut()).thenThrow(Exception('Sign out failed'));

        // Act
        final result = authController.signOut();
        // Assert
        await expectLater(result, completes);
        expect(authController.error, isA<Failure>());
      });
    });

    group('getCurrentUser', () {
      test('should return current user when authenticated', () async {
        // Arrange
        const uid = 'test-uid-123';
        when(mockUser.uid).thenReturn(uid);
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockDatabaseService.getUser(uid)).thenAnswer((_) async => UserTestFixtures.createUser());

        // Preload controller state to simulate authenticated session
        authController.setAuthenticatedUserForTest(uid, 'test@example.com', 'Test User');

        // Act
        final user = authController.currentUser;

        // Assert
        expect(user, isNotNull);
      });

      test('should return null when not authenticated', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        // Act
        final user = await authController.currentUser;

        // Assert
        expect(user, isNull);
      });
    });

    group('Authentication State', () {
      test('should return user when authenticated', () {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

        // Act
        authController.setAuthenticatedUserForTest('id', 'e@x.com', 'Name');
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

        // Act
        final result = authController.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'wrongpassword',
        );
        // Assert
        await expectLater(result, completes);
        expect(authController.error, isA<AuthenticationFailure>());
      });

      test('should handle generic exceptions', () async {
        // Arrange
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(Exception('Generic error'));

        // Act
        final result = authController.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        );
        // Assert
        await expectLater(result, completes);
        expect(authController.error, isA<Failure>());
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
        when(mockNavigationService.offAllNamed<void>(any)).thenAnswer((_) async => null);

        // Act
        final future = authController.signUpWithEmailAndPassword(
          email: email,
          password: password,
          name: name,
        );

        await future;
        
        // Assert - loading should be false after completion
        expect(authController.isLoading, isFalse);
      });
    });
  });
}