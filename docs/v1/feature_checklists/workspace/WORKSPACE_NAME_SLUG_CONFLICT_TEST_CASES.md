# Workspace Name/Slug Conflict Checking - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Workspace Name/Slug Conflict Checking** feature. This feature is currently **PARTIAL** - name check exists but only locally, slug helpers exist but unused, and no remote uniqueness check.

## Prerequisites
- User must be logged in
- Device should have internet connection (for Firebase sync)
- Multiple users may be needed for testing remote conflicts

---

## Test Case 1: Local Name Uniqueness Check - Happy Path

**Objective**: Verify local name uniqueness check works correctly.

**Preconditions**:
- User is logged in
- User has at least one existing workspace (e.g., "My Workspace")
- User is on the Create Workspace screen

**Steps**:
1. Navigate to Create Workspace screen
2. Tap on the "Workspace Name" input field
3. Enter the exact name of an existing workspace (e.g., "My Workspace")
4. Wait for validation to trigger (may happen automatically as you type or on blur)
5. Verify an error message appears below the Workspace Name field (e.g., "Workspace name already exists")
6. Verify the error message appears before tapping Create button
7. Tap the "Create" button
8. Verify workspace creation is prevented
9. Verify the error message remains visible
10. Change the workspace name to a unique name (e.g., "My New Workspace")
11. Verify the error message disappears
12. Verify the Create button becomes enabled/functional

**Expected Results**:
- ✅ Error message displayed for duplicate name
- ✅ Validation occurs in real-time or on blur
- ✅ Workspace creation is prevented for duplicate names
- ✅ Error clears when name is changed to unique value
- ✅ Case-insensitive check works (e.g., "my workspace" vs "My Workspace")

---

## Test Case 2: Local Name Uniqueness Check - Case Insensitive

**Objective**: Verify name uniqueness check is case-insensitive.

**Preconditions**:
- User is logged in
- User has an existing workspace named "My Workspace"
- User is on the Create Workspace screen

**Steps**:
1. On Create Workspace screen, tap on "Workspace Name" input field
2. Enter "MY WORKSPACE" (all uppercase)
3. Verify error message appears: "Workspace name already exists"
4. Change to "my workspace" (all lowercase)
5. Verify error message still appears
6. Change to "My Workspace" (mixed case)
7. Verify error message still appears
8. Change to "My New Workspace" (different name)
9. Verify error message disappears

**Expected Results**:
- ✅ Name check is case-insensitive
- ✅ All case variations of existing name are detected as duplicates
- ✅ Only truly unique names are accepted

---

## Test Case 3: Remote Name Uniqueness Check - Missing Feature

**Objective**: Verify remote name uniqueness check (currently missing).

**Preconditions**:
- User A is logged in
- User B is logged in (different account)
- User B has a workspace named "Shared Workspace"
- User A is on the Create Workspace screen

