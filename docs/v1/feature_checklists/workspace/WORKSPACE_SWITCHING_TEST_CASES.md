# Workspace Switching Test Cases

## Overview
This document contains step-by-step test cases for testing the **Workspace Switching** feature (fast switching and remembering last selection). This feature is currently **PARTIAL** - switching works, but "remember last" functionality is broken due to stubbed cache parsing.

## Prerequisites
- User must be logged into the application
- User must have access to multiple workspaces (at least 2)
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: Switch Workspace - Happy Path

**Objective**: Verify successful switching between workspaces.

**Preconditions**:
- User is logged in
- User has access to at least 2 workspaces
- User is on Dashboard or any screen with workspace selector

**Steps**:
1. Navigate to workspace selector:
   - Tap on workspace name/selector in header/navigation
   - OR navigate to workspace management/settings
2. Verify workspace selector/list is displayed showing:
   - All available workspaces
   - Current workspace is highlighted/selected (checkmark or highlight)
   - Workspace names and types are displayed
3. Identify a different workspace to switch to (not the current one)
4. Tap on the workspace item to switch
5. Verify loading indicator appears (if implemented)
6. Wait for switching process to complete
7. Verify success message appears (e.g., "Workspace switched successfully")
8. Verify the selected workspace is now highlighted/selected
9. Verify current workspace is updated:
   - Workspace name in header/navigation updates
   - Workspace-specific data is loaded
   - Workspace members are loaded (if applicable)
10. Verify workspace data is filtered correctly for new workspace

**Expected Results**:
- ✅ Workspace switching succeeds
- ✅ Current workspace is updated
- ✅ Success message is displayed
- ✅ UI reflects the new current workspace
- ✅ Workspace-specific data is loaded

---

## Test Case 2: Switch Workspace - Verify Storage Persistence

**Objective**: Verify workspace ID is saved to local storage when switching.

**Preconditions**:
- User is logged in
- User has access to multiple workspaces
- User is on workspace selector

**Steps**:
1. Note the current workspace ID
2. Switch to a different workspace (Workspace B)
3. Verify switching succeeds
4. Check local storage (if accessible):
   - Verify `StorageService.getWorkspaceId()` returns Workspace B ID
   - OR check SharedPreferences for workspace_id key
5. Switch to another workspace (Workspace C)
6. Verify local storage is updated with Workspace C ID
7. Verify previous workspace ID is replaced (not added)

**Expected Results**:
- ✅ Workspace ID is saved to local storage
- ✅ Storage is updated on each switch
- ✅ Only one workspace ID is stored (current workspace)

**Note**: May require checking storage directly or using debug tools.

---

## Test Case 3: Switch Workspace - Verify Firebase Preferences Update

**Objective**: Verify workspace preference is updated in Firebase when switching.

**Preconditions**:
- User is logged in
- User has access to multiple workspaces
- Firebase is accessible for verification

**Steps**:
1. Note current workspace ID
2. Switch to a different workspace (Workspace B)
3. Verify switching succeeds
4. Check Firebase Realtime Database:
   - Navigate to `users/{userId}/preferences/currentWorkspaceId`
   - Verify value is updated to Workspace B ID
5. Switch to another workspace (Workspace C)
6. Verify Firebase preference is updated to Workspace C ID

**Expected Results**:
- ✅ Firebase preference is updated on workspace switch
- ✅ Preference reflects current workspace ID
- ✅ Preference is synced across devices

**Note**: May require Firebase console access.

---

## Test Case 4: Remember Last Workspace - App Restart (CURRENTLY BROKEN)

**Objective**: Verify last selected workspace is remembered after app restart.

**Preconditions**:
- User is logged in
- User has access to multiple workspaces
- User has switched to a specific workspace (not the first one)

**Steps**:
1. Switch to a specific workspace (e.g., "Workspace B")
2. Verify switching succeeds
3. Note the workspace name/ID
4. Close the app completely
5. Reopen the app
6. Log in with same credentials
7. Wait for app to load
8. Verify one of the following:
   - **If implemented**: Last workspace (Workspace B) is automatically selected/loaded
   - **If NOT implemented**: First workspace or no workspace is selected (this is expected based on audit report)
