# Workspace Switching - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Workspace Switching** feature (fast switching and remembering last selection). Currently, this feature is **PARTIAL** - switching works, but "remember last" functionality is broken due to stubbed cache parsing.

## Current Status: ⚠️ PARTIAL

### What Works:
- ✅ Workspace switching flow: `WorkspaceSelector` → `WorkspaceController.switchToWorkspace` → `SwitchWorkspace` use case
- ✅ Workspace ID is saved to `StorageService.setWorkspaceId`
- ✅ Firebase preferences are updated via `WorkspaceRemoteDataSource.switchToWorkspace`
- ✅ Workspace is cached via `WorkspaceLocalDataSource.cacheCurrentWorkspace`
- ✅ Current workspace is updated in controller
- ✅ Success message is displayed
- ✅ Workspace members are loaded after switching

### What's Missing/Broken:
- ⚠️ `WorkspaceLocalDataSource.getCachedCurrentWorkspace()` returns null (parsing is stubbed)
- ⚠️ `WorkspaceLocalDataSource.getCachedWorkspaces()` returns empty list (parsing is stubbed)
- ⚠️ Controller initial load doesn't read cached/last workspace
- ⚠️ "Remember last" functionality doesn't work

---

## Task List

### Task 1: Implement Workspace Cache Parsing

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Implement proper JSON parsing in `WorkspaceLocalDataSource` to retrieve cached workspaces and current workspace.

**Files to Modify**:
- `lib/features/workspace/data/datasources/workspace_local_data_source.dart`

**Implementation Steps**:
1. Add JSON serialization/deserialization:
   - Use `dart:convert` for JSON encoding/decoding
   - OR use existing workspace `toMap()` and `fromMap()` methods
2. Update `getCachedCurrentWorkspace()`:
   - Read workspace JSON string from SharedPreferences
   - Parse JSON string to Map
   - Convert Map to `Workspace` using `Workspace.fromMap()`
   - Return parsed workspace
   - Handle parsing errors gracefully
3. Update `getCachedWorkspaces()`:
   - Read workspaces JSON string from SharedPreferences
   - Parse JSON string to List<Map>
   - Convert each Map to `Workspace` using `Workspace.fromMap()`
   - Return list of parsed workspaces
   - Handle parsing errors gracefully
4. Update `getCachedWorkspaceMembers()`:
   - Read members JSON string from SharedPreferences
   - Parse JSON string to List<Map>
   - Convert each Map to `WorkspaceMember` using `WorkspaceMember.fromMap()`
   - Return list of parsed members
5. Add error handling for malformed JSON
6. Add unit tests for parsing

**Expected Results**:
- ✅ `getCachedCurrentWorkspace()` returns cached workspace (not null)
- ✅ `getCachedWorkspaces()` returns cached workspaces list (not empty)
- ✅ `getCachedWorkspaceMembers()` returns cached members
- ✅ Parsing handles errors gracefully
- ✅ Workspace data is correctly deserialized

**Test Criteria**:
- Unit tests for cache parsing
- Manual test: Cache workspace, retrieve from cache, verify data is correct

---

### Task 2: Update Cache Storage to Use JSON

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update cache storage methods to use proper JSON encoding instead of `toString()`.

**Files to Modify**:
- `lib/features/workspace/data/datasources/workspace_local_data_source.dart`

**Implementation Steps**:
1. Update `cacheCurrentWorkspace()`:
   - Convert workspace to Map using `workspace.toMap()`
   - Encode Map to JSON string using `jsonEncode()`
   - Store JSON string in SharedPreferences
2. Update `cacheWorkspaces()`:
   - Convert workspaces list to List<Map>
   - Encode List<Map> to JSON string using `jsonEncode()`
   - Store JSON string in SharedPreferences
3. Update `cacheWorkspaceMembers()`:
   - Convert members list to List<Map>
   - Encode List<Map> to JSON string using `jsonEncode()`
   - Store JSON string in SharedPreferences
4. Ensure encoding is consistent with parsing

**Expected Results**:
- ✅ Workspace data is stored as proper JSON
- ✅ JSON can be parsed correctly
- ✅ Storage format is consistent

**Test Criteria**:
- Unit tests for JSON encoding
- Manual test: Cache workspace, verify JSON format in storage

---

