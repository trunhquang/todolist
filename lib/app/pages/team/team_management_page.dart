import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/app/widgets/td_text_field.dart';

class TeamManagementPage extends StatelessWidget {
  TeamManagementPage({super.key});

  final WorkspaceController _controller = Get.find<WorkspaceController>();
  final TextEditingController _managerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.userManagement)),
      body: Obx(() {
        final members = _controller.workspaceMembers;
        if (members.isEmpty) {
          return Center(child: Text(AppStrings.noUsersFound));
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


