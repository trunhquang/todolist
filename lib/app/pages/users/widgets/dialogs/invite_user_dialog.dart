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
      title:  Text(AppStrings.I.inviteUser),
      content: Form(
        key: controller.inviteFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TDTextField(
              controller: controller.inviteNameController,
              labelText: AppStrings.I.fullName,
              hintText: AppStrings.I.enterFullName,
              prefixIcon: const Icon(Icons.person),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.I.pleaseEnterFullName;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TDTextField(
              controller: controller.inviteEmailController,
              labelText: AppStrings.I.emailAddress,
              hintText: AppStrings.I.enterEmailAddress,
              prefixIcon: const Icon(Icons.email),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.I.pleaseEnterEmail;
                }
                if (!GetUtils.isEmail(value)) {
                  return AppStrings.I.pleaseEnterValidEmail;
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
          child:  Text(AppStrings.I.cancel),
        ),
        TDButton(
          text: AppStrings.I.sendInvitation,
          onPressed: onSubmit,
        ),
      ],
    );
  }
}


