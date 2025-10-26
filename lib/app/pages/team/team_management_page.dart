import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/app/widgets/td_text_field.dart';

class TeamManagementPage extends StatefulWidget {
  const TeamManagementPage({super.key});

  @override
  State<TeamManagementPage> createState() => _TeamManagementPageState();
}

class _TeamManagementPageState extends State<TeamManagementPage> {
  final WorkspaceController _controller = Get.find<WorkspaceController>();
  final TextEditingController _managerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  /// Check if user has permission to access team management
  Future<void> _checkPermissions() async {
    try {
      final canManageUsers = await _controller.hasPermission('manage_users');
      if (!canManageUsers) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: AppStrings.permissionDenied,
        );
        NavigationService().back<void>();
        return;
      }
    } catch (e) {
      SnackbarService().showError(
        title: AppStrings.error,
        message: AppStrings.permissionDenied,
      );
      NavigationService().back<void>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.userManagement)),
      body: Obx(() {
        final members = _controller.workspaceMembers;
        if (members.isEmpty) {
          return const Center(child: Text(AppStrings.noUsersFound));
        }
        return ListView.builder(
          itemCount: members.length,
          itemBuilder: (context, index) {
            final m = members[index];
            return ListTile(
              title: Text(m.userId),
              subtitle: Text('Manager: ${m.managerUserId ?? '-'}'),
              trailing: SizedBox(
                width: 240,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 140,
                      child: TDTextField(
                        controller: _managerController,
                        label: 'Manager User ID',
                        hint: 'Enter manager user id',
                      ),
                    ),
                    const SizedBox(width: 8),
                    TDButton(
                      text: AppStrings.save,
                      variant: TDButtonVariant.outlined,
                      onPressed: () async {
                        final managerId = _managerController.text.trim();
                        await _controller.setManager(
                          userId: m.userId,
                          managerUserId: managerId.isEmpty ? null : managerId,
                        );
                        _managerController.clear();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}


