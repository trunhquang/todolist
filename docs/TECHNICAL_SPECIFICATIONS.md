# 🛠️ Technical Specifications - Todo List Application

## 📦 Flutter Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase Suite
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  firebase_database: ^10.4.0
  firebase_messaging: ^14.7.10
  firebase_analytics: ^10.7.4
  firebase_crashlytics: ^3.4.9
  
  # State Management
  get: ^4.6.6
  
  # Local Storage & Caching
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  
  # HTTP & API
  http: ^1.1.2
  dio: ^5.4.0
  connectivity_plus: ^5.0.2
  
  # UI Components & Icons
  cupertino_icons: ^1.0.6
  material_design_icons_flutter: ^7.0.7296
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0
  
  # Date & Time
  intl: ^0.19.0
  timezone: ^0.9.2
  
  # OneDrive Integration
  msal_flutter: ^2.0.0
  graph_api: ^1.0.0
  
  # Utilities
  uuid: ^4.2.1
  path_provider: ^2.1.1
  permission_handler: ^11.1.0
  device_info_plus: ^9.1.1
  
  # Notifications
  flutter_local_notifications: ^16.3.0
  
  # Charts & Analytics
  fl_chart: ^0.66.0
  syncfusion_flutter_charts: ^23.2.7

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Testing
  mockito: ^5.4.4
  build_runner: ^2.4.7
  
  # Code Quality
  flutter_lints: ^3.0.1
  very_good_analysis: ^5.1.0
  
  # Code Generation
  json_annotation: ^4.8.1
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1
```

## 🏗️ Project Structure

### File Size & Widget Composition Rules
```
📏 File Size Limits:
- Maximum 400 lines per file
- Maximum 100 lines per widget
- Break large widgets into smaller components

🎨 Widget Composition:
- Each complex widget should be split into smaller widgets
- Use folder structure for widget groups
- Follow TD prefix naming convention

