# Task SLA Overdue Notifications - Task List & Expected Results

## Overview
This document lists all tasks required to implement the **Task SLA Overdue Notifications** feature. Currently, this feature is **MISSING** - Not implemented; no SLA timers or notifications.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `NotificationService.showTaskDeadline()` method exists (but may not be used)
- ✅ `NotificationManagerService` exists (but has TODO comments for task reminders)
- ✅ `notification_settings_page.dart` has deadline alerts toggle (but may not be functional)
- ✅ Task cards show overdue indicator (but may not be accurate)
- ✅ `TaskEntity.deadline` field exists

### What's Missing:
- ⛔ No SLA timer service for periodic overdue checking
- ⛔ No automatic overdue detection
- ⛔ No overdue notification triggers
- ⛔ No approaching deadline notifications
- ⛔ No critical overdue notifications
- ⛔ No notification frequency control
- ⛔ No SLA settings configuration
- ⛔ No overdue statistics
- ⛔ No overdue list widget

---

## Task List

### Task 1: Create SLA Timer Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service that runs periodically to check for overdue tasks and trigger notifications.

**Files to Create**:
- `lib/core/services/sla_timer_service.dart` (new file)

**Implementation Steps**:
1. Create `SLATimerService`:
   ```dart
   class SLATimerService extends GetxService {
     Timer? _checkTimer;
     final TaskOverdueService _overdueService = Get.find<TaskOverdueService>();
     final NotificationService _notificationService = Get.find<NotificationService>();
     
     @override
     void onInit() {
       super.onInit();
       _startTimer();
     }
     
     void _startTimer() {
       // Run check every 5 minutes
       _checkTimer = Timer.periodic(
         Duration(minutes: 5),
         (_) => _checkOverdueTasks(),
       );
       
       // Also run immediately on startup
       _checkOverdueTasks();
     }
     
     Future<void> _checkOverdueTasks() async {
       try {
         final workspaceId = _getCurrentWorkspaceId();
         if (workspaceId == null) return;
         
         final overdueTasks = await _overdueService.getOverdueTasks(
           workspaceId: workspaceId,
         );
         
         for (final task in overdueTasks) {
           await _overdueService.handleOverdueTask(task);
         }
       } catch (e) {
         // Log error but don't throw
         print('SLA timer check failed: $e');
       }
     }
     
     @override
     void onClose() {
       _checkTimer?.cancel();
       super.onClose();
     }
   }
   ```

2. Initialize in `app.dart`:
   ```dart
   Get.put(SLATimerService());
   ```

3. Add app lifecycle handling:
   - Pause timer when app is backgrounded (optional)
   - Resume timer when app is resumed

**Expected Results**:
- ✅ SLA timer service exists
- ✅ Timer runs periodically (every 5 minutes)
- ✅ Timer checks for overdue tasks
- ✅ Timer handles errors gracefully

**Test Criteria**:
- Unit test: Test timer runs periodically
- Test: Test overdue detection
- Test: Test error handling

---

### Task 2: Create Task Overdue Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for detecting and handling overdue tasks.

**Files to Create**:
- `lib/core/services/task_overdue_service.dart` (new file)

