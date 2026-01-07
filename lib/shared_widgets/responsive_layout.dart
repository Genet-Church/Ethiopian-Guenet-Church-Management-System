import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget tabletBody;
  final Widget desktopBody;
  final double mobileBreakpoint;
  final double tabletBreakpoint;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    Widget? tabletBody,
    required this.desktopBody,
    this.mobileBreakpoint = 600,
    this.tabletBreakpoint = 1024,
  }) : tabletBody = tabletBody ?? desktopBody;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeInOutCubic,
          switchOutCurve: Curves.easeInOutCubic,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutQuart,
              ),
              child: SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0.0, 0.03),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.98, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutBack,
                    ),
                  ),
                  child: child,
                ),
              ),
            );
          },
          child: _buildResponsiveChild(constraints.maxWidth),
        );
      },
    );
  }

  Widget _buildResponsiveChild(double width) {
    if (width < mobileBreakpoint) {
      return Container(key: const ValueKey('mobile'), child: mobileBody);
    } else if (width < tabletBreakpoint) {
      return Container(key: const ValueKey('tablet'), child: tabletBody);
    } else {
      return Container(key: const ValueKey('desktop'), child: desktopBody);
    }
  }
}
