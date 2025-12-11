# Projects & Teams Visibility + Access Rights by Role/Team - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Projects & Teams Visibility + Access Rights by Role/Team** feature. Currently, this feature is **PARTIAL** - team/group entities exist, but there's no enforcement path from workspace permissions to projects/tasks/teams views. Need guard rails to ensure data filtered by workspace + permissions before rendering.

## Current Status: ⚠️ PARTIAL

### What Works:
- ✅ Team/group entities exist: `TeamGroup` entity with workspaceId, members, leadGroupUserId
- ✅ Permissions exist: `WorkspacePermissions` has `viewAllData`, `viewTeamData`, `viewPersonalData`
- ✅ Permission service exists: `PermissionService` has methods like `canViewAllData`, `canViewTeamData`
- ✅ Data services filter by workspace: Firebase queries use workspaceId
- ✅ Role-based widgets exist: `RoleBasedWidget` can show/hide content based on permissions

### What's Missing/Broken:
- ⚠️ No enforcement path from workspace permissions to projects/tasks/teams views
- ⚠️ No guard rails ensuring data filtered by workspace + permissions before rendering
- ⚠️ Projects/tasks may not be filtered by team membership
- ⚠️ Permission checks may not be enforced before data rendering
- ⚠️ No interceptor/middleware to automatically apply permission filtering

---

## Task List

### Task 1: Create Permission-Based Data Filtering Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create a service that filters projects, tasks, and teams based on user permissions and team membership.

**Files to Create/Modify**:
- `lib/core/services/permission_based_filter_service.dart` (new file)
- `lib/features/workspace/domain/services/access_control_service.dart` (may need updates)

**Implementation Steps**:
1. Create `PermissionBasedFilterService`:
   - Methods to filter projects by permissions:
     - `filterProjectsByPermission(List<Project> projects, String userId, String workspaceId)`
     - Check user permissions (viewAllData, viewTeamData, viewPersonalData)
     - Filter projects based on permission scope
   - Methods to filter tasks by permissions:
     - `filterTasksByPermission(List<Task> tasks, String userId, String workspaceId)`
     - Check user permissions
     - Filter tasks based on permission scope
   - Methods to filter teams by permissions:
     - `filterTeamsByPermission(List<TeamGroup> teams, String userId, String workspaceId)`
     - Check user permissions
     - Filter teams based on permission scope
2. Implement permission-based filtering logic:
   - `viewAllData`: Return all data (no filtering)
   - `viewTeamData`: Filter by team membership
   - `viewPersonalData`: Filter by user ownership
3. Integrate with `PermissionService` to check permissions
4. Integrate with team membership data to filter by team
5. Cache permission checks for performance

**Expected Results**:
- ✅ Permission-based filtering service exists
- ✅ Projects are filtered by permissions
- ✅ Tasks are filtered by permissions
- ✅ Teams are filtered by permissions
- ✅ Filtering logic is centralized and reusable

**Test Criteria**:
- Unit test: Test filtering with different permissions
- Manual test: Verify filtered data matches permission scope

---

### Task 2: Implement Team-Based Filtering Logic

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Implement logic to filter projects and tasks based on team membership.

**Files to Create/Modify**:
- `lib/core/services/team_based_filter_service.dart` (new file)
- `lib/features/workspace/data/repositories/workspace_repository_impl.dart` (may need updates)

**Implementation Steps**:
1. Create `TeamBasedFilterService`:
   - Method to get user's teams: `getUserTeams(String userId, String workspaceId)`
   - Method to filter projects by team: `filterProjectsByTeam(List<Project> projects, List<String> teamIds)`
   - Method to filter tasks by team: `filterTasksByTeam(List<Task> tasks, List<String> teamIds)`
   - Method to check if project is in team: `isProjectInTeam(Project project, List<String> teamIds)`
   - Method to check if task is in team: `isTaskInTeam(Task task, List<String> teamIds)`
2. Implement team membership checking:
   - Check if user is member of team
   - Check if project is assigned to team
   - Check if task is assigned to team member
   - Check if task is in team's project
3. Handle multi-team membership:
   - Users can be members of multiple teams
   - Show data from all teams user is member of
4. Integrate with `TeamGroup` entity
5. Cache team membership for performance

**Expected Results**:
- ✅ Team-based filtering service exists
- ✅ Projects are filtered by team membership
- ✅ Tasks are filtered by team membership
- ✅ Multi-team membership is handled correctly
- ✅ Team membership is cached for performance