**Implementation Steps**:
1. Create `TaskOverdueService`:
   ```dart
   class TaskOverdueService extends GetxService {
     final FirebaseDatabaseService _databaseService = Get.find<FirebaseDatabaseService>();
     final NotificationService _notificationService = Get.find<NotificationService>();
     final StorageService _storageService = Get.find<StorageService>();
     
     /// Get all overdue tasks for workspace
     Future<List<TaskEntity>> getOverdueTasks({
       required String workspaceId,
     }) async {
       final allTasks = await _databaseService.listTasks(workspaceId: workspaceId);
       final now = DateTime.now();
       
       return allTasks.where((task) {
         // Must have deadline
         if (!task.hasDeadline || task.deadline == null) return false;
         
         // Must not be completed or cancelled
         if (task.status == 'completed' || task.status == 'cancelled') return false;
         
         // Deadline must have passed
         return now.isAfter(task.deadline!);
       }).toList();
     }
     
     /// Handle overdue task (check if notification should be sent)
     Future<void> handleOverdueTask(TaskEntity task) async {
       // Check if notification was already sent for this overdue period
       final lastNotificationTime = _getLastNotificationTime(task.id);
       final now = DateTime.now();
       
       // Send notification if:
       // 1. Never sent before, OR
       // 2. Last sent more than 24 hours ago (daily notification)
       if (lastNotificationTime == null || 
           now.difference(lastNotificationTime).inHours >= 24) {
         await _sendOverdueNotification(task);
         await _saveLastNotificationTime(task.id, now);
       }
     }
     
     /// Send overdue notification
     Future<void> _sendOverdueNotification(TaskEntity task) async {
       final overdueDuration = DateTime.now().difference(task.deadline!);
       final daysOverdue = overdueDuration.inDays;
       
       await _notificationService.showTaskOverdue(
         taskId: task.id,
         taskTitle: task.title,
         daysOverdue: daysOverdue,
         assigneeId: task.assignee,
         assignerId: task.assigner,
       );
     }
     
     /// Check if task is critically overdue
     bool isCriticallyOverdue(TaskEntity task, {int criticalThresholdHours = 24}) {
       if (task.deadline == null) return false;
       final overdueDuration = DateTime.now().difference(task.deadline!);
       return overdueDuration.inHours >= criticalThresholdHours;
     }
   }
   ```

2. Add helper methods for notification tracking:
   ```dart
   DateTime? _getLastNotificationTime(String taskId) {
     final timestamp = _storageService.getUserData<int>('overdue_notification_$taskId');
     return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
   }
   
   Future<void> _saveLastNotificationTime(String taskId, DateTime time) async {
     await _storageService.setUserData(
       'overdue_notification_$taskId',
       time.millisecondsSinceEpoch,
     );
   }
   ```

**Expected Results**:
- ✅ Overdue service exists
- ✅ Can detect overdue tasks
- ✅ Can handle overdue tasks
- ✅ Notification frequency is controlled

**Test Criteria**:
- Unit test: Test overdue detection
- Unit test: Test notification frequency control
- Integration test: Test with real tasks

---

### Task 3: Add Overdue Notification Methods to NotificationService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add methods to `NotificationService` for overdue notifications.

**Files to Modify**:
- `lib/core/services/notification_service.dart`

**Implementation Steps**:
1. Add overdue notification methods:
   ```dart
   /// Show task overdue notification
   Future<void> showTaskOverdue({
     required String taskId,
     required String taskTitle,
     required int daysOverdue,
     String? assigneeId,
     String? assignerId,
   }) async {
     final title = daysOverdue > 1 
         ? 'Task Overdue: $daysOverdue days'
         : 'Task Overdue: 1 day';
     
     final body = '$taskTitle is overdue';
     
     await showLocalNotification(
       id: taskId.hashCode + 5000, // Different ID to avoid conflicts
       title: title,
       body: body,
       payload: 'task_overdue:$taskId',
     );
     
     // Also notify assigner if different from assignee
     if (assignerId != null && assignerId != assigneeId) {
       await showLocalNotification(
         id: '${taskId}_assigner'.hashCode + 5000,
         title: title,
         body: 'Task assigned by you is overdue: $taskTitle',
         payload: 'task_overdue:$taskId',
       );
     }
   }
   
   /// Show critical overdue notification
   Future<void> showTaskCriticallyOverdue({
     required String taskId,
     required String taskTitle,
     required int daysOverdue,
     String? assigneeId,
     String? assignerId,
   }) async {
     await showLocalNotification(
       id: taskId.hashCode + 6000,
       title: '🚨 Critical: Task Overdue',
       body: '$taskTitle is $daysOverdue days overdue',
       payload: 'task_overdue:$taskId',
       // Higher priority for critical
     );
   }
   
   /// Show approaching deadline notification
   Future<void> showTaskApproachingDeadline({
     required String taskId,
     required String taskTitle,
     required DateTime deadline,
     String? assigneeId,
   }) async {
     final timeRemaining = deadline.difference(DateTime.now());
     final hoursRemaining = timeRemaining.inHours;
     
     await showScheduledNotification(
       id: taskId.hashCode + 7000,
       title: 'Deadline Approaching',
       body: '$taskTitle deadline in $hoursRemaining hours',
       scheduledDate: deadline.subtract(Duration(hours: 1)), // 1 hour before
       payload: 'task_deadline:$taskId',
     );
   }
   ```

