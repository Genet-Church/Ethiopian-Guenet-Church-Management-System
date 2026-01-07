import 'package:flutter/material.dart';

class MenuItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCollapsed;
  final int? badgeCount;

  const MenuItem({
    super.key,
    required this.title,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
    this.isCollapsed = false,
    this.badgeCount,
  });

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 4.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.isSelected) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(MenuItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: widget.isCollapsed ? widget.title : '',
        waitDuration: const Duration(milliseconds: 500),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: widget.isSelected
                      ? LinearGradient(
                    colors: [
                      primaryColor.withValues(alpha: 0.15),
                      primaryColor.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                      : null,
                  color: _isHovered && !widget.isSelected
                      ? Colors.grey.withValues(alpha: 0.08)
                      : null,
                  border: widget.isSelected
                      ? Border.all(
                    color: primaryColor.withValues(alpha: 0.3),
                    width: 1,
                  )
                      : null,
                ),
                child: Stack(
                  children: [
                    if (widget.isSelected)
                      Positioned(
                        left: 0,
                        top: 8,
                        bottom: 8,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 4,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    Transform.translate(
                      offset: Offset(_slideAnimation.value, 0),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: widget.isCollapsed ? 16 : 20,
                          vertical: 4,
                        ),
                        onTap: widget.onTap,
                        leading: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: widget.isSelected
                                    ? primaryColor.withValues(alpha: 0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                widget.icon,
                                color: widget.isSelected
                                    ? primaryColor
                                    : theme.textTheme.bodyMedium?.color
                                    ?.withValues(alpha: 0.7),
                                size: 20,
                              ),
                            ),
                            if (widget.badgeCount != null && widget.badgeCount! > 0)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  child: Text(
                                    widget.badgeCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: widget.isCollapsed
                            ? null
                            : Text(
                          widget.title,
                          style: TextStyle(
                            color: widget.isSelected
                                ? primaryColor
                                : theme.textTheme.bodyMedium?.color,
                            fontWeight: widget.isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}