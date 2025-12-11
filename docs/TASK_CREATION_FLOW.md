# 📋 Luồng Tạo Task Chi Tiết

## 🎯 Tổng Quan

Tài liệu này mô tả chi tiết luồng tạo task trong ứng dụng, bắt đầu từ hàm `_openCreateTaskPage` trong `project_detail_page.dart`.

---

## 🔄 Luồng Tạo Task

### 1️⃣ **Điểm Khởi Đầu: `_openCreateTaskPage`**

**File**: `lib/app/pages/projects/project_detail_page.dart` (dòng 99-104)

```dart
Future<void> _openCreateTaskPage(Project project) async {
  await NavigationService().toNamed<void>(
    AppRouter.taskCreate,
    arguments: project,
  );
}
```

**Chức năng**:
- Nhận `Project` object từ màn hình chi tiết project
- Điều hướng đến màn hình tạo task (`TaskCreatePage`)
- Truyền project qua `arguments` để tự động chọn project khi tạo task

---

### 2️⃣ **Màn Hình Tạo Task: `TaskCreatePage`**

**File**: `lib/app/pages/tasks/task_create_page.dart`

**Chức năng**:
- Hiển thị form tạo task với layout responsive (maxWidth: 600px)
- Nhận project từ `Get.arguments` (nếu có)
- Sử dụng widget `CreateTaskForm` để hiển thị form
- Tự động quay lại màn hình trước khi tạo task thành công

---

### 3️⃣ **Form Tạo Task: `CreateTaskForm`**

**File**: `lib/features/tasks/presentation/widgets/create_task_form.dart`

#### 📝 **Thông Tin Cần Thu Thập**

| Thông Tin | Bắt Buộc | Nguồn Dữ Liệu | Mô Tả |
|-----------|----------|---------------|-------|
| **Title** | ✅ Bắt buộc | Người dùng nhập | Tên task (tối thiểu 3 ký tự) |
| **Description** | ❌ Tùy chọn | Người dùng nhập | Mô tả chi tiết task |
| **Assignee** | ❌ Tùy chọn | `TaskController.workspaceMembers` | Người được giao task |
| **Project** | ❌ Tùy chọn | `TaskController.workspaceProjects` hoặc `initialProject` | Project liên quan |
| **Priority** | ✅ Bắt buộc | Enum `TaskPriority` (low, medium, high, urgent) | Độ ưu tiên (mặc định: medium) |
| **Type** | ✅ Bắt buộc | Enum `TaskType` (daily, weekly, monthly, project) | Loại task (mặc định: daily) |
| **Deadline** | ❌ Tùy chọn | DatePicker | Ngày hết hạn |

#### 🔍 **Nguồn Lấy Thông Tin**

1. **Workspace Members** (Danh sách người có thể gán task):
   - **Nguồn**: `TaskController.workspaceMembers`
   - **Lấy từ**: `WorkspaceContextService.workspaceMembers`
   - **Lọc**: Nếu có project được chọn, chỉ hiển thị members thuộc project đó
   - **Code**: 
     ```dart
     final List<User> availableUsers = _selectedProject != null
         ? controller.workspaceMembers
             .where((user) => _selectedProject!.memberIds.contains(user.id))
             .toList()
         : controller.workspaceMembers;
     ```

2. **Workspace Projects** (Danh sách project):
   - **Nguồn**: `TaskController.workspaceProjects`
   - **Lấy từ**: `WorkspaceContextService.workspaceProjects`
   - **Đặc biệt**: Nếu mở từ `ProjectDetailPage`, project được khóa (không thể thay đổi)

3. **Current User** (Người tạo task):
   - **Nguồn**: `AuthController.currentUser`
   - **Lấy từ**: Firebase Authentication
   - **Sử dụng**: Làm `assigner` (người giao task)

4. **Workspace ID**:
   - **Nguồn**: `WorkspaceContextService.currentWorkspaceId`
   - **Lấy từ**: `StorageService.getWorkspaceId()`
   - **Mục đích**: Đảm bảo task thuộc đúng workspace

