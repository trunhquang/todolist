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
✅ ĐÚNG (dùng NavigationService):
await NavigationService.instance.toNamed<void>(AppRoutes.taskDetail, arguments: {'taskId': taskId});
await NavigationService.instance.offAllNamed<void>(AppRoutes.home);
NavigationService.instance.back<Task>(result: updatedTask);

❌ SAI:
Get.toNamed(...);
Get.offAllNamed(...);
Get.back(...);
Navigator.pushNamed(context, '/task-detail');
Navigator.pushAndRemoveUntil(context, ...);
Navigator.pop(context);
```

### Route Arguments
```dart
✅ ĐÚNG:
// Passing arguments (always use map for extensibility)
await NavigationService.instance.toNamed<void>(AppRoutes.taskDetail, arguments: {'taskId': taskId});

// Receiving arguments (qua Get.arguments ở page/Binding)
final args = Get.arguments as Map<String, dynamic>;
final taskId = args['taskId'] as String;

❌ SAI:
await NavigationService.instance.toNamed<void>(AppRoutes.taskDetail, arguments: taskId);
final taskId = Get.arguments as String; // thiếu cấu trúc
```

---

**📁 File liên quan:**
- [Architecture Rules](ARCHITECTURE_RULES.md)
- [Coding Standards](CODING_STANDARDS.md)
- [UI/UX Rules](UI_UX_RULES.md)
