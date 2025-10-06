import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;

import '../pages/splash_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/auth/change_password_page.dart';
import '../pages/auth/company_setup_page.dart';
import '../pages/home/dashboard_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String changePassword = '/change-password';
  static const String companySetup = '/company-setup';
  static const String dashboard = '/dashboard';

  static String get initialRoute => splash;

  static List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: login,
      page: () => const LoginPage(),
    ),
    if (!kReleaseMode)
      GetPage(
        name: register,
        page: () => const RegisterPage(),
      ),
    GetPage(
      name: changePassword,
      page: () => const ChangePasswordPage(),
    ),
    GetPage(
      name: companySetup,
      page: () => const CompanySetupPage(),
    ),
    GetPage(
      name: dashboard,
      page: () => const DashboardPage(),
    ),
  ];
}
