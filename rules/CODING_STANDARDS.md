# 📝 Coding Standards

## 1. Naming Conventions

### Files & Folders
```
✅ ĐÚNG:
- auth_controller.dart
- task_repository_impl.dart
- user_model.dart
- create_task_usecase.dart

❌ SAI:
- AuthController.dart
- TaskRepositoryImpl.dart
- UserModel.dart
- CreateTaskUsecase.dart
```

### Classes
```
✅ ĐÚNG:
class AuthController extends GetxController {}
class TaskRepositoryImpl implements TaskRepository {}
class UserModel extends Equatable {}

❌ SAI:
class authController extends GetxController {}
class taskRepositoryImpl implements TaskRepository {}
```

### Variables & Methods
```
✅ ĐÚNG:
final _isLoading = false.obs;
final _user = Rxn<User>();
String get errorMessage => _errorMessage.value;

❌ SAI:
final _IsLoading = false.obs;
final _User = Rxn<User>();
String get ErrorMessage => _errorMessage.value;
```

## 2. Code Organization

### Controller Structure
```dart
class TaskController extends GetxController {
  // 1. Dependencies
  final CreateTask _createTask;
  final GetTasks _getTasks;
  
  // 2. Private observables
  final _isLoading = false.obs;
  final _tasks = <Task>[].obs;
  final _errorMessage = ''.obs;
  
  // 3. Constructor
  TaskController(this._createTask, this._getTasks);
  
  // 4. Lifecycle methods
  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }
  
  // 5. Public getters
  bool get isLoading => _isLoading.value;
  List<Task> get tasks => _tasks;
  String get errorMessage => _errorMessage.value;
  
  // 6. Public methods
  Future<void> createTask(Task task) async {
    // Implementation
  }
  
  // 7. Private methods
  void _handleError(String error) {
    // Implementation
  }
}
```

### Repository Structure
```dart
class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _remoteDataSource;
  final TaskLocalDataSource _localDataSource;
  
  TaskRepositoryImpl({
    required TaskRemoteDataSource remoteDataSource,
    required TaskLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;
  
  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      final tasks = await _remoteDataSource.getTasks();
      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

## 3. Error Handling

### Controller Error Handling
```dart
Future<void> createTask(Task task) async {
  try {
    _isLoading.value = true;
    _errorMessage.value = '';
    
    final result = await _createTask.call(CreateTaskParams(task: task));
    
    result.fold(
      (failure) => _errorMessage.value = failure.message,
      (success) => {
        _tasks.add(task),
        Get.snackbar('Success', 'Task created successfully'),
      },
    );
  } catch (e) {
    _errorMessage.value = 'Unexpected error: ${e.toString()}';
  } finally {
    _isLoading.value = false;
  }
}
```

### Repository Error Handling
```dart
@override
Future<Either<Failure, Task>> createTask(Task task) async {
  try {
    final createdTask = await _remoteDataSource.createTask(task);
    await _localDataSource.cacheTask(createdTask);
    return Right(createdTask);
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } on CacheException catch (e) {
    return Left(CacheFailure(e.message));
  } catch (e) {
    return Left(UnknownFailure(e.toString()));
  }
}
```

---

**📁 File liên quan:**
- [Architecture Rules](ARCHITECTURE_RULES.md)
- [GetX Specific Rules](GETX_RULES.md)
- [Testing Rules](TESTING_RULES.md)
