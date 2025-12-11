# UI Customization: Primary Color Change, Theme Light/Dark, Per-Workspace/Device Persistence - Task List & Implementation Steps

## Overview
This document lists all tasks required to complete the **UI Customization** feature. Currently, this feature is **PARTIAL** - Theme files exist, `WorkspaceSettingsPage` lets set theme/timezone/language per workspace, but primary color change not supported per workspace; per-workspace persistence is partial; app-wide theme toggle page exists (`AppSettingsPage`). This feature should include: primary color change (palette-safe), theme light/dark switching, and saving theme per workspace or device.

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `ThemeController` - manages app-wide theme mode and primary color
- ✅ `AppSettingsPage` - UI for app-wide theme mode picker and primary color picker
- ✅ `AppTheme` - defines light/dark theme
- ✅ `AppColors` - defines colors, has `applyPrimary()` method
- ✅ `WorkspaceSettings` entity - has `theme` field (light/dark/system)
- ✅ `WorkspaceSettingsPage` - can set theme per workspace (partial)

### What's Missing/Broken:
- ⛔ Primary color change not supported per workspace (only app-wide)
- ⚠️ Per-workspace theme persistence is partial (theme field exists but may not be fully integrated)
- ⚠️ Workspace switching doesn't fully apply workspace-specific theme/color
- ⚠️ Reset to defaults may not be implemented

---

## Task List

### Task 1: Enhance WorkspaceSettings Entity to Support Primary Color

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 1-2 hours

**Description**:
Add primary color field to `WorkspaceSettings` entity to support per-workspace primary color.

**Files to Modify**:
- `lib/features/workspace/domain/entities/workspace_settings.dart`

**Dependencies**:
- None

**Implementation Steps**:

1. **Add primaryColor field to WorkspaceSettings**:
   ```dart
   // In lib/features/workspace/domain/entities/workspace_settings.dart
   class WorkspaceSettings {
     const WorkspaceSettings({
       // ... existing fields ...
       this.theme = 'system',
       this.primaryColor, // Add this field (nullable int for ARGB value)
       this.customFields = const {},
     });
     
     final String? description;
     final String? logoUrl;
     final String timezone;
     final String language;
     final String dateFormat;
     final String timeFormat;
     final String currency;
     final bool notifications;
     final bool autoSave;
     final String theme;
     final int? primaryColor; // Add this field
     final Map<String, dynamic> customFields;
   }
   ```

2. **Update fromMap factory**:
   ```dart
   factory WorkspaceSettings.fromMap(Map<String, dynamic> map) {
     return WorkspaceSettings(
       // ... existing fields ...
       theme: map['theme']?.toString() ?? 'system',
       primaryColor: map['primaryColor'] is int 
           ? map['primaryColor'] as int
           : map['primaryColor'] != null 
               ? int.tryParse(map['primaryColor'].toString())
               : null,
       customFields: map['customFields'] is Map<String, dynamic>
           ? Map<String, dynamic>.from(map['customFields'] as Map<String, dynamic>)
           : const {},
     );
   }
   ```

3. **Update copyWith method**:
   ```dart
   WorkspaceSettings copyWith({
     // ... existing parameters ...
     String? theme,
     int? primaryColor, // Add this parameter
     Map<String, dynamic>? customFields,
   }) {
     return WorkspaceSettings(
       // ... existing fields ...
       theme: theme ?? this.theme,
       primaryColor: primaryColor ?? this.primaryColor, // Add this
       customFields: customFields ?? this.customFields,
     );
   }
   ```

4. **Update toMap method**:
   ```dart
   Map<String, dynamic> toMap() {
     return {
       // ... existing fields ...
       'theme': theme,
       'primaryColor': primaryColor, // Add this
       'customFields': customFields,
     };
   }
   ```

5. **Update equality operator**:
   ```dart
   @override
   bool operator ==(Object other) {
     if (identical(this, other)) return true;
     return other is WorkspaceSettings &&
         // ... existing comparisons ...
         other.theme == theme &&
         other.primaryColor == primaryColor; // Add this
   }
   ```

