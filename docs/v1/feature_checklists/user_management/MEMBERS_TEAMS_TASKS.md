# Members & Teams (Add/Remove User to Team/Group, Assign Lead, Cascading) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Members & Teams** feature (add/remove user to Team/Group, assign lead, cascading permissions). Currently, this feature is **PARTIAL** - workspace hierarchy helpers exist (`WorkspaceRepositoryImpl.updateManager/listTeam`, `WorkspaceMember.managerUserId`), but Team/Group assignment UI/flows, cascading permission enforcement to tasks/projects, and user listing/filter by role/status UI are missing.

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `WorkspaceRepositoryImpl.updateManager` - can update manager for a user
- ✅ `WorkspaceRepositoryImpl.listTeam` - can list team members for a manager
- ✅ `WorkspaceMember.managerUserId` - field exists to track manager
- ✅ `TeamGroup` entity - exists with `leadGroupUserId` and `members` list
- ✅ Team Management page exists (may have TODOs)
- ✅ Team Detail page exists (may have TODOs)

### What's Missing/Broken:
- ⛔ Team/Group assignment UI/flows - no UI to add/remove users from teams
- ⛔ Cascading permission enforcement - permissions don't cascade to tasks/projects when user joins team
- ⛔ User listing/filter by role/status UI - no filters for role, status, or team
- ⛔ Assign lead UI - no UI to assign lead to teams
- ⛔ Permission enforcement after team changes - permissions not updated automatically

---

## Task List

### Task 1: Create Add User to Team Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to add user to team, updating TeamGroup.members and WorkspaceMember.managerUserId if applicable.

**Files to Create**:
- `lib/features/workspace/domain/usecases/add_user_to_team.dart` (new file)

**Implementation Steps**:
1. Create `AddUserToTeam` use case:
   ```dart
   class AddUserToTeam {
     final WorkspaceRepository _repository;
     
     AddUserToTeam(this._repository);
     
     Future<Either<Failure, TeamGroup>> call({
       required String workspaceId,
       required String teamId,
       required String userId,
       String? managerUserId,
     }) async {
       // 1. Get team
       // 2. Verify user is not already in team
       // 3. Add user to team.members
       // 4. Update managerUserId if provided
       // 5. Save to Firebase
       // 6. Trigger cascading permissions (if implemented)
       // 7. Return updated team
     }
   }
   ```

2. Add validation:
   - User must exist in workspace
   - User must not already be in team
   - Manager must exist (if provided)
   - Permission check: only Account Holder/Admin can add users

3. Update TeamGroup:
   - Add userId to `members` list
   - Update `updatedAt` timestamp

4. Update WorkspaceMember:
   - Set `managerUserId` if provided
   - Update `updatedAt` timestamp

5. Save to Firebase:
   - Update `TeamGroup` in Firebase
   - Update `WorkspaceMember` in Firebase

**Expected Results**:
- ✅ Use case exists
- ✅ User is added to team
- ✅ Team membership is saved to Firebase
- ✅ Manager relationship is updated (if provided)
- ✅ Validation works correctly

**Test Criteria**:
- Unit test: Test adding user to team
- Test: Verify user appears in team members list
- Test: Verify Firebase data is updated

---

### Task 2: Create Remove User from Team Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to remove user from team, updating TeamGroup.members and clearing WorkspaceMember.managerUserId if applicable.

**Files to Create**:
- `lib/features/workspace/domain/usecases/remove_user_from_team.dart` (new file)

**Implementation Steps**:
1. Create `RemoveUserFromTeam` use case:
   ```dart
   class RemoveUserFromTeam {
     final WorkspaceRepository _repository;
     
     RemoveUserFromTeam(this._repository);
     
     Future<Either<Failure, TeamGroup>> call({
       required String workspaceId,
       required String teamId,
       required String userId,
     }) async {
       // 1. Get team
       // 2. Verify user is in team
       // 3. Remove user from team.members
       // 4. Clear managerUserId if user was manager's direct report
       // 5. Save to Firebase
       // 6. Trigger cascading permissions revocation (if implemented)
       // 7. Return updated team
     }
   }
   ```