### Task 3: Load Last Workspace on App Initialization

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update `WorkspaceController` to load last workspace from cache on initialization.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/features/workspace/data/repositories/workspace_repository_impl.dart`

**Implementation Steps**:
1. In `WorkspaceController._loadUserWorkspaces()`:
   - Before calling `getUserWorkspaces`, try to get cached workspace
   - Call `WorkspaceRepository.getCurrentWorkspace(userId)` which should:
     - Try to get from cache first
     - If cache exists, return cached workspace
     - If cache doesn't exist, get from Firebase
   - Set cached workspace as current workspace immediately (for fast UI)
   - Then load all workspaces from Firebase and update
2. In `WorkspaceRepositoryImpl.getCurrentWorkspace()`:
   - Try to get from `WorkspaceLocalDataSource.getCachedCurrentWorkspace()` first
   - If cached workspace exists, return it
   - If not, get from Firebase via `WorkspaceRemoteDataSource.getCurrentWorkspace()`
   - Cache the workspace if retrieved from Firebase
3. Ensure workspace is set as current in controller
4. Handle case where cached workspace no longer exists (user removed from workspace)

**Expected Results**:
- ✅ Last workspace is loaded from cache on app start
- ✅ Workspace is set as current workspace immediately
- ✅ UI shows last workspace without waiting for Firebase
- ✅ Workspace is synced with Firebase in background

**Test Criteria**:
- Manual test: Switch workspace, restart app, verify last workspace is loaded
- Test with cached workspace that no longer exists

---

### Task 4: Load Last Workspace from StorageService

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Use `StorageService.getWorkspaceId()` as fallback to load last workspace if cache parsing fails.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/features/workspace/data/repositories/workspace_repository_impl.dart`

**Implementation Steps**:
1. In `WorkspaceController._loadUserWorkspaces()`:
   - Try to get workspace ID from `StorageService.getWorkspaceId()`
   - If workspace ID exists:
     - Load workspace by ID from repository
     - Set as current workspace
   - This serves as fallback if cache parsing fails
2. Ensure this works alongside cache-based loading
3. Prefer cache over storage ID (cache has full workspace data)

**Expected Results**:
- ✅ Last workspace ID is retrieved from storage
- ✅ Workspace is loaded by ID if cache fails
- ✅ Fallback mechanism works correctly

**Test Criteria**:
- Manual test: Switch workspace, clear cache but keep storage, verify workspace is loaded by ID

---

### Task 5: Handle Stale Cache Scenarios

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Handle cases where cached workspace is stale or user no longer has access.

**Files to Modify**:
- `lib/features/workspace/data/repositories/workspace_repository_impl.dart`
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`

**Implementation Steps**:
1. When loading cached workspace:
   - Verify user still has access to workspace
   - Verify workspace still exists in Firebase
   - If workspace is invalid:
     - Clear cache
     - Load from Firebase
     - Set first available workspace as current
2. Handle error scenarios:
   - Cached workspace not found in Firebase
   - User no longer has access to cached workspace
   - Cached workspace data is corrupted
3. Add validation for cached workspace
4. Clear invalid cache automatically

**Expected Results**:
- ✅ Stale cache is detected and handled
- ✅ Invalid cached workspaces are cleared
- ✅ App falls back to Firebase when cache is invalid
- ✅ User experience is not broken by stale cache

**Test Criteria**:
- Test: Cache workspace, remove user from workspace, verify app handles it
- Test: Cache workspace, delete workspace, verify app handles it

---

### Task 6: Optimize Workspace Switching Performance

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Optimize workspace switching for better performance and user experience.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/features/workspace/data/repositories/workspace_repository_impl.dart`

**Implementation Steps**:
1. Preload workspace data when switching:
   - Load workspace members in parallel
   - Load workspace settings in parallel
   - Don't wait for all data before showing success
2. Use cached workspace data immediately:
   - Show cached workspace data while syncing with Firebase
   - Update UI when Firebase data arrives
3. Debounce rapid workspace switches:
   - Prevent multiple simultaneous switches
   - Process only the last switch request
4. Add loading states for better UX
5. Optimize Firebase queries

**Expected Results**:
- ✅ Workspace switching is fast and responsive
- ✅ UI updates immediately with cached data
- ✅ Background sync doesn't block UI
- ✅ Rapid switches are handled efficiently

**Test Criteria**:
- Performance test: Measure switching time
- Test rapid switches
- Verify UI responsiveness

---

### Task 7: Add Real-time Workspace Sync

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add real-time sync of workspace switching across multiple devices.