6. **Update hashCode**:
   ```dart
   @override
   int get hashCode {
     return // ... existing hash codes ...
         theme.hashCode ^
         (primaryColor?.hashCode ?? 0); // Add this
   }
   ```

**Expected Results**:
- ✅ WorkspaceSettings entity has primaryColor field
- ✅ primaryColor is nullable (workspace can have no custom primary color)
- ✅ primaryColor is stored as int (ARGB value)
- ✅ All methods (fromMap, copyWith, toMap, equality) are updated

**Testing**:
- Test WorkspaceSettings creation with primaryColor
- Test WorkspaceSettings creation without primaryColor
- Test fromMap/toMap with primaryColor
- Test copyWith with primaryColor
- Test equality with primaryColor

---

### Task 2: Create Workspace Theme Service

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Create service to manage workspace-specific theme and primary color, with integration to ThemeController.

**Files to Create/Modify**:
- `lib/core/services/workspace_theme_service.dart` (new file)
- `lib/app/theme/theme_controller.dart` (modify to integrate workspace theme)

**Dependencies**:
- Task 1 (WorkspaceSettings with primaryColor)
- WorkspaceController (to get current workspace)

**Implementation Steps**:

1. **Create WorkspaceThemeService**:
   ```dart
   // lib/core/services/workspace_theme_service.dart
   import 'package:get/get.dart';
   import 'package:flutter/material.dart';
   import '../../features/workspace/domain/entities/workspace_settings.dart';
   import '../../features/workspace/presentation/controllers/workspace_controller.dart';
   import '../app/theme/theme_controller.dart';
   import '../app/theme/app_colors.dart';
   
   class WorkspaceThemeService {
     factory WorkspaceThemeService() => _instance ??= WorkspaceThemeService._();
     WorkspaceThemeService._();
     static WorkspaceThemeService? _instance;
     
     final WorkspaceController _workspaceController = Get.find<WorkspaceController>();
     final ThemeController _themeController = Get.find<ThemeController>();
     
     /// Apply workspace theme and primary color
     Future<void> applyWorkspaceTheme(String workspaceId) async {
       try {
         final workspace = _workspaceController.getWorkspaceById(workspaceId);
         if (workspace == null) return;
         
         final settings = WorkspaceSettings.fromMap(workspace.settings ?? {});
         
         // Apply workspace theme mode
         if (settings.theme != 'system') {
           final themeMode = _parseThemeMode(settings.theme);
           await _themeController.setThemeMode(themeMode);
         }
         
         // Apply workspace primary color
         if (settings.primaryColor != null) {
           final color = Color(settings.primaryColor!);
           await _themeController.setPrimaryColor(color);
         }
       } catch (e) {
         Get.log('ERROR: Failed to apply workspace theme: $e');
       }
     }
     
     /// Get workspace theme mode
     ThemeMode? getWorkspaceThemeMode(String workspaceId) {
       try {
         final workspace = _workspaceController.getWorkspaceById(workspaceId);
         if (workspace == null) return null;
         
         final settings = WorkspaceSettings.fromMap(workspace.settings ?? {});
         if (settings.theme == 'system') return null;
         
         return _parseThemeMode(settings.theme);
       } catch (e) {
         return null;
       }
     }
     
     /// Get workspace primary color
     Color? getWorkspacePrimaryColor(String workspaceId) {
       try {
         final workspace = _workspaceController.getWorkspaceById(workspaceId);
         if (workspace == null) return null;
         
         final settings = WorkspaceSettings.fromMap(workspace.settings ?? {});
         if (settings.primaryColor == null) return null;
         
         return Color(settings.primaryColor!);
       } catch (e) {
         return null;
       }
     }
     
     ThemeMode _parseThemeMode(String theme) {
       switch (theme) {
         case 'light':
           return ThemeMode.light;
         case 'dark':
           return ThemeMode.dark;
         case 'system':
         default:
           return ThemeMode.system;
       }
     }
   }
   ```

