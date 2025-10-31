import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart';
import '../core/services/storage_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/onedrive_service.dart';
import '../core/services/firebase_database_service.dart';
import '../core/services/firebase_database_service_enhanced.dart';
import '../core/services/firebase_pagination_service.dart';
import '../core/backend/api_gateway_impl.dart';
import '../core/backend/backend_service.dart';
import '../core/backend/external_services_manager.dart';
import '../core/backend/notification_service.dart';
import '../core/services/recurring_task_service.dart';
import '../core/services/conflict_resolution_service.dart';
import '../core/services/offline_queue_service.dart';
import '../core/services/report_service.dart';
import '../core/services/pagination_service.dart';
import '../core/services/notification_manager_service.dart';
import '../core/services/backup_service.dart';
import '../features/reports/presentation/controllers/report_controller.dart';
import '../features/workspace/presentation/controllers/workspace_controller.dart';
import '../features/workspace/domain/repositories/workspace_repository.dart';
import '../features/workspace/data/repositories/workspace_repository_impl.dart';
import '../features/workspace/data/datasources/workspace_remote_data_source.dart';
import '../features/workspace/data/datasources/workspace_local_data_source.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'constants/app_constants.dart';

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    return GetBuilder<ThemeController>(
      init: themeController,
      builder: (ctrl) {
        final seed = ctrl.primaryColor;
        return GetMaterialApp(
          title: AppConstants.appName,
          theme: AppTheme.lightTheme(seed),
          darkTheme: AppTheme.darkTheme(seed),
          themeMode: ctrl.themeMode,
          getPages: AppRouter.routes,
          initialRoute: AppRouter.initialRoute,
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}

class AppInitializer {
  static Future<void> initialize() async {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Initialize Firebase Database
    Get.put<FirebaseDatabase>(FirebaseDatabase.instance);
    
    // Initialize Hive for local storage
    await Hive.initFlutter();
    
    // Initialize SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(sharedPreferences);
    
    // Initialize core services
    await StorageService().initialize();
    Get.put(StorageService());
    await NotificationService().initialize();
    Get.put(NotificationService());
    await OneDriveService().initialize();
    Get.put(OneDriveService());
    
    // Initialize Firebase Pagination service
    Get.put(FirebasePaginationService());
    
    // Initialize External Services Manager
    Get.put(ExternalServicesManager());

    // Initialize Notification Service
    Get.put(NotificationServiceImpl());

    
    // Initialize Backend Service Layer
    Get.put(BackendServiceImpl(
      externalServices: Get.find<ExternalServicesManager>(),
      notificationService: Get.find<NotificationServiceImpl>(),
    ));
    
    // Initialize API Gateway
    Get.put(ApiGatewayImpl(
      backendService: Get.find<BackendServiceImpl>(),
    ));
    
    // Legacy Firebase services (deprecated - will be removed)
    Get.put(FirebaseDatabaseService());
    Get.lazyPut(() => FirebaseDatabaseServiceEnhanced());
    
    // Initialize Offline Queue service (must be before services that depend on it)
    Get.put(OfflineQueueService.instance);

    // Initialize Recurring Task service
    Get.put(RecurringTaskService());
    
    // Initialize Conflict Resolution service
    Get.put(ConflictResolutionService());
    
    // Initialize Pagination service
    Get.put(PaginationService());

    // Initialize Report service
    Get.put(ReportService());
    
    // Initialize Report Controller
    Get.put(ReportController());
    
    // Initialize Notification Manager service
    Get.put(NotificationManagerService());

    // Initialize Backup service
    final backupService = BackupService();
    Get.put(backupService);
    // Kick off scheduled backups (client-side cadence)
    backupService.startScheduledBackups();
    
    // Initialize Workspace dependencies
    Get.put<WorkspaceRemoteDataSource>(
      WorkspaceRemoteDataSourceImpl(database: Get.find()),
    );
    Get.put<WorkspaceLocalDataSource>(
      WorkspaceLocalDataSourceImpl(sharedPreferences: Get.find()),
    );
    Get.put<WorkspaceRepository>(
      WorkspaceRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
        storageService: Get.find(),
        databaseService: Get.find(),
      ),
    );
    

    Get.put(AuthController());

    // Initialize Workspace Controller
    Get.put(WorkspaceController(
      workspaceRepository: Get.find(),
    ));

    // Initialize Auth Controller (lazy with fenix for resilience)
    // Get.lazyPut<AuthController>(AuthController.new, fenix: true);
  }
}
