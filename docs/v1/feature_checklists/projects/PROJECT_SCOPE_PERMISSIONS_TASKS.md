# Project Scope & Permissions (Workspace + Role/Team; Project Membership Assign/Revoke/Roles) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Project Scope & Permissions** feature (workspace + role/team; project membership assign/revoke/roles). Currently, this feature is **PARTIAL** - workspace scoping is present (`workspaceId`), but no dedicated project member roles/permissions or UI to assign/revoke exists.

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `Project` entity has `workspaceId` field - workspace scoping exists
- ✅ Projects are filtered by workspace
- ✅ `WorkspacePermissions` has project-related permissions (`createProjects`, `manageProjects`, `assignProjects`)
- ✅ `WorkspaceMember` entity exists with workspace roles (AccountHolder, Admin, Member)
- ✅ `PermissionService` has methods for checking workspace permissions

### What's Missing/Broken:
- ⛔ No `ProjectMember` entity - no project-specific membership
- ⛔ No project-specific roles (Project Owner, Project Manager, Project Member)
- ⛔ No project-specific permissions
- ⛔ No UI to assign/revoke project members
- ⛔ No UI to manage project roles
- ⛔ No team-based project assignment
- ⛔ No project-level access control (only workspace-level)

---

## Task List

### Task 1: Create ProjectMember Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create `ProjectMember` entity to represent project-specific membership with roles and permissions.

**Files to Create**:
- `lib/features/tasks/domain/entities/project_member.dart` (new file)

**Implementation Steps**:
1. Create `ProjectMember` entity:
   ```dart
   class ProjectMember {
     final String id;
     final String projectId;
     final String userId;
     final String workspaceId;
     final ProjectRole role;
     final List<String> permissions;
     final String assignedBy;
     final DateTime assignedAt;
     final bool isActive;
     
     const ProjectMember({
       required this.id,
       required this.projectId,
       required this.userId,
       required this.workspaceId,
       required this.role,
       required this.permissions,
       required this.assignedBy,
       required this.assignedAt,
       this.isActive = true,
     });
   }
   ```

2. Add `fromMap` and `toMap` methods

3. Add `copyWith` method

**Expected Results**:
- ✅ ProjectMember entity exists
- ✅ Entity supports roles and permissions
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity creation
- Test: Verify entity serialization

---

### Task 2: Create ProjectRole Enum

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create `ProjectRole` enum for project-specific roles.

**Files to Create/Modify**:
- `lib/core/constants/task_enums.dart` (add ProjectRole enum)
- OR `lib/features/tasks/domain/entities/project_role.dart` (new file)

**Implementation Steps**:
1. Create `ProjectRole` enum:
   ```dart
   enum ProjectRole {
     owner('owner'),
     manager('manager'),
     member('member');
     
     const ProjectRole(this.value);
     final String value;
     
     static ProjectRole fromString(String value) {
       return ProjectRole.values.firstWhere(
         (role) => role.value == value,
         orElse: () => ProjectRole.member,
       );
     }
     
     String get displayText {
       switch (this) {
         case ProjectRole.owner:
           return 'Project Owner';
         case ProjectRole.manager:
           return 'Project Manager';
         case ProjectRole.member:
           return 'Project Member';
       }
     }
   }
   ```

2. Add default permissions for each role:
   ```dart
   List<String> get defaultPermissions {
     switch (this) {
       case ProjectRole.owner:
         return ProjectPermissions.allPermissions;
       case ProjectRole.manager:
         return ProjectPermissions.managerPermissions;
       case ProjectRole.member:
         return ProjectPermissions.memberPermissions;
     }
   }
   ```

**Expected Results**:
- ✅ ProjectRole enum exists
- ✅ Enum has all required roles
- ✅ Default permissions are defined

**Test Criteria**:
- Unit test: Test enum values
- Test: Verify default permissions

---

### Task 3: Create ProjectPermissions Constants

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create project-specific permissions constants.

**Files to Create**:
- `lib/features/tasks/domain/entities/project_permissions.dart` (new file)

