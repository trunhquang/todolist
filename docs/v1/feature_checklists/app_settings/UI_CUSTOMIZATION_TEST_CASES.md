# UI Customization: Primary Color Change, Theme Light/Dark, Per-Workspace/Device Persistence - Test Cases

## Overview
This document contains step-by-step test cases for testing the **UI Customization** feature. Currently, this feature is **PARTIAL** - Theme files exist, `WorkspaceSettingsPage` lets set theme/timezone/language per workspace, but primary color change not supported per workspace; per-workspace persistence is partial; app-wide theme toggle page exists (`AppSettingsPage`). This feature should include: primary color change (palette-safe), theme light/dark switching, and saving theme per workspace or device.

## Prerequisites
- User must be logged in
- User has access to at least one workspace
- App settings page is accessible
- Workspace settings page is accessible
- Multiple workspaces available (for per-workspace testing)

---

## Test Case 1: App-Wide Theme Mode Switching - Light Theme

**Objective**: Verify that users can switch app-wide theme mode to light theme.

**Preconditions**:
- User is logged in
- App is currently using dark theme or system theme
- User is on the app settings page

**Steps**:
1. Navigate to app settings page:
   - From home screen, tap on "Settings" icon or menu
   - OR Tap on profile icon, then tap "Settings"
   - Verify app settings page is displayed

2. Locate theme mode picker:
   - Scroll to "Appearance" section (if needed)
   - Verify theme mode picker is displayed:
     - "Light" option (ChoiceChip)
     - "Dark" option (ChoiceChip)
     - "System" option (ChoiceChip)
   - Verify current theme mode is indicated (selected chip)

3. Switch to light theme:
   - Tap on "Light" ChoiceChip
   - Verify "Light" chip becomes selected
   - Verify other chips (Dark, System) become unselected

4. Verify theme change is applied:
   - Verify app theme changes to light mode immediately:
     - Background becomes light
     - Text becomes dark
     - App bar becomes light
     - Cards and surfaces become light
   - Verify theme persists after app restart:
     - Close app completely
     - Reopen app
     - Verify app still uses light theme

**Expected Results**:
- ✅ App settings page is accessible
- ✅ Theme mode picker is displayed
- ✅ User can switch to light theme
- ✅ Theme change is applied immediately
- ✅ Theme persists after app restart

---

## Test Case 2: App-Wide Theme Mode Switching - Dark Theme

**Objective**: Verify that users can switch app-wide theme mode to dark theme.

**Preconditions**:
- User is logged in
- App is currently using light theme or system theme
- User is on the app settings page

**Steps**:
1. Navigate to app settings page:
   - From home screen, tap on "Settings" icon or menu
   - OR Tap on profile icon, then tap "Settings"
   - Verify app settings page is displayed

2. Locate theme mode picker:
   - Scroll to "Appearance" section (if needed)
   - Verify theme mode picker is displayed with Light, Dark, System options
   - Verify current theme mode is indicated

3. Switch to dark theme:
   - Tap on "Dark" ChoiceChip
   - Verify "Dark" chip becomes selected
   - Verify other chips become unselected

4. Verify theme change is applied:
   - Verify app theme changes to dark mode immediately:
     - Background becomes dark
     - Text becomes light
     - App bar becomes dark
     - Cards and surfaces become dark
   - Verify theme persists after app restart:
     - Close app completely
     - Reopen app
     - Verify app still uses dark theme

**Expected Results**:
- ✅ User can switch to dark theme
- ✅ Theme change is applied immediately
- ✅ Theme persists after app restart

---

## Test Case 3: App-Wide Theme Mode Switching - System Theme

**Objective**: Verify that users can switch app-wide theme mode to system theme (follows device theme).

**Preconditions**:
- User is logged in
- App is currently using light or dark theme
- User is on the app settings page
- Device has system theme setting (light or dark)

**Steps**:
1. Navigate to app settings page:
   - From home screen, tap on "Settings" icon or menu
   - Verify app settings page is displayed

2. Locate theme mode picker:
   - Scroll to "Appearance" section (if needed)
   - Verify theme mode picker is displayed

3. Switch to system theme:
   - Tap on "System" ChoiceChip
   - Verify "System" chip becomes selected
   - Verify other chips become unselected

4. Verify theme follows device theme:
   - Verify app theme matches device theme:
     - If device is in light mode, app uses light theme
     - If device is in dark mode, app uses dark theme
   - Change device theme:
     - Go to device settings
     - Change device theme (light to dark or vice versa)
     - Return to app
     - Verify app theme changes to match device theme

5. Verify theme persists:
   - Close app completely
   - Reopen app
   - Verify app still uses system theme
   - Verify app theme matches device theme