📁 Widget Folder Structure:
widgets/
├── widget_name/
│   ├── widget_name.dart           # Main widget (max 100 lines)
│   ├── widget_name_header.dart    # Header component
│   ├── widget_name_content.dart   # Content component
│   └── widget_name_actions.dart   # Actions component
```

### Flutter App Structure
```
lib/
├── main.dart                          # App entry point
├── app/
│   ├── app.dart                       # Main app widget
│   ├── routes/
│   │   ├── app_router.dart           # Route configuration
│   │   └── route_names.dart          # Route constants
│   ├── theme/
│   │   ├── app_theme.dart            # Theme configuration
│   │   ├── app_colors.dart           # Color palette
│   │   └── app_text_styles.dart      # Text styles
│   └── constants/
│       ├── app_constants.dart        # App-wide constants
│       └── api_constants.dart        # API endpoints
├── core/
│   ├── constants/
│   │   ├── database_constants.dart   # Database field names
│   │   └── task_constants.dart       # Task-related constants
│   ├── errors/
│   │   ├── exceptions.dart           # Custom exceptions
│   │   └── failures.dart             # Failure classes
│   ├── network/
│   │   ├── network_info.dart         # Network connectivity
│   │   └── api_client.dart           # HTTP client setup
│   ├── utils/
│   │   ├── validators.dart           # Input validators
│   │   ├── formatters.dart           # Data formatters
│   │   └── extensions.dart           # Dart extensions
│   └── services/
│       ├── notification_service.dart # Local notifications
│       └── storage_service.dart      # Local storage
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart
│   │   │   │   └── company_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── user.dart
│   │   │   │   └── company.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sign_in_with_email.dart
│   │   │       ├── sign_in_with_google.dart
│   │   │       ├── sign_up.dart
│   │   │       └── sign_out.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   ├── register_page.dart
│   │       │   └── company_setup_page.dart
│   │       ├── widgets/
│   │       │   ├── login_form.dart
│   │       │   └── company_form.dart
│   │       └── controllers/
│   │           └── auth_controller.dart
│   ├── company/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── company_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── company_model.dart
│   │   │   └── repositories/
│   │   │       └── company_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── company.dart
│   │   │   ├── repositories/
│   │   │   │   └── company_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_company.dart
│   │   │       ├── get_company.dart
│   │   │       └── update_company.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── company_management_page.dart
│   │       ├── widgets/
│   │       │   └── company_card.dart
│   │       └── controllers/
│   │           └── company_controller.dart
│   ├── department/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── department_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── department_model.dart
│   │   │   └── repositories/
│   │   │       └── department_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── department.dart
│   │   │   ├── repositories/
│   │   │   │   └── department_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_department.dart
│   │   │       ├── get_departments.dart
│   │   │       ├── update_department.dart
│   │   │       └── delete_department.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── department_list_page.dart
│   │       ├── widgets/
│   │       │   └── department_card.dart
│   │       └── controllers/
│   │           └── department_controller.dart
│   ├── task/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── task_remote_datasource.dart
│   │   │   │   └── task_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── task_model.dart
│   │   │   │   └── recurring_task_model.dart
│   │   │   └── repositories/
│   │   │       └── task_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── task.dart
│   │   │   │   └── recurring_task.dart
│   │   │   ├── repositories/
│   │   │   │   └── task_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_task.dart
│   │   │       ├── get_tasks.dart
│   │   │       ├── update_task.dart
│   │   │       ├── delete_task.dart
│   │   │       ├── get_tasks_by_type.dart
│   │   │       └── create_recurring_task.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── task_list_page.dart
│   │       │   ├── task_detail_page.dart
│   │       │   └── create_task_page.dart
│   │       ├── widgets/
│   │       │   ├── task_card/
│   │       │   │   ├── task_card.dart           # Main TaskCard widget
│   │       │   │   ├── task_card_header.dart    # TaskCardHeader widget
│   │       │   │   ├── task_card_content.dart   # TaskCardContent widget
│   │       │   │   └── task_card_actions.dart   # TaskCardActions widget
│   │       │   ├── task_type_selector/
│   │       │   │   ├── task_type_selector.dart  # Main selector widget
│   │       │   │   ├── task_type_item.dart      # Individual type item
│   │       │   │   └── task_type_icon.dart      # Type icon widget
│   │       │   ├── deadline_selector/
│   │       │   │   ├── deadline_selector.dart   # Main deadline selector
│   │       │   │   ├── deadline_toggle.dart     # Deadline toggle widget
│   │       │   │   └── deadline_picker.dart     # Date picker widget
│   │       │   └── recurring_task_setup/
│   │       │       ├── recurring_setup.dart     # Main recurring setup
│   │       │       ├── frequency_selector.dart  # Frequency selector
│   │       │       └── interval_selector.dart   # Interval selector
│   │       └── controllers/
│   │           └── task_controller.dart
│   ├── project/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── project_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── project_model.dart
│   │   │   └── repositories/
│   │   │       └── project_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── project.dart
│   │   │   ├── repositories/
│   │   │   │   └── project_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_project.dart
│   │   │       ├── get_projects.dart
│   │   │       ├── update_project.dart
│   │   │       └── delete_project.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── project_list_page.dart
│   │       │   └── project_detail_page.dart
│   │       ├── widgets/
│   │       │   └── project_card.dart
│   │       └── controllers/
│   │           └── project_controller.dart
│   ├── report/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── report_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── report_model.dart
│   │   │   └── repositories/
│   │   │       └── report_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── report.dart
│   │   │   ├── repositories/
│   │   │   │   └── report_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_report.dart
│   │   │       ├── get_reports.dart
│   │   │       └── get_reports_by_date_range.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── daily_report_page.dart
│   │       │   └── report_history_page.dart
│   │       ├── widgets/
│   │       │   ├── report_form/
│   │       │   │   ├── report_form.dart           # Main report form
│   │       │   │   ├── completed_tasks_section.dart # Completed tasks section
│   │       │   │   ├── pending_tasks_section.dart  # Pending tasks section
│   │       │   │   └── notes_section.dart          # Notes section
│   │       │   └── report_summary/
│   │       │       ├── report_summary.dart         # Main summary widget
│   │       │       ├── summary_stats.dart          # Summary statistics
│   │       │       └── summary_chart.dart          # Summary chart
│   │       └── controllers/
│   │           └── report_controller.dart
│   ├── notification/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── notification_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── notification_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── repositories/
│   │   │   │   └── notification_repository.dart
│   │   │   └── usecases/
│   │   │       ├── send_notification.dart
│   │   │       └── get_notifications.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── notification_list_page.dart
│   │       ├── widgets/
│   │       │   └── notification_card.dart
│   │       └── controllers/
│   │           └── notification_controller.dart
│   └── dashboard/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── dashboard_remote_datasource.dart
│       │   └── repositories/
│       │       └── dashboard_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── dashboard_stats.dart
│       │   ├── repositories/
│       │   │   └── dashboard_repository.dart
│       │   └── usecases/
│       │       ├── get_task_stats.dart
│       │       ├── get_completion_rates.dart
│       │       └── get_department_performance.dart
│       └── presentation/
│           ├── pages/
│           │   └── dashboard_page.dart
│           ├── widgets/
│           │   ├── stats_card/
│           │   │   ├── stats_card.dart           # Main stats card
│           │   │   ├── stats_card_header.dart    # Stats card header
│           │   │   ├── stats_card_content.dart   # Stats card content
│           │   │   └── stats_card_footer.dart    # Stats card footer
│           │   ├── task_type_chart/
│           │   │   ├── task_type_chart.dart      # Main chart widget
│           │   │   ├── chart_legend.dart         # Chart legend
│           │   │   └── chart_tooltip.dart        # Chart tooltip
│           │   └── completion_rate_chart/
│           │       ├── completion_rate_chart.dart # Main completion chart
│           │       ├── rate_indicator.dart       # Rate indicator
│           │       └── progress_bar.dart         # Progress bar
│           └── controllers/
│               └── dashboard_controller.dart
├── shared/
│   ├── widgets/
│   │   ├── common/
│   │   │   ├── td_button.dart              # TDButton widget
│   │   │   ├── td_text.dart                # TDText widget
│   │   │   ├── td_text_field.dart          # TDTextField widget
│   │   │   ├── td_card.dart                # TDCard widget
│   │   │   ├── td_dialog.dart              # TDDialog widget
│   │   │   ├── td_snackbar.dart            # TDSnackbar widget
│   │   │   ├── td_loading.dart             # TDLoading widget
│   │   │   ├── td_error.dart               # TDError widget
│   │   │   ├── td_empty.dart               # TDEmpty widget
│   │   │   ├── td_app_bar.dart             # TDAppBar widget
│   │   │   └── td_alert.dart               # TDAlert widget
│   │   ├── forms/
│   │   │   ├── td_date_picker.dart         # TDDatePicker widget
│   │   │   ├── td_dropdown.dart            # TDDropdown widget
│   │   │   ├── td_multi_select.dart        # TDMultiSelect widget
│   │   │   ├── td_checkbox.dart            # TDCheckbox widget
│   │   │   ├── td_radio_button.dart        # TDRadioButton widget
│   │   │   └── td_switch.dart              # TDSwitch widget
│   │   ├── layout/
│   │   │   ├── td_scaffold.dart            # TDScaffold widget
│   │   │   ├── td_drawer.dart              # TDDrawer widget
│   │   │   ├── td_bottom_nav.dart          # TDBottomNav widget
│   │   │   ├── td_app_bar.dart             # TDAppBar widget
│   │   │   ├── td_tab_bar.dart             # TDTabBar widget
│   │   │   └── td_list_view.dart           # TDListView widget
│   │   ├── charts/
│   │   │   ├── td_pie_chart.dart           # TDPieChart widget
│   │   │   ├── td_bar_chart.dart           # TDBarChart widget
│   │   │   ├── td_line_chart.dart          # TDLineChart widget
│   │   │   └── td_progress_chart.dart      # TDProgressChart widget
│   │   └── animations/
│   │       ├── td_fade_animation.dart      # TDFadeAnimation widget
│   │       ├── td_slide_animation.dart     # TDSlideAnimation widget
│   │       └── td_scale_animation.dart     # TDScaleAnimation widget
│   ├── constants/
│   │   ├── app_strings.dart                # AppStrings class
│   │   ├── app_spacing.dart                # AppSpacing class
│   │   ├── app_colors.dart                 # AppColors class
│   │   ├── app_sizes.dart                  # AppSizes class
│   │   ├── app_durations.dart              # AppDurations class
│   │   └── app_enums.dart                  # App enums (TDButtonType, etc.)
│   ├── models/
│   │   ├── api_response.dart               # API response models
│   │   ├── pagination_model.dart           # Pagination models
│   │   ├── base_entity.dart                # Base entity class
│   │   └── notification_models.dart        # Notification models
│   ├── services/
│   │   ├── firebase_service.dart           # Firebase service
│   │   ├── onedrive_service.dart           # OneDrive service
│   │   ├── local_storage_service.dart      # Local storage service
│   │   ├── notification_service.dart       # Centralized notification service
│   │   ├── theme_service.dart              # Theme management service
│   │   ├── localization_service.dart       # Localization service
│   │   └── validation_service.dart         # Validation service
│   └── utils/
│       ├── validators.dart                 # Input validators
│       ├── formatters.dart                 # Data formatters
│       ├── extensions.dart                 # Dart extensions
│       ├── date_utils.dart                 # Date utilities
│       ├── string_utils.dart               # String utilities
│       └── device_utils.dart               # Device utilities
└── test/
    ├── unit/
    │   ├── features/
    │   │   ├── auth/
    │   │   ├── task/
    │   │   └── report/
    │   └── shared/
    ├── widget/
    │   ├── features/
    │   └── shared/
    └── integration/
        ├── auth_flow_test.dart
        ├── task_management_test.dart
        └── report_submission_test.dart
