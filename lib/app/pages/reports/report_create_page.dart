import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/navigation_service.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../features/reports/presentation/controllers/report_controller.dart';
import '../../theme/app_colors.dart';
import '../../widgets/td_button.dart';

class ReportCreatePage extends StatefulWidget {
  const ReportCreatePage({super.key});

  @override
  State<ReportCreatePage> createState() => _ReportCreatePageState();
}

class _ReportCreatePageState extends State<ReportCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _summaryController = TextEditingController();
  final _reportController = Get.find<ReportController>();
  // Note: TaskController will be implemented in future phases
  
  final _selectedTasks = <String>{}.obs;
  final _isSubmitting = false.obs;

  @override
  void initState() {
    super.initState();
    _loadTodayTasks();
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _loadTodayTasks() async {
    // TODO: Load tasks when TaskController is available
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      _isSubmitting.value = true;
      
      final reportId = await _reportController.createDraft(
        summary: _summaryController.text.trim(),
        completedTaskIds: _selectedTasks.toList(),
      );

      if (reportId != null) {
        await _reportController.submit(reportId);
        SnackbarService().showSuccess(
          title: 'Success',
          message: 'Daily report submitted successfully!',
        );
        NavigationService().back<void>();
      } else {
        SnackbarService().showError(
          title: 'Error',
          message: 'Failed to create report',
        );
      }
    } catch (e) {
      SnackbarService().showError(
        title: 'Error',
        message: 'Failed to submit report: $e',
      );
    } finally {
      _isSubmitting.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Daily Report'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        actions: [
          Obx(() => _isSubmitting.value
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : TextButton(
                  onPressed: _submitReport,
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Report',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(DateTime.now()),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Summary Section
              Text(
                'Summary',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _summaryController,
                decoration: const InputDecoration(
                  hintText: 'Describe your work today, achievements, challenges, and plans for tomorrow...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please provide a summary of your work';
                  }
                  if (value.trim().length < 10) {
                    return 'Summary must be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Completed Tasks Section
              Text(
                'Completed Tasks',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select the tasks you completed today:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),
              
              // Task List placeholder (replace when TaskController is available)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 48,
                      color: AppColors.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No completed tasks today',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: Obx(() => TDButton(
                  text: 'Submit Daily Report',
                  onPressed: _isSubmitting.value ? null : _submitReport,
                  isLoading: _isSubmitting.value,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TODO: Implement task item builder when TaskEntity is available

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
