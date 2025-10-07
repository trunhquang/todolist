import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../widgets/td_text_field.dart';
import '../../widgets/td_button.dart';
import '../../../core/utils/validators.dart';

class TaskEditPage extends StatefulWidget {
  const TaskEditPage({super.key});

  @override
  State<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _type = 'daily';
  String _priority = 'medium';
  String _status = 'pending';
  bool _hasDeadline = false;
  DateTime? _deadline;
  bool _isRecurring = false;
  String _frequency = 'daily';
  int _interval = 1;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Task'),
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
              validator: Validators.taskTitle,
            ),
            const SizedBox(height: 12),
            TDTextField(
              controller: _descriptionController,
              label: 'Description',
              maxLines: 4,
              validator: Validators.taskDescription,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _type,
                    items: const [
                      DropdownMenuItem(value: 'daily', child: Text('Daily')),
                      DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                      DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                      DropdownMenuItem(value: 'project', child: Text('Project')),
                    ],
                    onChanged: (v) => setState(() => _type = v ?? 'daily'),
                    decoration: const InputDecoration(labelText: 'Type'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _priority,
                    items: const [
                      DropdownMenuItem(value: 'low', child: Text('Low')),
                      DropdownMenuItem(value: 'medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'high', child: Text('High')),
                      DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                    ],
                    onChanged: (v) => setState(() => _priority = v ?? 'medium'),
                    decoration: const InputDecoration(labelText: 'Priority'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _status,
              items: const [
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
                DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
              ],
              onChanged: (v) => setState(() => _status = v ?? 'pending'),
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _hasDeadline,
              title: const Text('Has deadline'),
              onChanged: (v) => setState(() {
                _hasDeadline = v;
                if (!v) _deadline = null;
              }),
            ),
            if (_hasDeadline)
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
                        if (picked != null) setState(() => _deadline = picked);
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
            const SizedBox(height: 12),
            SwitchListTile(
              value: _isRecurring,
              title: const Text('Recurring task'),
              onChanged: (v) => setState(() => _isRecurring = v),
            ),
            if (_isRecurring)
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _frequency,
                          items: const [
                            DropdownMenuItem(value: 'daily', child: Text('Daily')),
                            DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                            DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                          ],
                          onChanged: (v) => setState(() => _frequency = v ?? 'daily'),
                          decoration: const InputDecoration(labelText: 'Frequency'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          initialValue: '1',
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Interval'),
                          onChanged: (v) => _interval = int.tryParse(v) ?? 1,
                        ),
                      ),
                    ],
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
                              initialDate: _endDate ?? now,
                              firstDate: DateTime(now.year, now.month, now.day),
                              lastDate: now.add(const Duration(days: 3650)),
                            );
                            if (picked != null) setState(() => _endDate = picked);
                          },
                          child: Text(_endDate == null ? 'Pick end date' : _endDate!.toIso8601String().split('T').first),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _endDate = null),
                      )
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 24),
            TDButton(
              text: 'Save',
              onPressed: () {
                if (_formKey.currentState?.validate() != true) return;
                if (_hasDeadline && _deadline != null) {
                  final today = DateTime.now();
                  final startOfToday = DateTime(today.year, today.month, today.day);
                  if (_deadline!.isBefore(startOfToday)) {
                    Get.snackbar('Invalid deadline', 'Deadline must be today or later');
                    return;
                  }
                }
                if (_isRecurring) {
                  if (_interval < 1) {
                    Get.snackbar('Invalid interval', 'Interval must be at least 1');
                    return;
                  }
                  if (_endDate != null) {
                    final today = DateTime.now();
                    final startOfToday = DateTime(today.year, today.month, today.day);
                    if (_endDate!.isBefore(startOfToday)) {
                      Get.snackbar('Invalid end date', 'End date must be today or later');
                      return;
                    }
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


