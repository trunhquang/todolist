import 'package:flutter/material.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/core/constants/app_spacing.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';

class ProjectAddMemberDialog extends StatefulWidget {
  const ProjectAddMemberDialog({
    super.key,
    required this.candidates,
    required this.onSubmit,
  });

  final List<User> candidates;
  final Future<void> Function(User user) onSubmit;

  @override
  State<ProjectAddMemberDialog> createState() => _ProjectAddMemberDialogState();
}

class _ProjectAddMemberDialogState extends State<ProjectAddMemberDialog> {
  User? _selected;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.addMember),
      content: SizedBox(
        width: 420,
        child: DropdownButton<User>(
          isExpanded: true,
          value: _selected,
          hint: const Text(AppStrings.selectAssignee),
          items: widget.candidates
              .map(
                (user) => DropdownMenuItem<User>(
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
