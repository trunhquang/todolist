# Workspace Data Filtering - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Workspace Data Filtering** feature (ensuring all data queries filter by active workspace). Currently, this feature is **PARTIAL** - data services expect workspaceId, but there's no global guard ensuring all queries are scoped.

## Current Status: ⚠️ PARTIAL

### What Works:
- ✅ Data services expect `workspaceId` parameter (e.g., `FirebaseDatabaseService`)
- ✅ Firebase queries use workspace paths: `workspaces/{workspaceId}/tasks`, etc.
- ✅ Most controllers pass workspaceId to data services
- ✅ Some controllers filter data by workspace (TaskController, ProjectController use WorkspaceContextService)
- ✅ Task, Project, Report entities have `workspaceId` field

### What's Missing/Broken:
- ⚠️ No global guard ensuring controllers/use cases always pass current workspace
- ⚠️ No interceptor to automatically inject workspaceId
- ⚠️ Hard to guarantee all queries are scoped (needs auditing)
- ⚠️ Some controllers might not be passing workspaceId correctly
- ⚠️ No enforcement mechanism to prevent workspace data leakage

---

## Task List

### Task 1: Audit All Data Queries for Workspace Filtering

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Audit all data queries across the codebase to identify which queries filter by workspace and which don't.

**Files to Review**:
- `lib/features/tasks/**/*` (controllers, repositories, use cases)
- `lib/features/reports/**/*` (controllers, repositories, use cases)
- `lib/core/services/firebase_database_service.dart`
- `lib/core/backend/**/*` (if any data queries)
- All other features with data queries

**Implementation Steps**:
1. Create audit checklist of all data operations:
   - Task operations (list, get, create, update, delete, search)
   - Project operations (list, get, create, update, delete)
   - Report operations (list, get, create, update, delete)
   - User operations (if workspace-scoped)
   - Other data operations
2. For each operation, check:
   - Does it require workspaceId parameter?
   - Does it pass workspaceId to data service?
   - Does it use workspaceId in Firebase path?
   - Does it filter results by workspace?
3. Document findings:
   - List operations that correctly filter by workspace
   - List operations that don't filter by workspace
   - List operations that might have issues
4. Create audit report with recommendations

**Expected Results**:
- ✅ Complete audit of all data queries
- ✅ List of operations that need workspace filtering
- ✅ Audit report with findings and recommendations
- ✅ Priority list for fixes

**Test Criteria**:
- Review audit report
- Verify all critical operations are identified
- Test identified issues

---

### Task 2: Create Global Workspace Guard/Interceptor

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create a global guard/interceptor that automatically ensures all data queries include current workspace ID.

**Files to Create/Modify**:
- `lib/core/guards/workspace_guard.dart` (new file)
- `lib/core/interceptors/workspace_interceptor.dart` (new file)
- `lib/core/services/workspace_context_service.dart` (may need updates)

**Implementation Steps**:
1. Create `WorkspaceGuard` service:
   - Check if current workspace is set
   - Throw error if workspace is missing
   - Provide current workspace ID
2. Create `WorkspaceInterceptor` (if using GetX):
   - Intercept data service calls
   - Automatically inject workspaceId if missing
   - Validate workspaceId is valid
3. Integrate guard/interceptor:
   - Apply to all data repositories
   - Apply to all use cases
   - Apply to all controllers
4. Add workspace validation:
   - Verify user has access to workspace
   - Verify workspace exists
   - Handle invalid workspace gracefully

**Expected Results**:
- ✅ Global guard ensures workspace is always set
- ✅ Interceptor automatically injects workspaceId
- ✅ All queries are guaranteed to be scoped
- ✅ Missing workspaceId is handled gracefully

**Test Criteria**:
- Test: Operations without workspaceId get it injected automatically
- Test: Operations with invalid workspaceId are rejected
- Test: All data queries are scoped correctly

---

### Task 3: Fix Queries Missing WorkspaceId

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Fix all data queries identified in audit that don't filter by workspace.

**Files to Modify**:
- Based on audit findings (TBD)

**Implementation Steps**:
1. Review audit findings
2. For each query missing workspaceId:
   - Add workspaceId parameter
   - Get workspaceId from WorkspaceController or StorageService
   - Pass workspaceId to data service
   - Update Firebase query to use workspaceId
3. Update controllers to pass workspaceId
4. Update use cases to require workspaceId
5. Update repositories to require workspaceId
6. Test each fix

**Expected Results**:
- ✅ All data queries filter by workspace
- ✅ No queries bypass workspace filtering
- ✅ All operations are scoped correctly

**Test Criteria**:
- Test each fixed query
- Verify workspace filtering works
- Verify no data leakage

---

### Task 4: Standardize WorkspaceId Source

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Standardize how controllers/get workspaceId (from WorkspaceController vs StorageService).

