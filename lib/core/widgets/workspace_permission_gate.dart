import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';

/// Shows [child] only if the current user has ANY of the [requiredPermissions]
/// in the current workspace. Otherwise shows [fallback] or nothing.
class WorkspacePermissionGate extends StatelessWidget {
  const WorkspacePermissionGate({
    super.key,
    required this.requiredPermissions,
    required this.child,
    this.fallback,
    this.hideIfNotAuthorized = true,
  });

  final List<String> requiredPermissions;
  final Widget child;
  final Widget? fallback;
  final bool hideIfNotAuthorized;

  @override
  Widget build(BuildContext context) {
    final WorkspaceController controller = Get.find<WorkspaceController>();
    return FutureBuilder<bool>(
      future: _hasAny(controller),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }
        final bool allowed = snapshot.data ?? false;
        if (allowed) return child;
        if (hideIfNotAuthorized) return const SizedBox.shrink();
        return fallback ?? const SizedBox.shrink();
      },
    );
  }

  Future<bool> _hasAny(WorkspaceController controller) async {
    for (final String permission in requiredPermissions) {
      final bool ok = await controller.hasPermission(permission);
      if (ok) return true;
    }
    return false;
  }
}


