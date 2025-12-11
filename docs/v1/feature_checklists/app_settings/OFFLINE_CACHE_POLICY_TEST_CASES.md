# Offline Cache Policy: Cache Size, Auto-Clear - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Offline Cache Policy** feature. Currently, this feature is **MISSING** - Not implemented. This feature should include: cache size calculation and display, cache auto-clear policy configuration, manual cache clearing, cache size limits, and cache cleanup scheduling.

## Prerequisites
- User must be logged in
- App has cached data (tasks, reports, pagination cache, etc.)
- App settings page is accessible
- Cache policy feature should be implemented (or test cases should document expected behavior)

---

## Test Case 1: Cache Size Display - View Current Cache Size

**Objective**: Verify that users can view current cache size in app settings.

**Preconditions**:
- User is logged in
- App has cached data (tasks, reports, pagination cache, etc.)
- User is on the app settings page
- Cache size display feature is implemented

**Steps**:
1. Navigate to app settings page:
   - From home screen, tap on "Settings" icon or menu
   - OR Tap on profile icon, then tap "Settings"
   - Verify app settings page is displayed

2. Locate cache size section:
   - Scroll to "Storage" or "Cache" or "Offline Storage" section (if needed)
   - **If NOT implemented**: Cache size section is not available (this is expected - feature missing)
   - **If implemented**: 
     - Verify cache size section is displayed:
       - "Cache Size" or "Offline Storage" label
       - Current cache size is displayed (e.g., "125.5 MB")
       - Cache breakdown by category (if available):
         - Tasks cache: "50.2 MB"
         - Reports cache: "30.1 MB"
         - Pagination cache: "25.3 MB"
         - Settings cache: "10.5 MB"
         - User data cache: "9.4 MB"

3. Verify cache size is accurate:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Verify cache size matches actual storage usage
     - Verify cache size updates when data is cached
     - Verify cache size updates when cache is cleared

4. Verify cache size format:
   - Verify cache size is displayed in readable format:
     - Bytes for small sizes (< 1 KB)
     - KB for medium sizes (< 1 MB)
     - MB for large sizes (< 1 GB)
     - GB for very large sizes
   - Verify format is consistent and clear

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Cache size display is NOT implemented (missing)
- ✅ **When implemented**: Current cache size is displayed
- ✅ Cache size is accurate
- ✅ Cache size is formatted clearly
- ✅ Cache breakdown by category is shown (if available)

---

## Test Case 2: Cache Size Calculation - Accurate Size Measurement

**Objective**: Verify that cache size calculation is accurate and includes all cache types.

**Preconditions**:
- User is logged in
- App has cached data in multiple categories
- Cache size calculation feature is implemented

**Steps**:
1. Generate cache data:
   - Create multiple tasks (to generate task cache)
   - Create multiple reports (to generate report cache)
   - Navigate through paginated lists (to generate pagination cache)
   - Change settings (to generate settings cache)
   - Wait for cache to be saved

2. Check cache size calculation:
   - Navigate to app settings
   - Locate cache size section
   - **If NOT implemented**: Cache size is not displayed (this is expected - feature missing)
   - **If implemented**: 
     - Verify total cache size is displayed
     - Verify cache size includes all categories:
       - Hive boxes (userBox, settingsBox, tasksBox, reportsBox)
       - SharedPreferences data
       - Pagination cache
       - Image cache (if applicable)
       - Other cached data

3. Verify calculation accuracy:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Compare displayed size with actual storage usage (if possible)
     - Verify size calculation is consistent
     - Verify size updates correctly when cache changes

4. Test with different cache sizes:
   - Clear cache
   - Verify size is 0 or minimal
   - Add cache data
   - Verify size increases
   - Add more cache data
   - Verify size increases proportionally

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Cache size calculation is NOT implemented (missing)
- ✅ **When implemented**: Cache size calculation is accurate
- ✅ All cache types are included
- ✅ Size calculation is consistent
- ✅ Size updates correctly when cache changes

---

