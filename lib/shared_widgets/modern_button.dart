import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/core/theme/visual_effects.dart';
import 'package:iconsax/iconsax.dart';

enum ButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
  gradient,
  neon,
  glass,
}

enum ButtonSize { small, medium, large }

class ModernButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Future<void> Function()? onPressedAsync;
  final IconData? icon;
  final IconData? trailingIcon;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final Color? customColor;
  final String? loadingText;
  final Widget? customChild;

  const ModernButton({
    super.key,
    required this.text,
    this.onPressed,
    this.onPressedAsync,
    this.icon,
    this.trailingIcon,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.customColor,
    this.loadingText,
    this.customChild,
  });

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pressController;
  late AnimationController _loadingController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isInternalLoading = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 0.0, end: 4.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    if (widget.isLoading) {
      _loadingController.repeat();
    }
  }

  @override
  void didUpdateWidget(ModernButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _loadingController.repeat();
      } else {
        _loadingController.stop();
      }
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pressController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  Future<void> _handlePress() async {
    if (_isInternalLoading || widget.isLoading) return;

    if (widget.onPressedAsync != null) {
      setState(() => _isInternalLoading = true);
      _loadingController.repeat();
      try {
        await widget.onPressedAsync!();
      } finally {
        if (mounted) {
          setState(() => _isInternalLoading = false);
          _loadingController.stop();
        }
      }
    } else {
      widget.onPressed?.call();
    }
  }

  void _onHoverChanged(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final isEnabled = widget.onPressed != null || widget.onPressedAsync != null;

    // Size configurations
    final sizeConfig = _getSizeConfig();

    // Color configurations
    final colorConfig = _getColorConfig(context, appColors, theme);

    return ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorConfig.disabledForeground;
        }
        return colorConfig.foreground;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorConfig.disabledBackground;
        }
        if (states.contains(WidgetState.pressed)) {
          return colorConfig.pressedBackground;
        }
        if (states.contains(WidgetState.hovered)) {
          return colorConfig.hoveredBackground;
        }
        return colorConfig.background;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (widget.variant == ButtonVariant.outline) {
          return BorderSide(
            color: states.contains(WidgetState.disabled)
                ? colorConfig.disabledBorder!
                : colorConfig.border!,
            width: 1.5,
          );
        }
        return null;
      }),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
        ),
      ),
      padding: WidgetStateProperty.all(sizeConfig.padding),
      minimumSize: WidgetStateProperty.all(
        Size(widget.isFullWidth ? double.infinity : 0, sizeConfig.height),
      ),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (widget.variant == ButtonVariant.ghost ||
            widget.variant == ButtonVariant.outline) {
          return 0;
        }
        if (states.contains(WidgetState.pressed)) return 2;
        if (states.contains(WidgetState.hovered)) return 8;
        return 4;
      }),
      shadowColor: WidgetStateProperty.all(
        colorConfig.shadow?.withValues(alpha: 0.3),
      ),
    );
  }

  _SizeConfig _getSizeConfig() {
    switch (widget.size) {
      case ButtonSize.small:
        return _SizeConfig(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          borderRadius: 12,
          fontSize: 13,
          iconSize: 16,
        );
      case ButtonSize.medium:
        return _SizeConfig(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          borderRadius: 14,
          fontSize: 14,
          iconSize: 18,
        );
      case ButtonSize.large:
        return _SizeConfig(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          borderRadius: 16,
          fontSize: 16,
          iconSize: 20,
        );
    }
  }

  _ColorConfig _getColorConfig(
    BuildContext context,
    AppColors appColors,
    ThemeData theme,
  ) {
    final customColor = widget.customColor;

    switch (widget.variant) {
      case ButtonVariant.primary:
        return _ColorConfig(
          foreground: Colors.white,
          background: customColor ?? theme.colorScheme.primary,
          hoveredBackground: (customColor ?? theme.colorScheme.primary)
              .withValues(alpha: 0.9),
          pressedBackground: (customColor ?? theme.colorScheme.primary)
              .withValues(alpha: 0.8),
          disabledBackground: appColors.textSecondary.withValues(alpha: 0.3),
          disabledForeground: appColors.textSecondary.withValues(alpha: 0.5),
          shadow: customColor ?? theme.colorScheme.primary,
        );

      case ButtonVariant.secondary:
        return _ColorConfig(
          foreground: appColors.textPrimary,
          background: appColors.surface,
          hoveredBackground: appColors.surface.withValues(alpha: 0.8),
          pressedBackground: appColors.surface.withValues(alpha: 0.6),
          disabledBackground: appColors.surface.withValues(alpha: 0.3),
          disabledForeground: appColors.textSecondary.withValues(alpha: 0.5),
          shadow: appColors.shadow,
        );

      case ButtonVariant.outline:
        return _ColorConfig(
          foreground: customColor ?? theme.colorScheme.primary,
          background: Colors.transparent,
          hoveredBackground: (customColor ?? theme.colorScheme.primary)
              .withValues(alpha: 0.05),
          pressedBackground: (customColor ?? theme.colorScheme.primary)
              .withValues(alpha: 0.1),
          disabledBackground: Colors.transparent,
          disabledForeground: appColors.textSecondary.withValues(alpha: 0.5),
          border: customColor ?? theme.colorScheme.primary,
          disabledBorder: appColors.textSecondary.withValues(alpha: 0.3),
        );

      case ButtonVariant.ghost:
        return _ColorConfig(
          foreground: customColor ?? appColors.textPrimary,
          background: Colors.transparent,
          hoveredBackground: appColors.surface.withValues(alpha: 0.5),
          pressedBackground: appColors.surface.withValues(alpha: 0.7),
          disabledBackground: Colors.transparent,
          disabledForeground: appColors.textSecondary.withValues(alpha: 0.5),
        );

      case ButtonVariant.destructive:
        return _ColorConfig(
          foreground: Colors.white,
          background: theme.colorScheme.error,
          hoveredBackground: theme.colorScheme.error.withValues(alpha: 0.9),
          pressedBackground: theme.colorScheme.error.withValues(alpha: 0.8),
          disabledBackground: appColors.textSecondary.withValues(alpha: 0.3),
          disabledForeground: appColors.textSecondary.withValues(alpha: 0.5),
          shadow: theme.colorScheme.error,
        );

      case ButtonVariant.gradient:
        return _ColorConfig(
          foreground: Colors.white,
          background: theme.colorScheme.primary,
          hoveredBackground: theme.colorScheme.primary.withValues(alpha: 0.9),
          pressedBackground: theme.colorScheme.primary.withValues(alpha: 0.8),
          disabledBackground: appColors.textSecondary.withValues(alpha: 0.3),
          disabledForeground: appColors.textSecondary.withValues(alpha: 0.5),
          shadow: theme.colorScheme.primary,
          isGradient: true,
        );

      case ButtonVariant.neon:
        return _ColorConfig(
          foreground: appColors.glowPrimary,
          background: appColors.surface.withValues(alpha: 0.1),
          hoveredBackground: appColors.glowPrimary.withValues(alpha: 0.15),
          pressedBackground: appColors.glowPrimary.withValues(alpha: 0.25),
          disabledBackground: Colors.transparent,
          disabledForeground: appColors.textSecondary.withValues(alpha: 0.5),
          border: appColors.glowPrimary,
          disabledBorder: appColors.textSecondary.withValues(alpha: 0.3),
          shadow: appColors.glowPrimary,
          isNeon: true,
        );

      case ButtonVariant.glass:
        return _ColorConfig(
          foreground: appColors.textPrimary,
          background: appColors.glass.withValues(alpha: 0.2),
          hoveredBackground: appColors.glass.withValues(alpha: 0.3),
          pressedBackground: appColors.glass.withValues(alpha: 0.4),
          disabledBackground: appColors.surface.withValues(alpha: 0.1),
          disabledForeground: appColors.textSecondary.withValues(alpha: 0.5),
          border: appColors.border.withValues(alpha: 0.3),
          disabledBorder: appColors.textSecondary.withValues(alpha: 0.2),
          isGlass: true,
        );
    }
  }

  Widget _buildButtonContent() {
    final sizeConfig = _getSizeConfig();
    final isLoading = widget.isLoading || _isInternalLoading;
    final loadingText = widget.loadingText ?? 'Loading...';

    if (widget.customChild != null && !isLoading) {
      return widget.customChild!;
    }

    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: sizeConfig.iconSize,
            height: sizeConfig.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            loadingText,
            style: TextStyle(
              fontSize: sizeConfig.fontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: sizeConfig.iconSize),
          const SizedBox(width: 8),
        ],
        Text(
          widget.text,
          style: TextStyle(
            fontSize: sizeConfig.fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        if (widget.trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(widget.trailingIcon, size: sizeConfig.iconSize),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled =
        (widget.onPressed != null || widget.onPressedAsync != null) &&
        !widget.isLoading &&
        !_isInternalLoading;

    Widget button = AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _pressController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * (1.0 - _pressController.value * 0.02),
          child: ElevatedButton(
            onPressed: isEnabled ? _handlePress : null,
            style: _getButtonStyle(context),
            child: _buildButtonContent(),
          ),
        );
      },
    );

    if (isEnabled) {
      button = MouseRegion(
        onEnter: (_) => _onHoverChanged(true),
        onExit: (_) => _onHoverChanged(false),
        child: GestureDetector(
          onTapDown: (_) => _pressController.forward(),
          onTapUp: (_) => _pressController.reverse(),
          onTapCancel: () => _pressController.reverse(),
          child: button,
        ),
      );
    }

    return button
        .animate()
        .fadeIn(duration: 300.ms)
        .scale(
          begin: const Offset(0.95, 0.95),
          duration: 300.ms,
          curve: Curves.easeOutBack,
        );
  }
}

