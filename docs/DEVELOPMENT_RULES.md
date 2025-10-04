# 📋 Development Rules & Guidelines

## 🎯 Mục đích
File này định nghĩa các quy tắc và hướng dẫn phát triển để đảm bảo:
- **Tính nhất quán** trong codebase
- **Dễ dàng refactor** và maintain
- **Chất lượng code** cao
- **Team collaboration** hiệu quả

---

## 🏗️ Architecture Rules

### 1. Clean Architecture Pattern
```
✅ ĐÚNG: features/auth/presentation/controllers/auth_controller.dart
❌ SAI: features/auth/auth_controller.dart
```

**Quy tắc:**
- Mỗi feature phải tuân theo Clean Architecture: `data/domain/presentation`
- Không được bỏ qua layer nào
- Dependencies chỉ được point inward (presentation → domain → data)

### 2. Feature-Based Structure
```
✅ ĐÚNG: features/task/presentation/controllers/task_controller.dart
❌ SAI: controllers/task_controller.dart
```

**Quy tắc:**
- Mỗi feature phải độc lập và self-contained
- Không được import trực tiếp giữa các features
- Shared code phải đặt trong `shared/` folder

### 3. GetX Architecture
```
✅ ĐÚNG: 
class TaskController extends GetxController {
  final _tasks = <Task>[].obs;
  List<Task> get tasks => _tasks;
}

❌ SAI:
class TaskController extends GetxController {
  List<Task> tasks = [];
}
```

**Quy tắc:**
- Controllers phải extend `GetxController`
- State variables phải là `.obs` (observable)
- Public getters để access private observables
- Sử dụng `Get.find()` cho dependency injection

---

## 📝 Coding Standards

### 1. Naming Conventions

#### Files & Folders
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

#### Classes
```
✅ ĐÚNG:
class AuthController extends GetxController {}
class TaskRepositoryImpl implements TaskRepository {}
class UserModel extends Equatable {}

❌ SAI:
class authController extends GetxController {}
class taskRepositoryImpl implements TaskRepository {}
```

#### Variables & Methods
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

### 2. Code Organization

#### Controller Structure
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

#### Repository Structure
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

### 3. Error Handling

#### Controller Error Handling
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

#### Repository Error Handling
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

## 🔧 GetX Specific Rules

### 1. State Management

#### Observable Variables
```dart
✅ ĐÚNG:
final _tasks = <Task>[].obs;
final _isLoading = false.obs;
final _user = Rxn<User>();

❌ SAI:
final tasks = <Task>[].obs;
final isLoading = false.obs;
final user = Rxn<User>();
```

#### Reactive UI
```dart
✅ ĐÚNG:
Obx(() => _controller.isLoading 
  ? CircularProgressIndicator() 
  : TaskList(tasks: _controller.tasks))

❌ SAI:
_controller.isLoading 
  ? CircularProgressIndicator() 
  : TaskList(tasks: _controller.tasks)
```

### 2. Dependency Injection

#### Controller Registration
```dart
✅ ĐÚNG:
class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskController>(() => TaskController(
      Get.find<CreateTask>(),
      Get.find<GetTasks>(),
    ));
  }
}

❌ SAI:
class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TaskController());
  }
}
```

#### Service Registration
```dart
✅ ĐÚNG:
Get.lazyPut<AuthRepository>(
  () => AuthRepositoryImpl(
    remoteDataSource: Get.find(),
    localDataSource: Get.find(),
  ),
);

❌ SAI:
Get.put(AuthRepositoryImpl());
```

### 3. Navigation

#### Route Navigation
```dart
✅ ĐÚNG:
Get.toNamed(AppRoutes.taskDetail, arguments: taskId);
Get.offAllNamed(AppRoutes.home);
Get.back(result: updatedTask);

❌ SAI:
Navigator.pushNamed(context, '/task-detail');
Navigator.pushAndRemoveUntil(context, ...);
Navigator.pop(context);
```

#### Route Arguments
```dart
✅ ĐÚNG:
// Passing arguments
Get.toNamed(AppRoutes.taskDetail, arguments: {'taskId': taskId});

// Receiving arguments
final args = Get.arguments as Map<String, dynamic>;
final taskId = args['taskId'] as String;

❌ SAI:
Get.toNamed(AppRoutes.taskDetail, arguments: taskId);
final taskId = Get.arguments as String;
```