**Expected Results**:
- ✅ User can switch to system theme
- ✅ App theme follows device theme
- ✅ App theme updates when device theme changes
- ✅ System theme persists after app restart

---

## Test Case 4: App-Wide Primary Color Change

**Objective**: Verify that users can change app-wide primary color using color picker.

**Preconditions**:
- User is logged in
- User is on the app settings page
- Primary color change feature is implemented

**Steps**:
1. Navigate to app settings page:
   - From home screen, tap on "Settings" icon or menu
   - Verify app settings page is displayed

2. Locate primary color picker:
   - Scroll to "Primary Color" section (if needed)
   - Verify primary color picker is displayed:
     - Color preview box
     - Hue slider
     - Saturation slider
     - Value slider
   - Verify current primary color is shown in preview

3. Change primary color:
   - Adjust Hue slider to a different value (e.g., 120 for green)
   - Verify color preview updates immediately
   - Adjust Saturation slider (if needed)
   - Adjust Value slider (if needed)
   - Verify final color is shown in preview

4. Verify primary color change is applied:
   - Verify primary color changes throughout app immediately:
     - App bar background color changes
     - Button colors change
     - Primary action colors change
     - Focus indicators change
   - Verify color is palette-safe:
     - Colors are readable (good contrast)
     - Colors are visually consistent
     - Related colors (containers, accents) are derived correctly

5. Verify primary color persists:
   - Close app completely
   - Reopen app
   - Verify app still uses the new primary color

**Expected Results**:
- ✅ Primary color picker is displayed
- ✅ User can change primary color using sliders
- ✅ Color preview updates in real-time
- ✅ Primary color change is applied immediately throughout app
- ✅ Color is palette-safe and readable
- ✅ Primary color persists after app restart

---

## Test Case 5: Per-Workspace Theme Mode - Set Theme for Workspace

**Objective**: Verify that users can set theme mode per workspace (workspace-specific theme).

**Preconditions**:
- User is logged in
- User has access to at least one workspace
- User is on workspace settings page
- Per-workspace theme feature is implemented

**Steps**:
1. Navigate to workspace settings page:
   - From home screen, tap on workspace selector
   - Select a workspace
   - Tap on "Settings" or "Workspace Settings"
   - Verify workspace settings page is displayed

2. Locate theme setting:
   - Scroll to find theme setting (if needed)
   - **If NOT implemented**: Theme setting is not available (this is expected - partial implementation)
   - **If implemented**: 
     - Verify theme setting is displayed:
       - "Theme" label
       - Theme options (Light, Dark, System)
       - Current theme is indicated

3. Set theme for workspace:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Tap on a theme option (e.g., "Dark")
     - Verify theme option is selected
     - Save workspace settings (if required):
       - Tap "Save" button
       - Verify settings are saved

4. Verify workspace theme is applied:
   - **If NOT implemented**: Workspace theme is not applied (this is expected - partial implementation)
   - **If implemented**: 
     - Verify app theme changes to match workspace theme
     - Switch to another workspace:
       - Tap on workspace selector
       - Select a different workspace
       - Verify app theme changes to match that workspace's theme
     - Switch back to original workspace:
       - Verify app theme changes back to original workspace's theme

5. Verify workspace theme persists:
   - Close app completely
   - Reopen app
   - Switch to the workspace with custom theme
   - Verify workspace theme is still applied

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Per-workspace theme mode is PARTIALLY implemented (theme field exists in WorkspaceSettings, but may not be fully integrated)
- ✅ **When fully implemented**: Users can set theme per workspace
- ✅ Workspace theme is applied when switching workspaces
- ✅ Workspace theme persists after app restart

---

## Test Case 6: Per-Workspace Primary Color - Set Primary Color for Workspace

**Objective**: Verify that users can set primary color per workspace (workspace-specific primary color).

**Preconditions**:
- User is logged in
- User has access to at least one workspace
- User is on workspace settings page
- Per-workspace primary color feature is implemented

**Steps**:
1. Navigate to workspace settings page:
   - From home screen, tap on workspace selector
   - Select a workspace
   - Tap on "Settings" or "Workspace Settings"
   - Verify workspace settings page is displayed

2. Locate primary color setting:
   - Scroll to find primary color setting (if needed)
   - **If NOT implemented**: Primary color setting is not available (this is expected - not supported)
   - **If implemented**: 
     - Verify primary color picker is displayed:
       - Color preview
       - Color picker controls (sliders or color grid)
       - Current primary color is shown

3. Set primary color for workspace:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Select a new primary color (e.g., green)
     - Verify color preview updates
     - Save workspace settings (if required):
       - Tap "Save" button
       - Verify settings are saved

