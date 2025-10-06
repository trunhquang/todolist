# 🧪 Testing Rules

## 1. Test Structure
```
test/
├── unit/
│   ├── features/
│   │   └── task/
│   │       ├── data/
│   │       │   ├── repositories/
│   │       │   │   └── task_repository_impl_test.dart
│   │       │   └── datasources/
│   │       │       └── task_remote_datasource_test.dart
│   │       ├── domain/
│   │       │   └── usecases/
│   │       │       └── create_task_test.dart
│   │       └── presentation/
│   │           └── controllers/
│   │               └── task_controller_test.dart
```

## 2. Controller Testing
```dart
class MockCreateTask extends Mock implements CreateTask {}
class MockGetTasks extends Mock implements GetTasks {}

void main() {
  late TaskController controller;
  late MockCreateTask mockCreateTask;
  late MockGetTasks mockGetTasks;

  setUp(() {
    mockCreateTask = MockCreateTask();
    mockGetTasks = MockGetTasks();
    controller = TaskController(mockCreateTask, mockGetTasks);
  });

  group('TaskController', () {
    test('should create task successfully', () async {
      // Arrange
      final task = Task(id: '1', title: 'Test Task');
      when(mockCreateTask.call(any))
          .thenAnswer((_) async => Right(task));

      // Act
      await controller.createTask(task);

      // Assert
      expect(controller.tasks, contains(task));
      expect(controller.isLoading, false);
    });
  });
}
```

## 3. Repository Testing
```dart
void main() {
  late TaskRepositoryImpl repository;
  late MockTaskRemoteDataSource mockRemoteDataSource;
  late MockTaskLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTaskRemoteDataSource();
    mockLocalDataSource = MockTaskLocalDataSource();
    repository = TaskRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('TaskRepositoryImpl', () {
    test('should return tasks when call to remote data source is successful', () async {
      // Arrange
      final tasks = [Task(id: '1', title: 'Test Task')];
      when(mockRemoteDataSource.getTasks())
          .thenAnswer((_) async => tasks);

      // Act
      final result = await repository.getTasks();

      // Assert
      expect(result, Right(tasks));
      verify(mockRemoteDataSource.getTasks());
    });
  });
}
```

---

**📁 File liên quan:**
- [Coding Standards](CODING_STANDARDS.md)
- [Architecture Rules](ARCHITECTURE_RULES.md)
- [Code Review Checklist](CODE_REVIEW_CHECKLIST.md)
