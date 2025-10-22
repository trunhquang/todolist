import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todolist/app/theme/app_colors.dart';
import 'package:todolist/app/theme/app_text_styles.dart';
import 'package:todolist/app/routes/app_router.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/app/widgets/td_text_field.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';

class CompanySetupPage extends StatefulWidget {
  const CompanySetupPage({super.key});

  @override
  State<CompanySetupPage> createState() => _CompanySetupPageState();
}

class _CompanySetupPageState extends State<CompanySetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _departmentNameController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _companyNameController.dispose();
    _departmentNameController.dispose();
    super.dispose();
  }

  Future<void> _handleCompanySetup() async {
    if (_formKey.currentState!.validate()) {
      await _authController.createCompany(
        name: _companyNameController.text.trim(),
        departmentName: _departmentNameController.text.trim(),
      );
      
      // Navigate to dashboard on success
      if (_authController.hasCompany) {
        await NavigationService().offAllNamed<void>(AppRouter.dashboard);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.companySetup),
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
                  AppStrings.companySetup,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.companySetupDescription,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                // Company Name Field
                TDTextField(
                  controller: _companyNameController,
                  label: AppStrings.companyName,
                  hint: AppStrings.enterCompanyName,
                  prefixIcon: Icons.business_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.pleaseEnterCompanyName;
                    }
                    if (value.length < 2) {
                      return AppStrings.companyNameMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Department Name Field
                TDTextField(
                  controller: _departmentNameController,
                  label: AppStrings.departmentName,
                  hint: AppStrings.enterDepartmentName,
                  prefixIcon: Icons.group_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.pleaseEnterDepartmentName;
                    }
                    if (value.length < 2) {
                      return AppStrings.departmentNameMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                // Setup Button
                Obx(() => TDButton(
                  text: AppStrings.completeSetup,
                  onPressed: _authController.isLoading ? null : _handleCompanySetup,
                  isLoading: _authController.isLoading,
                )),
                const SizedBox(height: 16),
                // Skip Button
                Obx(() => TDButton(
                  text: AppStrings.skipForNow,
                  onPressed: _authController.isLoading ? null : () => NavigationService().offAllNamed<void>(AppRouter.dashboard),
                  variant: TDButtonVariant.outlined,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
