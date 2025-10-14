# 🤖 Cursor Testing Guide for Multi-Workspace Todo List Application

## 📋 OVERVIEW

This guide provides specific instructions for Cursor AI to automatically generate high-quality test cases following the established testing standards and principles.

## 🎯 CURSOR INSTRUCTIONS

### When Writing Tests, ALWAYS:

1. **Read the Testing Rules First**
   - Always check `rules/TESTING_RULES.md`
   - Follow `rules/TEST_CASE_PRINCIPLES.md`
   - Use templates from `rules/TEST_CASE_TEMPLATES.md`
   - Apply mocking guidelines from `rules/MOCKING_GUIDE.md`

2. **Use Test Fixtures**
   - Import from `test/fixtures/` directory
   - Use `UserTestFixtures` for user-related tests
   - Use `CompanyTestFixtures` for company-related tests
   - Create new fixtures following the established patterns

3. **Follow AAA Pattern**
   ```dart
   test('should {expected_behavior} when {condition}', () async {
     // Arrange - Set up test data and mocks
     
     // Act - Execute the method under test
     
     // Assert - Verify the expected outcome
   });
   ```

4. **Use Descriptive Test Names**
   - Format: `should_{expected_behavior}_when_{condition}`
   - Examples:
     - `should_create_user_when_valid_data_provided`
     - `should_throw_exception_when_invalid_email`
     - `should_return_empty_list_when_no_data_exists`

## 🏗️ TEST GENERATION WORKFLOW

### Step 1: Identify Test Requirements
```dart
// When asked to write tests for a controller/service, identify:
// 1. What methods need testing
// 2. What dependencies need mocking
// 3. What scenarios to test (happy path, errors, edge cases)
// 4. What test fixtures are needed
```

### Step 2: Create Test Structure
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:get/get.dart';

import 'package:todolist/features/{feature}/presentation/controllers/{controller}_controller.dart';
import 'package:todolist/core/services/{service}_service.dart';
import 'package:todolist/test/fixtures/{feature}.dart';

class Mock{Service}Service extends Mock implements {Service}Service {}

void main() {
  group('{Controller}Controller', () {
    late Mock{Service}Service mock{Service}Service;
    late {Controller}Controller controller;

    setUp(() {
      mock{Service}Service = Mock{Service}Service();
      controller = {Controller}Controller(
        {service}Service: mock{Service}Service,
      );
    });

    tearDown(() {
      reset(mock{Service}Service);
      Get.reset();
    });

    // Test methods here
  });
}
```

### Step 3: Write Test Cases
For each method, create tests for:
- **Happy Path**: Normal successful operation
- **Error Cases**: Exception scenarios
- **Edge Cases**: Boundary conditions
- **Validation**: Input validation

## 🎨 TESTING PATTERNS FOR CURSOR

### 1. Controller Testing Pattern
```dart
group('{methodName}', () {
  test('should {expected_behavior} when {condition}', () async {
    // Arrange
    final testData = TestFixtures.create{Entity}();
    when(mockService.{methodName}(any)).thenAnswer((_) async => expectedResult);

    // Act
    await controller.{methodName}(testData);

    // Assert
    verify(mockService.{methodName}(any)).called(1);
    expect(controller.{stateProperty}, equals(expectedValue));
  });

  test('should throw {ExceptionType} when {error_condition}', () async {
    // Arrange
    when(mockService.{methodName}(any)).thenThrow({ExceptionType}());

    // Act & Assert
    expect(
      () => controller.{methodName}(invalidData),
      throwsA(isA<{ExceptionType}>()),
    );
  });
});
```

### 2. Service Testing Pattern
```dart
group('{ServiceName}Service', () {
  test('should return {expected_result} when {condition}', () async {
    // Arrange
    final testData = TestFixtures.create{Entity}();
    when(mockRepository.{methodName}(any)).thenAnswer((_) async => expectedResult);

    // Act
    final result = await service.{methodName}(testData);

    // Assert
    expect(result, equals(expectedResult));
    verify(mockRepository.{methodName}(any)).called(1);
  });
});
```

### 3. Widget Testing Pattern
```dart
testWidgets('should display {expected_content} when {condition}', (tester) async {
  // Arrange
  when(mockController.{stateProperty}).thenReturn(expectedValue);

  // Act
  await tester.pumpWidget(
    GetMaterialApp(
      home: {WidgetName}(),
    ),
  );
  await tester.pumpAndSettle();

  // Assert
  expect(find.text('{expected_text}'), findsOneWidget);
});
```

## 🔧 MOCKING INSTRUCTIONS FOR CURSOR

### 1. Always Mock External Dependencies
```dart
// ✅ Correct - Mock external services
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockDatabaseService extends Mock implements DatabaseService {}

// ❌ Wrong - Don't mock domain entities
class MockUser extends Mock implements User {}
```

### 2. Use Proper Mock Setup
```dart
// ✅ Correct Mock Setup
when(mockService.method(any)).thenAnswer((_) async => result);
when(mockService.method(argThat(isA<Type>()))).thenAnswer((_) async => result);

// ❌ Wrong - Don't use complex logic in mocks
when(mockService.method(any)).thenAnswer((_) async {
  // Don't implement complex logic here
  return complexResult;
});
```

### 3. Verify Mock Interactions
```dart
// ✅ Always verify important interactions
verify(mockService.method(any)).called(1);
verify(mockService.method(specificArgument)).called(1);
verifyNever(mockService.unwantedMethod(any));
```

## 📊 TEST FIXTURE USAGE

### 1. Use Existing Fixtures
```dart
// ✅ Use existing fixtures
final user = UserTestFixtures.createUser();
final adminUser = UserTestFixtures.createAdminUser();
final company = CompanyTestFixtures.createCompany();