2. Add validation:
   - User must be in team
   - Cannot remove team lead (need to change lead first)
   - Permission check: only Account Holder/Admin can remove users

3. Update TeamGroup:
   - Remove userId from `members` list
   - Update `updatedAt` timestamp

4. Update WorkspaceMember:
   - Clear `managerUserId` if user was manager's direct report
   - Update `updatedAt` timestamp

5. Save to Firebase

**Expected Results**:
- ✅ Use case exists
- ✅ User is removed from team
- ✅ Team membership is updated in Firebase
- ✅ Manager relationship is cleared (if applicable)
- ✅ Validation works correctly

**Test Criteria**:
- Unit test: Test removing user from team
- Test: Verify user no longer appears in team members list
- Test: Verify Firebase data is updated

---

### Task 3: Create Assign Lead to Team Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to assign lead to team, updating TeamGroup.leadGroupUserId and applying Lead role permissions.

**Files to Create**:
- `lib/features/workspace/domain/usecases/assign_lead_to_team.dart` (new file)

**Implementation Steps**:
1. Create `AssignLeadToTeam` use case:
   ```dart
   class AssignLeadToTeam {
     final WorkspaceRepository _repository;
     
     AssignLeadToTeam(this._repository);
     
     Future<Either<Failure, TeamGroup>> call({
       required String workspaceId,
       required String teamId,
       required String userId,
     }) async {
       // 1. Get team
       // 2. Verify user exists in workspace
       // 3. Update team.leadGroupUserId
       // 4. Update user's role to Lead (if Lead role exists)
       // 5. Apply Lead permissions (if cascading is implemented)
       // 6. Save to Firebase
       // 7. Return updated team
     }
   }
   ```

2. Add validation:
   - User must exist in workspace
   - User should ideally be member of team (or add to team automatically)
   - Permission check: only Account Holder/Admin can assign lead

3. Update TeamGroup:
   - Set `leadGroupUserId` to userId
   - Update `updatedAt` timestamp

4. Update WorkspaceMember:
   - Set role to Lead (if Lead role exists in WorkspaceRole)
   - Apply Lead permissions (from DefaultPermissionSets)
   - Update `updatedAt` timestamp

5. Save to Firebase

**Expected Results**:
- ✅ Use case exists
- ✅ Lead is assigned to team
- ✅ Lead role/permissions are applied
- ✅ Team is updated in Firebase
- ✅ Validation works correctly

**Test Criteria**:
- Unit test: Test assigning lead to team
- Test: Verify lead is displayed in team
- Test: Verify Lead permissions are applied

---

### Task 4: Create Cascading Permission Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service to handle cascading permissions when users join/leave teams, ensuring permissions cascade to tasks/projects.

**Files to Create**:
- `lib/core/services/cascading_permission_service.dart` (new file)

**Implementation Steps**:
1. Create `CascadingPermissionService`:
   ```dart
   class CascadingPermissionService {
     final PermissionService _permissionService;
     final WorkspaceRepository _workspaceRepository;
     
     /// Apply cascading permissions when user joins team
     Future<void> applyTeamPermissions({
       required String userId,
       required String workspaceId,
       required String teamId,
     }) async {
       // 1. Get team
       // 2. Get team's default permissions (from team settings or role)
       // 3. Get user's current permissions
       // 4. Merge team permissions with user permissions
       // 5. Update user's permissions in workspace
       // 6. Update task/project access (if needed)
     }
     
     /// Revoke cascading permissions when user leaves team
     Future<void> revokeTeamPermissions({
       required String userId,
       required String workspaceId,
       required String teamId,
     }) async {
       // 1. Get team permissions that were applied
       // 2. Remove team permissions from user
       // 3. Update user's permissions in workspace
       // 4. Revoke task/project access (if needed)
     }
     
     /// Update permissions for all team members (when team permissions change)
     Future<void> updateTeamMemberPermissions({
       required String workspaceId,
       required String teamId,
     }) async {
       // 1. Get all team members
       // 2. For each member, apply updated team permissions
     }
   }
   ```

2. Integrate with PermissionService:
   - Use `PermissionService.hasPermission` to check permissions
   - Use `WorkspaceRepository.updateMemberPermissions` to update permissions