**Steps**:
1. As User A, navigate to Create Workspace screen
2. Enter workspace name "Shared Workspace" (same as User B's workspace)
3. Verify one of the following:
   - **If NOT implemented**: No error appears (this is expected - feature missing)
   - **If implemented**: Error message appears: "Workspace name already exists" or "This workspace name is already taken"
4. If implemented:
   - Verify error appears after remote check completes
   - Verify workspace creation is prevented
   - Change to unique name
   - Verify error disappears
   - Verify workspace can be created

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Remote name check is NOT available (missing)
- ✅ **When implemented**: Remote name conflicts are detected
- ✅ Error message is clear and helpful
- ✅ Workspace creation is prevented for remote conflicts

---

## Test Case 4: Slug Generation - Missing Feature

**Objective**: Verify workspace slug is generated from name (currently missing).

**Preconditions**:
- User is logged in
- User is on the Create Workspace screen
- Slug generation feature is implemented

**Steps**:
1. Navigate to Create Workspace screen
2. Enter workspace name "My Test Workspace"
3. Verify one of the following:
   - **If NOT implemented**: No slug is generated (this is expected - feature missing)
   - **If implemented**: Slug is generated automatically (e.g., "my-test-workspace")
4. If implemented:
   - Verify slug is generated in real-time as user types
   - Verify slug is displayed (optional - may be hidden)
   - Verify slug follows correct format:
     - Lowercase
     - Spaces replaced with hyphens
     - Special characters removed
     - No consecutive hyphens
     - No leading/trailing hyphens
5. Test various name formats:
   - "My Workspace" → "my-workspace"
   - "My@Test#Workspace!" → "mytestworkspace"
   - "My   Test   Workspace" → "my-test-workspace"
   - "My--Test--Workspace" → "my-test-workspace"

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Slug generation is NOT available (missing)
- ✅ **When implemented**: Slug is generated correctly
- ✅ Slug format follows rules
- ✅ Special characters are handled correctly

---

## Test Case 5: Slug Validation - Missing Feature

**Objective**: Verify slug validation works correctly (currently missing).

**Preconditions**:
- User is logged in
- User is on the Create Workspace screen
- Slug validation feature is implemented

**Steps**:
1. Navigate to Create Workspace screen
2. If slug field is editable, test various invalid slugs:
   - Empty slug: ""
   - Too short: "a"
   - Too long: "a" * 31
   - Invalid characters: "invalid_slug" or "invalid@slug"
   - Consecutive hyphens: "invalid--slug"
   - Leading hyphen: "-invalid-slug"
   - Trailing hyphen: "invalid-slug-"
3. Verify error messages appear for invalid slugs
4. Verify workspace creation is prevented for invalid slugs
5. Test valid slugs:
   - "valid-slug"
   - "valid-slug-123"
   - "my-workspace"
6. Verify valid slugs are accepted

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Slug validation is NOT available (missing)
- ✅ **When implemented**: Slug validation works correctly
- ✅ Invalid slugs are rejected
- ✅ Valid slugs are accepted
- ✅ Error messages are clear

---

## Test Case 6: Remote Slug Uniqueness Check - Missing Feature

**Objective**: Verify remote slug uniqueness check (currently missing).

**Preconditions**:
- User A is logged in
- User B is logged in (different account)
- User B has a workspace with slug "my-workspace"
- User A is on the Create Workspace screen
- Slug uniqueness check feature is implemented

**Steps**:
1. As User A, navigate to Create Workspace screen
2. Enter workspace name that generates slug "my-workspace" (same as User B's workspace slug)
3. Verify one of the following:
   - **If NOT implemented**: No error appears (this is expected - feature missing)
   - **If implemented**: Error message appears: "Workspace slug already exists" or "This workspace identifier is already taken"
4. If implemented:
   - Verify error appears after remote check completes
   - Verify workspace creation is prevented
   - Verify slug collision handling:
     - **Option A**: Auto-generate alternative slug (e.g., "my-workspace-2")
     - **Option B**: Show error and require user to change name
     - **Option C**: Show error with suggestion for alternative name
5. If auto-generation:
   - Verify alternative slug is generated
   - Verify workspace can be created with alternative slug
6. If manual change required:
   - Change workspace name to generate unique slug
   - Verify error disappears
   - Verify workspace can be created

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Remote slug check is NOT available (missing)
- ✅ **When implemented**: Remote slug conflicts are detected
- ✅ Slug collision is handled appropriately
- ✅ Error message is clear and helpful

---

## Test Case 7: Slug Collision Handling - Auto-Generation

**Objective**: Verify automatic slug collision resolution (if implemented).

**Preconditions**:
- User is logged in
- User has workspaces with slugs: "my-workspace", "my-workspace-2"
- User is on the Create Workspace screen
- Auto-generation feature is implemented

**Steps**:
1. Navigate to Create Workspace screen
2. Enter workspace name "My Workspace" (generates slug "my-workspace")
3. Verify slug collision is detected
4. Verify alternative slug is auto-generated:
   - First collision: "my-workspace-2" (if "my-workspace" exists)
   - Second collision: "my-workspace-3" (if "my-workspace-2" exists)
   - Continue incrementing until unique slug found
5. Verify auto-generated slug is displayed (if visible)
6. Verify workspace can be created with auto-generated slug
7. Verify created workspace uses the auto-generated slug

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Auto-generation is NOT available (missing)
- ✅ **When implemented**: Slug collisions are resolved automatically
- ✅ Incremental numbering works correctly
- ✅ Workspace is created with unique slug

---

## Test Case 8: Update Workspace Name - Name Conflict Check

**Objective**: Verify name conflict check when updating workspace name.

**Preconditions**:
- User is logged in
- User has workspaces: "Workspace A" and "Workspace B"
- User is on Workspace Settings or Edit Workspace screen
- Name conflict check on update is implemented

**Steps**:
1. Navigate to edit "Workspace A"
2. Change name to "Workspace B" (conflicts with existing workspace)
3. Verify one of the following:
   - **If NOT implemented**: No error appears (this is expected - feature missing)
   - **If implemented**: Error message appears: "Workspace name already exists"
4. If implemented:
   - Verify error appears in real-time or on blur
   - Verify save is prevented
   - Verify current workspace name is excluded from conflict check (can keep same name)
5. Change name to unique value (e.g., "Workspace C")
6. Verify error disappears
7. Save changes
8. Verify workspace name is updated successfully

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Name conflict check on update is NOT available (missing)
- ✅ **When implemented**: Name conflicts are detected when updating
- ✅ Current workspace name is excluded from check
- ✅ Save is prevented for conflicts

---

## Test Case 9: Update Workspace Name - Slug Conflict Check

**Objective**: Verify slug conflict check when updating workspace name (if implemented).

**Preconditions**:
- User is logged in
- User has workspaces with slugs: "workspace-a" and "workspace-b"
- User is on Workspace Settings or Edit Workspace screen
- Slug conflict check on update is implemented

**Steps**:
1. Navigate to edit workspace with slug "workspace-a"
2. Change name to generate slug "workspace-b" (conflicts with existing workspace)
3. Verify one of the following:
   - **If NOT implemented**: No error appears (this is expected - feature missing)
   - **If implemented**: Error message appears: "Workspace slug already exists"
4. If implemented:
   - Verify error appears after slug generation
   - Verify save is prevented
   - Verify current workspace slug is excluded from conflict check
5. Change name to generate unique slug (e.g., "workspace-c")
6. Verify error disappears
7. Save changes
8. Verify workspace slug is updated successfully

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Slug conflict check on update is NOT available (missing)
- ✅ **When implemented**: Slug conflicts are detected when updating
- ✅ Current workspace slug is excluded from check
- ✅ Save is prevented for conflicts

---

## Test Case 10: Name Validation - Edge Cases

**Objective**: Verify name validation handles edge cases correctly.

**Preconditions**:
- User is logged in
- User is on the Create Workspace screen

**Steps**:
1. Test empty name:
   - Leave name field empty
   - Verify error: "Please enter workspace name" or "Workspace name is required"
2. Test too short name:
   - Enter single character "A"
   - Verify error: "Workspace name must be at least 2 characters"
3. Test too long name:
   - Enter name with 51+ characters
   - Verify error: "Workspace name must be less than 50 characters"
4. Test invalid characters:
   - Enter name with invalid characters: "My<Workspace>"
   - Verify error: "Workspace name contains invalid characters"
5. Test whitespace-only name:
   - Enter "   " (only spaces)
   - Verify error or name is trimmed
6. Test name with leading/trailing spaces:
   - Enter "  My Workspace  "
   - Verify name is trimmed before validation
   - Verify trimmed name is used for conflict check

**Expected Results**:
- ✅ All edge cases are handled correctly
- ✅ Error messages are clear
- ✅ Name is trimmed before validation
- ✅ Validation prevents invalid names

---

## Test Case 11: Slug Generation - Edge Cases

**Objective**: Verify slug generation handles edge cases correctly (if implemented).

**Preconditions**:
- User is logged in
- User is on the Create Workspace screen
- Slug generation feature is implemented

**Steps**:
1. Test various name formats:
   - "My Workspace" → "my-workspace"
   - "My@Test#Workspace!" → "mytestworkspace"
   - "My   Test   Workspace" → "my-test-workspace"
   - "My--Test--Workspace" → "my-test-workspace"
   - "My_Test_Workspace" → "my-test-workspace"
   - "My Test Workspace 123" → "my-test-workspace-123"
2. Test special characters:
   - "My Workspace!" → "my-workspace"
   - "My@Workspace#" → "myworkspace"
   - "My Workspace & Co." → "my-workspace-co"
3. Test unicode characters:
   - "My Workspace Café" → "my-workspace-caf" (or appropriate handling)
4. Test empty/whitespace name:
   - "" → "" or error
   - "   " → "" or error
5. Verify slug is always lowercase
6. Verify slug has no leading/trailing hyphens
7. Verify slug has no consecutive hyphens

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Slug generation is NOT available (missing)
- ✅ **When implemented**: Edge cases are handled correctly
- ✅ Special characters are removed or converted
- ✅ Slug format is consistent

---

## Test Case 12: Performance - Remote Check Timing

**Objective**: Verify remote uniqueness checks perform efficiently.

**Preconditions**:
- User is logged in
- User is on the Create Workspace screen
- Remote uniqueness check feature is implemented

**Steps**:
1. Navigate to Create Workspace screen
2. Enter workspace name
3. Verify remote check timing:
   - Check should complete within reasonable time (e.g., < 2 seconds)
   - Loading indicator should appear during check (if check is async)
   - UI should remain responsive
4. Test with slow network:
   - Simulate slow network connection
   - Enter workspace name
   - Verify check still completes (may take longer)
   - Verify timeout handling (if implemented)
5. Test with offline network:
   - Disable network connection
   - Enter workspace name
   - Verify appropriate error message or fallback behavior

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Remote check is NOT available (missing)
- ✅ **When implemented**: Remote checks are performant
- ✅ Loading indicators are shown
- ✅ Timeout and offline scenarios are handled

---

## Test Case 13: Concurrent Workspace Creation - Race Condition

**Objective**: Verify handling of concurrent workspace creation with same name/slug.

**Preconditions**:
- User A and User B are logged in (different accounts)
- Both users try to create workspace with same name simultaneously
- Remote uniqueness check feature is implemented

**Steps**:
1. As User A, navigate to Create Workspace screen
2. As User B, navigate to Create Workspace screen
3. Both users enter same workspace name (e.g., "New Workspace")
4. Both users tap "Create" button at nearly the same time
5. Verify one of the following outcomes:
   - **Option A**: First creation succeeds, second fails with conflict error
   - **Option B**: Both creations are queued, first succeeds, second fails
   - **Option C**: Transaction/atomic check prevents both from succeeding
6. Verify error message for failed creation is clear
7. Verify successful creation uses correct name/slug

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Race condition handling is NOT available (missing)
- ✅ **When implemented**: Concurrent creations are handled correctly
- ✅ Only one workspace with same name/slug is created
- ✅ Error messages are clear for failed creation

---

## Test Case 14: Slug Storage and Retrieval

**Objective**: Verify slug is stored and retrieved correctly (if implemented).

**Preconditions**:
- User is logged in
- Slug field is added to Workspace entity
- Slug storage feature is implemented

**Steps**:
1. Create a workspace with name "My Test Workspace"
2. Verify slug "my-test-workspace" is generated
3. Verify slug is stored in Firebase:
   - Check Firebase database
   - Verify slug field exists in workspace data
   - Verify slug value is correct
4. Retrieve workspace from Firebase
5. Verify slug is retrieved correctly:
   - Workspace entity has slug field
   - Slug value matches stored value
6. Update workspace name
7. Verify slug is updated accordingly
8. Verify slug persists across app restarts

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Slug storage is NOT available (missing)
- ✅ **When implemented**: Slug is stored correctly
- ✅ Slug is retrieved correctly
- ✅ Slug persists across sessions

---

## Test Case 15: Slug Usage in URLs/Sharing

**Objective**: Verify slug can be used for workspace URLs/sharing (if implemented).

**Preconditions**:
- User is logged in
- Workspace has slug "my-workspace"
- Slug-based URLs/sharing feature is implemented

**Steps**:
1. Navigate to workspace with slug "my-workspace"
2. Verify one of the following:
   - **If NOT implemented**: URL uses workspace ID (this is expected - feature missing)
   - **If implemented**: URL uses slug (e.g., "/workspace/my-workspace")
3. If implemented:
   - Verify URL is human-readable
   - Verify workspace can be accessed via slug URL
   - Test workspace sharing:
     - Share workspace link
     - Verify link uses slug
     - Verify link works for other users (with permissions)
   - Test invalid slug:
     - Try to access workspace with invalid slug
     - Verify appropriate error (404 or redirect)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Slug-based URLs are NOT available (missing)
- ✅ **When implemented**: Slug can be used in URLs
- ✅ URLs are human-readable
- ✅ Sharing works correctly

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Local name uniqueness check works
- [ ] Name check is case-insensitive
- [ ] Remote name uniqueness check works (if implemented)
- [ ] Slug generation works (if implemented)
- [ ] Slug validation works (if implemented)
- [ ] Remote slug uniqueness check works (if implemented)
- [ ] Slug collision handling works (if implemented)
- [ ] Name conflict check on update works (if implemented)
- [ ] Slug conflict check on update works (if implemented)
- [ ] Edge cases are handled correctly
- [ ] Performance is acceptable
- [ ] Race conditions are handled (if implemented)
- [ ] Slug storage works (if implemented)
- [ ] Slug retrieval works (if implemented)
- [ ] Slug-based URLs work (if implemented)

---

## Known Issues (Based on Audit Report)

1. **Local Name Check Only**:
   - `WorkspaceValidator.isWorkspaceNameAvailable` only checks against local list
   - Does not check against all workspaces in Firebase
   - **Status**: ⚠️ Partial

2. **Slug Helpers Unused**:
   - `generateWorkspaceSlug` and `validateWorkspaceSlug` exist but are not used
   - No slug field in Workspace entity
   - **Status**: ⚠️ Partial

3. **No Remote Uniqueness Check**:
   - No server-side uniqueness check for name or slug
   - Can create workspaces with duplicate names across different users
   - **Status**: ⛔ Missing

4. **No Slug in Entity**:
   - Workspace entity doesn't have slug field
   - Slug cannot be stored or retrieved
   - **Status**: ⛔ Missing

---

## Notes for Testers

1. **Current Status**: Name conflict checking is partially implemented (local only). Slug functionality is completely missing.

2. **Local vs Remote**: Local check only validates against workspaces loaded in memory. Remote check would validate against all workspaces in Firebase.

3. **Slug Purpose**: Slug is a URL-friendly identifier derived from workspace name. It should be unique and used for workspace URLs/sharing.

4. **Conflict Resolution**: When conflicts are detected, system should either:
   - Auto-generate alternative (e.g., "my-workspace-2")
   - Show error and require user to change name
   - Show error with suggestion for alternative name

5. **Performance**: Remote checks should be fast and non-blocking. Consider debouncing for real-time checks.

6. **Race Conditions**: Multiple users creating workspaces with same name simultaneously should be handled correctly.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- User account(s) used
- Workspace name(s) and slug(s) (if applicable)
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase data (if accessible) showing workspace names/slugs
- Network conditions (online/offline, slow/fast)
