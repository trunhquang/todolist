# 📋 Test Case Templates for Multi-Workspace Todo List Application

## 🎯 TEMPLATE OVERVIEW

This document provides standardized templates for writing tests across the application. Use these templates to ensure consistency and completeness in test coverage.

## 🏗️ UNIT TEST TEMPLATES

### 1. Controller Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:get/get.dart';

import 'package:todolist/features/{feature}/presentation/controllers/{controller_name}_controller.dart';
import 'package:todolist/core/services/{service_name}_service.dart';
import 'package:todolist/test/fixtures/{feature}.dart';

class Mock{ServiceName}Service extends Mock implements {ServiceName}Service {}

void main() {
  group('{ControllerName}Controller', () {
    late Mock{ServiceName}Service mock{ServiceName}Service;
    late {ControllerName}Controller controller;

    setUp(() {
      mock{ServiceName}Service = Mock{ServiceName}Service();
      controller = {ControllerName}Controller(
        {serviceName}Service: mock{ServiceName}Service,
      );
    });

    tearDown(() {
      reset(mock{ServiceName}Service);
      Get.reset();
    });

    group('{methodName}', () {
      test('should {expected_behavior} when {condition}', () async {
        // Arrange
        final testData = TestFixtures.create{EntityName}();
        when(mock{ServiceName}Service.{methodName}(any))
            .thenAnswer((_) async => expectedResult);

        // Act
        await controller.{methodName}(testData);

        // Assert
        verify(mock{ServiceName}Service.{methodName}(any)).called(1);
        expect(controller.{stateProperty}, equals(expectedValue));
      });

      test('should throw {ExceptionType} when {error_condition}', () async {
        // Arrange
        when(mock{ServiceName}Service.{methodName}(any))
            .thenThrow({ExceptionType}());

        // Act & Assert
        expect(
          () => controller.{methodName}(invalidData),
          throwsA(isA<{ExceptionType}>()),
        );
      });

      test('should handle {edge_case} correctly', () async {
        // Arrange
        final edgeCaseData = TestFixtures.create{EntityName}With{EdgeCase}();

        // Act
        final result = await controller.{methodName}(edgeCaseData);

        // Assert
        expect(result, equals(expectedEdgeCaseResult));
      });
    });
  });
}
```

### 2. Service Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:todolist/core/services/{service_name}_service.dart';
import 'package:todolist/core/repositories/{repository_name}_repository.dart';
import 'package:todolist/test/fixtures/{feature}.dart';

class Mock{RepositoryName}Repository extends Mock implements {RepositoryName}Repository {}

void main() {
  group('{ServiceName}Service', () {
    late Mock{RepositoryName}Repository mock{RepositoryName}Repository;
    late {ServiceName}Service service;

    setUp(() {
      mock{RepositoryName}Repository = Mock{RepositoryName}Repository();
      service = {ServiceName}Service(
        {repositoryName}Repository: mock{RepositoryName}Repository,
      );
    });

    tearDown(() {
      reset(mock{RepositoryName}Repository);
    });

    group('{methodName}', () {
      test('should return {expected_result} when {condition}', () async {
        // Arrange
        final testData = TestFixtures.create{EntityName}();
        when(mock{RepositoryName}Repository.{methodName}(any))
            .thenAnswer((_) async => expectedResult);

        // Act
        final result = await service.{methodName}(testData);

        // Assert
        expect(result, equals(expectedResult));
        verify(mock{RepositoryName}Repository.{methodName}(any)).called(1);
      });

      test('should throw {ExceptionType} when {error_condition}', () async {
        // Arrange
        when(mock{RepositoryName}Repository.{methodName}(any))
            .thenThrow({ExceptionType}());

        // Act & Assert
        expect(
          () => service.{methodName}(invalidData),
          throwsA(isA<{ExceptionType}>()),
        );
      });
    });
  });
}
```

### 3. Repository Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:todolist/features/{feature}/data/repositories/{repository_name}_repository_impl.dart';
import 'package:todolist/features/{feature}/data/datasources/{datasource_name}_datasource.dart';
import 'package:todolist/test/fixtures/{feature}.dart';

