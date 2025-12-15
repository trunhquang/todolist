import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/services/navigation_service.dart';
import '../../../../../core/services/snackbar_service.dart';
import '../../../../../features/workspace/domain/entities/workspace_member.dart';
import '../../../../widgets/td_button.dart';
import '../../controllers/user_management_controller.dart';

Future<void> showEditRoleDialog({
  required BuildContext context,
  required WorkspaceMember member,
  required UserManagementController controller,
}) {
  var selectedRole = member.role.displayName;

  return NavigationService().showDialog<void>(
    child: StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title:  Text(AppStrings.I.editRole),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${AppStrings.I.user}: ${member.displayName}'),
            if (member.email.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                member.email,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration:  InputDecoration(
                labelText: AppStrings.I.selectRole,
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Admin',
                  child: Text('Admin'),
                ),
                DropdownMenuItem(
                  value: 'Member',
                  child: Text('Member'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedRole = value;
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => NavigationService().back<void>(),
            child:  Text(AppStrings.I.cancel),
          ),
          TDButton(
            text: AppStrings.I.save,
            onPressed: () => _handleUpdateUserRole(
              context: context,
              member: member,
              newRole: selectedRole,
              controller: controller,
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _handleUpdateUserRole({
  required BuildContext context,
  required WorkspaceMember member,
  required String newRole,
  required UserManagementController controller,
}) async {
  try {
    await controller.updateUserRole(member.userId, newRole);
    NavigationService().back<void>();
    await controller.refreshData();
    SnackbarService().showSuccess(
      title: AppStrings.I.success,
      message: AppStrings.I.userRoleUpdated,
    );
  } catch (e) {
    SnackbarService().showError(
      title: AppStrings.I.error,
      message: '${AppStrings.I.failedToUpdateRole}: $e',
    );
  }
}


