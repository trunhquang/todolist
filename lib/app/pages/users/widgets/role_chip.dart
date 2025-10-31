import 'package:flutter/material.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';

class TDRoleChip extends StatelessWidget {
  final WorkspaceRole role;

  const TDRoleChip({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final display = role.displayName;
    final Color chipColor = switch (role) {
      WorkspaceRole.admin => Colors.blue,
      WorkspaceRole.member => Colors.green,
      _ => Colors.grey,
    };

    return Chip(
      label: Text(
        display.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: chipColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}


