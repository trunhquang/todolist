# User Management Page - Logic & Data Flow Documentation

## 📋 Tổng Quan

Tài liệu này mô tả chi tiết logic, cách load dữ liệu, các action và cơ chế reload của `UserManagementPage` để phục vụ việc maintain và phát triển.

**File chính**: `lib/app/pages/users/user_management_page.dart`  
**Controller**: `lib/app/pages/users/controllers/user_management_controller.dart`

---

## 🏗️ Kiến Trúc

### Component Structure

```
UserManagementPage (StatelessWidget)
├── UserManagementController (GetX Controller)
│   └── WorkspaceController (Dependency Injection)
│       └── WorkspaceRepository
│           └── Firebase Database Service
├── MemberCard (Widget)
└── InvitationCard (Widget)
```

### Data Flow

```
Page Init
  ↓
Controller.onInit()
  ↓
_initializePage()
  ├── _checkPermissions() → WorkspaceController.hasPermission('manage_users')
  └── _loadWorkspaceMembers()
      ├── WorkspaceController.loadWorkspaceMembers()
      └── WorkspaceController.loadInvitations()
  ↓
Reactive UI Update (Obx)
  ├── Combine members + invitations
  ├── Filter by search query
  └── Render ListView
```

---

## 📥 Cơ Chế Load Dữ Liệu

### 1. Initialization Flow

**Khi page được mở:**

```dart
// Controller.onInit() được gọi tự động
@override
void onInit() {
  super.onInit();
  _initializePage(); // Async operation
}
```

**Sequence:**

1. **Set loading state**: `_isLoading.value = true`
2. **Check permissions**: 
   - Gọi `_workspaceController.hasPermission('manage_users')`
   - Nếu không có quyền → hiển thị error → navigate back
   - Set `_canManageUsers.value = true/false`
3. **Load data**:
   - `_loadWorkspaceMembers()` → gọi 2 methods:
     - `_workspaceController.loadWorkspaceMembers()`
     - `_workspaceController.loadInvitations()`
4. **Set loading state**: `_isLoading.value = false`

### 2. Data Sources

**Controller lấy dữ liệu từ WorkspaceController:**

```dart
// Direct getters - reactive data
List<WorkspaceMember> get workspaceMembers => 
    _workspaceController.workspaceMembers;

List<Invitation> get invitations => 
    _workspaceController.invitations;

// Filtered invitations - excludes users who are already members
List<Invitation> get filteredInvitations {
  final members = workspaceMembers;
  final allInvitations = invitations;
  
  // Get set of member emails for quick lookup
  final memberEmails = members
      .where((member) => member.email != null && member.email!.isNotEmpty)
      .map((member) => member.email!.toLowerCase())
      .toSet();
  
  // Filter out invitations for users who are already members
  return allInvitations.where((invitation) {
    final invitationEmail = invitation.email.toLowerCase();
    return !memberEmails.contains(invitationEmail);
  }).toList();
}
```

**WorkspaceController load từ Repository:**

- `loadWorkspaceMembers()` → `WorkspaceRepository.getWorkspaceMembers(workspaceId)`
- `loadInvitations()` → `WorkspaceRepository.listInvitations(workspaceId)`

**Filtering Logic:**

- **Rule**: Nếu user đã là member trong `workspaceMembers` (match theo email), thì invitation của user đó sẽ không được hiển thị trong danh sách
- **Lý do**: User đã đồng ý gia nhập và có trong danh sách members rồi, không cần hiển thị invitation nữa
- **Implementation**: Sử dụng `filteredInvitations` getter thay vì `invitations` để tự động filter

### 3. Data Processing trong UI

**Trong build method:**

```dart
// 1. Lấy raw data từ controller
final members = controller.workspaceMembers;
final invitations = controller.filteredInvitations; // Đã được filter để loại bỏ users đã là members

// 2. Combine thành 1 list
final allUsers = _combineMembersAndInvitations(members, invitations);

// 3. Filter theo search query
final filteredUsers = _filterUsers(allUsers, controller.searchQuery);

// 4. Render ListView
ListView.builder(
  itemCount: filteredUsers.length,
  itemBuilder: (context, index) {
    final user = filteredUsers[index];
    return _buildUserCard(context, user, controller);
  },
)
```

**Combine logic:**

```dart
List<dynamic> _combineMembersAndInvitations(
    List<WorkspaceMember> members, 
    List<Invitation> invitations) {
  final List<dynamic> allUsers = [...members];
  allUsers.addAll(invitations);
  return allUsers;
}
```

**Invitation Filtering Rule:**

