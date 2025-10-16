import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../../app/widgets/td_button.dart';

/// Enhanced error state widget with retry functionality
class TDErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? retryText;
  final bool showIcon;
  final EdgeInsets? padding;

  const TDErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
    this.retryText,
    this.showIcon = true,
    this.padding,
  });

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
                text: retryText ?? AppStrings.retry,
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
  final VoidCallback? onRetry;
  final String? customMessage;

  const TDNetworkErrorState({
    super.key,
    this.onRetry,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    return TDErrorState(
      message: customMessage ?? AppStrings.networkError,
      onRetry: onRetry,
      icon: Icons.wifi_off,
      retryText: AppStrings.checkConnection,
    );
  }
}

/// Empty state widget for when there's no data
class TDEmptyState extends StatelessWidget {
  final String message;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionText;
  final bool showAction;

  const TDEmptyState({
    super.key,
    required this.message,
    this.subtitle,
    this.icon,
    this.onAction,
    this.actionText,
    this.showAction = true,
  });

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
                text: actionText ?? AppStrings.getStarted,
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
  final String? message;
  final VoidCallback? onRequestPermission;

  const TDPermissionErrorState({
    super.key,
    this.message,
    this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    return TDErrorState(
      message: message ?? AppStrings.permissionDenied,
      onRetry: onRequestPermission,
      icon: Icons.lock_outline,
      retryText: AppStrings.requestPermission,
    );
  }
}

/// Server error state
class TDServerErrorState extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const TDServerErrorState({
    super.key,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return TDErrorState(
      message: message ?? AppStrings.serverError,
      onRetry: onRetry,
      icon: Icons.cloud_off,
      retryText: AppStrings.tryAgain,
    );
  }
}

/// Validation error state
class TDValidationErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onFix;

  const TDValidationErrorState({
    super.key,
    required this.message,
    this.onFix,
  });

  @override
  Widget build(BuildContext context) {
    return TDErrorState(
      message: message,
      onRetry: onFix,
      icon: Icons.warning_outlined,
      retryText: AppStrings.fixIssues,
    );
  }
}

/// Error state with multiple actions
class TDMultiActionErrorState extends StatelessWidget {
  final String message;
  final List<ErrorAction> actions;
  final IconData? icon;

  const TDMultiActionErrorState({
    super.key,
    required this.message,
    required this.actions,
    this.icon,
  });

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
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;

  const ErrorAction({
    required this.text,
    this.onPressed,
    this.icon,
    this.isPrimary = false,
  });
}
