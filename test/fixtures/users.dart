import 'package:todolist/features/auth/domain/entities/user.dart';

class UserTestFixtures {
  static User createUser({
    String id = 'test-user-id',
    String email = 'test@example.com',
    String name = 'Test User',
    String role = 'member',
    String companyId = 'test-company-id',
    String? profileImageUrl,
    bool mustChangePassword = false,
    DateTime? lastLoginAt,
    DateTime? createdAt,
  }) {
    return User(
      id: id,
      email: email,
      name: name,
      role: role,
      companyId: companyId,
      profileImageUrl: profileImageUrl,
      mustChangePassword: mustChangePassword,
      lastLoginAt: lastLoginAt,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  static List<User> createTestUsers({
    int count = 5,
  }) {
    return List.generate(
      count,
        (index) => createUser(
        id: 'test-user-id-${index + 1}',
        email: 'test${index + 1}@example.com',
        name: 'Test User ${index + 1}',
      ),
    );
  }

  static User createAdminUser({
    String id = 'admin-user-id',
    String email = 'admin@example.com',
    String name = 'Admin User',
    String companyId = 'test-company-id',
  }) {
    return createUser(
      id: id,
      email: email,
      name: name,
      role: 'admin',
      companyId: companyId,
    );
  }

  static User createRegularUser({
    String id = 'regular-user-id',
    String email = 'user@example.com',
    String name = 'Regular User',
    String companyId = 'test-company-id',
  }) {
    return createUser(
      id: id,
      email: email,
      name: name,
      role: 'member',
      companyId: companyId,
    );
  }

  static User createUserWithMustChangePassword({
    String id = 'test-user-id',
    String email = 'test@example.com',
    String name = 'Test User',
    String companyId = 'test-company-id',
  }) {
    return createUser(
      id: id,
      email: email,
      name: name,
      companyId: companyId,
      mustChangePassword: true,
    );
  }

  static List<User> createUserList({int count = 3}) {
    return createTestUsers(count: count);
  }

  static User createUserWithLongName() {
    return createUser(
      name: 'A' * 255,
    );
  }

  static User createUserWithSpecialCharacters() {
    return createUser(
      name: 'User @#\$%^&*()',
    );
  }
}