**Test Criteria**:
- Unit test: Test filtering with different team memberships
- Manual test: Verify team filtering works correctly

---

### Task 3: Create Guard Rails/Interceptor for Permission Enforcement

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create guard rails/interceptor that automatically enforces permission-based filtering before data is rendered.

**Files to Create/Modify**:
- `lib/core/guards/permission_enforcement_guard.dart` (new file)
- `lib/core/interceptors/permission_interceptor.dart` (new file)
- `lib/features/tasks/presentation/controllers/task_controller.dart`
- `lib/features/tasks/presentation/controllers/project_controller.dart`

**Implementation Steps**:
1. Create `PermissionEnforcementGuard`:
   - Intercept data loading operations
   - Check user permissions before loading
   - Apply permission-based filtering
   - Throw error if unauthorized access attempted
2. Create `PermissionInterceptor` (if using GetX):
   - Intercept controller method calls
   - Automatically apply permission filtering
   - Inject filtered data into controllers
3. Integrate guard/interceptor:
   - Apply to all project controllers
   - Apply to all task controllers
   - Apply to all team controllers
   - Apply to all data loading operations
4. Add permission validation:
   - Validate permissions before data access
   - Log unauthorized access attempts
   - Show appropriate error messages

**Expected Results**:
- ✅ Guard rails/interceptor exists
- ✅ Permission enforcement is automatic
- ✅ Unauthorized access is prevented
- ✅ Permission checks are logged

**Test Criteria**:
- Test: Try to access unauthorized data - should be blocked
- Test: Verify guard applies filtering automatically
- Test: Verify error messages are clear

---

### Task 4: Update Project Controllers to Use Permission Filtering

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update project controllers to use permission-based filtering before rendering projects.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/project_controller.dart`
- `lib/app/pages/projects/project_list_page.dart` (if exists)
- Any other project-related controllers

**Implementation Steps**:
1. Update `ProjectController`:
   - Inject `PermissionBasedFilterService`
   - Inject `TeamBasedFilterService`
   - Update `loadProjects` method:
     - Load projects from data service
     - Apply permission-based filtering
     - Apply team-based filtering (if user has viewTeamData)
     - Return filtered projects
   - Update `projects` getter to return filtered projects
2. Update project list page:
   - Use filtered projects from controller
   - Show appropriate empty states
   - Handle permission-denied scenarios
3. Add permission checks before project operations:
   - Create project: Check `createProjects` permission
   - Edit project: Check `manageProjects` permission
   - Delete project: Check `manageProjects` permission
   - Assign project: Check `assignProjects` permission
4. Ensure workspace filtering is also applied

**Expected Results**:
- ✅ Project controllers use permission filtering
- ✅ Projects are filtered by permissions
- ✅ Projects are filtered by team membership
- ✅ Permission checks are enforced for operations

**Test Criteria**:
- Manual test: Verify projects are filtered correctly
- Test: Verify permission checks work for operations

---

### Task 5: Update Task Controllers to Use Permission Filtering

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update task controllers to use permission-based filtering before rendering tasks.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/task_controller.dart`
- `lib/features/tasks/presentation/controllers/paginated_task_controller.dart`
- `lib/app/pages/tasks/task_list_page.dart`

**Implementation Steps**:
1. Update `TaskController`:
   - Inject `PermissionBasedFilterService`
   - Inject `TeamBasedFilterService`
   - Update `_loadTasks` method:
     - Load tasks from data service
     - Apply permission-based filtering
     - Apply team-based filtering (if user has viewTeamData)
     - Return filtered tasks
   - Update `tasks` getter to return filtered tasks
2. Update `PaginatedTaskController`:
   - Apply permission filtering to paginated results
   - Ensure pagination respects permission scope
   - Filter results before returning
3. Update task list page:
   - Use filtered tasks from controller
   - Show appropriate empty states
   - Handle permission-denied scenarios
4. Add permission checks before task operations:
   - Create task: Check `createTasks` permission
   - Edit task: Check `updateTaskStatus` permission
   - Delete task: Check `deleteTasks` permission
   - Assign task: Check `assignTasks` permission
5. Ensure workspace filtering is also applied

**Expected Results**:
- ✅ Task controllers use permission filtering
- ✅ Tasks are filtered by permissions
- ✅ Tasks are filtered by team membership
- ✅ Permission checks are enforced for operations
- ✅ Pagination respects permission scope

