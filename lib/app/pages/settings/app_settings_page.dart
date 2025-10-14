import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme_controller.dart';
import '../../../core/constants/app_strings.dart';
import '../../../features/workspace/presentation/controllers/workspace_controller.dart';
import '../../../features/workspace/presentation/widgets/workspace_selector.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController controller = Get.find<ThemeController>();
    final Color current = controller.primaryColor;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.settings),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WorkspaceSelector(),
            const SizedBox(height: 24),
            Text(AppStrings.appearance, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _ThemeModePicker(controller: controller),
            const SizedBox(height: 24),
            Text(AppStrings.primaryColor, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _ColorPicker(
              initial: current,
              onChanged: (c) => controller.setPrimaryColor(c),
            ),
          ],
        ),
      ),
    );
  }
}


class _ThemeModePicker extends StatelessWidget {
  const _ThemeModePicker({required this.controller});
  final ThemeController controller;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final mode = controller.themeMode;
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ChoiceChip(
            label: const Text(AppStrings.lightTheme),
            selected: mode == ThemeMode.light,
            onSelected: (_) => controller.setThemeMode(ThemeMode.light),
          ),
          ChoiceChip(
            label: const Text(AppStrings.darkTheme),
            selected: mode == ThemeMode.dark,
            onSelected: (_) => controller.setThemeMode(ThemeMode.dark),
          ),
          ChoiceChip(
            label: const Text(AppStrings.systemTheme),
            selected: mode == ThemeMode.system,
            onSelected: (_) => controller.setThemeMode(ThemeMode.system),
          ),
        ],
      );
    });
  }
}

class _ColorPicker extends StatefulWidget {
  const _ColorPicker({required this.initial, required this.onChanged});
  final Color initial;
  final ValueChanged<Color> onChanged;
  @override
  State<_ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<_ColorPicker> {
  late double _hue;
  late double _saturation;
  late double _value;

  @override
  void initState() {
    super.initState();
    final hsv = HSVColor.fromColor(widget.initial);
    _hue = hsv.hue;
    _saturation = hsv.saturation;
    _value = hsv.value;
  }

  void _emit() {
    final color = HSVColor.fromAHSV(1, _hue, _saturation, _value).toColor();
    widget.onChanged(color);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final preview = HSVColor.fromAHSV(1, _hue, _saturation, _value).toColor();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: preview,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outline.withOpacity(0.3)),
          ),
        ),
        const SizedBox(height: 12),
        Text('Hue ${_hue.toStringAsFixed(0)}'),
        Slider(
          min: 0,
          max: 360,
          value: _hue,
          onChanged: (v) { _hue = v; _emit(); },
        ),
        Text('Saturation ${( _saturation * 100).toStringAsFixed(0)}%'),
        Slider(
          min: 0,
          max: 1,
          value: _saturation,
          onChanged: (v) { _saturation = v; _emit(); },
        ),
        Text('Value ${( _value * 100).toStringAsFixed(0)}%'),
        Slider(
          min: 0,
          max: 1,
          value: _value,
          onChanged: (v) { _value = v; _emit(); },
        ),
      ],
    );
  }
}