## Test Case 3: Cache Auto-Clear Policy - Set Auto-Clear Interval

**Objective**: Verify that users can configure auto-clear policy (interval, conditions).

**Preconditions**:
- User is logged in
- User is on the app settings page
- Cache auto-clear policy feature is implemented

**Steps**:
1. Navigate to app settings page:
   - From home screen, tap on "Settings" icon or menu
   - Verify app settings page is displayed

2. Locate cache auto-clear policy section:
   - Scroll to "Storage" or "Cache" section (if needed)
   - **If NOT implemented**: Auto-clear policy section is not available (this is expected - feature missing)
   - **If implemented**: 
     - Verify auto-clear policy section is displayed:
       - "Auto-Clear Cache" or "Cache Policy" label
       - Auto-clear toggle or switch
       - Auto-clear interval options (if enabled)

3. Configure auto-clear policy:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Enable auto-clear (if disabled):
       - Tap on "Auto-Clear Cache" toggle
       - Verify toggle is enabled
     - Set auto-clear interval:
       - Tap on "Auto-Clear Interval" option
       - Select interval (e.g., "Daily", "Weekly", "Monthly", "Never")
       - Verify selected interval is displayed
     - Set auto-clear conditions (if available):
       - "Clear when cache exceeds X MB"
       - "Clear old cache only"
       - "Clear on app launch"
       - etc.

4. Save auto-clear policy:
   - Tap "Save" button (if required)
   - Verify settings are saved
   - Verify success message appears (if applicable)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Cache auto-clear policy is NOT implemented (missing)
- ✅ **When implemented**: Users can configure auto-clear policy
- ✅ Auto-clear can be enabled/disabled
- ✅ Auto-clear interval can be set
- ✅ Auto-clear conditions can be configured
- ✅ Policy persists after app restart

---

## Test Case 4: Cache Auto-Clear - Automatic Cache Cleanup

**Objective**: Verify that cache is automatically cleared according to configured policy.

**Preconditions**:
- User is logged in
- App has cached data
- Auto-clear policy is configured (e.g., daily, weekly, or when cache exceeds limit)
- Cache auto-clear feature is implemented

**Steps**:
1. Configure auto-clear policy:
   - Navigate to app settings
   - Enable auto-clear
   - Set auto-clear interval (e.g., "Daily")
   - Save settings

2. Generate cache data:
   - Create tasks, reports, etc.
   - Navigate through app to generate cache
   - Verify cache size increases

3. Wait for auto-clear trigger:
   - **If NOT implemented**: Auto-clear does not trigger (this is expected - feature missing)
   - **If implemented**: 
     - Wait for auto-clear interval to elapse (or trigger condition)
     - OR Manually trigger auto-clear (for testing):
       - Change device date/time to trigger interval
       - OR Exceed cache size limit (if configured)

4. Verify cache is cleared:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Check cache size:
       - Navigate to app settings
       - Verify cache size has decreased
       - OR Verify cache size is 0 (if all cache was cleared)
     - Verify cache data is cleared:
       - Check that cached data is removed
       - Verify app still works correctly after cache clear

5. Verify auto-clear notification (if applicable):
   - Check if notification appears when cache is cleared:
     - "Cache cleared automatically"
     - OR "X MB of cache cleared"
   - Verify notification is informative

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Cache auto-clear is NOT implemented (missing)
- ✅ **When implemented**: Cache is automatically cleared according to policy
- ✅ Auto-clear triggers at configured interval
- ✅ Cache size decreases after auto-clear
- ✅ App continues to work after auto-clear
- ✅ Auto-clear notification appears (if applicable)

---

## Test Case 5: Manual Cache Clear - Clear All Cache

**Objective**: Verify that users can manually clear all cache.

**Preconditions**:
- User is logged in
- App has cached data
- User is on the app settings page
- Manual cache clear feature is implemented

**Steps**:
1. Navigate to app settings page:
   - From home screen, tap on "Settings" icon or menu
   - Verify app settings page is displayed