**Test Criteria**:
- Manual test: Verify tasks are filtered correctly
- Test: Verify permission checks work for operations
- Test: Verify pagination works with filtering

---

### Task 6: Update Team Controllers to Use Permission Filtering

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Update team controllers to use permission-based filtering before rendering teams.

**Files to Modify**:
- `lib/app/pages/team/team_management_page.dart`
- Any team-related controllers

**Implementation Steps**:
1. Update team management:
   - Inject `PermissionBasedFilterService`
   - Update team loading:
     - Load teams from data service
     - Apply permission-based filtering
     - Return filtered teams
2. Update team display:
   - Show only teams user has access to
   - Hide teams user doesn't have access to
   - Show appropriate empty states
3. Add permission checks before team operations:
   - Create team: Check `manageUsers` permission
   - Edit team: Check `manageUsers` permission
   - Delete team: Check `manageUsers` permission
   - Add member: Check `manageUsers` permission
4. Ensure workspace filtering is also applied

**Expected Results**:
- ✅ Team controllers use permission filtering
- ✅ Teams are filtered by permissions
- ✅ Permission checks are enforced for operations

**Test Criteria**:
- Manual test: Verify teams are filtered correctly
- Test: Verify permission checks work for operations

---

### Task 7: Implement Permission-Based Search/Filter

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Ensure search and filter operations respect permission scope.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/task_controller.dart`
- `lib/features/tasks/presentation/controllers/project_controller.dart`
- Search/filter UI components

**Implementation Steps**:
1. Update search functionality:
   - Apply permission filtering to search results
   - Search only within permission scope
   - Hide results outside permission scope
2. Update filter functionality:
   - Apply permission filtering to filter results
   - Filters work within permission scope only
   - Hide filter options outside permission scope
3. Update search/filter UI:
   - Show only searchable/filterable data within scope
   - Show appropriate messages when no results
   - Handle permission-denied scenarios
4. Ensure search/filter respects:
   - Workspace filtering
   - Permission filtering
   - Team filtering (if applicable)

**Expected Results**:
- ✅ Search respects permission scope
- ✅ Filter respects permission scope
- ✅ Search/filter results are filtered correctly
- ✅ UI shows appropriate messages

**Test Criteria**:
- Manual test: Verify search respects permissions
- Test: Verify filter respects permissions
- Test: Verify results are filtered correctly

---

### Task 8: Implement Permission-Based Statistics/Analytics

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Ensure statistics and analytics are scoped by user permissions.

**Files to Modify**:
- Dashboard controllers
- Analytics controllers
- Statistics calculation services

**Implementation Steps**:
1. Update statistics calculation:
   - Calculate statistics from filtered data only
   - Apply permission filtering before calculation
   - Scope statistics to permission level
2. Update analytics:
   - Analytics charts use filtered data
   - Charts reflect permission scope
   - Hide metrics outside permission scope
3. Implement permission-scoped statistics:
   - `viewAllData`: All workspace statistics
   - `viewTeamData`: Team statistics only
   - `viewPersonalData`: Personal statistics only
4. Update dashboard:
   - Show only authorized statistics
   - Show appropriate empty states
   - Handle permission-denied scenarios

**Expected Results**:
- ✅ Statistics are scoped by permissions
- ✅ Analytics reflect permission scope
- ✅ Charts show only authorized data
- ✅ Dashboard shows appropriate data

**Test Criteria**:
- Manual test: Verify statistics are scoped correctly
- Test: Verify analytics reflect permission scope

---

### Task 9: Add Permission Checks to Data Loading Operations

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add permission checks to all data loading operations before data is fetched.

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`
- `lib/features/tasks/data/repositories/task_repository_impl.dart` (if exists)
- `lib/features/tasks/data/repositories/project_repository_impl.dart` (if exists)

**Implementation Steps**:
1. Update data service methods:
   - Add permission check before fetching data
   - Apply permission filtering to query results
   - Return filtered data only
2. Update repository methods:
   - Check permissions before data access
   - Apply filtering at repository level
   - Throw error if unauthorized
3. Add permission validation:
   - Validate permissions before query
   - Log permission checks
   - Handle permission-denied errors
4. Ensure all data operations check permissions:
   - List operations
   - Get operations
   - Search operations
   - Filter operations

