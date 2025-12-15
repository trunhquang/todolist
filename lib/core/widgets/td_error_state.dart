import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../constants/app_strings_en.dart';
import '../../app/widgets/td_button.dart';

/// Enhanced error state widget with retry functionality
class TDErrorState extends StatelessWidget {

  const TDErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
    this.retryText,
    this.showIcon = true,
    this.padding,
  });
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? retryText;
  final bool showIcon;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                icon ?? Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
            ],
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              TDButton(
                text: retryText ?? AppStrings.I.retry,
                onPressed: onRetry,
                variant: TDButtonVariant.outlined,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Network error state with specific network error handling
class TDNetworkErrorState extends StatelessWidget {

  const TDNetworkErrorState({
    super.key,
    this.onRetry,
    this.customMessage,
  });
  final VoidCallback? onRetry;
  final String? customMessage;

  @override
  Widget build(BuildContext context) {
    return TDErrorState(
      message: customMessage ?? AppStrings.I.networkError,
      onRetry: onRetry,
      icon: Icons.wifi_off,
      retryText: AppStrings.I.checkConnection,
    );
  }
}

/// Empty state widget for when there's no data
class TDEmptyState extends StatelessWidget {

  const TDEmptyState({
    super.key,
    required this.message,
    this.subtitle,
    this.icon,
    this.onAction,
    this.actionText,
    this.showAction = true,
  });
  final String message;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionText;
  final bool showAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (showAction && onAction != null) ...[
              const SizedBox(height: 24),
              TDButton(
                text: actionText ?? AppStrings.I.getStarted,
                onPressed: onAction,
                icon: Icons.add,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Permission denied error state
class TDPermissionErrorState extends StatelessWidget {

  const TDPermissionErrorState({
    super.key,
    this.message,
    this.onRequestPermission,
  });
  final String? message;
  final VoidCallback? onRequestPermission;

  @override
  Widget build(BuildContext context) {
    return TDErrorState(
      message: message ?? AppStrings.I.permissionDenied,
      onRetry: onRequestPermission,
      icon: Icons.lock_outline,
      retryText: AppStrings.I.requestPermission,
    );
  }
}

/// Server error state
class TDServerErrorState extends StatelessWidget {

  const TDServerErrorState({
    super.key,
    this.message,
    this.onRetry,
  });
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return TDErrorState(
      message: message ?? AppStrings.I.serverError,
      onRetry: onRetry,
      icon: Icons.cloud_off,
      retryText: AppStrings.I.tryAgain,
    );
  }
}

/// Validation error state
class TDValidationErrorState extends StatelessWidget {

  const TDValidationErrorState({
    super.key,
    required this.message,
    this.onFix,
  });
  final String message;
  final VoidCallback? onFix;

  @override
  Widget build(BuildContext context) {
    return TDErrorState(
      message: message,
      onRetry: onFix,
      icon: Icons.warning_outlined,
      retryText: AppStrings.I.fixIssues,
    );
  }
}

/// Error state with multiple actions
class TDMultiActionErrorState extends StatelessWidget {

  const TDMultiActionErrorState({
    super.key,
    required this.message,
    required this.actions,
    this.icon,
  });
  final String message;
  final List<ErrorAction> actions;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ...actions.map((action) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: TDButton(
                  text: action.text,
                  onPressed: action.onPressed,
                  variant: action.isPrimary 
                      ? TDButtonVariant.filled 
                      : TDButtonVariant.outlined,
                  icon: action.icon,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class ErrorAction {

  const ErrorAction({
    required this.text,
    this.onPressed,
    this.icon,
    this.isPrimary = false,
  });
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;
}