- **Mục đích**: Tránh hiển thị duplicate - nếu user đã là member thì không hiển thị invitation của user đó
- **Logic**: So sánh `invitation.email` (lowercase) với `member.email` (lowercase) của tất cả members
- **Kết quả**: Chỉ hiển thị invitations cho users chưa có trong danh sách members
- **Performance**: Sử dụng `Set` để lookup O(1) thay vì O(n) với list

**Filter logic (Search):**

- Search trong: `displayName`, `email`, `userId`, `role` (cho Members)
- Search trong: `email`, `role`, `name` (cho Invitations)
- Case-insensitive matching

---

## 🔄 Cơ Chế Reload Data

### 1. Manual Refresh

**Method `refreshData()`:**

```dart
Future<void> refreshData() async {
  _isLoading.value = true;
  await _loadWorkspaceMembers(); // Reload từ WorkspaceController
  _isLoading.value = false;
}
```

**Được gọi sau các actions:**

- ✅ Sau `inviteUserToWorkspace()` → refresh để hiển thị invitation mới
- ✅ Sau `revokeInvitation()` → refresh để cập nhật status
- ✅ Sau `updateUserRole()` → refresh để hiển thị role mới
- ✅ Sau `removeUserFromWorkspace()` → refresh để xóa user khỏi list

### 2. Reactive Updates

**UI tự động update khi:**

- `controller.isLoading` thay đổi → hiển thị/ẩn loading indicator
- `controller.workspaceMembers` thay đổi (từ WorkspaceController)
- `controller.invitations` thay đổi (từ WorkspaceController)
- `controller.searchQuery` thay đổi → filter lại list

**Sử dụng `Obx()` để wrap reactive widgets:**

```dart
Obx(() {
  if (controller.isLoading) {
    return CircularProgressIndicator();
  }
  // ... render data
})
```

---

## 🎯 Các Actions & Handlers

### 1. Invite User Action

**Flow:**

```
User clicks "Invite User" button
  ↓
_showInviteUserDialog()
  ↓
User fills form (name, email)
  ↓
_handleSendInvitation()
  ├── Validate form
  ├── controller.inviteUserToWorkspace()
  │   └── WorkspaceController.inviteUserToWorkspace()
  ├── Close dialog
  ├── Clear form fields
  ├── refreshData() → Reload list
  └── Show success snackbar
```

**Validation:**

- Name: Required, không được empty
- Email: Required, phải là valid email format (dùng `GetUtils.isEmail()`)

**Error handling:**

- Catch exception → Show error snackbar với message chi tiết

### 2. Edit Role Action

**Flow:**

```
User clicks "Edit Role" on MemberCard
  ↓
_handleMemberAction('edit_role')
  ├── Check if Account Holder → Block if true
  └── _showEditRoleDialog()
      ↓
User selects new role (Admin/Member)
  ↓
_handleUpdateUserRole()
  ├── controller.updateUserRole(userId, newRole)
  │   └── WorkspaceController.updateUserRole()
  ├── Close dialog
  ├── refreshData() → Reload list
  └── Show success snackbar
```

**Restrictions:**

- ❌ Không cho phép edit role của Account Holder
- ✅ Chỉ có thể chọn: "Admin" hoặc "Member"
- ✅ Role hiện tại được pre-select trong dropdown

**Permission check:**

- Account Holder check được thực hiện trong `_handleMemberAction()`:
  ```dart
  if (member.isAccountHolder) {
    SnackbarService().showInfo(...);
    return; // Block action
  }
  ```

### 3. Remove User Action

**Flow:**

```
User clicks "Remove User" on MemberCard
  ↓
_handleMemberAction('remove')
  ├── Check if Account Holder → Block if true
  └── _showRemoveUserDialog()
      ↓
User confirms removal
  ↓
controller.removeUserFromWorkspace(userId)
  ├── WorkspaceController.removeUserFromWorkspace()
  ├── refreshData() → Reload list
  └── Show success snackbar
```

**Confirmation dialog:**

- Hiển thị confirmation với user name
- User phải click "Remove" (màu đỏ) để confirm
- Cancel → không làm gì

**Restrictions:**

- ❌ Không cho phép remove Account Holder
- ✅ Chỉ remove được nếu có permission `manage_users`

### 4. Revoke Invitation Action

**Flow:**

```
User clicks "Revoke Invitation" on InvitationCard
  ↓
_handleInvitationAction('revoke')
  ├── controller.revokeInvitation(invitation.id)
  │   └── WorkspaceController.revokeInvitation()
  └── refreshData() → Reload list
```

**Visibility:**

- Chỉ hiển thị action menu nếu `invitation.isWaiting == true`
- Nếu `isRevoked` hoặc `isAccepted` → không hiển thị menu

---

## 🔍 Search Functionality

### Implementation

**Search bar:**