class Mock{DatasourceName}Datasource extends Mock implements {DatasourceName}Datasource {}

void main() {
  group('{RepositoryName}RepositoryImpl', () {
    late Mock{DatasourceName}Datasource mock{DatasourceName}Datasource;
    late {RepositoryName}RepositoryImpl repository;

    setUp(() {
      mock{DatasourceName}Datasource = Mock{DatasourceName}Datasource();
      repository = {RepositoryName}RepositoryImpl(
        {datasourceName}Datasource: mock{DatasourceName}Datasource,
      );
    });

    tearDown(() {
      reset(mock{DatasourceName}Datasource);
    });

    group('{methodName}', () {
      test('should return {expected_result} when {condition}', () async {
        // Arrange
        final testData = TestFixtures.create{EntityName}();
        when(mock{DatasourceName}Datasource.{methodName}(any))
            .thenAnswer((_) async => expectedResult);

        // Act
        final result = await repository.{methodName}(testData);

        // Assert
        expect(result, equals(expectedResult));
        verify(mock{DatasourceName}Datasource.{methodName}(any)).called(1);
      });

      test('should throw {ExceptionType} when {error_condition}', () async {
        // Arrange
        when(mock{DatasourceName}Datasource.{methodName}(any))
            .thenThrow({ExceptionType}());

        // Act & Assert
        expect(
          () => repository.{methodName}(invalidData),
          throwsA(isA<{ExceptionType}>()),
        );
      });
    });
  });
}
```

## 🎨 WIDGET TEST TEMPLATES

### 1. Page Widget Test Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:todolist/features/{feature}/presentation/pages/{page_name}_page.dart';
import 'package:todolist/features/{feature}/presentation/controllers/{controller_name}_controller.dart';
import 'package:todolist/test/fixtures/{feature}.dart';

class Mock{ControllerName}Controller extends Mock implements {ControllerName}Controller {}

void main() {
  group('{PageName}Page', () {
    late Mock{ControllerName}Controller mock{ControllerName}Controller;

    setUp(() {
      mock{ControllerName}Controller = Mock{ControllerName}Controller();
      Get.put<{ControllerName}Controller>(mock{ControllerName}Controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('should display {expected_content} when {condition}', (tester) async {
      // Arrange
      when(mock{ControllerName}Controller.{stateProperty}).thenReturn(expectedValue);
      when(mock{ControllerName}Controller.isLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(
        GetMaterialApp(
          home: {PageName}Page(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('{expected_text}'), findsOneWidget);
      expect(find.byKey(Key('{expected_key}')), findsOneWidget);
    });

    testWidgets('should show loading indicator when isLoading is true', (tester) async {
      // Arrange
      when(mock{ControllerName}Controller.isLoading).thenReturn(true);

      // Act
      await tester.pumpWidget(
        GetMaterialApp(
          home: {PageName}Page(),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should call {methodName} when {action} is performed', (tester) async {
      // Arrange
      when(mock{ControllerName}Controller.{methodName}()).thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(
        GetMaterialApp(
          home: {PageName}Page(),
        ),
      );
      await tester.tap(find.byKey(Key('{button_key}')));
      await tester.pumpAndSettle();

      // Assert
      verify(mock{ControllerName}Controller.{methodName}()).called(1);
    });
  });
}
```

### 2. Component Widget Test Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todolist/features/{feature}/presentation/widgets/{widget_name}_widget.dart';
import 'package:todolist/test/fixtures/{feature}.dart';

