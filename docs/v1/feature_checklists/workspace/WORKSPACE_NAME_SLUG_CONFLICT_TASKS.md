# Workspace Name/Slug Conflict Checking - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Workspace Name/Slug Conflict Checking** feature. Currently, this feature is **PARTIAL** - name check exists but only locally, slug helpers exist but unused, and no remote uniqueness check.

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `WorkspaceValidator.isWorkspaceNameAvailable` - checks against local list
- ✅ `WorkspaceValidator.generateWorkspaceSlug` - generates slug from name
- ✅ `WorkspaceValidator.validateWorkspaceSlug` - validates slug format
- ✅ Name validation in `CreateWorkspacePage` - uses local check
- ✅ Case-insensitive name comparison

### What's Missing/Broken:
- ⚠️ Name check only validates against local list (not all workspaces in Firebase)
- ⚠️ Slug helpers exist but are not used anywhere
- ⛔ No slug field in Workspace entity
- ⛔ No remote uniqueness check for name
- ⛔ No remote uniqueness check for slug
- ⛔ No slug generation during workspace creation
- ⛔ No slug storage in Firebase
- ⛔ No slug collision handling
- ⛔ No name/slug conflict check when updating workspace

---

## Task List

### Task 1: Add Slug Field to Workspace Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add `slug` field to `Workspace` entity to support slug-based identification and URLs.

**Files to Modify**:
- `lib/features/workspace/domain/entities/workspace.dart`

**Implementation Steps**:
1. Add `slug` field to `Workspace` entity:
   ```dart
   final String? slug; // URL-friendly identifier
   ```
2. Update constructor to include slug:
   - Make slug optional (nullable)
   - Default to `null` for backward compatibility
3. Update `fromMap` method to read slug:
   ```dart
   slug: map['slug']?.toString(),
   ```
4. Update `toMap` method to include slug:
   ```dart
   'slug': slug,
   ```
5. Update `copyWith` method to support slug
6. Add helper method:
   ```dart
   String get effectiveSlug => slug ?? generateWorkspaceSlug(name);
   ```

**Expected Results**:
- ✅ Workspace entity has slug field
- ✅ Slug field is serialized correctly
- ✅ Backward compatibility is maintained (slug is optional)

**Test Criteria**:
- Unit test: Test entity creation with/without slug
- Test: Verify serialization works correctly
- Test: Verify backward compatibility (existing workspaces without slug)

---

### Task 2: Implement Remote Name Uniqueness Check

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Implement remote uniqueness check for workspace name against all workspaces in Firebase.

**Files to Create/Modify**:
- `lib/features/workspace/domain/repositories/workspace_repository.dart`
- `lib/features/workspace/data/repositories/workspace_repository_impl.dart`
- `lib/features/workspace/data/datasources/workspace_remote_data_source.dart`
- `lib/features/workspace/data/datasources/workspace_remote_data_source_impl.dart`

**Implementation Steps**:
1. Add method to repository interface:
   ```dart
   Future<Either<Failure, bool>> isWorkspaceNameAvailable(String name, {String? excludeWorkspaceId});
   ```
   - `excludeWorkspaceId`: Optional workspace ID to exclude from check (for updates)
2. Implement in `WorkspaceRepositoryImpl`:
   - Call remote data source method
   - Handle errors appropriately
3. Add method to remote data source interface:
   ```dart
   Future<bool> isWorkspaceNameAvailable(String name, {String? excludeWorkspaceId});
   ```