---

## 🧪 Testing Rules

### 1. Test Structure
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

### 2. Controller Testing
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

### 3. Repository Testing
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

## 📱 UI/UX Rules

### 1. Widget Composition & Size Management

#### Widget Size Limits
```
✅ ĐÚNG: 
- Mỗi widget file không quá 100 dòng
- Mỗi file không quá 400 dòng
- Chia widget lớn thành nhiều widget nhỏ

❌ SAI:
- Widget 200+ dòng code
- File 500+ dòng code
- Monolithic widgets
```

#### Widget Composition Example
```dart
// ✅ ĐÚNG: Chia nhỏ widget
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TDCard(
      child: Column(
        children: [
          TaskCardHeader(task: task),
          TaskCardContent(task: task),
          TaskCardActions(
            onTap: onTap,
            onDelete: onDelete,
          ),
        ],
      ),
    );
  }
}

// TaskCardHeader - Widget nhỏ
class TaskCardHeader extends StatelessWidget {
  final Task task;
  
  const TaskCardHeader({Key? key, required this.task}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      child: TDText.heading(task.title),
    );
  }
}
```

### 2. Custom Widget Inheritance (TD Prefix)

#### Custom Widget Rules
```
✅ ĐÚNG: Tất cả custom widgets phải có prefix TD
- TDCard, TDButton, TDText, TDTextField
- TDAppBar, TDDialog, TDSnackbar
- TDLoading, TDError, TDEmpty

❌ SAI: Sử dụng trực tiếp Material widgets
- Card, ElevatedButton, Text, TextField
- AppBar, AlertDialog, SnackBar
```

### 3. Centralized Services

#### SnackbarService Rules
```
✅ ĐÚNG: Sử dụng SnackbarService cho tất cả thông báo
- SnackbarService.instance.showSuccess()
- SnackbarService.instance.showError()
- SnackbarService.instance.showWarning()
- SnackbarService.instance.showInfo()
- SnackbarService.instance.showTaskCreated()
- SnackbarService.instance.showNetworkError()

❌ SAI: Sử dụng trực tiếp Get.snackbar
- Get.snackbar()
- ScaffoldMessenger.of(context).showSnackBar()
```

#### NavigationService Rules
```
✅ ĐÚNG: Sử dụng NavigationService cho tất cả navigation
- NavigationService.instance.toNamed()
- NavigationService.instance.offAllNamed()
- NavigationService.instance.back()
- NavigationService.instance.showDialog()
- NavigationService.instance.showBottomSheet()
- NavigationService.instance.showAlertDialog()

❌ SAI: Sử dụng trực tiếp Get navigation
- Get.toNamed()
- Get.offAllNamed()
- Get.back()
- Get.dialog()
```

### 4. String Management & Localization

#### String Management Rules
```
✅ ĐÚNG: Sử dụng AppStrings cho tất cả strings
- AppStrings.taskCreatedSuccessfully
- AppStrings.confirm
- AppStrings.cancel

❌ SAI: Hardcode strings
- "Task created successfully"
- "Confirm"
- "Cancel"
```

### 5. Consistent Spacing & Padding

#### Spacing Rules
```
✅ ĐÚNG: Sử dụng AppSpacing cho tất cả spacing
- AppSpacing.cardPadding
- AppSpacing.contentMargin
- AppSpacing.sectionSpacing

❌ SAI: Hardcode spacing values
- EdgeInsets.all(16)
- EdgeInsets.symmetric(horizontal: 24)
- SizedBox(height: 8)
```

### 6. Widget Structure
```dart
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
```

### 2. Responsive Design
```dart
✅ ĐÚNG:
class ResponsiveTaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => TaskCard(),
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) => TaskCard(),
          );
        }
      },
    );
  }
}
```

### 3. Loading States
```dart
✅ ĐÚNG:
Obx(() {
  if (controller.isLoading) {
    return Center(child: CircularProgressIndicator());
  }
  
  if (controller.tasks.isEmpty) {
    return Center(child: Text('No tasks found'));
  }
  
  return ListView.builder(
    itemCount: controller.tasks.length,
    itemBuilder: (context, index) => TaskCard(
      task: controller.tasks[index],
    ),
  );
})
```

