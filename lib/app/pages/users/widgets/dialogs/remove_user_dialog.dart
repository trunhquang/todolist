import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/services/navigation_service.dart';
import '../../../../../core/services/snackbar_service.dart';
import '../../../../../features/workspace/domain/entities/workspace_member.dart';
import '../../controllers/user_management_controller.dart';

Future<void> showRemoveUserDialog({
  required BuildContext context,
  required WorkspaceMember member,
  required UserManagementController controller,
}) async {
  final confirmed = await NavigationService().showDialog<bool>(
    child: AlertDialog(
      title:  Text(AppStrings.I.removeUser),
      content: Text(
        '${AppStrings.I.removeUserConfirmation} ${member.displayName}?',
      ),
      actions: [
        TextButton(
          onPressed: () => NavigationService().back<void>(result: false),
          child:  Text(AppStrings.I.cancel),
        ),
        TextButton(
          onPressed: () => NavigationService().back<void>(result: true),
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child:  Text(AppStrings.I.remove),
        ),
      ],
    ),
  );

  if (confirmed ?? false) {
    try {
      await controller.removeUserFromWorkspace(member.userId);
      await controller.refreshData();
      SnackbarService().showSuccess(
        title: AppStrings.I.success,
        message: AppStrings.I.userRemoved,
      );
    } catch (e) {
      SnackbarService().showError(
        title: AppStrings.I.error,
        message: '${AppStrings.I.failedToRemoveUser}: $e',
      );
    }
  }
}


