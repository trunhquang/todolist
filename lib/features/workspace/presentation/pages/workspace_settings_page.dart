import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/theme/app_colors.dart';
import 'package:todolist/app/theme/app_text_styles.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/app/widgets/td_text_field.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_settings.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';

/// Page for managing workspace settings
class WorkspaceSettingsPage extends StatefulWidget {

  const WorkspaceSettingsPage({
    super.key,
    required this.workspace,
  });
  final Workspace workspace;

  @override
  State<WorkspaceSettingsPage> createState() => _WorkspaceSettingsPageState();
}

class _WorkspaceSettingsPageState extends State<WorkspaceSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _logoUrlController = TextEditingController();
  
  late WorkspaceSettings _currentSettings;
  final WorkspaceController _workspaceController = Get.find<WorkspaceController>();

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  void _initializeSettings() {
    _currentSettings = WorkspaceSettings.fromMap(
      widget.workspace.settings ?? {},
    );
    
    _descriptionController.text = _currentSettings.description ?? '';
    _logoUrlController.text = _currentSettings.logoUrl ?? '';
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _logoUrlController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveSettings() async {
    if (_formKey.currentState!.validate()) {
      final updatedSettings = _currentSettings.copyWith(
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        logoUrl: _logoUrlController.text.trim().isEmpty
            ? null
            : _logoUrlController.text.trim(),
      );

      final updatedWorkspace = widget.workspace.copyWith(
        settings: updatedSettings.toMap(),
        updatedAt: DateTime.now(),
      );

      await _workspaceController.updateWorkspace(updatedWorkspace);

      // Navigate back on success
      if (!_workspaceController.isLoading) {
        NavigationService().back<void>();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.workspaceSettings),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.onBackground,
        actions: [
          Obx(() => TDButton(
            text: AppStrings.save,
            onPressed: _workspaceController.isLoading ? null : _handleSaveSettings,
            isLoading: _workspaceController.isLoading,
            variant: TDButtonVariant.text,
          )),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Basic Settings Section
                _buildSection(
                  title: 'Basic Settings',
                  children: [
                    TDTextField(
                      controller: _descriptionController,
                      label: AppStrings.workspaceDescription,
                      hint: AppStrings.enterWorkspaceDescription,
                      prefixIcon: Icons.description_outlined,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TDTextField(
                      controller: _logoUrlController,
                      label: 'Logo URL',
                      hint: 'Enter workspace logo URL',
                      prefixIcon: Icons.image_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Localization Settings Section
                _buildSection(
                  title: 'Localization',
                  children: [
                    _buildDropdownSetting(
                      title: 'Timezone',
                      value: _currentSettings.timezone,
                      items: WorkspaceTimezones.available,
                      onChanged: (value) {
                        setState(() {
                          _currentSettings = _currentSettings.copyWith(timezone: value);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownSetting(
                      title: 'Language',
                      value: _currentSettings.language,
                      items: WorkspaceLanguages.available,
                      displayNames: WorkspaceLanguages.available
                          .map(WorkspaceLanguages.getDisplayName)
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _currentSettings = _currentSettings.copyWith(language: value);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownSetting(
                      title: 'Date Format',
                      value: _currentSettings.dateFormat,
                      items: WorkspaceDateFormats.available,
                      onChanged: (value) {
                        setState(() {
                          _currentSettings = _currentSettings.copyWith(dateFormat: value);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownSetting(
                      title: 'Time Format',
                      value: _currentSettings.timeFormat,
                      items: WorkspaceTimeFormats.available,
                      onChanged: (value) {
                        setState(() {
                          _currentSettings = _currentSettings.copyWith(timeFormat: value);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownSetting(
                      title: 'Currency',
                      value: _currentSettings.currency,
                      items: WorkspaceCurrencies.available,
                      displayNames: WorkspaceCurrencies.available
                          .map(WorkspaceCurrencies.getDisplayName)
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _currentSettings = _currentSettings.copyWith(currency: value);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Appearance Settings Section
                _buildSection(
                  title: 'Appearance',
                  children: [
                    _buildDropdownSetting(
                      title: 'Theme',
                      value: _currentSettings.theme,
                      items: WorkspaceThemes.available,
                      displayNames: WorkspaceThemes.available
                          .map(WorkspaceThemes.getDisplayName)
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _currentSettings = _currentSettings.copyWith(theme: value);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Preferences Settings Section
                _buildSection(
                  title: 'Preferences',
                  children: [
                    _buildSwitchSetting(
                      title: 'Notifications',
                      subtitle: 'Enable workspace notifications',
                      value: _currentSettings.notifications,
                      onChanged: (value) {
                        setState(() {
                          _currentSettings = _currentSettings.copyWith(notifications: value);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSwitchSetting(
                      title: 'Auto Save',
                      subtitle: 'Automatically save changes',
                      value: _currentSettings.autoSave,
                      onChanged: (value) {
                        setState(() {
                          _currentSettings = _currentSettings.copyWith(autoSave: value);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Save Button
                Obx(() => TDButton(
                  text: AppStrings.save,
                  onPressed: _workspaceController.isLoading ? null : _handleSaveSettings,
                  isLoading: _workspaceController.isLoading,
                )),
                const SizedBox(height: 16),
                
                // Cancel Button
                Obx(() => TDButton(
                  text: AppStrings.cancel,
                  onPressed: _workspaceController.isLoading ? null : () => NavigationService().back<void>(),
                  variant: TDButtonVariant.outlined,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.onBackground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDropdownSetting({
    required String title,
    required String value,
    required List<String> items,
    List<String>? displayNames,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final displayName = displayNames?[index] ?? item;
            
            return DropdownMenuItem<String>(
              value: item,
              child: Text(displayName),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchSetting({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.onBackground,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
        ),
      ],
    );
  }
}