void main() {
  group('{WidgetName}Widget', () {
    testWidgets('should render correctly with {condition}', (tester) async {
      // Arrange
      final testData = TestFixtures.create{EntityName}();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: {WidgetName}Widget(
              data: testData,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType({WidgetName}Widget), findsOneWidget);
      expect(find.text('{expected_text}'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      // Arrange
      bool wasTapped = false;
      final testData = TestFixtures.create{EntityName}();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: {WidgetName}Widget(
              data: testData,
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byType({WidgetName}Widget));
      await tester.pumpAndSettle();

      // Assert
      expect(wasTapped, isTrue);
    });

    testWidgets('should display {expected_content} when {condition}', (tester) async {
      // Arrange
      final testData = TestFixtures.create{EntityName}With{Condition}();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: {WidgetName}Widget(
              data: testData,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('{expected_text}'), findsOneWidget);
      expect(find.byIcon(Icons.{expected_icon}), findsOneWidget);
    });
  });
}
```

## 🔄 INTEGRATION TEST TEMPLATES

### 1. Feature Integration Test Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:todolist/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('{FeatureName} Integration Tests', () {
    testWidgets('should complete {feature_flow} flow successfully', (tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act - Step 1
      await tester.enterText(find.byKey(Key('{input_field_key}')), '{test_input}');
      await tester.tap(find.byKey(Key('{button_key}')));
      await tester.pumpAndSettle();

      // Assert - Step 1
      expect(find.text('{expected_text_1}'), findsOneWidget);

      // Act - Step 2
      await tester.tap(find.byKey(Key('{next_button_key}')));
      await tester.pumpAndSettle();

      // Assert - Step 2
      expect(find.text('{expected_text_2}'), findsOneWidget);

      // Act - Step 3
      await tester.tap(find.byKey(Key('{submit_button_key}')));
      await tester.pumpAndSettle();

      // Assert - Final
      expect(find.text('{success_message}'), findsOneWidget);
    });

    testWidgets('should handle {error_scenario} gracefully', (tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(find.byKey(Key('{input_field_key}')), '{invalid_input}');
      await tester.tap(find.byKey(Key('{button_key}')));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('{error_message}'), findsOneWidget);
    });
  });
}
```

### 2. API Integration Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:todolist/core/services/{service_name}_service.dart';
import 'package:todolist/test/fixtures/{feature}.dart';

void main() {
  group('{ServiceName}Service Integration Tests', () {
    late {ServiceName}Service service;

    setUp(() {
      service = {ServiceName}Service();
    });

    group('{methodName}', () {
      test('should {expected_behavior} when calling real API', () async {
        // Arrange
        final testData = TestFixtures.create{EntityName}();

        // Act
        final result = await service.{methodName}(testData);

        // Assert
        expect(result, isNotNull);
        expect(result, isA<{ExpectedType}>());
        // Add more specific assertions based on expected API response
      });

      test('should handle API errors gracefully', () async {
        // Arrange
        final invalidData = TestFixtures.createInvalid{EntityName}();

        // Act & Assert
        expect(
          () => service.{methodName}(invalidData),
          throwsA(isA<{ExceptionType}>()),
        );
      });
    });
  });
}
```

## 📊 TEST FIXTURE TEMPLATES

### 1. Entity Test Fixture Template

```dart
import 'package:todolist/features/{feature}/domain/entities/{entity_name}.dart';

class {EntityName}TestFixtures {
  static {EntityName} create{EntityName}({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    // Add other parameters as needed
  }) {
    return {EntityName}(
      id: id ?? 'test-{entity_name}-id',
      name: name ?? 'Test {EntityName}',
      description: description ?? 'Test Description',
      createdAt: createdAt ?? DateTime.now(),
      // Add other properties as needed
    );
  }

  static {EntityName} create{EntityName}With{SpecialCondition}({
    String? id,
    String? name,
    // Add specific parameters for special condition
  }) {
    return create{EntityName}(
      id: id,
      name: name,
      // Add specific properties for special condition
    );
  }

  static List<{EntityName}> create{EntityName}List({
    int count = 3,
  }) {
    return List.generate(count, (index) => create{EntityName}(
      id: 'test-{entity_name}-id-$index',
      name: 'Test {EntityName} $index',
    ));
  }

  static {EntityName} createInvalid{EntityName}() {
    return {EntityName}(
      id: '', // Invalid empty ID
      name: '', // Invalid empty name
      description: '', // Invalid empty description
      createdAt: DateTime.now(),
    );
  }
}
```

### 2. Model Test Fixture Template

```dart
import 'package:todolist/features/{feature}/data/models/{model_name}_model.dart';

class {ModelName}TestFixtures {
  static {ModelName}Model create{ModelName}Model({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    // Add other parameters as needed
  }) {
    return {ModelName}Model(
      id: id ?? 'test-{model_name}-id',
      name: name ?? 'Test {ModelName}',
      description: description ?? 'Test Description',
      createdAt: createdAt ?? DateTime.now(),
      // Add other properties as needed
    );
  }

  static Map<String, dynamic> create{ModelName}Json({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
  }) {
    return {
      'id': id ?? 'test-{model_name}-id',
      'name': name ?? 'Test {ModelName}',
      'description': description ?? 'Test Description',
      'createdAt': (createdAt ?? DateTime.now()).millisecondsSinceEpoch,
      // Add other JSON properties as needed
    };
  }

  static List<Map<String, dynamic>> create{ModelName}JsonList({
    int count = 3,
  }) {
    return List.generate(count, (index) => create{ModelName}Json(
      id: 'test-{model_name}-id-$index',
      name: 'Test {ModelName} $index',
    ));
  }
}
```

## 🎯 PERFORMANCE TEST TEMPLATES

### 1. Response Time Test Template

```dart
import 'package:flutter_test/flutter_test.dart';

import 'package:todolist/features/{feature}/presentation/controllers/{controller_name}_controller.dart';

void main() {
  group('{ControllerName}Controller Performance Tests', () {
    late {ControllerName}Controller controller;

    setUp(() {
      controller = {ControllerName}Controller();
    });

    test('should complete {operation} within {time_limit}ms', () async {
      // Arrange
      final stopwatch = Stopwatch()..start();
      final testData = TestFixtures.create{EntityName}();

      // Act
      await controller.{methodName}(testData);

      // Assert
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan({time_limit}));
    });

    test('should handle {large_dataset} efficiently', () async {
      // Arrange
      final largeDataset = TestFixtures.create{EntityName}List(count: 1000);
      final stopwatch = Stopwatch()..start();

      // Act
      await controller.{methodName}(largeDataset);

      // Assert
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // 5 seconds
    });
  });
}
```

### 2. Memory Usage Test Template

```dart
import 'package:flutter_test/flutter_test.dart';

import 'package:todolist/features/{feature}/presentation/controllers/{controller_name}_controller.dart';

void main() {
  group('{ControllerName}Controller Memory Tests', () {
    late {ControllerName}Controller controller;

    setUp(() {
      controller = {ControllerName}Controller();
    });

    test('should not leak memory when processing {operation}', () async {
      // Arrange
      final initialMemory = ProcessInfo.currentRss;
      final testData = TestFixtures.create{EntityName}();

      // Act
      await controller.{methodName}(testData);
      
      // Force garbage collection
      await Future.delayed(Duration(milliseconds: 100));

      // Assert
      final finalMemory = ProcessInfo.currentRss;
      expect(finalMemory - initialMemory, lessThan(10 * 1024 * 1024)); // 10MB
    });
  });
}
```

## 📝 USAGE INSTRUCTIONS

### How to Use These Templates

1. **Copy the appropriate template** for your test type
2. **Replace placeholders** with actual values:
   - `{feature}` → Feature name (e.g., auth, tasks, workspace)
   - `{ControllerName}` → Controller class name
   - `{EntityName}` → Entity class name
   - `{methodName}` → Method being tested
   - `{expected_behavior}` → What the test expects
   - `{condition}` → When the behavior occurs

3. **Customize the test logic** based on your specific requirements
4. **Add additional test cases** as needed
5. **Follow the AAA pattern** (Arrange, Act, Assert)

### Template Placeholders

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `{feature}` | Feature name | `auth`, `tasks`, `workspace` |
| `{ControllerName}` | Controller class name | `AuthController`, `TaskController` |
| `{EntityName}` | Entity class name | `User`, `Task`, `Company` |
| `{methodName}` | Method being tested | `signUp`, `createTask`, `createCompany` |
| `{expected_behavior}` | Expected behavior | `create user`, `throw exception`, `return data` |
| `{condition}` | Test condition | `valid data provided`, `invalid input`, `user not found` |

---

**Remember**: These templates provide a starting point. Always customize them based on your specific testing needs and follow the established testing principles.