```dart
TDTextField(
  controller: controller.searchController,
  hint: AppStrings.I.searchUsers,
  prefixIcon: Icons.search,
  onChanged: (value) => controller.updateSearchQuery(value),
)
```

**Controller update:**

```dart
Future<void> updateSearchQuery(String query) async {
  _searchQuery.value = query; // Reactive update
}
```

**Filter logic:**

```dart
List<dynamic> _filterUsers(List<dynamic> users, String searchQuery) {
  if (searchQuery.isEmpty) return users;
  
  final query = searchQuery.toLowerCase();
  return users.where((user) {
    if (user is WorkspaceMember) {
      // Search in: displayName, email, userId, role.displayName
      return displayName.contains(query) ||
          email.contains(query) ||
          userId.contains(query) ||
          roleName.contains(query);
    } else if (user is Invitation) {
      // Search in: email, role, name
      return email.contains(query) ||
          role.contains(query) ||
          name.contains(query);
    }
    return false;
  }).toList();
}
```

**Real-time filtering:**

- Mỗi khi user type → `updateSearchQuery()` được gọi
- `_searchQuery` là reactive → UI tự động re-render với filtered list

---

## 🎨 UI Components

### 1. MemberCard

**Hiển thị:**

- Avatar (chữ cái đầu của displayName)
- Display name
- Email (nếu có)
- Role chip (TDRoleChip)

**Actions:**

- Edit Role (disabled nếu Account Holder)
- Remove User (disabled nếu Account Holder)

**Location**: `lib/app/pages/users/widgets/member_card.dart`

### 2. InvitationCard

**Hiển thị:**

- Avatar (chữ cái đầu của email)
- Name hoặc email
- Email (nếu có name)
- "Invited [date]" text
- Role chip
- Status chip (Waiting/Revoked/Accepted/Denied)

**Actions:**

- Revoke Invitation (chỉ hiển thị nếu `isWaiting == true`)

**Location**: `lib/app/pages/users/widgets/invitation_card.dart`

### 3. Empty State

**Hiển thị khi:**

- `filteredUsers.isEmpty == true`

**Content:**

- Icon: `Icons.people_outline`
- Text: "No users found"
- Subtitle: "Invite users to get started"
- Button: "Invite User" (chỉ hiển thị nếu `canManageUsers == true`)

---

## 🔐 Permission Management

### Permission Check Flow

**Initial check:**

```dart
Future<void> _checkPermissions() async {
  final canManage = await _workspaceController.hasPermission('manage_users');
  _canManageUsers.value = canManage;
  
  if (!canManage) {
    // Show error & navigate back
    SnackbarService().showError(...);
    NavigationService().back<void>();
  }
}
```

**UI conditional rendering:**

- "Invite User" button trong AppBar → chỉ hiển thị nếu `canManageUsers == true`
- "Invite User" button trong empty state → chỉ hiển thị nếu `canManageUsers == true`
- Action menus trong cards → được control bởi permission checks trong WorkspaceController

---

## 🐛 Error Handling

### 1. Permission Denied

**Khi không có quyền:**

- Show error snackbar
- Navigate back tự động
- Không load data

### 2. Action Errors

**Catch exceptions trong handlers:**

```dart
try {
  await controller.inviteUserToWorkspace();
  // Success handling
} catch (e) {
  SnackbarService().showError(
    title: AppStrings.I.error,
    message: '${AppStrings.failedToSendInvitation}: $e',
  );
}
```

**Tất cả actions đều có try-catch:**

- `_handleSendInvitation()`
- `_handleUpdateUserRole()`
- `_showRemoveUserDialog()` (trong confirmed block)

---

## 📊 State Management

### Reactive Variables

**Controller:**

```dart
final RxBool _canManageUsers = false.obs;
final RxBool _isLoading = false.obs;
final RxString _searchQuery = ''.obs;
```

**Data (from WorkspaceController):**

```dart
// Reactive lists - update automatically when WorkspaceController updates
List<WorkspaceMember> get workspaceMembers => 
    _workspaceController.workspaceMembers; // RxList

List<Invitation> get invitations => 
    _workspaceController.invitations; // RxList
```

### UI Reactivity

**Obx() usage:**

- Wrap toàn bộ body để react với `isLoading`, `workspaceMembers`, `invitations`
- Wrap conditional buttons để react với `canManageUsers`
- Search filter tự động update khi `searchQuery` thay đổi

---

## 🔄 Data Refresh Triggers

### Automatic Refresh

**Sau các actions:**

1. ✅ `inviteUserToWorkspace()` → `refreshData()`
2. ✅ `revokeInvitation()` → `refreshData()`
3. ✅ `updateUserRole()` → `refreshData()`
4. ✅ `removeUserFromWorkspace()` → `refreshData()`

### Manual Refresh

**Có thể thêm pull-to-refresh:**