class _SizeConfig {
  final double height;
  final EdgeInsets padding;
  final double borderRadius;
  final double fontSize;
  final double iconSize;

  _SizeConfig({
    required this.height,
    required this.padding,
    required this.borderRadius,
    required this.fontSize,
    required this.iconSize,
  });
}

class _ColorConfig {
  final Color foreground;
  final Color background;
  final Color hoveredBackground;
  final Color pressedBackground;
  final Color disabledBackground;
  final Color disabledForeground;
  final Color? border;
  final Color? disabledBorder;
  final Color? shadow;
  final bool isGradient;
  final bool isNeon;
  final bool isGlass;

  _ColorConfig({
    required this.foreground,
    required this.background,
    required this.hoveredBackground,
    required this.pressedBackground,
    required this.disabledBackground,
    required this.disabledForeground,
    this.border,
    this.disabledBorder,
    this.shadow,
    this.isGradient = false,
    this.isNeon = false,
    this.isGlass = false,
  });
}

// Convenience constructors for common button types
class PrimaryButton extends ModernButton {
  const PrimaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.onPressedAsync,
    super.icon,
    super.trailingIcon,
    super.size = ButtonSize.medium,
    super.isLoading = false,
    super.isFullWidth = false,
    super.loadingText,
  }) : super(variant: ButtonVariant.primary);
}