2. Locate cache clear option:
   - Scroll to "Storage" or "Cache" section (if needed)
   - **If NOT implemented**: Cache clear option is not available (this is expected - feature missing)
   - **If implemented**: 
     - Verify "Clear Cache" or "Clear All Cache" button is displayed
     - Verify current cache size is displayed (if available)

3. Clear all cache:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Tap on "Clear Cache" button
     - Verify confirmation dialog appears (if applicable):
       - Dialog title: "Clear Cache"
       - Dialog message: "Are you sure you want to clear all cache? This will remove offline data."
       - Options: "Clear" and "Cancel"
     - Tap "Clear" (if confirmation required)
     - Verify loading indicator appears (if applicable)
     - Wait for cache clear to complete

4. Verify cache is cleared:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Verify cache size is 0 or minimal:
       - Navigate to cache size section
       - Verify cache size shows 0 MB or minimal size
     - Verify success message appears:
       - "Cache cleared successfully"
       - OR "X MB of cache cleared"
     - Verify cached data is removed:
       - Check that cached tasks/reports are cleared
       - Verify app still works (data will be fetched from server)

5. Verify app functionality after cache clear:
   - Navigate through app
   - Verify app loads data from server (not cache)
   - Verify app works correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Manual cache clear is NOT implemented (missing)
- ✅ **When implemented**: Users can manually clear all cache
- ✅ Confirmation dialog appears before clearing
- ✅ Cache is cleared successfully
- ✅ Cache size shows 0 or minimal after clearing
- ✅ App continues to work after cache clear

---

## Test Case 6: Selective Cache Clear - Clear Specific Cache Categories

**Objective**: Verify that users can clear cache for specific categories (tasks, reports, pagination, etc.).

**Preconditions**:
- User is logged in
- App has cached data in multiple categories
- User is on the app settings page
- Selective cache clear feature is implemented

**Steps**:
1. Navigate to app settings page:
   - From home screen, tap on "Settings" icon or menu
   - Verify app settings page is displayed

2. Locate cache categories section:
   - Scroll to "Storage" or "Cache" section (if needed)
   - **If NOT implemented**: Cache categories section is not available (this is expected - feature missing)
   - **If implemented**: 
     - Verify cache breakdown by category is displayed:
       - Tasks cache: "50.2 MB" with "Clear" button
       - Reports cache: "30.1 MB" with "Clear" button
       - Pagination cache: "25.3 MB" with "Clear" button
       - Settings cache: "10.5 MB" with "Clear" button
       - User data cache: "9.4 MB" with "Clear" button

3. Clear specific cache category:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Note current cache size for a category (e.g., Tasks: 50.2 MB)
     - Tap on "Clear" button for that category (e.g., Tasks)
     - Verify confirmation dialog appears (if applicable):
       - "Clear Tasks Cache?"
       - "This will remove cached tasks data."
     - Tap "Clear" (if confirmation required)
     - Verify loading indicator appears
     - Wait for cache clear to complete

4. Verify specific cache is cleared:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Verify cache size for that category is 0 or minimal:
       - Tasks cache: "0 MB" or minimal
     - Verify other categories are not affected:
       - Reports cache: still "30.1 MB"
       - Pagination cache: still "25.3 MB"
     - Verify total cache size decreased:
       - Total cache: decreased by ~50.2 MB

5. Verify app functionality:
   - Navigate to tasks section
   - Verify tasks are loaded from server (not cache)
   - Verify app works correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Selective cache clear is NOT implemented (missing)
- ✅ **When implemented**: Users can clear cache for specific categories
- ✅ Cache size for selected category is cleared
- ✅ Other categories are not affected
- ✅ Total cache size decreases correctly
- ✅ App continues to work after selective clear

---

## Test Case 7: Cache Size Limit - Set Maximum Cache Size

**Objective**: Verify that users can set maximum cache size limit and cache is cleared when limit is exceeded.

**Preconditions**:
- User is logged in
- User is on the app settings page
- Cache size limit feature is implemented