2. Use AppStrings for notification text (if available)

**Expected Results**:
- ✅ Overdue notification methods exist
- ✅ Critical overdue notification exists
- ✅ Approaching deadline notification exists
- ✅ Notifications are clear and helpful

**Test Criteria**:
- Test: Notifications are sent correctly
- Test: Notification content is accurate

---

### Task 4: Create SLA Settings Model and Service

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create model and service for managing SLA notification settings.

**Files to Create**:
- `lib/core/models/sla_settings.dart` (new file)
- `lib/core/services/sla_settings_service.dart` (new file)

**Implementation Steps**:
1. Create `SLASettings` model:
   ```dart
   class SLASettings {
     final bool enableOverdueNotifications;
     final bool enableApproachingDeadlineNotifications;
     final int approachingDeadlineThresholdHours; // e.g., 1, 24
     final int criticalOverdueThresholdHours; // e.g., 24, 48
     final NotificationFrequency notificationFrequency; // once, daily, hourly
     
     const SLASettings({
       this.enableOverdueNotifications = true,
       this.enableApproachingDeadlineNotifications = true,
       this.approachingDeadlineThresholdHours = 24,
       this.criticalOverdueThresholdHours = 24,
       this.notificationFrequency = NotificationFrequency.daily,
     });
     
     factory SLASettings.fromMap(Map<String, dynamic> map) {
       return SLASettings(
         enableOverdueNotifications: map['enableOverdueNotifications'] ?? true,
         enableApproachingDeadlineNotifications: map['enableApproachingDeadlineNotifications'] ?? true,
         approachingDeadlineThresholdHours: map['approachingDeadlineThresholdHours'] ?? 24,
         criticalOverdueThresholdHours: map['criticalOverdueThresholdHours'] ?? 24,
         notificationFrequency: NotificationFrequency.fromString(
           map['notificationFrequency'] ?? 'daily',
         ),
       );
     }
     
     Map<String, dynamic> toMap() {
       return {
         'enableOverdueNotifications': enableOverdueNotifications,
         'enableApproachingDeadlineNotifications': enableApproachingDeadlineNotifications,
         'approachingDeadlineThresholdHours': approachingDeadlineThresholdHours,
         'criticalOverdueThresholdHours': criticalOverdueThresholdHours,
         'notificationFrequency': notificationFrequency.value,
       };
     }
   }
   
   enum NotificationFrequency {
     once('once'),
     daily('daily'),
     hourly('hourly');
     
     const NotificationFrequency(this.value);
     final String value;
     
     static NotificationFrequency fromString(String value) {
       return NotificationFrequency.values.firstWhere(
         (freq) => freq.value == value,
         orElse: () => NotificationFrequency.daily,
       );
     }
   }
   ```

2. Create `SLASettingsService`:
   ```dart
   class SLASettingsService extends GetxService {
     final StorageService _storageService = Get.find<StorageService>();
     final Rx<SLASettings> _settings = SLASettings().obs;
     
     SLASettings get settings => _settings.value;
     
     @override
     void onInit() {
       super.onInit();
       _loadSettings();
     }
     
     Future<void> _loadSettings() async {
       final settingsData = _storageService.getUserData<Map<String, dynamic>>('sla_settings');
       if (settingsData != null) {
         _settings.value = SLASettings.fromMap(settingsData);
       }
     }
     
     Future<void> updateSettings(SLASettings newSettings) async {
       _settings.value = newSettings;
       await _storageService.setUserData('sla_settings', newSettings.toMap());
     }
   }
   ```

**Expected Results**:
- ✅ SLA settings model exists
- ✅ SLA settings service exists
- ✅ Settings can be loaded and saved
- ✅ Settings are per-user or per-workspace

**Test Criteria**:
- Unit test: Test settings model
- Unit test: Test settings service
- Test: Settings are persisted

---

### Task 5: Create SLA Settings UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI for configuring SLA notification settings.

