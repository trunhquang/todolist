# Notification Subscription Management (Enable/Disable Groups, DND, Quiet Hours) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Notification Subscription Management** feature (enable/disable notification groups: task updates, mentions, workspace changes; DND/quiet hours). Currently, this feature is **MISSING** - Not implemented; no user prefs or UI for categories/DND.

## Prerequisites
- User must be logged in
- Notification settings page should be accessible
- Device should have internet connection (for Firebase sync)
- Multiple notification types may be needed for testing

---

## Test Case 1: Enable/Disable Task Updates Notification Group - Missing Feature

**Objective**: Verify user can enable/disable task updates notification group (currently missing).

**Preconditions**:
- User is logged in
- Notification subscription management is implemented
- Task updates notification group exists

**Steps**:
1. Navigate to Notification Settings page
2. Verify one of the following:
   - **If NOT implemented**: Task updates group toggle is not available (this is expected - feature missing)
   - **If implemented**: Task updates group toggle is available
3. If implemented:
   - Verify toggle exists:
     - Toggle for "Task Updates" group is visible
     - Toggle has clear label and description
     - Toggle shows current state (enabled/disabled)
   - Test enable:
     - Toggle "Task Updates" group ON
     - Save settings
     - Verify settings are saved
     - Verify task update notifications are received
   - Test disable:
     - Toggle "Task Updates" group OFF
     - Save settings
     - Verify settings are saved
     - Verify task update notifications are NOT received
   - Verify persistence:
     - Close and reopen app
     - Verify toggle state persists
     - Verify settings are loaded correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Task updates group toggle is NOT implemented (missing)
- ✅ **When implemented**: User can enable/disable task updates group
- ✅ Settings are saved and persisted
- ✅ Notifications respect the setting

---

## Test Case 2: Enable/Disable Mentions Notification Group - Missing Feature

**Objective**: Verify user can enable/disable mentions notification group (currently missing).

**Preconditions**:
- User is logged in
- Notification subscription management is implemented
- Mentions notification group exists

**Steps**:
1. Navigate to Notification Settings page
2. Verify one of the following:
   - **If NOT implemented**: Mentions group toggle is not available (this is expected - feature missing)
   - **If implemented**: Mentions group toggle is available
3. If implemented:
   - Verify toggle exists:
     - Toggle for "Mentions" group is visible
     - Toggle has clear label and description
     - Toggle shows current state (enabled/disabled)
   - Test enable:
     - Toggle "Mentions" group ON
     - Save settings
     - Verify settings are saved
     - Verify mention notifications are received
   - Test disable:
     - Toggle "Mentions" group OFF
     - Save settings
     - Verify settings are saved
     - Verify mention notifications are NOT received
   - Verify persistence:
     - Close and reopen app
     - Verify toggle state persists
     - Verify settings are loaded correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Mentions group toggle is NOT implemented (missing)
- ✅ **When implemented**: User can enable/disable mentions group
- ✅ Settings are saved and persisted
- ✅ Notifications respect the setting

---

## Test Case 3: Enable/Disable Workspace Changes Notification Group - Missing Feature

**Objective**: Verify user can enable/disable workspace changes notification group (currently missing).

**Preconditions**:
- User is logged in
- Notification subscription management is implemented
- Workspace changes notification group exists

**Steps**:
1. Navigate to Notification Settings page
2. Verify one of the following:
   - **If NOT implemented**: Workspace changes group toggle is not available (this is expected - feature missing)
   - **If implemented**: Workspace changes group toggle is available
3. If implemented:
   - Verify toggle exists:
     - Toggle for "Workspace Changes" group is visible
     - Toggle has clear label and description
     - Toggle shows current state (enabled/disabled)
   - Test enable:
     - Toggle "Workspace Changes" group ON
     - Save settings
     - Verify settings are saved
     - Verify workspace change notifications are received
   - Test disable:
     - Toggle "Workspace Changes" group OFF
     - Save settings
     - Verify settings are saved
     - Verify workspace change notifications are NOT received
   - Verify persistence:
     - Close and reopen app
     - Verify toggle state persists
     - Verify settings are loaded correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Workspace changes group toggle is NOT implemented (missing)
- ✅ **When implemented**: User can enable/disable workspace changes group
- ✅ Settings are saved and persisted
- ✅ Notifications respect the setting

---

## Test Case 4: Enable Do Not Disturb (DND) Mode - Missing Feature

**Objective**: Verify user can enable Do Not Disturb (DND) mode (currently missing).

**Preconditions**:
- User is logged in
- DND mode is implemented

