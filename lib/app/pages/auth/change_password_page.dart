import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/constants/app_spacing.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/core/widgets/td_text_field.dart';
import '../../routes/app_router.dart';
import '../../widgets/td_app_bar.dart';
import '../../widgets/td_button.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  
  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDAppBar(
        title: AppStrings.changePassword,
        leading: null, // Prevent back button for security
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.lock_reset,
                      size: 64,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      AppStrings.changePasswordRequired,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      AppStrings.changePasswordDescription,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Form Section
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
              
              // New Password Field
              TDTextField(
                controller: _newPasswordController,
                labelText: AppStrings.newPassword,
                obscureText: _obscureNewPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseEnterNewPassword;
                  }
                  if (value.length < 6) {
                    return AppStrings.passwordTooShort;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              
              // Confirm Password Field
              TDTextField(
                controller: _confirmPasswordController,
                labelText: AppStrings.confirmPassword,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseConfirmPassword;
                  }
                  if (value != _newPasswordController.text) {
                    return AppStrings.passwordsDoNotMatch;
                  }
                  return null;
                },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    
                    // Change Password Button
                    TDButton(
                      text: AppStrings.changePassword,
                      onPressed: _isLoading ? null : _changePassword,
                      variant: TDButtonVariant.filled,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: AppStrings.userNotAuthenticated,
        );
        return;
      }

      // Update password
      await user.updatePassword(_newPasswordController.text);

      // Update user flag in database
      await _updateUserPasswordFlag();

      SnackbarService().showSuccess(
        title: AppStrings.success,
        message: AppStrings.passwordChangedSuccessfully,
      );

      // Navigate to dashboard
      await NavigationService().toNamed<void>(AppRouter.dashboard);
      
    } catch (e) {
      SnackbarService().showError(
        title: AppStrings.error,
        message: 'Failed to change password: $e',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUserPasswordFlag() async {
    try {
      // TODO: Implement updateUserPasswordFlag method in FirebaseDatabaseServiceEnhanced
      // await _databaseService.updateUserPasswordFlag(
      //   userId: _firebaseAuth.currentUser!.uid,
      //   mustChangePassword: false,
      // );
    } catch (e) {
      // Log error but don't block the flow
      print('Failed to update user password flag: $e');
    }
  }
}