# Roles & Permissions (Account Holder/Admin/Lead/Member + Custom Permissions) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Roles & Permissions** feature (Account Holder/Admin/Lead/Member + custom permissions). Currently, this feature is **PARTIAL** - `UserRoles` defines admin/departmentManager/teamLead/regular with permission lists, but Account Holder role, Lead per workspace/team, custom permission sets for projects/tasks/teams are missing, and workspace role (AccountHolder/Admin/Member) is handled separately in `WorkspaceRole` but not bridged to `User`.

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `UserRoles` class with admin/departmentManager/teamLead/regular roles
- ✅ `UserRoles` has permission lists for each role
- ✅ `WorkspaceRole` enum with accountHolder/admin/member
- ✅ `DefaultPermissionSets` with hardcoded permission templates
- ✅ `WorkspacePermissions` constants
- ✅ `AuthController.hasPermission/canManageRole/hasHigherAuthority` methods
- ✅ `WorkspaceController.hasPermission` method
- ✅ Individual permissions can be granted/revoked

### What's Missing/Broken:
- ⚠️ Account Holder role is not in `UserRoles`
- ⚠️ Lead role is not in `WorkspaceRole` enum
- ⛔ No bridge between `User.role` (UserRoles) and `WorkspaceMember.role` (WorkspaceRole)
- ⛔ No custom permission sets for projects/tasks/teams
- ⛔ No UI for managing custom permission sets
- ⛔ Permission templates are hardcoded (cannot be edited via UI)
- ⛔ No custom role creation
- ⛔ Lead per workspace/team is not supported

---

## Task List

### Task 1: Add Account Holder Role to UserRoles

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add Account Holder role to `UserRoles` class to bridge with `WorkspaceRole.accountHolder`.

**Files to Modify**:
- `lib/core/constants/user_roles.dart`

**Implementation Steps**:
1. Add Account Holder constant:
   ```dart
   /// Account Holder role - Workspace owner with full permissions
   static const String accountHolder = 'account_holder';
   ```

2. Add Account Holder permissions:
   ```dart
   /// Account Holder permissions - Full access to everything
   static const List<String> accountHolderPermissions = [
     // Include all permissions (same as admin or more)
     manageCompany,
     manageDepartments,
     manageUsers,
     assignRoles,
     createTasks,
     assignTasks,
     updateTaskStatus,
     deleteTasks,
     setTaskPriority,
     setTaskDeadline,
     closeTasks,
     viewCompanyDashboard,
     viewDepartmentDashboard,
     viewTeamDashboard,
     viewPersonalDashboard,
     generateReports,
     viewAnalytics,
     viewAllData,
     viewDepartmentData,
     viewTeamData,
     viewPersonalData,
     createProjects,
     manageProjects,
     assignProjects,
   ];
   ```

3. Update `hasPermission` method:
   ```dart
   static bool hasPermission(String role, String permission) {
     switch (role) {
       case accountHolder:
         return accountHolderPermissions.contains(permission);
       case admin:
         return adminPermissions.contains(permission);
       // ... rest of cases
     }
   }
   ```

4. Update `getPermissions` method
5. Update `canManageRole` method (Account Holder can manage all roles)
6. Update `getRoleLevel` method (Account Holder has highest level, e.g., 5)
7. Update `getRoleDisplayName` method
8. Update `getRoleDescription` method
9. Update `getAllRoles` method

**Expected Results**:
- ✅ Account Holder is added to UserRoles
- ✅ Account Holder has all permissions
- ✅ All UserRoles methods support Account Holder
- ✅ Account Holder has highest authority level

**Test Criteria**:
- Unit test: Test Account Holder in all UserRoles methods
- Test: Verify Account Holder has all permissions
- Test: Verify Account Holder can manage all roles

---

### Task 2: Add Lead Role to WorkspaceRole Enum

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add Lead role to `WorkspaceRole` enum for team/group leadership.

**Files to Modify**:
- `lib/features/workspace/domain/entities/workspace_member.dart`

**Implementation Steps**:
1. Add Lead role to `WorkspaceRole` enum:
   ```dart
   enum WorkspaceRole {
     accountHolder('account_holder'),
     admin('admin'),
     lead('lead'),
     member('member');
     
     const WorkspaceRole(this.value);
     final String value;
   }
   ```