**Steps**:
1. Navigate to Notification Settings page
2. Verify one of the following:
   - **If NOT implemented**: DND toggle is not available (this is expected - feature missing)
   - **If implemented**: DND toggle is available
3. If implemented:
   - Verify DND toggle exists:
     - Toggle for "Do Not Disturb" is visible
     - Toggle has clear label and description
     - Toggle shows current state (enabled/disabled)
   - Test enable DND:
     - Toggle "Do Not Disturb" ON
     - Save settings
     - Verify settings are saved
     - Verify no notifications are received while DND is enabled
   - Test disable DND:
     - Toggle "Do Not Disturb" OFF
     - Save settings
     - Verify settings are saved
     - Verify notifications are received normally
   - Verify DND behavior:
     - While DND is enabled, no push notifications are sent
     - While DND is enabled, notifications may be queued or suppressed
     - DND overrides individual group settings
   - Verify persistence:
     - Close and reopen app
     - Verify DND state persists
     - Verify settings are loaded correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: DND mode is NOT implemented (missing)
- ✅ **When implemented**: User can enable/disable DND mode
- ✅ DND suppresses all notifications
- ✅ Settings are saved and persisted

---

## Test Case 5: Configure Quiet Hours - Missing Feature

**Objective**: Verify user can configure quiet hours (currently missing).

**Preconditions**:
- User is logged in
- Quiet hours feature is implemented

**Steps**:
1. Navigate to Notification Settings page
2. Verify one of the following:
   - **If NOT implemented**: Quiet hours configuration is not available (this is expected - feature missing)
   - **If implemented**: Quiet hours configuration is available
3. If implemented:
   - Verify quiet hours UI exists:
     - Toggle for "Quiet Hours" is visible
     - Time pickers for start and end time are visible
     - Clear labels and descriptions are shown
   - Test enable quiet hours:
     - Toggle "Quiet Hours" ON
     - Set start time (e.g., 22:00)
     - Set end time (e.g., 08:00)
     - Save settings
     - Verify settings are saved
   - Test quiet hours behavior:
     - During quiet hours, verify no notifications are received
     - Outside quiet hours, verify notifications are received normally
     - Test edge cases:
       - Quiet hours spanning midnight (e.g., 22:00 to 08:00)
       - Quiet hours within same day (e.g., 14:00 to 16:00)
   - Test disable quiet hours:
     - Toggle "Quiet Hours" OFF
     - Save settings
     - Verify settings are saved
     - Verify notifications are received normally at all times
   - Verify persistence:
     - Close and reopen app
     - Verify quiet hours settings persist
     - Verify settings are loaded correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Quiet hours configuration is NOT implemented (missing)
- ✅ **When implemented**: User can configure quiet hours
- ✅ Quiet hours suppress notifications during specified time
- ✅ Settings are saved and persisted

---

## Test Case 6: Multiple Notification Groups Configuration - Missing Feature

**Objective**: Verify user can configure multiple notification groups independently (currently missing).

**Preconditions**:
- User is logged in
- Multiple notification groups are implemented

**Steps**:
1. Navigate to Notification Settings page
2. Verify one of the following:
   - **If NOT implemented**: Multiple group toggles are not available (this is expected - feature missing)
   - **If implemented**: Multiple group toggles are available
3. If implemented:
   - Verify all groups are visible:
     - Task Updates group toggle
     - Mentions group toggle
     - Workspace Changes group toggle
   - Test independent configuration:
     - Enable Task Updates, disable Mentions, enable Workspace Changes
     - Save settings
     - Verify settings are saved correctly
     - Verify only enabled groups send notifications
   - Test all enabled:
     - Enable all groups
     - Save settings
     - Verify all notifications are received
   - Test all disabled:
     - Disable all groups
     - Save settings
     - Verify no notifications are received
   - Verify persistence:
     - Close and reopen app
     - Verify all group settings persist
     - Verify settings are loaded correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Multiple group configuration is NOT implemented (missing)
- ✅ **When implemented**: User can configure multiple groups independently
- ✅ Settings are saved and persisted
- ✅ Notifications respect individual group settings

---

## Test Case 7: DND Override Individual Group Settings - Missing Feature

**Objective**: Verify DND mode overrides individual group settings (currently missing).

**Preconditions**:
- User is logged in
- DND mode and notification groups are implemented

**Steps**:
1. Navigate to Notification Settings page
2. Enable all notification groups:
   - Enable Task Updates
   - Enable Mentions
   - Enable Workspace Changes
   - Save settings