// ✅ Use fixtures with custom parameters
final user = UserTestFixtures.createUser(
  email: 'custom@example.com',
  name: 'Custom User',
);
```

### 2. Create New Fixtures When Needed
```dart
// ✅ Create new fixture methods following the pattern
static {Entity} create{Entity}With{SpecialCondition}({
  String? id,
  String? name,
}) {
  return create{Entity}(
    id: id,
    name: name,
    // Add special condition properties
  );
}
```

## 🚨 ERROR HANDLING FOR CURSOR

### 1. Always Test Error Scenarios
```dart
test('should throw {ExceptionType} when {error_condition}', () async {
  // Arrange
  when(mockService.method(any)).thenThrow({ExceptionType}());

  // Act & Assert
  expect(
    () => controller.method(invalidData),
    throwsA(isA<{ExceptionType}>()),
  );
});
```

### 2. Test Specific Error Codes
```dart
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
```

## 🎯 TEST COVERAGE REQUIREMENTS

### 1. Required Test Types
For each method, create:
- **Happy Path Test**: Normal successful operation
- **Error Test**: Exception/error scenarios
- **Edge Case Test**: Boundary conditions
- **Validation Test**: Input validation

### 2. Test Coverage Goals
- **Unit Tests**: 90% code coverage
- **Widget Tests**: 80% widget coverage
- **Integration Tests**: 70% critical path coverage

## 📝 CURSOR COMMANDS

### When Asked to Write Tests:
1. **Read the rules first**: Check `rules/TESTING_RULES.md`
2. **Use templates**: Follow `rules/TEST_CASE_TEMPLATES.md`
3. **Apply mocking**: Use `rules/MOCKING_GUIDE.md`
4. **Use fixtures**: Import from `test/fixtures/`
5. **Follow patterns**: Use established testing patterns

### Example Cursor Prompt:
```
Write comprehensive tests for the AuthController.signUpWithEmailAndPassword method following the established testing rules and using the provided fixtures.
```

### Expected Cursor Response:
1. Import necessary testing libraries
2. Create proper mocks for dependencies
3. Use test fixtures for data
4. Write tests for happy path, errors, and edge cases
5. Follow AAA pattern
6. Use descriptive test names
7. Verify mock interactions

## 🔍 QUALITY CHECKLIST FOR CURSOR

### Before Generating Tests:
- [ ] Read testing rules and principles
- [ ] Identify all dependencies to mock
- [ ] Plan test scenarios (happy path, errors, edge cases)
- [ ] Check if test fixtures exist
- [ ] Follow established naming conventions

### During Test Generation:
- [ ] Use proper mock setup
- [ ] Follow AAA pattern
- [ ] Use descriptive test names
- [ ] Test both success and failure scenarios
- [ ] Include edge cases and boundary conditions
- [ ] Verify mock interactions

### After Test Generation:
- [ ] Ensure tests are independent
- [ ] Check test coverage
- [ ] Verify test readability
- [ ] Ensure proper cleanup
- [ ] Follow established patterns

## 🚀 EXAMPLE CURSOR WORKFLOW

### Input:
```
Write tests for the TaskController.createTask method
```

### Cursor Should:
1. **Read Rules**: Check `rules/TESTING_RULES.md`
2. **Use Template**: Follow controller test template
3. **Create Mocks**: Mock TaskService and dependencies
4. **Use Fixtures**: Import and use TaskTestFixtures
5. **Write Tests**:
   - Happy path: successful task creation
   - Error cases: validation failures, service errors
   - Edge cases: empty data, long names, special characters
6. **Verify**: Mock interactions and state changes

### Expected Output:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:get/get.dart';

import 'package:todolist/features/tasks/presentation/controllers/task_controller.dart';
import 'package:todolist/core/services/task_service.dart';
import 'package:todolist/test/fixtures/tasks.dart';

class MockTaskService extends Mock implements TaskService {}

void main() {
  group('TaskController', () {
    late MockTaskService mockTaskService;
    late TaskController controller;

    setUp(() {
      mockTaskService = MockTaskService();
      controller = TaskController(taskService: mockTaskService);
    });

    tearDown(() {
      reset(mockTaskService);
      Get.reset();
    });

    group('createTask', () {
      test('should create task successfully when valid data provided', () async {
        // Arrange
        final taskData = TaskTestFixtures.createTask();
        when(mockTaskService.createTask(any)).thenAnswer((_) async => 'task-id');

        // Act
        await controller.createTask(taskData);

        // Assert
        verify(mockTaskService.createTask(taskData)).called(1);
        expect(controller.tasks.length, equals(1));
      });

      test('should throw ValidationException when invalid data provided', () async {
        // Arrange
        final invalidTask = TaskTestFixtures.createInvalidTask();
        when(mockTaskService.createTask(any)).thenThrow(ValidationException());

        // Act & Assert
        expect(
          () => controller.createTask(invalidTask),
          throwsA(isA<ValidationException>()),
        );
      });
    });
  });
}
```

---

**Remember**: Cursor should always follow these guidelines to generate consistent, high-quality tests that meet the project's standards and requirements.
