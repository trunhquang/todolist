# 🎭 Mocking Guide for Multi-Workspace Todo List Application

## 📋 OVERVIEW

This guide provides comprehensive instructions for setting up and using mocks in tests. Proper mocking is essential for creating reliable, fast, and isolated unit tests.

## 🛠️ MOCK SETUP

### 1. Basic Mock Creation

```dart
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Generate mocks using build_runner
@GenerateMocks([
  FirebaseAuth,
  FirebaseDatabaseService,
  StorageService,
  GoogleSignIn,
])
void main() {}

// Or create mocks manually
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockDatabaseService extends Mock implements FirebaseDatabaseService {}
class MockStorageService extends Mock implements StorageService {}
```

### 2. Mock Generation Commands

```bash
# Generate mock files
flutter packages pub run build_runner build

# Watch for changes and regenerate
flutter packages pub run build_runner watch

# Clean and rebuild
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 3. Mock File Structure

```
test/
├── mocks/
│   ├── mock_firebase_auth.dart
│   ├── mock_database_service.dart
│   └── mock_storage_service.dart
└── unit/
    └── controllers/
        └── auth_controller_test.dart
```

## 🎯 MOCKING PATTERNS

### 1. Service Mocking

```dart
// ✅ Correct Service Mocking
class MockFirebaseDatabaseService extends Mock implements FirebaseDatabaseService {}

void main() {
  group('AuthController Tests', () {
    late MockFirebaseDatabaseService mockDb;
    late AuthController controller;

    setUp(() {
      mockDb = MockFirebaseDatabaseService();
      controller = AuthController(databaseService: mockDb);
    });

    tearDown(() {
      reset(mockDb);
    });

    test('should create user successfully', () async {
      // Arrange
      when(mockDb.createUser(any)).thenAnswer((_) async {});

      // Act
      await controller.createUser(userData);

      // Assert
      verify(mockDb.createUser(any)).called(1);
    });
  });
}
```

### 2. Firebase Auth Mocking

```dart
// ✅ Correct Firebase Auth Mocking
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockFirebaseUser extends Mock implements User {}

void main() {
  group('Firebase Auth Tests', () {
    late MockFirebaseAuth mockAuth;
    late MockUserCredential mockCredential;
    late MockFirebaseUser mockUser;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockCredential = MockUserCredential();
      mockUser = MockFirebaseUser();
    });

    test('should sign in successfully', () async {
      // Arrange
      when(mockAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockCredential);
      
      when(mockCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('test-uid');

      // Act
      final result = await authService.signIn('email', 'password');

      // Assert
      expect(result, isNotNull);
      verify(mockAuth.signInWithEmailAndPassword(
        email: 'email',
        password: 'password',
      )).called(1);
    });
  });
}
```

### 3. Database Service Mocking

```dart
// ✅ Correct Database Service Mocking
class MockFirebaseDatabaseService extends Mock implements FirebaseDatabaseService {}

void main() {
  group('Database Service Tests', () {
    late MockFirebaseDatabaseService mockDb;

    setUp(() {
      mockDb = MockFirebaseDatabaseService();
    });

    test('should create user in database', () async {
      // Arrange
      final user = TestFixtures.createTestUser();
      when(mockDb.createUser(any)).thenAnswer((_) async {});

      // Act
      await mockDb.createUser(user);

      // Assert
      verify(mockDb.createUser(user)).called(1);
    });

    test('should return user when found', () async {
      // Arrange
      final user = TestFixtures.createTestUser();
      when(mockDb.getUser(any)).thenAnswer((_) async => user);

      // Act
      final result = await mockDb.getUser('user-id');

      // Assert
      expect(result, equals(user));
      verify(mockDb.getUser('user-id')).called(1);
    });
  });
}
```

### 4. Storage Service Mocking

```dart
// ✅ Correct Storage Service Mocking
class MockStorageService extends Mock implements StorageService {}