#### ✅ **Validation**

- **Title**: Bắt buộc, tối thiểu 3 ký tự
- **Assignee**: Phải là member của workspace (và project nếu có)
- **Project**: Phải thuộc workspace hiện tại
- **Deadline**: Phải là ngày trong tương lai (tối đa 365 ngày)

---

### 4️⃣ **Xử Lý Tạo Task: `TaskController.createTask`**

**File**: `lib/features/tasks/presentation/controllers/task_controller.dart` (dòng 85-190)

#### 🔐 **Kiểm Tra Quyền (Permission Checks)**

1. **Workspace Validation**:
   ```dart
   if (!_workspaceContext.hasValidWorkspace) {
     throw WorkspaceMismatchException('No valid workspace selected');
   }
   ```

2. **Create Task Permission**:
   ```dart
   final canCreate = await _permissionService.canCreateTask(
     currentUserId,
     _workspaceContext.currentWorkspaceId,
   );
   ```

3. **Assignee Validation**:
   - Assignee phải là member của workspace
   - Nếu có project, assignee phải là member của project

4. **Project Validation**:
   - Project phải thuộc workspace hiện tại

#### 🏗️ **Tạo Task Entity**

```dart
final task = TaskEntity(
  id: _generateTaskId(),                    // ID tự động: 'task_{timestamp}_{count}'
  title: title,                             // Từ form
  description: description,                 // Từ form (optional)
  workspaceId: _workspaceContext.currentWorkspaceId,  // Từ WorkspaceContextService
  taskType: taskType.value,                 // Từ enum TaskType
  priority: priority.value,                 // Từ enum TaskPriority
  status: TaskStatus.pending.value,          // Mặc định: pending
  assignee: assigneeId,                    // Từ form (optional)
  assigner: currentUserId,                  // Từ AuthController
  projectId: projectId,                     // Từ form (optional)
  hasDeadline: deadline != null,            // Từ form
  deadline: deadline,                       // Từ form (optional)
  recurring: const RecurringConfig(isRecurring: false),  // Mặc định: không recurring
  createdAt: DateTime.now(),                // Thời gian hiện tại
);
```

#### 💾 **Lưu Task**

**Hiện tại (Temporary)**:
```dart
_tasks.add(task);  // Thêm vào local list (in-memory)
```

**TODO - Sẽ được implement**:
- Lưu vào Firebase Realtime Database
- Sử dụng `OfflineQueueService` nếu offline
- Sync khi có kết nối

---

### 5️⃣ **Lưu Trữ Task: Endpoints & Services**

#### 🔥 **Firebase Realtime Database**

**Endpoint Path**:
```
/workspaces/{workspaceId}/tasks/{taskId}
```

**Cấu trúc dữ liệu**:
```json
{
  "id": "task_1234567890_0",
  "title": "Task title",
  "description": "Task description",
  "status": "pending",
  "priority": "medium",
  "taskType": "daily",
  "projectId": "project_123",
  "assignee": "user_456",
  "assigner": "user_789",
  "workspaceId": "workspace_abc",
  "createdAt": 1234567890000,
  "updatedAt": null,
  "deadline": 1234567890000,
  "recurring": {
    "isRecurring": false,
    "frequency": null,
    "interval": null,
    "endDate": null
  }
}
```

**Service**: `FirebaseDatabaseService.createTask()`
- **File**: `lib/core/services/firebase_database_service.dart` (dòng 1023-1049)
- **Method**: `createTaskFromEntity(TaskEntity task)`
- **Chức năng**: Tạo task mới trong Firebase với auto-generated ID

#### 📦 **Offline Queue Service**

**Service**: `OfflineQueueService.createTask()`
- **File**: `lib/core/services/offline_queue_service.dart` (dòng 150-160)
- **Chức năng**: 
  - Nếu online: Lưu trực tiếp vào Firebase
  - Nếu offline: Thêm vào queue, sync sau khi có kết nối