9. Check workspace selector:
   - Verify which workspace is highlighted/selected
   - Verify if it matches the last selected workspace

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Last workspace is NOT remembered (cache parsing is stubbed)
- ✅ **When implemented**: Last selected workspace is automatically loaded after app restart
- ✅ Workspace is set as current workspace on app launch

---

## Test Case 5: Remember Last Workspace - Multiple Switches

**Objective**: Verify last workspace is remembered after multiple switches.

**Preconditions**:
- User is logged in
- User has access to at least 3 workspaces

**Steps**:
1. Switch to Workspace A
2. Verify Workspace A is current
3. Switch to Workspace B
4. Verify Workspace B is current
5. Switch to Workspace C
6. Verify Workspace C is current
7. Close and reopen the app
8. Log in
9. Verify one of the following:
   - **If implemented**: Workspace C (last selected) is loaded
   - **If NOT implemented**: First workspace or no workspace is loaded
10. Verify workspace selector shows correct workspace as selected

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Last workspace may not be remembered
- ✅ **When implemented**: Last workspace (Workspace C) is remembered and loaded

---

## Test Case 6: Switch Workspace - Loading State

**Objective**: Verify loading state during workspace switching.

**Preconditions**:
- User is logged in
- User has access to multiple workspaces
- Device has internet connection

**Steps**:
1. Navigate to workspace selector
2. Tap on a different workspace to switch
3. Immediately verify:
   - Loading indicator appears (spinner/progress)
   - Workspace selector is disabled (if implemented)
   - Current workspace is disabled (if implemented)
4. Wait for switching to complete
5. Verify loading indicator disappears
6. Verify success message appears
7. Verify workspace is switched

**Expected Results**:
- ✅ Loading indicator is visible during switching
- ✅ UI is disabled during loading (if implemented)
- ✅ User cannot trigger multiple switch requests
- ✅ Loading state clears after completion

---

## Test Case 7: Switch Workspace - Network Error Handling

**Objective**: Verify error handling when network connection fails during switching.

**Preconditions**:
- User is logged in
- User has access to multiple workspaces
- Device internet connection can be disabled

**Steps**:
1. Navigate to workspace selector
2. Disable internet connection (Airplane mode or disable WiFi/Mobile data)
3. Tap on a different workspace to switch
4. Verify loading indicator appears
5. Wait for network timeout/error
6. Verify an error message appears (e.g., "Network error" or "Failed to switch workspace")
7. Verify loading indicator disappears
8. Verify current workspace remains unchanged (not switched)
9. Re-enable internet connection
10. Try switching again
11. Verify switching succeeds this time

**Expected Results**:
- ✅ Error message displayed for network failures
- ✅ Current workspace is not changed on error
- ✅ User can retry after network is restored
- ✅ Workspace state remains consistent

---

## Test Case 8: Switch Workspace - Permission Denied

**Objective**: Verify switching is blocked if user doesn't have access to workspace.

**Preconditions**:
- User is logged in
- User has access to some workspaces but not all
- OR user's access to a workspace is revoked

**Steps**:
1. Navigate to workspace selector
2. Identify a workspace user doesn't have access to (if visible)
3. Attempt to switch to that workspace
4. Verify one of the following:
   - Workspace is not visible in list (filtered out)
   - OR error message appears: "User does not have access to this workspace"
   - OR switching is blocked
5. Verify current workspace remains unchanged
6. Verify appropriate error message is displayed

**Expected Results**:
- ✅ Switching is blocked for workspaces without access
- ✅ Error message is clear and user-friendly
- ✅ Current workspace is not changed

---

## Test Case 9: Switch Workspace - Rapid Switching

**Objective**: Verify handling of rapid multiple workspace switches.

**Preconditions**:
- User is logged in
- User has access to multiple workspaces

**Steps**:
1. Navigate to workspace selector
2. Rapidly switch between workspaces (tap 3-5 different workspaces quickly)
3. Verify one of the following:
   - Only the last switch is processed
   - OR all switches are queued and processed sequentially
   - OR switches are debounced
4. Wait for all operations to complete
5. Verify final workspace is the last one selected
6. Verify no duplicate operations occur
7. Verify workspace state is consistent

**Expected Results**:
- ✅ Rapid switches are handled correctly
- ✅ Only one workspace switch is active at a time
- ✅ Final workspace matches last selection
- ✅ No race conditions or inconsistent states

---

## Test Case 10: Switch Workspace - Verify Workspace Members Load

