import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:iconsax/iconsax.dart';

/// A data action button for ModernDataCard
class DataAction {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final bool isDestructive;
  final bool isLoading;

  const DataAction({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color,
    this.isDestructive = false,
    this.isLoading = false,
  });
}

/// A chip/badge for ModernDataCard
class DataChip {
  final String label;
  final IconData? icon;
  final Color? color;
  final Color? backgroundColor;

  const DataChip({
    required this.label,
    this.icon,
    this.color,
    this.backgroundColor,
  });
}

/// A beautiful, modern card for displaying data items
class ModernDataCard extends StatefulWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final String? description;
  final List<DataChip>? chips;
  final List<DataAction>? actions;
  final bool isNew;
  final VoidCallback? onTap;
  final int index;

  const ModernDataCard({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.description,
    this.chips,
    this.actions,
    this.isNew = false,
    this.onTap,
    this.index = 0,
  });

  @override
  State<ModernDataCard> createState() => _ModernDataCardState();
}

class _ModernDataCardState extends State<ModernDataCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    if (widget.isNew) {
      _glowController.repeat(reverse: true);
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _glowController.stop();
          _glowController.value = 0;
        }
      });
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    Widget cardContent = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    appColors.surface,
                    _isHovered
                        ? appColors.surface.withValues(alpha: 0.98)
                        : appColors.surface.withValues(alpha: 0.95),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isNew
                      ? Color.lerp(
                          appColors.border.withValues(alpha: 0.3),
                          theme.colorScheme.primary,
                          _glowAnimation.value,
                        )!
                      : _isHovered
                      ? theme.colorScheme.primary.withValues(alpha: 0.3)
                      : appColors.border.withValues(alpha: 0.3),
                  width: widget.isNew ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.isNew
                        ? theme.colorScheme.primary.withOpacity(
                            0.2 * _glowAnimation.value,
                          )
                        : appColors.shadow.withOpacity(
                            _isHovered ? 0.15 : 0.08,
                          ),
                    blurRadius: _isHovered ? 20 : 12,
                    offset: Offset(0, _isHovered ? 8 : 4),
                  ),
                  if (widget.isNew)
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(
                        0.15 * _glowAnimation.value,
                      ),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                ],
              ),
              transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
              child: child,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leading (Avatar/Icon)
                  if (widget.leading != null) ...[
                    widget.leading!,
                    const SizedBox(width: 16),
                  ],
                  // Title & Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: appColors.textPrimary,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: appColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // New Badge
                  if (widget.isNew)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.flash_1, size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              // Description
              if (widget.description != null) ...[
                const SizedBox(height: 12),
                Text(
                  widget.description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: appColors.textTertiary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              // Chips
              if (widget.chips != null && widget.chips!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.chips!.map((chip) {
                    return _DataChipWidget(chip: chip);
                  }).toList(),
                ),
              ],
              // Actions
              if (widget.actions != null && widget.actions!.isNotEmpty) ...[
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: widget.actions!.asMap().entries.map((entry) {
                      final index = entry.key;
                      final action = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < widget.actions!.length - 1 ? 8 : 0,
                        ),
                        child: _ActionButton(action: action),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    // Apply staggered entrance animation
    return cardContent
        .animate(delay: Duration(milliseconds: widget.index * 50))
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOutCubic);
  }
}

class _DataChipWidget extends StatelessWidget {
  final DataChip chip;

  const _DataChipWidget({required this.chip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = chip.color ?? theme.colorScheme.primary;
    final chipBg = chip.backgroundColor ?? chipColor.withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: chipColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (chip.icon != null) ...[
            Icon(chip.icon, size: 12, color: chipColor),
            const SizedBox(width: 6),
          ],
          Text(
            chip.label,
            style: TextStyle(
              color: chipColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final DataAction action;

  const _ActionButton({required this.action});

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final buttonColor = widget.action.isDestructive
        ? theme.colorScheme.error
        : widget.action.color ?? theme.colorScheme.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.action.isLoading ? null : widget.action.onPressed,
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _isHovered
                  ? buttonColor.withValues(alpha: 0.15)
                  : buttonColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: buttonColor.withValues(alpha: _isHovered ? 0.4 : 0.2),
                width: 1,
              ),
            ),
            child: widget.action.isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: buttonColor,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.action.icon, size: 14, color: buttonColor),
                      const SizedBox(width: 6),
                      Text(
                        widget.action.label,
                        style: TextStyle(
                          color: buttonColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// A responsive grid layout for ModernDataCards
class ModernDataGrid extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  const ModernDataGrid({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 16,
    this.crossAxisSpacing = 16,
    this.childAspectRatio = 1.0,
    this.shrinkWrap = true,
    this.physics,
    this.padding,
  });

  factory ModernDataGrid.responsive({
    Key? key,
    required List<Widget> children,
    required BuildContext context,
    double mainAxisSpacing = 16,
    double crossAxisSpacing = 16,
    bool shrinkWrap = true,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
  }) {
    final width = MediaQuery.of(context).size.width;
    int columns;
    if (width < 600) {
      columns = 1;
    } else if (width < 900) {
      columns = 2;
    } else if (width < 1200) {
      columns = 3;
    } else {
      columns = 4;
    }

    return ModernDataGrid(
      key: key,
      crossAxisCount: columns,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use a custom layout for better control
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - (crossAxisSpacing * (crossAxisCount - 1))) /
            crossAxisCount;

        return Wrap(
          spacing: crossAxisSpacing,
          runSpacing: mainAxisSpacing,
          children: children.map((child) {
            return SizedBox(
              width: crossAxisCount == 1 ? constraints.maxWidth : itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}

/// Avatar widget for use with ModernDataCard
class DataCardAvatar extends StatelessWidget {
  final String? initials;
  final String? imageUrl;
  final IconData? icon;
  final Color? backgroundColor;
  final double size;

  const DataCardAvatar({
    super.key,
    this.initials,
    this.imageUrl,
    this.icon,
    this.backgroundColor,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bgColor, bgColor.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(size * 0.3),
                child: Image.network(
                  imageUrl!,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildFallback(),
                ),
              )
            : _buildFallback(),
      ),
    );
  }

  Widget _buildFallback() {
    if (icon != null) {
      return Icon(icon, color: Colors.white, size: size * 0.5);
    }
    return Text(
      initials?.toUpperCase() ?? '?',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: size * 0.4,
      ),
    );
  }
}
