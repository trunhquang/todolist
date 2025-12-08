import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../features/invitations/domain/entities/invitation.dart';
import '../../../../features/workspace/domain/entities/workspace_member.dart';
import '../controllers/user_management_controller.dart';
import 'dialogs/edit_role_dialog.dart';
import 'dialogs/invite_user_dialog.dart';
import 'dialogs/remove_user_dialog.dart';

Future<void> handleInvitationAction({
  required String action,
  required Invitation invitation,
  required UserManagementController controller,
}) async {
  if (action == 'revoke') {
    await controller.revokeInvitation(invitation.id);
    await controller.refreshData();
  }
}

Future<void> showInviteUserDialog({
  required BuildContext context,
  required UserManagementController controller,
}) {
  return NavigationService().showDialog<void>(
    child: InviteUserDialog(
      controller: controller,
      onSubmit: () async =>
          _handleSendInvitation(context: context, controller: controller),
    ),
  );
}

Future<void> handleMemberAction({
  required BuildContext context,
  required String action,
  required WorkspaceMember member,
  required UserManagementController controller,
}) async {
  if (member.isAccountHolder) {
    SnackbarService().showInfo(
      title: AppStrings.info,
      message: AppStrings.cannotModifyAdminPermissions,
    );
    return;
  }

  switch (action) {
    case 'edit_role':
      await showEditRoleDialog(
        context: context,
        member: member,
        controller: controller,
      );
      break;
    case 'remove':
      await showRemoveUserDialog(
        context: context,
        member: member,
        controller: controller,
      );
      break;
    default:
      break;
  }
}

Future<void> _handleSendInvitation({
  required BuildContext context,
  required UserManagementController controller,
}) async {
  if (!controller.inviteFormKey.currentState!.validate()) return;

  try {
    await controller.inviteUserToWorkspace();
    NavigationService().back<void>();
    controller.inviteEmailController.clear();
    controller.inviteNameController.clear();
    await controller.refreshData();
    SnackbarService().showSuccess(
      title: AppStrings.success,
      message: AppStrings.invitationSent,
    );
  } catch (e) {
    SnackbarService().showError(
      title: AppStrings.error,
      message: '${AppStrings.failedToSendInvitation}: $e',
    );
  }
}
