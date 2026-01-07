import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/core/theme/visual_effects.dart';
import 'package:genet_church_portal/data/models/menu_item_model.dart';
import 'package:genet_church_portal/data/models/user_model.dart';
import 'package:genet_church_portal/data/repositories/auth_repository.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:genet_church_portal/shared_widgets/notification_system.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:genet_church_portal/core/settings/language_provider.dart';

import '../core/localization/app_localization.dart';

// Removed static list to allow localization in build method

class SideMenu extends ConsumerWidget {
  final bool isCollapsed;
  const SideMenu({super.key, required this.isCollapsed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final user = ref.watch(authStateProvider);
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);

    final List<AppMenuItem> allMenuItems = [
      AppMenuItem(
        title: loc.navDashboard,
        path: '/dashboard',
        icon: Iconsax.category,
      ),
      AppMenuItem(
        title: loc.navChurchAdmin,
        path: '#',
        icon: Iconsax.building_4,
        roles: [UserRole.SUPER_ADMIN, UserRole.PASTOR],
        children: {
          loc.navChurches: '/report-churchs',
          loc.navPastors: '/report-pastors',
          loc.navDepartments: '/departments',
          loc.navServants: '/report-servants',
        },
      ),
      AppMenuItem(
        title: loc.navMembers,
        path: '#',
        icon: Iconsax.people,
        roles: [UserRole.PASTOR, UserRole.SERVANT, UserRole.SUPER_ADMIN],
        children: {
          loc.navAddMember: '/add-members',
          loc.navShowMembers: '/show-members',
        },
      ),
      AppMenuItem(
        title: loc.navAnalytics,
        path: '/advanced-reports',
        icon: Iconsax.chart_21,
        roles: [UserRole.SUPER_ADMIN],
      ),

      AppMenuItem(
        title: loc.navSettings,
        path: '/settings',
        icon: Iconsax.setting_2,
        roles: [UserRole.SUPER_ADMIN, UserRole.PASTOR, UserRole.SERVANT],
      ),
    ];

    if (user == null) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubicEmphasized,
          width: isCollapsed ? 85 : 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                appColors.surface.withValues(alpha: 0.95),
                appColors.surface.withValues(alpha: 0.85),
                appColors.surface.withValues(alpha: 0.90),
                appColors.surface.withValues(alpha: 0.95),
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
            border: Border(
              right: BorderSide(
                color: appColors.glowPrimary.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: appColors.shadow.withValues(alpha: 0.12),
                blurRadius: 48,
                offset: const Offset(8, 0),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: appColors.glowPrimary.withValues(alpha: 0.03),
                blurRadius: 80,
                offset: const Offset(16, 0),
                spreadRadius: 0,
              ),
              // Subtle inner glow
              BoxShadow(
                color: appColors.glowPrimary.withValues(alpha: 0.02),
                blurRadius: 24,
                offset: const Offset(-2, 0),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Column(
                children: [
                  _Header(isCollapsed: isCollapsed),
                  Expanded(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 32,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              _buildMenuItems(
                                user,
                                context,
                                ref,
                                isCollapsed,
                                allMenuItems,
                                loc,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        )
        .animate()
        .slideX(
          begin: -1,
          duration: 600.ms,
          curve: Curves.easeInOutCubicEmphasized,
        )
        .fadeIn(duration: 400.ms, delay: 100.ms);
  }

  List<Widget> _buildMenuItems(
    UserModel user,
    BuildContext context,
    WidgetRef ref,
    bool collapsed,
    List<AppMenuItem> menuItems,
    AppLocalization loc,
  ) {
    final currentRole = user.roleEnum;
    final pastor = ref.watch(currentPastorProvider);
    final isPastorUnassigned =
        currentRole == UserRole.PASTOR && pastor.value?.churchId == null;
    final currentRoute = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.toString();
    final accessibleItems = menuItems.where(
      (item) => item.roles.contains(currentRole),
    );

    return accessibleItems.map((item) {
      final isProtected =
          (item.title == loc.navMembers || item.title == loc.navChurchAdmin) &&
          isPastorUnassigned;

      if (isProtected) {
        return _DisabledMenuItem(
          title: item.title,
          icon: item.icon,
          isCollapsed: collapsed,
          loc: loc,
        );
      }

      if (item.children != null) {
        Map<String, String> accessibleChildren = Map.from(item.children!);

        if (currentRole == UserRole.SUPER_ADMIN) {
          if (item.title == loc.navMembers) {
            accessibleChildren.removeWhere(
              (key, value) => key == loc.navAddMember,
            );
          }
        } else if (currentRole == UserRole.PASTOR) {
          if (item.title == loc.navChurchAdmin) {
            accessibleChildren.removeWhere(
              (key, value) => key == loc.navChurches || key == loc.navPastors,
            );
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _ExpansionMenuItem(
            title: item.title,
            icon: item.icon,
            isCollapsed: collapsed,
            children: accessibleChildren,
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _MenuItem(
            title: item.title,
            icon: item.icon,
            isSelected: currentRoute.startsWith(item.path),
            onTap: () {
              context.go(item.path);
              try {
                Scaffold.of(context).closeDrawer();
              } catch (_) {}
            },
            isCollapsed: collapsed,
          ),
        );
      }
    }).toList();
  }
}

class _Header extends ConsumerWidget {
  final bool isCollapsed;
  const _Header({required this.isCollapsed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubicEmphasized,
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 12 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            appColors.surface,
            appColors.surface.withValues(alpha: 0.95),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: appColors.border.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Center(
        child: isCollapsed
            ? Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.primaryColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Image.asset('assets/images/logo.png', height: 32),
                  )
                  .animate()
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    duration: 300.ms,
                    delay: 200.ms,
                    curve: Curves.easeOutBack,
                  )
                  .fadeIn(delay: 150.ms)
            : Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: theme.primaryColor.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 44,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.navDashboard,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: appColors.textPrimary,
                                letterSpacing: -0.5,
                                height: 1.0,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                loc.churchManagement,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                  .animate()
                  .slideX(
                    begin: -0.3,
                    duration: 400.ms,
                    delay: 200.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .fadeIn(delay: 150.ms),
      ),
    );
  }
}

class _MenuItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCollapsed;

  const _MenuItem({
    required this.title,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
    this.isCollapsed = false,
  });

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Tooltip(
      message: widget.isCollapsed ? widget.title : '',
      waitDuration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.border),
        boxShadow: [
          BoxShadow(
            color: appColors.shadow.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      textStyle: TextStyle(
        color: appColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: MouseRegion(
          onEnter: (_) {
            setState(() => _isHovered = true);
            _animationController.forward();
          },
          onExit: (_) {
            setState(() => _isHovered = false);
            _animationController.reverse();
          },
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubicEmphasized,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: widget.isSelected
                              ? LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    theme.primaryColor.withValues(alpha: 0.15),
                                    theme.primaryColor.withValues(alpha: 0.08),
                                    theme.primaryColor.withValues(alpha: 0.05),
                                  ],
                                )
                              : _isHovered
                              ? LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    theme.primaryColor.withValues(alpha: 0.08),
                                    theme.primaryColor.withValues(alpha: 0.04),
                                    Colors.transparent,
                                  ],
                                )
                              : null,
                          borderRadius: BorderRadius.circular(16),
                          border: widget.isSelected
                              ? Border.all(
                                  color: theme.primaryColor.withValues(
                                    alpha: 0.2,
                                  ),
                                  width: 1,
                                )
                              : _isHovered
                              ? Border.all(
                                  color: theme.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  width: 1,
                                )
                              : null,
                          boxShadow: widget.isSelected
                              ? [
                                  BoxShadow(
                                    color: theme.primaryColor.withValues(
                                      alpha: 0.1,
                                    ),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                  BoxShadow(
                                    color: theme.primaryColor.withValues(
                                      alpha: 0.05,
                                    ),
                                    blurRadius: 32,
                                    offset: const Offset(0, 8),
                                  ),
                                ]
                              : _isHovered
                              ? [
                                  BoxShadow(
                                    color: theme.primaryColor.withValues(
                                      alpha: 0.05,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      if (widget.isSelected)
                        Positioned(
                          left: 0,
                          top: 12,
                          bottom: 12,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  appColors.glowPrimary,
                                  theme.primaryColor,
                                  appColors.glowPrimary.withValues(alpha: 0.7),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(4),
                              ),
                              boxShadow: VisualEffects.createGlow(
                                color: appColors.glowPrimary,
                                intensity: 0.5,
                                blur: 12.0,
                              ),
                            ),
                          ),
                        ).animate().scaleY(
                          begin: 0.5,
                          duration: 300.ms,
                          curve: Curves.easeOutBack,
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.isCollapsed ? 12 : 20,
                        ),
                        child: Row(
                          mainAxisAlignment: widget.isCollapsed
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: widget.isSelected
                                    ? theme.primaryColor.withValues(alpha: 0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                widget.icon,
                                size: 22,
                                color: widget.isSelected
                                    ? theme.primaryColor
                                    : _isHovered
                                    ? theme.primaryColor.withValues(alpha: 0.8)
                                    : appColors.textSecondary,
                              ),
                            ),
                            if (!widget.isCollapsed) ...[
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: widget.isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: widget.isSelected
                                        ? theme.primaryColor
                                        : _isHovered
                                        ? appColors.textPrimary
                                        : appColors.textSecondary,
                                    letterSpacing: widget.isSelected ? -0.2 : 0,
                                  ),
                                ),
                              ),
                              if (widget.isSelected)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Iconsax.arrow_right_3,
                                    size: 14,
                                    color: theme.primaryColor,
                                  ),
                                ).animate().scale(
                                  begin: const Offset(0.8, 0.8),
                                  duration: 200.ms,
                                  delay: 100.ms,
                                ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _DisabledMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isCollapsed;

  const _DisabledMenuItem({
    required this.title,
    required this.icon,
    required this.isCollapsed,
    required this.loc,
  });

  final AppLocalization loc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final disabledColor = appColors.textSecondary.withValues(alpha: 0.5);

    final tooltipMessage = isCollapsed
        ? '$title ${loc.assignToEnable}'
        : loc.mustBeAssigned;

    return Tooltip(
      message: tooltipMessage,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: InkWell(
          onTap: () {
            context.showInfoNotification(
              title: loc.actionDisabled,
              message: loc.contactAdmin,
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: appColors.scaffold.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 12 : 20),
              child: Row(
                mainAxisAlignment: isCollapsed
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Icon(icon, size: 22, color: disabledColor),
                  if (!isCollapsed) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: disabledColor,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpansionMenuItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isCollapsed;
  final Map<String, String> children;

  const _ExpansionMenuItem({
    required this.title,
    required this.icon,
    required this.isCollapsed,
    required this.children,
  });

  @override
  State<_ExpansionMenuItem> createState() => _ExpansionMenuItemState();
}

class _ExpansionMenuItemState extends State<_ExpansionMenuItem>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _hoverAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
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
    final currentRoute = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.toString();
    final bool isExpanded = widget.children.values.any(
      (route) => currentRoute.startsWith(route),
    );

    if (widget.isCollapsed) {
      return Tooltip(
        message: widget.title,
        waitDuration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: appColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appColors.border),
          boxShadow: [
            BoxShadow(
              color: appColors.shadow.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 16,
          color: appColors.surface,
          shadowColor: appColors.shadow.withValues(alpha: 0.2),
          itemBuilder: (context) {
            return widget.children.entries.map((entry) {
              return PopupMenuItem(
                value: entry.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.arrow_right_3,
                        size: 16,
                        color: appColors.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: appColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList();
          },
          onSelected: (path) {
            context.go(path);
            try {
              Scaffold.of(context).closeDrawer();
            } catch (_) {}
          },
          child: MouseRegion(
            onEnter: (_) {
              setState(() => _isHovered = true);
              _hoverController.forward();
            },
            onExit: (_) {
              setState(() => _isHovered = false);
              _hoverController.reverse();
            },
            child: AnimatedBuilder(
              animation: _hoverController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _hoverAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubicEmphasized,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: isExpanded
                            ? LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  theme.primaryColor.withValues(alpha: 0.15),
                                  theme.primaryColor.withValues(alpha: 0.05),
                                ],
                              )
                            : _isHovered
                            ? LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  theme.primaryColor.withValues(alpha: 0.08),
                                  Colors.transparent,
                                ],
                              )
                            : null,
                        borderRadius: BorderRadius.circular(16),
                        border: isExpanded
                            ? Border.all(
                                color: theme.primaryColor.withValues(
                                  alpha: 0.2,
                                ),
                                width: 1,
                              )
                            : null,
                      ),
                      child: Center(
                        child: Icon(
                          widget.icon,
                          size: 22,
                          color: isExpanded
                              ? theme.primaryColor
                              : _isHovered
                              ? theme.primaryColor.withValues(alpha: 0.8)
                              : appColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _hoverController.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _hoverController.reverse();
        },
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.scale(
              scale: _hoverAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: isExpanded
                      ? LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            theme.primaryColor.withValues(alpha: 0.1),
                            theme.primaryColor.withValues(alpha: 0.05),
                            Colors.transparent,
                          ],
                        )
                      : _isHovered
                      ? LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            theme.primaryColor.withValues(alpha: 0.05),
                            Colors.transparent,
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(16),
                  border: isExpanded
                      ? Border.all(
                          color: theme.primaryColor.withValues(alpha: 0.15),
                          width: 1,
                        )
                      : null,
                ),
                child: Theme(
                  data: theme.copyWith(
                    dividerColor: Colors.transparent,
                    expansionTileTheme: ExpansionTileThemeData(
                      backgroundColor: Colors.transparent,
                      collapsedBackgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: isExpanded,
                    leading: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isExpanded
                            ? theme.primaryColor.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 22,
                        color: isExpanded
                            ? theme.primaryColor
                            : _isHovered
                            ? theme.primaryColor.withValues(alpha: 0.8)
                            : appColors.textSecondary,
                      ),
                    ),
                    title: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isExpanded
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isExpanded
                            ? theme.primaryColor
                            : _isHovered
                            ? appColors.textPrimary
                            : appColors.textSecondary,
                        letterSpacing: isExpanded ? -0.2 : 0,
                      ),
                    ),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 20),
                    childrenPadding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 12,
                      top: 8,
                    ),
                    trailing: Icon(
                      isExpanded ? Iconsax.arrow_up_2 : Iconsax.arrow_down_2,
                      size: 18,
                      color: isExpanded
                          ? theme.primaryColor
                          : appColors.textSecondary,
                    ),
                    children: widget.children.entries.map((entry) {
                      final isSelected = currentRoute.startsWith(entry.value);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: _MenuItem(
                          title: entry.key,
                          icon: Iconsax.arrow_right_3,
                          isCollapsed: false,
                          isSelected: isSelected,
                          onTap: () {
                            context.go(entry.value);
                            try {
                              Scaffold.of(context).closeDrawer();
                            } catch (_) {}
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