---

## 🛠️ Implementation Examples

### 1. Custom Widget Implementation
```dart
// shared/widgets/td_card.dart
class TDCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;

  const TDCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? AppSpacing.cardMargin,
      child: Card(
        elevation: elevation ?? AppTheme.cardElevation,
        color: backgroundColor ?? AppTheme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
        child: Padding(
          padding: padding ?? AppSpacing.cardPadding,
          child: child,
        ),
      ),
    );
  }
}

// shared/widgets/td_button.dart
class TDButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final TDButtonType type;
  final TDButtonSize size;
  final IconData? icon;

  const TDButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = TDButtonType.primary,
    this.size = TDButtonSize.medium,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: _getButtonStyle(context),
      child: _buildButtonContent(),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      padding: AppSpacing.getButtonPadding(size),
      backgroundColor: AppTheme.getButtonColor(type),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppTheme.getIconSize(size)),
          SizedBox(width: AppSpacing.iconTextSpacing),
          TDText.button(text),
        ],
      );
    }
    return TDText.button(text);
  }
}
```

### 2. Notification Service Implementation
```dart
// shared/services/notification_service.dart
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static void showSnackbar({
    required String message,
    String? title,
    TDNotificationType type = TDNotificationType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    Get.snackbar(
      title ?? _getDefaultTitle(type),
      message,
      backgroundColor: AppTheme.getNotificationColor(type),
      colorText: AppTheme.getNotificationTextColor(type),
      duration: duration,
      snackPosition: SnackPosition.BOTTOM,
      margin: AppSpacing.snackbarMargin,
      borderRadius: AppTheme.borderRadius,
      onTap: onTap != null ? (_) => onTap() : null,
    );
  }

  static Future<T?> showDialog<T>({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return Get.dialog<T>(
      TDDialog(
        title: title,
        message: message,
        confirmText: confirmText ?? AppStrings.confirm,
        cancelText: cancelText ?? AppStrings.cancel,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
      barrierDismissible: barrierDismissible,
    );
  }
}
```

### 3. String Management Implementation
```dart
// shared/constants/app_strings.dart
class AppStrings {
  // Common
  static const String confirm = 'confirm';
  static const String cancel = 'cancel';
  static const String ok = 'ok';
  static const String save = 'save';
  static const String delete = 'delete';
  static const String edit = 'edit';
  static const String add = 'add';
  static const String search = 'search';
  static const String loading = 'loading';
  static const String error = 'error';
  static const String success = 'success';
  static const String warning = 'warning';
  static const String info = 'info';

  // Tasks
  static const String tasks = 'tasks';
  static const String task = 'task';
  static const String createTask = 'create_task';
  static const String editTask = 'edit_task';
  static const String deleteTask = 'delete_task';
  static const String taskTitle = 'task_title';
  static const String taskDescription = 'task_description';
  static const String taskCreatedSuccessfully = 'task_created_successfully';
  static const String taskUpdatedSuccessfully = 'task_updated_successfully';
  static const String taskDeletedSuccessfully = 'task_deleted_successfully';

  // Task Types
  static const String dailyTask = 'daily_task';
  static const String weeklyTask = 'weekly_task';
  static const String monthlyTask = 'monthly_task';
  static const String projectTask = 'project_task';

  // Validation Messages
  static const String fieldRequired = 'field_required';
  static const String emailInvalid = 'email_invalid';
  static const String passwordTooShort = 'password_too_short';

  // Error Messages
  static const String unexpectedError = 'unexpected_error';
  static const String networkError = 'network_error';
  static const String serverError = 'server_error';
}
```