**Objective**: Verify workspace members are loaded when switching workspace.

**Preconditions**:
- User is logged in
- User has access to multiple workspaces
- Workspaces have different members

**Steps**:
1. Switch to Workspace A
2. Navigate to workspace members/settings (if available)
3. Note the members in Workspace A
4. Switch to Workspace B
5. Verify workspace members are loaded for Workspace B
6. Navigate to workspace members/settings
7. Verify members list shows Workspace B members (not Workspace A members)
8. Verify members are different from Workspace A

**Expected Results**:
- ✅ Workspace members are loaded when switching
- ✅ Members list updates correctly
- ✅ Members are specific to the current workspace

---

## Test Case 11: Switch Workspace - Verify Data Filtering

**Objective**: Verify data (tasks, projects) is filtered by current workspace after switching.

**Preconditions**:
- User is logged in
- User has access to multiple workspaces
- Each workspace has different tasks/projects

**Steps**:
1. Switch to Workspace A
2. Navigate to Tasks or Projects list
3. Note the tasks/projects visible (belonging to Workspace A)
4. Switch to Workspace B
5. Navigate to Tasks or Projects list
6. Verify tasks/projects list shows only Workspace B data
7. Verify Workspace A data is not visible
8. Switch back to Workspace A
9. Verify Workspace A data is visible again
10. Verify Workspace B data is not visible

**Expected Results**:
- ✅ Data is filtered by current workspace
- ✅ Only current workspace data is visible
- ✅ Data updates correctly when switching

---

## Test Case 12: Switch Workspace - App Backgrounding During Switch

**Objective**: Verify behavior when app is backgrounded during workspace switching.

**Preconditions**:
- User is logged in
- User has access to multiple workspaces

**Steps**:
1. Navigate to workspace selector
2. Tap on a different workspace to switch
3. Immediately background the app (press home button or switch apps)
4. Wait 5-10 seconds
5. Return to the app
6. Verify one of the following:
   - Workspace was switched successfully
   - OR switching is still in progress
   - OR error message appears if switching failed
7. Verify app state is consistent
8. Verify current workspace is correct

**Expected Results**:
- ✅ App handles backgrounding gracefully
- ✅ Workspace switching completes or fails appropriately
- ✅ App state is consistent after returning

---

## Test Case 13: Switch to Same Workspace (No-op)

**Objective**: Verify switching to the same workspace doesn't trigger unnecessary operations.

**Preconditions**:
- User is logged in
- User has a current workspace (Workspace A)

**Steps**:
1. Note current workspace (Workspace A)
2. Navigate to workspace selector
3. Tap on Workspace A (current workspace)
4. Verify one of the following:
   - No operation is triggered (early return)
   - OR operation completes quickly without changes
5. Verify no loading indicator appears (or appears briefly)
6. Verify no success message appears (or appears briefly)
7. Verify current workspace remains Workspace A
8. Verify no unnecessary API calls are made

**Expected Results**:
- ✅ Switching to same workspace is a no-op
- ✅ No unnecessary operations are triggered
- ✅ Performance is optimized

---

## Test Case 14: Switch Workspace - Initial Load Without Cache (CURRENTLY BROKEN)

**Objective**: Verify workspace is loaded from cache on initial app load.

**Preconditions**:
- User is logged in
- User has switched to a specific workspace previously
- App is closed

**Steps**:
1. Close the app completely
2. Reopen the app
3. Log in with same credentials
4. Monitor the initial load process:
   - Check if cached workspace is read
   - Check if last workspace ID is retrieved from storage
   - Check if workspace is loaded from cache or Firebase
5. Verify one of the following:
   - **If implemented**: Cached workspace is loaded first, then synced with Firebase
   - **If NOT implemented**: Workspace is loaded only from Firebase (this is expected)
6. Verify workspace selector shows correct workspace as selected

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Cache is not read (parsing is stubbed)
- ✅ **When implemented**: Cached workspace is loaded on initial app load
- ✅ Workspace is set as current workspace from cache
- ✅ Cache is then synced with Firebase

---

## Test Case 15: Switch Workspace - Cache Parsing (CURRENTLY STUBBED)

**Objective**: Verify workspace cache parsing works correctly.

**Preconditions**:
- User is logged in
- User has switched workspaces (workspace is cached)

