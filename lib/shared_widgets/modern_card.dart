import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/core/theme/visual_effects.dart';

enum CardVariant {
  elevated,
  outlined,
  filled,
  glass,
  neon,
  mesh,
  floating,
  holographic,
}

class ModernCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final CardVariant variant;
  final VoidCallback? onTap;
  final bool isHoverable;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double? borderRadius;
  final Border? border;
  final List<BoxShadow>? customShadows;
  final double? elevation;
  final bool enableAnimation;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.variant = CardVariant.elevated,
    this.onTap,
    this.isHoverable = true,
    this.backgroundColor,
    this.gradient,
    this.borderRadius,
    this.border,
    this.customShadows,
    this.elevation,
    this.enableAnimation = true,
  });

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovered) {
    if (!widget.isHoverable || !mounted) return;

    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final radius = BorderRadius.circular(widget.borderRadius ?? 20);

    switch (widget.variant) {
      case CardVariant.elevated:
        return BoxDecoration(
          color: widget.backgroundColor ?? appColors.surface,
          gradient: widget.gradient ?? appColors.cardGradient,
          borderRadius: radius,
          border: widget.border,
          boxShadow:
              widget.customShadows ??
              [
                BoxShadow(
                  color: appColors.shadow.withValues(alpha: 0.12),
                  blurRadius: 48,
                  offset: const Offset(0, 20),
                  spreadRadius: -8,
                ),
                BoxShadow(
                  color: appColors.shadow.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color: appColors.shadow.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: -2,
                ),
              ],
        );

      case CardVariant.outlined:
        return BoxDecoration(
          color: widget.backgroundColor ?? Colors.transparent,
          gradient: widget.gradient,
          borderRadius: radius,
          border:
              widget.border ??
              Border.all(
                color: appColors.border.withValues(alpha: 0.3),
                width: 1.5,
              ),
        );

      case CardVariant.filled:
        return BoxDecoration(
          color:
              widget.backgroundColor ??
              appColors.surface.withValues(alpha: 0.5),
          gradient: widget.gradient,
          borderRadius: radius,
          border: widget.border,
        );

      case CardVariant.glass:
        return BoxDecoration(
          color:
              widget.backgroundColor ?? appColors.glass.withValues(alpha: 0.15),
          gradient:
              widget.gradient ??
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  appColors.glass.withValues(alpha: 0.2),
                  appColors.glass.withValues(alpha: 0.1),
                ],
              ),
          borderRadius: radius,
          border:
              widget.border ??
              Border.all(
                color: appColors.glass.withValues(alpha: 0.3),
                width: 1.5,
              ),
          boxShadow:
              widget.customShadows ??
              [
                BoxShadow(
                  color: appColors.shadow.withValues(alpha: 0.15),
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                  spreadRadius: -8,
                ),
                BoxShadow(
                  color: appColors.glass.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                  spreadRadius: -2,
                ),
              ],
        );

      case CardVariant.neon:
        return BoxDecoration(
          color:
              widget.backgroundColor ??
              appColors.surface.withValues(alpha: 0.8),
          gradient: widget.gradient,
          borderRadius: radius,
          border:
              widget.border ??
              Border.all(color: appColors.glowPrimary, width: 2.0),
          boxShadow:
              widget.customShadows ??
              VisualEffects.createGlow(
                color: appColors.glowPrimary,
                intensity: 0.6,
                blur: 24.0,
                spread: 2.0,
              ),
        );

      case CardVariant.mesh:
        return BoxDecoration(
          gradient: widget.gradient ?? appColors.meshGradient,
          borderRadius: radius,
          border: widget.border,
          boxShadow:
              widget.customShadows ??
              [
                BoxShadow(
                  color: appColors.shadow.withValues(alpha: 0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                  spreadRadius: -8,
                ),
              ],
        );

      case CardVariant.floating:
        return BoxDecoration(
          color: widget.backgroundColor ?? appColors.surface,
          gradient: widget.gradient ?? appColors.cardGradient,
          borderRadius: radius,
          border: widget.border,
          boxShadow:
              widget.customShadows ??
              VisualEffects.createFloatingShadow(
                shadowColor: appColors.floatingShadow,
                elevation: widget.elevation ?? 16.0,
              ),
        );

      case CardVariant.holographic:
        return BoxDecoration(
          gradient: widget.gradient ?? appColors.holographicGradient,
          borderRadius: radius,
          border:
              widget.border ??
              Border.all(
                color: appColors.glowAccent.withValues(alpha: 0.4),
                width: 1.5,
              ),
          boxShadow:
              widget.customShadows ??
              [
                ...VisualEffects.createGlow(
                  color: appColors.glowPrimary,
                  intensity: 0.3,
                  blur: 20.0,
                ),
                ...VisualEffects.createGlow(
                  color: appColors.glowAccent,
                  intensity: 0.2,
                  blur: 32.0,
                ),
              ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      margin: widget.margin,
      decoration: _buildDecoration(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(24.0),
              child: widget.child,
            ),
          ),
        ),
      ),
    );

    if (widget.isHoverable && widget.onTap != null) {
      cardContent = MouseRegion(
        onEnter: (_) => _onHoverChanged(true),
        onExit: (_) => _onHoverChanged(false),
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: cardContent,
            );
          },
        ),
      );
    }

    if (widget.enableAnimation) {
      cardContent = cardContent
          .animate()
          .fadeIn(duration: 400.ms, curve: Curves.easeOut)
          .slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOut);
    }

    return cardContent;
  }
}

// Specialized card variants for common use cases
class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final EdgeInsets? padding;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return ModernCard(
      onTap: onTap,
      padding: padding ?? const EdgeInsets.all(20),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (iconColor ?? theme.colorScheme.primary).withOpacity(
                  0.1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor ?? theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: appColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: appColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 16), trailing!],
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? color;
  final String? trend;
  final bool isPositiveTrend;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.color,
    this.trend,
    this.isPositiveTrend = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final cardColor = color ?? theme.colorScheme.primary;

    return ModernCard(
      onTap: onTap,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [appColors.surface, appColors.surface.withValues(alpha: 0.8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: appColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cardColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: cardColor, size: 20),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: appColors.textPrimary,
            ),
          ),
          if (subtitle != null || trend != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                if (subtitle != null)
                  Expanded(
                    child: Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: appColors.textSecondary,
                      ),
                    ),
                  ),
                if (trend != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (isPositiveTrend ? Colors.green : Colors.red)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      trend!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isPositiveTrend ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
