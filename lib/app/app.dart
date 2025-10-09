import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../firebase_options.dart';
import '../core/services/storage_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/onedrive_service.dart';
import '../core/services/firebase_database_service.dart';
import '../core/services/recurring_task_service.dart';
import '../core/services/conflict_resolution_service.dart';
import '../core/services/offline_queue_service.dart';
import '../core/services/report_service.dart';
import '../core/services/pagination_service.dart';
import '../core/services/notification_manager_service.dart';
import '../core/services/backup_service.dart';
import '../features/reports/presentation/controllers/report_controller.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';
import 'constants/app_constants.dart';

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      getPages: AppRouter.routes,
      initialRoute: AppRouter.initialRoute,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

class AppInitializer {
  static Future<void> initialize() async {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Initialize Hive for local storage
    await Hive.initFlutter();
    
    // Initialize core services
    await StorageService().initialize();
    Get.put(StorageService());
    await NotificationService().initialize();
    Get.put(NotificationService());
    await OneDriveService().initialize();
    Get.put(OneDriveService());
    
    // Initialize Firebase Database service
    Get.put(FirebaseDatabaseService());
    
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
  }
}
