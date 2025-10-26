import 'package:get/get.dart';

import '../pages/splash_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/auth/change_password_page.dart';
import '../pages/auth/forgot_password_page.dart';
import '../pages/home/dashboard_page.dart';
import '../pages/backup/backup_restore_page.dart';
import '../pages/projects/project_list_page.dart';
import '../pages/projects/project_edit_page.dart';
import '../pages/tasks/task_list_page.dart';
import '../pages/tasks/task_edit_page.dart';
import '../pages/tasks/task_statistics_page.dart';
import '../pages/reports/report_create_page.dart';
import '../pages/reports/report_history_page.dart';
import '../pages/reports/report_analytics_page.dart';
import '../pages/settings/notification_settings_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/settings/app_settings_page.dart';
import '../pages/workspace/workspace_settings_page.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/entities/team_group.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';
import 'package:todolist/features/workspace/presentation/pages/workspace_management_page.dart';
import 'package:todolist/features/workspace/presentation/pages/workspace_analytics_dashboard.dart';
import '../pages/users/user_management_page.dart';
import '../pages/team/team_management_page.dart';
import '../pages/team/team_group_detail_page.dart';
import '../pages/permissions/permission_management_page.dart';
import '../../features/workspace/presentation/pages/create_workspace_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/change-password';
  static const String dashboard = '/dashboard';
  static const String backupRestore = '/backup-restore';
  static const String projects = '/projects';
  static const String projectEdit = '/projects/edit';
  static const String tasks = '/tasks';
  static const String taskEdit = '/tasks/edit';
  static const String taskStatistics = '/tasks/statistics';
  static const String reportCreate = '/reports/create';
  static const String reportHistory = '/reports/history';
  static const String reportAnalytics = '/reports/analytics';
  static const String notificationSettings = '/settings/notifications';
  static const String settings = '/settings';
  static const String profilePage = '/profile';

  // Workspace Management Routes
  static const String workspaceManagement = '/workspace/management';
  static const String workspaceSettings = '/workspace/settings';
  static const String workspaceAnalytics = '/workspace/analytics';
  static const String createWorkspace = '/workspace/create';

  // User Management Routes
  static const String userManagement = '/users/management';
  static const String teamManagement = '/team/management';
  static const String teamGroupDetail = '/team-group-detail';

  // Permission Management Routes
  static const String permissionManagement = '/permissions/management';

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
    GetPage<void>(
      name: register,
      page: () => const RegisterPage(),
    ),
    GetPage<void>(
      name: forgotPassword,
      page: () => const ForgotPasswordPage(),
    ),
    GetPage<void>(
      name: changePassword,
      page: () => const ChangePasswordPage(),
    ),
    GetPage<void>(
      name: dashboard,
      page: () => const DashboardPage(),
    ),
    GetPage(
      name: backupRestore,
      page: () => const BackupRestorePage(),
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
      name: taskStatistics,
      page: () => const TaskStatisticsPage(),
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
    GetPage<void>(
      name: settings,
      page: () => const AppSettingsPage(),
    ),
    GetPage<void>(
      name: profilePage,
      page: () => const ProfilePage(),
    ),

    // Workspace Management Routes
    GetPage<void>(
      name: createWorkspace,
      page: () => const CreateWorkspacePage(),
    ),
    GetPage<void>(
      name: workspaceManagement,
      page: () {
        final controller = Get.find<WorkspaceController>();
        final ws = controller.currentWorkspace.value ??
            Workspace(
              id: '',
              name: '',
              type: WorkspaceType.personal,
              createdBy: '',
              createdAt: DateTime.fromMillisecondsSinceEpoch(0),
            );
        return WorkspaceManagementPage(workspace: ws);
      },
    ),
    GetPage<void>(
      name: workspaceSettings,
      page: () => const WorkspaceSettingsPage(),
    ),
    GetPage<void>(
      name: workspaceAnalytics,
      page: () => const WorkspaceAnalyticsDashboard(),
    ),

    // User Management Routes
    GetPage<void>(
      name: userManagement,
      page: () => const UserManagementPage(),
    ),
    GetPage<void>(
      name: teamManagement,
      page: () => const TeamManagementPage(),
    ),
    GetPage<void>(
      name: teamGroupDetail,
      page: () {
        final teamGroup = Get.arguments as TeamGroup;
        return TeamGroupDetailPage(teamGroup: teamGroup);
      },
    ),

    // Permission Management Routes
    GetPage<void>(
      name: permissionManagement,
      page: () => const PermissionManagementPage(),
    ),
  ];
}