3. Handle task/project access:
   - When user joins team, grant access to team's tasks/projects
   - When user leaves team, revoke access to team's tasks/projects
   - Use task/project filtering services

4. Cache permission changes for performance

**Expected Results**:
- ✅ Cascading permission service exists
- ✅ Permissions cascade when user joins team
- ✅ Permissions are revoked when user leaves team
- ✅ Task/project access is updated automatically

**Test Criteria**:
- Unit test: Test cascading permissions
- Test: Verify permissions are applied when user joins team
- Test: Verify permissions are revoked when user leaves team

---

### Task 5: Integrate Cascading Permissions with Team Operations

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Integrate cascading permission service with add/remove user to team operations.

**Files to Modify**:
- `lib/features/workspace/domain/usecases/add_user_to_team.dart`
- `lib/features/workspace/domain/usecases/remove_user_from_team.dart`

**Implementation Steps**:
1. Update `AddUserToTeam` use case:
   ```dart
   Future<Either<Failure, TeamGroup>> call(...) async {
     // ... existing code ...
     
     // After adding user to team
     await _cascadingPermissionService.applyTeamPermissions(
       userId: userId,
       workspaceId: workspaceId,
       teamId: teamId,
     );
     
     // ... rest of code ...
   }
   ```

2. Update `RemoveUserFromTeam` use case:
   ```dart
   Future<Either<Failure, TeamGroup>> call(...) async {
     // ... existing code ...
     
     // Before removing user from team
     await _cascadingPermissionService.revokeTeamPermissions(
       userId: userId,
       workspaceId: workspaceId,
       teamId: teamId,
     );
     
     // ... rest of code ...
   }
   ```

3. Handle errors:
   - If cascading fails, rollback team membership change
   - Show appropriate error messages

**Expected Results**:
- ✅ Cascading permissions are triggered when user joins team
- ✅ Cascading permissions are triggered when user leaves team
- ✅ Errors are handled gracefully

**Test Criteria**:
- Test: Add user to team, verify permissions cascade
- Test: Remove user from team, verify permissions are revoked
- Test: Verify error handling works

---

### Task 6: Create Add User to Team UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI to add users to teams, with user selection and confirmation.

**Files to Create/Modify**:
- `lib/app/pages/team/widgets/add_user_to_team_dialog.dart` (new file)
- `lib/app/pages/team/team_group_detail_page.dart` (modify)

**Implementation Steps**:
1. Create `AddUserToTeamDialog`:
   ```dart
   class AddUserToTeamDialog extends StatelessWidget {
     final String teamId;
     final String workspaceId;
     
     @override
     Widget build(BuildContext context) {
       return AlertDialog(
         title: Text(AppStrings.addUserToTeam),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             // User search field
             TDTextField(
               controller: _searchController,
               hint: AppStrings.searchUsers,
             ),
             // User list
             Obx(() => ListView.builder(
               itemCount: _availableUsers.length,
               itemBuilder: (context, index) {
                 final user = _availableUsers[index];
                 return ListTile(
                   title: Text(user.displayName),
                   subtitle: Text(user.email ?? ''),
                   onTap: () => _selectUser(user),
                 );
               },
             )),
           ],
         ),
         actions: [
           TDButton(
             label: AppStrings.cancel,
             onPressed: () => NavigationService().back<void>(),
           ),
           TDButton(
             label: AppStrings.add,
             onPressed: _handleAddUser,
           ),
         ],
       );
     }
   }
   ```

2. Add "Add Member" button to Team Detail page:
   - Show button only if user has `manageUsers` permission
   - Open `AddUserToTeamDialog` when tapped

3. Use TD widgets and AppStrings

4. Handle loading and error states

**Expected Results**:
- ✅ Add user to team UI exists
- ✅ User selection works
- ✅ Users can be added to teams
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Add user to team via UI
- Test: Verify user appears in team members list
- Test: Verify permissions are applied (if cascading is implemented)

---

### Task 7: Create Remove User from Team UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI to remove users from teams, with confirmation dialog.

