import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get/get.dart';

import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../routes/app_router.dart';
import '../../core/services/navigation_service.dart';
import '../../core/services/firebase_database_service.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadAppNameFromFirebase();
    _navigateToNextPage();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      // Reduced from 2 seconds to 1.2 seconds
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    ));

    unawaited(_animationController.forward());
  }

  Future<void> _loadAppNameFromFirebase() async {
    try {
      final databaseService = Get.find<FirebaseDatabaseService>();
      final appName = await databaseService.getConfigValue('appName');
      final appDescription = await databaseService.getConfigValue('appDescription');

      AppConstants.appName = appName ?? AppConstants.appName;
      AppConstants.appDescription =
          appDescription ?? AppConstants.appDescription;

      if (appName != null && mounted) {
        setState(() {});
      } else if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // If Firebase fails, keep default app name
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _navigateToNextPage() {
    if (Get.testMode) {
      return; // Skip navigation and Firebase access in tests
    }
    // Reduced delay from 3 seconds to 1.5 seconds for better UX
    Future.delayed(const Duration(milliseconds: 1500), () async {
      // Ensure AuthController is available (use global instance)
      final authController = Get.find<AuthController>();

      // If a Firebase user session exists, let centralized logic decide
      final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        await authController.handlePostLoginNavigation();
        return;
      }

      // No session -> go to login
      await NavigationService().offAllNamed<void>(AppRouter.login);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.onPrimary,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.checklist_rtl,
                            size: 60,
                            color: AppColors.primary,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Icon(Icons.arrow_forward, size: 50, color: Colors.white,),
                        ),
                         Image.asset(
                           'assets/icons/app_icon_trans_1024.png',
                           width: 120,
                           height: 120,
                           fit: BoxFit.cover,
                         )
                      ],
                    ),
                    const SizedBox(height: 32),
                    // App Name
                    Text(
                      AppConstants.appName,
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // App Description
                    Text(
                      AppConstants.appDescription,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.onPrimary.withValues(alpha: 0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    // Loading Indicator
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
