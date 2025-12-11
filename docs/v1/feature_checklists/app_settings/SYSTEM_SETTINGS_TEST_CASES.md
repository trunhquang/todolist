# System Settings: Language, Date/Time Format, Timezone Defaults, Background Data Permissions - Test Cases

## Overview
This document contains step-by-step test cases for testing the **System Settings** feature. Currently, this feature is **PARTIAL** - Workspace settings capture language/timezone/date/time format, but no global app settings page exists for these settings; no background data permission handling exists. This feature should include: language selection, date/time format selection, timezone defaults, and background data permission management (notifications, sync).

## Prerequisites
- User must be logged in
- User has access to at least one workspace
- App settings page is accessible
- Workspace settings page is accessible
- Device has background data restrictions (for testing)

---

## Test Case 1: App-Wide Language Setting - Set Default Language

**Objective**: Verify that users can set app-wide default language in app settings.

**Preconditions**:
- User is logged in
- User is on the app settings page
- App-wide language setting feature is implemented

**Steps**:
1. Navigate to app settings page:
   - From home screen, tap on "Settings" icon or menu
   - OR Tap on profile icon, then tap "Settings"
   - Verify app settings page is displayed

2. Locate language setting:
   - Scroll to "System" or "Language" section (if needed)
   - **If NOT implemented**: Language setting is not available (this is expected - no global app settings page)
   - **If implemented**: 
     - Verify language setting is displayed:
       - "Language" label
       - Language dropdown or selection
       - Current language is indicated

3. Set app-wide language:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Tap on language dropdown
     - Verify list of available languages is displayed:
       - English, Tiếng Việt, Español, Français, etc.
     - Select a different language (e.g., "Tiếng Việt")
     - Verify selected language is displayed
     - Save settings (if required):
       - Tap "Save" button
       - Verify settings are saved

4. Verify language change is applied:
   - **If NOT implemented**: Language change is not applied (this is expected - feature missing)
   - **If implemented**: 
     - Verify app language changes immediately:
       - App strings are displayed in selected language
       - UI elements are translated
     - Verify language persists after app restart:
       - Close app completely
       - Reopen app
       - Verify app still uses selected language

**Expected Results**:
- ⚠️ **CURRENT STATUS**: App-wide language setting is NOT implemented (no global app settings page)
- ✅ **When implemented**: Users can set app-wide default language
- ✅ Language change is applied immediately
- ✅ Language persists after app restart

---

## Test Case 2: App-Wide Timezone Setting - Set Default Timezone

**Objective**: Verify that users can set app-wide default timezone in app settings.

**Preconditions**:
- User is logged in
- User is on the app settings page
- App-wide timezone setting feature is implemented

**Steps**:
1. Navigate to app settings page:
   - From home screen, tap on "Settings" icon or menu
   - Verify app settings page is displayed

2. Locate timezone setting:
   - Scroll to "System" or "Timezone" section (if needed)
   - **If NOT implemented**: Timezone setting is not available (this is expected - no global app settings page)
   - **If implemented**: 
     - Verify timezone setting is displayed:
       - "Timezone" label
       - Timezone dropdown or selection
       - Current timezone is indicated

3. Set app-wide timezone:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Tap on timezone dropdown
     - Verify list of available timezones is displayed:
       - UTC, UTC+1, UTC+2, etc.
     - Select a different timezone (e.g., "UTC+7")
     - Verify selected timezone is displayed
     - Save settings (if required)

4. Verify timezone change is applied:
   - **If NOT implemented**: Timezone change is not applied (this is expected - feature missing)
   - **If implemented**: 
     - Verify timezone is used for date/time display:
       - Dates and times are displayed in selected timezone
       - Task due dates use selected timezone
     - Verify timezone persists after app restart:
       - Close app completely
       - Reopen app
       - Verify app still uses selected timezone

**Expected Results**:
- ⚠️ **CURRENT STATUS**: App-wide timezone setting is NOT implemented (no global app settings page)
- ✅ **When implemented**: Users can set app-wide default timezone
- ✅ Timezone change is applied immediately
- ✅ Timezone persists after app restart

---

## Test Case 3: App-Wide Date Format Setting - Set Default Date Format

**Objective**: Verify that users can set app-wide default date format in app settings.