2. **Initialize WorkspaceThemeService in app.dart**:
   ```dart
   // In lib/app/app.dart
   import 'core/services/workspace_theme_service.dart';
   
   static Future<void> initialize() async {
     // ... existing initialization ...
     
     // Initialize Workspace Theme Service
     Get.put(WorkspaceThemeService());
   }
   ```

3. **Integrate with WorkspaceController workspace switching**:
   ```dart
   // In lib/features/workspace/presentation/controllers/workspace_controller.dart
   import '../../../core/services/workspace_theme_service.dart';
   
   Future<void> switchWorkspace(String workspaceId) async {
     // ... existing switch workspace logic ...
     
     // Apply workspace theme after switching
     final workspaceThemeService = Get.find<WorkspaceThemeService>();
     await workspaceThemeService.applyWorkspaceTheme(workspaceId);
   }
   ```

**Expected Results**:
- ✅ WorkspaceThemeService exists
- ✅ Service can apply workspace theme and primary color
- ✅ Service is initialized in app.dart
- ✅ Service is integrated with workspace switching
- ✅ Workspace theme is applied when switching workspaces

**Testing**:
- Test applyWorkspaceTheme with theme and primary color
- Test applyWorkspaceTheme with only theme
- Test applyWorkspaceTheme with only primary color
- Test applyWorkspaceTheme with no custom settings
- Test integration with workspace switching

---

### Task 3: Add Primary Color Picker to WorkspaceSettingsPage

**Priority**: High  
**Status**: ⚠️ Not Started  
**Estimated Time**: 3-4 hours

**Description**:
Add primary color picker to `WorkspaceSettingsPage` to allow users to set primary color per workspace.

**Files to Modify**:
- `lib/features/workspace/presentation/pages/workspace_settings_page.dart`

**Dependencies**:
- Task 1 (WorkspaceSettings with primaryColor)
- Task 2 (WorkspaceThemeService)

**Implementation Steps**:

1. **Add primary color picker to WorkspaceSettingsPage**:
   ```dart
   // In lib/features/workspace/presentation/pages/workspace_settings_page.dart
   import 'package:flutter/material.dart';
   import '../../../../app/pages/settings/app_settings_page.dart'; // For _ColorPicker widget
   
   class _WorkspaceSettingsPageState extends State<WorkspaceSettingsPage> {
     // ... existing code ...
     
     int? _workspacePrimaryColor; // Add this field
     
     @override
     void initState() {
       super.initState();
       _initializeSettings();
     }
     
     void _initializeSettings() {
       _currentSettings = WorkspaceSettings.fromMap(
         widget.workspace.settings ?? {},
       );
       
       // ... existing initialization ...
       
       // Initialize primary color
       _workspacePrimaryColor = _currentSettings.primaryColor;
     }
     
     Future<void> _handleSaveSettings() async {
       if (_formKey.currentState!.validate()) {
         final updatedSettings = _currentSettings.copyWith(
           // ... existing fields ...
           primaryColor: _workspacePrimaryColor, // Add this
         );
         
         // ... existing save logic ...
       }
     }
     
     @override
     Widget build(BuildContext context) {
       return Scaffold(
         // ... existing scaffold ...
         body: SingleChildScrollView(
           padding: EdgeInsets.all(16),
           child: Form(
             key: _formKey,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 // ... existing fields ...
                 
                 // Add Primary Color Section
                 SizedBox(height: 24),
                 Text(
                   AppStrings.primaryColor,
                   style: Theme.of(context).textTheme.titleMedium,
                 ),
                 SizedBox(height: 12),
                 _ColorPicker(
                   initial: _workspacePrimaryColor != null
                       ? Color(_workspacePrimaryColor!)
                       : AppColors.primary,
                   onChanged: (Color color) {
                     setState(() {
                       _workspacePrimaryColor = color.value;
                     });
                   },
                 ),
                 
                 // ... existing fields ...
               ],
             ),
           ),
         ),
       );
     }
   }
   ```

