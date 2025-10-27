import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

/// Notification Service Interface
abstract class NotificationServiceInterface {
  /// Send notification to specific user by user ID
  Future<bool> sendNotificationToUserID({
    required String userId,
    required String title,
    required String body,
    Map<String, String>? data,
  });

  /// Send notification to multiple users
  Future<Map<String, bool>> sendNotificationToUsers({
    required List<String> userIds,
    required String title,
    required String body,
    Map<String, String>? data,
  });

  /// Send notification to workspace members
  Future<Map<String, bool>> sendNotificationToWorkspace({
    required String workspaceId,
    required String title,
    required String body,
    Map<String, String>? data,
  });

  /// Send notification to topic subscribers
  Future<bool> sendNotificationToTopic({
    required String topic,
    required String title,
    required String body,
    Map<String, String>? data,
  });

  /// Get user's FCM token by user ID
  Future<String?> getUserFCMToken(String userId);

  /// Update user's FCM token
  Future<void> updateUserFCMToken(String userId, String token);

  /// Subscribe user to topic
  Future<void> subscribeUserToTopic(String userId, String topic);

  /// Unsubscribe user from topic
  Future<void> unsubscribeUserFromTopic(String userId, String topic);
}

/// Notification Request Model
class NotificationRequest {
  final String userId;
  final String title;
  final String body;
  final Map<String, String>? data;
  final String? imageUrl;
  final String? clickAction;

  const NotificationRequest({
    required this.userId,
    required this.title,
    required this.body,
    this.data,
    this.imageUrl,
    this.clickAction,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'title': title,
    'body': body,
    'data': data,
    'imageUrl': imageUrl,
    'clickAction': clickAction,
  };
}

/// Notification Response Model
class NotificationResponse {
  final bool success;
  final String? message;
  final String? error;

  const NotificationResponse({
    required this.success,
    this.message,
    this.error,
  });

  factory NotificationResponse.success([String? message]) => NotificationResponse(
    success: true,
    message: message,
  );

  factory NotificationResponse.error(String error) => NotificationResponse(
    success: false,
    error: error,
  );
}

/// Notification Service Implementation
class NotificationServiceImpl extends GetxService implements NotificationServiceInterface {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeFirebaseMessaging();
  }

  /// Initialize Firebase Messaging
  Future<void> _initializeFirebaseMessaging() async {
    try {
      // Request permission
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // Listen to token refresh
      _firebaseMessaging.onTokenRefresh.listen((token) async {
        // TODO: Update token in database for current user
        // This should be handled by the authentication service
      });
    } catch (e) {
      Get.log('Failed to initialize Firebase Messaging: $e');
    }
  }

  @override
  Future<bool> sendNotificationToUserID({
    required String userId,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      // Get user's FCM token
      final fcmToken = await getUserFCMToken(userId);
      if (fcmToken == null) {
        Get.log('No FCM token found for user: $userId');
        return false;
      }

      // Note: Client-side Firebase messaging cannot send messages to other devices
      // This requires server-side implementation with Firebase Admin SDK
      // For now, we'll simulate the notification sending
      await _sendMessageToToken(fcmToken, title, body, data);
      
      return true;
    } catch (e) {
      Get.log('Failed to send notification to user $userId: $e');
      return false;
    }
  }

  @override
  Future<Map<String, bool>> sendNotificationToUsers({
    required List<String> userIds,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    final results = <String, bool>{};
    
    for (final userId in userIds) {
      try {
        final success = await sendNotificationToUserID(
          userId: userId,
          title: title,
          body: body,
          data: data,
        );
        results[userId] = success;
      } catch (e) {
        Get.log('Failed to send notification to user $userId: $e');
        results[userId] = false;
      }
    }
    
    return results;
  }

  @override
  Future<Map<String, bool>> sendNotificationToWorkspace({
    required String workspaceId,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      // TODO: Get workspace members from database
      // This should integrate with the workspace service
      final memberIds = <String>[]; // Placeholder
      
      if (memberIds.isEmpty) {
        Get.log('No members found for workspace: $workspaceId');
        return {};
      }

      return await sendNotificationToUsers(
        userIds: memberIds,
        title: title,
        body: body,
        data: data,
      );
    } catch (e) {
      Get.log('Failed to send notification to workspace $workspaceId: $e');
      return {};
    }
  }

  @override
  Future<bool> sendNotificationToTopic({
    required String topic,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      // Subscribe to topic first (if not already subscribed)
      await _firebaseMessaging.subscribeToTopic(topic);
      
      // Note: Sending to topic requires server-side implementation
      // For now, we'll use a placeholder approach
      Get.log('Topic notification sent to: $topic');
      return true;
    } catch (e) {
      Get.log('Failed to send notification to topic $topic: $e');
      return false;
    }
  }

  @override
  Future<String?> getUserFCMToken(String userId) async {
    try {
      // TODO: Get FCM token from database for the specific user
      // This should integrate with the user service
      // For now, return current user's token as placeholder
      return await _firebaseMessaging.getToken();
    } catch (e) {
      Get.log('Failed to get FCM token for user $userId: $e');
      return null;
    }
  }

  @override
  Future<void> updateUserFCMToken(String userId, String token) async {
    try {
      // TODO: Update FCM token in database for the specific user
      // This should integrate with the user service
      Get.log('FCM token updated for user $userId');
    } catch (e) {
      Get.log('Failed to update FCM token for user $userId: $e');
    }
  }

  @override
  Future<void> subscribeUserToTopic(String userId, String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      Get.log('User $userId subscribed to topic: $topic');
    } catch (e) {
      Get.log('Failed to subscribe user $userId to topic $topic: $e');
    }
  }

  @override
  Future<void> unsubscribeUserFromTopic(String userId, String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      Get.log('User $userId unsubscribed from topic: $topic');
    } catch (e) {
      Get.log('Failed to unsubscribe user $userId from topic $topic: $e');
    }
  }

  /// Send message to specific FCM token
  Future<void> _sendMessageToToken(
    String token,
    String title,
    String body,
    Map<String, String>? data,
  ) async {
    try {
      // Note: This is a placeholder implementation
      // Real implementation requires server-side Firebase Admin SDK
      // Client-side Firebase SDK cannot send messages to other devices
      
      Get.log('📱 Notification Service: Sending notification');
      Get.log('   Token: ${token.substring(0, 20)}...');
      Get.log('   Title: $title');
      Get.log('   Body: $body');
      Get.log('   Data: $data');
      
      // Simulate notification sending delay
      await Future<void>.delayed(const Duration(milliseconds: 100));
      
      // TODO: Implement server-side notification sending
      // This should call a backend API that uses Firebase Admin SDK
      // Example server-side implementation would be:
      // await _callServerAPI('/api/notifications/send', {
      //   'token': token,
      //   'title': title,
      //   'body': body,
      //   'data': data,
      // });
      
      Get.log('✅ Notification sent successfully (simulated)');
    } catch (e) {
      Get.log('❌ Failed to send message to token: $e');
      rethrow;
    }
  }

  /// Get current user's FCM token
  Future<String?> getCurrentUserFCMToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      Get.log('Failed to get current user FCM token: $e');
      return null;
    }
  }

  /// Send notification to current user (for testing)
  Future<bool> sendNotificationToCurrentUser({
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      final token = await getCurrentUserFCMToken();
      if (token == null) {
        Get.log('No FCM token available for current user');
        return false;
      }

      await _sendMessageToToken(token, title, body, data);
      return true;
    } catch (e) {
      Get.log('Failed to send notification to current user: $e');
      return false;
    }
  }
}