4. Verify workspace primary color is applied:
   - **If NOT implemented**: Workspace primary color is not applied (this is expected - not supported)
   - **If implemented**: 
     - Verify app primary color changes to match workspace primary color
     - Switch to another workspace:
       - Tap on workspace selector
       - Select a different workspace
       - Verify app primary color changes to match that workspace's primary color
     - Switch back to original workspace:
       - Verify app primary color changes back to original workspace's primary color

5. Verify workspace primary color persists:
   - Close app completely
   - Reopen app
   - Switch to the workspace with custom primary color
   - Verify workspace primary color is still applied

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Per-workspace primary color is NOT implemented (not supported)
- ✅ **When implemented**: Users can set primary color per workspace
- ✅ Workspace primary color is applied when switching workspaces
- ✅ Workspace primary color persists after app restart

---

## Test Case 7: Workspace Switching with Theme/Color - Theme Persistence

**Objective**: Verify that theme and color settings persist correctly when switching between workspaces.

**Preconditions**:
- User is logged in
- User has access to at least 2 workspaces
- Workspace 1 has custom theme (e.g., dark) and/or primary color
- Workspace 2 has different custom theme (e.g., light) and/or primary color
- Per-workspace theme/color feature is implemented

**Steps**:
1. Set up workspace 1 with custom theme/color:
   - Switch to workspace 1
   - Navigate to workspace settings
   - Set theme to "Dark" (if implemented)
   - Set primary color to blue (if implemented)
   - Save settings
   - Verify theme/color is applied

2. Set up workspace 2 with different theme/color:
   - Switch to workspace 2
   - Navigate to workspace settings
   - Set theme to "Light" (if implemented)
   - Set primary color to green (if implemented)
   - Save settings
   - Verify theme/color is applied

3. Switch between workspaces:
   - Switch to workspace 1:
     - Tap on workspace selector
     - Select workspace 1
     - Verify app theme/color changes to workspace 1's theme/color
   - Switch to workspace 2:
     - Tap on workspace selector
     - Select workspace 2
     - Verify app theme/color changes to workspace 2's theme/color
   - Switch back to workspace 1:
     - Verify app theme/color changes back to workspace 1's theme/color

4. Verify persistence after app restart:
   - Close app completely
   - Reopen app
   - Switch to workspace 1:
     - Verify workspace 1's theme/color is applied
   - Switch to workspace 2:
     - Verify workspace 2's theme/color is applied

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Per-workspace theme/color persistence is PARTIAL (theme exists, but primary color not supported)
- ✅ **When fully implemented**: Theme/color persists correctly when switching workspaces
- ✅ Each workspace maintains its own theme/color settings
- ✅ Theme/color persists after app restart

---

## Test Case 8: Device-Level Theme Persistence - App-Wide Settings

**Objective**: Verify that app-wide theme and color settings persist at device level (not per-workspace).

**Preconditions**:
- User is logged in
- User has access to multiple workspaces
- App-wide theme/color settings are set

**Steps**:
1. Set app-wide theme and color:
   - Navigate to app settings page
   - Set theme mode to "Dark"
   - Set primary color to red
   - Verify theme/color is applied

2. Switch between workspaces:
   - Switch to workspace 1
   - Verify app-wide theme/color is still applied (if no workspace-specific override)
   - Switch to workspace 2
   - Verify app-wide theme/color is still applied (if no workspace-specific override)

3. Verify device-level persistence:
   - Close app completely
   - Reopen app
   - Verify app-wide theme/color is still applied
   - Switch to any workspace
   - Verify app-wide theme/color is still applied (if no workspace-specific override)

4. Test workspace override (if implemented):
   - Set workspace-specific theme/color for a workspace
   - Switch to that workspace
   - Verify workspace-specific theme/color is applied (overrides app-wide)
   - Switch to another workspace (without workspace-specific settings)
   - Verify app-wide theme/color is applied

**Expected Results**:
- ✅ App-wide theme/color persists at device level
- ✅ App-wide theme/color is applied when no workspace-specific override
- ✅ Workspace-specific theme/color overrides app-wide (if implemented)
- ✅ Device-level settings persist after app restart

---

## Test Case 9: Primary Color Palette Safety - Color Validation

**Objective**: Verify that primary color changes maintain palette safety (readability, contrast, consistency).

**Preconditions**:
- User is logged in
- User is on the app settings page
- Primary color change feature is implemented

**Steps**:
1. Navigate to app settings page:
   - From home screen, tap on "Settings" icon or menu
   - Verify app settings page is displayed