**Implementation Steps**:
1. Create `ProjectPermissions` class:
   ```dart
   class ProjectPermissions {
     // Project Management
     static const String viewProject = 'view_project';
     static const String editProject = 'edit_project';
     static const String deleteProject = 'delete_project';
     static const String manageProjectMembers = 'manage_project_members';
     static const String assignProjectMembers = 'assign_project_members';
     static const String revokeProjectMembers = 'revoke_project_members';
     static const String changeProjectRoles = 'change_project_roles';
     
     // Task Management within Project
     static const String createProjectTasks = 'create_project_tasks';
     static const String editProjectTasks = 'edit_project_tasks';
     static const String deleteProjectTasks = 'delete_project_tasks';
     static const String assignProjectTasks = 'assign_project_tasks';
     
     // Project Data Access
     static const String viewProjectData = 'view_project_data';
     static const String viewProjectReports = 'view_project_reports';
     
     static List<String> get allPermissions => [
       viewProject,
       editProject,
       deleteProject,
       manageProjectMembers,
       assignProjectMembers,
       revokeProjectMembers,
       changeProjectRoles,
       createProjectTasks,
       editProjectTasks,
       deleteProjectTasks,
       assignProjectTasks,
       viewProjectData,
       viewProjectReports,
     ];
     
     static const List<String> ownerPermissions = allPermissions;
     
     static const List<String> managerPermissions = [
       viewProject,
       editProject,
       manageProjectMembers,
       assignProjectMembers,
       revokeProjectMembers,
       changeProjectRoles,
       createProjectTasks,
       editProjectTasks,
       deleteProjectTasks,
       assignProjectTasks,
       viewProjectData,
       viewProjectReports,
     ];
     
     static const List<String> memberPermissions = [
       viewProject,
       createProjectTasks,
       editProjectTasks,
       viewProjectData,
     ];
   }
   ```

**Expected Results**:
- ✅ ProjectPermissions constants exist
- ✅ Default permission sets are defined
- ✅ Permissions are clear and comprehensive

**Test Criteria**:
- Test: Verify permission constants
- Test: Verify default permission sets

---

### Task 4: Create ProjectMemberRepository

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create repository interface and implementation for project member operations.

**Files to Create**:
- `lib/features/tasks/domain/repositories/project_member_repository.dart` (new file)
- `lib/features/tasks/data/repositories/project_member_repository_impl.dart` (new file)

**Implementation Steps**:
1. Create `ProjectMemberRepository` interface:
   ```dart
   abstract class ProjectMemberRepository {
     Future<List<ProjectMember>> getProjectMembers({
       required String workspaceId,
       required String projectId,
     });
     
     Future<ProjectMember?> getProjectMember({
       required String workspaceId,
       required String projectId,
       required String userId,
     });
     
     Future<ProjectMember> addProjectMember({
       required String workspaceId,
       required String projectId,
       required String userId,
       required ProjectRole role,
       required String assignedBy,
     });
     
     Future<void> removeProjectMember({
       required String workspaceId,
       required String projectId,
       required String userId,
     });
     
     Future<ProjectMember> updateProjectMemberRole({
       required String workspaceId,
       required String projectId,
       required String userId,
       required ProjectRole newRole,
     });
     
     Future<bool> isProjectMember({
       required String workspaceId,
       required String projectId,
       required String userId,
     });
   }
   ```

2. Implement in `ProjectMemberRepositoryImpl`:
   - Use `FirebaseDatabaseService` to store/retrieve project members
   - Store in path: `workspaces/{workspaceId}/projects/{projectId}/members/{userId}`

**Expected Results**:
- ✅ Repository interface exists
- ✅ Repository implementation exists
- ✅ All CRUD operations work correctly

**Test Criteria**:
- Unit test: Test repository methods
- Integration test: Test with Firebase

---

### Task 5: Create Add Project Member Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to add a member to a project.

**Files to Create**:
- `lib/features/tasks/domain/usecases/add_project_member.dart` (new file)