4. Implement in `WorkspaceRemoteDataSourceImpl`:
   ```dart
   Future<bool> isWorkspaceNameAvailable(String name, {String? excludeWorkspaceId}) async {
     try {
       final workspacesRef = _database.ref('workspaces');
       final snapshot = await workspacesRef.get();
       
       if (!snapshot.exists) return true;
       
       final data = snapshot.value as Map<dynamic, dynamic>?;
       if (data == null) return true;
       
       final normalizedName = name.toLowerCase().trim();
       
       for (final entry in data.entries) {
         final workspaceId = entry.key as String;
         // Exclude current workspace if updating
         if (excludeWorkspaceId != null && workspaceId == excludeWorkspaceId) {
           continue;
         }
         
         final workspaceData = entry.value as Map<dynamic, dynamic>;
         final existingName = (workspaceData['name'] as String? ?? '').toLowerCase().trim();
         
         if (existingName == normalizedName) {
           return false; // Name conflict found
         }
       }
       
       return true; // Name is available
     } catch (e) {
       throw ServerException(message: 'Failed to check workspace name availability: $e');
     }
   }
   ```
5. Optimize query (if possible):
   - Use Firebase query with name index
   - Consider caching results for performance

**Expected Results**:
- ✅ Remote name uniqueness check exists
- ✅ Check works correctly
- ✅ Excludes current workspace when updating
- ✅ Performance is acceptable

**Test Criteria**:
- Unit test: Test repository method
- Integration test: Test with Firebase
- Test: Verify name conflicts are detected
- Test: Verify performance is acceptable

---

### Task 3: Implement Remote Slug Uniqueness Check

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Implement remote uniqueness check for workspace slug against all workspaces in Firebase.

**Files to Create/Modify**:
- `lib/features/workspace/domain/repositories/workspace_repository.dart`
- `lib/features/workspace/data/repositories/workspace_repository_impl.dart`
- `lib/features/workspace/data/datasources/workspace_remote_data_source.dart`
- `lib/features/workspace/data/datasources/workspace_remote_data_source_impl.dart`

**Implementation Steps**:
1. Add method to repository interface:
   ```dart
   Future<Either<Failure, bool>> isWorkspaceSlugAvailable(String slug, {String? excludeWorkspaceId});
   ```
2. Implement in `WorkspaceRepositoryImpl`
3. Add method to remote data source interface:
   ```dart
   Future<bool> isWorkspaceSlugAvailable(String slug, {String? excludeWorkspaceId});
   ```
4. Implement in `WorkspaceRemoteDataSourceImpl`:
   ```dart
   Future<bool> isWorkspaceSlugAvailable(String slug, {String? excludeWorkspaceId}) async {
     try {
       final workspacesRef = _database.ref('workspaces');
       final snapshot = await workspacesRef.get();
       
       if (!snapshot.exists) return true;
       
       final data = snapshot.value as Map<dynamic, dynamic>?;
       if (data == null) return true;
       
       final normalizedSlug = slug.toLowerCase().trim();
       
       for (final entry in data.entries) {
         final workspaceId = entry.key as String;
         if (excludeWorkspaceId != null && workspaceId == excludeWorkspaceId) {
           continue;
         }
         
         final workspaceData = entry.value as Map<dynamic, dynamic>;
         final existingSlug = (workspaceData['slug'] as String? ?? '').toLowerCase().trim();
         
         // If no slug exists, generate from name for comparison
         if (existingSlug.isEmpty) {
           final existingName = workspaceData['name'] as String? ?? '';
           final generatedSlug = WorkspaceValidator.generateWorkspaceSlug(existingName);
           if (generatedSlug == normalizedSlug) {
             return false;
           }
         } else if (existingSlug == normalizedSlug) {
           return false; // Slug conflict found
         }
       }
       
       return true; // Slug is available
     } catch (e) {
       throw ServerException(message: 'Failed to check workspace slug availability: $e');
     }
   }
   ```
5. Optimize query (if possible):
   - Use Firebase query with slug index
   - Consider caching results

**Expected Results**:
- ✅ Remote slug uniqueness check exists
- ✅ Check works correctly
- ✅ Handles workspaces without slug (generates for comparison)
- ✅ Excludes current workspace when updating

**Test Criteria**:
- Unit test: Test repository method
- Integration test: Test with Firebase
- Test: Verify slug conflicts are detected
- Test: Verify handles workspaces without slug