void main() {
  group('Storage Service Tests', () {
    late MockStorageService mockStorage;

    setUp(() {
      mockStorage = MockStorageService();
    });

    test('should save user data', () async {
      // Arrange
      final userData = {'id': '123', 'name': 'Test User'};
      when(mockStorage.setUserData(any, any)).thenAnswer((_) async {});

      // Act
      await mockStorage.setUserData('current_user', userData);

      // Assert
      verify(mockStorage.setUserData('current_user', userData)).called(1);
    });

    test('should retrieve user data', () async {
      // Arrange
      final userData = {'id': '123', 'name': 'Test User'};
      when(mockStorage.getUserData(any)).thenReturn(userData);

      // Act
      final result = mockStorage.getUserData('current_user');

      // Assert
      expect(result, equals(userData));
      verify(mockStorage.getUserData('current_user')).called(1);
    });
  });
}
```

## 🔧 MOCK CONFIGURATION

### 1. Mock Behavior Setup

```dart
// ✅ Correct Mock Behavior Setup
test('should handle different mock behaviors', () async {
  // Arrange - Setup different behaviors
  when(mockService.method1(any)).thenAnswer((_) async => 'success');
  when(mockService.method2(any)).thenThrow(Exception('Error'));
  when(mockService.method3(any)).thenReturn('immediate result');

  // Act & Assert
  expect(await mockService.method1('input'), equals('success'));
  expect(() => mockService.method2('input'), throwsException);
  expect(mockService.method3('input'), equals('immediate result'));
});
```

### 2. Mock Verification

```dart
// ✅ Correct Mock Verification
test('should verify mock interactions', () async {
  // Arrange
  when(mockService.createUser(any)).thenAnswer((_) async {});
  when(mockService.updateUser(any)).thenAnswer((_) async {});

  // Act
  await controller.createAndUpdateUser(userData);

  // Assert - Verify interactions
  verify(mockService.createUser(any)).called(1);
  verify(mockService.updateUser(any)).called(1);
  verifyNever(mockService.deleteUser(any));
  verifyNoMoreInteractions(mockService);
});
```

### 3. Mock Argument Matching

```dart
// ✅ Correct Argument Matching
test('should match specific arguments', () async {
  // Arrange
  when(mockService.getUser(argThat(isA<String>()))).thenAnswer((_) async => user);
  when(mockService.createUser(argThat(predicate((u) => u.name.isNotEmpty)))).thenAnswer((_) async {});

  // Act
  await mockService.getUser('user-id');
  await mockService.createUser(TestFixtures.createTestUser());

  // Assert
  verify(mockService.getUser('user-id')).called(1);
  verify(mockService.createUser(argThat(isA<User>()))).called(1);
});
```

## 🎨 ADVANCED MOCKING TECHNIQUES

### 1. Mock with Custom Behavior

```dart
// ✅ Correct Custom Mock Behavior
test('should handle custom mock behavior', () async {
  // Arrange
  when(mockService.processData(any)).thenAnswer((invocation) async {
    final data = invocation.positionalArguments[0] as Map<String, dynamic>;
    return data['id'] != null ? 'processed' : 'error';
  });

  // Act
  final result1 = await mockService.processData({'id': '123'});
  final result2 = await mockService.processData({});

  // Assert
  expect(result1, equals('processed'));
  expect(result2, equals('error'));
});
```

### 2. Mock with Named Parameters

```dart
// ✅ Correct Named Parameter Mocking
test('should handle named parameters', () async {
  // Arrange
  when(mockService.addUserToCompany(
    userId: anyNamed('userId'),
    companyId: anyNamed('companyId'),
  )).thenAnswer((_) async {});

  // Act
  await mockService.addUserToCompany(
    userId: 'user-123',
    companyId: 'company-456',
  );

  // Assert
  verify(mockService.addUserToCompany(
    userId: 'user-123',
    companyId: 'company-456',
  )).called(1);
});
```

### 3. Mock with Streams

```dart
// ✅ Correct Stream Mocking
test('should handle stream mocking', () async {
  // Arrange
  final streamController = StreamController<String>();
  when(mockService.getDataStream()).thenAnswer((_) => streamController.stream);

  // Act
  final stream = mockService.getDataStream();
  streamController.add('data1');
  streamController.add('data2');

  // Assert
  expect(await stream.take(2).toList(), equals(['data1', 'data2']));
  
  streamController.close();
});
```

## 🧹 MOCK CLEANUP

### 1. Proper Mock Cleanup

```dart
// ✅ Correct Mock Cleanup
void main() {
  group('Controller Tests', () {
    late MockService mockService;
    late Controller controller;

    setUp(() {
      mockService = MockService();
      controller = Controller(service: mockService);
    });

    tearDown(() {
      // Reset all mocks
      reset(mockService);
      
      // Clear any global state
      Get.reset();
      
      // Dispose resources
      controller.dispose();
    });
  });
}
```

### 2. Mock State Management

```dart
// ✅ Correct Mock State Management
test('should maintain mock state across calls', () async {
  // Arrange
  when(mockService.getCounter()).thenReturn(0);
  when(mockService.incrementCounter()).thenAnswer((_) {
    // Simulate state change
    when(mockService.getCounter()).thenReturn(1);
  });

  // Act
  expect(mockService.getCounter(), equals(0));
  mockService.incrementCounter();
  expect(mockService.getCounter(), equals(1));
});
```

## 🚨 COMMON MOCKING MISTAKES

### 1. ❌ Incorrect Mock Setup

```dart
// ❌ Bad - Incorrect mock setup
test('should not work', () async {
  // This will fail because mock is not properly configured
  final result = await mockService.method();
  expect(result, equals('expected'));
});
```

### 2. ❌ Mocking Implementation Details

```dart
// ❌ Bad - Mocking implementation details
test('should not mock internals', () async {
  // Don't mock private methods or internal implementation
  when(mockService._privateMethod()).thenReturn('value');
});
```

### 3. ❌ Over-Mocking

```dart
// ❌ Bad - Over-mocking
test('should not over-mock', () async {
  // Don't mock simple data classes or value objects
  when(mockService.getSimpleData()).thenReturn(SimpleData());
  // Just create the object directly
  final data = SimpleData();
});
```

## 🎯 MOCKING BEST PRACTICES

### 1. Mock External Dependencies Only

```dart
// ✅ Good - Mock external dependencies
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockDatabaseService extends Mock implements DatabaseService {}

