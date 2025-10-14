# 🏗️ Architecture Rules

## 1. Clean Architecture Pattern
```
✅ ĐÚNG: features/auth/presentation/controllers/auth_controller.dart
❌ SAI: features/auth/auth_controller.dart
```

**Quy tắc:**
- Mỗi feature phải tuân theo Clean Architecture: `data/domain/presentation`
- Không được bỏ qua layer nào
- Dependencies chỉ được point inward (presentation → domain → data)

## 2. Feature-Based Structure
```
✅ ĐÚNG: features/task/presentation/controllers/task_controller.dart
❌ SAI: controllers/task_controller.dart
```

**Quy tắc:**
- Mỗi feature phải độc lập và self-contained
- Không được import trực tiếp giữa các features
- Shared code phải đặt trong `shared/` folder

## 3. GetX Architecture
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

**📁 File liên quan:**
- [Development Workflow](DEVELOPMENT_WORKFLOW.md)
- [GetX Specific Rules](GETX_RULES.md)
- [File Organization Rules](FILE_ORGANIZATION_RULES.md)