2. Update `fromString` method:
   ```dart
   static WorkspaceRole fromString(String value) {
     switch (value.toLowerCase()) {
       case 'account_holder':
         return WorkspaceRole.accountHolder;
       case 'admin':
         return WorkspaceRole.admin;
       case 'lead':
         return WorkspaceRole.lead;
       case 'member':
         return WorkspaceRole.member;
       default:
         return WorkspaceRole.member;
     }
   }
   ```

3. Update `displayName` getter:
   ```dart
   String get displayName {
     switch (this) {
       case WorkspaceRole.accountHolder:
         return 'Account Holder';
       case WorkspaceRole.admin:
         return 'Admin';
       case WorkspaceRole.lead:
         return 'Lead';
       case WorkspaceRole.member:
         return 'Member';
     }
   }
   ```

4. Add `isLead` getter to `WorkspaceMember`:
   ```dart
   bool get isLead => role == WorkspaceRole.lead;
   ```

**Expected Results**:
- ✅ Lead role is added to WorkspaceRole enum
- ✅ Lead role can be assigned to users
- ✅ Lead role is displayed correctly
- ✅ isLead getter works

**Test Criteria**:
- Unit test: Test Lead role in WorkspaceRole enum
- Test: Assign Lead role to user, verify it works
- Test: Verify isLead getter works

---

### Task 3: Add Lead Permissions to DefaultPermissionSets

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add default Lead permissions to `DefaultPermissionSets`.

**Files to Modify**:
- `lib/features/workspace/domain/entities/workspace_permissions.dart`

**Implementation Steps**:
1. Add Lead permissions constant:
   ```dart
   // Lead permissions (team-level management)
   static const List<String> defaultLeadPermissions = [
     WorkspacePermissions.createTasks,
     WorkspacePermissions.assignTasks,
     WorkspacePermissions.updateTaskStatus,
     WorkspacePermissions.deleteTasks,
     WorkspacePermissions.setTaskPriority,
     WorkspacePermissions.setTaskDeadline,
     WorkspacePermissions.createProjects,
     WorkspacePermissions.manageProjects,
     WorkspacePermissions.assignProjects,
     WorkspacePermissions.viewTeamData,
     WorkspacePermissions.viewPersonalData,
     WorkspacePermissions.generateReports,
     WorkspacePermissions.viewAnalytics,
   ];
   ```

2. Update `getDefaultPermissions` method:
   ```dart
   static List<String> getDefaultPermissions(String role) {
     switch (role.toLowerCase()) {
       case 'account_holder':
         return List.from(accountHolderPermissions);
       case 'admin':
         return List.from(defaultAdminPermissions);
       case 'lead':
         return List.from(defaultLeadPermissions);
       case 'member':
         return List.from(defaultMemberPermissions);
       case 'personal':
         return List.from(personalUserPermissions);
       default:
         return List.from(defaultMemberPermissions);
     }
   }
   ```

**Expected Results**:
- ✅ Lead permissions are defined
- ✅ Lead permissions are returned by getDefaultPermissions
- ✅ Lead permissions are appropriate for team leadership

**Test Criteria**:
- Unit test: Test Lead permissions
- Test: Verify Lead permissions are correct

---

### Task 4: Create Role Bridge Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service to bridge `User.role` (UserRoles) with `WorkspaceMember.role` (WorkspaceRole).

**Files to Create**:
- `lib/core/services/role_bridge_service.dart` (new file)

