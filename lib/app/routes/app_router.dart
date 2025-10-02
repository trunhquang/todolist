import 'package:get/get.dart';

import '../pages/splash_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/auth/company_setup_page.dart';
import '../pages/home/dashboard_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
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
    GetPage(
      name: register,
      page: () => const RegisterPage(),
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