---

### Task 4: Implement Slug Generation During Workspace Creation

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Generate and store slug when creating workspace.

**Files to Modify**:
- `lib/features/workspace/domain/usecases/create_workspace.dart`
- `lib/features/workspace/data/datasources/workspace_remote_data_source_impl.dart`

**Implementation Steps**:
1. Update `CreateWorkspace` use case:
   - Generate slug from workspace name using `WorkspaceValidator.generateWorkspaceSlug`
   - Check slug uniqueness using repository method
   - Handle slug collisions (see Task 5)
   - Set slug in workspace entity before creation
2. Update `WorkspaceRemoteDataSourceImpl.createWorkspace`:
   - Ensure slug is included in workspace data
   - Store slug in Firebase
3. Handle slug generation:
   ```dart
   // In CreateWorkspace use case
   String generateUniqueSlug(String name) async {
     String baseSlug = WorkspaceValidator.generateWorkspaceSlug(name);
     String slug = baseSlug;
     int counter = 1;
     
     while (true) {
       final isAvailable = await repository.isWorkspaceSlugAvailable(slug);
       if (isAvailable) {
         return slug;
       }
       // Collision detected, try with number suffix
       slug = '$baseSlug-$counter';
       counter++;
       
       // Prevent infinite loop
       if (counter > 100) {
         throw Exception('Unable to generate unique slug');
       }
     }
   }
   ```

**Expected Results**:
- ✅ Slug is generated during workspace creation
- ✅ Slug uniqueness is checked
- ✅ Slug collisions are handled
- ✅ Slug is stored in Firebase

**Test Criteria**:
- Test: Create workspace, verify slug is generated
- Test: Create workspace with duplicate name, verify slug collision handling
- Test: Verify slug is stored in Firebase

---

### Task 5: Implement Slug Collision Handling

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Handle slug collisions by auto-generating alternative slugs.

**Files to Modify**:
- `lib/features/workspace/domain/usecases/create_workspace.dart`
- `lib/features/workspace/domain/services/workspace_validator.dart` (optional - add helper method)

**Implementation Steps**:
1. Create helper method in `WorkspaceValidator` (optional):
   ```dart
   static String generateUniqueSlug(String baseSlug, List<String> existingSlugs) {
     String slug = baseSlug;
     int counter = 1;
     
     while (existingSlugs.contains(slug)) {
       slug = '$baseSlug-$counter';
       counter++;
       
       if (counter > 100) {
         throw Exception('Unable to generate unique slug');
       }
     }
     
     return slug;
   }
   ```
2. Update `CreateWorkspace` use case to use collision handling:
   - Generate base slug from name
   - Check if slug is available
   - If not available, generate alternative with number suffix
   - Continue until unique slug found
3. Consider user notification (optional):
   - Show message if slug was auto-generated
   - Allow user to see generated slug (if visible in UI)

**Expected Results**:
- ✅ Slug collisions are handled automatically
- ✅ Alternative slugs are generated correctly
- ✅ Infinite loops are prevented
- ✅ Workspace is created with unique slug

**Test Criteria**:
- Test: Create multiple workspaces with same name, verify unique slugs
- Test: Verify incremental numbering works (my-workspace, my-workspace-2, etc.)
- Test: Verify no infinite loops

---

