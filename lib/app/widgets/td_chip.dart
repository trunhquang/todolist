import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum TDChipType {
  primary,
  secondary,
  success,
  warning,
  error,
  info,
}

class TDChip extends StatelessWidget {
  final String label;
  final TDChipType type;
  final IconData? icon;
  final VoidCallback? onDeleted;
  final bool isSelected;
  final VoidCallback? onTap;

  const TDChip({
    super.key,
    required this.label,
    this.type = TDChipType.primary,
    this.icon,
    this.onDeleted,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors['selected'] : colors['background'],
          border: Border.all(
            color: isSelected ? colors['selected']! : colors['border']!,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.onPrimary : colors['text'],
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected ? AppColors.onPrimary : colors['text'],
                fontWeight: FontWeight.w500,
              ),
            ),
            if (onDeleted != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onDeleted,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: isSelected ? AppColors.onPrimary : colors['text'],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Map<String, Color> _getColors() {
    switch (type) {
      case TDChipType.primary:
        return {
          'background': AppColors.primaryContainer,
          'selected': AppColors.primary,
          'border': AppColors.primary,
          'text': AppColors.onPrimaryContainer,
        };
      case TDChipType.secondary:
        return {
          'background': AppColors.secondaryContainer,
          'selected': AppColors.secondary,
          'border': AppColors.secondary,
          'text': AppColors.onSecondaryContainer,
        };
      case TDChipType.success:
        return {
          'background': AppColors.success.withOpacity(0.1),
          'selected': AppColors.success,
          'border': AppColors.success,
          'text': AppColors.success,
        };
      case TDChipType.warning:
        return {
          'background': AppColors.warning.withOpacity(0.1),
          'selected': AppColors.warning,
          'border': AppColors.warning,
          'text': AppColors.warning,
        };
      case TDChipType.error:
        return {
          'background': AppColors.errorContainer,
          'selected': AppColors.error,
          'border': AppColors.error,
          'text': AppColors.onErrorContainer,
        };
      case TDChipType.info:
        return {
          'background': AppColors.info.withOpacity(0.1),
          'selected': AppColors.info,
          'border': AppColors.info,
          'text': AppColors.info,
        };
    }
  }
}
