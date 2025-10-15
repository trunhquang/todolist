import 'package:flutter_test/flutter_test.dart';
import 'package:todolist/features/auth/domain/entities/user.dart' as app_user;
import 'package:todolist/features/auth/domain/entities/company.dart';
import 'fixtures/users.dart';
import 'fixtures/companies.dart';

void main() {
  group('Auth registration with personal workspace', () {
    group('User Entity Tests', () {
      test('should create user with correct properties', () {
        // Arrange
        const email = 'john@example.com';
        const name = 'John Doe';
        const userId = 'uid-123';

        // Act
        final user = UserTestFixtures.createUser(
          id: userId,
          email: email,
          name: name,
          role: 'admin',
          companyId: '',
        );

        // Assert
        expect(user.id, equals(userId));
        expect(user.email, equals(email));
        expect(user.name, equals(name));
        expect(user.role, equals('admin'));
        expect(user.companyId, equals(''));
        expect(user.createdAt, isNotNull);
        expect(user.lastLoginAt, isNull);
      });

      test('should create admin user with correct role', () {
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

      test('should create regular user with correct role', () {
        // Arrange & Act
        final regularUser = UserTestFixtures.createRegularUser(
          email: 'user@example.com',
          name: 'Regular User',
        );

        // Assert
        expect(regularUser.role, equals('member'));
        expect(regularUser.email, equals('user@example.com'));
        expect(regularUser.name, equals('Regular User'));
      });

      test('should create user with must change password flag', () {
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

      test('should update user with company ID using copyWith', () {
        // Arrange
        const userId = 'uid-123';
        const companyId = 'company-1';
        final user = UserTestFixtures.createUser(id: userId);

        // Act
        final updatedUser = user.copyWith(companyId: companyId);

        // Assert
        expect(updatedUser.id, equals(userId));
        expect(updatedUser.companyId, equals(companyId));
        expect(updatedUser.email, equals(user.email));
        expect(updatedUser.name, equals(user.name));
        expect(updatedUser.role, equals(user.role));
      });

      test('should create user list with correct count', () {
        // Arrange & Act
        final userList = UserTestFixtures.createUserList(count: 5);

        // Assert
        expect(userList.length, equals(5));
        expect(userList[0].id, equals('test-user-id-1'));
        expect(userList[4].id, equals('test-user-id-5'));
      });

      test('should handle edge cases correctly', () {
        // Arrange & Act
        final longNameUser = UserTestFixtures.createUserWithLongName();
        final specialCharUser = UserTestFixtures.createUserWithSpecialCharacters();

        // Assert
        expect(longNameUser.name.length, equals(255));
        expect(specialCharUser.name, contains('@#\$%^&*()'));
        expect(specialCharUser.email, equals('test@example.com'));
      });
    });

    group('Company Entity Tests', () {
      test('should create company with correct properties', () {
        // Arrange
        const companyId = 'company-1';
        const name = 'Test Company';
        const description = 'Test Description';
        const createdBy = 'user-123';

        // Act
        final company = CompanyTestFixtures.createCompany(
          id: companyId,
          name: name,
          description: description,
          createdBy: createdBy,
        );

        // Assert
        expect(company.id, equals(companyId));
        expect(company.name, equals(name));
        expect(company.description, equals(description));
        expect(company.createdBy, equals(createdBy));
        expect(company.createdAt, isNotNull);
      });

      test('should create personal workspace with correct name format', () {
        // Arrange
        const userName = 'John Doe';
        const createdBy = 'user-123';

        // Act
        final personalWorkspace = CompanyTestFixtures.createPersonalWorkspace(
          userName: userName,
          createdBy: createdBy,
        );

        // Assert
        expect(personalWorkspace.name, equals('Personal Workspace'));
        expect(personalWorkspace.description, equals('Personal workspace for $userName'));
        expect(personalWorkspace.createdBy, equals(createdBy));
      });

      test('should create company with ID using copyWith', () {
        // Arrange
        const companyId = 'company-1';
        const userId = 'uid-123';
        final company = CompanyTestFixtures.createCompany(createdBy: userId);

        // Act
        final companyWithId = company.copyWith(id: companyId);

        // Assert
        expect(companyWithId.id, equals(companyId));
        expect(companyWithId.name, equals(company.name));
        expect(companyWithId.description, equals(company.description));
        expect(companyWithId.createdBy, equals(company.createdBy));
      });

      test('should create company list with correct count', () {
        // Arrange & Act
        final companyList = CompanyTestFixtures.createCompanyList(count: 3);

        // Assert
        expect(companyList.length, equals(3));
        expect(companyList[0].id, equals('test-company-id-1'));
        expect(companyList[2].id, equals('test-company-id-3'));
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

      test('should handle edge cases correctly', () {
        // Arrange & Act
        final longNameCompany = CompanyTestFixtures.createCompanyWithLongName();
        final specialCharCompany = CompanyTestFixtures.createCompanyWithSpecialCharacters();

        // Assert
        expect(longNameCompany.name.length, equals(255));
        expect(specialCharCompany.name, contains('@#\$%^&*()'));
        expect(specialCharCompany.description, contains('áéíóú'));
      });
    });

    group('Integration Tests', () {
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
        expect(personalWorkspace.description, contains(userName));
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
  });
}