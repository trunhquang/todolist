import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todolist/app/app.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/core/services/snackbar_service.dart';

import 'auth_integration_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  User,
  UserCredential,
  AuthCredential,
])
void main() {
  group('Authentication Integration Tests', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;

    setUpAll(() async {
      // Initialize Firebase for testing
      await Firebase.initializeApp();
    });

    setUp(() {
      Get.testMode = true;
      
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();
      
      // Setup GetX dependencies
      Get.put<NavigationService>(NavigationService());
      Get.put<SnackbarService>(SnackbarService());
    });

    tearDown(Get.reset);

    group('User Registration Flow', () {
      testWidgets('Complete user registration with email and password', (tester) async {
        // Arrange
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => mockUserCredential);
        
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test_user_id');
        when(mockUser.email).thenReturn('test@example.com');
        when(mockUser.displayName).thenReturn('Test User');
        
        when(mockUser.updateDisplayName(any)).thenAnswer((_) async {});

        // Create auth controller with mocked dependencies
        final authController = AuthController(
          firebaseAuth: mockFirebaseAuth,
        );
        Get.put<AuthController>(authController);

        // Act
        await tester.pumpWidget(const TodoListApp());
        await tester.pumpAndSettle();

        // Navigate to registration page
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        // Fill registration form
        await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
        await tester.enterText(find.byKey(const Key('password_field')), 'password123');
        await tester.enterText(find.byKey(const Key('name_field')), 'Test User');

        // Submit form
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        // Assert
        verify(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        )).called(1);
        
        verify(mockUser.updateDisplayName('Test User')).called(1);
      });

      testWidgets('Handle registration errors gracefully', (tester) async {
        // Arrange
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'The email address is already in use',
        ));

        final authController = AuthController(
          firebaseAuth: mockFirebaseAuth,
        );
        Get.put<AuthController>(authController);

        // Act
        await tester.pumpWidget(const TodoListApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(const Key('email_field')), 'existing@example.com');
        await tester.enterText(find.byKey(const Key('password_field')), 'password123');
        await tester.enterText(find.byKey(const Key('name_field')), 'Test User');

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('The email address is already in use'), findsOneWidget);
      });
    });

    group('User Login Flow', () {
      testWidgets('Successful login with email and password', (tester) async {
        // Arrange
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => mockUserCredential);
        
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test_user_id');
        when(mockUser.email).thenReturn('test@example.com');
        when(mockUser.displayName).thenReturn('Test User');

        final authController = AuthController(
          firebaseAuth: mockFirebaseAuth,
        );
        Get.put<AuthController>(authController);

        // Act
        await tester.pumpWidget(const TodoListApp());
        await tester.pumpAndSettle();

        // Fill login form
        await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
        await tester.enterText(find.byKey(const Key('password_field')), 'password123');

        // Submit form
        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();

        // Assert
        verify(mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        )).called(1);
      });

      testWidgets('Handle login errors gracefully', (tester) async {
        // Arrange
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found with this email',
        ));

        final authController = AuthController(
          firebaseAuth: mockFirebaseAuth,
        );
        Get.put<AuthController>(authController);

        // Act
        await tester.pumpWidget(const TodoListApp());
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(const Key('email_field')), 'nonexistent@example.com');
        await tester.enterText(find.byKey(const Key('password_field')), 'wrongpassword');

        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('No user found with this email'), findsOneWidget);
      });
    });

    group('Google Sign-In Flow', () {
      testWidgets('Successful Google Sign-In', (tester) async {
        // Arrange
        when(mockFirebaseAuth.signInWithCredential(any))
            .thenAnswer((_) async => mockUserCredential);
        
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('google_user_id');
        when(mockUser.email).thenReturn('google@example.com');
        when(mockUser.displayName).thenReturn('Google User');
        when(mockUser.photoURL).thenReturn('https://example.com/photo.jpg');

        final authController = AuthController(
          firebaseAuth: mockFirebaseAuth,
        );
        Get.put<AuthController>(authController);

        // Act
        await tester.pumpWidget(const TodoListApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Sign in with Google'));
        await tester.pumpAndSettle();

        // Assert
        verify(mockFirebaseAuth.signInWithCredential(any)).called(1);
      });
    });

    group('Authentication State Management', () {
      testWidgets('Maintain authentication state across app restarts', (tester) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('persistent_user_id');
        when(mockUser.email).thenReturn('persistent@example.com');
        when(mockUser.displayName).thenReturn('Persistent User');

        final authController = AuthController(
          firebaseAuth: mockFirebaseAuth,
        );
        Get.put<AuthController>(authController);

        // Act
        await tester.pumpWidget(const TodoListApp());
        await tester.pumpAndSettle();

        // Assert
        expect(authController.currentUser, isNotNull);
        expect(authController.currentUser?.id, equals('persistent_user_id'));
        expect(authController.currentUser?.email, equals('persistent@example.com'));
      });

      testWidgets('Handle user logout correctly', (tester) async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('logout_user_id');
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        final authController = AuthController(
          firebaseAuth: mockFirebaseAuth,
        );
        Get.put<AuthController>(authController);

        // Act
        await tester.pumpWidget(const TodoListApp());
        await tester.pumpAndSettle();

        // Verify user is logged in
        expect(authController.currentUser, isNotNull);

        // Logout
        await authController.signOut();
        await tester.pumpAndSettle();

        // Assert
        verify(mockFirebaseAuth.signOut()).called(1);
        expect(authController.currentUser, isNull);
      });
    });

    group('Navigation Flow', () {
      testWidgets('Navigate to dashboard after successful login', (tester) async {
        // Arrange
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => mockUserCredential);
        
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('nav_user_id');
        when(mockUser.email).thenReturn('nav@example.com');
        when(mockUser.displayName).thenReturn('Nav User');

        final authController = AuthController(
          firebaseAuth: mockFirebaseAuth,
        );
        Get.put<AuthController>(authController);

        // Act
        await tester.pumpWidget(const TodoListApp());
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(const Key('email_field')), 'nav@example.com');
        await tester.enterText(find.byKey(const Key('password_field')), 'password123');

        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byKey(const Key('dashboard_page')), findsOneWidget);
      });

      testWidgets('Navigate to company setup for new users', (tester) async {
        // Arrange
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => mockUserCredential);
        
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('new_user_id');
        when(mockUser.email).thenReturn('new@example.com');
        when(mockUser.displayName).thenReturn('New User');
        
        when(mockUser.updateDisplayName(any)).thenAnswer((_) async {});

        final authController = AuthController(
          firebaseAuth: mockFirebaseAuth,
        );
        Get.put<AuthController>(authController);

        // Act
        await tester.pumpWidget(const TodoListApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(const Key('email_field')), 'new@example.com');
        await tester.enterText(find.byKey(const Key('password_field')), 'password123');
        await tester.enterText(find.byKey(const Key('name_field')), 'New User');

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byKey(const Key('company_setup_page')), findsOneWidget);
      });
    });
  });
}