**Steps**:
1. Navigate to app settings page:
   - From home screen, tap on "Settings" icon or menu
   - Verify app settings page is displayed

2. Locate cache size limit setting:
   - Scroll to "Storage" or "Cache" section (if needed)
   - **If NOT implemented**: Cache size limit setting is not available (this is expected - feature missing)
   - **If implemented**: 
     - Verify cache size limit setting is displayed:
       - "Maximum Cache Size" label
       - Size input or slider (e.g., 100 MB, 500 MB, 1 GB, Unlimited)
       - Current limit is indicated

3. Set cache size limit:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Tap on cache size limit option
     - Select a limit (e.g., "100 MB")
     - Verify selected limit is displayed
     - Save settings (if required)

4. Exceed cache size limit:
   - Generate cache data to exceed limit:
     - Create many tasks, reports, etc.
     - Navigate through app to generate cache
     - Wait for cache to accumulate
   - **If NOT implemented**: Cache limit is not enforced (this is expected - feature missing)
   - **If implemented**: 
     - Verify cache is automatically cleared when limit is exceeded:
       - Cache size is reduced to below limit
       - OR Oldest cache is removed first
       - OR Cache is cleared according to policy

5. Verify limit enforcement:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Check cache size:
       - Verify cache size stays below or at limit
       - Verify cache is cleared automatically when limit is exceeded
     - Verify notification appears (if applicable):
       - "Cache limit exceeded. Old cache cleared."
       - OR "Cache size reduced to stay within limit."

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Cache size limit is NOT implemented (missing)
- ✅ **When implemented**: Users can set maximum cache size limit
- ✅ Cache size limit is enforced
- ✅ Cache is automatically cleared when limit is exceeded
- ✅ Limit persists after app restart
- ✅ Notification appears when limit is exceeded (if applicable)

---

## Test Case 8: Cache Cleanup Scheduling - Scheduled Cache Cleanup

**Objective**: Verify that cache cleanup can be scheduled (daily, weekly, monthly).

**Preconditions**:
- User is logged in
- User is on the app settings page
- Cache cleanup scheduling feature is implemented

**Steps**:
1. Navigate to app settings page:
   - From home screen, tap on "Settings" icon or menu
   - Verify app settings page is displayed

2. Locate cache cleanup schedule setting:
   - Scroll to "Storage" or "Cache" section (if needed)
   - **If NOT implemented**: Cache cleanup schedule setting is not available (this is expected - feature missing)
   - **If implemented**: 
     - Verify cache cleanup schedule setting is displayed:
       - "Scheduled Cleanup" label
       - Schedule options (Daily, Weekly, Monthly, Never)
       - Current schedule is indicated

3. Set cache cleanup schedule:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Tap on schedule option
     - Select a schedule (e.g., "Daily")
     - Verify selected schedule is displayed
     - Set cleanup time (if available):
       - "Cleanup Time: 2:00 AM"
       - OR "Cleanup on app launch"
     - Save settings

4. Verify scheduled cleanup:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Generate cache data
     - Wait for scheduled cleanup time (or trigger manually for testing)
     - Verify cache is cleaned up:
       - Cache size decreases
       - Old cache is removed
     - Verify cleanup runs according to schedule:
       - Daily: runs once per day
       - Weekly: runs once per week
       - Monthly: runs once per month

5. Verify schedule persistence:
   - Close app completely
   - Reopen app
   - Navigate to cache settings
   - Verify schedule is still set

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Cache cleanup scheduling is NOT implemented (missing)
- ✅ **When implemented**: Users can set cache cleanup schedule
- ✅ Scheduled cleanup runs according to schedule
- ✅ Cache is cleaned up at scheduled time
- ✅ Schedule persists after app restart

---

## Test Case 9: Cache Policy Persistence - Settings Persist After Restart

**Objective**: Verify that cache policy settings (auto-clear, size limit, schedule) persist after app restart.