// ❌ Bad - Don't mock internal classes
class MockUser extends Mock implements User {} // User is a domain entity
```

### 2. Use Real Objects When Possible

```dart
// ✅ Good - Use real objects for simple data
final user = User(
  id: '123',
  name: 'Test User',
  email: 'test@example.com',
);

// ❌ Bad - Don't mock simple data objects
when(mockUser.getId()).thenReturn('123');
```

### 3. Mock Behavior, Not Implementation

```dart
// ✅ Good - Mock behavior
when(mockService.getUser(any)).thenAnswer((_) async => testUser);

// ❌ Bad - Don't mock implementation details
when(mockService.getUser(any)).thenAnswer((_) async {
  // Don't implement complex logic in mocks
  final user = User();
  user.id = '123';
  user.name = 'Test';
  return user;
});
```

## 📊 MOCK TESTING PATTERNS

### 1. Happy Path Testing

```dart
test('should handle successful operation', () async {
  // Arrange
  when(mockService.operation(any)).thenAnswer((_) async => successResult);

  // Act
  final result = await controller.performOperation();

  // Assert
  expect(result, equals(successResult));
  verify(mockService.operation(any)).called(1);
});
```

### 2. Error Handling Testing

```dart
test('should handle operation failure', () async {
  // Arrange
  when(mockService.operation(any)).thenThrow(Exception('Operation failed'));

  // Act & Assert
  expect(
    () => controller.performOperation(),
    throwsA(isA<Exception>()),
  );
});
```

### 3. Edge Case Testing

```dart
test('should handle edge case', () async {
  // Arrange
  when(mockService.operation(any)).thenAnswer((_) async => edgeCaseResult);

  // Act
  final result = await controller.performOperation(edgeCaseInput);

  // Assert
  expect(result, equals(edgeCaseResult));
});
```

## 🔧 MOCK UTILITIES

### 1. Mock Helper Functions

```dart
// ✅ Useful Mock Helper Functions
class MockHelpers {
  static void setupSuccessfulAuth(MockFirebaseAuth mockAuth) {
    when(mockAuth.signInWithEmailAndPassword(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => mockUserCredential);
  }

  static void setupFailedAuth(MockFirebaseAuth mockAuth) {
    when(mockAuth.signInWithEmailAndPassword(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenThrow(FirebaseAuthException(code: 'invalid-credential'));
  }

  static void setupDatabaseSuccess(MockDatabaseService mockDb) {
    when(mockDb.createUser(any)).thenAnswer((_) async {});
    when(mockDb.getUser(any)).thenAnswer((_) async => testUser);
  }
}
```

### 2. Mock Data Factories

```dart
// ✅ Mock Data Factories
class MockDataFactory {
  static UserCredential createUserCredential({
    String uid = 'test-uid',
    String email = 'test@example.com',
  }) {
    final mockCredential = MockUserCredential();
    final mockUser = MockFirebaseUser();
    
    when(mockCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn(uid);
    when(mockUser.email).thenReturn(email);
    
    return mockCredential;
  }
}
```

## 📝 MOCKING CHECKLIST

### Before Writing Tests
- [ ] Identify all external dependencies
- [ ] Create mocks for external services
- [ ] Set up proper mock configuration
- [ ] Plan mock behavior for different scenarios

### During Test Writing
- [ ] Use appropriate mock setup methods
- [ ] Verify mock interactions
- [ ] Test both success and failure scenarios
- [ ] Clean up mocks properly

### After Writing Tests
- [ ] Ensure mocks are properly reset
- [ ] Verify test independence
- [ ] Check mock coverage
- [ ] Review mock complexity

---

**Remember**: Proper mocking is essential for creating reliable, fast, and maintainable tests. Always follow these guidelines to ensure your mocks are effective and your tests are robust.
