// ignore_for_file: unreachable_from_main - Executable app: this service exposes app-internal APIs used via runtime wiring; not a public package API
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  factory NotificationService() => _instance ??= NotificationService._();
  NotificationService._();

  static NotificationService? _instance;

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  FirebaseMessaging? _firebaseMessaging;
  
  FirebaseMessaging get firebaseMessaging => _firebaseMessaging ??= FirebaseMessaging.instance;

  // Initialize notification service
  Future<void> initialize() async {
    await _initializeLocalNotifications();
    await _initializeFirebaseMessaging();
  }

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsIOS =
        DarwinInitializationSettings();

    const initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  // Initialize Firebase messaging
  Future<void> _initializeFirebaseMessaging() async {
    try {
      // Request permission
      await _requestPermission();

      // Get FCM token
      final token = await firebaseMessaging.getToken();
      debugPrint('FCM Token: $token');

      // Listen to token refresh
      firebaseMessaging.onTokenRefresh.listen((token) async {
        // TODO: Send token to server (replace with real implementation)
        // await ApiService.instance.updateFcmToken(token);
      });

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((message) async {
        await _handleForegroundMessage(message);
      });

      // Handle notification tap when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        await _handleNotificationTap(message);
      });
    } on Exception {
      // Swallow errors but do not crash app
      // Continue without Firebase Messaging - local notifications will still work
    }
  }

  // Request notification permission
  Future<bool> _requestPermission() async {
    try {
      // Request local notification permission
      final localPermission = await Permission.notification.request();
      
      // Request FCM permission
      final fcmPermission = await firebaseMessaging.requestPermission();

      return localPermission.isGranted && fcmPermission.authorizationStatus == AuthorizationStatus.authorized;
    } on Exception catch (e) {
      debugPrint('Permission request failed: $e');
      // Return false if permission request fails
      return false;
    }
  }

  // Show local notification
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationDetails? notificationDetails,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'todo_channel',
      'Todo Notifications',
      channelDescription: 'Notifications for todo tasks and reports',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      notificationDetails ?? details,
      payload: payload,
    );
  }

  // Show scheduled notification
  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'todo_scheduled_channel',
      'Scheduled Todo Notifications',
      channelDescription: 'Scheduled notifications for todo tasks',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  // Cancel notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _localNotifications.pendingNotificationRequests();
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      // TODO: Handle notification tap based on payload
      debugPrint('Notification tapped with payload: $payload');
    }
  }

  // Handle foreground message
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    // Show local notification for foreground messages
    await showLocalNotification(
      id: message.hashCode,
      title: message.notification?.title ?? 'New Message',
      body: message.notification?.body ?? 'You have a new message',
      payload: message.data.toString(),
    );
  }

  // Handle notification tap
  Future<void> _handleNotificationTap(RemoteMessage message) async {
    // TODO: Navigate to specific screen based on message data
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await firebaseMessaging.subscribeToTopic(topic);
    } on Exception catch (e) {
      debugPrint('Failed to subscribe to topic $topic: $e');
    }
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await firebaseMessaging.unsubscribeFromTopic(topic);
    } on Exception catch (e) {
      debugPrint('Failed to unsubscribe from topic $topic: $e');
    }
  }

  // Get FCM token
  Future<String?> getFCMToken() async {
    try {
      return await firebaseMessaging.getToken();
    } on Exception catch (e) {
      debugPrint('Failed to get FCM token: $e');
      return null;
    }
  }

  // Task-specific notification methods
  Future<void> showTaskReminder({
    required String taskId,
    required String taskTitle,
    required DateTime reminderTime,
  }) async {
    await showScheduledNotification(
      id: taskId.hashCode,
      title: 'Task Reminder',
      body: "Don't forget: $taskTitle",
      scheduledDate: reminderTime,
      payload: 'task_reminder:$taskId',
    );
  }

  Future<void> showTaskDeadline({
    required String taskId,
    required String taskTitle,
    required DateTime deadline,
  }) async {
    await showScheduledNotification(
      id: taskId.hashCode,
      title: 'Task Deadline',
      body: 'Deadline approaching: $taskTitle',
      scheduledDate: deadline,
      payload: 'task_deadline:$taskId',
    );
  }

  Future<void> showTaskAssigned({
    required String taskId,
    required String taskTitle,
    required String assignerName,
  }) async {
    await showLocalNotification(
      id: taskId.hashCode,
      title: 'New Task Assigned',
      body: '$assignerName assigned you: $taskTitle',
      payload: 'task_assigned:$taskId',
    );
  }

  Future<void> showTaskCompleted({
    required String taskId,
    required String taskTitle,
    required String assigneeName,
  }) async {
    await showLocalNotification(
      id: taskId.hashCode,
      title: 'Task Completed',
      body: '$assigneeName completed: $taskTitle',
      payload: 'task_completed:$taskId',
    );
  }

  Future<void> showReportReminder({
    required String userId,
    required DateTime reminderTime,
  }) async {
    await showScheduledNotification(
      id: userId.hashCode,
      title: 'Daily Report Reminder',
      body: "Don't forget to submit your daily report",
      scheduledDate: reminderTime,
      payload: 'report_reminder:$userId',
    );
  }

  Future<void> showReportSubmitted({
    required String userId,
    required String userName,
  }) async {
    await showLocalNotification(
      id: userId.hashCode,
      title: 'Report Submitted',
      body: '$userName submitted their daily report',
      payload: 'report_submitted:$userId',
    );
  }

  // Cancel task-related notifications
  Future<void> cancelTaskNotifications(String taskId) async {
    await cancelNotification(taskId.hashCode);
  }

  // Cancel user-related notifications
  Future<void> cancelUserNotifications(String userId) async {
    await cancelNotification(userId.hashCode);
  }
}

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.messageId}');
  // TODO: Handle background message
}
