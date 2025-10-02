import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum TDButtonVariant {
  filled,
  outlined,
  text,
}

class TDButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final TDButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double? height;

  const TDButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = TDButtonVariant.filled,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;

    switch (variant) {
      case TDButtonVariant.filled:
        return SizedBox(
          width: width,
          height: height ?? 48,
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              disabledBackgroundColor: AppColors.disabled,
              disabledForegroundColor: AppColors.onSurfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _buildButtonContent(),
          ),
        );

      case TDButtonVariant.outlined:
        return SizedBox(
          width: width,
          height: height ?? 48,
          child: OutlinedButton(
            onPressed: isEnabled ? onPressed : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _buildButtonContent(),
          ),
        );

      case TDButtonVariant.text:
        return SizedBox(
          width: width,
          height: height ?? 48,
          child: TextButton(
            onPressed: isEnabled ? onPressed : null,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _buildButtonContent(),
          ),
        );
    }
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.buttonMedium,
          ),
        ],
      );
    }

    return Text(
      text,
      style: AppTextStyles.buttonMedium,
    );
  }
}
