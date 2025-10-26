# 🧪 Testing Rules for Multi-Workspace Todo List Application

## 📋 MANDATORY TESTING REQUIREMENTS

### ❌ NEVER DO THESE:
- **NEVER write tests without proper setup and teardown**
- **NEVER use real Firebase services in unit tests**
- **NEVER test implementation details instead of behavior**
- **NEVER skip error handling tests**
- **NEVER write tests that depend on external services**
- **NEVER use `print()` statements in tests**
- **NEVER write tests without proper assertions**
- **NEVER skip edge cases and boundary conditions**

### ✅ ALWAYS DO THESE:
- **ALWAYS use proper mocking for external dependencies**
- **ALWAYS test both success and failure scenarios**
- **ALWAYS use descriptive test names**
- **ALWAYS follow AAA pattern (Arrange, Act, Assert)**
- **ALWAYS test edge cases and boundary conditions**
- **ALWAYS use proper test data setup**
- **ALWAYS clean up resources in tearDown**
- **ALWAYS maintain test independence**

## 🏗️ TEST ARCHITECTURE

### Test Structure
```
test/
├── unit/                    # Unit tests
│   ├── controllers/         # Controller tests
│   ├── services/           # Service tests
│   ├── repositories/       # Repository tests
│   └── utils/              # Utility function tests
├── widget/                 # Widget tests
│   ├── pages/              # Page widget tests
│   ├── components/         # Component widget tests
│   └── forms/              # Form widget tests
├── integration/            # Integration tests
│   ├── auth/               # Authentication flow tests
│   ├── workspace/          # Workspace management tests
│   └── tasks/              # Task management tests
└── fixtures/               # Test data fixtures
    ├── users.dart          # User test data
    ├── companies.dart      # Company test data
    └── tasks.dart          # Task test data
```

## 📝 TEST NAMING CONVENTIONS

### Test File Naming
- **Unit Tests**: `{feature}_{component}_test.dart`
- **Widget Tests**: `{widget_name}_widget_test.dart`
- **Integration Tests**: `{feature}_integration_test.dart`

### Test Method Naming
- **Format**: `should_{expected_behavior}_when_{condition}`
- **Examples**:
  - `should_create_user_when_valid_data_provided`
  - `should_throw_exception_when_invalid_email`
  - `should_return_empty_list_when_no_data_exists`

## 🎯 TEST COVERAGE REQUIREMENTS

### Minimum Coverage
- **Unit Tests**: 90% code coverage
- **Widget Tests**: 80% widget coverage
- **Integration Tests**: 70% critical path coverage

### Required Test Types
1. **Happy Path Tests**: Normal operation scenarios
2. **Error Handling Tests**: Exception and error scenarios
3. **Edge Case Tests**: Boundary conditions and limits
4. **Integration Tests**: Cross-component interactions
5. **Performance Tests**: Response time and memory usage

## 🔧 MOCKING GUIDELINES

### Mock Setup
```dart
// ✅ Correct Mock Setup
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockDatabaseService extends Mock implements FirebaseDatabaseService {}

void main() {
  group('AuthController Tests', () {
    late MockFirebaseAuth mockAuth;
    late MockDatabaseService mockDb;
    late AuthController controller;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockDb = MockDatabaseService();
      controller = AuthController(
        firebaseAuth: mockAuth,
        databaseService: mockDb,
      );
    });

    tearDown(() {
      // Clean up resources
      reset(mockAuth);
      reset(mockDb);
    });
  });
}
```

### Mock Verification
```dart
// ✅ Correct Mock Verification
test('should call createUser when signing up', () async {
  // Arrange
  when(mockDb.createUser(any)).thenAnswer((_) async {});
  
  // Act
  await controller.signUpWithEmailAndPassword(
    email: 'test@example.com',
    password: 'password123',
    name: 'Test User',
  );
  
  // Assert
  verify(mockDb.createUser(any)).called(1);
});
```

## 📊 TEST DATA MANAGEMENT

### Test Fixtures
```dart
// ✅ Correct Test Fixture
class TestFixtures {
  static User createTestUser({
    String id = 'test-user-id',
    String email = 'test@example.com',
    String name = 'Test User',
    String role = 'admin',
    String workspaceId = '',
  }) {
    return User(
      id: id,
      email: email,
      name: name,
      role: role,
      workspaceId: workspaceId,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
  }

  static Company createTestCompany({
    String id = 'test-company-id',
    String name = 'Test Company',
    String description = 'Test Description',
    String createdBy = 'test-user-id',
  }) {
    return Company(
      id: id,
      name: name,
      description: description,
      createdBy: createdBy,
      createdAt: DateTime.now(),
    );
  }
}
```

## 🚨 ERROR HANDLING TESTS

### Required Error Test Patterns
```dart
// ✅ Correct Error Testing
test('should throw AuthenticationFailure when invalid credentials', () async {
  // Arrange
  when(mockAuth.signInWithEmailAndPassword(
    email: anyNamed('email'),
    password: anyNamed('password'),
  )).thenThrow(FirebaseAuthException(
    code: 'invalid-credential',
    message: 'Invalid credentials',
  ));

  // Act & Assert
  expect(
    () => controller.signInWithEmailAndPassword(
      email: 'invalid@example.com',
      password: 'wrongpassword',
    ),
    throwsA(isA<AuthenticationFailure>()),
  );
});
```

## 🎨 WIDGET TESTING RULES

