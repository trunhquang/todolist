import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/notification_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/snackbar_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/td_button.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final _notificationService = Get.find<NotificationService>();
  final _storageService = Get.find<StorageService>();
  
  final _taskReminders = true.obs;
  final _reportReminders = true.obs;
  final _deadlineAlerts = true.obs;
  final _assignmentNotifications = true.obs;
  final _completionCelebrations = true.obs;
  final _streakNotifications = true.obs;
  final _departmentSummaries = true.obs;
  
  final _reminderTime = '17:00'.obs; // Default 5 PM
  final _isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      _isLoading.value = true;
      
      // Load settings from storage
      _taskReminders.value = _storageService.getBool('notification_task_reminders') ?? true;
      _reportReminders.value = _storageService.getBool('notification_report_reminders') ?? true;
      _deadlineAlerts.value = _storageService.getBool('notification_deadline_alerts') ?? true;
      _assignmentNotifications.value = _storageService.getBool('notification_assignments') ?? true;
      _completionCelebrations.value = _storageService.getBool('notification_completions') ?? true;
      _streakNotifications.value = _storageService.getBool('notification_streaks') ?? true;
      _departmentSummaries.value = _storageService.getBool('notification_department_summaries') ?? true;
      
      _reminderTime.value = _storageService.getString('notification_reminder_time') ?? '17:00';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _saveSettings() async {
    try {
      _isLoading.value = true;
      
      // Save settings to storage
      await _storageService.setBool('notification_task_reminders', value: _taskReminders.value);
      await _storageService.setBool('notification_report_reminders', value: _reportReminders.value);
      await _storageService.setBool('notification_deadline_alerts', value: _deadlineAlerts.value);
      await _storageService.setBool('notification_assignments', value: _assignmentNotifications.value);
      await _storageService.setBool('notification_completions', value: _completionCelebrations.value);
      await _storageService.setBool('notification_streaks', value: _streakNotifications.value);
      await _storageService.setBool('notification_department_summaries', value: _departmentSummaries.value);
      
      await _storageService.setString('notification_reminder_time', _reminderTime.value);
      
      SnackbarService().showSuccess(
        title: 'Success',
        message: 'Notification settings saved successfully!',
      );
    } catch (e) {
      SnackbarService().showError(
        title: 'Error',
        message: 'Failed to save settings: $e',
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _testNotification() async {
    await _notificationService.showLocalNotification(
      id: 9999,
      title: 'Test Notification',
      body: 'This is a test notification to verify your settings are working correctly.',
      payload: 'test_notification',
    );
  }

  Future<void> _selectReminderTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        DateTime.parse('2023-01-01 ${_reminderTime.value}:00'),
      ),
    );
    
    if (time != null) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      _reminderTime.value = '$hour:$minute';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        actions: [
          Obx(() => _isLoading.value
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : TextButton(
                  onPressed: _saveSettings,
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
        ],
      ),
      body: Obx(() {
        if (_isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // General Settings
              _buildSectionHeader('General Settings'),
              const SizedBox(height: 16),
              
              _buildSwitchTile(
                title: 'Task Reminders',
                subtitle: 'Get reminded about upcoming task deadlines',
                value: _taskReminders.value,
                onChanged: (value) => _taskReminders.value = value,
                icon: Icons.task_alt,
              ),
              
              _buildSwitchTile(
                title: 'Report Reminders',
                subtitle: 'Get reminded to submit daily reports',
                value: _reportReminders.value,
                onChanged: (value) => _reportReminders.value = value,
                icon: Icons.assignment,
              ),
              
              _buildSwitchTile(
                title: 'Deadline Alerts',
                subtitle: 'Get alerts when task deadlines are approaching',
                value: _deadlineAlerts.value,
                onChanged: (value) => _deadlineAlerts.value = value,
                icon: Icons.schedule,
              ),
              
              const SizedBox(height: 24),
              
              // Social Settings
              _buildSectionHeader('Social Notifications'),
              const SizedBox(height: 16),
              
              _buildSwitchTile(
                title: 'Task Assignments',
                subtitle: 'Get notified when tasks are assigned to you',
                value: _assignmentNotifications.value,
                onChanged: (value) => _assignmentNotifications.value = value,
                icon: Icons.person_add,
              ),
              
              _buildSwitchTile(
                title: 'Completion Celebrations',
                subtitle: 'Get celebration notifications when completing tasks',
                value: _completionCelebrations.value,
                onChanged: (value) => _completionCelebrations.value = value,
                icon: Icons.celebration,
              ),
              
              _buildSwitchTile(
                title: 'Streak Notifications',
                subtitle: 'Get notified about task completion streaks',
                value: _streakNotifications.value,
                onChanged: (value) => _streakNotifications.value = value,
                icon: Icons.local_fire_department,
              ),
              
              _buildSwitchTile(
                title: 'Department Summaries',
                subtitle: 'Get department-wide report summaries',
                value: _departmentSummaries.value,
                onChanged: (value) => _departmentSummaries.value = value,
                icon: Icons.business,
              ),
              
              const SizedBox(height: 24),
              
              // Timing Settings
              _buildSectionHeader('Timing Settings'),
              const SizedBox(height: 16),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Daily Reminder Time',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose when you want to receive daily reminders',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: _selectReminderTime,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.outline),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Reminder Time: ',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Obx(() => Text(
                              _reminderTime.value,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            )),
                            const Spacer(),
                            Icon(
                              Icons.edit,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Test Section
              _buildSectionHeader('Test Notifications'),
              const SizedBox(height: 16),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications_active,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Test Your Settings',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Send a test notification to verify your settings are working correctly',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TDButton(
                      text: 'Send Test Notification',
                      onPressed: _testNotification,
                      variant: TDButtonVariant.outlined,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: TDButton(
                  text: 'Save Settings',
                  onPressed: _saveSettings,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: SwitchListTile(
        title: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.onSurface.withOpacity(0.7),
            ),
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
