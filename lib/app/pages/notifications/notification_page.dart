import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/constants/app_spacing.dart';
import 'package:todolist/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:todolist/features/notifications/domain/entities/notification.dart';
import 'package:todolist/core/widgets/td_button.dart';
import 'package:todolist/core/widgets/td_loading_indicator.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.notifications),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Obx(() {
          if (controller.isLoading) {
            return const Center(child: TDLoadingIndicator());
          }

          if (controller.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    AppStrings.noNotifications,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshNotifications,
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                final notification = controller.notifications[index];
                return _buildNotificationCard(notification, controller);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationEntity notification, NotificationController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      elevation: notification.isRead ? 1 : 3,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getNotificationIcon(notification.type),
                  color: notification.isRead ? Colors.grey : Colors.blue,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                ),
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              notification.message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _formatDate(notification.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
            if (notification.type == 'workspace_invitation') ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TDButton(
                      text: AppStrings.accept,
                      onPressed: () => controller.acceptInvitation(
                        notification.data['invitationId'] as String,
                      ),
                      variant: TDButtonVariant.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TDButton(
                      text: AppStrings.decline,
                      onPressed: () => controller.declineInvitation(
                        notification.data['invitationId'] as String,
                      ),
                      variant: TDButtonVariant.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'workspace_invitation':
        return Icons.group_add;
      case 'task_assigned':
        return Icons.assignment;
      case 'task_completed':
        return Icons.check_circle;
      default:
        return Icons.notifications;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
