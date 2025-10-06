import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../firebase_options.dart';
import '../core/services/storage_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/onedrive_service.dart';
import '../core/services/firebase_database_service.dart';
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
      themeMode: ThemeMode.system,
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
    await StorageService.instance.initialize();
    await NotificationService.instance.initialize();
    await OneDriveService.instance.initialize();
    
    // Initialize Firebase Database service
    Get.put(FirebaseDatabaseService());
  }
}