**Files to Create/Modify**:
- `lib/app/pages/settings/sla_settings_page.dart` (new file, OR add to existing settings page)
- `lib/app/pages/settings/notification_settings_page.dart` (modify - enhance existing)

**Implementation Steps**:
1. Create SLA settings page:
   ```dart
   class SLASettingsPage extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       final controller = Get.find<SLASettingsService>();
       
       return Scaffold(
         appBar: AppBar(title: Text(AppStrings.slaSettings)),
         body: GetBuilder<SLASettingsService>(
           builder: (service) {
             final settings = service.settings;
             return ListView(
               padding: EdgeInsets.all(AppSpacing.md),
               children: [
                 // Overdue notifications toggle
                 SwitchListTile(
                   title: Text(AppStrings.enableOverdueNotifications),
                   subtitle: Text(AppStrings.overdueNotificationsDescription),
                   value: settings.enableOverdueNotifications,
                   onChanged: (value) {
                     service.updateSettings(
                       settings.copyWith(enableOverdueNotifications: value),
                     );
                   },
                 ),
                 
                 // Approaching deadline notifications toggle
                 SwitchListTile(
                   title: Text(AppStrings.enableApproachingDeadlineNotifications),
                   subtitle: Text(AppStrings.approachingDeadlineNotificationsDescription),
                   value: settings.enableApproachingDeadlineNotifications,
                   onChanged: (value) {
                     service.updateSettings(
                       settings.copyWith(enableApproachingDeadlineNotifications: value),
                     );
                   },
                 ),
                 
                 // Approaching deadline threshold
                 ListTile(
                   title: Text(AppStrings.approachingDeadlineThreshold),
                   subtitle: Text('${settings.approachingDeadlineThresholdHours} hours'),
                   trailing: DropdownButton<int>(
                     value: settings.approachingDeadlineThresholdHours,
                     items: [1, 6, 12, 24, 48].map((hours) {
                       return DropdownMenuItem(
                         value: hours,
                         child: Text('$hours hours'),
                       );
                     }).toList(),
                     onChanged: (value) {
                       if (value != null) {
                         service.updateSettings(
                           settings.copyWith(approachingDeadlineThresholdHours: value),
                         );
                       }
                     },
                   ),
                 ),
                 
                 // Critical overdue threshold
                 ListTile(
                   title: Text(AppStrings.criticalOverdueThreshold),
                   subtitle: Text('${settings.criticalOverdueThresholdHours} hours'),
                   trailing: DropdownButton<int>(
                     value: settings.criticalOverdueThresholdHours,
                     items: [12, 24, 48, 72].map((hours) {
                       return DropdownMenuItem(
                         value: hours,
                         child: Text('$hours hours'),
                       );
                     }).toList(),
                     onChanged: (value) {
                       if (value != null) {
                         service.updateSettings(
                           settings.copyWith(criticalOverdueThresholdHours: value),
                         );
                       }
                     },
                   ),
                 ),
                 
                 // Notification frequency
                 ListTile(
                   title: Text(AppStrings.notificationFrequency),
                   subtitle: Text(settings.notificationFrequency.displayText),
                   trailing: DropdownButton<NotificationFrequency>(
                     value: settings.notificationFrequency,
                     items: NotificationFrequency.values.map((freq) {
                       return DropdownMenuItem(
                         value: freq,
                         child: Text(freq.displayText),
                       );
                     }).toList(),
                     onChanged: (value) {
                       if (value != null) {
                         service.updateSettings(
                           settings.copyWith(notificationFrequency: value),
                         );
                       }
                     },
                   ),
                 ),
               ],
             );
           },
         ),
       );
     }
   }
   ```

2. Use TD widgets and AppStrings

3. Add route:
   ```dart
   GetPage(
     name: AppRoutes.slaSettings,
     page: () => SLASettingsPage(),
   ),
   ```

**Expected Results**:
- ✅ SLA settings page exists
- ✅ All settings can be configured
- ✅ Settings are saved
- ✅ UI follows project rules

**Test Criteria**:
- Test: Settings can be configured
- Test: Settings are saved
- Test: Settings are applied

---

### Task 6: Integrate SLA Settings with Overdue Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Integrate SLA settings with overdue detection and notification logic.