**Implementation Steps**:
1. Create `RoleBridgeService`:
   ```dart
   class RoleBridgeService {
     factory RoleBridgeService() => _instance ??= RoleBridgeService._();
     RoleBridgeService._();
     static RoleBridgeService? _instance;
     
     final WorkspaceController _workspaceController = Get.find<WorkspaceController>();
     
     /// Get effective user role (bridges User.role with WorkspaceRole)
     Future<String> getEffectiveUserRole(String userId, String workspaceId) async {
       // Get workspace role
       final workspaceMember = await _workspaceController.getUserWorkspaceRole();
       
       if (workspaceMember != null) {
         // Map WorkspaceRole to UserRoles
         return _mapWorkspaceRoleToUserRole(workspaceMember.role);
       }
       
       // Fallback to User.role
       final authController = Get.find<AuthController>();
       return authController.currentUser?.role ?? UserRoles.regularUser;
     }
     
     /// Map WorkspaceRole to UserRoles
     String _mapWorkspaceRoleToUserRole(WorkspaceRole workspaceRole) {
       switch (workspaceRole) {
         case WorkspaceRole.accountHolder:
           return UserRoles.accountHolder;
         case WorkspaceRole.admin:
           return UserRoles.admin;
         case WorkspaceRole.lead:
           return UserRoles.teamLead; // Map Lead to Team Lead
         case WorkspaceRole.member:
           return UserRoles.regularUser;
       }
     }
     
     /// Get effective permissions (combines User.role and WorkspaceRole permissions)
     Future<List<String>> getEffectivePermissions(String userId, String workspaceId) async {
       final workspaceMember = await _workspaceController.getUserWorkspaceRole();
       if (workspaceMember != null) {
         // Use workspace permissions (which may include custom permissions)
         return workspaceMember.permissions;
       }
       
       // Fallback to User.role permissions
       final authController = Get.find<AuthController>();
       final userRole = authController.currentUser?.role ?? UserRoles.regularUser;
       return UserRoles.getPermissions(userRole);
     }
     
     /// Check if user has permission (workspace-aware)
     Future<bool> hasPermission(String userId, String workspaceId, String permission) async {
       final permissions = await getEffectivePermissions(userId, workspaceId);
       return permissions.contains(permission);
     }
   }
   ```

2. Integrate with AuthController:
   - Update `hasPermission` to use RoleBridgeService
   - Make permission checks workspace-aware

**Expected Results**:
- ✅ RoleBridgeService exists
- ✅ User.role is bridged with WorkspaceRole
- ✅ Permissions are workspace-aware
- ✅ Permission checks work correctly

**Test Criteria**:
- Unit test: Test role bridge
- Test: Verify permissions are workspace-aware
- Test: Verify role changes when switching workspaces

---

### Task 5: Update AuthController to Use Role Bridge

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update `AuthController.hasPermission` to use role bridge for workspace-aware permission checks.

**Files to Modify**:
- `lib/features/auth/presentation/controllers/auth_controller.dart`

**Implementation Steps**:
1. Add RoleBridgeService dependency:
   ```dart
   final RoleBridgeService _roleBridgeService = RoleBridgeService();
   ```

2. Update `hasPermission` method:
   ```dart
   Future<bool> hasPermission(String permission) async {
     final user = _currentUser.value;
     if (user == null) return false;
     
     // Get current workspace
     final workspaceController = Get.find<WorkspaceController>();
     final currentWorkspace = workspaceController.currentWorkspace.value;
     
     if (currentWorkspace != null) {
       // Use workspace-aware permission check
       return await _roleBridgeService.hasPermission(
         user.id,
         currentWorkspace.id,
         permission,
       );
     }
     
     // Fallback to User.role permissions
     return UserRoles.hasPermission(user.role, permission);
   }
   ```

3. Update `getCurrentUserPermissions` method:
   ```dart
   Future<List<String>> getCurrentUserPermissions() async {
     final user = _currentUser.value;
     if (user == null) return [];
     
     final workspaceController = Get.find<WorkspaceController>();
     final currentWorkspace = workspaceController.currentWorkspace.value;
     
     if (currentWorkspace != null) {
       return await _roleBridgeService.getEffectivePermissions(
         user.id,
         currentWorkspace.id,
       );
     }
     
     return UserRoles.getPermissions(user.role);
   }
   ```

4. Add workspace-aware role getter:
   ```dart
   Future<String> getEffectiveRole() async {
     final user = _currentUser.value;
     if (user == null) return UserRoles.regularUser;
     
     final workspaceController = Get.find<WorkspaceController>();
     final currentWorkspace = workspaceController.currentWorkspace.value;
     
     if (currentWorkspace != null) {
       return await _roleBridgeService.getEffectiveUserRole(
         user.id,
         currentWorkspace.id,
       );
     }
     
     return user.role;
   }
   ```

**Expected Results**:
- ✅ Permission checks are workspace-aware
- ✅ Role is workspace-aware
- ✅ Permissions update when switching workspaces

**Test Criteria**:
- Test: Check permissions in different workspaces
- Test: Verify permissions update when switching workspaces
- Test: Verify role changes when switching workspaces

---

### Task 6: Create Custom Permission Set Entity

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create entity to represent custom permission sets for projects/tasks/teams.

**Files to Create**:
- `lib/features/workspace/domain/entities/custom_permission_set.dart` (new file)