**Implementation Steps**:
1. Create `AddProjectMember` use case:
   ```dart
   class AddProjectMember {
     final ProjectMemberRepository _repository;
     final WorkspaceRepository _workspaceRepository;
     
     AddProjectMember(this._repository, this._workspaceRepository);
     
     Future<Either<Failure, ProjectMember>> call({
       required String workspaceId,
       required String projectId,
       required String userId,
       required ProjectRole role,
       required String assignedBy,
     }) async {
       // 1. Validate user exists in workspace
       // 2. Validate project exists
       // 3. Check if user is already a member
       // 4. Create ProjectMember entity
       // 5. Save to repository
       // 6. Return created member
     }
   }
   ```

2. Add validation:
   - User must exist in workspace
   - Project must exist
   - User must not already be a member
   - AssignedBy must have permission to assign members

3. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Validation works correctly
- ✅ Member is added to project
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test add project member
- Test: Verify validation works
- Test: Verify member is added

---

### Task 6: Create Remove Project Member Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to remove a member from a project.

**Files to Create**:
- `lib/features/tasks/domain/usecases/remove_project_member.dart` (new file)

**Implementation Steps**:
1. Create `RemoveProjectMember` use case similar to `AddProjectMember`

2. Add validation:
   - Member must exist
   - Cannot remove project owner
   - Remover must have permission

3. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Validation works correctly
- ✅ Member is removed from project
- ✅ Owner protection works

**Test Criteria**:
- Unit test: Test remove project member
- Test: Verify owner protection
- Test: Verify member is removed

---

### Task 7: Create Update Project Member Role Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to update a project member's role.

**Files to Create**:
- `lib/features/tasks/domain/usecases/update_project_member_role.dart` (new file)

**Implementation Steps**:
1. Create `UpdateProjectMemberRole` use case

2. Add validation:
   - Member must exist
   - Cannot change owner role (unless transferring ownership)
   - Updater must have permission

3. Update permissions based on new role

4. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Validation works correctly
- ✅ Role is updated
- ✅ Permissions are updated

**Test Criteria**:
- Unit test: Test update role
- Test: Verify owner protection
- Test: Verify permissions update

---

### Task 8: Create Project Access Control Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service to check project access permissions.

**Files to Create**:
- `lib/core/services/project_access_control_service.dart` (new file)

**Implementation Steps**:
1. Create `ProjectAccessControlService`:
   ```dart
   class ProjectAccessControlService {
     final ProjectMemberRepository _projectMemberRepository;
     final PermissionService _permissionService;
     final WorkspaceRepository _workspaceRepository;
     
     /// Check if user can view project
     Future<bool> canViewProject(String userId, String workspaceId, String projectId) async {
       // 1. Check workspace permissions (viewAllData, viewTeamData, viewPersonalData)
       // 2. Check project membership
       // 3. Return true if either condition is met
     }
     
     /// Check if user can edit project
     Future<bool> canEditProject(String userId, String workspaceId, String projectId) async {
       // 1. Check workspace permissions (manageProjects)
       // 2. Check project role (owner, manager)
       // 3. Return true if either condition is met
     }
     
     /// Check if user has project permission
     Future<bool> hasProjectPermission(
       String userId,
       String workspaceId,
       String projectId,
       String permission,
     ) async {
       // 1. Check workspace permissions
       // 2. Check project member permissions
       // 3. Return true if either condition is met
     }
   }
   ```

2. Implement permission checking logic

**Expected Results**:
- ✅ Service exists
- ✅ Permission checks work correctly
- ✅ Workspace and project permissions are combined

**Test Criteria**:
- Unit test: Test permission checks
- Test: Verify workspace permissions
- Test: Verify project permissions

---

### Task 9: Add Project Members Field to Project Entity (Optional)

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Optionally add members list to Project entity for quick access (or query separately).

**Files to Modify**:
- `lib/features/tasks/domain/entities/project.dart`

**Implementation Steps**:
1. Option 1: Add members list field (denormalized):
   ```dart
   class Project {
     // ... existing fields ...
     final List<String> memberIds; // Quick reference
   }
   ```

2. Option 2: Query members separately (preferred for data consistency)

**Expected Results**:
- ✅ Members can be accessed (either via field or query)
- ✅ Data consistency is maintained

**Test Criteria**:
- Test: Verify members can be accessed
- Test: Verify data consistency

---

