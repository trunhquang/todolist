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

---

## 4. Linting & Static Analysis

- Use `package:` imports cho các file trong `lib/`
- Sắp xếp imports và các directive theo thứ tự alphabet
- Thêm doc comments tối thiểu cho public classes, methods, fields
- Tránh `print()` trong production; dùng logging phù hợp hoặc `SnackbarService`
- Xóa tất cả unused imports; ưu tiên IDE auto-organize imports
- Tránh dòng quá dài (> 80 ký tự) trừ khi bất khả kháng; ưu tiên wrapping
- Dùng generic tường minh cho `NavigationService` (`offAllNamed<void>(…)`, `toNamed<void>(…)`, `back<void>(…)`)
- Luôn `await` future từ điều hướng; không bỏ qua `Future`
- Tập trung route paths ở `lib/app/routes/app_router.dart`; không hardcode '/login', '/dashboard' — luôn dùng `AppRouter.*`
- Không hardcode user-facing text ngoài `lib/core/constants/app_strings.dart`; dùng `AppStrings.*`
- Luôn dùng `Future<void>` cho async functions không trả về giá trị
- Ưu tiên `on <ExceptionType>` trong `catch` khi có thể
- Không trả về `dynamic` khi có thể chỉ định type; cast JSON về `Map<String, dynamic>` / `List<Map<String, dynamic>>`
- Không dùng `withOpacity()` (deprecated); dùng `withValues(alpha: value)`
- Thêm type annotations khi type không hiển nhiên (ví dụ `final AuthController _authController = Get.put(AuthController())`)
- Ưu tiên tearoffs thay closures khi chỉ gọi hàm cùng tham số
- Không truyền tham số bằng đúng giá trị default (loại bỏ redundancy)
- Xử lý đúng Future-returning calls — `await` hoặc `unawaited()` khi không cần chờ
- Đặt constructors trước các khai báo khác trong class
- Thứ tự named parameters: required trước optional
- Dùng `ColoredBox` thay `Container(color: ...)` khi chỉ cần màu
- Ưu tiên widget chuyên biệt: `SizedBox`, `ColoredBox`, `DecoratedBox`; chỉ dùng `Container` khi cần nhiều thuộc tính
- Bool parameters phải là named parameters
- Với methods chỉ đổi một property, dùng setter; và tên setter khớp getter
- Chỉ định loại exception trong `catch` (ví dụ `on FormatException catch (e)`)
- Không `await` không cần thiết trong `return`
- Ưu tiên super parameters trong constructors khi phù hợp
- Annotate `@immutable` khi override `==` và `hashCode`
- Được phép import transitive dependencies (ví dụ `meta`)
- Các lớp có thể bị throw phải implement `Exception` (hoặc extend `Error`)
- Tránh `toString()` thừa trong string interpolation
- Cast nullable an toàn với `as?` và xử lý null rõ ràng
- Có thể dùng factory constructors cho singleton; đặt thứ tự named trước unnamed constructors
- Dùng cascade để tránh lặp receiver khi gọi nhiều method liên tiếp
- Tránh type annotations cục bộ không cần thiết — để Dart infer
- Không truyền tham số trùng default (DateTime(...))
- Tránh raw strings không cần thiết; chỉ dùng khi cần backslashes literal
- Không dùng cascade cho single call
- Khi dùng `// ignore:` cho cascade hợp lệ, ghi chú lý do rõ ràng cùng dòng
- Không escape quotes không cần thiết ("Don't" thay vì 'Don\'t')
- Không so sánh với boolean literals; dùng trực tiếp hoặc phủ định
- Với bool nullable, dùng if-null `(maybe ?? false)` thay vì `== true/false`
- Loại bỏ ngoặc thừa không ảnh hưởng ưu tiên toán tử
- Ưu tiên raw strings khi phải escape nhiều backslashes (regex, path, currency)
- Tránh `cond ? true : false`/`cond ? false : true`
- Tránh gọi method trên `dynamic`; cast sớm về type cụ thể
- Ưu tiên `isEmpty`/`isNotEmpty` thay so sánh `length`
- Đặt `child:` cuối cùng trong constructors của widget

---

**📁 Tham khảo thêm:**
- [GetX Specific Rules](GETX_RULES.md)
- [String Management Rules](STRING_MANAGEMENT_RULES.md)
- [UI/UX Rules](UI_UX_RULES.md)
