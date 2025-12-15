import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/navigation_service.dart';
import '../../widgets/td_app_bar.dart';
import 'controllers/user_management_controller.dart';
import 'widgets/user_management_actions.dart';
import 'widgets/user_management_body.dart';

/// Controller for User Management Page

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserManagementController>(
      init: UserManagementController(),
      builder: (controller) => Scaffold(
        appBar: TDAppBar(
          title: AppStrings.I.userManagement,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => NavigationService().back<void>(),
          ),
          actions: [
            Obx(() {
              if (controller.canManageUsers) {
                return IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () =>
                      showInviteUserDialog(context: context, controller: controller),
                  tooltip: AppStrings.I.inviteUser,
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
        body: UserManagementBody(controller: controller),
      ),
    );
  }
}
