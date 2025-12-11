# 🔧 WorkspaceContextService Refactoring Plan

## 📋 Vấn Đề Hiện Tại

### ❌ **Vấn đề chính:**

1. **Multiple Instances & Data Inconsistency**:
   - `WorkspaceContextService` được khởi tạo bằng `Get.lazyPut` với `fenix: true` trong `ProjectBindings`
   - Service có thể bị dispose và tạo lại nhiều lần
   - Mỗi instance mới sẽ có data rỗng, dẫn đến inconsistency

2. **Không được khởi tạo trong App Initialization**:
   - Service không được đăng ký trong `AppInitializer.initialize()`
   - Chỉ được khởi tạo khi `ProjectBindings` được gọi
   - Nếu các controller khác sử dụng trước khi binding được gọi → lỗi

3. **Logic Load Data chưa được implement**:
   - `_loadWorkspaceMembers()` và `_loadWorkspaceProjects()` chỉ là placeholder (TODO)
   - Data luôn rỗng, không load từ Firebase

4. **Không sync với WorkspaceController**:
   - Khi user switch workspace qua `WorkspaceController`, `WorkspaceContextService` không được cập nhật
   - Data không đồng bộ giữa 2 services

---

## ✅ Giải Pháp Đề Xuất

### 1. **Singleton Pattern với Permanent Instance**

**Mục tiêu**: Đảm bảo chỉ có 1 instance duy nhất trong suốt lifecycle của app

**Implementation**:
```dart
// Trong AppInitializer.initialize()
Get.put<WorkspaceContextService>(
  WorkspaceContextService(),
  permanent: true,  // Không bao giờ bị dispose
);
```

### 2. **Implement Actual Data Loading**

**Mục tiêu**: Load thực sự data từ Firebase

**Implementation**:
- Load workspace members từ Firebase
- Load workspace projects từ Firebase
- Cache data để tránh load lại nhiều lần

### 3. **Sync với WorkspaceController**

**Mục tiêu**: Tự động cập nhật khi workspace thay đổi

**Implementation**:
- Listen to `WorkspaceController.currentWorkspace` changes
- Tự động gọi `setCurrentWorkspace()` khi workspace thay đổi
- Đảm bảo data luôn sync

### 4. **Remove từ ProjectBindings**

**Mục tiêu**: Tránh khởi tạo nhiều lần

**Implementation**:
- Xóa `Get.lazyPut<WorkspaceContextService>` từ `ProjectBindings`
- Chỉ sử dụng `Get.find<WorkspaceContextService>()` trong controllers

---

## 🏗️ Implementation Plan

### Step 1: Update AppInitializer

**File**: `lib/app/app.dart`

```dart
// Trong AppInitializer.initialize(), thêm sau WorkspaceController:

// Initialize WorkspaceContextService (must be after WorkspaceController)
Get.put<WorkspaceContextService>(
  WorkspaceContextService(),
  permanent: true,
);
```

### Step 2: Implement Data Loading Logic

**File**: `lib/core/services/workspace_context_service.dart`

Cần implement:
- `_loadWorkspaceMembers()` - Load từ Firebase
- `_loadWorkspaceProjects()` - Load từ Firebase
- Cache mechanism để tránh load lại

### Step 3: Add Workspace Sync

**File**: `lib/core/services/workspace_context_service.dart`

Thêm listener để sync với `WorkspaceController`:
```dart
@override
void onInit() {
  super.onInit();
  _syncWithWorkspaceController();
}

void _syncWithWorkspaceController() {
  final workspaceController = Get.find<WorkspaceController>();
  ever(workspaceController.currentWorkspace, (workspace) {
    if (workspace != null && workspace.id != currentWorkspaceId) {
      setCurrentWorkspace(workspace.id);
    }
  });
}
```

### Step 4: Update ProjectBindings

**File**: `lib/app/routes/bindings/project_bindings.dart`

Xóa dòng:
```dart
// XÓA DÒNG NÀY:
Get.lazyPut<WorkspaceContextService>(() => WorkspaceContextService(), fenix: true);
```

Controllers sẽ tự động dùng instance đã được khởi tạo trong AppInitializer.

---

## 📝 Chi Tiết Implementation

### 1. WorkspaceContextService với Data Loading