```

## 📋 Constants & Services Structure

### Constants Organization
```dart
// shared/constants/app_strings.dart
class AppStrings {
  // Common strings
  static const String confirm = 'confirm';
  static const String cancel = 'cancel';
  
  // Task-related strings
  static const String taskCreatedSuccessfully = 'task_created_successfully';
  static const String taskUpdatedSuccessfully = 'task_updated_successfully';
  
  // Validation strings
  static const String fieldRequired = 'field_required';
  static const String emailInvalid = 'email_invalid';
}

// shared/constants/app_spacing.dart
class AppSpacing {
  static const double _baseUnit = 8.0;
  
  // Padding constants
  static const EdgeInsets cardPadding = EdgeInsets.all(_baseUnit * 2);
  static const EdgeInsets contentPadding = EdgeInsets.all(_baseUnit * 1.5);
  
  // Margin constants
  static const EdgeInsets cardMargin = EdgeInsets.all(_baseUnit);
  static const EdgeInsets sectionMargin = EdgeInsets.only(bottom: _baseUnit * 4);
}

// shared/constants/app_colors.dart
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  
  // Task type colors
  static const Color dailyTask = Color(0xFF4CAF50);
  static const Color weeklyTask = Color(0xFFFF9800);
  static const Color monthlyTask = Color(0xFF9C27B0);
  static const Color projectTask = Color(0xFFF44336);
}

