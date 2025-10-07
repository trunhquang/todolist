import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TDLoadingIndicator extends StatelessWidget {
  const TDLoadingIndicator({
    super.key,
    this.message,
    this.size = 24.0,
    this.color,
    this.showMessage = true,
  });

  final String? message;
  final double size;
  final Color? color;
  final bool showMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.primary,
              ),
            ),
          ),
          if (showMessage && message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class TDLoadingOverlay extends StatelessWidget {
  const TDLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingMessage,
    this.overlayColor,
  });

  final Widget child;
  final bool isLoading;
  final String? loadingMessage;
  final Color? overlayColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          ColoredBox(
            color: overlayColor ?? Colors.black.withValues(alpha: 0.3),
            child: TDLoadingIndicator(
              message: loadingMessage,
              showMessage: loadingMessage != null,
            ),
          ),
      ],
    );
  }
}
