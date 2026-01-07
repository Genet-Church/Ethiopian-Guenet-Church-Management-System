import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

class DepartmentsOverviewCard extends ConsumerWidget {
  const DepartmentsOverviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departmentsAsync = ref.watch(departmentsProvider);
    final servantsAsync = ref.watch(servantsProvider);
    final appColors = Theme.of(context).extension<AppColors>()!;
    final theme = Theme.of(context);

    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 32),
      decoration: BoxDecoration(
        color: appColors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: appColors.shadow.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.2),
                          theme.colorScheme.primary.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Icon(
                      Iconsax.folder_open,
                      color: theme.colorScheme.primary,
                      size: isSmallScreen ? 20 : 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Departments',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: appColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Manage your assigned departments',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: appColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => context.go('/departments'),
                icon: const Icon(Iconsax.arrow_right_3, size: 18),
                label: const Text('View All'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          departmentsAsync.when(
            data: (departments) {
              if (departments.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: appColors.scaffold,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Iconsax.folder_open,
                            size: 48,
                            color: appColors.textSecondary.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No departments found',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: appColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton.icon(
                          onPressed: () => context.go('/departments'),
                          icon: const Icon(Iconsax.add, size: 18),
                          label: const Text('Create Department'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SizedBox(
                height: isSmallScreen ? 140 : 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: departments.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 24),
                  itemBuilder: (context, index) {
                    final dept = departments[index];

                    // Calculate servant count
                    final servantCount = servantsAsync.maybeWhen(
                      data: (servants) => servants
                          .where((s) => s.departmentId == dept.id)
                          .length,
                      orElse: () => 0,
                    );

                    return _DepartmentCard(
                      department: dept,
                      servantCount: servantCount,
                      index: index,
                    );
                  },
                ),
              );
            },
            loading: () => SizedBox(
              height: isSmallScreen ? 140 : 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (context, index) => const SizedBox(width: 24),
                itemBuilder: (context, index) => Shimmer.fromColors(
                  baseColor: appColors.shimmerBase,
                  highlightColor: appColors.shimmerHighlight,
                  child: Container(
                    width: isSmallScreen ? 180 : 240,
                    decoration: BoxDecoration(
                      color: appColors.surface,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ),
            error: (e, s) => Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Failed to load departments',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DepartmentCard extends StatefulWidget {
  final dynamic
  department; // Using dynamic to avoid import issues if model not exported
  final int servantCount;
  final int index;

  const _DepartmentCard({
    required this.department,
    required this.servantCount,
    required this.index,
  });

  @override
  State<_DepartmentCard> createState() => _DepartmentCardState();
}

class _DepartmentCardState extends State<_DepartmentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
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
    final appColors = Theme.of(context).extension<AppColors>()!;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return MouseRegion(
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
        builder: (context, child) => Transform.scale(
          scale: 1.0 + (_hoverController.value * 0.03),
          child: Transform.translate(
            offset: Offset(0, -_hoverController.value * 5),
            child: InkWell(
              onTap: () => context.go('/departments'),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: isSmallScreen ? 180 : 240,
                padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isHovered
                        ? [
                            theme.colorScheme.primary.withValues(alpha: 0.1),
                            theme.colorScheme.primary.withValues(alpha: 0.05),
                          ]
                        : [appColors.scaffold, appColors.surface],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isHovered
                        ? theme.colorScheme.primary.withValues(alpha: 0.3)
                        : appColors.border.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.05),
                      blurRadius: _isHovered ? 20 : 10,
                      offset: Offset(0, _isHovered ? 10 : 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Iconsax.folder,
                            color: theme.colorScheme.secondary,
                            size: isSmallScreen ? 20 : 24,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Active',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      widget.department.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: appColors.textPrimary,
                        fontSize: isSmallScreen ? 16 : 18,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Iconsax.people,
                          size: 16,
                          color: appColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.servantCount} Servants',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: appColors.textSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: isSmallScreen ? 12 : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (widget.index * 100).ms).slideX(begin: 0.2);
  }
}