2. **Add AppStrings constant** (if not already exists):
   ```dart
   // In app_strings.dart
   static const String primaryColor = 'Primary Color';
   ```

3. **Reuse _ColorPicker widget from AppSettingsPage**:
   - Extract `_ColorPicker` widget to a shared location (e.g., `lib/app/widgets/color_picker.dart`)
   - OR Import and use from `app_settings_page.dart` (if accessible)

**Expected Results**:
- ✅ Primary color picker is added to WorkspaceSettingsPage
- ✅ Users can select primary color for workspace
- ✅ Primary color is saved with workspace settings
- ✅ Primary color picker UI is consistent with app settings

**Testing**:
- Test primary color picker display
- Test primary color selection
- Test primary color saving
- Test primary color persistence

---

### Task 4: Improve Per-Workspace Theme Integration

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Improve integration of per-workspace theme mode with ThemeController to ensure workspace theme is applied correctly.

**Files to Modify**:
- `lib/features/workspace/presentation/pages/workspace_settings_page.dart`
- `lib/core/services/workspace_theme_service.dart`

**Dependencies**:
- Task 2 (WorkspaceThemeService)

**Implementation Steps**:

1. **Ensure WorkspaceSettingsPage saves theme correctly**:
   ```dart
   // In lib/features/workspace/presentation/pages/workspace_settings_page.dart
   // Verify theme is saved correctly in _handleSaveSettings
   final updatedSettings = _currentSettings.copyWith(
     // ... existing fields ...
     theme: _selectedTheme, // Ensure theme is saved
   );
   ```

2. **Add theme mode picker to WorkspaceSettingsPage** (if not already present):
   ```dart
   // Add theme mode picker similar to AppSettingsPage
   SizedBox(height: 24),
   Text(
     AppStrings.theme,
     style: Theme.of(context).textTheme.titleMedium,
   ),
   SizedBox(height: 12),
   Wrap(
     spacing: 8,
     runSpacing: 8,
     children: [
       ChoiceChip(
         label: Text(AppStrings.lightTheme),
         selected: _currentSettings.theme == 'light',
         onSelected: (_) {
           setState(() {
             _currentSettings = _currentSettings.copyWith(theme: 'light');
           });
         },
       ),
       ChoiceChip(
         label: Text(AppStrings.darkTheme),
         selected: _currentSettings.theme == 'dark',
         onSelected: (_) {
           setState(() {
             _currentSettings = _currentSettings.copyWith(theme: 'dark');
           });
         },
       ),
       ChoiceChip(
         label: Text(AppStrings.systemTheme),
         selected: _currentSettings.theme == 'system',
         onSelected: (_) {
           setState(() {
             _currentSettings = _currentSettings.copyWith(theme: 'system');
           });
         },
       ),
     ],
   ),
   ```

3. **Ensure workspace theme is applied immediately after save**:
   ```dart
   // In _handleSaveSettings
   await _workspaceController.updateWorkspace(updatedWorkspace);
   
   // Apply workspace theme immediately
   final workspaceThemeService = Get.find<WorkspaceThemeService>();
   await workspaceThemeService.applyWorkspaceTheme(widget.workspace.id);
   
   // Navigate back on success
   if (!_workspaceController.isLoading) {
     NavigationService().back<void>();
   }
   ```

**Expected Results**:
- ✅ Workspace theme is saved correctly
- ✅ Theme mode picker is available in WorkspaceSettingsPage
- ✅ Workspace theme is applied immediately after save
- ✅ Workspace theme persists correctly

**Testing**:
- Test theme mode picker in WorkspaceSettingsPage
- Test theme saving
- Test theme application after save
- Test theme persistence

---

### Task 5: Add Reset to Defaults Functionality