**Implementation Steps**:
1. Create `CustomPermissionSet` entity:
   ```dart
   class CustomPermissionSet {
     final String id;
     final String name;
     final String description;
     final String scope; // 'project', 'task', 'team', 'workspace'
     final String? scopeId; // ID of project/task/team if scoped
     final List<String> permissions;
     final String workspaceId;
     final String createdBy;
     final DateTime createdAt;
     final DateTime? updatedAt;
     
     const CustomPermissionSet({
       required this.id,
       required this.name,
       required this.description,
       required this.scope,
       this.scopeId,
       required this.permissions,
       required this.workspaceId,
       required this.createdBy,
       required this.createdAt,
       this.updatedAt,
     });
     
     factory CustomPermissionSet.fromMap(Map<String, dynamic> map) {
       return CustomPermissionSet(
         id: map['id'] as String,
         name: map['name'] as String,
         description: map['description'] as String,
         scope: map['scope'] as String,
         scopeId: map['scopeId'] as String?,
         permissions: (map['permissions'] as List<dynamic>?)
             ?.map((e) => e.toString())
             .toList() ?? [],
         workspaceId: map['workspaceId'] as String,
         createdBy: map['createdBy'] as String,
         createdAt: DateTime.fromMillisecondsSinceEpoch(
           map['createdAt'] as int,
         ),
         updatedAt: map['updatedAt'] != null
             ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
             : null,
       );
     }
     
     Map<String, dynamic> toMap() {
       return {
         'id': id,
         'name': name,
         'description': description,
         'scope': scope,
         'scopeId': scopeId,
         'permissions': permissions,
         'workspaceId': workspaceId,
         'createdBy': createdBy,
         'createdAt': createdAt.millisecondsSinceEpoch,
         'updatedAt': updatedAt?.millisecondsSinceEpoch,
       };
     }
   }
   ```

2. Add helper methods:
   - `copyWith` method
   - `isValid` method
   - `hasPermission` method

**Expected Results**:
- ✅ CustomPermissionSet entity exists
- ✅ Entity supports different scopes (project/task/team)
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity creation and serialization
- Test: Verify all fields are included

---

### Task 7: Create Custom Permission Set Repository

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create repository for managing custom permission sets.

**Files to Create**:
- `lib/features/workspace/domain/repositories/custom_permission_set_repository.dart` (new file)
- `lib/features/workspace/data/repositories/custom_permission_set_repository_impl.dart` (new file)

**Implementation Steps**:
1. Create repository interface:
   ```dart
   abstract class CustomPermissionSetRepository {
     Future<Either<Failure, CustomPermissionSet>> createPermissionSet(
       CustomPermissionSet permissionSet,
     );
     
     Future<Either<Failure, CustomPermissionSet>> updatePermissionSet(
       CustomPermissionSet permissionSet,
     );
     
     Future<Either<Failure, void>> deletePermissionSet(String id);
     
     Future<Either<Failure, List<CustomPermissionSet>>> getPermissionSets(
       String workspaceId, {
       String? scope,
       String? scopeId,
     });
     
     Future<Either<Failure, CustomPermissionSet?>> getPermissionSet(String id);
     
     Future<Either<Failure, List<CustomPermissionSet>>> getUserPermissionSets(
       String userId,
       String workspaceId,
     );
   }
   ```

2. Implement repository:
   - Implement all methods
   - Use FirebaseDatabaseService for data operations
   - Handle errors appropriately

**Expected Results**:
- ✅ Repository exists
- ✅ All CRUD operations work
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test repository methods
- Integration test: Test with Firebase

---

### Task 8: Create Custom Permission Set Controller

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create controller for managing custom permission sets.

**Files to Create**:
- `lib/features/workspace/presentation/controllers/custom_permission_set_controller.dart` (new file)

**Implementation Steps**:
1. Create `CustomPermissionSetController`:
   ```dart
   class CustomPermissionSetController extends GetxController {
     final CustomPermissionSetRepository _repository;
     
     final RxList<CustomPermissionSet> _permissionSets = <CustomPermissionSet>[].obs;
     final RxBool _isLoading = false.obs;
     final RxString _errorMessage = ''.obs;
     
     List<CustomPermissionSet> get permissionSets => _permissionSets;
     bool get isLoading => _isLoading.value;
     String get errorMessage => _errorMessage.value;
     
     Future<void> createPermissionSet({
       required String name,
       required String description,
       required String scope,
       String? scopeId,
       required List<String> permissions,
     }) async {
       // Implementation
     }
     
     Future<void> updatePermissionSet(CustomPermissionSet permissionSet) async {
       // Implementation
     }
     
     Future<void> deletePermissionSet(String id) async {
       // Implementation
     }
     
     Future<void> loadPermissionSets({
       String? scope,
       String? scopeId,
     }) async {
       // Implementation
     }
   }
   ```

