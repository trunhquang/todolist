import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_constants.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../routes/app_router.dart';
import '../../widgets/td_button.dart';
import '../../widgets/td_text_field.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../core/services/navigation_service.dart';

class CompanySetupPage extends StatefulWidget {
  const CompanySetupPage({super.key});

  @override
  State<CompanySetupPage> createState() => _CompanySetupPageState();
}

class _CompanySetupPageState extends State<CompanySetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _departmentNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _companyNameController.dispose();
    _departmentNameController.dispose();
    super.dispose();
  }

  void _handleCompanySetup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // TODO: Implement company setup logic
        await Future.delayed(const Duration(seconds: 2)); // Simulate API call
        
        // Navigate to dashboard on success
        NavigationService.instance.offAllNamed(AppRouter.dashboard);
      } catch (e) {
        // Show error message using SnackbarService
        SnackbarService.instance.showCompanySetupError();
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Company Setup'),
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
                  'Set Up Your Company',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your company and first department to get started',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                // Company Name Field
                TDTextField(
                  controller: _companyNameController,
                  label: 'Company Name',
                  hint: 'Enter your company name',
                  prefixIcon: Icons.business_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your company name';
                    }
                    if (value.length < 2) {
                      return 'Company name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Department Name Field
                TDTextField(
                  controller: _departmentNameController,
                  label: 'Department Name',
                  hint: 'Enter your department name',
                  prefixIcon: Icons.group_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your department name';
                    }
                    if (value.length < 2) {
                      return 'Department name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                // Setup Button
                TDButton(
                  text: 'Complete Setup',
                  onPressed: _isLoading ? null : _handleCompanySetup,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),
                // Skip Button
                TDButton(
                  text: 'Skip for Now',
                  onPressed: _isLoading ? null : () => NavigationService.instance.offAllNamed(AppRouter.dashboard),
                  variant: TDButtonVariant.outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