**Queue Structure**:
```dart
{
  'op': 'create_task',
  'workspaceId': workspaceId,
  'payload': task.toMap(),
}
```

---

### 6️⃣ **Các Màn Hình Sử Dụng Task**

#### 📱 **1. Project Detail Page** (`project_detail_page.dart`)

**Mục đích**: 
- Hiển thị danh sách tasks của project
- Cho phép tạo task mới từ project
- Hiển thị tiến độ project dựa trên tasks

**Sử dụng**:
```dart
final tasks = _taskController.getTasksByProject(project.id);
```

**Widget liên quan**: `ProjectDetailOverviewTab`

---

#### 📱 **2. Task List Page** (`task_list_page.dart`)

**Mục đích**: 
- Hiển thị tất cả tasks của workspace
- Filter theo type, status, priority, project
- Search tasks
- Edit/Delete tasks

**Sử dụng**:
```dart
Stream<List<TaskEntity>> _watchTasks() {
  return FirebaseDatabaseService.instance.watchTasks(
    workspaceId: workspaceId,
    type: type,
    status: status,
    priority: priority,
    projectId: _selectedProjectId,
  );
}
```

**Features**:
- Real-time updates (Stream)
- Filtering & Search
- Task cards với actions (edit, delete, status change)

---

#### 📱 **3. Dashboard Page** (`dashboard_page.dart`)

**Mục đích**: 
- Hiển thị tasks gần đây
- Quick actions để tạo task
- Overview statistics

**Sử dụng**:
```dart
// Widget: TDRecentTasksSection
controller.recentTasks  // Từ DashboardController
```

**Widget liên quan**: 
- `TDRecentTasksSection`: Hiển thị recent tasks
- `TDQuickActionsSection`: Quick action buttons

---

#### 📱 **4. Task Edit Page** (`task_edit_page.dart`)

**Mục đích**: 
- Chỉnh sửa task đã tồn tại
- Cập nhật thông tin task
- Xóa task

**Sử dụng**:
- Nhận `TaskEntity` qua `Get.arguments`
- Load từ Firebase hoặc local state

---

#### 📱 **5. Task Statistics Page** (`task_statistics_page.dart`)

**Mục đích**: 
- Thống kê tasks theo các tiêu chí
- Charts và graphs
- Reports

**Sử dụng**:
- Aggregate data từ tasks
- Filter và group tasks

---

#### 📱 **6. Project Progress Card** (`project_progress_card.dart`)

**Mục đích**: 
- Hiển thị tiến độ project dựa trên tasks
- Tính toán % hoàn thành

**Sử dụng**:
```dart
final progressFuture = CalculateProjectProgress().call(
  workspaceId: workspaceId,
  projectId: projectId,
);
```

---

## 🔄 **Luồng Dữ Liệu Hoàn Chỉnh**

```
1. User clicks "Create Task" button
   ↓
2. _openCreateTaskPage(project) → Navigate to TaskCreatePage
   ↓
3. TaskCreatePage → CreateTaskForm
   ↓
4. User fills form:
   - Title (required)
   - Description (optional)
   - Assignee (from workspaceMembers)
   - Project (from workspaceProjects or initialProject)
   - Priority (enum)
   - Type (enum)
   - Deadline (optional)
   ↓
5. User clicks "Create Task" button
   ↓
6. CreateTaskForm._onCreateTask()
   ↓
7. TaskController.createTask()
   ↓
8. Validation:
   - Workspace context ✓
   - Permission check ✓
   - Assignee validation ✓
   - Project validation ✓
   ↓
9. Create TaskEntity object
   ↓
10. Save to:
    - Local state (_tasks.add(task)) [Current]
    - Firebase Realtime Database [TODO]
    - Offline Queue (if offline) [TODO]
   ↓
11. Show success snackbar
   ↓
12. Callback: onTaskCreated() → Navigate back
   ↓
13. Task appears in:
    - Project Detail Page
    - Task List Page
    - Dashboard (if recent)
    - Project Progress Card
```

