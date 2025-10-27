import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/constants/app_spacing.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/features/invitations/domain/entities/invitation.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';
import 'package:todolist/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:todolist/core/services/firebase_database_service_enhanced.dart';
import 'package:todolist/core/services/invitation_notification_service.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/app/widgets/td_button.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Widget to show invitation notifications in the app
class TDInvitationNotificationWidget extends StatelessWidget {
  const TDInvitationNotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkspaceController>(
      builder: (controller) => Obx(() {
        return FutureBuilder<List<Invitation>>(
          future: _getPendingInvitations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            }
            
            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox.shrink();
            }
            
            final invitations = snapshot.data!;
            return _buildNotificationBanner(invitations.first);
          },
        );
      }),
    );
  }

  /// Get pending invitations for current user
  Future<List<Invitation>> _getPendingInvitations() async {
    return await InvitationNotificationService.instance.getPendingInvitationsForCurrentUser();
  }

  /// Get workspace name and inviter name for invitation
  Future<Map<String, String>> _getWorkspaceAndInviterNames(Invitation invitation) async {
    try {
      final workspaceRepository = Get.find<WorkspaceRepository>();
      final databaseService = Get.find<FirebaseDatabaseServiceEnhanced>();
      
      // Get workspace name
      String workspaceName = invitation.workspaceId;
      try {
        final workspaceResult = await workspaceRepository.getWorkspace(invitation.workspaceId);
        workspaceResult.fold(
          (failure) {
            // Use workspaceId as fallback
          },
          (workspace) {
            workspaceName = workspace.name;
          },
        );
      } catch (e) {
        // Use workspaceId as fallback
      }
      
      // Get inviter name
      String inviterName = 'Unknown User';
      try {
        final inviterData = await databaseService.getUser(invitation.invitedByUserId);
        if (inviterData != null) {
          inviterName = inviterData.name.isNotEmpty ? inviterData.name : inviterData.email;
        }
      } catch (e) {
        // Use 'Unknown User' as fallback
      }
      
      return {
        'workspaceName': workspaceName,
        'inviterName': inviterName,
      };
    } catch (e) {
      return {
        'workspaceName': invitation.workspaceId,
        'inviterName': 'Unknown User',
      };
    }
  }


  /// Build notification banner
  Widget _buildNotificationBanner(Invitation invitation) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.group_add,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  AppStrings.workspaceInvitation,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => _dismissNotification(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          FutureBuilder<Map<String, String>>(
            future: _getWorkspaceAndInviterNames(invitation),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                final workspaceName = data['workspaceName'] ?? invitation.workspaceId;
                final inviterName = data['inviterName'] ?? 'Unknown User';
                
                return RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    children: [
                      if (invitation.name != null && invitation.name!.isNotEmpty) ...[
                        TextSpan(text: '${AppStrings.youHaveBeenInvited} '),
                        TextSpan(
                          text: invitation.name!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' to '),
                      ] else
                        TextSpan(text: '${AppStrings.youHaveBeenInvited} '),
                      TextSpan(
                        text: workspaceName,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' ${AppStrings.byUser} '),
                      TextSpan(
                        text: inviterName,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              // Fallback to original text if data not available
              return Text(
                '${AppStrings.youHaveBeenInvited} ${invitation.workspaceId}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: TDButton(
                  text: AppStrings.declineInvitation,
                  onPressed: () => _declineInvitation(invitation),
                  variant: TDButtonVariant.outlined,
                  icon: Icons.close,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TDButton(
                  text: AppStrings.acceptInvitation,
                  onPressed: () => _acceptInvitation(invitation),
                  icon: Icons.check,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Accept invitation
  Future<void> _acceptInvitation(Invitation invitation) async {
    try {
      final workspaceRepository = Get.find<WorkspaceRepository>();
      final authController = Get.find<AuthController>();
      
      // Get current user ID
      final userId = authController.currentUser?.id;
      if (userId == null) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: 'User not authenticated',
        );
        return;
      }
      
      // Accept the invitation using the repository
      final result = await workspaceRepository.acceptInvitation(
        invitationId: invitation.id,
        userId: userId,
      );
      
      result.fold(
        (failure) {
          SnackbarService().showError(
            title: AppStrings.error,
            message: failure.message,
          );
        },
        (member) {
          // Show success message
          SnackbarService().showSuccess(
            title: AppStrings.success,
            message: AppStrings.invitationAcceptedMessage,
          );
          
          // Send notification to inviter
          _sendNotificationToInviter(
            invitation.invitedByUserId,
            invitation.workspaceId,
            AppStrings.invitationAcceptedNotification,
          );
        },
      );
      
    } catch (e) {
      SnackbarService().showError(
        title: AppStrings.error,
        message: e.toString(),
      );
    }
  }

  /// Decline invitation
  Future<void> _declineInvitation(Invitation invitation) async {
    try {
      final databaseService = Get.find<FirebaseDatabaseServiceEnhanced>();
      
      // Update invitation status to declined
      await databaseService.updateInvitationStatus(
        invitationId: invitation.id,
        status: 'declined',
      );
      
      // Show success message
      SnackbarService().showSuccess(
        title: AppStrings.success,
        message: AppStrings.invitationDeclinedMessage,
      );
      
      // Send notification to inviter
      await _sendNotificationToInviter(
        invitation.invitedByUserId,
        invitation.workspaceId,
        AppStrings.invitationDeclinedNotification,
      );
      
    } catch (e) {
      SnackbarService().showError(
        title: AppStrings.error,
        message: e.toString(),
      );
    }
  }

  /// Dismiss notification
  void _dismissNotification() {
    // This could be implemented to hide the notification temporarily
    // For now, we'll just do nothing
  }

  /// Send notification to inviter
  Future<void> _sendNotificationToInviter(
    String inviterUserId,
    String workspaceId,
    String message,
  ) async {
    try {
      final databaseService = Get.find<FirebaseDatabaseServiceEnhanced>();
      
      // Create notification for the inviter
      await databaseService.createNotification(
        userId: inviterUserId,
        type: 'invitation_response',
        title: 'Invitation Response',
        message: message,
        data: {
          'workspaceId': workspaceId,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (e) {
      // Don't show error to user for notification failure
      print('Error sending notification: $e');
    }
  }
}
