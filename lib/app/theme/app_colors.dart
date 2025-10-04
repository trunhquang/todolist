import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF05812D); // rgb(5, 129, 45)
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFB8E6C1); // Light green container
  static const Color onPrimaryContainer = Color(0xFF003D0F); // Dark green text

  // Secondary Colors
  static const Color secondary = Color(0xFF03DAC6);
  static const Color onSecondary = Color(0xFF000000);
  static const Color secondaryContainer = Color(0xFFB2DFDB);
  static const Color onSecondaryContainer = Color(0xFF004D40);

  // Surface Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color surfaceVariant = Color(0xFFF3F3F3);
  static const Color onSurfaceVariant = Color(0xFF49454F);

  // Background Colors
  static const Color background = Color(0xFFFFFBFE);
  static const Color onBackground = Color(0xFF1C1B1F);

  // Error Colors
  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFF9DEDC);
  static const Color onErrorContainer = Color(0xFF410E0B);

  // Outline Colors
  static const Color outline = Color(0xFF79747E);
  static const Color outlineVariant = Color(0xFFCAC4D0);

  // Task Type Colors
  static const Color dailyTask = Color(0xFF05812D); // Same as primary
  static const Color weeklyTask = Color(0xFFFF9800);
  static const Color monthlyTask = Color(0xFF9C27B0);
  static const Color projectTask = Color(0xFF2196F3);

  // Priority Colors
  static const Color lowPriority = Color(0xFF05812D); // Same as primary
  static const Color mediumPriority = Color(0xFFFF9800);
  static const Color highPriority = Color(0xFFFF5722);
  static const Color urgentPriority = Color(0xFFF44336);

  // Status Colors
  static const Color pendingStatus = Color(0xFF9E9E9E);
  static const Color inProgressStatus = Color(0xFF2196F3);
  static const Color completedStatus = Color(0xFF05812D); // Same as primary
  static const Color cancelledStatus = Color(0xFFF44336);

  // Additional Colors
  static const Color success = Color(0xFF05812D); // Same as primary
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  static const Color disabled = Color(0xFFBDBDBD);
}
