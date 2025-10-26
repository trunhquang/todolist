import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/td_button.dart';
import '../../widgets/td_text_field.dart';
import '../../../core/services/navigation_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetEmail() async {
    if (_formKey.currentState!.validate()) {
      await _authController.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      
      // Check if email was sent successfully
      if (!_authController.hasError) {
        setState(() {
          _emailSent = true;
        });
      }
    }
  }

  Future<void> _handleResendEmail() async {
    await _authController.sendPasswordResetEmail(
      email: _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_emailSent ? AppStrings.checkYourEmail : AppStrings.resetPassword),
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
                const SizedBox(height: 32),
                
                // Icon
                Icon(
                  _emailSent ? Icons.mark_email_read : Icons.lock_reset,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),
                
                // Title
                Text(
                  _emailSent ? AppStrings.checkYourEmail : AppStrings.resetPassword,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Description
                Text(
                  _emailSent 
                    ? AppStrings.resetLinkSent
                    : AppStrings.resetPasswordDescription,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                if (!_emailSent) ...[
                  // Email Field
                  TDTextField(
                    controller: _emailController,
                    label: AppStrings.email,
                    hint: AppStrings.enterEmail,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.emailRequired;
                      }
                      if (!GetUtils.isEmail(value)) {
                        return AppStrings.invalidEmail;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Send Reset Link Button
                  Obx(() => TDButton(
                    text: AppStrings.sendResetLink,
                    onPressed: _authController.isLoading ? null : _handleSendResetEmail,
                    isLoading: _authController.isLoading,
                  )),
                ] else ...[
                  // Email sent success message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppStrings.viAuthPasswordResetEmailSentMessage,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onPrimaryContainer,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Resend Email Button
                  Obx(() => TDButton(
                    text: AppStrings.resendEmail,
                    onPressed: _authController.isLoading ? null : _handleResendEmail,
                    isLoading: _authController.isLoading,
                    variant: TDButtonVariant.outlined,
                  )),
                ],
                
                const SizedBox(height: 24),
                
                // Back to Login Button
                TDButton(
                  text: AppStrings.backToLogin,
                  onPressed: () => NavigationService().back<void>(),
                  variant: TDButtonVariant.text,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