// shared/constants/app_enums.dart
enum TDButtonType { primary, secondary, success, warning, error }
enum TDButtonSize { small, medium, large }
enum TDNotificationType { info, success, warning, error }
enum TaskType { daily, weekly, monthly, project }
enum TaskPriority { low, medium, high, urgent }
enum TaskStatus { pending, inProgress, completed, cancelled }
```

### Services Organization
```dart
// shared/services/notification_service.dart
class NotificationService {
  static void showSnackbar({
    required String message,
    TDNotificationType type = TDNotificationType.info,
  }) {
    // Implementation using AppStrings and AppSpacing
  }
  
  static Future<T?> showDialog<T>({
    required String title,
    required String message,
  }) {
    // Implementation using TDDialog widget
  }
}

// shared/services/theme_service.dart
class ThemeService {
  static ThemeData get lightTheme => ThemeData(
    primaryColor: AppColors.primary,
    cardTheme: CardTheme(
      margin: AppSpacing.cardMargin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
    ),
  );
}

// shared/services/validation_service.dart
class ValidationService {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return AppStrings.emailInvalid;
    }
    return null;
  }
}
```

## 🎯 GetX Architecture & Configuration

### GetX State Management Setup
```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TodoList App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 300),
    );
  }
}
```

### GetX Controller Example
```dart
// features/auth/presentation/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/usecases/sign_in_with_email.dart';
import '../../domain/usecases/sign_up.dart';

class AuthController extends GetxController {
  final SignInWithEmail _signInWithEmail;
  final SignUp _signUp;
  
  AuthController(this._signInWithEmail, this._signUp);
  
  // Observable variables
  final _isLoading = false.obs;
  final _user = Rxn<User>();
  final _errorMessage = ''.obs;
  
  // Getters
  bool get isLoading => _isLoading.value;
  User? get user => _user.value;
  String get errorMessage => _errorMessage.value;
  
  @override
  void onInit() {
    super.onInit();
    _user.value = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user.value = user;
    });
  }
  
  Future<void> signInWithEmail(String email, String password) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      final result = await _signInWithEmail.call(
        SignInWithEmailParams(email: email, password: password)
      );
      
      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (user) => Get.offAllNamed(AppRoutes.home),
      );
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }
  
  Future<void> signUp(String email, String password, String companyName) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      final result = await _signUp.call(
        SignUpParams(email: email, password: password, companyName: companyName)
      );
      
      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (user) => Get.offAllNamed(AppRoutes.home),
      );
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }
  
  void signOut() {
    FirebaseAuth.instance.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}