**Priority**: Low  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Add functionality to reset theme and primary color to defaults in both app settings and workspace settings.

**Files to Create/Modify**:
- `lib/app/pages/settings/app_settings_page.dart`
- `lib/features/workspace/presentation/pages/workspace_settings_page.dart`
- `lib/app/theme/theme_controller.dart` (add reset method)

**Dependencies**:
- Task 2 (WorkspaceThemeService)

**Implementation Steps**:

1. **Add reset method to ThemeController**:
   ```dart
   // In lib/app/theme/theme_controller.dart
   static const Color _defaultPrimaryColor = Color(0xFF081F40); // Default primary color
   
   Future<void> resetToDefaults() async {
     // Reset theme mode to system
     await setThemeMode(ThemeMode.system);
     
     // Reset primary color to default
     await setPrimaryColor(_defaultPrimaryColor);
   }
   ```

2. **Add reset button to AppSettingsPage**:
   ```dart
   // In lib/app/pages/settings/app_settings_page.dart
   SizedBox(height: 24),
   TDButton(
     text: AppStrings.resetToDefaults,
     onPressed: () async {
       // Show confirmation dialog
       final confirmed = await Get.dialog<bool>(
         AlertDialog(
           title: Text(AppStrings.resetToDefaults),
           content: Text(AppStrings.resetToDefaultsConfirmation),
           actions: [
             TextButton(
               onPressed: () => Get.back(result: false),
               child: Text(AppStrings.cancel),
             ),
             TextButton(
               onPressed: () => Get.back(result: true),
               child: Text(AppStrings.reset),
             ),
           ],
         ),
       );
       
       if (confirmed == true) {
         await controller.resetToDefaults();
       }
     },
   ),
   ```

3. **Add reset button to WorkspaceSettingsPage**:
   ```dart
   // In lib/features/workspace/presentation/pages/workspace_settings_page.dart
   SizedBox(height: 24),
   TDButton(
     text: AppStrings.resetToDefaults,
     onPressed: () async {
       // Show confirmation dialog
       final confirmed = await Get.dialog<bool>(
         AlertDialog(
           title: Text(AppStrings.resetToDefaults),
           content: Text(AppStrings.resetWorkspaceSettingsConfirmation),
           actions: [
             TextButton(
               onPressed: () => Get.back(result: false),
               child: Text(AppStrings.cancel),
             ),
             TextButton(
               onPressed: () => Get.back(result: true),
               child: Text(AppStrings.reset),
             ),
           ],
         ),
       );
       
       if (confirmed == true) {
         setState(() {
           _currentSettings = WorkspaceSettings(); // Reset to defaults
           _workspacePrimaryColor = null;
         });
       }
     },
   ),
   ```

4. **Add AppStrings constants**:
   ```dart
   // In app_strings.dart
   static const String resetToDefaults = 'Reset to Defaults';
   static const String resetToDefaultsConfirmation = 'Reset theme and color to defaults?';
   static const String resetWorkspaceSettingsConfirmation = 'Reset workspace theme and color to defaults?';
   static const String reset = 'Reset';
   static const String cancel = 'Cancel';
   ```

**Expected Results**:
- ✅ Reset to defaults functionality exists
- ✅ Reset button is available in AppSettingsPage
- ✅ Reset button is available in WorkspaceSettingsPage
- ✅ Confirmation dialog is shown before reset
- ✅ Defaults are applied correctly

**Testing**:
- Test reset to defaults in app settings
- Test reset to defaults in workspace settings
- Test confirmation dialog
- Test defaults are applied correctly

---

### Task 6: Improve Palette Safety for Primary Color

**Priority**: Medium  
**Status**: ⚠️ Not Started  
**Estimated Time**: 2-3 hours

**Description**:
Improve palette safety for primary color changes to ensure readability and contrast.

**Files to Modify**:
- `lib/app/theme/app_colors.dart`
- `lib/app/pages/settings/app_settings_page.dart` (color picker validation)

