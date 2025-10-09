import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_constants.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../routes/app_router.dart';
import '../../widgets/td_button.dart';
import '../../widgets/td_text_field.dart';
import '../../../core/services/navigation_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      await _authController.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      // Delegate post-login navigation (may force company setup)
      await _authController.handlePostLoginNavigation();
    }
  }

  // Future<void> _handleGoogleSignIn() async {
  //   await _authController.signInWithGoogle();
  //   // Delegate post-login navigation (may force company setup)
  //   await _authController.handlePostLoginNavigation();
  // }
  //
  // Future<void> _handleAppleSignIn() async {
  //   await _authController.signInWithApple();
  //   // Delegate post-login navigation (may force company setup)
  //   await _authController.handlePostLoginNavigation();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                // App Logo and Title
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.checklist_rtl,
                          size: 40,
                          color: AppColors.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome Back',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.onBackground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue to ${AppConstants.appName}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                // Email Field
                TDTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Password Field
                TDTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  obscureText: !_isPasswordVisible,
                  prefixIcon: Icons.lock_outlined,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < AppConstants.minPasswordLength) {
                      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Login Button
                Obx(() => TDButton(
                  text: 'Sign In',
                  onPressed: _authController.isLoading ? null : _handleLogin,
                  isLoading: _authController.isLoading,
                )),
                const SizedBox(height: 16),
                // Third-party Sign-In buttons are temporarily disabled until the flow is finalized.
                // Obx(() => TDButton(
                //   text: 'Continue with Google',
                //   onPressed: _authController.isLoading ? null : _handleGoogleSignIn,
                //   variant: TDButtonVariant.outlined,
                //   icon: Icons.g_mobiledata,
                // )),
                // const SizedBox(height: 12),
                // if (Platform.isIOS)
                //   Obx(() => TDButton(
                //         text: 'Continue with Apple',
                //         onPressed: _authController.isLoading ? null : _handleAppleSignIn,
                //         variant: TDButtonVariant.outlined,
                //         icon: Icons.apple,
                //       )),
                const SizedBox(height: 24),
                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => NavigationService().toNamed<void>(AppRouter.register),
                      child: Text(
                        'Sign Up',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
