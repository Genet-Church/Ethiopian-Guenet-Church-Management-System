import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/data/models/activity_log_model.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:genet_church_portal/core/settings/language_provider.dart';

import '../../../../core/localization/app_localization.dart';

class RecentActivityCard extends ConsumerWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(activityLogProvider);
    final theme = Theme.of(context);
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);
    final appColors = theme.extension<AppColors>()!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appColors.surface.withValues(alpha: 0.8),
            appColors.surface.withValues(alpha: 0.4),
          ],
        ),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Padding(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width < 600 ? 12 : 32,
          ),
          child: activityAsync.when(
            data: (allActivities) {
              final recentActivities = allActivities.take(4).toList();
              return Column(
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
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Iconsax.activity,
                              color: theme.colorScheme.primary,
                              size: MediaQuery.of(context).size.width < 600
                                  ? 20
                                  : 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.recentActivity,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                loc.latestUpdates,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: appColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (recentActivities.isEmpty)
                    _buildEmptyState(appColors)
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentActivities.length,
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 24),
                      itemBuilder: (context, index) {
                        final item = recentActivities[index];
                        return _ActivityItem(
                          activity: item,
                          isLast: index == recentActivities.length - 1,
                          index: index,
                        );
                      },
                    ),
                  if (allActivities.length > 4) ...[
                    const SizedBox(height: 32),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => context.go('/activity-log'),
                        borderRadius: BorderRadius.circular(16),
                        child: Ink(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary.withValues(alpha: 0.1),
                                theme.colorScheme.primary.withValues(alpha: 0.05),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.colorScheme.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Iconsax.arrow_right_1,
                                size: 18,
                                color: theme.colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                  ],
                ],
              );
            },
            loading: () => const _ActivityShimmer(),
            error: (error, stack) => _buildErrorState(theme),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppColors appColors) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: appColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: appColors.border.withValues(alpha: 0.5),
                ),
              ),
              child: Icon(
                Iconsax.activity,
                size: 48,
                color: appColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No recent activity',
              style: TextStyle(
                color: appColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Activities will appear here once they happen.',
              style: TextStyle(color: appColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.warning_2,
                size: 48,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Could not load activity',
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityShimmer extends StatelessWidget {
  const _ActivityShimmer();

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Shimmer.fromColors(
      baseColor: appColors.shimmerBase,
      highlightColor: appColors.shimmerHighlight,
      child: Column(
        children: List.generate(
          4,
              (index) => Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: appColors.surface,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: 120,
                        decoration: BoxDecoration(
                          color: appColors.surface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 18,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: appColors.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 14,
                        width: 200,
                        decoration: BoxDecoration(
                          color: appColors.surface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
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

class _ActivityItem extends StatefulWidget {
  final ActivityLogItem activity;
  final bool isLast;
  final int index;

  const _ActivityItem({
    required this.activity,
    this.isLast = false,
    required this.index,
  });

  @override
  State<_ActivityItem> createState() => _ActivityItemState();
}

class _ActivityItemState extends State<_ActivityItem>
    with TickerProviderStateMixin {
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

    final List<Color> gradientColors =
    widget.activity.type == ActivityType.pastor
        ? [const Color(0xFF667eea), const Color(0xFF764ba2)]
        : [const Color(0xFF11998e), const Color(0xFF38ef7d)];

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: InkWell(
        onTap: () => context.go(widget.activity.path),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: _isHovered
                ? gradientColors[0].withValues(alpha: 0.05)
                : Colors.transparent,
            border: Border.all(
              color: _isHovered
                  ? gradientColors[0].withValues(alpha: 0.2)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: isSmallScreen ? 36 : 48,
                    height: isSmallScreen ? 36 : 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: gradientColors[0].withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.activity.icon,
                      color: Colors.white,
                      size: isSmallScreen ? 18 : 22,
                    ),
                  )
                      .animate(target: _isHovered ? 1 : 0)
                      .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.1, 1.1),
                    duration: 200.ms,
                  ),
                  if (!widget.isLast)
                    Container(
                      width: 2,
                      height: 40,
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            gradientColors[0].withValues(alpha: 0.5),
                            gradientColors[0].withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: gradientColors[0].withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            timeago.format(widget.activity.timestamp),
                            style: TextStyle(
                              color: gradientColors[0],
                              fontSize: isSmallScreen ? 10 : 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (_isHovered)
                          Icon(
                            Iconsax.arrow_right_3,
                            size: 16,
                            color: gradientColors[0],
                          ).animate().fadeIn().slideX(begin: -0.5),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.activity.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 14 : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.activity.subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: appColors.textSecondary,
                        fontSize: isSmallScreen ? 12 : null,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (widget.index * 100).ms).slideX(begin: 0.1);
  }
}