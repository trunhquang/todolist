import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/user_roles.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

/// Widget that shows content based on user role and permissions
class RoleBasedWidget extends StatelessWidget {
  const RoleBasedWidget({
    super.key,
    required this.child,
    this.requiredRole,
    this.requiredPermission,
    this.fallback,
    this.hideIfNotAuthorized = true,
  }) : assert(
          requiredRole != null || requiredPermission != null,
          'Either requiredRole or requiredPermission must be provided',
        );

  /// The required role to show the widget
  final String? requiredRole;
  
  /// The required permission to show the widget
  final String? requiredPermission;
  
  /// The child widget to show if conditions are met
  final Widget child;
  
  /// The fallback widget to show if conditions are not met
  final Widget? fallback;
  
  /// Whether to show nothing if conditions are not met
  final bool hideIfNotAuthorized;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final user = authController.currentUser;

    if (user == null) {
      return hideIfNotAuthorized ? const SizedBox.shrink() : (fallback ?? const SizedBox.shrink());
    }

    // Check role requirement
    if (requiredRole != null && user.role != requiredRole) {
      return hideIfNotAuthorized ? const SizedBox.shrink() : (fallback ?? const SizedBox.shrink());
    }

    // Check permission requirement
    if (requiredPermission != null && !authController.hasPermission(requiredPermission!)) {
      return hideIfNotAuthorized ? const SizedBox.shrink() : (fallback ?? const SizedBox.shrink());
    }

    return child;
  }
}

/// Widget that shows content only for admin users
class AdminOnlyWidget extends StatelessWidget {
  const AdminOnlyWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      requiredRole: UserRoles.admin,
      fallback: fallback,
      child: child,
    );
  }
}

/// Widget that shows content only for department managers and above
class DepartmentManagerOrAboveWidget extends StatelessWidget {
  const DepartmentManagerOrAboveWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      requiredPermission: UserRoles.manageDepartments,
      fallback: fallback,
      child: child,
    );
  }
}

/// Widget that shows content only for team leads and above
class TeamLeadOrAboveWidget extends StatelessWidget {
  const TeamLeadOrAboveWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      requiredPermission: UserRoles.assignTasks,
      fallback: fallback,
      child: child,
    );
  }
}

/// Widget that shows content only for users who can create tasks
class TaskCreatorWidget extends StatelessWidget {
  const TaskCreatorWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      requiredPermission: UserRoles.createTasks,
      fallback: fallback,
      child: child,
    );
  }
}

/// Widget that shows content only for users who can assign tasks
class TaskAssignerWidget extends StatelessWidget {
  const TaskAssignerWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      requiredPermission: UserRoles.assignTasks,
      fallback: fallback,
      child: child,
    );
  }
}

/// Widget that shows content only for users who can delete tasks
class TaskDeleterWidget extends StatelessWidget {
  const TaskDeleterWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      requiredPermission: UserRoles.deleteTasks,
      fallback: fallback,
      child: child,
    );
  }
}

/// Widget that shows content only for users who can view department dashboard
class DepartmentDashboardWidget extends StatelessWidget {
  const DepartmentDashboardWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      requiredPermission: UserRoles.viewDepartmentDashboard,
      fallback: fallback,
      child: child,
    );
  }
}

/// Widget that shows content only for users who can view team dashboard
class TeamDashboardWidget extends StatelessWidget {
  const TeamDashboardWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      requiredPermission: UserRoles.viewTeamDashboard,
      fallback: fallback,
      child: child,
    );
  }
}

/// Widget that shows content only for users who can view company dashboard
class CompanyDashboardWidget extends StatelessWidget {
  const CompanyDashboardWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      requiredPermission: UserRoles.viewCompanyDashboard,
      fallback: fallback,
      child: child,
    );
  }
}

/// Widget that shows content only for users who can generate reports
class ReportGeneratorWidget extends StatelessWidget {
  const ReportGeneratorWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return RoleBasedWidget(
      requiredPermission: UserRoles.generateReports,
      fallback: fallback,
      child: child,
    );
  }
}
