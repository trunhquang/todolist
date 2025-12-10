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
      title: const Text(AppStrings.removeUser),
      content: Text(
        '${AppStrings.removeUserConfirmation} ${member.displayName}?',
      ),
      actions: [
        TextButton(
          onPressed: () => NavigationService().back<void>(result: false),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () => NavigationService().back<void>(result: true),
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: const Text(AppStrings.remove),
        ),
      ],
    ),
  );

  if (confirmed ?? false) {
    try {
      await controller.removeUserFromWorkspace(member.userId);
      await controller.refreshData();
      SnackbarService().showSuccess(
        title: AppStrings.success,
        message: AppStrings.userRemoved,
      );
    } catch (e) {
      SnackbarService().showError(
        title: AppStrings.error,
        message: '${AppStrings.failedToRemoveUser}: $e',
      );
    }
  }
}

