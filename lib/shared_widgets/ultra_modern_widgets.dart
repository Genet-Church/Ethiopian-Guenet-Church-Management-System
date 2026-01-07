import 'package:flutter/material.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/core/theme/visual_effects.dart';

/// Glowing Badge with neon effect and pulse animation
class GlowingBadge extends StatefulWidget {
  final String text;
  final Color? glowColor;
  final bool isPulsing;
  final double? size;

  const GlowingBadge({
    super.key,
    required this.text,
    this.glowColor,
    this.isPulsing = true,
    this.size,
  });

  @override
  State<GlowingBadge> createState() => _GlowingBadgeState();
}

class _GlowingBadgeState extends State<GlowingBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (widget.isPulsing) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final glowColor = widget.glowColor ?? appColors.glowPrimary;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.size ?? 12,
            vertical: (widget.size ?? 12) * 0.5,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                glowColor.withValues(alpha: 0.3),
                glowColor.withValues(alpha: 0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular((widget.size ?? 12) * 1.5),
            border: Border.all(
              color: glowColor.withValues(alpha: 0.6),
              width: 1.5,
            ),
            boxShadow: VisualEffects.createGlow(
              color: glowColor,
              intensity: 0.4 * _pulseAnimation.value,
              blur: 16.0,
            ),
          ),
          child: Text(
            widget.text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: glowColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        );
      },
    );
  }
}

/// Holographic Chip with iridescent color shifting
class HolographicChip extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  const HolographicChip({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
  });

  @override
  State<HolographicChip> createState() => _HolographicChipState();
}

class _HolographicChipState extends State<HolographicChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: ModernDurations.fast,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: VisualEffects.createHolographic(
              colors: [
                appColors.glowPrimary.withValues(alpha: 0.2),
                appColors.glowAccent.withValues(alpha: 0.2),
                appColors.glowSecondary.withValues(alpha: 0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered
                  ? appColors.glowPrimary.withValues(alpha: 0.5)
                  : appColors.border.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: _isHovered
                ? VisualEffects.createGlow(
                    color: appColors.glowPrimary,
                    intensity: 0.3,
                    blur: 12.0,
                  )
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 16, color: appColors.textPrimary),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: appColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Floating Action Card with 3D depth and shadow
class FloatingActionCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final double elevation;

  const FloatingActionCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.elevation = 12.0,
  });

  @override
  State<FloatingActionCard> createState() => _FloatingActionCardState();
}

class _FloatingActionCardState extends State<FloatingActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: ModernDurations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _hoverController, curve: ModernCurves.smoothOut),
    );
    _elevationAnimation =
        Tween<double>(
          begin: widget.elevation,
          end: widget.elevation * 1.5,
        ).animate(
          CurvedAnimation(
            parent: _hoverController,
            curve: ModernCurves.smoothOut,
          ),
        );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return MouseRegion(
      onEnter: (_) {
        _hoverController.forward();
      },
      onExit: (_) {
        _hoverController.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: widget.padding ?? const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: appColors.cardGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: VisualEffects.createFloatingShadow(
                    shadowColor: appColors.floatingShadow,
                    elevation: _elevationAnimation.value,
                  ),
                ),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Neon Divider with gradient glow effect
class NeonDivider extends StatelessWidget {
  final double thickness;
  final double indent;
  final double endIndent;
  final Gradient? gradient;

  const NeonDivider({
    super.key,
    this.thickness = 2.0,
    this.indent = 0,
    this.endIndent = 0,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Container(
      margin: EdgeInsets.only(left: indent, right: endIndent),
      height: thickness,
      decoration: BoxDecoration(
        gradient: gradient ?? appColors.neonGradient,
        borderRadius: BorderRadius.circular(thickness / 2),
        boxShadow: VisualEffects.createGlow(
          color: theme.colorScheme.primary,
          intensity: 0.4,
          blur: 8.0,
        ),
      ),
    );
  }
}

/// Morphing Container with smooth shape transitions
class MorphingContainer extends StatefulWidget {
  final Widget child;
  final Duration morphDuration;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;

  const MorphingContainer({
    super.key,
    required this.child,
    this.morphDuration = const Duration(milliseconds: 600),
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  State<MorphingContainer> createState() => _MorphingContainerState();
}

class _MorphingContainerState extends State<MorphingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _morphController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _morphController = AnimationController(
      duration: widget.morphDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _morphController,
      curve: ModernCurves.bounce,
    );
    _morphController.forward();
  }

  @override
  void dispose() {
    _morphController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? appColors.surface,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Animated Gradient Background
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final Duration duration;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    required this.colors,
    this.duration = const Duration(seconds: 4),
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.colors,
              transform: GradientRotation(_animation.value * 2 * 3.14159),
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
