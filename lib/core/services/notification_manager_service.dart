import 'package:get/get.dart';

import 'notification_service.dart';
import 'storage_service.dart';
import '../../features/tasks/domain/entities/task.dart';
import '../../features/reports/presentation/controllers/report_controller.dart';

class NotificationManagerService extends GetxService {
  NotificationManagerService({
    NotificationService? notificationService,
    StorageService? storageService,
    ReportController? reportController,
  })  : _notificationService = notificationService ?? Get.find<NotificationService>(),
        _storageService = storageService ?? Get.find<StorageService>(),
        _reportController = reportController ?? Get.find<ReportController>();

  final NotificationService _notificationService;
  final StorageService _storageService;
  final ReportController _reportController;

  // Initialize notification manager
  Future<void> initialize() async {
    await _setupTaskNotifications();
    await _setupReportNotifications();
  }

  // Setup task-related notifications
  Future<void> _setupTaskNotifications() async {
    // TODO: Listen to task changes when TaskController is available
    // _taskController.tasks.listen((tasks) {
    //   _scheduleTaskReminders(tasks);
    // });
  }

  // Setup report-related notifications
  Future<void> _setupReportNotifications() async {
    // Schedule daily report reminders
    await _scheduleDailyReportReminders();
  }

  // Schedule reminders for tasks with deadlines
  Future<void> _scheduleTaskReminders(List<TaskEntity> tasks) async {
    // TODO: Implement when TaskEntity is available
    // final tasksWithDeadlines = tasks.where((task) => 
    //   task.hasDeadline && 
    //   task.deadline != null && 
    //   task.status != TaskStatus.completed &&
    //   task.status != TaskStatus.cancelled
    // ).toList();

    // for (final task in tasksWithDeadlines) {
    //   await _scheduleTaskReminder(task);
    // }
  }

  // Schedule reminder for a specific task
  Future<void> _scheduleTaskReminder(TaskEntity task) async {
    // TODO: Implement when TaskEntity is available
    // if (task.deadline == null) return;

    // final reminderTime = task.deadline!.subtract(const Duration(hours: 1));
    
    // // Don't schedule reminders for past deadlines
    // if (reminderTime.isBefore(DateTime.now())) return;

    // switch (task.taskType) {
    //   case TaskType.daily:
    //     await _notificationService.showDailyTaskReminder(
    //       taskId: task.id,
    //       taskTitle: task.title,
    //       reminderTime: reminderTime,
    //     );
    //     break;
    //   case TaskType.weekly:
    //     await _notificationService.showWeeklyTaskReminder(
    //       taskId: task.id,
    //       taskTitle: task.title,
    //       reminderTime: reminderTime,
    //     );
    //     break;
    //   case TaskType.monthly:
    //     await _notificationService.showMonthlyTaskReminder(
    //       taskId: task.id,
    //       taskTitle: task.title,
    //       reminderTime: reminderTime,
    //     );
    //     break;
    //   case TaskType.project:
    //     // Get project name if available
    //     final projectName = await _getProjectName(task.projectId);
    //     await _notificationService.showProjectTaskReminder(
    //       taskId: task.id,
    //       taskTitle: task.title,
    //       projectName: projectName,
    //       reminderTime: reminderTime,
    //     );
    //     break;
    // }
  }

  // Get project name by ID
  Future<String> _getProjectName(String? projectId) async {
    if (projectId == null) return 'Project';
    
    try {
      // TODO: Implement project name lookup
      // For now, return a generic name
      return 'Project';
    } catch (e) {
      return 'Project';
    }
  }