2. Add permission checks (only Account Holder/Admin can manage)
3. Add validation

**Expected Results**:
- ✅ Controller exists
- ✅ CRUD operations work
- ✅ Permission checks are enforced

**Test Criteria**:
- Unit test: Test controller methods
- Test: Verify permission checks work

---

### Task 9: Create Custom Permission Set Management UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI for managing custom permission sets.

**Files to Create**:
- `lib/app/pages/permissions/custom_permission_set_page.dart` (new file)

**Implementation Steps**:
1. Create permission set list view:
   - Display existing permission sets
   - Filter by scope (project/task/team)
   - Show permissions for each set

2. Create permission set editor:
   - Form for name, description, scope
   - Permission selector (checkboxes for each permission)
   - Save/Cancel buttons

3. Add navigation from appropriate screens:
   - Project settings
   - Task settings
   - Team settings

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Permission set management UI exists
- ✅ Permission sets can be created/edited/deleted
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Create/edit/delete permission set
- Test: Verify UI works correctly

---

### Task 10: Assign Custom Permission Sets to Users

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Implement functionality to assign custom permission sets to users.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/app/pages/users/user_management_page.dart`

**Implementation Steps**:
1. Add method to assign permission set:
   ```dart
   Future<void> assignPermissionSetToUser(
     String userId,
     String permissionSetId,
   ) async {
     // Get permission set
     // Get user's current permissions
     // Merge permission set permissions with user permissions
     // Update user permissions
   }
   ```

2. Add UI for assigning permission sets:
   - Show available permission sets
   - Allow selection
   - Assign to user

3. Handle permission set updates:
   - When permission set is updated, update all users with that set

**Expected Results**:
- ✅ Permission sets can be assigned to users
- ✅ Permissions are merged correctly
- ✅ Permission set updates affect assigned users

**Test Criteria**:
- Test: Assign permission set to user
- Test: Verify permissions are applied
- Test: Update permission set, verify user permissions update

---

### Task 11: Create Permission Template Management UI

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Create UI for managing permission templates (editing default permission sets).

**Files to Create**:
- `lib/app/pages/permissions/permission_template_page.dart` (new file)

**Implementation Steps**:
1. Create template list view:
   - Display existing templates (Account Holder, Admin, Member, Lead)
   - Show permissions for each template

2. Create template editor:
   - Edit permissions for each role
   - Save templates to Firebase (instead of hardcoded)

3. Add template persistence:
   - Load templates from Firebase
   - Save templates to Firebase
   - Fallback to hardcoded defaults if not found

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Permission templates can be edited
- ✅ Templates are saved to Firebase
- ✅ Templates are loaded from Firebase

**Test Criteria**:
- Manual test: Edit template, verify save
- Test: Verify templates are persisted

---

### Task 12: Create Custom Role Management UI

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Create UI for creating and managing custom roles.

**Files to Create**:
- `lib/app/pages/permissions/custom_role_page.dart` (new file)

**Implementation Steps**:
1. Create custom role list view
2. Create custom role editor:
   - Name, description fields
   - Permission selector
   - Save/Cancel buttons
3. Add role assignment:
   - Assign custom role to users
   - Verify role works correctly

**Expected Results**:
- ✅ Custom roles can be created
- ✅ Custom roles can be assigned to users
- ✅ Custom role permissions work

**Test Criteria**:
- Manual test: Create custom role
- Test: Assign custom role, verify permissions

---

### Task 13: Add Permission Matrix View

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Create permission matrix view for comparing roles and permissions.

**Files to Create**:
- `lib/app/pages/permissions/permission_matrix_page.dart` (new file)

**Implementation Steps**:
1. Create matrix view:
   - Rows: Permissions
   - Columns: Roles
   - Cells: Checkmarks for permissions
2. Add role comparison:
   - Select multiple roles
   - Show side-by-side comparison
3. Add export functionality (optional)

**Expected Results**:
- ✅ Permission matrix can be viewed
- ✅ Role comparison works
- ✅ Matrix is clear and easy to understand

**Test Criteria**:
- Manual test: View permission matrix
- Test: Compare roles, verify comparison works

---

### Task 14: Add Unit Tests for Roles & Permissions

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for roles and permissions functionality.

**Files to Create/Modify**:
- `test/core/constants/user_roles_test.dart`
- `test/core/services/role_bridge_service_test.dart`
- `test/features/workspace/domain/entities/custom_permission_set_test.dart`

**Implementation Steps**:
1. Test UserRoles:
   - Test Account Holder role (if added)
   - Test all permission methods
   - Test role hierarchy

2. Test WorkspaceRole:
   - Test Lead role (if added)
   - Test role conversion

3. Test RoleBridgeService:
   - Test role mapping
   - Test permission merging
   - Test workspace-aware checks

4. Test CustomPermissionSet:
   - Test entity creation
   - Test serialization
   - Test validation

**Expected Results**:
- ✅ Unit tests cover roles and permissions
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Add Account Holder Role to UserRoles (Critical - Foundation)
2. **Task 2**: Add Lead Role to WorkspaceRole Enum (High Priority - Core Feature)
3. **Task 3**: Add Lead Permissions to DefaultPermissionSets (High Priority - Core Feature)
4. **Task 4**: Create Role Bridge Service (High Priority - Integration)
5. **Task 5**: Update AuthController to Use Role Bridge (High Priority - Integration)
6. **Task 6**: Create Custom Permission Set Entity (Medium Priority - Foundation)
7. **Task 7**: Create Custom Permission Set Repository (Medium Priority - Data Layer)
8. **Task 8**: Create Custom Permission Set Controller (Medium Priority - Controller Layer)
9. **Task 9**: Create Custom Permission Set Management UI (Medium Priority - UI)
10. **Task 10**: Assign Custom Permission Sets to Users (Medium Priority - Feature Completeness)
11. **Task 11**: Create Permission Template Management UI (Low Priority - Feature Enhancement)
12. **Task 12**: Create Custom Role Management UI (Low Priority - Feature Enhancement)
13. **Task 13**: Add Permission Matrix View (Low Priority - UX Enhancement)
14. **Task 14**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Account Holder is added to UserRoles
- ✅ Lead role is added to WorkspaceRole
- ✅ Lead permissions are defined
- ✅ Role bridge service exists
- ✅ Permission checks are workspace-aware
- ✅ Custom permission sets can be created for projects/tasks/teams
- ✅ Custom permission sets can be assigned to users
- ✅ Permission templates can be managed via UI
- ✅ Custom roles can be created
- ✅ Permission matrix can be viewed
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ No known bugs or issues

---

## Dependencies

- **UserRoles**: Must support Account Holder role
- **WorkspaceRole**: Must support Lead role
- **WorkspaceController**: Required for workspace role checks
- **AuthController**: Must use role bridge for permissions
- **Firebase Realtime Database**: Required for storing custom permission sets
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications

---

## Notes

1. **Role Systems**: Two role systems exist (`UserRoles` and `WorkspaceRole`). They need to be bridged so workspace roles are reflected in user permissions.

2. **Account Holder**: Currently exists only in `WorkspaceRole`. Needs to be added to `UserRoles` and bridged.

3. **Lead Role**: Mentioned in requirements but not implemented. Should be added to `WorkspaceRole` enum.

4. **Custom Permissions**: Individual permissions can be granted/revoked, but custom permission sets for projects/tasks/teams are not implemented. This allows fine-grained control per project/task/team.

5. **Permission Templates**: Currently hardcoded in `DefaultPermissionSets`. Should be editable via UI and stored in Firebase.

6. **Permission Inheritance**: When custom permissions are assigned, they should override role defaults. Need to handle permission merging correctly.

7. **Workspace-Aware**: All permission checks should be workspace-aware. User may have different roles/permissions in different workspaces.

8. **Custom Roles**: Optional feature for creating custom roles with custom permission sets. Useful for organizations with specific role requirements.

9. **Permission Matrix**: Optional feature for visualizing and comparing roles and permissions. Helps with understanding permission structure.

10. **Backward Compatibility**: Changes should maintain backward compatibility with existing roles and permissions.

---

## Related Documentation

- `USER_MANAGEMENT_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `ROLES_PERMISSIONS_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/workspace/ROLE_MATRIX_TEST_CASES.md` - Related role matrix tests
- `docs/v1/feature_checklists/workspace/ROLE_MATRIX_TASKS.md` - Related role matrix tasks
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/SECURITY_RULES.md` - Security requirements