```dart
class WorkspaceContextService extends GetxService {
  // ... existing code ...

  // Dependencies
  late final FirebaseDatabaseService _databaseService;
  late final StorageService _storageService;

  @override
  void onInit() {
    super.onInit();
    _databaseService = Get.find<FirebaseDatabaseService>();
    _storageService = Get.find<StorageService>();
    _syncWithWorkspaceController();
    _initializeFromStorage();
  }

  /// Initialize from storage if available
  Future<void> _initializeFromStorage() async {
    final workspaceId = _storageService.getWorkspaceId();
    if (workspaceId != null && workspaceId.isNotEmpty) {
      await setCurrentWorkspace(workspaceId);
    }
  }

  /// Sync with WorkspaceController
  void _syncWithWorkspaceController() {
    if (Get.isRegistered<WorkspaceController>()) {
      final workspaceController = Get.find<WorkspaceController>();
      ever(workspaceController.currentWorkspace, (workspace) {
        if (workspace != null && workspace.id != currentWorkspaceId) {
          setCurrentWorkspace(workspace.id);
        }
      });
    }
  }

  /// Load workspace members from Firebase
  Future<void> _loadWorkspaceMembers() async {
    try {
      if (_currentWorkspaceId.value.isEmpty) {
        _workspaceMembers.value = [];
        return;
      }

      // Load workspace members from Firebase
      final members = await _databaseService.listWorkspaceMembers(
        workspaceId: _currentWorkspaceId.value,
      );
      
      _workspaceMembers.value = members;
    } catch (e) {
      _errorMessage.value = 'Failed to load workspace members: $e';
      _workspaceMembers.value = [];
    }
  }

  /// Load workspace projects from Firebase
  Future<void> _loadWorkspaceProjects() async {
    try {
      if (_currentWorkspaceId.value.isEmpty) {
        _workspaceProjects.value = [];
        return;
      }

      // Load workspace projects from Firebase
      final projects = await _databaseService.listProjects(
        workspaceId: _currentWorkspaceId.value,
      );
      
      _workspaceProjects.value = projects;
    } catch (e) {
      _errorMessage.value = 'Failed to load workspace projects: $e';
      _workspaceProjects.value = [];
    }
  }
}
```

### 2. Update AppInitializer

```dart
// Trong AppInitializer.initialize()

// ... existing code ...

// Initialize Workspace Controller
Get.put(WorkspaceController(
  workspaceRepository: Get.find(),
));

// Initialize WorkspaceContextService (must be after WorkspaceController)
Get.put<WorkspaceContextService>(
  WorkspaceContextService(),
  permanent: true,
);
```

### 3. Update ProjectBindings

```dart
class ProjectBindings extends Bindings {
  @override
  void dependencies() {
    // Core services
    Get.lazyPut<PermissionService>(() => PermissionService(), fenix: true);
    // XÓA: Get.lazyPut<WorkspaceContextService>(() => WorkspaceContextService(), fenix: true);
    // Service đã được khởi tạo trong AppInitializer

    // ... rest of the code ...
    
    // Controllers - sử dụng Get.find() thay vì inject
    Get.lazyPut<TaskController>(
      () => TaskController(
        workspaceContext: Get.find<WorkspaceContextService>(), // Tự động lấy instance đã khởi tạo
        permissionService: Get.find<PermissionService>(),
        authController: Get.find<AuthController>(),
      ),
      fenix: true,
    );
    
    // ... rest of the code ...
  }
}
```

---

## 🧪 Testing Strategy

### Unit Tests:
1. Test singleton pattern - chỉ có 1 instance
2. Test data loading từ Firebase
3. Test sync với WorkspaceController
4. Test cache mechanism

### Integration Tests:
1. Test workspace switching → WorkspaceContextService tự động update
2. Test multiple controllers sử dụng cùng 1 instance
3. Test data consistency giữa các controllers

---

## 📊 Benefits

1. ✅ **Single Source of Truth**: Chỉ có 1 instance duy nhất
2. ✅ **Data Consistency**: Tất cả controllers dùng cùng data
3. ✅ **Performance**: Tránh load lại data nhiều lần
4. ✅ **Auto Sync**: Tự động sync khi workspace thay đổi
5. ✅ **Reliability**: Service không bị dispose, data luôn available

---

## 🚨 Breaking Changes

### Controllers cần update:
- Không cần thay đổi gì, vì vẫn dùng `Get.find<WorkspaceContextService>()`
- Chỉ đảm bảo service đã được khởi tạo trước khi sử dụng

### Migration Steps:
1. Implement data loading logic
2. Add sync với WorkspaceController
3. Move initialization to AppInitializer
4. Remove từ ProjectBindings
5. Test thoroughly

---

## 📅 Timeline

1. **Phase 1** (Immediate): Move initialization to AppInitializer
2. **Phase 2** (Short-term): Implement data loading logic
3. **Phase 3** (Short-term): Add sync với WorkspaceController
4. **Phase 4** (Testing): Comprehensive testing
5. **Phase 5** (Cleanup): Remove từ ProjectBindings

---

**Tài liệu này cung cấp roadmap chi tiết để refactor WorkspaceContextService thành singleton pattern với data consistency.**