3. Verify one of the following:
   - **If NOT implemented**: DND override is not available (this is expected - feature missing)
   - **If implemented**: DND override works
4. If implemented:
   - Enable DND mode:
     - Toggle "Do Not Disturb" ON
     - Save settings
   - Verify DND override:
     - Trigger task update notification
     - Verify notification is NOT received (DND overrides Task Updates)
     - Trigger mention notification
     - Verify notification is NOT received (DND overrides Mentions)
     - Trigger workspace change notification
     - Verify notification is NOT received (DND overrides Workspace Changes)
   - Disable DND mode:
     - Toggle "Do Not Disturb" OFF
     - Save settings
   - Verify notifications resume:
     - Trigger notifications for all groups
     - Verify all notifications are received (groups are still enabled)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: DND override is NOT implemented (missing)
- ✅ **When implemented**: DND overrides individual group settings
- ✅ No notifications are received when DND is enabled
- ✅ Notifications resume when DND is disabled

---

## Test Case 8: Quiet Hours Override Individual Group Settings - Missing Feature

**Objective**: Verify quiet hours override individual group settings (currently missing).

**Preconditions**:
- User is logged in
- Quiet hours and notification groups are implemented

**Steps**:
1. Navigate to Notification Settings page
2. Enable all notification groups:
   - Enable Task Updates
   - Enable Mentions
   - Enable Workspace Changes
   - Save settings
3. Configure quiet hours:
   - Enable Quiet Hours
   - Set start time (e.g., 22:00)
   - Set end time (e.g., 08:00)
   - Save settings
4. Verify one of the following:
   - **If NOT implemented**: Quiet hours override is not available (this is expected - feature missing)
   - **If implemented**: Quiet hours override works
5. If implemented:
   - Test during quiet hours:
     - Set device time to within quiet hours (e.g., 23:00)
     - Trigger task update notification
     - Verify notification is NOT received (quiet hours override)
     - Trigger mention notification
     - Verify notification is NOT received (quiet hours override)
     - Trigger workspace change notification
     - Verify notification is NOT received (quiet hours override)
   - Test outside quiet hours:
     - Set device time to outside quiet hours (e.g., 10:00)
     - Trigger notifications for all groups
     - Verify all notifications are received (groups are still enabled)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Quiet hours override is NOT implemented (missing)
- ✅ **When implemented**: Quiet hours override individual group settings
- ✅ No notifications are received during quiet hours
- ✅ Notifications are received outside quiet hours

---

## Test Case 9: Notification Preferences Sync to Firebase - Missing Feature

**Objective**: Verify notification preferences are synced to Firebase (currently missing - only local storage).

**Preconditions**:
- User is logged in
- Notification preferences sync is implemented

**Steps**:
1. Navigate to Notification Settings page
2. Configure preferences:
   - Enable Task Updates
   - Disable Mentions
   - Enable Workspace Changes
   - Enable DND
   - Configure quiet hours
   - Save settings
3. Verify one of the following:
   - **If NOT implemented**: Preferences are only saved locally (this is expected - feature missing)
   - **If implemented**: Preferences are synced to Firebase
4. If implemented:
   - Check Firebase database:
     - Navigate to `users/{userId}/notificationPreferences`
     - Verify preferences are saved:
       - `taskUpdates` is true
       - `mentions` is false
       - `workspaceChanges` is true
       - `dndEnabled` is true
       - `quietHoursStart` exists
       - `quietHoursEnd` exists
   - Test sync across devices:
     - Configure preferences on Device 1
     - Open app on Device 2
     - Verify preferences are synced to Device 2
   - Test offline sync:
     - Configure preferences offline
     - Go online
     - Verify preferences are synced to Firebase

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Preferences sync to Firebase is NOT implemented (missing - only local storage)
- ✅ **When implemented**: Preferences are synced to Firebase
- ✅ Preferences are available across devices
- ✅ Offline changes are synced when online

---

## Test Case 10: Notification Preferences Load from Firebase - Missing Feature

**Objective**: Verify notification preferences are loaded from Firebase on app start (currently missing - only local storage).

**Preconditions**:
- User is logged in
- Notification preferences are saved in Firebase
- Preferences loading is implemented

**Steps**:
1. Configure preferences on another device or via Firebase console
2. Launch the app
3. Navigate to Notification Settings page
4. Verify one of the following:
   - **If NOT implemented**: Preferences are only loaded from local storage (this is expected - feature missing)
   - **If implemented**: Preferences are loaded from Firebase