### Task 6: Update CreateWorkspaceController to Use Remote Checks

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update `CreateWorkspaceController` to use remote name/slug uniqueness checks.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/create_workspace_controller.dart`

**Implementation Steps**:
1. Add repository dependency:
   ```dart
   final WorkspaceRepository _workspaceRepository;
   ```
2. Update `isWorkspaceNameAvailable` method:
   ```dart
   Future<bool> isWorkspaceNameAvailable(String name) async {
     // Local check first (fast)
     final localCheck = WorkspaceValidator.isWorkspaceNameAvailable(
       name,
       _workspaceController.workspaces,
     );
     if (!localCheck) {
       return false;
     }
     
     // Remote check (slower but comprehensive)
     final result = await _workspaceRepository.isWorkspaceNameAvailable(name);
     return result.fold(
       (failure) => false, // On error, assume not available
       (isAvailable) => isAvailable,
     );
   }
   ```
3. Add async validation support:
   - Use `Future<String?>` for validator
   - Show loading indicator during remote check
   - Debounce remote checks to avoid excessive API calls
4. Update form validator to use async method:
   - Use `FutureBuilder` or similar for async validation
   - Show loading state during check

**Expected Results**:
- ✅ Remote name checks are used
- ✅ Local check is used first (performance optimization)
- ✅ Async validation works correctly
- ✅ Loading indicators are shown

**Test Criteria**:
- Test: Create workspace, verify remote check is performed
- Test: Verify local check is used first
- Test: Verify async validation works
- Test: Verify performance is acceptable

---

### Task 7: Update CreateWorkspacePage to Show Slug (Optional)

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Optionally show generated slug in Create Workspace UI (for user awareness).

**Files to Modify**:
- `lib/features/workspace/presentation/pages/create_workspace_page.dart`

**Implementation Steps**:
1. Add slug display field (optional):
   - Show slug below name field
   - Display as read-only or editable
   - Show slug generation in real-time
2. Add slug validation:
   - Validate slug format
   - Check slug uniqueness
   - Show error if slug is invalid or taken
3. Consider user experience:
   - Make slug field optional (auto-generated by default)
   - Allow manual slug override (if needed)
   - Show helpful hints about slug format

**Expected Results**:
- ✅ Slug is displayed (if implemented)
- ✅ Slug validation works
- ✅ User can see/override slug (if implemented)

**Test Criteria**:
- Manual test: Verify slug is displayed
- Test: Verify slug validation works

**Note**: This is optional. Slug can be auto-generated without user visibility.

---

### Task 8: Add Name Conflict Check to Workspace Update

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add name conflict check when updating workspace name.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/features/workspace/domain/usecases/update_workspace.dart` (if exists)
- `lib/app/pages/workspace/workspace_settings_page.dart` (if name can be edited there)

**Implementation Steps**:
1. Update `WorkspaceController.updateWorkspace`:
   - Check name uniqueness before updating
   - Exclude current workspace from check
   - Show error if name conflicts
   - Prevent update if conflict exists
2. Add validation in update flow:
   ```dart
   Future<void> updateWorkspace(Workspace workspace) async {
     // Check name uniqueness (exclude current workspace)
     final nameCheck = await _workspaceRepository.isWorkspaceNameAvailable(
       workspace.name,
       excludeWorkspaceId: workspace.id,
     );
     
     nameCheck.fold(
       (failure) {
         SnackbarService().showError(
           title: AppStrings.I.error,
           message: AppStrings.I.failedToCheckWorkspaceName,
         );
       },
       (isAvailable) {
         if (!isAvailable) {
           SnackbarService().showError(
             title: AppStrings.I.error,
             message: AppStrings.I.workspaceNameAlreadyExists,
           );
           return;
         }
         // Proceed with update
         // ...
       },
     );
   }
   ```
3. Update UI to show validation errors:
   - Show error in name field
   - Prevent save if name conflicts

**Expected Results**:
- ✅ Name conflict check works when updating
- ✅ Current workspace is excluded from check
- ✅ Error messages are clear
- ✅ Update is prevented for conflicts

**Test Criteria**:
- Test: Update workspace name to conflict, verify error
- Test: Update workspace name to same name, verify no error
- Test: Update workspace name to unique name, verify success

---

