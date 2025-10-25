import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (mutable to support runtime theme changes)
  static Color primary = const Color(0xFF18160B); // RGB(24, 22, 11)
  static Color onPrimary = const Color(0xFFFFFFFF);
  static Color primaryContainer = const Color(0xFFE8E6D9); // Light olive container
  static Color onPrimaryContainer = const Color(0xFF0F0E08); // Dark text on light olive

  // Secondary Colors
  static Color secondary = const Color(0xFF03DAC6);
  static Color onSecondary = const Color(0xFF000000);
  static Color secondaryContainer = const Color(0xFFB2DFDB);
  static Color onSecondaryContainer = const Color(0xFF004D40);

  // Surface Colors
  static Color surface = const Color(0xFFFFFFFF);
  static Color onSurface = const Color(0xFF1C1B1F);
  static Color surfaceVariant = const Color(0xFFF3F3F3);
  static Color onSurfaceVariant = const Color(0xFF49454F);

  // Background Colors
  static Color background = const Color(0xFFFFFBFE);
  static Color onBackground = const Color(0xFF1C1B1F);

  // Error Colors
  static Color error = const Color(0xFFB3261E);
  static Color onError = const Color(0xFFFFFFFF);
  static Color errorContainer = const Color(0xFFF9DEDC);
  static Color onErrorContainer = const Color(0xFF410E0B);

  // Outline Colors
  static Color outline = const Color(0xFF79747E);
  static Color outlineVariant = const Color(0xFFCAC4D0);

  // Task Type Colors
  static Color dailyTask = const Color(0xFF18160B); // tie to primary
  static Color weeklyTask = const Color(0xFFFF9800);
  static Color monthlyTask = const Color(0xFF9C27B0);
  static Color projectTask = const Color(0xFF2196F3);

  // Priority Colors
  static Color lowPriority = const Color(0xFF18160B);
  static Color mediumPriority = const Color(0xFFFF9800);
  static Color highPriority = const Color(0xFFFF5722);
  static Color urgentPriority = const Color(0xFFF44336);

  // Status Colors
  static Color pendingStatus = const Color(0xFF9E9E9E);
  static Color inProgressStatus = const Color(0xFF2196F3);
  static Color completedStatus = const Color(0xFF18160B);
  static Color cancelledStatus = const Color(0xFFF44336);

  // Additional Colors
  static Color success = const Color(0xFF18160B);
  static Color warning = const Color(0xFFFF9800);
  static Color info = const Color(0xFF2196F3);
  static Color disabled = const Color(0xFFBDBDBD);

  // Apply a new primary color at runtime and derive related accents
  static void applyPrimary(Color newPrimary) {
    primary = newPrimary;
    // Derive containers and related colors
    primaryContainer = _tint(primary, 0.75);
    onPrimary = _contrastFor(primary);
    onPrimaryContainer = _contrastFor(primaryContainer);
    // Tie domain-specific colors to primary
    dailyTask = primary;
    lowPriority = primary;
    completedStatus = primary;
    success = primary;
  }

  static Color _tint(Color c, double amount) {
    assert(amount >= 0 && amount <= 1);
    return Color.lerp(c, Colors.white, amount) ?? c;
  }

  static Color _contrastFor(Color bg) {
    final luminance = bg.computeLuminance();
    return luminance > 0.5 ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  }
}