```

### GetX Dependency Injection
```dart
// app/di/injection_container.dart
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

// Data Sources
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';

// Repositories
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

// Use Cases
import '../../features/auth/domain/usecases/sign_in_with_email.dart';
import '../../features/auth/domain/usecases/sign_up.dart';

// Controllers
import '../../features/auth/presentation/controllers/auth_controller.dart';

class InjectionContainer {
  static Future<void> init() async {
    // External
    Get.put<FirebaseAuth>(FirebaseAuth.instance);
    Get.put<FirebaseDatabase>(FirebaseDatabase.instance);
    
    // Data Sources
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        firebaseAuth: Get.find(),
        firebaseDatabase: Get.find(),
      ),
    );
    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(),
    );
    
    // Repositories
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
      ),
    );
    
    // Use Cases
    Get.lazyPut(() => SignInWithEmail(Get.find()));
    Get.lazyPut(() => SignUp(Get.find()));
    
    // Controllers
    Get.lazyPut(() => AuthController(
      Get.find(),
      Get.find(),
    ));
  }
}
```

### GetX Route Management
```dart
// app/routes/app_pages.dart
import 'package:get/get.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}

// app/routes/app_routes.dart
abstract class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const taskList = '/tasks';
  static const taskDetail = '/task-detail';
  static const createTask = '/create-task';
  static const reports = '/reports';
  static const profile = '/profile';
}
```

### GetX Bindings
```dart
// app/bindings/auth_binding.dart
import 'package:get/get.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

// app/bindings/dashboard_binding.dart
import 'package:get/get.dart';
import '../../features/dashboard/presentation/controllers/dashboard_controller.dart';
import '../../features/task/presentation/controllers/task_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<TaskController>(() => TaskController());
  }
}
```

### GetX Middleware
```dart
// app/middlewares/auth_middleware.dart
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}
```

## 🔧 Development Tools & Configuration

### Analysis Options
```yaml
# analysis_options.yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.mocks.dart"

linter:
  rules:
    # Additional custom rules
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    avoid_print: true
    prefer_single_quotes: true
```

### Build Configuration
```yaml
# pubspec.yaml build configuration
flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
    - assets/fonts/
  
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
        - asset: assets/fonts/Roboto-Bold.ttf
          weight: 700
```

## 🔐 Firebase Configuration

### Security Rules
```javascript
// Firebase Realtime Database Rules
{
  "rules": {
    "companies": {
      "$workspaceId": {
        ".read": "auth != null && root.child('workspaces').child($workspaceId).child('users').child(auth.uid).exists()",
        ".write": "auth != null && root.child('workspaces').child($workspaceId).child('users').child(auth.uid).exists()",
        
        "departments": {
          "$departmentId": {
            ".read": "auth != null && (data.child('users').child(auth.uid).exists() || data.child('admins').child(auth.uid).exists())",
            ".write": "auth != null && data.child('admins').child(auth.uid).exists()"
          }
        },
        
        "tasks": {
          "$taskId": {
            ".read": "auth != null && (data.child('assignee').val() == auth.uid || data.child('assigner').val() == auth.uid || data.child('departmentId').val() == root.child('workspaces').child($workspaceId).child('departments').child(data.child('departmentId').val()).child('admins').child(auth.uid).exists())",
            ".write": "auth != null && (data.child('assignee').val() == auth.uid || data.child('assigner').val() == auth.uid || data.child('departmentId').val() == root.child('workspaces').child($workspaceId).child('departments').child(data.child('departmentId').val()).child('admins').child(auth.uid).exists())"
          }
        },
        
        "projects": {
          "$projectId": {
            ".read": "auth != null && root.child('workspaces').child($workspaceId).child('departments').child(data.child('departmentId').val()).child('users').child(auth.uid).exists()",
            ".write": "auth != null && root.child('workspaces').child($workspaceId).child('departments').child(data.child('departmentId').val()).child('admins').child(auth.uid).exists()"
          }
        },
        
        "reports": {
          "$userId": {
            ".read": "auth != null && (auth.uid == $userId || root.child('workspaces').child($workspaceId).child('departments').child(data.child('departmentId').val()).child('admins').child(auth.uid).exists())",
            ".write": "auth != null && auth.uid == $userId"
          }
        }
      }
    }
  }
}
```

### Firebase Functions (Optional)
```javascript
// Cloud Functions for notifications
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendTaskNotification = functions.database
  .ref('/companies/{workspaceId}/tasks/{taskId}')
  .onCreate(async (snapshot, context) => {
    const task = snapshot.val();
    const assigneeId = task.assignee;
    
    // Get user's FCM token
    const userDoc = await admin.firestore()
      .collection('users')
      .doc(assigneeId)
      .get();
    
    if (userDoc.exists) {
      const userData = userDoc.data();
      const fcmToken = userData.fcmToken;
      
      if (fcmToken) {
        const message = {
          token: fcmToken,
          notification: {
            title: 'New Task Assigned',
            body: `You have been assigned: ${task.title}`
          },
          data: {
            taskId: context.params.taskId,
            workspaceId: context.params.workspaceId
          }
        };
        
        await admin.messaging().send(message);
      }
    }
  });