**Files to Create/Modify**:
- `lib/app/pages/team/widgets/remove_user_from_team_dialog.dart` (new file)
- `lib/app/pages/team/team_group_detail_page.dart` (modify)

**Implementation Steps**:
1. Create `RemoveUserFromTeamDialog`:
   ```dart
   class RemoveUserFromTeamDialog extends StatelessWidget {
     final String teamId;
     final String userId;
     final String userName;
     
     @override
     Widget build(BuildContext context) {
       return AlertDialog(
         title: Text(AppStrings.removeUserFromTeam),
         content: Text(AppStrings.confirmRemoveUserFromTeam(userName)),
         actions: [
           TDButton(
             label: AppStrings.cancel,
             onPressed: () => NavigationService().back<void>(),
           ),
           TDButton(
             label: AppStrings.remove,
             type: TDButtonType.danger,
             onPressed: _handleRemoveUser,
           ),
         ],
       );
     }
   }
   ```

2. Add "Remove" button to team member cards:
   - Show button only if user has `manageUsers` permission
   - Hide button for team lead
   - Open `RemoveUserFromTeamDialog` when tapped

3. Use TD widgets and AppStrings

4. Handle loading and error states

**Expected Results**:
- ✅ Remove user from team UI exists
- ✅ Confirmation dialog appears
- ✅ Users can be removed from teams
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Remove user from team via UI
- Test: Verify user no longer appears in team members list
- Test: Verify permissions are revoked (if cascading is implemented)

---

### Task 8: Create Assign Lead to Team UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI to assign lead to teams, with user selection.

**Files to Create/Modify**:
- `lib/app/pages/team/widgets/assign_lead_dialog.dart` (new file)
- `lib/app/pages/team/team_group_detail_page.dart` (modify)

**Implementation Steps**:
1. Create `AssignLeadDialog`:
   ```dart
   class AssignLeadDialog extends StatelessWidget {
     final String teamId;
     final String workspaceId;
     
     @override
     Widget build(BuildContext context) {
       return AlertDialog(
         title: Text(AppStrings.assignLead),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             // User search field
             TDTextField(
               controller: _searchController,
               hint: AppStrings.searchUsers,
             ),
             // User list (team members or all users)
             Obx(() => ListView.builder(
               itemCount: _availableUsers.length,
               itemBuilder: (context, index) {
                 final user = _availableUsers[index];
                 return ListTile(
                   title: Text(user.displayName),
                   subtitle: Text(user.email ?? ''),
                   onTap: () => _selectUser(user),
                 );
               },
             )),
           ],
         ),
         actions: [
           TDButton(
             label: AppStrings.cancel,
             onPressed: () => NavigationService().back<void>(),
           ),
           TDButton(
             label: AppStrings.assign,
             onPressed: _handleAssignLead,
           ),
         ],
       );
     }
   }
   ```

2. Add "Assign Lead" button to Team Detail page:
   - Show button only if user has `manageUsers` permission
   - Open `AssignLeadDialog` when tapped

3. Display current lead:
   - Show lead badge/indicator
   - Show lead name

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Assign lead UI exists
- ✅ Lead can be assigned to teams
- ✅ Current lead is displayed
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Assign lead to team via UI
- Test: Verify lead is displayed in team
- Test: Verify Lead permissions are applied

---

### Task 9: Create User Filter Service

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create service to filter users by role, status, and team.

**Files to Create**:
- `lib/core/services/user_filter_service.dart` (new file)