**Expected Results**:
- ✅ Permission checks are added to data loading
- ✅ Data is filtered at service/repository level
- ✅ Unauthorized access is prevented
- ✅ Permission checks are logged

**Test Criteria**:
- Test: Try to load unauthorized data - should be blocked
- Test: Verify permission checks are performed
- Test: Verify filtered data is returned

---

### Task 10: Add Unit Tests for Permission-Based Filtering

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for permission-based filtering functionality.

**Files to Create/Modify**:
- `test/core/services/permission_based_filter_service_test.dart`
- `test/core/services/team_based_filter_service_test.dart`
- `test/core/guards/permission_enforcement_guard_test.dart`

**Implementation Steps**:
1. Test `PermissionBasedFilterService`:
   - Test filtering with viewAllData permission
   - Test filtering with viewTeamData permission
   - Test filtering with viewPersonalData permission
   - Test filtering with multiple permissions
2. Test `TeamBasedFilterService`:
   - Test filtering by single team
   - Test filtering by multiple teams
   - Test filtering with no team membership
   - Test team membership checking
3. Test `PermissionEnforcementGuard`:
   - Test guard enforcement
   - Test unauthorized access blocking
   - Test permission validation
4. Test integration:
   - Test filtering in controllers
   - Test filtering in repositories
   - Test end-to-end filtering flow

**Expected Results**:
- ✅ Unit tests cover permission filtering
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Create Permission-Based Data Filtering Service (Critical - Foundation)
2. **Task 2**: Implement Team-Based Filtering Logic (Critical - Core Feature)
3. **Task 3**: Create Guard Rails/Interceptor for Permission Enforcement (Critical - Security)
4. **Task 4**: Update Project Controllers to Use Permission Filtering (High Priority - Core Feature)
5. **Task 5**: Update Task Controllers to Use Permission Filtering (High Priority - Core Feature)
6. **Task 9**: Add Permission Checks to Data Loading Operations (High Priority - Security)
7. **Task 6**: Update Team Controllers to Use Permission Filtering (Medium Priority)
8. **Task 7**: Implement Permission-Based Search/Filter (Medium Priority - UX)
9. **Task 8**: Implement Permission-Based Statistics/Analytics (Medium Priority - Feature Completeness)
10. **Task 10**: Add Unit Tests for Permission-Based Filtering (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Permission-based filtering service exists
- ✅ Team-based filtering service exists
- ✅ Guard rails/interceptor enforce permission filtering
- ✅ Project controllers use permission filtering
- ✅ Task controllers use permission filtering
- ✅ Team controllers use permission filtering
- ✅ Search/filter respects permission scope
- ✅ Statistics are scoped by permissions
- ✅ Permission checks are added to data loading
- ✅ Unit tests have minimum 80% coverage
- ✅ No data leakage between permission scopes
- ✅ No data leakage between teams
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)

---

## Dependencies

- **PermissionService**: Must provide permission checking methods
- **WorkspaceController**: Must provide current workspace and user permissions
- **TeamGroup Entity**: Must provide team membership data
- **Firebase Realtime Database**: Must support permission-scoped queries
- **GetX**: Required for interceptors/guards (if using GetX patterns)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants

---

## Notes

1. **Permission Scopes**:
   - `viewAllData`: Can view all workspace data (Account Holder, Admin)
   - `viewTeamData`: Can view only team data (Lead, some Members)
   - `viewPersonalData`: Can view only personal data (Member)

2. **Team Membership**: Users can be members of multiple teams. They should see data from all their teams if they have `viewTeamData` permission.

3. **Guard Rails**: Critical for ensuring all data is filtered before rendering. Without guard rails, it's easy to miss permission checks in new code.

4. **Defense in Depth**: Apply filtering at multiple levels:
   - Service level (data loading)
   - Repository level (data access)
   - Controller level (data presentation)
   - UI level (data display)

5. **Performance**: Cache permission checks and team membership for performance. Don't check permissions on every data access.

6. **Workspace + Permissions**: Data must be filtered by BOTH workspace AND permissions. Missing either filter can cause data leakage.

---

## Related Documentation

- `WORKSPACE_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `PROJECTS_TEAMS_VISIBILITY_TEST_CASES.md` - Test cases for this feature
- `WORKSPACE_DATA_FILTERING_TASKS.md` - Related workspace filtering tasks
- `ROLE_MATRIX_TASKS.md` - Related role matrix tasks
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/SECURITY_RULES.md` - Security requirements

