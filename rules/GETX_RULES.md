# 🔧 GetX Specific Rules

## 1. State Management

### Observable Variables
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

### Reactive UI
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

## 2. Dependency Injection

### Controller Registration
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

### Service Registration
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

## 3. Navigation

### Route Navigation
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

### Route Arguments
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

**📁 File liên quan:**
- [Architecture Rules](ARCHITECTURE_RULES.md)
- [Coding Standards](CODING_STANDARDS.md)
- [UI/UX Rules](UI_UX_RULES.md)