### Task 10: Create Project Member Management UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI for managing project members (view, add, remove, change roles).

**Files to Create/Modify**:
- `lib/app/pages/projects/project_members_page.dart` (new file)
- `lib/app/pages/projects/project_detail_page.dart` (modify)

**Implementation Steps**:
1. Create `ProjectMembersPage`:
   ```dart
   class ProjectMembersPage extends StatelessWidget {
     final Project project;
     
     @override
     Widget build(BuildContext context) {
       return GetBuilder<ProjectController>(
         builder: (controller) => Scaffold(
           appBar: TDAppBar(
             title: AppStrings.projectMembers,
           ),
           body: Column(
             children: [
               _buildAddMemberButton(controller),
               _buildMembersList(controller),
             ],
           ),
         ),
       );
     }
   }
   ```

2. Add "Manage Members" button to project detail page

3. Create add member dialog:
   - Member selector
   - Role selector
   - Confirm button

4. Create member card with:
   - Member info
   - Role display
   - Change role option
   - Remove option

5. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Project members page exists
- ✅ Can view project members
- ✅ Can add members
- ✅ Can remove members
- ✅ Can change roles
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: View project members
- Test: Add member
- Test: Remove member
- Test: Change role

---

### Task 11: Add Team Assignment to Project Entity

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add team assignment field to Project entity for team-based access.

**Files to Modify**:
- `lib/features/tasks/domain/entities/project.dart`

**Implementation Steps**:
1. Add team assignment fields:
   ```dart
   class Project {
     // ... existing fields ...
     final String? teamId; // Assigned team
     final List<String>? teamIds; // Multiple teams (if supported)
   }
   ```

2. Update `fromMap` and `toMap` methods

3. Update `copyWith` method

**Expected Results**:
- ✅ Team assignment fields exist
- ✅ Entity supports team assignment
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity with team assignment
- Test: Verify team assignment works

---

### Task 12: Create Assign Project to Team Use Case

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create use case to assign a project to a team.

**Files to Create**:
- `lib/features/tasks/domain/usecases/assign_project_to_team.dart` (new file)

**Implementation Steps**:
1. Create `AssignProjectToTeam` use case

2. Add validation:
   - Project must exist
   - Team must exist
   - User must have `assignProjects` permission

3. Update project with teamId

4. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Validation works correctly
- ✅ Project is assigned to team
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test assign project to team
- Test: Verify validation works
- Test: Verify project is updated

---

### Task 13: Update ProjectController with Member Management Methods

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add project member management methods to `ProjectController`.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/project_controller.dart`

**Implementation Steps**:
1. Add methods:
   ```dart
   Future<List<ProjectMember>> getProjectMembers(String projectId) async {
     // Get project members
   }
   
   Future<void> addProjectMember({
     required String projectId,
     required String userId,
     required ProjectRole role,
   }) async {
     // Add member with permission check
   }
   
   Future<void> removeProjectMember({
     required String projectId,
     required String userId,
   }) async {
     // Remove member with permission check
   }
   
   Future<void> updateProjectMemberRole({
     required String projectId,
     required String userId,
     required ProjectRole newRole,
   }) async {
     // Update role with permission check
   }
   ```

2. Add permission checks to all methods

3. Add error handling

**Expected Results**:
- ✅ Controller methods exist
- ✅ Permission checks are enforced
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test controller methods
- Test: Verify permission checks
- Test: Verify error handling

---

### Task 14: Update Project Filtering to Include Access Control

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update project filtering to respect project access control.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/project_controller.dart`
- `lib/features/tasks/data/repositories/project_repository_impl.dart`

**Implementation Steps**:
1. Update `_loadProjects` to filter by access:
   ```dart
   Future<void> _loadProjects() async {
     // Get all projects in workspace
     final allProjects = await _projectRepository.getProjects(
       workspaceId: _workspaceContext.currentWorkspaceId,
     );
     
     // Filter by access control
     final accessibleProjects = <Project>[];
     for (final project in allProjects) {
       final canView = await _projectAccessControlService.canViewProject(
         currentUserId,
         workspaceId,
         project.id,
       );
       if (canView) {
         accessibleProjects.add(project);
       }
     }
     
     _projects.value = accessibleProjects;
   }
   ```