### 4. Spacing Implementation
```dart
// shared/constants/app_spacing.dart
class AppSpacing {
  // Base spacing unit
  static const double _baseUnit = 8.0;

  // Padding
  static const EdgeInsets cardPadding = EdgeInsets.all(_baseUnit * 2); // 16
  static const EdgeInsets contentPadding = EdgeInsets.all(_baseUnit * 1.5); // 12
  static const EdgeInsets actionPadding = EdgeInsets.symmetric(
    horizontal: _baseUnit * 2,
    vertical: _baseUnit,
  ); // 16, 8
  static const EdgeInsets screenPadding = EdgeInsets.all(_baseUnit * 2); // 16
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(
    vertical: _baseUnit * 3,
  ); // 24

  // Margin
  static const EdgeInsets cardMargin = EdgeInsets.all(_baseUnit); // 8
  static const EdgeInsets contentMargin = EdgeInsets.symmetric(
    horizontal: _baseUnit * 2,
  ); // 16
  static const EdgeInsets sectionMargin = EdgeInsets.only(
    bottom: _baseUnit * 4,
  ); // 32

  // Specific spacing
  static const EdgeInsets snackbarMargin = EdgeInsets.all(_baseUnit * 2);
  static const double iconTextSpacing = _baseUnit; // 8
  static const double itemSpacing = _baseUnit * 1.5; // 12
  static const double sectionSpacing = _baseUnit * 3; // 24

  // Button padding by size
  static EdgeInsets getButtonPadding(TDButtonSize size) {
    switch (size) {
      case TDButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: _baseUnit * 1.5,
          vertical: _baseUnit,
        );
      case TDButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: _baseUnit * 2,
          vertical: _baseUnit * 1.5,
        );
      case TDButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: _baseUnit * 3,
          vertical: _baseUnit * 2,
        );
    }
  }
}
```

---

## 🔒 Security Rules

### 1. Data Validation
```dart
✅ ĐÚNG:
class TaskValidator {
  static String? validateTitle(String? title) {
    if (title == null || title.isEmpty) {
      return 'Title is required';
    }
    if (title.length < 3) {
      return 'Title must be at least 3 characters';
    }
    return null;
  }
}

❌ SAI:
// No validation
```

### 2. Input Sanitization
```dart
✅ ĐÚNG:
String sanitizeInput(String input) {
  return input.trim().replaceAll(RegExp(r'[<>"\']'), '');
}

❌ SAI:
// Direct use of user input without sanitization
```

### 3. Error Messages
```dart
✅ ĐÚNG:
// Generic error messages for security
'An error occurred. Please try again.'

❌ SAI:
// Detailed error messages that might expose system info
'Database connection failed at 192.168.1.1:5432'
```

---

## 📊 Performance Rules

### 1. Memory Management
```dart
✅ ĐÚNG:
@override
void onClose() {
  _subscription?.cancel();
  super.onClose();
}

❌ SAI:
// Not disposing resources
```

### 2. Lazy Loading
```dart
✅ ĐÚNG:
Get.lazyPut<TaskController>(() => TaskController());

❌ SAI:
Get.put(TaskController()); // Eager loading
```

### 3. Image Optimization
```dart
✅ ĐÚNG:
CachedNetworkImage(
  imageUrl: task.imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)

❌ SAI:
Image.network(task.imageUrl) // No caching or error handling
```

---

## 🚀 Deployment Rules

### 1. Environment Configuration
```dart
✅ ĐÚNG:
class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.example.com',
  );
  
  static const bool isDebug = bool.fromEnvironment('DEBUG', defaultValue: false);
}

❌ SAI:
// Hardcoded URLs
const String baseUrl = 'https://api.example.com';
```

### 2. Build Configuration
```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
  
  # Environment-specific configurations
  flavors:
    development:
      applicationId: com.company.todolist.dev
    staging:
      applicationId: com.company.todolist.staging
    production:
      applicationId: com.company.todolist
```

### 3. Version Management
```daml
# pubspec.yaml
version: 1.0.0+1
# Format: version+build_number
# version: major.minor.patch
# build_number: incremental number
```

---

## 📋 Code Review Checklist