5. If implemented:
   - Verify preferences are loaded:
     - Task Updates setting matches Firebase
     - Mentions setting matches Firebase
     - Workspace Changes setting matches Firebase
     - DND setting matches Firebase
     - Quiet hours settings match Firebase
   - Test priority:
     - If Firebase has preferences, use Firebase
     - If Firebase doesn't have preferences, use local storage
     - If neither has preferences, use defaults
   - Verify loading doesn't block UI:
     - Settings page loads quickly
     - Loading indicator is shown if needed
     - No errors occur during loading

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Preferences loading from Firebase is NOT implemented (missing - only local storage)
- ✅ **When implemented**: Preferences are loaded from Firebase
- ✅ Preferences match Firebase data
- ✅ Loading is fast and doesn't block UI

---

## Test Case 11: Push Notification Service Checks Preferences - Missing Feature

**Objective**: Verify push notification service checks preferences before sending (currently missing).

**Preconditions**:
- User is logged in
- Notification preferences are configured
- Push notification service checks preferences
- Preference checking is implemented

**Steps**:
1. Configure preferences:
   - Disable Task Updates group
   - Enable Mentions group
   - Enable DND mode
   - Save settings
2. Trigger task update event
3. Verify one of the following:
   - **If NOT implemented**: Notification is sent regardless of preferences (this is expected - feature missing)
   - **If implemented**: Notification is NOT sent (Task Updates is disabled)
4. If implemented:
   - Verify preference checking:
     - Task update notification is NOT sent (group disabled)
     - Mention notification IS sent (group enabled, DND may override)
     - Workspace change notification is NOT sent (DND enabled)
   - Test with DND disabled:
     - Disable DND
     - Enable all groups
     - Trigger notifications
     - Verify all notifications are sent
   - Test with quiet hours:
     - Configure quiet hours (e.g., 22:00 to 08:00)
     - Set device time to within quiet hours
     - Trigger notifications
     - Verify notifications are NOT sent
     - Set device time to outside quiet hours
     - Trigger notifications
     - Verify notifications ARE sent

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Preference checking is NOT implemented (missing)
- ✅ **When implemented**: Push service checks preferences before sending
- ✅ Notifications respect group settings
- ✅ Notifications respect DND and quiet hours

---

## Test Case 12: Notification Preferences Default Values - Missing Feature

**Objective**: Verify notification preferences have correct default values (currently missing).

**Preconditions**:
- User is logged in
- Notification preferences defaults are implemented

**Steps**:
1. Create new user account
2. Navigate to Notification Settings page
3. Verify one of the following:
   - **If NOT implemented**: Default values are not set (this is expected - feature missing)
   - **If implemented**: Default values are set
4. If implemented:
   - Verify default values:
     - Task Updates: enabled (default)
     - Mentions: enabled (default)
     - Workspace Changes: enabled (default)
     - DND: disabled (default)
     - Quiet Hours: disabled (default)
   - Verify defaults are saved:
     - Defaults are saved to Firebase
     - Defaults are saved to local storage
   - Test user experience:
     - New users receive all notifications by default
     - Users can customize preferences as needed

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Default values are NOT implemented (missing)
- ✅ **When implemented**: Default values are set correctly
- ✅ Defaults are saved automatically
- ✅ New users have good default experience

---

## Test Case 13: Notification Preferences Validation - Missing Feature

**Objective**: Verify notification preferences are validated (currently missing).

**Preconditions**:
- User is logged in
- Notification preferences validation is implemented

**Steps**:
1. Navigate to Notification Settings page
2. Test invalid quiet hours:
   - Set start time equal to end time
   - Try to save
   - Verify one of the following:
     - **If NOT implemented**: Invalid settings are saved (this is expected - feature missing)
     - **If implemented**: Validation error is shown
3. If implemented:
   - Verify validation:
     - Start time cannot equal end time
     - Start time and end time must be valid times
     - Error messages are clear and helpful
   - Test valid settings:
     - Set valid quiet hours
     - Save settings
     - Verify settings are saved successfully
   - Test edge cases:
     - Quiet hours spanning midnight (valid)
     - Quiet hours within same day (valid)
     - Invalid time formats (invalid)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Validation is NOT implemented (missing)
- ✅ **When implemented**: Preferences are validated
- ✅ Invalid settings are rejected
- ✅ Error messages are clear

---

## Test Case 14: Notification Preferences UI/UX - Missing Feature

**Objective**: Verify notification preferences UI/UX is user-friendly (currently missing - basic UI exists but incomplete).

**Preconditions**:
- User is logged in
- Notification preferences UI is implemented

