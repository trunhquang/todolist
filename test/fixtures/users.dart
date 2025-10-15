import 'package:todolist/features/auth/domain/entities/user.dart';

class UserFixtures {
  static app_user.User createTestUser({
    String id = 'test-user-id',
    String email = 'test@example.com',
    String name = 'Test User',
    String? profileImageUrl,
    bool mustChangePassword = false,
    DateTime? lastLoginAt,
    DateTime? createdAt,
  }) {
    return app_user.User(
      id: id,
      email: email,
      name: name,
      profileImageUrl: profileImageUrl,
      mustChangePassword: mustChangePassword,
      lastLoginAt: lastLoginAt,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  static List<app_user.User> createTestUsers({
    int count = 5,
  }) {
    return List.generate(
      count,
      (index) => createTestUser(
        id: 'test-user-id-${index + 1}',
        email: 'test${index + 1}@example.com',
        name: 'Test User ${index + 1}',
      ),
    );
  }
}