**Files to Modify**:
- `lib/core/services/task_overdue_service.dart`

**Implementation Steps**:
1. Inject `SLASettingsService`:
   ```dart
   class TaskOverdueService extends GetxService {
     final SLASettingsService _settingsService = Get.find<SLASettingsService>();
     
     Future<void> handleOverdueTask(TaskEntity task) async {
       final settings = _settingsService.settings;
       
       // Check if overdue notifications are enabled
       if (!settings.enableOverdueNotifications) return;
       
       // Check notification frequency
       final lastNotificationTime = _getLastNotificationTime(task.id);
       final now = DateTime.now();
       
       bool shouldSend = false;
       switch (settings.notificationFrequency) {
         case NotificationFrequency.once:
           shouldSend = lastNotificationTime == null;
           break;
         case NotificationFrequency.daily:
           shouldSend = lastNotificationTime == null || 
                       now.difference(lastNotificationTime).inHours >= 24;
           break;
         case NotificationFrequency.hourly:
           shouldSend = lastNotificationTime == null || 
                       now.difference(lastNotificationTime).inHours >= 1;
           break;
       }
       
       if (shouldSend) {
         // Check if critically overdue
         if (_isCriticallyOverdue(task, settings.criticalOverdueThresholdHours)) {
           await _sendCriticalOverdueNotification(task);
         } else {
           await _sendOverdueNotification(task);
         }
         await _saveLastNotificationTime(task.id, now);
       }
     }
   }
   ```

2. Add approaching deadline check:
   ```dart
   Future<void> checkApproachingDeadlines({
     required String workspaceId,
   }) async {
     final settings = _settingsService.settings;
     if (!settings.enableApproachingDeadlineNotifications) return;
     
     final tasks = await _databaseService.listTasks(workspaceId: workspaceId);
     final threshold = Duration(hours: settings.approachingDeadlineThresholdHours);
     final now = DateTime.now();
     
     for (final task in tasks) {
       if (task.deadline == null || 
           task.status == 'completed' || 
           task.status == 'cancelled') continue;
       
       final timeUntilDeadline = task.deadline!.difference(now);
       if (timeUntilDeadline <= threshold && timeUntilDeadline > Duration.zero) {
         // Check if notification was already sent
         final lastNotification = _getLastApproachingDeadlineNotification(task.id);
         if (lastNotification == null || 
             now.difference(lastNotification).inHours >= 24) {
           await _sendApproachingDeadlineNotification(task);
           await _saveLastApproachingDeadlineNotification(task.id, now);
         }
       }
     }
   }
   ```

**Expected Results**:
- ✅ Settings are integrated
- ✅ Notifications respect settings
- ✅ Frequency control works
- ✅ Thresholds are respected

**Test Criteria**:
- Test: Settings are respected
- Test: Frequency control works
- Test: Thresholds work

---

### Task 7: Add Overdue Indicator to Task Card

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Enhance task card to show accurate overdue indicator.

**Files to Modify**:
- `lib/features/tasks/presentation/widgets/task_card.dart`

**Implementation Steps**:
1. Update overdue indicator:
   ```dart
   Widget _buildDeadlineChip() {
     final deadline = task.deadline!;
     final now = DateTime.now();
     final isOverdue = deadline.isBefore(now) && 
                       task.status != 'completed' && 
                       task.status != 'cancelled';
     
     if (isOverdue) {
       final overdueDuration = now.difference(deadline);
       final daysOverdue = overdueDuration.inDays;
       final hoursOverdue = overdueDuration.inHours;
       
       String label;
       Color color;
       
       if (daysOverdue > 0) {
         label = daysOverdue == 1 
             ? AppStrings.oneDayOverdue 
             : AppStrings.daysOverdue(daysOverdue);
         color = daysOverdue > 3 ? AppColors.criticalOverdue : AppColors.overdue;
       } else {
         label = hoursOverdue == 1 
             ? AppStrings.oneHourOverdue 
             : AppStrings.hoursOverdue(hoursOverdue);
         color = AppColors.overdue;
       }
       
       return Chip(
         label: Text(label),
         backgroundColor: color,
         labelStyle: TextStyle(color: Colors.white),
       );
     }
     
     // Not overdue - show normal deadline
     // ...
   }
   ```

