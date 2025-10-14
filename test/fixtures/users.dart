import 'package:todolist/features/auth/domain/entities/user.dart';

class UserTestFixtures {
  static User createUser({
    String? id,
    String? email,
    String? name,
    String? role,
    String? companyId,
    String? departmentId,
    String? managerUserId,
    String? invitedByUserId,
    bool? mustChangePassword,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? 'test-user-id',
      email: email ?? 'test@example.com',
      name: name ?? 'Test User',
      role: role ?? 'admin',
      companyId: companyId ?? '',
      departmentId: departmentId,
      managerUserId: managerUserId,
      invitedByUserId: invitedByUserId,
      mustChangePassword: mustChangePassword ?? false,
      createdAt: createdAt ?? DateTime.now(),
      lastLoginAt: lastLoginAt ?? DateTime.now(),
    );
  }

  static User createUserWithCompany({
    String? id,
    String? email,
    String? name,
    String? role,
    String? companyId,
  }) {
    return createUser(
      id: id,
      email: email,
      name: name,
      role: role,
      companyId: companyId ?? 'test-company-id',
    );
  }

  static User createAdminUser({
    String? id,
    String? email,
    String? name,
    String? companyId,
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
    String? id,
    String? email,
    String? name,
    String? companyId,
  }) {
    return createUser(
      id: id,
      email: email,
      name: name,
      role: 'user',
      companyId: companyId,
    );
  }

  static User createUserWithMustChangePassword({
    String? id,
    String? email,
    String? name,
    String? role,
    String? companyId,
  }) {
    return createUser(
      id: id,
      email: email,
      name: name,
      role: role,
      companyId: companyId,
      mustChangePassword: true,
    );
  }

  static List<User> createUserList({
    int count = 3,
    String? companyId,
  }) {
    return List.generate(count, (index) => createUser(
      id: 'test-user-id-$index',
      email: 'test$index@example.com',
      name: 'Test User $index',
      companyId: companyId,
    ));
  }

  static User createInvalidUser() {
    return User(
      id: '', // Invalid empty ID
      email: '', // Invalid empty email
      name: '', // Invalid empty name
      role: '', // Invalid empty role
      companyId: '',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
  }

  static User createUserWithLongName() {
    return createUser(
      name: 'A' * 1000, // Very long name
    );
  }

  static User createUserWithSpecialCharacters() {
    return createUser(
      name: 'Test User with Special Characters !@#\$%^&*()',
      email: 'test+special@example.com',
    );
  }
}