### Task 9: Add Slug Conflict Check to Workspace Update

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add slug conflict check when updating workspace name (which may change slug).

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/features/workspace/domain/usecases/update_workspace.dart` (if exists)

**Implementation Steps**:
1. Update `WorkspaceController.updateWorkspace`:
   - Generate slug from new name
   - Check slug uniqueness (exclude current workspace)
   - Handle slug collisions
   - Update slug in workspace entity
2. Implement slug update logic:
   ```dart
   Future<void> updateWorkspace(Workspace workspace) async {
     // Generate slug from name
     String newSlug = WorkspaceValidator.generateWorkspaceSlug(workspace.name);
     
     // Check slug uniqueness (exclude current workspace)
     final slugCheck = await _workspaceRepository.isWorkspaceSlugAvailable(
       newSlug,
       excludeWorkspaceId: workspace.id,
     );
     
     slugCheck.fold(
       (failure) {
         // Handle error
       },
       (isAvailable) {
         if (!isAvailable) {
           // Handle collision (generate alternative)
           newSlug = await generateUniqueSlug(newSlug, workspace.id);
         }
         
         // Update workspace with new slug
         final updatedWorkspace = workspace.copyWith(slug: newSlug);
         // Proceed with update
       },
     );
   }
   ```
3. Update slug in Firebase when name changes

**Expected Results**:
- ✅ Slug conflict check works when updating
- ✅ Slug is updated when name changes
- ✅ Slug collisions are handled
- ✅ Current workspace is excluded from check

**Test Criteria**:
- Test: Update workspace name, verify slug is updated
- Test: Update to name that generates conflicting slug, verify handling
- Test: Verify slug is stored in Firebase

---

### Task 10: Add Firebase Index for Slug (Performance Optimization)

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add Firebase index for slug field to optimize uniqueness queries.

**Files to Modify**:
- `firebase_database_rules.json` (or Firebase console)
- `firebase.json` (if using Firebase CLI)

**Implementation Steps**:
1. Add index for slug in Firebase:
   ```json
   {
     "rules": {
       "workspaces": {
         ".indexOn": ["slug", "name"],
         // ... existing rules
       }
     }
   }
   ```
2. Update Firebase database rules:
   - Ensure slug field can be queried
   - Ensure name field can be queried
3. Test query performance:
   - Verify queries are faster with index
   - Monitor Firebase usage

**Expected Results**:
- ✅ Firebase index exists for slug
- ✅ Query performance is improved
- ✅ Firebase rules are updated

**Test Criteria**:
- Test: Verify queries are faster
- Test: Verify Firebase rules work correctly

**Note**: This is a performance optimization. Feature works without index but may be slower.

---

### Task 11: Add Debouncing for Remote Checks

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add debouncing to remote uniqueness checks to avoid excessive API calls.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/create_workspace_controller.dart`

**Implementation Steps**:
1. Add debouncing logic:
   ```dart
   Timer? _nameCheckTimer;
   
   void _debouncedNameCheck(String name) {
     _nameCheckTimer?.cancel();
     _nameCheckTimer = Timer(Duration(milliseconds: 500), () {
       isWorkspaceNameAvailable(name);
     });
   }
   ```
2. Update name field onChange:
   - Call debounced check instead of immediate check
   - Cancel previous timer if user types again
3. Consider local check first:
   - Do local check immediately (fast)
   - Do remote check after debounce (slower but comprehensive)

**Expected Results**:
- ✅ Remote checks are debounced
- ✅ Excessive API calls are prevented
- ✅ User experience is smooth

**Test Criteria**:
- Test: Type quickly in name field, verify limited API calls
- Test: Verify debouncing works correctly
- Test: Verify user experience is smooth

---

### Task 12: Add Unit Tests for Name/Slug Conflict Checking

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for name/slug conflict checking functionality.

**Files to Create/Modify**:
- `test/features/workspace/data/repositories/workspace_repository_impl_test.dart`
- `test/features/workspace/data/datasources/workspace_remote_data_source_impl_test.dart`
- `test/features/workspace/domain/usecases/create_workspace_test.dart`

