import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/storage_service.dart';
import 'app_colors.dart';

class ThemeController extends GetxController {
  static const String _primaryColorKey = 'primary_color_argb';
  static const String _themeModeKey = 'theme_mode';

  final Rx<Color> _primaryColor = AppColors.primary.obs;
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  Color get primaryColor => _primaryColor.value;
  ThemeMode get themeMode => _themeMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final storage = StorageService();
    final argb = storage.getSetting<int>(_primaryColorKey);
    if (argb != null) {
      final c = Color(argb);
      AppColors.applyPrimary(c);
      _primaryColor.value = c;
    }
    final modeStr = storage.getThemeMode();
    if (modeStr != null) {
      _themeMode.value = _parseThemeMode(modeStr);
    }
  }

  Future<void> setPrimaryColor(Color color) async {
    AppColors.applyPrimary(color);
    _primaryColor.value = color;
    await StorageService().setSetting(_primaryColorKey, color.value);
    update();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;
    await StorageService().setThemeMode(_themeModeToString(mode));
    update();
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }

  ThemeMode _parseThemeMode(String s) {
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}