**Preconditions**:
- User is logged in
- User is on the app settings page
- App-wide date format setting feature is implemented

**Steps**:
1. Navigate to app settings page:
   - From home screen, tap on "Settings" icon or menu
   - Verify app settings page is displayed

2. Locate date format setting:
   - Scroll to "System" or "Date Format" section (if needed)
   - **If NOT implemented**: Date format setting is not available (this is expected - no global app settings page)
   - **If implemented**: 
     - Verify date format setting is displayed:
       - "Date Format" label
       - Date format dropdown or selection
       - Current date format is indicated

3. Set app-wide date format:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Tap on date format dropdown
     - Verify list of available formats is displayed:
       - MM/dd/yyyy, dd/MM/yyyy, yyyy-MM-dd, etc.
     - Select a different format (e.g., "dd/MM/yyyy")
     - Verify selected format is displayed
     - Save settings (if required)

4. Verify date format change is applied:
   - **If NOT implemented**: Date format change is not applied (this is expected - feature missing)
   - **If implemented**: 
     - Verify date format is used throughout app:
       - Task dates are displayed in selected format
       - Report dates are displayed in selected format
       - All date displays use selected format
     - Verify date format persists after app restart:
       - Close app completely
       - Reopen app
       - Verify app still uses selected date format

**Expected Results**:
- ⚠️ **CURRENT STATUS**: App-wide date format setting is NOT implemented (no global app settings page)
- ✅ **When implemented**: Users can set app-wide default date format
- ✅ Date format change is applied immediately
- ✅ Date format persists after app restart

---

## Test Case 4: App-Wide Time Format Setting - Set Default Time Format

**Objective**: Verify that users can set app-wide default time format (12h/24h) in app settings.

**Preconditions**:
- User is logged in
- User is on the app settings page
- App-wide time format setting feature is implemented

**Steps**:
1. Navigate to app settings page:
   - From home screen, tap on "Settings" icon or menu
   - Verify app settings page is displayed

2. Locate time format setting:
   - Scroll to "System" or "Time Format" section (if needed)
   - **If NOT implemented**: Time format setting is not available (this is expected - no global app settings page)
   - **If implemented**: 
     - Verify time format setting is displayed:
       - "Time Format" label
       - Time format options (12h/24h)
       - Current time format is indicated

3. Set app-wide time format:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Tap on time format option (e.g., "24h")
     - Verify selected format is displayed
     - Save settings (if required)

4. Verify time format change is applied:
   - **If NOT implemented**: Time format change is not applied (this is expected - feature missing)
   - **If implemented**: 
     - Verify time format is used throughout app:
       - Task times are displayed in selected format
       - Report times are displayed in selected format
       - All time displays use selected format
     - Verify time format persists after app restart:
       - Close app completely
       - Reopen app
       - Verify app still uses selected time format

**Expected Results**:
- ⚠️ **CURRENT STATUS**: App-wide time format setting is NOT implemented (no global app settings page)
- ✅ **When implemented**: Users can set app-wide default time format
- ✅ Time format change is applied immediately
- ✅ Time format persists after app restart

---

## Test Case 5: Workspace Language Override - Workspace-Specific Language

**Objective**: Verify that workspace-specific language overrides app-wide default language.

**Preconditions**:
- User is logged in
- User has access to at least one workspace
- App-wide language is set (e.g., English)
- Workspace language setting feature is implemented
- Workspace language override feature is implemented

**Steps**:
1. Set app-wide language:
   - Navigate to app settings
   - Set app-wide language to "English"
   - Verify app uses English

2. Set workspace-specific language:
   - Navigate to workspace settings
   - Locate "Language" setting
   - Set workspace language to "Tiếng Việt"
   - Save workspace settings

3. Verify workspace language override:
   - **If NOT implemented**: Workspace language does not override app-wide (this is expected - may not be implemented)
   - **If implemented**: 
     - Switch to workspace with custom language
     - Verify app language changes to workspace language:
       - App strings are displayed in workspace language
       - UI elements are translated to workspace language
     - Switch to another workspace (without custom language):
       - Verify app language reverts to app-wide default

