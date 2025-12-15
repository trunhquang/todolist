import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todolist/app/constants/app_constants.dart';
import 'package:todolist/app/theme/app_colors.dart';
import 'package:todolist/app/theme/app_text_styles.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/app/widgets/td_text_field.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      await _authController.signUpWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );
      
      // Navigation is handled automatically by signUpWithEmailAndPassword
      // No need to call handlePostLoginNavigation() again
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.I.createAccount),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.onBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Title
                Text(
                  'Join ${AppConstants.appName}',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.I.createAccountDescription,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                // Name Field
                TDTextField(
                  controller: _nameController,
                  label: AppStrings.I.fullName,
                  hint: AppStrings.I.enterFullName,
                  prefixIcon: Icons.person_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.I.pleaseEnterFullName;
                    }
                    if (value.length < 2) {
                      return AppStrings.I.nameMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Email Field
                TDTextField(
                  controller: _emailController,
                  label: AppStrings.I.email,
                  hint: AppStrings.I.enterEmail,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.I.emailRequired;
                    }
                    if (!GetUtils.isEmail(value)) {
                      return AppStrings.I.invalidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Password Field
                TDTextField(
                  controller: _passwordController,
                  label: AppStrings.I.password,
                  hint: AppStrings.I.enterPassword,
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
                      return AppStrings.I.passwordRequired;
                    }
                    if (value.length < AppConstants.minPasswordLength) {
                      return AppStrings.I.passwordTooShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Confirm Password Field
                TDTextField(
                  controller: _confirmPasswordController,
                  label: AppStrings.I.confirmPassword,
                  hint: AppStrings.I.confirmYourPassword,
                  obscureText: !_isConfirmPasswordVisible,
                  prefixIcon: Icons.lock_outlined,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.I.pleaseConfirmPassword;
                    }
                    if (value != _passwordController.text) {
                      return AppStrings.I.passwordsDoNotMatch;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                // Register Button
                Obx(() => TDButton(
                  text: AppStrings.I.createAccount,
                  onPressed: _authController.isLoading ? null : _handleRegister,
                  isLoading: _authController.isLoading,
                )),
                const SizedBox(height: 24),
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.I.alreadyHaveAccount,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => NavigationService().back<void>(),
                      child: Text(
                        AppStrings.I.login,
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