  // Schedule daily report reminders
  Future<void> _scheduleDailyReportReminders() async {
    final userId = _storageService.getUserId();
    if (userId == null) return;

    // Schedule reminder for 5 PM daily
    final now = DateTime.now();
    final reminderTime = DateTime(now.year, now.month, now.day, 17); // 5 PM
    
    // If it's already past 5 PM today, schedule for tomorrow
    if (reminderTime.isBefore(now)) {
      final tomorrow = now.add(const Duration(days: 1));
      final tomorrowReminder = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 17);
      await _notificationService.showReportReminder(
        userId: userId,
        reminderTime: tomorrowReminder,
      );
    } else {
      await _notificationService.showReportReminder(
        userId: userId,
        reminderTime: reminderTime,
      );
    }
  }

  // Handle task completion
  Future<void> onTaskCompleted(TaskEntity task) async {
    // TODO: Implement when TaskEntity is available
    // // Show completion celebration
    // await _notificationService.showTaskCompletionCelebration(
    //   taskId: task.id,
    //   taskTitle: task.title,
    //   taskType: task.taskType.name,
    // );

    // // Cancel any pending reminders for this task
    // await _notificationService.cancelTaskReminders(task.id);

    // // Check for streaks
    // await _checkTaskStreak(task);
  }

  // Handle task assignment
  Future<void> onTaskAssigned(TaskEntity task, String assignerName) async {
    // TODO: Implement when TaskEntity is available
    // await _notificationService.showTaskAssigned(
    //   taskId: task.id,
    //   taskTitle: task.title,
    //   assignerName: assignerName,
    // );

    // // Schedule reminder if task has deadline
    // if (task.hasDeadline && task.deadline != null) {
    //   await _scheduleTaskReminder(task);
    // }
  }

  // Handle report submission
  Future<void> onReportSubmitted(String userId, String userName) async {
    await _notificationService.showReportSubmitted(
      userId: userId,
      userName: userName,
    );
  }

  // Check for task completion streaks
  Future<void> _checkTaskStreak(TaskEntity task) async {
    // TODO: Implement when TaskEntity is available
    // // TODO: Implement streak calculation logic
    // // For now, this is a placeholder
    // final userId = _storageService.getUserId();
    // if (userId == null) return;

    // // Example: Check if user has completed daily tasks for 3+ days in a row
    // if (task.taskType == TaskType.daily) {
    //   // Placeholder logic - in real implementation, you'd check actual completion history
    //   final streakDays = 3; // This would be calculated from actual data
      
    //   if (streakDays >= 3) {
    //     await _notificationService.showTaskStreak(
    //       userId: userId,
    //       streakDays: streakDays,
    //       taskType: task.taskType.name,
    //     );
    //   }
    // }
  }

  // Handle recurring task generation
  Future<void> onRecurringTaskGenerated(TaskEntity parentTask, TaskEntity newInstance) async {
    // TODO: Implement when TaskEntity is available
    // // Schedule reminder for the new recurring task instance
    // if (newInstance.hasDeadline && newInstance.deadline != null) {
    //   await _scheduleTaskReminder(newInstance);
    // }
  }

  // Handle project closure
  Future<void> onProjectClosed(String projectId) async {
    // TODO: Implement when TaskController is available
    // // Cancel all notifications for tasks in this project
    // final projectTasks = _taskController.tasks.where((task) => task.projectId == projectId);
    
    // for (final task in projectTasks) {
    //   await _notificationService.cancelTaskReminders(task.id);
    // }
  }

  // Handle task cancellation
  Future<void> onTaskCancelled(TaskEntity task) async {
    // TODO: Implement when TaskEntity is available
    // // Cancel all notifications for this task
    // await _notificationService.cancelTaskReminders(task.id);
  }

  // Handle task deadline update
  Future<void> onTaskDeadlineUpdated(TaskEntity task) async {
    // TODO: Implement when TaskEntity is available
    // // Cancel existing reminders
    // await _notificationService.cancelTaskReminders(task.id);
    
    // // Schedule new reminder if task has deadline
    // if (task.hasDeadline && task.deadline != null) {
    //   await _scheduleTaskReminder(task);
    // }
  }

  // Department manager notifications
  Future<void> notifyDepartmentReportSummary({
    required String departmentId,
    required String departmentName,
    required int submittedCount,
    required int totalCount,
  }) async {
    await _notificationService.showDepartmentReportSummary(
      departmentId: departmentId,
      departmentName: departmentName,
      submittedCount: submittedCount,
      totalCount: totalCount,
    );
  }

  // Report overdue notifications
  Future<void> notifyReportOverdue(String userId, String userName) async {
    await _notificationService.showReportOverdue(
      userId: userId,
      userName: userName,
    );
  }

  // Clean up notifications for completed/cancelled tasks
  Future<void> cleanupNotifications() async {
    // TODO: Implement when TaskController is available
    // final activeTasks = _taskController.tasks.where((task) => 
    //   task.status != TaskStatus.completed && 
    //   task.status != TaskStatus.cancelled
    // ).toList();

    // // Get all pending notifications
    // final pendingNotifications = await _notificationService.getPendingNotifications();
    
    // // Cancel notifications for tasks that are no longer active
    // for (final notification in pendingNotifications) {
    //   final payload = notification.payload;
    //   if (payload != null && payload.startsWith('task_')) {
    //     final taskId = payload.split(':')[1];
    //     final taskExists = activeTasks.any((task) => task.id == taskId);
        
    //     if (!taskExists) {
    //       await _notificationService.cancelNotification(notification.id);
    //     }
    //   }
    // }
  }

  // Refresh all notifications based on current task state
  Future<void> refreshAllNotifications() async {
    // TODO: Implement when TaskController is available
    // // Cancel all existing task notifications
    // final pendingNotifications = await _notificationService.getPendingNotifications();
    // for (final notification in pendingNotifications) {
    //   if (notification.payload?.startsWith('task_') == true) {
    //     await _notificationService.cancelNotification(notification.id);
    //   }
    // }

    // // Reschedule notifications for current tasks
    // await _scheduleTaskReminders(_taskController.tasks);
  }
}