```

## 📱 Platform-Specific Configuration

### Android Configuration
```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.company.todolist"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

dependencies {
    implementation 'com.google.firebase:firebase-analytics'
    implementation 'com.google.firebase:firebase-messaging'
    implementation 'com.google.firebase:firebase-database'
}
```

### iOS Configuration
```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleDisplayName</key>
<string>TodoList</string>
<key>CFBundleIdentifier</key>
<string>com.company.todolist</string>
<key>CFBundleVersion</key>
<string>1.0.0</string>

<!-- Firebase configuration -->
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
```

## 🧪 Testing Configuration

### Test Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Testing
  mockito: ^5.4.4
  build_runner: ^2.4.7
  integration_test:
    sdk: flutter
  
  # Code Coverage
  test_coverage: ^0.2.1
```

### Test Structure
```
test/
├── unit/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository_impl_test.dart
│   │   │   │   └── datasources/
│   │   │   │       └── auth_remote_datasource_test.dart
│   │   │   ├── domain/
│   │   │   │   └── usecases/
│   │   │   │       ├── sign_in_with_email_test.dart
│   │   │   │       └── sign_up_test.dart
│   │   │   └── presentation/
│   │   │       └── controllers/
│   │   │           └── auth_controller_test.dart
│   │   ├── task/
│   │   └── report/
│   └── shared/
│       ├── services/
│       │   ├── firebase_service_test.dart
│       │   └── onedrive_service_test.dart
│       └── utils/
│           ├── validators_test.dart
│           └── formatters_test.dart
├── widget/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── pages/
│   │   │   │   └── login_page_test.dart
│   │   │   └── widgets/
│   │   │       └── login_form_test.dart
│   │   ├── task/
│   │   └── report/
│   └── shared/
│       └── widgets/
│           ├── app_button_test.dart
│           └── app_text_field_test.dart
└── integration/
    ├── auth_flow_test.dart
    ├── task_management_test.dart
    ├── report_submission_test.dart
    └── notification_test.dart
```

## 🚀 CI/CD Configuration

### GitLab CI Pipeline
```yaml
# .gitlab-ci.yml
stages:
  - test
  - build
  - deploy

variables:
  FLUTTER_VERSION: "3.16.0"

test:
  stage: test
  image: cirrusci/flutter:3.16.0
  script:
    - flutter pub get
    - flutter analyze
    - flutter test
    - flutter test --coverage
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura.xml

build_android:
  stage: build
  image: cirrusci/flutter:3.16.0
  script:
    - flutter pub get
    - flutter build apk --release
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-release.apk
  only:
    - main
    - develop

build_ios:
  stage: build
  image: cirrusci/flutter:3.16.0
  script:
    - flutter pub get
    - flutter build ios --release --no-codesign
  artifacts:
    paths:
      - build/ios/iphoneos/Runner.app
  only:
    - main
    - develop
```

## 📊 Performance Monitoring

### Firebase Analytics Events
```dart
// Analytics events to track
class AnalyticsEvents {
  static const String taskCreated = 'task_created';
  static const String taskCompleted = 'task_completed';
  static const String reportSubmitted = 'report_submitted';
  static const String userLoggedIn = 'user_logged_in';
  static const String companyCreated = 'company_created';
  static const String departmentCreated = 'department_created';
}
```

### Performance Metrics
- App startup time: < 3 seconds
- Screen transition: < 300ms
- Database query: < 500ms
- Image loading: < 1 second
- Memory usage: < 100MB
- Battery usage: Optimized for 8+ hours usage

---

**Note**: This technical specification document should be updated as the project evolves and new requirements are added.