**Implementation Steps**:
1. Create `UserFilterService`:
   ```dart
   class UserFilterService {
     /// Filter users by role
     List<WorkspaceMember> filterByRole(
       List<WorkspaceMember> users,
       WorkspaceRole? role,
     ) {
       if (role == null) return users;
       return users.where((user) => user.role == role).toList();
     }
     
     /// Filter users by status
     List<WorkspaceMember> filterByStatus(
       List<WorkspaceMember> users,
       bool? isActive,
     ) {
       if (isActive == null) return users;
       return users.where((user) => user.isActive == isActive).toList();
     }
     
     /// Filter users by team
     Future<List<WorkspaceMember>> filterByTeam(
       List<WorkspaceMember> users,
       String? teamId,
       String workspaceId,
     ) async {
       if (teamId == null) return users;
       
       // Get team members
       final team = await _getTeam(teamId, workspaceId);
       final teamMemberIds = team.members.toSet();
       teamMemberIds.add(team.leadGroupUserId);
       
       return users.where((user) => teamMemberIds.contains(user.userId)).toList();
     }
     
     /// Filter users by multiple criteria
     Future<List<WorkspaceMember>> filterUsers({
       required List<WorkspaceMember> users,
       WorkspaceRole? role,
       bool? isActive,
       String? teamId,
       required String workspaceId,
     }) async {
       var filtered = users;
       
       if (role != null) {
         filtered = filterByRole(filtered, role);
       }
       
       if (isActive != null) {
         filtered = filterByStatus(filtered, isActive);
       }
       
       if (teamId != null) {
         filtered = await filterByTeam(filtered, teamId, workspaceId);
       }
       
       return filtered;
     }
   }
   ```

2. Add caching for performance

**Expected Results**:
- ✅ User filter service exists
- ✅ Users can be filtered by role, status, and team
- ✅ Combined filters work correctly

**Test Criteria**:
- Unit test: Test filtering by role, status, team
- Test: Verify combined filters work

---

### Task 10: Create User Filter UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI to filter users by role, status, and team in User Management page.

**Files to Modify**:
- `lib/app/pages/users/user_management_page.dart`
- `lib/app/pages/users/controllers/user_management_controller.dart`

**Implementation Steps**:
1. Add filter state to `UserManagementController`:
   ```dart
   final Rx<WorkspaceRole?> _selectedRole = Rx<WorkspaceRole?>(null);
   final Rx<bool?> _selectedStatus = Rx<bool?>(null);
   final Rx<String?> _selectedTeam = Rx<String?>(null);
   
   WorkspaceRole? get selectedRole => _selectedRole.value;
   bool? get selectedStatus => _selectedStatus.value;
   String? get selectedTeam => _selectedTeam.value;
   ```

2. Add filter UI to User Management page:
   ```dart
   Widget _buildFilterBar() {
     return Container(
       padding: EdgeInsets.all(16),
       child: Row(
         children: [
           // Role filter
           Expanded(
             child: DropdownButton<WorkspaceRole?>(
               value: controller.selectedRole,
               items: [
                 DropdownMenuItem(value: null, child: Text(AppStrings.allRoles)),
                 DropdownMenuItem(value: WorkspaceRole.accountHolder, child: Text(AppStrings.accountHolder)),
                 DropdownMenuItem(value: WorkspaceRole.admin, child: Text(AppStrings.admin)),
                 DropdownMenuItem(value: WorkspaceRole.member, child: Text(AppStrings.member)),
               ],
               onChanged: (value) => controller.setRoleFilter(value),
             ),
           ),
           SizedBox(width: 8),
           // Status filter
           Expanded(
             child: DropdownButton<bool?>(
               value: controller.selectedStatus,
               items: [
                 DropdownMenuItem(value: null, child: Text(AppStrings.allStatuses)),
                 DropdownMenuItem(value: true, child: Text(AppStrings.active)),
                 DropdownMenuItem(value: false, child: Text(AppStrings.locked)),
               ],
               onChanged: (value) => controller.setStatusFilter(value),
             ),
           ),
           SizedBox(width: 8),
           // Team filter
           Expanded(
             child: DropdownButton<String?>(
               value: controller.selectedTeam,
               items: [
                 DropdownMenuItem(value: null, child: Text(AppStrings.allTeams)),
                 // Add team options
               ],
               onChanged: (value) => controller.setTeamFilter(value),
             ),
           ),
         ],
       ),
     );
   }
   ```

3. Apply filters in controller:
   ```dart
   Future<void> applyFilters() async {
     final filtered = await _userFilterService.filterUsers(
       users: _workspaceMembers,
       role: _selectedRole.value,
       isActive: _selectedStatus.value,
       teamId: _selectedTeam.value,
       workspaceId: _workspaceId,
     );
     _filteredMembers.value = filtered;
   }
   ```

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ User filter UI exists
- ✅ Users can be filtered by role, status, and team
- ✅ Filters work correctly
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Filter users by role, status, team
- Test: Verify filtered results are correct
- Test: Verify combined filters work

