import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:genet_church_portal/core/settings/date_format_provider.dart';
import 'package:genet_church_portal/data/models/dashboard_model.dart';
import 'package:genet_church_portal/data/models/pastor_dashboard_model.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/features/dashboard/presentation/widgets/clock_painter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:genet_church_portal/core/settings/language_provider.dart';

import 'package:abushakir/abushakir.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_localization.dart';
import '../../../../data/models/dashboard_base_model.dart';

class AnalyticsCard extends HookConsumerWidget {
  const AnalyticsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return statsAsync.when(
      data: (stats) {
        if (stats == null) {
          return const SizedBox.shrink();
        }
        return _AnalyticsCardContent(stats: stats);
      },
      loading: () => const _AnalyticsCardShimmer(),
      error: (e, s) {
        final appColors = Theme.of(context).extension<AppColors>()!;
        final locale = ref.watch(languageNotifierProvider);
        final loc = AppLocalization(locale);
        return Container(
          height: 600,
          decoration: BoxDecoration(
            color: appColors.surface,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: appColors.border.withValues(alpha: 0.5)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.warning_2,
                  color: Colors.red.withValues(alpha: 0.7),
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  loc.couldNotLoadAnalytics,
                  style: TextStyle(
                    color: appColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnalyticsCardContent extends HookConsumerWidget {
  final DashboardStatsBase stats;
  const _AnalyticsCardContent({required this.stats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);
    final chartController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
    );

    useEffect(() {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) chartController.forward();
      });
      return null;
    }, [chartController]);

    int churches = 0;
    int pastors = 0;
    int servants = 0;

    if (stats is SuperAdminDashboardStats) {
      final s = stats as SuperAdminDashboardStats;
      churches = s.totals?.totalChurches ?? 0;
      pastors = s.totals?.totalPastors ?? 0;
      servants = s.totals?.totalServants ?? 0;
    } else if (stats is PastorDashboardStats) {
      final p = stats as PastorDashboardStats;
      servants = p.totals?.totalServants ?? 0;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 900;

        return Column(
          children: [
            // Calendar and Time Section
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.secondary,
                    theme.colorScheme.secondary.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Decorative circles
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.1),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Flex(
                    direction: isSmallScreen ? Axis.vertical : Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      isSmallScreen
                          ? _Calendar(isSmallScreen: isSmallScreen)
                          : Expanded(
                              flex: 3,
                              child: _Calendar(isSmallScreen: isSmallScreen),
                            ),
                      SizedBox(
                        width: isSmallScreen ? 0 : 32,
                        height: isSmallScreen ? 32 : 0,
                      ),
                      isSmallScreen
                          ? _TimeAndHoliday(isSmallScreen: isSmallScreen)
                          : Expanded(
                              flex: 2,
                              child: _TimeAndHoliday(
                                isSmallScreen: isSmallScreen,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Stats Summary Section
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: appColors.surface,
                border: Border.all(
                  color: appColors.border.withValues(alpha: 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: appColors.shadow.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        loc.quickStats,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (stats is SuperAdminDashboardStats)
                        TextButton.icon(
                          onPressed: () => context.go('/advanced-reports'),
                          icon: const Icon(Iconsax.chart_21, size: 18),
                          label: Text(loc.viewFullReport),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    alignment: WrapAlignment.center,
                    children: [
                      if (stats is SuperAdminDashboardStats) ...[
                        _IconStat(
                          icon: Iconsax.building,
                          value: churches.toString(),
                          label: loc.navChurches,
                          color: theme.colorScheme.primary,
                        ),
                        _IconStat(
                          icon: Iconsax.user_octagon,
                          value: pastors.toString(),
                          label: loc.navPastors,
                          color: theme.colorScheme.secondary,
                        ),
                      ],
                      _IconStat(
                        icon: Iconsax.lifebuoy,
                        value: servants.toString(),
                        label: loc.navServants,
                        color: const Color(0xFF0091FF),
                      ),
                      _ComingSoonStat(
                        icon: Iconsax.wallet_3,
                        label: loc.donations,
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
          ],
        );
      },
    );
  }
}

class _TimeAndHoliday extends HookConsumerWidget {
  final bool isSmallScreen;

  const _TimeAndHoliday({required this.isSmallScreen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = ref.watch(dateFormatNotifierProvider);
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);

    return Column(
      children: [
        SizedBox(height: isSmallScreen ? 0 : 20),
        Container(
          width: isSmallScreen ? 140 : 180,
          height: isSmallScreen ? 140 : 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.15),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return CustomPaint(
                  painter: ClockPainter(dateTime: DateTime.now()),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: HookBuilder(
            builder: (context) {
              final holidayName = useMemoized(() {
                if (dateFormat == DateFormatType.ethiopian) {
                  try {
                    final now = EtDatetime.now();
                    final bh = BahireHasab(year: now.year);
                    final holiday = bh.getSingleBealOrTsom(
                      "${now.month}/${now.day}",
                    );
                    return holiday?['name'];
                  } catch (e) {
                    return null;
                  }
                } else {
                  // Simple Gregorian holiday logic or placeholder
                  return null;
                }
              }, [dateFormat]);

              return Text(
                holidayName ?? loc.noCelebration,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Calendar extends HookConsumerWidget {
  final bool isSmallScreen;

  const _Calendar({required this.isSmallScreen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = ref.watch(dateFormatNotifierProvider);
    final now = DateTime.now();

    String monthName;
    int year;
    int daysInMonth;
    int firstWeekdayOffset;
    int currentDay;

    if (dateFormat == DateFormatType.ethiopian) {
      final etNow = EtDatetime.now();
      final calendar = ETC(
        year: etNow.year,
        month: etNow.month,
        day: etNow.day,
      );
      monthName = calendar.monthName ?? '';
      year = calendar.year;
      daysInMonth = calendar.monthDays().length;
      final firstDayOfMonth = EtDatetime(
        year: etNow.year,
        month: etNow.month,
        day: 1,
      );
      firstWeekdayOffset = firstDayOfMonth.weekday - 1;
      currentDay = etNow.day;
    } else {
      monthName = DateFormat('MMMM').format(now);
      year = now.year;
      daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      firstWeekdayOffset = firstDayOfMonth.weekday - 1; // Mon=1 -> 0
      currentDay = now.day;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  monthName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 24 : 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  year.toString(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: isSmallScreen ? 14 : 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Icon(
                Iconsax.calendar_1,
                color: Colors.white,
                size: isSmallScreen ? 20 : 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
                .map(
                  (day) => Expanded(
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: isSmallScreen ? 9 : 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: isSmallScreen ? 0.9 : 1,
            ),
            itemCount: 35, // Fixed size grid
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final day = index - firstWeekdayOffset + 1;
              final isValid = day > 0 && day <= daysInMonth;
              final isToday = isValid && day == currentDay;

              // Simplified upcoming Sunday logic for now, or remove it if complex to adapt
              // For simplicity, let's just highlight today

              return Container(
                decoration: BoxDecoration(
                  gradient: isToday
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Color(0xFFE0E0E0)],
                        )
                      : null,
                  color: !isToday ? Colors.white.withValues(alpha: 0.05) : null,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isToday
                      ? [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    isValid ? day.toString() : '',
                    style: TextStyle(
                      color: isToday
                          ? Colors.black
                          : Colors.white.withValues(alpha: 0.7),
                      fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                      fontSize: isToday
                          ? (isSmallScreen ? 14 : 16)
                          : (isSmallScreen ? 12 : 14),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _IconStat extends StatefulWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _IconStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  State<_IconStat> createState() => _IconStatState();
}

class _IconStatState extends State<_IconStat> with TickerProviderStateMixin {
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
    final appColors = Theme.of(context).extension<AppColors>()!;

    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

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
          scale: 1.0 + (_hoverController.value * 0.05),
          child: Container(
            width: isMobile ? 110 : 160,
            padding: EdgeInsets.all(isMobile ? 12 : 20),
            decoration: BoxDecoration(
              color: _isHovered
                  ? widget.color.withValues(alpha: 0.05)
                  : appColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _isHovered
                    ? widget.color.withValues(alpha: 0.3)
                    : appColors.border.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: appColors.shadow.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.color.withValues(alpha: 0.2),
                        widget.color.withValues(alpha: 0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.color,
                    size: isMobile ? 20 : 24,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 24,
                    fontWeight: FontWeight.w800,
                    color: appColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 13,
                    color: appColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ComingSoonStat extends ConsumerWidget {
  final IconData icon;
  final String label;

  const _ComingSoonStat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);

    return Container(
      width: isMobile ? 110 : 160,
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      decoration: BoxDecoration(
        color: appColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: appColors.border.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: appColors.textSecondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: appColors.textSecondary,
              size: isMobile ? 20 : 24,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: appColors.textSecondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              loc.comingSoon,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: appColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 11 : 13,
              color: appColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsCardShimmer extends StatelessWidget {
  const _AnalyticsCardShimmer();

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Container(
      height: 600,
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(32),
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds);
  }
}
