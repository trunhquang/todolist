import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

/// Enhanced loading indicator with customizable message and size
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
    final theme = Theme.of(context);
    final indicatorColor = color ?? theme.primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
          ),
        ),
        if (showMessage && message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Full screen loading indicator
class TDFullScreenLoading extends StatelessWidget {

  const TDFullScreenLoading({
    super.key,
    this.message,
    this.backgroundColor,
  });
  final String? message;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: TDLoadingIndicator(
          message: message ?? AppStrings.loading,
          size: 32.0,
        ),
      ),
    );
  }
}

/// Loading overlay that can be placed over existing content
class TDLoadingOverlay extends StatelessWidget {

  const TDLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
    this.overlayColor,
  });
  final Widget child;
  final bool isLoading;
  final String? message;
  final Color? overlayColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          ColoredBox(
            color: overlayColor ?? 
                Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TDLoadingIndicator(
                  message: message ?? AppStrings.loading,
                  size: 28.0,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Skeleton loading placeholder
class TDSkeletonLoader extends StatefulWidget {

  const TDSkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  State<TDSkeletonLoader> createState() => _TDSkeletonLoaderState();
}

class _TDSkeletonLoaderState extends State<TDSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface.withOpacity(0.5),
                Theme.of(context).colorScheme.surface,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}

/// List skeleton loader for loading states
class TDListSkeletonLoader extends StatelessWidget {

  const TDListSkeletonLoader({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 60.0,
    this.padding,
  });
  final int itemCount;
  final double itemHeight;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        children: List.generate(
          itemCount,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TDSkeletonLoader(
              width: double.infinity,
              height: itemHeight,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