class SecondaryButton extends ModernButton {
  const SecondaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.onPressedAsync,
    super.icon,
    super.trailingIcon,
    super.size = ButtonSize.medium,
    super.isLoading = false,
    super.isFullWidth = false,
    super.loadingText,
  }) : super(variant: ButtonVariant.secondary);
}

class OutlineButton extends ModernButton {
  const OutlineButton({
    super.key,
    required super.text,
    super.onPressed,
    super.onPressedAsync,
    super.icon,
    super.trailingIcon,
    super.size = ButtonSize.medium,
    super.isLoading = false,
    super.isFullWidth = false,
    super.customColor,
    super.loadingText,
  }) : super(variant: ButtonVariant.outline);
}

class GhostButton extends ModernButton {
  const GhostButton({
    super.key,
    required super.text,
    super.onPressed,
    super.onPressedAsync,
    super.icon,
    super.trailingIcon,
    super.size = ButtonSize.medium,
    super.isLoading = false,
    super.isFullWidth = false,
    super.customColor,
    super.loadingText,
  }) : super(variant: ButtonVariant.ghost);
}

class DestructiveButton extends ModernButton {
  const DestructiveButton({
    super.key,
    required super.text,
    super.onPressed,
    super.onPressedAsync,
    super.icon = Iconsax.trash,
    super.trailingIcon,
    super.size = ButtonSize.medium,
    super.isLoading = false,
    super.isFullWidth = false,
    super.loadingText,
  }) : super(variant: ButtonVariant.destructive);
}