### Widget Test Structure
```dart
// ✅ Correct Widget Test
testWidgets('should display user name when user is logged in', (tester) async {
  // Arrange
  final mockController = MockAuthController();
  when(mockController.currentUser).thenReturn(TestFixtures.createTestUser());
  
  // Act
  await tester.pumpWidget(
    GetMaterialApp(
      home: UserProfilePage(),
    ),
  );
  
  // Assert
  expect(find.text('Test User'), findsOneWidget);
});
```

## 🔄 INTEGRATION TESTING RULES

### Integration Test Structure
```dart
// ✅ Correct Integration Test
group('Authentication Integration Tests', () {
  testWidgets('should complete full signup flow', (tester) async {
    // Arrange
    await tester.pumpWidget(MyApp());
    
    // Act
    await tester.enterText(find.byKey(Key('email_field')), 'test@example.com');
    await tester.enterText(find.byKey(Key('password_field')), 'password123');
    await tester.tap(find.byKey(Key('signup_button')));
    await tester.pumpAndSettle();
    
    // Assert
    expect(find.text('Welcome to Dashboard'), findsOneWidget);
  });
});
```

## 📈 PERFORMANCE TESTING

### Performance Test Requirements
```dart
// ✅ Correct Performance Test
test('should load user data within 100ms', () async {
  // Arrange
  final stopwatch = Stopwatch()..start();
  
  // Act
  final user = await controller.getCurrentUser();
  
  // Assert
  stopwatch.stop();
  expect(stopwatch.elapsedMilliseconds, lessThan(100));
  expect(user, isNotNull);
});
```

## 🧹 TEST CLEANUP RULES

### Resource Cleanup
```dart
// ✅ Correct Cleanup
tearDown(() {
  // Reset all mocks
  reset(mockAuth);
  reset(mockDb);
  reset(mockStorage);
  
  // Clear any global state
  Get.reset();
  
  // Close any open resources
  if (controller != null) {
    controller.dispose();
  }
});
```

## 📋 TEST CHECKLIST

### Before Writing Tests
- [ ] Understand the feature requirements
- [ ] Identify all dependencies to mock
- [ ] Plan test scenarios (happy path, error cases, edge cases)
- [ ] Create test fixtures for data
- [ ] Set up proper test structure

### During Test Writing
- [ ] Follow AAA pattern (Arrange, Act, Assert)
- [ ] Use descriptive test names
- [ ] Mock all external dependencies
- [ ] Test both success and failure scenarios
- [ ] Include edge cases and boundary conditions
- [ ] Verify mock interactions

### After Writing Tests
- [ ] Run tests to ensure they pass
- [ ] Check test coverage meets requirements
- [ ] Review test readability and maintainability
- [ ] Ensure tests are independent
- [ ] Document any complex test logic

## 🎯 TESTING BEST PRACTICES

### Code Quality
- **Single Responsibility**: Each test should test one specific behavior
- **Independence**: Tests should not depend on each other
- **Repeatability**: Tests should produce the same results every time
- **Fast Execution**: Unit tests should run quickly
- **Clear Intent**: Test names should clearly describe what is being tested

### Maintenance
- **Regular Updates**: Update tests when requirements change
- **Refactoring**: Refactor tests when code is refactored
- **Documentation**: Document complex test scenarios
- **Review**: Regularly review and improve test quality

## 🚀 TESTING TOOLS

### Required Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.13
  integration_test:
    sdk: flutter
  test: ^1.24.9
```

### Test Commands
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/controllers/auth_controller_test.dart

# Run tests with coverage
flutter test --coverage

# Generate mock files
flutter packages pub run build_runner build
```

## 📚 TESTING EXAMPLES

### Complete Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/core/services/firebase_database_service.dart';
import 'package:todolist/test/fixtures/users.dart';

class MockDatabaseService extends Mock implements FirebaseDatabaseService {}

void main() {
  group('AuthController', () {
    late MockDatabaseService mockDb;
    late AuthController controller;

    setUp(() {
      mockDb = MockDatabaseService();
      controller = AuthController(databaseService: mockDb);
    });

    tearDown(() {
      reset(mockDb);
    });

    group('signUpWithEmailAndPassword', () {
      test('should create user and personal workspace successfully', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const name = 'Test User';
        
        when(mockDb.createUser(any)).thenAnswer((_) async {});
        when(mockDb.createCompany(any)).thenAnswer((_) async => 'company-1');
        when(mockDb.addUserToCompany(
          userId: anyNamed('userId'),
          workspaceId: anyNamed('workspaceId'),
        )).thenAnswer((_) async {});
        when(mockDb.updateUser(any)).thenAnswer((_) async {});

        // Act
        await controller.signUpWithEmailAndPassword(
          email: email,
          password: password,
          name: name,
        );

        // Assert
        verify(mockDb.createUser(any)).called(1);
        verify(mockDb.createCompany(any)).called(1);
        verify(mockDb.addUserToCompany(
          userId: 'uid-123',
          workspaceId: 'company-1',
        )).called(1);
        verify(mockDb.updateUser(any)).called(1);
      });

      test('should throw AuthenticationFailure when email already exists', () async {
        // Arrange
        when(mockAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'Email already in use',
        ));

        // Act & Assert
        expect(
          () => controller.signUpWithEmailAndPassword(
            email: 'existing@example.com',
            password: 'password123',
            name: 'Test User',
          ),
          throwsA(isA<AuthenticationFailure>()),
        );
      });
    });
  });
}
```

---

**Remember**: These testing rules ensure consistent, maintainable, and reliable tests across the entire application. Always follow these guidelines when writing tests.