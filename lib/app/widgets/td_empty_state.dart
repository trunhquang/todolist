import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'td_button.dart';

class TDEmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;
  final Widget? customAction;

  const TDEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.actionText,
    this.onAction,
    this.customAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null || customAction != null) ...[
              const SizedBox(height: 24),
              customAction ??
                  TDButton(
                    text: actionText!,
                    onPressed: onAction,
                  ),
            ],
          ],
        ),
      ),
    );
  }
}