**Files to Modify**:
- All controllers that get workspaceId
- `lib/features/tasks/presentation/controllers/**/*`
- `lib/features/reports/presentation/controllers/**/*`
- Other feature controllers

**Implementation Steps**:
1. Review current implementations:
   - Some use `StorageService.getWorkspaceId()`
   - Some use `WorkspaceController.currentWorkspace.value?.id`
   - Some use `WorkspaceContextService.currentWorkspaceId`
2. Decide on standard approach:
   - Option A: Always use `WorkspaceController.currentWorkspace.value?.id`
   - Option B: Always use `StorageService.getWorkspaceId()`
   - Option C: Use `WorkspaceContextService.currentWorkspaceId`
   - Recommended: Use WorkspaceController (single source of truth)
3. Update all controllers to use standard approach
4. Remove inconsistent implementations
5. Add helper method if needed

**Expected Results**:
- ✅ All controllers use same method to get workspaceId
- ✅ Single source of truth for current workspace
- ✅ Consistent behavior across app

**Test Criteria**:
- Verify all controllers use standard approach
- Test workspace switching works correctly
- Verify no inconsistencies

---

### Task 5: Add Workspace Validation to Data Operations

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add validation to ensure data operations only work with current workspace.

**Files to Modify**:
- `lib/features/tasks/domain/usecases/**/*`
- `lib/features/tasks/data/repositories/**/*`
- `lib/features/reports/domain/usecases/**/*`
- `lib/features/reports/data/repositories/**/*`

**Implementation Steps**:
1. Add workspace validation to use cases:
   - Verify workspaceId matches current workspace
   - Throw error if workspaceId doesn't match
   - Validate user has access to workspace
2. Add validation to repositories:
   - Verify workspaceId is provided
   - Verify workspaceId is valid
   - Reject operations with wrong workspaceId
3. Add validation to controllers:
   - Verify current workspace is set
   - Verify workspaceId matches current workspace
   - Show error if validation fails

**Expected Results**:
- ✅ Data operations validate workspace
- ✅ Operations with wrong workspaceId are rejected
- ✅ Clear error messages for validation failures

**Test Criteria**:
- Test: Try to create task with wrong workspaceId - should fail
- Test: Try to access task from different workspace - should fail
- Test: Validation errors are clear

---

