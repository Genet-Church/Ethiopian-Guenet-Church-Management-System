import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/data/models/menu_item_model.dart';
import 'package:genet_church_portal/data/models/user_model.dart';
import 'package:genet_church_portal/data/repositories/auth_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class ModernNavigation extends ConsumerStatefulWidget {
  final bool isCollapsed;
  final VoidCallback? onToggle;
  final List<AppMenuItem> menuItems;

  const ModernNavigation({
    super.key,
    this.isCollapsed = false,
    this.onToggle,
    required this.menuItems,
  });

  @override
  ConsumerState<ModernNavigation> createState() => _ModernNavigationState();
}

class _ModernNavigationState extends ConsumerState<ModernNavigation>
    with TickerProviderStateMixin {
  late AnimationController _expandController;

  String? _expandedItem;
  String _currentPath = '/dashboard';

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpanded(String title) {
    if (_expandedItem == title) {
      _expandedItem = null;
      _expandController.reverse();
    } else {
      _expandedItem = title;
      _expandController.forward();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final user = ref.watch(authStateProvider);
    final currentLocation = GoRouterState.of(context).uri.path;

    if (currentLocation != _currentPath) {
      _currentPath = currentLocation;
    }

    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Container(
      width: widget.isCollapsed
          ? (isSmallScreen ? 60 : 80)
          : (isSmallScreen ? 220 : 280),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [appColors.surface, appColors.surfaceElevated],
        ),
        border: Border(
          right: BorderSide(color: appColors.borderSubtle, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: appColors.shadow.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(theme, appColors, user),
          Expanded(child: _buildMenuItems(theme, appColors, user)),
          _buildFooter(theme, appColors),
        ],
      ),
    ).animate().slideX(begin: -1, duration: 400.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildHeader(ThemeData theme, AppColors appColors, UserModel? user) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      child: Column(
        children: [
          if (!widget.isCollapsed) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: appColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(Iconsax.building_4, color: Colors.white, size: 32),
            ).animate().scale(delay: 200.ms, duration: 300.ms),
            const SizedBox(height: 16),
            Text(
              'Genet Church',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: appColors.textPrimary,
              ),
            ).animate().fadeIn(delay: 300.ms),
            Text(
              'Portal',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: appColors.textSecondary,
              ),
            ).animate().fadeIn(delay: 400.ms),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: appColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Iconsax.building_4, color: Colors.white, size: 24),
            ),
          ],
          const SizedBox(height: 24),
          if (widget.onToggle != null) _buildToggleButton(theme, appColors),
        ],
      ),
    );
  }

  Widget _buildToggleButton(ThemeData theme, AppColors appColors) {
    return GestureDetector(
      onTap: widget.onToggle,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: appColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: appColors.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          widget.isCollapsed ? Iconsax.arrow_right_3 : Iconsax.arrow_left_3,
          color: appColors.textSecondary,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildMenuItems(
    ThemeData theme,
    AppColors appColors,
    UserModel? user,
  ) {
    final filteredItems = widget.menuItems.where((item) {
      return item.roles.isEmpty ||
          (user != null && item.roles.contains(user.roleEnum));
    }).toList();

    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 16),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _buildMenuItem(item, theme, appColors, index);
      },
    );
  }

  Widget _buildMenuItem(
    AppMenuItem item,
    ThemeData theme,
    AppColors appColors,
    int index,
  ) {
    final hasChildren = item.children?.isNotEmpty ?? false;
    final isExpanded = _expandedItem == item.title;
    final isActive = _isItemActive(item);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            gradient: isActive ? appColors.primaryGradient : null,
            color: isActive
                ? null
                : (isExpanded ? appColors.surfaceElevated : null),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _handleMenuTap(item),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white.withValues(alpha: 0.2)
                            : appColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        item.icon,
                        color: isActive
                            ? Colors.white
                            : appColors.textSecondary,
                        size: 20,
                      ),
                    ),
                    if (!widget.isCollapsed) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          item.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: isActive
                                ? Colors.white
                                : appColors.textPrimary,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      if (hasChildren)
                        Icon(
                          isExpanded
                              ? Iconsax.arrow_up_2
                              : Iconsax.arrow_down_1,
                          color: isActive
                              ? Colors.white
                              : appColors.textSecondary,
                          size: 16,
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ).animate().slideX(
          begin: -0.3,
          delay: Duration(milliseconds: 100 * index),
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        ),
        if (hasChildren && !widget.isCollapsed)
          _buildSubMenu(item, theme, appColors),
      ],
    );
  }

  Widget _buildSubMenu(AppMenuItem item, ThemeData theme, AppColors appColors) {
    final isExpanded = _expandedItem == item.title;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isExpanded ? (item.children?.length ?? 0) * 48.0 : 0,
      child: ClipRect(
        child: Container(
          margin: const EdgeInsets.only(left: 16, bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: appColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: appColors.borderSubtle, width: 1),
          ),
          child: Column(
            children:
                item.children?.entries.map((entry) {
                  final isActive = _currentPath == entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => context.go(entry.value),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? appColors.accent.withValues(alpha: 0.1)
                                : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? appColors.accent
                                      : appColors.textTertiary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isActive
                                        ? appColors.accent
                                        : appColors.textSecondary,
                                    fontWeight: isActive
                                        ? FontWeight.w500
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList() ??
                [],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeData theme, AppColors appColors) {
    final user = ref.watch(authStateProvider);

    if (widget.isCollapsed) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: appColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Iconsax.user, color: appColors.textSecondary, size: 20),
        ),
      );
    }

    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [appColors.surface, appColors.surfaceElevated],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: appColors.borderSubtle, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: appColors.accentGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Iconsax.user, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user?.fullName.split(' ').first ?? 'User',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: appColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    user?.roleEnum.name.toLowerCase().replaceAll('_', ' ') ??
                        'Role',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: appColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isItemActive(AppMenuItem item) {
    if (item.path != '#' && _currentPath == item.path) {
      return true;
    }
    return item.children?.values.contains(_currentPath) ?? false;
  }

  void _handleMenuTap(AppMenuItem item) {
    if (item.children?.isNotEmpty ?? false) {
      _toggleExpanded(item.title);
    } else if (item.path != '#') {
      context.go(item.path);
    }
  }
}
