import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A wrapper widget that applies entrance animations to newly added items
/// with a glowing pulse effect that fades out after a specified duration.
class NewItemAnimationWrapper extends StatefulWidget {
  final Widget child;
  final bool isNew;
  final Duration highlightDuration;
  final Duration animationDuration;
  final Color? glowColor;
  final int pulseCount;

  const NewItemAnimationWrapper({
    super.key,
    required this.child,
    this.isNew = false,
    this.highlightDuration = const Duration(seconds: 3),
    this.animationDuration = const Duration(milliseconds: 600),
    this.glowColor,
    this.pulseCount = 3,
  });

  @override
  State<NewItemAnimationWrapper> createState() =>
      _NewItemAnimationWrapperState();
}

class _NewItemAnimationWrapperState extends State<NewItemAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: Duration(
        milliseconds:
            widget.highlightDuration.inMilliseconds ~/ (widget.pulseCount * 2),
      ),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    if (widget.isNew) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _isAnimating = true;
    int pulses = 0;

    void pulse() {
      if (!mounted) return;
      _glowController.forward().then((_) {
        if (!mounted) return;
        _glowController.reverse().then((_) {
          pulses++;
          if (pulses < widget.pulseCount && mounted) {
            pulse();
          } else if (mounted) {
            setState(() => _isAnimating = false);
          }
        });
      });
    }

    pulse();
  }

  @override
  void didUpdateWidget(NewItemAnimationWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isNew && !oldWidget.isNew) {
      _startAnimation();
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
    final glowColor = widget.glowColor ?? theme.colorScheme.primary;

    if (!widget.isNew) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: _isAnimating
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withValues(alpha: 0.4 * _glowAnimation.value),
                      blurRadius: 20 + (10 * _glowAnimation.value),
                      spreadRadius: 2 * _glowAnimation.value,
                    ),
                  ],
                )
              : null,
          child: child,
        );
      },
      child: widget.child
          .animate()
          .fadeIn(duration: widget.animationDuration)
          .slideX(
            begin: 0.2,
            duration: widget.animationDuration,
            curve: Curves.easeOutCubic,
          )
          .scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1.0, 1.0),
            duration: widget.animationDuration,
            curve: Curves.easeOutBack,
          ),
    );
  }
}

/// Helper extension for applying new item animation to any widget
extension NewItemAnimationExtension on Widget {
  Widget withNewItemAnimation({
    required bool isNew,
    Duration highlightDuration = const Duration(seconds: 3),
    Color? glowColor,
  }) {
    return NewItemAnimationWrapper(
      isNew: isNew,
      highlightDuration: highlightDuration,
      glowColor: glowColor,
      child: this,
    );
  }
}

/// A list tile variant with built-in new item animation
class AnimatedListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isNew;
  final EdgeInsetsGeometry? contentPadding;
  final int index;

  const AnimatedListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isNew = false,
    this.contentPadding,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      contentPadding: contentPadding,
    );

    return NewItemAnimationWrapper(
      isNew: isNew,
      child: tile
          .animate(delay: Duration(milliseconds: index * 50))
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.1, duration: 400.ms),
    );
  }
}

/// A helper class for creating animated DataRow for tables
/// Since DataRow is not a Widget, this provides static methods to create animated rows
class AnimatedDataRowHelper {
  /// Creates a DataRow with animated cell content for new items
  static DataRow createAnimatedRow({
    required DataRow row,
    required bool isNew,
    int index = 0,
  }) {
    return DataRow(
      cells: row.cells.map((cell) {
        Widget child = cell.child;
        if (isNew) {
          child = child
              .animate()
              .fadeIn(duration: 600.ms)
              .slideX(begin: 0.2, duration: 600.ms, curve: Curves.easeOutCubic);
        }
        return DataCell(
          child,
          showEditIcon: cell.showEditIcon,
          placeholder: cell.placeholder,
          onTap: cell.onTap,
        );
      }).toList(),
      selected: row.selected,
      onSelectChanged: row.onSelectChanged,
      onLongPress: row.onLongPress,
      color: row.color,
    );
  }
}