### Task 6: Add Workspace Filtering to Client-Side Lists

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Ensure client-side filtering also filters by workspace (defense in depth).

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/task_controller.dart`
- `lib/features/tasks/presentation/controllers/project_controller.dart`
- `lib/features/reports/presentation/controllers/**/*`

**Implementation Steps**:
1. Review controllers that filter data client-side
2. Ensure getters filter by workspace:
   ```dart
   List<Task> get tasks => _tasks.where((task) => 
     task.workspaceId == currentWorkspaceId
   ).toList();
   ```
3. Add workspace filtering to all data getters
4. Ensure filtering happens even if server-side filtering exists (defense in depth)
5. Test filtering works correctly

**Expected Results**:
- ✅ Client-side lists filter by workspace
- ✅ Defense in depth (server + client filtering)
- ✅ No data leakage even if server filtering fails

**Test Criteria**:
- Test: Verify getters filter by workspace
- Test: Verify no cross-workspace data in lists

---

### Task 7: Add Workspace Context Validation Middleware

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Create middleware that validates workspace context before data operations.

**Files to Create**:
- `lib/core/middleware/workspace_context_middleware.dart`

**Implementation Steps**:
1. Create middleware class:
   - Check if workspace is set
   - Validate workspace exists
   - Validate user has access
   - Inject workspaceId if needed
2. Apply middleware to:
   - All data service calls
   - All repository calls
   - All use case calls
3. Handle middleware errors gracefully
4. Log middleware actions for debugging

**Expected Results**:
- ✅ Middleware validates workspace context
- ✅ All operations go through middleware
- ✅ Consistent workspace validation

**Test Criteria**:
- Test: Middleware validates workspace
- Test: Middleware rejects invalid operations
- Test: Middleware logs actions

---

### Task 8: Add Workspace Filtering Tests

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive tests to verify workspace filtering works correctly.

**Files to Create/Modify**:
- `test/features/tasks/presentation/controllers/task_controller_test.dart`
- `test/features/tasks/data/repositories/task_repository_test.dart`
- `test/features/reports/presentation/controllers/report_controller_test.dart`
- `test/integration/workspace_filtering_integration_test.dart`

**Implementation Steps**:
1. Test workspace filtering in controllers:
   - Test tasks are filtered by workspace
   - Test projects are filtered by workspace
   - Test reports are filtered by workspace
2. Test workspace filtering in repositories:
   - Test queries use workspaceId
   - Test Firebase paths are correct
3. Test workspace switching:
   - Test data updates when workspace changes
   - Test no stale data from previous workspace
4. Test cross-workspace isolation:
   - Test data from one workspace not visible in another
   - Test operations with wrong workspaceId fail
5. Integration tests:
   - Test complete flow with workspace filtering
   - Test with Firebase emulator

**Expected Results**:
- ✅ Comprehensive tests for workspace filtering
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

### Task 9: Add Workspace Filtering Documentation

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Document workspace filtering patterns and best practices.

**Files to Create**:
- `docs/workspace_filtering_guide.md`

**Implementation Steps**:
1. Document workspace filtering patterns:
   - How to get current workspaceId
   - How to pass workspaceId to data services
   - How to filter data client-side
   - Best practices
2. Document common mistakes:
   - Forgetting to pass workspaceId
   - Using wrong workspaceId
   - Not filtering client-side
3. Add code examples:
   - Correct patterns
   - Incorrect patterns
   - Migration guide
4. Add to developer onboarding

**Expected Results**:
- ✅ Comprehensive documentation
- ✅ Clear patterns and examples
- ✅ Helps prevent future issues

**Test Criteria**:
- Review documentation
- Verify examples are correct
- Test documentation clarity

---

### Task 10: Add Runtime Workspace Filtering Checks

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add runtime checks in debug mode to detect workspace filtering issues.

**Files to Create/Modify**:
- `lib/core/debug/workspace_filtering_checker.dart`

**Implementation Steps**:
1. Create debug checker:
   - Monitor all data queries
   - Verify workspaceId is present
   - Verify workspaceId matches current workspace
   - Log warnings for potential issues
2. Add assertions in debug mode:
   - Assert workspaceId is not null
   - Assert workspaceId matches current workspace
   - Assert data belongs to current workspace
3. Add debug logging:
   - Log all workspace filtering operations
   - Log warnings for missing workspaceId
   - Log errors for wrong workspaceId
4. Enable only in debug mode (not production)

**Expected Results**:
- ✅ Runtime checks detect workspace filtering issues
- ✅ Debug logging helps identify problems
- ✅ No performance impact in production

**Test Criteria**:
- Test: Debug checker detects missing workspaceId
- Test: Debug checker detects wrong workspaceId
- Test: No performance impact in release mode

---

## Implementation Priority Order

1. **Task 1**: Audit All Data Queries for Workspace Filtering (Critical - Foundation)
2. **Task 2**: Create Global Workspace Guard/Interceptor (Critical - Core Feature)
3. **Task 3**: Fix Queries Missing WorkspaceId (Critical - Data Integrity)
4. **Task 4**: Standardize WorkspaceId Source (Important - Consistency)
5. **Task 5**: Add Workspace Validation to Data Operations (Important - Security)
6. **Task 6**: Add Workspace Filtering to Client-Side Lists (Important - Defense in Depth)
7. **Task 8**: Add Workspace Filtering Tests (Important - Quality Assurance)
8. **Task 7**: Add Workspace Context Validation Middleware (Nice to have)
9. **Task 9**: Add Workspace Filtering Documentation (Nice to have)
10. **Task 10**: Add Runtime Workspace Filtering Checks (Nice to have)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ All data queries filter by current workspace
- ✅ Global guard/interceptor ensures workspace scoping
- ✅ No data leakage between workspaces
- ✅ All controllers use standardized workspaceId source
- ✅ Workspace validation works for all operations
- ✅ Client-side filtering provides defense in depth
- ✅ Unit tests have minimum 80% coverage
- ✅ Integration tests pass
- ✅ No known bugs or data leakage issues

---

## Dependencies

- **WorkspaceController**: Must provide current workspace ID
- **StorageService**: Must support `getWorkspaceId()`
- **WorkspaceContextService**: Must provide current workspace context
- **Firebase Realtime Database**: Must support workspace-scoped queries
- **GetX**: Required for interceptors/guards (if using GetX patterns)

---

## Notes

1. **Global Guard**: This is critical for ensuring all queries are scoped. Without it, it's easy to miss workspace filtering in new code.

2. **Defense in Depth**: Even with server-side filtering, add client-side filtering as backup.

3. **Standardization**: Having a single way to get workspaceId prevents inconsistencies.

4. **Validation**: Validate workspace at multiple levels (controller, use case, repository) for security.

5. **Audit First**: Before implementing fixes, audit all queries to understand the scope of work.

6. **Testing**: Comprehensive tests are essential to prevent data leakage.

7. **Performance**: Workspace filtering should not significantly impact performance. Use server-side filtering when possible.

8. **Error Handling**: Clear error messages when workspaceId is missing or invalid.

---

## Related Documentation

- `WORKSPACE_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `WORKSPACE_DATA_FILTERING_TEST_CASES.md` - Test cases for this feature
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/PERFORMANCE_AND_ENUM_RULES.md` - Performance requirements
- `rules/SECURITY_RULES.md` - Security requirements

