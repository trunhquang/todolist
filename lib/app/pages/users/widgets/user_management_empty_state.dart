import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../widgets/td_button.dart';
import '../controllers/user_management_controller.dart';
import 'user_management_actions.dart';

class UserManagementEmptyState extends StatelessWidget {
  const UserManagementEmptyState({super.key, required this.controller});

  final UserManagementController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.I.noUsersFound,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.I.inviteUsersToGetStarted,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Obx(() {
            if (controller.canManageUsers) {
              return TDButton(
                text: AppStrings.I.inviteUser,
                onPressed: () => showInviteUserDialog(
                  context: context,
                  controller: controller,
                ),
                icon: Icons.person_add,
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}