---

## 📊 **Cấu Trúc TaskEntity**

**File**: `lib/features/tasks/domain/entities/task.dart`

```dart
class TaskEntity {
  final String id;                    // Auto-generated
  final String title;                 // Required, min 3 chars
  final String? description;          // Optional
  final String workspaceId;           // Required, from WorkspaceContextService
  final String taskType;               // daily | weekly | monthly | project
  final String priority;              // low | medium | high | urgent
  final String status;                // pending | in_progress | completed | cancelled
  final String? assignee;              // Optional, userId
  final String assigner;               // Required, currentUserId
  final String? projectId;            // Optional
  final bool hasDeadline;              // true if deadline != null
  final DateTime? deadline;            // Optional
  final RecurringConfig recurring;    // Recurring config
  final DateTime createdAt;           // Auto-set
  final DateTime? updatedAt;          // Set on update
  final DateTime? deletedAt;           // Soft delete
}
```

---

## 🔐 **Security & Permissions**

### Permission Checks:
1. **canCreateTask**: User có quyền tạo task trong workspace
2. **canAssignTask**: User có quyền gán task cho người khác
3. **canUpdateTaskStatus**: User có quyền cập nhật status
4. **canDeleteTask**: User có quyền xóa task

### Workspace Validation:
- Task phải thuộc workspace hiện tại
- Assignee phải là member của workspace
- Project phải thuộc workspace hiện tại
- Nếu task có project, assignee phải là member của project

---

## 🚀 **Tính Năng Tương Lai (TODO)**

1. **Firebase Integration**: 
   - Lưu task vào Firebase Realtime Database
   - Real-time sync giữa các devices

2. **Offline Support**:
   - Queue tasks khi offline
   - Auto-sync khi có kết nối

3. **Recurring Tasks**:
   - Tự động tạo task instances
   - Quản lý recurring config

4. **Notifications**:
   - Thông báo khi task được gán
   - Thông báo khi deadline sắp đến

5. **Task Dependencies**:
   - Task phụ thuộc vào task khác
   - Blocking tasks

---

## 📝 **Tóm Tắt**

### Thông tin cần để tạo task:
1. ✅ **Title** (bắt buộc) - Người dùng nhập
2. ❌ **Description** (tùy chọn) - Người dùng nhập
3. ❌ **Assignee** (tùy chọn) - Từ `workspaceMembers`
4. ❌ **Project** (tùy chọn) - Từ `workspaceProjects` hoặc `initialProject`
5. ✅ **Priority** (bắt buộc) - Enum `TaskPriority`
6. ✅ **Type** (bắt buộc) - Enum `TaskType`
7. ❌ **Deadline** (tùy chọn) - DatePicker

### Nguồn lấy thông tin:
- **Workspace Members**: `WorkspaceContextService.workspaceMembers`
- **Workspace Projects**: `WorkspaceContextService.workspaceProjects`
- **Current User**: `AuthController.currentUser`
- **Workspace ID**: `WorkspaceContextService.currentWorkspaceId`

### Endpoint lưu trữ:
- **Firebase Path**: `/workspaces/{workspaceId}/tasks/{taskId}`
- **Service**: `FirebaseDatabaseService.createTask()`
- **Offline Queue**: `OfflineQueueService.createTask()`

### Màn hình sử dụng:
1. **Project Detail Page** - Hiển thị tasks của project
2. **Task List Page** - Danh sách tất cả tasks
3. **Dashboard** - Recent tasks & quick actions
4. **Task Edit Page** - Chỉnh sửa task
5. **Task Statistics** - Thống kê tasks
6. **Project Progress Card** - Tính toán tiến độ

---

**Tài liệu này cung cấp cái nhìn toàn diện về luồng tạo task trong ứng dụng.**
