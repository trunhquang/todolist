import 'package:get/get.dart';
import 'package:todolist/core/services/firebase_database_service_enhanced.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/notifications/domain/entities/notification.dart';
import 'package:todolist/core/services/invitation_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class NotificationController extends GetxController {
  final FirebaseDatabaseServiceEnhanced _databaseService = Get.find();
  final InvitationService _invitationService = InvitationService(
    firebaseAuth: firebase_auth.FirebaseAuth.instance,
    databaseService: Get.find(),
  );

  final RxList<NotificationEntity> _notifications = <NotificationEntity>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  List<NotificationEntity> get notifications => _notifications;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    _loadNotifications();
  }

  /// Load notifications for current user
  Future<void> _loadNotifications() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // Get notifications from database
      final notificationData = await _databaseService.getNotifications(currentUser.uid);
      
      // Convert to NotificationEntity objects
      final notifications = notificationData.map((data) => NotificationEntity.fromMap(data)).toList();
      _notifications.value = notifications;
      
    } catch (e) {
      _errorMessage.value = 'Failed to load notifications: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Accept workspace invitation
  Future<void> acceptInvitation(String invitationId) async {
    try {
      _isLoading.value = true;
      
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: 'User not authenticated',
        );
        return;
      }

      final result = await _invitationService.acceptInvitation(
        invitationId: invitationId,
        userId: currentUser.uid,
      );

      result.fold(
        (failure) {
          SnackbarService().showError(
            title: AppStrings.error,
            message: failure.message,
          );
        },
        (member) {
          SnackbarService().showSuccess(
            title: AppStrings.success,
            message: AppStrings.invitationAccepted,
          );
          
          // Remove notification from list
          _notifications.removeWhere((n) => 
            n.type == 'workspace_invitation' && 
            n.data['invitationId'] == invitationId
          );
        },
      );
    } catch (e) {
      SnackbarService().showError(
        title: AppStrings.error,
        message: 'Failed to accept invitation: $e',
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Decline workspace invitation
  Future<void> declineInvitation(String invitationId) async {
    try {
      _isLoading.value = true;
      
      // TODO: Implement decline invitation logic
      // This should update invitation status to 'declined'
      
      SnackbarService().showSuccess(
        title: AppStrings.success,
        message: AppStrings.invitationDeclined,
      );
      
      // Remove notification from list
      _notifications.removeWhere((n) => 
        n.type == 'workspace_invitation' && 
        n.data['invitationId'] == invitationId
      );
      
    } catch (e) {
      SnackbarService().showError(
        title: AppStrings.error,
        message: 'Failed to decline invitation: $e',
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      // TODO: Implement markAsRead method in FirebaseDatabaseServiceEnhanced
      // await _databaseService.markNotificationAsRead(notificationId);
      
      // Update local list
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index >= 0) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    } catch (e) {
      SnackbarService().showError(
        title: AppStrings.error,
        message: 'Failed to mark notification as read: $e',
      );
    }
  }

  /// Refresh notifications
  Future<void> refreshNotifications() async {
    await _loadNotifications();
  }
}