**Dependencies**:
- None

**Implementation Steps**:

1. **Improve applyPrimary method in AppColors**:
   ```dart
   // In lib/app/theme/app_colors.dart
   static void applyPrimary(Color newPrimary) {
     primary = newPrimary;
     
     // Ensure minimum contrast for readability
     final luminance = newPrimary.computeLuminance();
     
     // Derive containers and related colors
     primaryContainer = _tint(primary, 0.75);
     onPrimary = _contrastFor(primary);
     onPrimaryContainer = _contrastFor(primaryContainer);
     
     // Ensure onPrimary has sufficient contrast
     final onPrimaryLuminance = onPrimary.computeLuminance();
     final contrastRatio = _calculateContrastRatio(primary, onPrimary);
     
     // If contrast is too low, adjust onPrimary
     if (contrastRatio < 4.5) { // WCAG AA minimum
       onPrimary = luminance > 0.5 
           ? const Color(0xFF000000) 
           : const Color(0xFFFFFFFF);
     }
     
     // Tie domain-specific colors to primary
     dailyTask = primary;
     lowPriority = primary;
     completedStatus = primary;
     success = primary;
   }
   
   static double _calculateContrastRatio(Color color1, Color color2) {
     final l1 = color1.computeLuminance();
     final l2 = color2.computeLuminance();
     final lighter = l1 > l2 ? l1 : l2;
     final darker = l1 > l2 ? l2 : l1;
     return (lighter + 0.05) / (darker + 0.05);
   }
   ```

2. **Add color validation in color picker** (optional):
   ```dart
   // In _ColorPicker widget
   // Add warning if contrast is too low
   void _emit() {
     final color = HSVColor.fromAHSV(1, _hue, _saturation, _value).toColor();
     
     // Check contrast
     final contrast = _calculateContrastRatio(color, AppColors.background);
     if (contrast < 2.0) {
       // Show warning (optional)
       Get.log('WARNING: Low contrast color selected');
     }
     
     widget.onChanged(color);
     setState(() {});
   }
   ```

**Expected Results**:
- ✅ Primary color changes maintain minimum contrast
- ✅ onPrimary color is adjusted for readability
- ✅ Color scheme is visually consistent
- ✅ Palette safety is maintained

**Testing**:
- Test with very light colors
- Test with very dark colors
- Test with low contrast colors
- Test contrast ratio calculation
- Test onPrimary adjustment

---

## Summary

### Implementation Order:
1. **Task 1**: Enhance WorkspaceSettings Entity to Support Primary Color
2. **Task 2**: Create Workspace Theme Service
3. **Task 3**: Add Primary Color Picker to WorkspaceSettingsPage
4. **Task 4**: Improve Per-Workspace Theme Integration
5. **Task 6**: Improve Palette Safety for Primary Color
6. **Task 5**: Add Reset to Defaults Functionality

### Estimated Total Time: 13-19 hours

### Dependencies:
- Task 1 is independent
- Task 2 depends on Task 1
- Task 3 depends on Tasks 1 and 2
- Task 4 depends on Task 2
- Task 5 depends on Task 2
- Task 6 is independent

### Testing Requirements:
- Unit tests for WorkspaceSettings with primaryColor
- Unit tests for WorkspaceThemeService
- Widget tests for color picker
- Integration tests for workspace theme switching
- Manual testing for palette safety

### Success Criteria:
- ✅ Primary color can be set per workspace
- ✅ Theme mode can be set per workspace
- ✅ Workspace theme/color is applied when switching workspaces
- ✅ Per-workspace settings persist correctly
- ✅ App-wide settings work correctly
- ✅ Palette safety is maintained
- ✅ Reset to defaults works

### Security and Reliability Considerations:
- Primary color changes should not break app functionality
- Palette safety must be maintained (readability, contrast)
- Persistence should work reliably across app restarts
- Workspace switching should handle theme/color changes smoothly
- Default values should be safe and accessible