2. Integrate with `ProjectAccessControlService`

**Expected Results**:
- ✅ Projects are filtered by access control
- ✅ Only accessible projects are shown
- ✅ Performance is acceptable

**Test Criteria**:
- Test: Verify filtering works
- Test: Verify performance
- Test: Verify access control

---

### Task 15: Add Unit Tests for Project Scope & Permissions

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for project scope & permissions functionality.

**Files to Create**:
- `test/features/tasks/domain/entities/project_member_test.dart`
- `test/features/tasks/domain/usecases/add_project_member_test.dart`
- `test/core/services/project_access_control_service_test.dart`

**Implementation Steps**:
1. Test `ProjectMember` entity
2. Test `ProjectRole` enum
3. Test use cases (add, remove, update role)
4. Test access control service
5. Test repository methods

**Expected Results**:
- ✅ Unit tests cover project scope & permissions
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Create ProjectMember Entity (Critical - Foundation)
2. **Task 2**: Create ProjectRole Enum (Critical - Foundation)
3. **Task 3**: Create ProjectPermissions Constants (Critical - Foundation)
4. **Task 4**: Create ProjectMemberRepository (High Priority - Data Layer)
5. **Task 5**: Create Add Project Member Use Case (High Priority - Business Logic)
6. **Task 6**: Create Remove Project Member Use Case (High Priority - Business Logic)
7. **Task 7**: Create Update Project Member Role Use Case (High Priority - Business Logic)
8. **Task 8**: Create Project Access Control Service (High Priority - Security)
9. **Task 13**: Update ProjectController with Member Management Methods (High Priority - Controller Layer)
10. **Task 10**: Create Project Member Management UI (High Priority - UI)
11. **Task 14**: Update Project Filtering to Include Access Control (High Priority - Security)
12. **Task 11**: Add Team Assignment to Project Entity (Medium Priority - Feature Enhancement)
13. **Task 12**: Create Assign Project to Team Use Case (Medium Priority - Feature Enhancement)
14. **Task 9**: Add Project Members Field to Project Entity (Low Priority - Optimization)
15. **Task 15**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ ProjectMember entity exists
- ✅ ProjectRole enum exists
- ✅ ProjectPermissions constants exist
- ✅ Project member repository exists
- ✅ Use cases exist for add/remove/update role
- ✅ Project access control service exists
- ✅ Project member management UI exists
- ✅ Projects are filtered by access control
- ✅ Team assignment is supported (if implemented)
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ No known bugs or issues

---

## Dependencies

- **Project Entity**: Needs team assignment fields (optional)
- **ProjectMemberRepository**: Required for project member operations
- **WorkspaceRepository**: Required for workspace member validation
- **PermissionService**: Required for permission checks
- **Firebase Realtime Database**: Required for storing project members
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications

---

## Notes

1. **Workspace Scoping**: Already exists and works. Projects are filtered by `workspaceId`.

2. **Project Membership**: Currently missing. Need to implement project-specific membership separate from workspace membership.

3. **Project Roles**: Need to implement project-specific roles (Owner, Manager, Member) separate from workspace roles.

4. **Access Control**: Need to combine workspace permissions with project permissions:
   - Workspace `viewAllData` → can view all projects
   - Workspace `viewTeamData` → can view team projects
   - Project member → can view assigned project
   - Project role → determines project permissions

5. **Team Assignment**: Optional enhancement. Can assign projects to teams for team-based access.

6. **Migration**: When implementing, need to handle existing projects:
   - Creator becomes project owner
   - Existing workspace members may need to be added as project members (or use workspace permissions as fallback)

7. **Permission Inheritance**: Project permissions should inherit from workspace permissions but can be overridden by project-specific permissions.

---

## Related Documentation

- `PROJECTS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `PROJECT_SCOPE_PERMISSIONS_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/user_management/ROLES_PERMISSIONS_TASKS.md` - Related roles & permissions tasks
- `docs/v1/feature_checklists/workspace/PROJECTS_TEAMS_VISIBILITY_TASKS.md` - Related team visibility tasks
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture

