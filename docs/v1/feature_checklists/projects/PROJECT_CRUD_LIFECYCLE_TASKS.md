# Project CRUD & Lifecycle (Create/Edit/Archive/Restore/Delete with Permissions) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Project CRUD & Lifecycle** feature (create/edit/archive/restore/delete with permissions). Currently, this feature is **PARTIAL** - create/edit/delete flows exist via project controllers/repository, but archive/restore support is not evident, and permissions are enforced indirectly (workspace-based, not role-based UI checks).

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `ProjectController` with `createProject`, `updateProject`, `deleteProject` methods
- ✅ `ProjectRepository` with CRUD operations
- ✅ `FirebaseDatabaseService.softDeleteProject` method
- ✅ `Project` entity with `deletedAt` field (soft delete support)
- ✅ `PermissionService.canCreateProject` and `canManageProject` methods
- ✅ Workspace-based filtering (projects filtered by workspaceId)

### What's Missing/Broken:
- ⛔ Archive/restore support is not evident
- ⛔ No archive/restore methods in repository
- ⛔ No archive/restore UI
- ⛔ Permissions are enforced indirectly (workspace-based, not role-based UI checks)
- ⛔ Permission checks are not used in ProjectController
- ⛔ Permission checks are not enforced in UI
- ⛔ No confirmation dialog for delete (may be missing)
- ⛔ No view for archived projects

---

## Task List

### Task 1: Add Archive Fields to Project Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add archive-related fields to `Project` entity to support archive/restore functionality.

**Files to Modify**:
- `lib/features/tasks/domain/entities/project.dart`

**Implementation Steps**:
1. Add archive fields to `Project` entity:
   ```dart
   class Project {
     // ... existing fields ...
     final DateTime? deletedAt;
     final bool isArchived; // Whether project is archived
     final DateTime? archivedAt; // When project was archived
     final String? archivedBy; // Who archived the project
     
     const Project({
       // ... existing parameters ...
       this.deletedAt,
       this.isArchived = false,
       this.archivedAt,
       this.archivedBy,
     });
   }
   ```

2. Update `fromMap` factory:
   ```dart
   factory Project.fromMap(Map<dynamic, dynamic> map) {
     return Project(
       // ... existing fields ...
       deletedAt: map['deletedAt'] != null
           ? DateTime.fromMillisecondsSinceEpoch(map['deletedAt'] as int)
           : null,
       isArchived: (map['isArchived'] as bool?) ?? false,
       archivedAt: map['archivedAt'] != null
           ? DateTime.fromMillisecondsSinceEpoch(map['archivedAt'] as int)
           : null,
       archivedBy: map['archivedBy'] as String?,
     );
   }
   ```

3. Update `toMap` method:
   ```dart
   Map<String, dynamic> toMap() {
     return <String, dynamic>{
       // ... existing fields ...
       'deletedAt': deletedAt?.millisecondsSinceEpoch,
       'isArchived': isArchived,
       'archivedAt': archivedAt?.millisecondsSinceEpoch,
       'archivedBy': archivedBy,
     };
   }
   ```

4. Update `copyWith` method to include new fields

**Expected Results**:
- ✅ Archive fields are added to Project entity
- ✅ Entity supports archive/restore
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity creation with archive fields
- Test: Verify archive fields are included in toMap/fromMap

---

### Task 2: Create Archive Project Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case for archiving projects.

**Files to Create**:
- `lib/features/tasks/domain/usecases/archive_project.dart` (new file)

**Implementation Steps**:
1. Create `ArchiveProject` use case:
   ```dart
   class ArchiveProject implements UseCase<void, ArchiveProjectParams> {
     final ProjectRepository _repository;
     
     ArchiveProject(this._repository);
     
     @override
     Future<Either<Failure, void>> call(ArchiveProjectParams params) async {
       // 1. Get project
       // 2. Validate project exists
       // 3. Validate project is not already archived
       // 4. Update project: isArchived = true, archivedAt = now, archivedBy = userId
       // 5. Save to repository
       // 6. Return success
     }
   }
   ```

2. Create `ArchiveProjectParams`:
   ```dart
   class ArchiveProjectParams {
     final String workspaceId;
     final String projectId;
     final String userId;
     
     const ArchiveProjectParams({
       required this.workspaceId,
       required this.projectId,
       required this.userId,
     });
   }
   ```

3. Add validation:
   - Project must exist
   - Project must not be already archived
   - User must have `manageProjects` permission

4. Handle errors:
   - Project not found
   - Project already archived
   - Permission denied
   - Network errors

**Expected Results**:
- ✅ Archive use case exists
- ✅ Validation works correctly
- ✅ Project is archived in Firebase
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test archive use case
- Test: Verify project is archived
- Test: Verify validation works

---

### Task 3: Create Restore Project Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case for restoring archived projects.

**Files to Create**:
- `lib/features/tasks/domain/usecases/restore_project.dart` (new file)

**Implementation Steps**:
1. Create `RestoreProject` use case:
   ```dart
   class RestoreProject implements UseCase<void, RestoreProjectParams> {
     final ProjectRepository _repository;
     
     RestoreProject(this._repository);
     
     @override
     Future<Either<Failure, void>> call(RestoreProjectParams params) async {
       // 1. Get project
       // 2. Validate project exists
       // 3. Validate project is archived
       // 4. Update project: isArchived = false, archivedAt = null, archivedBy = null
       // 5. Save to repository
       // 6. Return success
     }
   }
   ```

2. Create `RestoreProjectParams`:
   ```dart
   class RestoreProjectParams {
     final String workspaceId;
     final String projectId;
     final String userId;
     
     const RestoreProjectParams({
       required this.workspaceId,
       required this.projectId,
       required this.userId,
     });
   }
   ```

3. Add validation:
   - Project must exist
   - Project must be archived
   - User must have `manageProjects` permission

4. Handle errors appropriately

**Expected Results**:
- ✅ Restore use case exists
- ✅ Validation works correctly
- ✅ Project is restored in Firebase
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test restore use case
- Test: Verify project is restored
- Test: Verify validation works

---

### Task 4: Add Archive/Restore Methods to ProjectRepository

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add archive and restore methods to ProjectRepository interface and implementation.

**Files to Modify**:
- `lib/features/tasks/domain/repositories/project_repository.dart`
- `lib/features/tasks/data/repositories/project_repository_impl.dart`

**Implementation Steps**:
1. Add methods to `ProjectRepository` interface:
   ```dart
   /// Archive a project
   Future<Project> archiveProject({
     required String workspaceId,
     required String projectId,
     required String userId,
   });
   
   /// Restore an archived project
   Future<Project> restoreProject({
     required String workspaceId,
     required String projectId,
     required String userId,
   });
   
   /// Get archived projects
   Future<List<Project>> getArchivedProjects({
     required String workspaceId,
   });
   ```

2. Implement methods in `ProjectRepositoryImpl`:
   ```dart
   @override
   Future<Project> archiveProject({
     required String workspaceId,
     required String projectId,
     required String userId,
   }) async {
     try {
       // Get project
       final project = await _firebaseService.getProject(
         workspaceId: workspaceId,
         projectId: projectId,
       );
       
       if (project == null) {
         throw ProjectRepositoryException('Project not found');
       }
       
       // Update project
       final archivedProject = project.copyWith(
         isArchived: true,
         archivedAt: DateTime.now(),
         archivedBy: userId,
       );
       
       // Save to Firebase
       await _firebaseService.updateProject(
         workspaceId: workspaceId,
         project: archivedProject,
       );
       
       return archivedProject;
     } catch (e) {
       throw ProjectRepositoryException('Failed to archive project: $e');
     }
   }
   ```

3. Implement `restoreProject` similarly

4. Implement `getArchivedProjects`:
   ```dart
   @override
   Future<List<Project>> getArchivedProjects({
     required String workspaceId,
   }) async {
     try {
       final allProjects = await _firebaseService.listProjects(
         workspaceId: workspaceId,
       );
       return allProjects.where((p) => p.isArchived).toList();
     } catch (e) {
       throw ProjectRepositoryException('Failed to get archived projects: $e');
     }
   }
   ```

**Expected Results**:
- ✅ Archive/restore methods exist in repository
- ✅ Methods work correctly
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test repository methods
- Integration test: Test with Firebase

---

### Task 5: Add Archive/Restore Methods to FirebaseDatabaseService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add archive and restore methods to FirebaseDatabaseService (if needed, or use existing updateProject).

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`

**Implementation Steps**:
1. Check if `updateProject` can be used for archive/restore:
   - If yes, no new methods needed
   - If no, add specific methods

2. If needed, add methods:
   ```dart
   Future<void> archiveProject({
     required String workspaceId,
     required String projectId,
     required String userId,
   }) async {
     try {
       final ref = _projectsRef(workspaceId).child(projectId);
       await ref.update({
         'isArchived': true,
         'archivedAt': DateTime.now().millisecondsSinceEpoch,
         'archivedBy': userId,
       });
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to archive project: $e');
     }
   }
   
   Future<void> restoreProject({
     required String workspaceId,
     required String projectId,
   }) async {
     try {
       final ref = _projectsRef(workspaceId).child(projectId);
       await ref.update({
         'isArchived': false,
         'archivedAt': null,
         'archivedBy': null,
       });
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to restore project: $e');
     }
   }
   ```

**Expected Results**:
- ✅ Archive/restore methods exist in FirebaseDatabaseService (if needed)
- ✅ Methods work correctly
- ✅ Error handling is robust

**Test Criteria**:
- Test: Archive project, verify Firebase data
- Test: Restore project, verify Firebase data

---

### Task 6: Add Archive/Restore Methods to ProjectController

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add archive and restore methods to ProjectController with permission checks.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/project_controller.dart`

**Implementation Steps**:
1. Add archive method:
   ```dart
   Future<void> archiveProject(String projectId) async {
     try {
       _isLoading.value = true;
       _errorMessage.value = '';
       
       // Permission check
       final authController = _authController ?? Get.find<AuthController>();
       final currentUser = authController.currentUser;
       if (currentUser == null) {
         throw Exception('User not logged in');
       }
       
       final permissionService = Get.find<PermissionService>();
       final canManage = await permissionService.canManageProject(
         currentUser.id,
         _workspaceContext.currentWorkspaceId,
       );
       
       if (!canManage) {
         SnackbarService().showError(
           title: AppStrings.error,
           message: AppStrings.permissionDenied,
         );
         return;
       }
       
       // Archive project
       final archivedProject = await _projectRepository.archiveProject(
         workspaceId: _workspaceContext.currentWorkspaceId,
         projectId: projectId,
         userId: currentUser.id,
       );
       
       // Update in local list
       final index = _projects.indexWhere((p) => p.id == projectId);
       if (index != -1) {
         _projects[index] = archivedProject;
       }
       
       SnackbarService().showSuccess(
         title: AppStrings.success,
         message: AppStrings.projectArchived,
       );
     } catch (e) {
       _errorMessage.value = '${AppStrings.errorOccurred}: $e';
       SnackbarService().showError(
         title: AppStrings.error,
         message: e.toString(),
       );
     } finally {
       _isLoading.value = false;
     }
   }
   ```

2. Add restore method similarly

3. Add method to get archived projects:
   ```dart
   Future<List<Project>> getArchivedProjects() async {
     try {
       return await _projectRepository.getArchivedProjects(
         workspaceId: _workspaceContext.currentWorkspaceId,
       );
     } catch (e) {
       throw ProjectControllerException('Failed to get archived projects: $e');
     }
   }
   ```

4. Add AppStrings:
   ```dart
   static const String projectArchived = 'Project archived successfully';
   static const String projectRestored = 'Project restored successfully';
   static const String archiveProject = 'Archive Project';
   static const String restoreProject = 'Restore Project';
   ```

**Expected Results**:
- ✅ Archive/restore methods exist in controller
- ✅ Permission checks are enforced
- ✅ Success/error handling works correctly

**Test Criteria**:
- Unit test: Test controller methods
- Test: Verify permission checks work
- Test: Verify archive/restore works

---

### Task 7: Add Permission Checks to Existing CRUD Methods

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add permission checks to existing `createProject`, `updateProject`, and `deleteProject` methods in ProjectController.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/project_controller.dart`

**Implementation Steps**:
1. Update `createProject` method:
   ```dart
   Future<void> createProject({
     required String title,
     String? description,
     DateTime? deadline,
   }) async {
     try {
       _isLoading.value = true;
       _errorMessage.value = '';
       
       // Permission check
       final authController = _authController ?? Get.find<AuthController>();
       final currentUser = authController.currentUser;
       if (currentUser == null) {
         SnackbarService().showError(
           title: AppStrings.error,
           message: 'User not logged in',
         );
         return;
       }
       
       final permissionService = Get.find<PermissionService>();
       final canCreate = await permissionService.canCreateProject(
         currentUser.id,
         _workspaceContext.currentWorkspaceId,
       );
       
       if (!canCreate) {
         SnackbarService().showError(
           title: AppStrings.error,
           message: AppStrings.permissionDenied,
         );
         return;
       }
       
       // ... existing create code ...
     } catch (e) {
       // ... error handling ...
     }
   }
   ```

2. Update `updateProject` method:
   - Add permission check for `manageProjects`
   - Show error if permission denied

3. Update `deleteProject` method:
   - Add permission check for `manageProjects`
   - Show error if permission denied

**Expected Results**:
- ✅ Permission checks are added to all CRUD methods
- ✅ Permission checks are enforced
- ✅ Error messages are clear

**Test Criteria**:
- Test: Try to create project without permission, verify error
- Test: Try to edit project without permission, verify error
- Test: Try to delete project without permission, verify error

---

### Task 8: Add Permission Checks to UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add role-based permission checks to UI to show/hide buttons based on user permissions.

**Files to Modify**:
- `lib/app/pages/projects/project_list_page.dart`
- `lib/features/tasks/presentation/pages/project_list_page.dart`

**Implementation Steps**:
1. Add permission check helper:
   ```dart
   Future<bool> _canCreateProject() async {
     final authController = Get.find<AuthController>();
     final currentUser = authController.currentUser;
     if (currentUser == null) return false;
     
     final permissionService = Get.find<PermissionService>();
     final workspaceController = Get.find<WorkspaceController>();
     final workspaceId = workspaceController.currentWorkspace.value?.id;
     if (workspaceId == null) return false;
     
     return await permissionService.canCreateProject(
       currentUser.id,
       workspaceId,
     );
   }
   
   Future<bool> _canManageProject() async {
     // Similar implementation for manageProjects permission
   }
   ```

2. Update UI to check permissions:
   ```dart
   floatingActionButton: FutureBuilder<bool>(
     future: _canCreateProject(),
     builder: (context, snapshot) {
       if (snapshot.data == true) {
         return FloatingActionButton(
           onPressed: () => _showCreateProjectDialog(context),
           child: const Icon(Icons.add),
         );
       }
       return const SizedBox.shrink();
     },
   ),
   ```

3. Update edit/delete buttons:
   ```dart
   FutureBuilder<bool>(
     future: _canManageProject(),
     builder: (context, snapshot) {
       if (snapshot.data == true) {
         return IconButton(
           icon: const Icon(Icons.edit),
           onPressed: () => _editProject(project),
         );
       }
       return const SizedBox.shrink();
     },
   ),
   ```

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Permission checks are enforced in UI
- ✅ Buttons are shown/hidden based on permissions
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: View project list as Member, verify buttons are hidden
- Test: View project list as Admin, verify buttons are visible
- Test: Verify permission checks work correctly

---

### Task 9: Add Confirmation Dialog for Delete

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add confirmation dialog before deleting project.

**Files to Modify**:
- `lib/app/pages/projects/project_list_page.dart`
- `lib/features/tasks/presentation/pages/project_list_page.dart`

**Implementation Steps**:
1. Create confirmation dialog:
   ```dart
   Future<bool> _showDeleteConfirmationDialog(BuildContext context, Project project) async {
     return await showDialog<bool>(
       context: context,
       builder: (context) => AlertDialog(
         title: Text(AppStrings.deleteProject),
         content: Text(AppStrings.deleteProjectConfirmation(project.title)),
         actions: [
           TDButton(
             label: AppStrings.cancel,
             onPressed: () => Navigator.of(context).pop(false),
           ),
           TDButton(
             label: AppStrings.delete,
             type: TDButtonType.danger,
             onPressed: () => Navigator.of(context).pop(true),
           ),
         ],
       ),
     ) ?? false;
   }
   ```

2. Update delete handler:
   ```dart
   Future<void> _onProjectDelete(Project project) async {
     final confirmed = await _showDeleteConfirmationDialog(context, project);
     if (!confirmed) return;
     
     // Proceed with deletion
     await controller.deleteProject(project.id);
   }
   ```

3. Add AppStrings:
   ```dart
   static const String deleteProject = 'Delete Project';
   static String deleteProjectConfirmation(String projectName) => 
     'Are you sure you want to delete "$projectName"? This action cannot be undone.';
   ```

**Expected Results**:
- ✅ Confirmation dialog appears before deletion
- ✅ Confirmation cannot be bypassed
- ✅ Dialog is clear and informative

**Test Criteria**:
- Manual test: Delete project, verify confirmation dialog appears
- Test: Cancel deletion, verify project is not deleted
- Test: Confirm deletion, verify project is deleted

---

### Task 10: Create Archive/Restore UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI for archiving and restoring projects.

**Files to Create/Modify**:
- `lib/app/pages/projects/project_list_page.dart` (modify)
- `lib/features/tasks/presentation/pages/project_list_page.dart` (modify)

**Implementation Steps**:
1. Add "Archive" button to project card:
   ```dart
   PopupMenuButton<String>(
     onSelected: (value) {
       switch (value) {
         case 'archive':
           _archiveProject(project);
           break;
         case 'restore':
           _restoreProject(project);
           break;
         // ... other options
       }
     },
     itemBuilder: (context) => [
       if (!project.isArchived)
         PopupMenuItem(
           value: 'archive',
           child: Row(
             children: [
               Icon(Icons.archive),
               SizedBox(width: 8),
               Text(AppStrings.archiveProject),
             ],
           ),
         ),
       if (project.isArchived)
         PopupMenuItem(
           value: 'restore',
           child: Row(
             children: [
               Icon(Icons.unarchive),
               SizedBox(width: 8),
               Text(AppStrings.restoreProject),
             ],
           ),
         ),
     ],
   )
   ```

2. Add archive handler:
   ```dart
   Future<void> _archiveProject(Project project) async {
     final confirmed = await _showArchiveConfirmationDialog(context, project);
     if (!confirmed) return;
     
     await controller.archiveProject(project.id);
   }
   ```

3. Add restore handler similarly

4. Add confirmation dialogs for archive/restore

5. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Archive/restore UI exists
- ✅ Archive option is available for active projects
- ✅ Restore option is available for archived projects
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Archive project via UI
- Test: Restore project via UI
- Test: Verify UI works correctly

---

### Task 11: Create Archived Projects View

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI to view archived projects separately from active projects.

**Files to Create/Modify**:
- `lib/app/pages/projects/archived_projects_page.dart` (new file)
- `lib/app/pages/projects/project_list_page.dart` (modify)

**Implementation Steps**:
1. Create `ArchivedProjectsPage`:
   ```dart
   class ArchivedProjectsPage extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return GetBuilder<ProjectController>(
         builder: (controller) => Scaffold(
           appBar: TDAppBar(
             title: AppStrings.archivedProjects,
           ),
           body: Obx(() {
             if (controller.isLoading) {
               return TDLoadingIndicator();
             }
             
             final archivedProjects = controller.archivedProjects;
             
             if (archivedProjects.isEmpty) {
               return _buildEmptyState();
             }
             
             return ListView.builder(
               itemCount: archivedProjects.length,
               itemBuilder: (context, index) {
                 final project = archivedProjects[index];
                 return _buildArchivedProjectCard(project, controller);
               },
             );
           }),
         ),
       );
     }
   }
   ```

2. Add "View Archived" button to Project List page:
   - Show only if user has `manageProjects` permission
   - Navigate to ArchivedProjectsPage when tapped

3. Add restore button to archived project cards

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Archived projects view exists
- ✅ Archived projects are displayed
- ✅ Restore option is available
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: View archived projects
- Test: Restore project from archived view
- Test: Verify archived projects are filtered correctly

---

### Task 12: Filter Projects by Archive Status

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Update project loading to filter out archived projects from active list, and provide option to show archived.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/project_controller.dart`
- `lib/features/tasks/data/repositories/project_repository_impl.dart`

**Implementation Steps**:
1. Update `_loadProjects` method:
   ```dart
   Future<void> _loadProjects({bool includeArchived = false}) async {
     try {
       _isLoading.value = true;
       
       final projects = await _projectRepository.getProjects(
         workspaceId: _workspaceContext.currentWorkspaceId,
       );
       
       // Filter archived projects
       if (!includeArchived) {
         _projects.value = projects.where((p) => !p.isArchived).toList();
       } else {
         _projects.value = projects;
       }
     } catch (e) {
       // ... error handling ...
     } finally {
       _isLoading.value = false;
     }
   }
   ```

2. Update repository to support filtering:
   ```dart
   Future<List<Project>> getProjects({
     required String workspaceId,
     String? status,
     bool? includeArchived,
   }) async {
     // Get all projects
     // Filter by archive status if specified
   }
   ```

3. Add toggle in UI to show/hide archived projects (optional)

**Expected Results**:
- ✅ Archived projects are filtered from active list
- ✅ Option to include archived projects exists
- ✅ Filtering works correctly

**Test Criteria**:
- Test: Load projects, verify archived are filtered out
- Test: Load with includeArchived, verify all projects are shown

---

### Task 13: Add Unit Tests for Project CRUD & Lifecycle

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for project CRUD and lifecycle functionality.

**Files to Create**:
- `test/features/tasks/domain/usecases/archive_project_test.dart`
- `test/features/tasks/domain/usecases/restore_project_test.dart`
- `test/features/tasks/presentation/controllers/project_controller_crud_test.dart`

**Implementation Steps**:
1. Test `ArchiveProject` use case:
   - Test archiving project
   - Test validation (project not found, already archived)
   - Test permission checks

2. Test `RestoreProject` use case:
   - Test restoring project
   - Test validation (project not found, not archived)
   - Test permission checks

3. Test `ProjectController` CRUD methods:
   - Test create with permission check
   - Test update with permission check
   - Test delete with permission check
   - Test archive with permission check
   - Test restore with permission check

**Expected Results**:
- ✅ Unit tests cover project CRUD and lifecycle
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Add Archive Fields to Project Entity (Critical - Foundation)
2. **Task 2**: Create Archive Project Use Case (High Priority - Core Feature)
3. **Task 3**: Create Restore Project Use Case (High Priority - Core Feature)
4. **Task 4**: Add Archive/Restore Methods to ProjectRepository (High Priority - Data Layer)
5. **Task 5**: Add Archive/Restore Methods to FirebaseDatabaseService (High Priority - Data Layer)
6. **Task 6**: Add Archive/Restore Methods to ProjectController (High Priority - Controller Layer)
7. **Task 7**: Add Permission Checks to Existing CRUD Methods (High Priority - Security)
8. **Task 8**: Add Permission Checks to UI (High Priority - Security)
9. **Task 9**: Add Confirmation Dialog for Delete (Medium Priority - UX)
10. **Task 10**: Create Archive/Restore UI (High Priority - UI)
11. **Task 11**: Create Archived Projects View (Medium Priority - UI)
12. **Task 12**: Filter Projects by Archive Status (Medium Priority - Feature Enhancement)
13. **Task 13**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Projects can be created with permission checks
- ✅ Projects can be edited with permission checks
- ✅ Projects can be deleted with permission checks
- ✅ Projects can be archived with permission checks
- ✅ Projects can be restored with permission checks
- ✅ Archived projects can be viewed
- ✅ Permission checks are enforced in UI and controller
- ✅ Confirmation dialogs appear for destructive operations
- ✅ Projects are filtered by workspace and archive status
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ No known bugs or issues

---

## Dependencies

- **ProjectRepository**: Required for project operations
- **PermissionService**: Required for permission checks
- **WorkspaceController**: Required for workspace context
- **AuthController**: Required for current user
- **Firebase Realtime Database**: Required for storing projects
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications

---

## Notes

1. **Archive vs Delete**: Archive should be different from delete:
   - Archive: Hide project but keep data (can be restored)
   - Delete: Soft delete (sets deletedAt, may be restorable)
   - Permanent Delete: Remove completely (cannot be restored)

2. **Permission Checks**: Need to add permission checks at multiple levels:
   - UI level: Show/hide buttons based on permissions
   - Controller level: Check permissions before operations
   - Repository level: Validate permissions (optional, for extra security)

3. **Workspace Filtering**: Projects are already filtered by workspace (workspaceId), which is good. This is workspace-based filtering.

4. **Role-Based UI Checks**: Need to add role-based UI checks to show/hide buttons based on user permissions, not just workspace membership.

5. **Soft Delete**: `softDeleteProject` exists and sets `deletedAt` field. This is different from archive. Need to clarify:
   - Archive: `isArchived = true` (can be restored)
   - Delete: `deletedAt != null` (soft delete, may be restorable)
   - Both can coexist (project can be archived AND deleted)

6. **Permission Service**: `PermissionService` has `canCreateProject` and `canManageProject` methods, but they're not used in ProjectController. Need to integrate them.

7. **Confirmation Dialogs**: Should be clear and informative, especially for destructive operations like delete and archive.

---

## Related Documentation

- `PROJECTS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `PROJECT_CRUD_LIFECYCLE_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/workspace/WORKSPACE_ARCHIVE_TASKS.md` - Related workspace archive tasks
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/SECURITY_RULES.md` - Security requirements