---

### Task 11: Update Team Detail Page with Member Management

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Update Team Detail page to include add/remove member buttons and lead assignment.

**Files to Modify**:
- `lib/app/pages/team/team_group_detail_page.dart`

**Implementation Steps**:
1. Add "Add Member" button:
   - Show only if user has `manageUsers` permission
   - Open `AddUserToTeamDialog` when tapped

2. Add "Remove" button to member cards:
   - Show only if user has `manageUsers` permission
   - Hide for team lead
   - Open `RemoveUserFromTeamDialog` when tapped

3. Add "Assign Lead" button:
   - Show only if user has `manageUsers` permission
   - Open `AssignLeadDialog` when tapped

4. Display team member count:
   - Show count in header or summary
   - Update count when members are added/removed

5. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Team Detail page has member management UI
- ✅ Add/remove member buttons work
- ✅ Assign lead button works
- ✅ Team member count is displayed

**Test Criteria**:
- Manual test: Add/remove members via Team Detail page
- Test: Verify member count updates correctly

---

### Task 12: Add Permission Enforcement After Team Changes

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Ensure permission enforcement works correctly after team membership changes, updating task/project access immediately.

**Files to Modify**:
- `lib/core/services/cascading_permission_service.dart`
- `lib/features/tasks/presentation/controllers/task_controller.dart`
- `lib/features/projects/presentation/controllers/project_controller.dart`

**Implementation Steps**:
1. Update `CascadingPermissionService`:
   ```dart
   Future<void> applyTeamPermissions(...) async {
     // ... existing code ...
     
     // Update task access
     await _updateTaskAccess(userId, workspaceId, teamId);
     
     // Update project access
     await _updateProjectAccess(userId, workspaceId, teamId);
   }
   
   Future<void> _updateTaskAccess(String userId, String workspaceId, String teamId) async {
     // Get team's tasks
     // Grant user access to team's tasks
     // Update task filtering cache
   }
   
   Future<void> _updateProjectAccess(String userId, String workspaceId, String teamId) async {
     // Get team's projects
     // Grant user access to team's projects
     // Update project filtering cache
   }
   ```

2. Update task controller:
   - Refresh task list when team membership changes
   - Update task filtering cache

3. Update project controller:
   - Refresh project list when team membership changes
   - Update project filtering cache

4. Add listeners for team membership changes:
   - Listen to Firebase changes
   - Update permissions when team membership changes

**Expected Results**:
- ✅ Permissions are enforced immediately after team changes
- ✅ Task/project access is updated automatically
- ✅ Permission checks work correctly

**Test Criteria**:
- Test: Add user to team, verify task/project access is updated
- Test: Remove user from team, verify task/project access is revoked
- Test: Verify permission checks work correctly

---

### Task 13: Add Team Member Count Display

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Display team member count in Team Management and Team Detail pages.

**Files to Modify**:
- `lib/app/pages/team/team_management_page.dart`
- `lib/app/pages/team/team_group_detail_page.dart`

**Implementation Steps**:
1. Add member count to Team Management page:
   ```dart
   Widget _buildTeamCard(TeamGroup team) {
     return TDCard(
       child: ListTile(
         title: Text(team.name),
         subtitle: Text('${team.memberCount} members'),
         // ... rest of card ...
       ),
     );
   }
   ```

2. Add member count to Team Detail page:
   - Display in header or summary section
   - Update count when members are added/removed

3. Use AppStrings for labels

**Expected Results**:
- ✅ Team member count is displayed
- ✅ Count updates when members are added/removed
- ✅ UI is clear and easy to understand

**Test Criteria**:
- Manual test: Verify member count is displayed
- Test: Verify count updates correctly

---

### Task 14: Add Unit Tests for Members & Teams

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for members and teams functionality.