4. Verify override persistence:
   - Close app completely
   - Reopen app
   - Switch to workspace with custom language
   - Verify workspace language is still applied

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Workspace language override may not be fully implemented
- ✅ **When implemented**: Workspace-specific language overrides app-wide default
- ✅ Override is applied when switching workspaces
- ✅ Override persists after app restart

---

## Test Case 6: Background Data Permission - Check Permission Status

**Objective**: Verify that app can check background data permission status.

**Preconditions**:
- User is logged in
- Background data permission checking feature is implemented
- Device has background data restrictions (for testing)

**Steps**:
1. Navigate to app settings or system settings:
   - From home screen, tap on "Settings" icon or menu
   - OR Navigate to "System Settings" or "Permissions" section
   - **If NOT implemented**: Background data permission section is not available (this is expected - not implemented)
   - **If implemented**: 
     - Verify background data permission section is displayed

2. Check permission status:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Locate "Background Data" or "Data Usage" section
     - Verify permission status is displayed:
       - "Background Data: Allowed" or "Restricted"
       - OR "Unrestricted Data Access: Enabled" or "Disabled"
     - Verify status is accurate:
       - Status matches device settings
       - Status is updated if device settings change

3. Verify permission status updates:
   - Change device background data settings:
     - Go to device settings
     - Change background data restriction for app
     - Return to app
   - Verify app detects change:
     - Permission status is updated
     - OR App shows notification about permission change

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Background data permission checking is NOT implemented
- ✅ **When implemented**: App can check background data permission status
- ✅ Permission status is displayed accurately
- ✅ Permission status updates when device settings change

---

## Test Case 7: Background Data Permission - Request Permission

**Objective**: Verify that app can request background data permission or guide user to enable it.

**Preconditions**:
- User is logged in
- Background data permission is restricted
- Background data permission requesting feature is implemented

**Steps**:
1. Navigate to app settings or system settings:
   - From home screen, tap on "Settings" icon or menu
   - Navigate to "System Settings" or "Permissions" section
   - **If NOT implemented**: Background data permission section is not available (this is expected - not implemented)
   - **If implemented**: 
     - Verify background data permission section is displayed

2. Request permission:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Locate "Background Data" section
     - Verify "Enable Background Data" or "Request Permission" button is displayed
     - Tap on button
     - Verify action is taken:
       - Device settings page is opened (for user to enable)
       - OR Permission is requested directly (if supported)
       - OR Instructions are shown to user

3. Verify permission is enabled:
   - Enable background data in device settings (if needed)
   - Return to app
   - Verify permission status is updated:
     - Status shows "Allowed" or "Enabled"
     - App can use background data

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Background data permission requesting is NOT implemented
- ✅ **When implemented**: App can request or guide user to enable background data permission
- ✅ User can enable permission
- ✅ Permission status is updated after enabling

---

## Test Case 8: Background Data Permission - Notification Permission

**Objective**: Verify that app can check and request notification permission for background notifications.

**Preconditions**:
- User is logged in
- Notification permission checking feature is implemented
- Device notification permissions are configurable

**Steps**:
1. Navigate to app settings or notification settings:
   - From home screen, tap on "Settings" icon or menu
   - Navigate to "Notifications" or "System Settings" section
   - **If NOT implemented**: Notification permission section is not available (this is expected - may not be fully implemented)
   - **If implemented**: 
     - Verify notification permission section is displayed

2. Check notification permission status:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Locate "Notification Permission" section
     - Verify permission status is displayed:
       - "Notifications: Allowed" or "Denied"
       - OR "Push Notifications: Enabled" or "Disabled"
     - Verify status is accurate

3. Request notification permission:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Locate "Enable Notifications" or "Request Permission" button
     - Tap on button
     - Verify permission dialog appears (if not already granted)
     - Grant permission
     - Verify permission status is updated

4. Verify notification permission works:
   - Trigger a test notification
   - Verify notification is received
   - Verify notification appears correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Notification permission management may be partially implemented (NotificationService exists)
- ✅ **When fully implemented**: App can check and request notification permission
- ✅ Permission status is displayed accurately
- ✅ User can grant permission
- ✅ Notifications work after permission is granted

---

## Test Case 9: Background Sync Permission - Check Sync Permission

**Objective**: Verify that app can check background sync permission and manage sync settings.

**Preconditions**:
- User is logged in
- Background sync permission checking feature is implemented
- Device has sync restrictions (for testing)