**Steps**:
1. Navigate to Notification Settings page
2. Verify one of the following:
   - **If NOT implemented**: UI is incomplete (this is expected - feature missing)
   - **If implemented**: UI is complete and user-friendly
3. If implemented:
   - Verify UI elements:
     - All toggles are clearly labeled
     - Descriptions explain what each setting does
     - Group settings are organized logically
     - DND and quiet hours are prominently displayed
     - Save button is visible and accessible
   - Verify UX:
     - Settings are easy to understand
     - Changes are saved immediately or with clear save action
     - Success/error messages are shown
     - Loading states are indicated
   - Verify accessibility:
     - Text is readable
     - Toggles are easy to use
     - Time pickers are intuitive
     - UI follows project design guidelines (TD widgets, AppStrings)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: UI is incomplete (missing - basic UI exists but doesn't have required features)
- ✅ **When implemented**: UI is complete and user-friendly
- ✅ UI follows project guidelines
- ✅ Settings are easy to configure

---

## Test Case 15: Notification Preferences Workspace Scoping - Missing Feature

**Objective**: Verify notification preferences are scoped to workspace (currently missing).

**Preconditions**:
- User is logged in
- User is in multiple workspaces
- Workspace-scoped preferences are implemented

**Steps**:
1. Switch to Workspace A
2. Configure preferences:
   - Disable Task Updates in Workspace A
   - Save settings
3. Switch to Workspace B
4. Verify one of the following:
   - **If NOT implemented**: Preferences are global (this is expected - feature missing)
   - **If implemented**: Preferences are workspace-scoped
5. If implemented:
   - Verify workspace scoping:
     - Task Updates setting in Workspace B is independent
     - Preferences in Workspace A don't affect Workspace B
     - Each workspace has its own preferences
   - Test switching workspaces:
     - Configure different preferences in each workspace
     - Switch between workspaces
     - Verify preferences are loaded correctly for each workspace
   - Check Firebase database:
     - Navigate to `users/{userId}/workspaces/{workspaceId}/notificationPreferences`
     - Verify preferences are saved per workspace

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Workspace scoping is NOT implemented (missing)
- ✅ **When implemented**: Preferences are scoped to workspace
- ✅ Each workspace has independent preferences
- ✅ Preferences are saved per workspace

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Task updates group toggle works (missing)
- [ ] Mentions group toggle works (missing)
- [ ] Workspace changes group toggle works (missing)
- [ ] DND mode works (missing)
- [ ] Quiet hours configuration works (missing)
- [ ] Multiple groups can be configured independently (missing)
- [ ] DND overrides individual groups (missing)
- [ ] Quiet hours override individual groups (missing)
- [ ] Preferences sync to Firebase (missing)
- [ ] Preferences load from Firebase (missing)
- [ ] Push service checks preferences (missing)
- [ ] Default values are set (missing)
- [ ] Validation works (missing)
- [ ] UI/UX is complete (missing)
- [ ] Workspace scoping works (missing)

---

## Known Issues (Based on Audit Report)

1. **Notification Subscription Management Not Implemented**:
   - No user preferences for notification categories
   - No UI for categories/DND
   - No quiet hours configuration
   - **Status**: ⛔ Missing

2. **Existing Components**:
   - `NotificationSettingsPage` exists but:
     - Only saves to local storage (not Firebase)
     - Doesn't have required categories (task updates, mentions, workspace changes)
     - Doesn't have DND mode
     - Doesn't have quiet hours
   - Basic notification toggles exist but are incomplete

3. **Missing Components**:
   - No `NotificationPreferences` entity
   - No notification preferences service
   - No Firebase sync for preferences
   - No preference checking in push service
   - No workspace scoping for preferences

---

## Notes for Testers

1. **Current Status**: Notification subscription management is completely missing:
   - No notification group toggles (task updates, mentions, workspace changes)
   - No DND mode
   - No quiet hours
   - Only basic local storage settings exist

2. **Existing Components**: Some components exist but are incomplete:
   - `NotificationSettingsPage` has basic toggles but not the required ones
   - Settings are saved to local storage only, not Firebase
   - Push service doesn't check preferences

3. **Design Considerations**: When implementing, consider:
   - Create `NotificationPreferences` entity
   - Create notification preferences service
   - Sync preferences to Firebase
   - Check preferences before sending push notifications
   - Support workspace-scoped preferences
   - Implement DND and quiet hours
   - Validate preference settings

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
- Whether notification groups are available
- Whether DND mode is available
- Whether quiet hours are available
- Whether preferences sync to Firebase
- Whether push service checks preferences
- Firebase database state (if accessible)

