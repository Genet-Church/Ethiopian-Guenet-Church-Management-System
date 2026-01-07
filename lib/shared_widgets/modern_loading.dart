import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:iconsax/iconsax.dart';

enum LoadingType { circular, linear, dots, pulse, skeleton }

class ModernLoading extends StatefulWidget {
  final LoadingType type;
  final double? size;
  final Color? color;
  final String? message;
  final bool showMessage;
  final double strokeWidth;

  const ModernLoading({
    super.key,
    this.type = LoadingType.circular,
    this.size,
    this.color,
    this.message,
    this.showMessage = false,
    this.strokeWidth = 3.0,
  });

  @override
  State<ModernLoading> createState() => _ModernLoadingState();
}

class _ModernLoadingState extends State<ModernLoading>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final loadingColor = widget.color ?? theme.colorScheme.primary;
    final size = widget.size ?? 24.0;

    Widget loadingWidget;

    switch (widget.type) {
      case LoadingType.circular:
        loadingWidget = SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: widget.strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
          ),
        );
        break;

      case LoadingType.linear:
        loadingWidget = SizedBox(
          width: size * 4,
          child: LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
            backgroundColor: loadingColor.withValues(alpha: 0.2),
          ),
        );
        break;

      case LoadingType.dots:
        loadingWidget = AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                final delay = index * 0.2;
                final value = (_animation.value - delay).clamp(0.0, 1.0);
                final scale = (sin(value * pi) * 0.5 + 0.5).clamp(0.3, 1.0);
                
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: size * 0.1),
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      width: size * 0.3,
                      height: size * 0.3,
                      decoration: BoxDecoration(
                        color: loadingColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        );
        break;

      case LoadingType.pulse:
        loadingWidget = AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final scale = (sin(_animation.value * 2 * pi) * 0.2 + 0.8);
            return Transform.scale(
              scale: scale,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: loadingColor.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
        break;

      case LoadingType.skeleton:
        loadingWidget = _SkeletonLoader(
          width: size * 4,
          height: size,
          borderRadius: size * 0.2,
        );
        break;
    }

    if (widget.showMessage && widget.message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loadingWidget,
          const SizedBox(height: 16),
          Text(
            widget.message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: appColors.textSecondary,
            ),
          ),
        ],
      );
    }

    return loadingWidget;
  }
}

class _SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _SkeletonLoader({
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  State<_SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<_SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
              colors: [
                appColors.shimmerBase,
                appColors.shimmerHighlight,
                appColors.shimmerBase,
              ],
            ),
          ),
        );
      },
    );
  }
}

// Loading overlay for full screen loading
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final LoadingType type;
  final Color? backgroundColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.type = LoadingType.circular,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? appColors.scaffold.withValues(alpha: 0.8),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: appColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: appColors.shadow.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ModernLoading(
                  type: type,
                  message: message,
                  showMessage: message != null,
                  size: 32,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 200.ms),
      ],
    );
  }
}

// Empty state widget
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final Color? iconColor;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: (iconColor ?? appColors.textSecondary).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: iconColor ?? appColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: appColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 12),
              Text(
                subtitle!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: appColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Iconsax.add),
                label: Text(actionText!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scale(
      begin: const Offset(0.9, 0.9),
      duration: 400.ms,
      curve: Curves.easeOut,
    );
  }
}

// Error state widget
class ErrorState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorState({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onRetry,
    this.icon = Iconsax.warning_2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: appColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 12),
              Text(
                subtitle!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: appColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onRetry != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Iconsax.refresh),
                label: Text(actionText!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scale(
      begin: const Offset(0.9, 0.9),
      duration: 400.ms,
      curve: Curves.easeOut,
    );
  }
}

// Skeleton list for loading states
class SkeletonList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets? padding;

  const SkeletonList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _SkeletonLoader(
          width: double.infinity,
          height: itemHeight,
          borderRadius: 12,
        );
      },
    );
  }
}
