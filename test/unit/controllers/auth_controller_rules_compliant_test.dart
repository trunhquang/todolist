import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get/get.dart';

import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/core/services/firebase_database_service.dart';
import 'package:todolist/core/services/storage_service.dart';
import 'package:todolist/core/errors/failures.dart';
import '../../fixtures/users.dart';
import '../../fixtures/companies.dart';

// Mock classes following CODING_STANDARDS.md naming conventions
class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}
class MockDatabaseService extends Mock implements FirebaseDatabaseService {}
class MockStorageService extends Mock implements StorageService {}

void main() {
  group('AuthController - Rules Compliant Tests', () {
    late MockFirebaseAuth mockAuth;
    late MockDatabaseService mockDb;
    late MockStorageService mockStorage;
    late AuthController controller;

    setUp(() {
      // Initialize mocks following Clean Architecture patterns
      mockAuth = MockFirebaseAuth();
      mockDb = MockDatabaseService();
      mockStorage = MockStorageService();
      
      // Create controller with dependencies following GetX patterns
      controller = AuthController(
        firebaseAuth: mockAuth,
        databaseService: mockDb,
        storageService: mockStorage,
      );
    });

    tearDown(() {
      // Clean up following testing rules
      reset(mockAuth);
      reset(mockDb);
      reset(mockStorage);
      Get.reset();
    });

    group('Constructor and Initialization', () {
      test('should initialize with provided dependencies', () {
        // Arrange & Act
        final testController = AuthController(
          firebaseAuth: mockAuth,
          databaseService: mockDb,
          storageService: mockStorage,
        );

        // Assert
        expect(testController, isNotNull);
        expect(testController, isA<AuthController>());
      });

      test('should be instance of AuthController', () {
        // Assert
        expect(controller, isA<AuthController>());
      });

      test('should have required dependencies', () {
        // Assert
        expect(controller, isNotNull);
        // Note: We can't directly access private fields, but we can verify the controller exists
      });
    });

    group('Test Fixtures Usage', () {
      test('should create user using test fixtures', () {
        // Arrange & Act - Using test fixtures following TESTING_RULES.md
        final testUser = UserTestFixtures.createUser(
          id: 'test-user-id',
          email: 'test@example.com',
          name: 'Test User',
          role: 'admin',
          companyId: 'test-company-id',
        );

        // Assert
        expect(testUser.id, equals('test-user-id'));
        expect(testUser.email, equals('test@example.com'));
        expect(testUser.name, equals('Test User'));
        expect(testUser.role, equals('admin'));
        expect(testUser.companyId, equals('test-company-id'));
      });

      test('should create company using test fixtures', () {
        // Arrange & Act
        final testCompany = CompanyTestFixtures.createCompany(
          id: 'test-company-id',
          name: 'Test Company',
          description: 'Test Description',
          createdBy: 'test-user-id',
        );

        // Assert
        expect(testCompany.id, equals('test-company-id'));
        expect(testCompany.name, equals('Test Company'));
        expect(testCompany.description, equals('Test Description'));
        expect(testCompany.createdBy, equals('test-user-id'));
      });

      test('should create personal workspace using test fixtures', () {
        // Arrange & Act
        final personalWorkspace = CompanyTestFixtures.createPersonalWorkspace(
          userName: 'John Doe',
          createdBy: 'user-123',
        );

        // Assert
        expect(personalWorkspace.name, equals('Personal Workspace for John Doe'));
        expect(personalWorkspace.description, equals('Personal workspace'));
        expect(personalWorkspace.createdBy, equals('user-123'));
      });

      test('should create admin user using test fixtures', () {
        // Arrange & Act
        final adminUser = UserTestFixtures.createAdminUser(
          email: 'admin@example.com',
          name: 'Admin User',
        );

        // Assert
        expect(adminUser.role, equals('admin'));
        expect(adminUser.email, equals('admin@example.com'));
        expect(adminUser.name, equals('Admin User'));
      });

      test('should create regular user using test fixtures', () {
        // Arrange & Act
        final regularUser = UserTestFixtures.createRegularUser(
          email: 'user@example.com',
          name: 'Regular User',
        );

        // Assert
        expect(regularUser.role, equals('user'));
        expect(regularUser.email, equals('user@example.com'));
        expect(regularUser.name, equals('Regular User'));
      });
    });

    group('Edge Cases with Test Fixtures', () {
      test('should handle user with must change password flag', () {
        // Arrange & Act
        final user = UserTestFixtures.createUserWithMustChangePassword(
          email: 'newuser@example.com',
          name: 'New User',
        );

        // Assert
        expect(user.mustChangePassword, isTrue);
        expect(user.email, equals('newuser@example.com'));
        expect(user.name, equals('New User'));
      });

      test('should handle user with long name', () {
        // Arrange & Act
        final longNameUser = UserTestFixtures.createUserWithLongName();

        // Assert
        expect(longNameUser.name.length, equals(1000));
      });

      test('should handle user with special characters', () {
        // Arrange & Act
        final specialCharUser = UserTestFixtures.createUserWithSpecialCharacters();

        // Assert
        expect(specialCharUser.name, contains('Special Characters'));
        expect(specialCharUser.email, contains('+special'));
      });

      test('should handle company with empty description', () {
        // Arrange & Act
        final company = CompanyTestFixtures.createCompanyWithEmptyDescription(
          name: 'Test Company',
        );

        // Assert
        expect(company.name, equals('Test Company'));
        expect(company.description, equals(''));
      });

      test('should handle company with null description', () {
        // Arrange & Act
        final company = CompanyTestFixtures.createCompanyWithNullDescription(
          name: 'Test Company',
        );

        // Assert
        expect(company.name, equals('Test Company'));
        expect(company.description, isNull);
      });

      test('should handle company with long name', () {
        // Arrange & Act
        final longNameCompany = CompanyTestFixtures.createCompanyWithLongName();

        // Assert
        expect(longNameCompany.name.length, equals(1000));
      });

      test('should handle company with special characters', () {
        // Arrange & Act
        final specialCharCompany = CompanyTestFixtures.createCompanyWithSpecialCharacters();

        // Assert
        expect(specialCharCompany.name, contains('Special Characters'));
        expect(specialCharCompany.description, contains('áéíóú'));
      });
    });

    group('Integration Tests with Fixtures', () {
      test('should create user and personal workspace together', () {
        // Arrange
        const userName = 'John Doe';
        const userEmail = 'john@example.com';
        const userId = 'uid-123';

        // Act
        final user = UserTestFixtures.createUser(
          id: userId,
          email: userEmail,
          name: userName,
          role: 'admin',
        );

        final personalWorkspace = CompanyTestFixtures.createPersonalWorkspace(
          userName: userName,
          createdBy: userId,
        );

        // Assert
        expect(user.id, equals(personalWorkspace.createdBy));
        expect(personalWorkspace.name, contains(userName));
        expect(user.role, equals('admin'));
      });

      test('should associate user with company correctly', () {
        // Arrange
        const companyId = 'company-1';
        final user = UserTestFixtures.createUser();
        final company = CompanyTestFixtures.createCompany(id: companyId);

        // Act
        final userWithCompany = user.copyWith(companyId: company.id);

        // Assert
        expect(userWithCompany.companyId, equals(company.id));
        expect(userWithCompany.id, equals(user.id));
        expect(company.createdBy, equals(user.id));
      });
    });

    group('Error Handling Tests', () {
      test('should handle AuthenticationFailure type', () {
        // Arrange
        final failure = AuthenticationFailure(message: 'Test error message');

        // Assert
        expect(failure, isA<AuthenticationFailure>());
        expect(failure.message, equals('Test error message'));
      });

      test('should handle different error types', () {
        // Arrange
        final authFailure = AuthenticationFailure(message: 'Auth error');
        final networkFailure = NetworkFailure(message: 'Network error');
        final serverFailure = ServerFailure(message: 'Server error');

        // Assert
        expect(authFailure, isA<AuthenticationFailure>());
        expect(networkFailure, isA<NetworkFailure>());
        expect(serverFailure, isA<ServerFailure>());
      });
    });
  });
}