2. Test with very light color:
   - Set primary color to very light color (e.g., white or very light yellow)
   - Verify color is applied
   - Check readability:
     - Verify text on primary color background is readable (dark text on light background)
     - Verify buttons with primary color are readable
     - Verify app bar with primary color is readable
   - **Expected**: System should ensure contrast (e.g., use dark text on light background)

3. Test with very dark color:
   - Set primary color to very dark color (e.g., black or very dark blue)
   - Verify color is applied
   - Check readability:
     - Verify text on primary color background is readable (light text on dark background)
     - Verify buttons with primary color are readable
     - Verify app bar with primary color is readable
   - **Expected**: System should ensure contrast (e.g., use light text on dark background)

4. Test with saturated color:
   - Set primary color to highly saturated color (e.g., bright red, bright green)
   - Verify color is applied
   - Check visual consistency:
     - Verify related colors (containers, accents) are derived correctly
     - Verify color scheme is visually consistent
     - Verify colors don't clash

5. Test with low contrast color:
   - Set primary color to color with low contrast (e.g., light gray on white background)
   - Verify system handles low contrast:
     - System adjusts contrast automatically
     - OR System warns user about low contrast
     - OR System prevents low contrast colors

**Expected Results**:
- ✅ Primary color changes maintain readability
- ✅ System ensures proper contrast (light text on dark, dark text on light)
- ✅ Related colors are derived correctly
- ✅ Color scheme is visually consistent
- ✅ Low contrast colors are handled appropriately

---

## Test Case 10: Theme/Color Reset - Restore Defaults

**Objective**: Verify that users can reset theme and color settings to defaults.

**Preconditions**:
- User is logged in
- User has customized theme and/or primary color
- User is on the app settings page or workspace settings page

**Steps**:
1. Navigate to settings page:
   - Navigate to app settings page (for app-wide reset)
   - OR Navigate to workspace settings page (for workspace-specific reset)

2. Locate reset option:
   - **If NOT implemented**: Reset option is not available (this is expected - may need to be implemented)
   - **If implemented**: 
     - Locate "Reset to Default" or "Restore Defaults" button
     - Verify reset option is displayed

3. Reset theme and color:
   - **If NOT implemented**: Skip this step (feature missing)
   - **If implemented**: 
     - Tap on "Reset to Default" button
     - Verify confirmation dialog appears (if applicable):
         - Dialog asks: "Reset theme and color to defaults?"
         - Options: "Reset" and "Cancel"
       - Tap "Reset" (if confirmation required)
       - Verify settings are reset:
         - Theme mode resets to default (e.g., "System")
         - Primary color resets to default (e.g., original primary color)

4. Verify defaults are applied:
   - Verify app theme/color changes to defaults immediately
   - Verify defaults are correct:
     - Default theme mode is applied
     - Default primary color is applied
   - Close app completely
   - Reopen app
   - Verify defaults are still applied

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Reset to defaults may not be implemented
- ✅ **When implemented**: Users can reset theme/color to defaults
- ✅ Reset option is accessible
- ✅ Defaults are applied correctly
- ✅ Defaults persist after app restart

---

## Summary

### Current Status: ⚠️ PARTIAL
UI customization feature is **PARTIALLY IMPLEMENTED**:
- ✅ Theme files exist
- ✅ `AppSettingsPage` exists with theme mode picker and primary color picker
- ✅ App-wide theme switching works (light/dark/system)
- ✅ App-wide primary color change works
- ⚠️ `WorkspaceSettingsPage` lets set theme per workspace (theme field exists)
- ⛔ Primary color change not supported per workspace
- ⚠️ Per-workspace persistence is partial (theme exists, primary color missing)

### What Needs to Be Implemented/Improved:
1. ✅ App-wide theme mode switching (already works)
2. ✅ App-wide primary color change (already works)
3. ⚠️ Per-workspace theme mode (partially works - needs full integration)
4. ⛔ Per-workspace primary color change (not implemented)
5. ⚠️ Per-workspace persistence (partial - needs improvement)
6. ⚠️ Workspace switching with theme/color (partial - needs full support)
7. ⚠️ Reset to defaults (may not be implemented)

### Test Execution Notes:
- Test cases marked as "Partial" should verify current behavior and document gaps
- Test cases marked as "Not Implemented" should document expected behavior for future implementation
- Focus on theme switching, primary color change, and persistence
- Test with multiple workspaces to verify per-workspace functionality
- Test with app restart to verify persistence

### Security and Reliability Considerations:
- Theme/color settings should not break app functionality
- Palette safety must be maintained (readability, contrast)
- Persistence should work reliably across app restarts
- Workspace switching should handle theme/color changes smoothly
- Default values should be safe and accessible

