import 'package:flutter/material.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/core/constants/app_spacing.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';

import '../../../../features/workspace/domain/entities/workspace_member.dart';

class ProjectAddMemberDialog extends StatefulWidget {
  const ProjectAddMemberDialog({
    super.key,
    required this.candidates,
    required this.onSubmit,
  });

  final List<WorkspaceMember> candidates;
  final Future<void> Function(WorkspaceMember user) onSubmit;

  @override
  State<ProjectAddMemberDialog> createState() => _ProjectAddMemberDialogState();
}

class _ProjectAddMemberDialogState extends State<ProjectAddMemberDialog> {
  WorkspaceMember? _selected;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.addMember),
      content: SizedBox(
        width: 420,
        child: DropdownButton<WorkspaceMember>(
          isExpanded: true,
          value: _selected,
          hint: const Text(AppStrings.selectAssignee),
          items: widget.candidates
              .map(
                (user) => DropdownMenuItem<WorkspaceMember>(
                  value: user,
                  child: Text(user.name),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selected = value;
            });
          },
        ),
      ),
      actionsPadding: const EdgeInsets.all(AppSpacing.sm),
      actions: [
        TDButton(
          text: AppStrings.cancel,
          variant: TDButtonVariant.text,
          height: 40,
          onPressed: () => NavigationService().back<void>(),
        ),
        TDButton(
          text: AppStrings.addMember,
          height: 40,
          onPressed: _selected == null
              ? null
              : () async {
                  await widget.onSubmit(_selected!);
                  NavigationService().back<void>();
                },
        ),
      ],
    );
  }
}