**Preconditions**:
- User is logged in
- Cache policy settings are configured
- Cache policy persistence feature is implemented

**Steps**:
1. Configure cache policy settings:
   - Navigate to app settings
   - Enable auto-clear
   - Set auto-clear interval to "Weekly"
   - Set cache size limit to "500 MB"
   - Set cleanup schedule to "Daily at 2:00 AM"
   - Save settings

2. Verify settings are saved:
   - Verify success message appears (if applicable)
   - Verify settings are displayed correctly

3. Restart app:
   - Close app completely
   - Reopen app
   - Navigate to app settings

4. Verify settings persist:
   - **If NOT implemented**: Settings are not persisted (this is expected - feature missing)
   - **If implemented**: 
     - Navigate to cache policy section
     - Verify all settings are still configured:
       - Auto-clear: Enabled
       - Auto-clear interval: "Weekly"
       - Cache size limit: "500 MB"
       - Cleanup schedule: "Daily at 2:00 AM"

5. Verify policy is applied:
   - Generate cache data
   - Verify policy is enforced:
     - Auto-clear runs according to interval
     - Cache size limit is enforced
     - Scheduled cleanup runs according to schedule

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Cache policy persistence may not be fully implemented
- ✅ **When implemented**: Cache policy settings persist after app restart
- ✅ All settings are saved correctly
- ✅ Policy is applied correctly after restart

---

## Test Case 10: Cache Size Warning - Warning When Cache is Large

**Objective**: Verify that app shows warning when cache size is large and suggests clearing cache.

**Preconditions**:
- User is logged in
- App has large cache (e.g., > 500 MB)
- Cache size warning feature is implemented

**Steps**:
1. Generate large cache:
   - Create many tasks, reports, etc.
   - Navigate through app extensively
   - Wait for cache to accumulate to large size (e.g., > 500 MB)

2. Check for cache size warning:
   - Navigate to app settings
   - Locate cache size section
   - **If NOT implemented**: Cache size warning is not displayed (this is expected - feature missing)
   - **If implemented**: 
     - Verify warning is displayed when cache is large:
       - Warning message: "Cache size is large (X MB). Consider clearing cache."
       - OR Warning icon/indicator
       - "Clear Cache" button or link

3. Verify warning threshold:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Verify warning appears at configured threshold (e.g., > 500 MB)
     - Verify warning does not appear when cache is below threshold
     - Verify warning updates when cache size changes

4. Clear cache from warning:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Tap on "Clear Cache" button from warning
     - Verify cache is cleared
     - Verify warning disappears after cache is cleared

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Cache size warning is NOT implemented (missing)
- ✅ **When implemented**: Warning is displayed when cache is large
- ✅ Warning threshold is configurable
- ✅ Warning updates when cache size changes
- ✅ User can clear cache from warning

---

## Summary

### Current Status: ⛔ MISSING
Offline cache policy feature is **NOT IMPLEMENTED**. No cache size display, no auto-clear policy, no manual cache clear, no cache size limits, no cleanup scheduling exists.

### What Needs to Be Implemented:
1. ⛔ Cache size calculation and display
2. ⛔ Cache breakdown by category
3. ⛔ Cache auto-clear policy configuration
4. ⛔ Automatic cache cleanup
5. ⛔ Manual cache clear (all cache)
6. ⛔ Selective cache clear (by category)
7. ⛔ Cache size limit setting
8. ⛔ Cache cleanup scheduling
9. ⛔ Cache policy persistence
10. ⛔ Cache size warning

### Test Execution Notes:
- All test cases should be executed after implementation
- Test cases marked as "Missing Feature" should be updated once implemented
- Focus on cache size calculation, auto-clear, manual clear, and policy configuration
- Test with various cache sizes and scenarios
- Verify cache clearing doesn't break app functionality

### Security and Reliability Considerations:
- Cache clearing should not break app functionality
- Cache size calculation should be accurate
- Auto-clear should not remove critical data
- Policy settings should persist reliably
- Cache cleanup should be efficient and non-blocking