- Hiện tại chưa có
- Có thể implement với `RefreshIndicator` widget

---

## 📝 Best Practices & Notes

### ✅ Đã Implement Đúng

1. **Separation of concerns**: Controller xử lý logic, Page chỉ render UI
2. **Reactive state**: Sử dụng GetX reactive variables
3. **Error handling**: Tất cả async operations đều có try-catch
4. **Permission checks**: Check trước khi cho phép actions
5. **Form validation**: Validate input trước khi submit
6. **Loading states**: Hiển thị loading indicator khi đang load
7. **Empty states**: Hiển thị empty state khi không có data

### ⚠️ Cần Lưu Ý

1. **Account Holder protection**: Luôn check `member.isAccountHolder` trước khi cho phép edit/remove
2. **Context mounted check**: Luôn check `context.mounted` trước khi navigate hoặc show snackbar
3. **Form cleanup**: Clear form fields sau khi submit thành công
4. **Data consistency**: Luôn gọi `refreshData()` sau actions để đảm bảo UI sync với data
5. **WorkspaceMember dữ liệu bắt buộc**: `name` và `email` phải luôn được lưu trong `workspace_members`; tất cả chỗ thêm/sửa member phải truyền đủ 2 trường này, invitations được filter bằng email để tránh duplicate
5. **Permission check flow**: Hiện tại trong `_initializePage()`, nếu permission check fail và navigate back, code vẫn tiếp tục gọi `_loadWorkspaceMembers()`. Nên thêm early return sau permission check để tránh load data không cần thiết:
   ```dart
   Future<void> _initializePage() async {
     _isLoading.value = true;
     await _checkPermissions();
     if (!_canManageUsers.value) {
       _isLoading.value = false;
       return; // Early return nếu không có permission
     }
     await _loadWorkspaceMembers();
     _isLoading.value = false;
   }
   ```

### 🔮 Potential Improvements

1. **Pull-to-refresh**: Thêm `RefreshIndicator` để user có thể manual refresh
2. **Pagination**: Nếu có nhiều users (>100), nên implement pagination
3. **Debounce search**: Debounce search input để tránh filter quá nhiều lần
4. **Loading skeleton**: Thay `CircularProgressIndicator` bằng skeleton loader
5. **Optimistic updates**: Update UI ngay lập tức, rollback nếu error
6. **Batch operations**: Cho phép select multiple users để edit/remove cùng lúc

---

## 🧪 Testing Considerations

### Unit Tests Cần Cover

1. **Controller initialization**: Test `onInit()` flow
2. **Permission check**: Test permission denied scenario
3. **Data loading**: Test `_loadWorkspaceMembers()` success/error
4. **Search filter**: Test `_filterUsers()` với các cases khác nhau
5. **Combine logic**: Test `_combineMembersAndInvitations()`

### Widget Tests Cần Cover

1. **Empty state**: Test hiển thị khi không có users
2. **Loading state**: Test hiển thị loading indicator
3. **Member card**: Test render và actions
4. **Invitation card**: Test render và actions
5. **Search bar**: Test filter functionality

### Integration Tests Cần Cover

1. **Full flow**: Test invite → refresh → verify invitation appears
2. **Edit role flow**: Test edit → refresh → verify role updated
3. **Remove user flow**: Test remove → refresh → verify user removed
4. **Permission flow**: Test permission denied → verify navigation back

---

## 📚 Related Files

### Core Files

- **Page**: `lib/app/pages/users/user_management_page.dart`
- **Controller**: `lib/app/pages/users/controllers/user_management_controller.dart`
- **Member Card**: `lib/app/pages/users/widgets/member_card.dart`
- **Invitation Card**: `lib/app/pages/users/widgets/invitation_card.dart`

### Dependencies

- **WorkspaceController**: `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- **WorkspaceRepository**: `lib/features/workspace/domain/repositories/workspace_repository.dart`
- **Entities**: 
  - `lib/features/workspace/domain/entities/workspace_member.dart`
  - `lib/features/invitations/domain/entities/invitation.dart`

### Services

- **NavigationService**: `lib/core/services/navigation_service.dart`
- **SnackbarService**: `lib/core/services/snackbar_service.dart`

---

## 🔗 Related Documentation

- [Workspace User Management Tasks](../workspace/WORKSPACE_USER_MANAGEMENT_TASKS.md)
- [Workspace User Management Test Cases](../workspace/WORKSPACE_USER_MANAGEMENT_TEST_CASES.md)
- [User Management Implementation Audit](../user_management/USER_MANAGEMENT_IMPLEMENTATION_AUDIT_REPORT.md)

---

**Last Updated**: 2025-01-27  
**Maintained By**: Development Team  
**Review Frequency**: When logic changes