**Steps**:
1. Switch to a workspace (Workspace B)
2. Verify workspace is cached (check if cacheCurrentWorkspace is called)
3. Close and reopen the app
4. Log in
5. Check if cached workspace is retrieved:
   - Call `WorkspaceLocalDataSource.getCachedCurrentWorkspace()`
   - Verify one of the following:
     - **If implemented**: Returns Workspace B
     - **If NOT implemented**: Returns null (this is expected - parsing is stubbed)
6. Verify workspace is loaded from cache or Firebase accordingly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Cache parsing returns null (stubbed)
- ✅ **When implemented**: Cache parsing returns correct workspace
- ✅ Workspace is deserialized correctly from cache

---

## Test Case 16: Switch Workspace - Multiple Devices Sync

**Objective**: Verify workspace switching syncs across multiple devices.

**Preconditions**:
- User is logged in on Device A
- User is logged in on Device B (same account)
- Both devices have internet connection

**Steps**:
1. On Device A, switch to Workspace B
2. Verify switching succeeds on Device A
3. On Device B, wait a few seconds or refresh
4. Verify one of the following:
   - Workspace B is automatically selected on Device B
   - OR user needs to manually refresh to see the change
   - OR Firebase preference syncs but UI doesn't update automatically
5. Verify Firebase preference is updated on both devices
6. Switch to Workspace C on Device B
7. Verify Workspace C is selected on Device B
8. Check Device A to see if it syncs

**Expected Results**:
- ✅ Firebase preference is synced across devices
- ✅ Workspace switching is reflected on all devices (when implemented)
- ✅ Real-time sync works correctly (if implemented)

---

## Test Case 17: Switch Workspace - Workspace Deleted After Switch

**Objective**: Verify behavior when current workspace is deleted.

**Preconditions**:
- User is logged in
- User has access to multiple workspaces
- User is Account Holder of Workspace A

**Steps**:
1. Switch to Workspace A
2. Delete Workspace A (as Account Holder)
3. Verify workspace is deleted
4. Verify app handles the deleted workspace:
   - App switches to another available workspace
   - OR app shows empty state
   - OR app prompts to select/create workspace
5. Verify workspace selector no longer shows deleted workspace
6. Verify current workspace is updated to another workspace

**Expected Results**:
- ✅ App handles deleted current workspace gracefully
- ✅ App switches to another workspace automatically
- ✅ Deleted workspace is removed from selector

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Workspace switching works correctly
- [ ] Workspace ID is saved to local storage
- [ ] Firebase preference is updated
- [ ] Last workspace is remembered after app restart (when implemented)
- [ ] Loading states work correctly
- [ ] Error handling works for network issues
- [ ] Permission checks work correctly
- [ ] Rapid switches are handled correctly
- [ ] Workspace members are loaded correctly
- [ ] Data filtering works correctly
- [ ] Cache parsing works (when implemented)
- [ ] Multi-device sync works (when implemented)

---

## Known Issues (Based on Audit Report)

1. **Cache Parsing Stubbed**: 
   - `WorkspaceLocalDataSource.getCachedCurrentWorkspace()` returns null
   - `WorkspaceLocalDataSource.getCachedWorkspaces()` returns empty list
   - Parsing is stubbed (not implemented)
   - **Status**: ⚠️ Broken

2. **Initial Load Doesn't Read Cache**:
   - Controller initial load uses `getUserWorkspaces` without reading cached/last workspace
   - Last workspace is not loaded from cache on app start
   - **Status**: ⚠️ Missing

3. **Remember Last Not Working**:
   - Due to stubbed cache parsing, "remember last" functionality doesn't work
   - App always loads first workspace or no workspace on restart
   - **Status**: ⚠️ Broken

---

## Notes for Testers

1. **Cache Parsing**: The cache parsing is currently stubbed. When testing, document that cached workspace is not retrieved.

2. **Remember Last**: The "remember last workspace" feature doesn't work due to stubbed cache. Document this when testing.

3. **Storage Verification**: To verify storage, you may need to:
   - Use debug tools to check SharedPreferences
   - OR check StorageService directly
   - OR check Firebase preferences

4. **Firebase Verification**: For critical tests (like preference sync), you may need to check Firebase Realtime Database directly.

5. **Multi-Device Testing**: Requires two devices or emulators with same account logged in.

6. **Performance**: Test switching performance - should be fast and responsive.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Cache/storage state (if accessible)