**Files to Create**:
- `test/features/workspace/domain/usecases/add_user_to_team_test.dart`
- `test/features/workspace/domain/usecases/remove_user_from_team_test.dart`
- `test/features/workspace/domain/usecases/assign_lead_to_team_test.dart`
- `test/core/services/cascading_permission_service_test.dart`
- `test/core/services/user_filter_service_test.dart`

**Implementation Steps**:
1. Test `AddUserToTeam` use case:
   - Test adding user to team
   - Test validation (user already in team, etc.)
   - Test permission checks

2. Test `RemoveUserFromTeam` use case:
   - Test removing user from team
   - Test validation (cannot remove lead, etc.)
   - Test permission checks

3. Test `AssignLeadToTeam` use case:
   - Test assigning lead
   - Test changing lead
   - Test permission checks

4. Test `CascadingPermissionService`:
   - Test applying team permissions
   - Test revoking team permissions
   - Test updating team member permissions

5. Test `UserFilterService`:
   - Test filtering by role, status, team
   - Test combined filters

**Expected Results**:
- ✅ Unit tests cover members and teams functionality
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Create Add User to Team Use Case (Critical - Foundation)
2. **Task 2**: Create Remove User from Team Use Case (Critical - Foundation)
3. **Task 3**: Create Assign Lead to Team Use Case (High Priority - Core Feature)
4. **Task 4**: Create Cascading Permission Service (High Priority - Core Feature)
5. **Task 5**: Integrate Cascading Permissions with Team Operations (High Priority - Integration)
6. **Task 6**: Create Add User to Team UI (High Priority - UI)
7. **Task 7**: Create Remove User from Team UI (High Priority - UI)
8. **Task 8**: Create Assign Lead to Team UI (High Priority - UI)
9. **Task 9**: Create User Filter Service (Medium Priority - Foundation)
10. **Task 10**: Create User Filter UI (Medium Priority - UI)
11. **Task 11**: Update Team Detail Page with Member Management (Medium Priority - UI)
12. **Task 12**: Add Permission Enforcement After Team Changes (High Priority - Integration)
13. **Task 13**: Add Team Member Count Display (Low Priority - UX Enhancement)
14. **Task 14**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Users can be added to teams via UI
- ✅ Users can be removed from teams via UI
- ✅ Lead can be assigned to teams via UI
- ✅ Permissions cascade to tasks/projects when user joins team
- ✅ Permissions are revoked when user leaves team
- ✅ Users can be filtered by role, status, and team
- ✅ Permission enforcement works after team changes
- ✅ Team member count is displayed
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ No known bugs or issues

---

## Dependencies

- **TeamGroup Entity**: Must exist with `members` and `leadGroupUserId` fields
- **WorkspaceMember Entity**: Must exist with `managerUserId` field
- **WorkspaceRepository**: Must have `updateManager` and `listTeam` methods
- **PermissionService**: Required for permission checks
- **Firebase Realtime Database**: Required for storing team membership
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications

---

## Notes

1. **Team Membership**: Users can be members of teams via `TeamGroup.members` list. This is separate from `WorkspaceMember.managerUserId` which tracks manager relationship.

2. **Cascading Permissions**: When user joins team, permissions should automatically cascade to tasks/projects assigned to that team. This requires integration with task/project filtering services.

3. **Lead Role**: Lead can be assigned to teams via `TeamGroup.leadGroupUserId`. Lead should get Lead role permissions (if Lead role exists in WorkspaceRole).

4. **Manager Relationship**: `WorkspaceMember.managerUserId` tracks manager relationship. This is separate from team membership but may be related (team lead may be manager).

5. **User Filtering**: Need UI to filter users by role, status, and team. This helps with user management.

6. **Permission Enforcement**: Need to ensure permissions are enforced immediately after team changes. This requires updating task/project access and permission checks.

7. **Multi-Team Membership**: Users may be members of multiple teams. Need to handle this case (combine permissions from all teams).

8. **Backward Compatibility**: Changes should maintain backward compatibility with existing team management functionality.

---

## Related Documentation

- `USER_MANAGEMENT_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `MEMBERS_TEAMS_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/workspace/PROJECTS_TEAMS_VISIBILITY_TASKS.md` - Related visibility tasks
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/SECURITY_RULES.md` - Security requirements