**Steps**:
1. Navigate to app settings or system settings:
   - From home screen, tap on "Settings" icon or menu
   - Navigate to "System Settings" or "Sync" section
   - **If NOT implemented**: Background sync section is not available (this is expected - not implemented)
   - **If implemented**: 
     - Verify background sync section is displayed

2. Check sync permission status:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Locate "Background Sync" or "Data Sync" section
     - Verify sync permission status is displayed:
       - "Background Sync: Allowed" or "Restricted"
       - OR "Auto Sync: Enabled" or "Disabled"
     - Verify sync settings are displayed:
       - Sync frequency options
       - Sync on Wi-Fi only option
       - Sync on mobile data option

3. Configure sync settings:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Enable/disable background sync
     - Configure sync frequency
     - Configure sync data restrictions (Wi-Fi only, etc.)
     - Save settings
     - Verify settings are applied

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Background sync permission checking is NOT implemented
- ✅ **When implemented**: App can check background sync permission
- ✅ Sync settings can be configured
- ✅ Settings are applied correctly

---

## Test Case 10: System Settings Persistence - App-Wide Defaults

**Objective**: Verify that app-wide system settings (language, timezone, date/time format) persist correctly.

**Preconditions**:
- User is logged in
- App-wide system settings feature is implemented
- User has set app-wide defaults

**Steps**:
1. Set app-wide system settings:
   - Navigate to app settings
   - Set app-wide language to "Tiếng Việt"
   - Set app-wide timezone to "UTC+7"
   - Set app-wide date format to "dd/MM/yyyy"
   - Set app-wide time format to "24h"
   - Save settings

2. Verify settings persist:
   - Close app completely
   - Reopen app
   - Navigate to app settings
   - Verify all settings are still set:
     - Language: "Tiếng Việt"
     - Timezone: "UTC+7"
     - Date format: "dd/MM/yyyy"
     - Time format: "24h"

3. Verify settings are applied:
   - Verify app uses app-wide defaults:
     - App language is "Tiếng Việt"
     - Dates/times use UTC+7
     - Date format is "dd/MM/yyyy"
     - Time format is "24h"

4. Test workspace override:
   - Set workspace-specific language (if override is implemented)
   - Switch to that workspace
   - Verify workspace language overrides app-wide (if implemented)
   - Switch to another workspace
   - Verify app-wide defaults are used

**Expected Results**:
- ⚠️ **CURRENT STATUS**: App-wide system settings persistence is NOT implemented (no global app settings page)
- ✅ **When implemented**: App-wide system settings persist correctly
- ✅ Settings are applied throughout app
- ✅ Settings persist after app restart
- ✅ Workspace overrides work correctly (if implemented)

---

## Summary

### Current Status: ⚠️ PARTIAL
System settings feature is **PARTIALLY IMPLEMENTED**:
- ✅ Workspace settings capture language/timezone/date/time format (per workspace)
- ⛔ No global app settings page for language/timezone/date/time format
- ⛔ No background data permission handling
- ⚠️ Notification permission may be partially implemented (NotificationService exists)

### What Needs to Be Implemented/Improved:
1. ⛔ App-wide language setting (not implemented)
2. ⛔ App-wide timezone setting (not implemented)
3. ⛔ App-wide date format setting (not implemented)
4. ⛔ App-wide time format setting (not implemented)
5. ⚠️ Workspace language/timezone/date/time override (may need improvement)
6. ⛔ Background data permission checking (not implemented)
7. ⛔ Background data permission requesting (not implemented)
8. ⚠️ Notification permission management (may be partially implemented)
9. ⛔ Background sync permission checking (not implemented)
10. ⛔ System settings persistence at app level (not implemented)

### Test Execution Notes:
- Test cases marked as "Partial" should verify current behavior and document gaps
- Test cases marked as "Not Implemented" should document expected behavior for future implementation
- Focus on app-wide defaults vs workspace-specific overrides
- Test with multiple workspaces to verify override behavior
- Test with app restart to verify persistence
- Test with device permission changes to verify detection

### Security and Reliability Considerations:
- System settings should not break app functionality
- Permission checking should be accurate and up-to-date
- Persistence should work reliably across app restarts
- Workspace overrides should work correctly
- Default values should be safe and accessible

