import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/constants/app_spacing.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/features/invitations/domain/entities/invitation.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';
import 'package:todolist/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:todolist/core/services/firebase_database_service.dart';
import 'package:todolist/core/services/invitation_notification_service.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/app/widgets/td_button.dart';

import '../../../../features/workspace/domain/entities/workspace_member.dart';
import '../../../../features/workspace/domain/entities/workspace_permissions.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Widget to show invitation notifications in the app
class TDInvitationNotificationWidget extends StatefulWidget {
  const TDInvitationNotificationWidget({super.key});

  @override
  State<TDInvitationNotificationWidget> createState() =>
      _TDInvitationNotificationWidgetState();
}

class _TDInvitationNotificationWidgetState
    extends State<TDInvitationNotificationWidget> {
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

            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
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
    return InvitationNotificationService.instance
        .getPendingInvitationsForCurrentUser();
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
                onPressed: _dismissNotification,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          RichText(
            text: TextSpan(
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              children: [
                const TextSpan(text: '${AppStrings.youHaveBeenInvited} '),
                TextSpan(
                  text: invitation.workspaceName,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: ' ${AppStrings.byUser} '),
                TextSpan(
                  text: invitation.inviterName,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
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
      final databaseService = Get.find<FirebaseDatabaseService>();

      // Update invitation status to declined
      await databaseService.updateInvitationStatus(
        invitationId: invitation.id,
        isAccepted: true,
        workspaceId: invitation.workspaceId,
      );
      final workspaceRepository = Get.find<WorkspaceRepository>();
      final authController = Get.find<AuthController>();

      // Get current user ID
      final userId = authController.currentUser?.id ?? '';
      final userName = (authController.currentUser?.name.isNotEmpty ?? false)
          ? authController.currentUser!.name
          : (authController.currentUser?.email ?? userId);
      final userEmail =
          (authController.currentUser?.email.isNotEmpty ?? false)
              ? authController.currentUser!.email
              : '$userId@unknown.com';

      final member = WorkspaceMember(
        userId: userId,
        workspaceId: invitation.workspaceId,
        role: WorkspaceRole.member,
        permissions: DefaultPermissionSets.defaultMemberPermissions,
        assignedBy: invitation.invitedByUserId,
        assignedAt: DateTime.now(),
        name: userName,
        email: userEmail,
      );
      await workspaceRepository.addMember(member);

      SnackbarService().showSuccess(
        title: AppStrings.success,
        message: AppStrings.invitationAcceptedMessage,
      );
      await Get.find<WorkspaceController>().loadUserWorkspaces();
      setState(() {});
      // Let parent handle data reload
      // TODO: Backend sendNotification
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
      final databaseService = Get.find<FirebaseDatabaseService>();

      // Update invitation status to declined
      await databaseService.updateInvitationStatus(
        invitationId: invitation.id,
        isAccepted: false,
        workspaceId: invitation.workspaceId,
      );

      // Show success message
      SnackbarService().showSuccess(
        title: AppStrings.success,
        message: AppStrings.invitationDeclinedMessage,
      );
      // Let parent handle data reload
      setState(() {});
      // TODO: Backend sendNotification
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
}
