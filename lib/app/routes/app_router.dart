import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;

import '../pages/splash_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/auth/change_password_page.dart';
import '../pages/auth/company_setup_page.dart';
import '../pages/home/dashboard_page.dart';
import '../pages/projects/project_list_page.dart';
import '../pages/projects/project_edit_page.dart';
import '../pages/tasks/task_list_page.dart';
import '../pages/tasks/task_edit_page.dart';
import '../pages/reports/report_create_page.dart';
import '../pages/reports/report_history_page.dart';
import '../pages/reports/report_analytics_page.dart';
import '../pages/settings/notification_settings_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String changePassword = '/change-password';
  static const String companySetup = '/company-setup';
  static const String dashboard = '/dashboard';
  static const String projects = '/projects';
  static const String projectEdit = '/projects/edit';
  static const String tasks = '/tasks';
  static const String taskEdit = '/tasks/edit';
  static const String reportCreate = '/reports/create';
  static const String reportHistory = '/reports/history';
  static const String reportAnalytics = '/reports/analytics';
  static const String notificationSettings = '/settings/notifications';

  static String get initialRoute => splash;

  static List<GetPage<void>> routes = [
    GetPage<void>(
      name: splash,
      page: () => const SplashPage(),
    ),
    GetPage<void>(
      name: login,
      page: () => const LoginPage(),
    ),
    if (!kReleaseMode)
      GetPage<void>(
        name: register,
        page: () => const RegisterPage(),
      ),
    GetPage<void>(
      name: changePassword,
      page: () => const ChangePasswordPage(),
    ),
    GetPage<void>(
      name: companySetup,
      page: () => const CompanySetupPage(),
    ),
    GetPage<void>(
      name: dashboard,
      page: () => const DashboardPage(),
    ),
    GetPage<void>(
      name: projects,
      page: () => const ProjectListPage(),
    ),
    GetPage<void>(
      name: projectEdit,
      page: () => const ProjectEditPage(),
    ),
    GetPage<void>(
      name: tasks,
      page: () => const TaskListPage(),
    ),
    GetPage<void>(
      name: taskEdit,
      page: () => const TaskEditPage(),
    ),
    GetPage<void>(
      name: reportCreate,
      page: () => const ReportCreatePage(),
    ),
    GetPage<void>(
      name: reportHistory,
      page: () => const ReportHistoryPage(),
    ),
    GetPage<void>(
      name: reportAnalytics,
      page: () => const ReportAnalyticsPage(),
    ),
    GetPage<void>(
      name: notificationSettings,
      page: () => const NotificationSettingsPage(),
    ),
  ];
}
