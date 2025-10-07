import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../widgets/td_text_field.dart';
import '../../widgets/td_button.dart';
import '../../../core/utils/validators.dart';

class ProjectEditPage extends StatefulWidget {
  const ProjectEditPage({super.key});

  @override
  State<ProjectEditPage> createState() => _ProjectEditPageState();
}

class _ProjectEditPageState extends State<ProjectEditPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _deadline;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Project'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            TDTextField(
              controller: _titleController,
              label: 'Title',
              validator: (v) => Validators.required(v, 'Title'),
            ),
            const SizedBox(height: 12),
            TDTextField(
              controller: _descriptionController,
              label: 'Description',
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _deadline ?? now,
                        firstDate: DateTime(now.year, now.month, now.day),
                        lastDate: now.add(const Duration(days: 3650)),
                      );
                      if (picked != null) {
                        setState(() => _deadline = picked);
                      }
                    },
                    child: Text(_deadline == null ? 'Pick deadline' : _deadline!.toIso8601String().split('T').first),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => _deadline = null),
                )
              ],
            ),
            const SizedBox(height: 24),
            TDButton(
              text: 'Save',
              onPressed: () {
                if (_formKey.currentState?.validate() != true) return;
                if (_deadline != null) {
                  final today = DateTime.now();
                  final startOfToday = DateTime(today.year, today.month, today.day);
                  if (_deadline!.isBefore(startOfToday)) {
                    Get.snackbar('Invalid deadline', 'Deadline must be today or later');
                    return;
                  }
                }
                // TODO: Save to database
                Get.back();
              },
            ),
            ],
          ),
        ),
      ),
    );
  }
}