**Files to Modify**:
- `lib/features/workspace/data/datasources/workspace_remote_data_source.dart`
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`

**Implementation Steps**:
1. Listen to Firebase preference changes:
   - Set up listener on `users/{userId}/preferences/currentWorkspaceId`
   - When preference changes, update current workspace
2. Update UI when preference changes on other device
3. Handle conflicts (user switches on multiple devices simultaneously)
4. Add debouncing to prevent loops

**Expected Results**:
- ✅ Workspace switching syncs in real-time across devices
- ✅ UI updates automatically when workspace changes on another device
- ✅ Conflicts are handled gracefully

**Test Criteria**:
- Test: Switch workspace on Device A, verify Device B updates
- Test: Simultaneous switches on multiple devices

---

### Task 8: Add Unit Tests for Cache Parsing

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for workspace cache parsing functionality.

**Files to Create/Modify**:
- `test/features/workspace/data/datasources/workspace_local_data_source_test.dart`

**Implementation Steps**:
1. Test `cacheCurrentWorkspace()`:
   - Test workspace is cached correctly
   - Test JSON encoding
2. Test `getCachedCurrentWorkspace()`:
   - Test workspace is retrieved correctly
   - Test JSON parsing
   - Test null/empty cache handling
   - Test malformed JSON handling
3. Test `cacheWorkspaces()`:
   - Test multiple workspaces are cached
4. Test `getCachedWorkspaces()`:
   - Test workspaces are retrieved correctly
   - Test empty cache handling
5. Test `cacheWorkspaceMembers()` and `getCachedWorkspaceMembers()`
6. Test error scenarios

**Expected Results**:
- ✅ Unit tests cover cache parsing functionality
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

### Task 9: Add Integration Tests for Workspace Switching

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Write integration tests for complete workspace switching flow including cache persistence.

**Files to Create/Modify**:
- `test/features/workspace/integration/workspace_switching_integration_test.dart`

**Implementation Steps**:
1. Test complete flow: Switch workspace → Cache → Restart app → Load from cache
2. Test with Firebase emulator or test environment
3. Test cache persistence
4. Test stale cache handling
5. Test error scenarios

**Expected Results**:
- ✅ Integration tests cover complete switching flow
- ✅ Tests verify cache persistence
- ✅ All integration tests pass

**Test Criteria**:
- Run integration tests
- Verify tests pass with Firebase emulator

---

### Task 10: Improve Workspace Selector UI

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Improve workspace selector UI for better user experience.

**Files to Modify**:
- `lib/features/workspace/presentation/widgets/workspace_selector.dart`

**Implementation Steps**:
1. Add workspace icons/avatars
2. Show workspace description (if available)
3. Add workspace member count
4. Add loading states
5. Add search/filter functionality (if many workspaces)
6. Improve visual feedback for selected workspace
7. Add workspace type badges (Personal/Company)

**Expected Results**:
- ✅ Workspace selector UI is more user-friendly
- ✅ Workspaces are easier to identify
- ✅ Better visual feedback

**Test Criteria**:
- Manual test: Verify UI improvements
- User feedback on usability

---

## Implementation Priority Order

1. **Task 1**: Implement Workspace Cache Parsing (Critical - Core Functionality)
2. **Task 2**: Update Cache Storage to Use JSON (Critical - Required for Task 1)
3. **Task 3**: Load Last Workspace on App Initialization (Critical - Core Feature)
4. **Task 4**: Load Last Workspace from StorageService (Important - Fallback)
5. **Task 5**: Handle Stale Cache Scenarios (Important - Data Integrity)
6. **Task 8**: Add Unit Tests for Cache Parsing (Important - Quality Assurance)
7. **Task 6**: Optimize Workspace Switching Performance (Nice to have)
8. **Task 7**: Add Real-time Workspace Sync (Nice to have)
9. **Task 9**: Add Integration Tests (Nice to have)
10. **Task 10**: Improve Workspace Selector UI (Nice to have)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Workspace switching works correctly
- ✅ Workspace ID is saved to local storage
- ✅ Firebase preference is updated
- ✅ Workspace is cached correctly
- ✅ Cached workspace is retrieved correctly (parsing works)
- ✅ Last workspace is remembered after app restart
- ✅ Last workspace is loaded on app initialization
- ✅ Stale cache is handled gracefully
- ✅ Unit tests have minimum 80% coverage
- ✅ Integration tests pass
- ✅ No known bugs or issues

---

## Dependencies

- **SharedPreferences**: Used for local caching
- **dart:convert**: Required for JSON encoding/decoding
- **Firebase Realtime Database**: Must support workspace preference storage
- **StorageService**: Must support `setWorkspaceId()` and `getWorkspaceId()`
- **Workspace Entity**: Must have `toMap()` and `fromMap()` methods
- **WorkspaceMember Entity**: Must have `toMap()` and `fromMap()` methods

---

## Notes

1. **Cache Parsing**: Currently stubbed - returns null/empty. Need to implement proper JSON parsing.

2. **Storage Format**: Currently uses `toString()` which is not parseable. Need to use JSON encoding.

3. **Initial Load**: Controller doesn't read cached workspace on initialization. Need to add this logic.

4. **Remember Last**: Feature doesn't work due to stubbed cache parsing. Once parsing is implemented, this should work.

5. **Fallback Strategy**: Can use `StorageService.getWorkspaceId()` as fallback if cache parsing fails.

6. **Stale Cache**: Need to handle cases where cached workspace is invalid (deleted, user removed, etc.).

7. **Performance**: Workspace switching should be fast. Use cached data immediately, sync in background.

8. **Multi-Device**: Real-time sync across devices is nice-to-have but not critical for MVP.

---

## Related Documentation

- `WORKSPACE_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `WORKSPACE_SWITCHING_TEST_CASES.md` - Test cases for this feature
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/CODING_STANDARDS.md` - Coding standards
- `rules/PERFORMANCE_AND_ENUM_RULES.md` - Performance requirements