**Implementation Steps**:
1. Test `isWorkspaceNameAvailable`:
   - Test with available name
   - Test with unavailable name
   - Test with excluded workspace ID
   - Test case-insensitive comparison
   - Test error handling
2. Test `isWorkspaceSlugAvailable`:
   - Test with available slug
   - Test with unavailable slug
   - Test with excluded workspace ID
   - Test with workspaces without slug (generates for comparison)
   - Test error handling
3. Test slug generation:
   - Test various name formats
   - Test edge cases
   - Test collision handling
4. Test workspace creation with slug:
   - Test slug is generated
   - Test slug is stored
   - Test slug collision handling
5. Test workspace update with slug:
   - Test slug is updated when name changes
   - Test slug conflict handling

**Expected Results**:
- ✅ Unit tests cover name/slug conflict checking
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Add Slug Field to Workspace Entity (Critical - Foundation)
2. **Task 2**: Implement Remote Name Uniqueness Check (High Priority - Core Feature)
3. **Task 3**: Implement Remote Slug Uniqueness Check (High Priority - Core Feature)
4. **Task 4**: Implement Slug Generation During Workspace Creation (High Priority - Core Feature)
5. **Task 5**: Implement Slug Collision Handling (Medium Priority - Feature Completeness)
6. **Task 6**: Update CreateWorkspaceController to Use Remote Checks (High Priority - Integration)
7. **Task 8**: Add Name Conflict Check to Workspace Update (Medium Priority - Feature Completeness)
8. **Task 9**: Add Slug Conflict Check to Workspace Update (Medium Priority - Feature Completeness)
9. **Task 11**: Add Debouncing for Remote Checks (Medium Priority - Performance)
10. **Task 10**: Add Firebase Index for Slug (Low Priority - Performance Optimization)
11. **Task 7**: Update CreateWorkspacePage to Show Slug (Low Priority - UX Enhancement)
12. **Task 12**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Workspace entity has slug field
- ✅ Remote name uniqueness check exists
- ✅ Remote slug uniqueness check exists
- ✅ Slug is generated during workspace creation
- ✅ Slug collisions are handled
- ✅ Name conflict check works when updating
- ✅ Slug conflict check works when updating
- ✅ Remote checks are debounced
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ Performance is acceptable
- ✅ No known bugs or issues

---

## Dependencies

- **WorkspaceRepository**: Must support name/slug availability checks
- **WorkspaceRemoteDataSource**: Must support remote checks in Firebase
- **Firebase Realtime Database**: Must support slug field and queries
- **WorkspaceValidator**: Must have slug generation/validation methods
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **SnackbarService**: Must use SnackbarService for notifications

---

## Notes

1. **Local vs Remote**: Local check is fast but only checks loaded workspaces. Remote check is slower but comprehensive. Use local check first for performance, then remote check for accuracy.

2. **Slug Generation**: Slug should be generated automatically from name. User doesn't need to manually create slug, but may be able to see/override it (optional).

3. **Collision Handling**: When slug collision is detected, system should auto-generate alternative (e.g., "my-workspace-2"). This prevents user friction.

4. **Performance**: Remote checks should be debounced to avoid excessive API calls. Consider caching results for better performance.

5. **Backward Compatibility**: Existing workspaces without slug should still work. Slug can be generated on-the-fly when needed.

6. **Case Sensitivity**: Name checks should be case-insensitive. Slug checks should also be case-insensitive (slugs are lowercase by design).

7. **Update Exclusions**: When updating workspace, current workspace should be excluded from conflict checks (can keep same name/slug).

---

## Related Documentation

- `WORKSPACE_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `WORKSPACE_NAME_SLUG_CONFLICT_TEST_CASES.md` - Test cases for this feature
- `WORKSPACE_CREATION_TEST_CASES.md` - Related workspace creation tests
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/PERFORMANCE_AND_ENUM_RULES.md` - Performance requirements