2. Use AppColors and AppStrings

**Expected Results**:
- ✅ Overdue indicator is accurate
- ✅ Shows overdue duration
- ✅ Uses correct colors
- ✅ UI follows project rules

**Test Criteria**:
- Test: Indicator is shown for overdue tasks
- Test: Indicator is not shown for completed tasks
- Test: Duration is accurate

---

### Task 8: Add Overdue Filter to Task List

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add filter option to show only overdue tasks.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/paginated_task_controller.dart`
- `lib/app/pages/tasks/task_list_page.dart`

**Implementation Steps**:
1. Add overdue filter to filter model:
   ```dart
   class TaskFilter {
     // ... existing filters ...
     bool? isOverdue;
   }
   ```

2. Update controller to apply filter:
   ```dart
   Future<void> loadTasks() async {
     // ... existing code ...
     
     // Apply overdue filter
     if (filter.isOverdue == true) {
       final now = DateTime.now();
       tasks = tasks.where((task) {
         if (!task.hasDeadline || task.deadline == null) return false;
         if (task.status == 'completed' || task.status == 'cancelled') return false;
         return now.isAfter(task.deadline!);
       }).toList();
     }
   }
   ```

3. Add filter UI:
   ```dart
   // In filter UI
   CheckboxListTile(
     title: Text(AppStrings.overdueTasks),
     value: _filter.isOverdue ?? false,
     onChanged: (v) => setState(() => _filter.isOverdue = v),
   ),
   ```

**Expected Results**:
- ✅ Overdue filter exists
- ✅ Filter works correctly
- ✅ Combined filters work

**Test Criteria**:
- Test: Filter shows only overdue tasks
- Test: Combined filters work

---

### Task 9: Create Overdue Tasks List Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create widget to display list of overdue tasks.

**Files to Create**:
- `lib/features/tasks/presentation/widgets/overdue_tasks_widget.dart` (new file)

**Implementation Steps**:
1. Create overdue tasks widget:
   ```dart
   class OverdueTasksWidget extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       final controller = Get.find<PaginatedTaskController>();
       
       return GetBuilder<PaginatedTaskController>(
         builder: (ctrl) {
           final overdueTasks = ctrl.getOverdueTasks();
           
           if (overdueTasks.isEmpty) {
             return TDCard(
               child: Text(AppStrings.noOverdueTasks),
             );
           }
           
           return TDCard(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(
                       AppStrings.overdueTasks,
                       style: AppTextStyles.heading,
                     ),
                     Chip(
                       label: Text('${overdueTasks.length}'),
                       backgroundColor: AppColors.overdue,
                     ),
                   ],
                 ),
                 SizedBox(height: AppSpacing.sm),
                 ...overdueTasks.map((task) => TaskCard(task: task)),
               ],
             ),
           );
         },
       );
     }
   }
   ```

2. Add to dashboard or task list page

3. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Overdue tasks widget exists
- ✅ Shows overdue tasks
- ✅ Updates in real-time
- ✅ UI follows project rules

**Test Criteria**:
- Test: Widget shows overdue tasks
- Test: Widget updates when tasks are completed
- Test: Widget is accurate

---

### Task 10: Add Overdue Statistics

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add overdue task statistics to dashboard/statistics page.

**Files to Create/Modify**:
- `lib/features/tasks/presentation/widgets/overdue_statistics_widget.dart` (new file)
- Statistics service/controller

**Implementation Steps**:
1. Create statistics widget:
   ```dart
   class OverdueStatisticsWidget extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       final controller = Get.find<TaskStatisticsController>();
       
       return GetBuilder<TaskStatisticsController>(
         builder: (ctrl) {
           final stats = ctrl.overdueStatistics;
           return TDCard(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(AppStrings.overdueStatistics, style: AppTextStyles.heading),
                 SizedBox(height: AppSpacing.sm),
                 Text('${AppStrings.totalOverdue}: ${stats.totalOverdue}'),
                 Text('${AppStrings.averageOverdueDuration}: ${stats.averageOverdueDuration} days'),
                 Text('${AppStrings.criticallyOverdue}: ${stats.criticallyOverdue}'),
               ],
             ),
           );
         },
       );
     }
   }
   ```

2. Add statistics calculation to service

**Expected Results**:
- ✅ Statistics widget exists
- ✅ Statistics are accurate
- ✅ Statistics update in real-time

**Test Criteria**:
- Test: Statistics are accurate
- Test: Statistics update correctly

---

### Task 11: Add Notification Payload Handling

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Handle notification payload to navigate to overdue task.

**Files to Modify**:
- `lib/core/services/notification_service.dart`
- Navigation handlers

**Implementation Steps**:
1. Add payload handler:
   ```dart
   void _handleNotificationTap(String payload) {
     if (payload.startsWith('task_overdue:')) {
       final taskId = payload.split(':')[1];
       NavigationService().toNamed<void>(
         AppRoutes.taskDetail,
         arguments: taskId,
       );
     }
   }
   ```

2. Integrate with notification tap handler

**Expected Results**:
- ✅ Notification navigation works
- ✅ User can navigate to overdue task
- ✅ Navigation is smooth

**Test Criteria**:
- Test: Notification navigation works
- Test: User can access overdue task

---

### Task 12: Add Unit Tests

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for SLA overdue notifications.

**Files to Create**:
- `test/core/services/sla_timer_service_test.dart`
- `test/core/services/task_overdue_service_test.dart`
- `test/core/services/sla_settings_service_test.dart`

**Implementation Steps**:
1. Test SLA timer service:
   - Test timer runs periodically
   - Test overdue detection
   - Test error handling

2. Test overdue service:
   - Test overdue detection
   - Test notification frequency control
   - Test critical overdue detection

3. Test settings service:
   - Test settings loading
   - Test settings saving
   - Test settings application

**Expected Results**:
- ✅ Unit tests cover SLA features
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Create SLA Timer Service (Critical - Foundation)
2. **Task 2**: Create Task Overdue Service (Critical - Core Logic)
3. **Task 3**: Add Overdue Notification Methods to NotificationService (High Priority - Notifications)
4. **Task 4**: Create SLA Settings Model and Service (High Priority - Configuration)
5. **Task 6**: Integrate SLA Settings with Overdue Service (High Priority - Integration)
6. **Task 5**: Create SLA Settings UI (Medium Priority - User Experience)
7. **Task 7**: Add Overdue Indicator to Task Card (Medium Priority - UI)
8. **Task 8**: Add Overdue Filter to Task List (Medium Priority - UI)
9. **Task 9**: Create Overdue Tasks List Widget (Medium Priority - UI)
10. **Task 11**: Add Notification Payload Handling (Medium Priority - User Experience)
11. **Task 10**: Add Overdue Statistics (Low Priority - UI Enhancement)
12. **Task 12**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ SLA timer service runs periodically
- ✅ Overdue tasks are automatically detected
- ✅ Overdue notifications are sent
- ✅ Approaching deadline notifications are sent
- ✅ Critical overdue notifications are sent
- ✅ Notification frequency is controlled
- ✅ SLA settings can be configured
- ✅ Overdue indicators are shown in UI
- ✅ Overdue filter works
- ✅ Overdue list widget exists
- ✅ Notification navigation works
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, SnackbarService, NavigationService)
- ✅ No known bugs or issues

---

## Dependencies

- **Firebase Realtime Database**: Required for fetching tasks
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NotificationService**: Must use existing notification service
- **StorageService**: Required for storing settings and notification timestamps

---

## Notes

1. **Timer Frequency**: Start with 5-minute intervals. Can be made configurable later.

2. **Notification Frequency**: Default to daily to avoid spam. Allow user to configure.

3. **Workspace Scoping**: Ensure all overdue detection is scoped to current workspace.

4. **Performance**: Consider caching overdue tasks to avoid repeated queries.

5. **Existing Components**: Some notification methods exist but may not be used. Need to integrate with new SLA system.

6. **Settings**: Settings can be per-user or per-workspace. Recommend per-user for flexibility.

---

## Related Documentation

- `TASKS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `TASK_SLA_OVERDUE_NOTIFICATIONS_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/tasks/tasks.md` - Task requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
