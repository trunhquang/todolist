import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/services/navigation_service.dart';
import '../../../../../core/widgets/td_text_field.dart';
import '../../../../widgets/td_button.dart';
import '../../controllers/user_management_controller.dart';

class InviteUserDialog extends StatelessWidget {
  const InviteUserDialog({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  final UserManagementController controller;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.inviteUser),
      content: Form(
        key: controller.inviteFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TDTextField(
              controller: controller.inviteNameController,
              labelText: AppStrings.fullName,
              hintText: AppStrings.enterFullName,
              prefixIcon: const Icon(Icons.person),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.pleaseEnterFullName;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TDTextField(
              controller: controller.inviteEmailController,
              labelText: AppStrings.emailAddress,
              hintText: AppStrings.enterEmailAddress,
              prefixIcon: const Icon(Icons.email),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.pleaseEnterEmail;
                }
                if (!GetUtils.isEmail(value)) {
                  return AppStrings.pleaseEnterValidEmail;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => NavigationService().back<void>(),
          child: const Text(AppStrings.cancel),
        ),
        TDButton(
          text: AppStrings.sendInvitation,
          onPressed: onSubmit,
        ),
      ],
    );
  }
}