### Before Submitting PR:
- [ ] Code follows naming conventions
- [ ] Controllers extend GetxController properly
- [ ] Observable variables are private with public getters
- [ ] Error handling is implemented
- [ ] Tests are written and passing
- [ ] No hardcoded values
- [ ] Proper dependency injection
- [ ] Memory leaks prevented (onClose implemented)
- [ ] UI is responsive
- [ ] Security validations in place
- [ ] **Widget size limits respected** (max 100 lines per widget, 400 lines per file)
- [ ] **Custom widgets use TD prefix** (TDCard, TDButton, TDText, etc.)
- [ ] **SnackbarService used** for all notifications (no direct Get.snackbar)
- [ ] **NavigationService used** for all navigation (no direct Get.to/Get.back)
- [ ] **AppStrings used** for all text (no hardcoded strings)
- [ ] **AppSpacing used** for all spacing (no hardcoded EdgeInsets)

### Architecture Checklist:
- [ ] Clean Architecture layers respected
- [ ] Feature-based structure followed
- [ ] No direct imports between features
- [ ] Shared code in shared/ folder
- [ ] Proper separation of concerns

### GetX Checklist:
- [ ] Controllers properly registered in bindings
- [ ] Reactive UI with Obx()
- [ ] Proper navigation with GetX
- [ ] Dependency injection with Get.find()
- [ ] Lifecycle methods implemented

---

## 🔄 Refactoring Guidelines

### 1. Safe Refactoring Steps
1. **Write tests first** for existing functionality
2. **Extract interfaces** for better testability
3. **Move code gradually** to new structure
4. **Update dependencies** one by one
5. **Run tests** after each change
6. **Update documentation**

### 2. Breaking Changes
- **Version bump** required for breaking changes
- **Migration guide** must be provided
- **Backward compatibility** maintained when possible
- **Team notification** before major refactoring

### 3. Code Quality Metrics
- **Test coverage**: Minimum 80%
- **Code complexity**: Maximum 10 per method
- **File size**: Maximum 400 lines
- **Method size**: Maximum 50 lines
- **Class size**: Maximum 200 lines
- **Widget size**: Maximum 100 lines per widget

---

## 📚 Documentation Rules

### 1. Code Documentation
```dart
/// Controller for managing task-related operations
/// 
/// This controller handles:
/// - Creating new tasks
/// - Loading existing tasks
/// - Updating task status
/// - Deleting tasks
class TaskController extends GetxController {
  /// Creates a new task with the given parameters
  /// 
  /// [task] The task to be created
  /// 
  /// Throws [TaskCreationException] if task creation fails
  Future<void> createTask(Task task) async {
    // Implementation
  }
}
```

### 2. API Documentation
- **README.md** for each feature
- **API documentation** for public methods
- **Architecture diagrams** for complex features
- **Migration guides** for breaking changes

### 3. Commit Messages
```
✅ ĐÚNG:
feat: add task creation functionality
fix: resolve memory leak in task controller
docs: update API documentation
refactor: extract task validation logic

❌ SAI:
update code
fix bug
changes
```

---

## 🎯 Best Practices Summary

### Do's ✅
- Follow Clean Architecture strictly
- Use GetX patterns consistently
- Write comprehensive tests
- Handle errors gracefully
- Use proper naming conventions
- Implement proper lifecycle management
- Keep controllers focused and small
- Use dependency injection properly
- Document public APIs
- Follow responsive design principles
- **Break large widgets into smaller components**
- **Use TD prefix for all custom widgets**
- **Use SnackbarService for all notifications**
- **Use NavigationService for all navigation**
- **Use AppStrings for all text content**
- **Use AppSpacing for consistent spacing**
- **Keep files under 400 lines**
- **Keep widgets under 100 lines**

### Don'ts ❌
- Mix different state management approaches
- Skip error handling
- Use hardcoded values
- Create large, monolithic controllers
- Ignore memory management
- Skip tests for critical functionality
- Use unclear naming
- Create tight coupling between features
- Ignore performance implications
- Skip code reviews
- **Create widgets larger than 100 lines**
- **Create files larger than 400 lines**
- **Use Material widgets directly (Card, Button, Text)**
- **Use Get.snackbar() or Get.to/Get.back directly**
- **Hardcode strings in UI**
- **Hardcode spacing values (EdgeInsets.all(16))**
- **Create monolithic UI components**

---

**📝 Lưu ý**: File này phải được cập nhật thường xuyên khi có thay đổi trong architecture hoặc best practices. Tất cả team members phải tuân thủ các quy tắc này để đảm bảo tính nhất quán và chất lượng code.
