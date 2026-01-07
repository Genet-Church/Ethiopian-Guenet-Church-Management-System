import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/data/models/dashboard_model.dart';
import 'package:genet_church_portal/data/models/pastor_dashboard_model.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/localization/app_localization.dart';
import 'package:genet_church_portal/core/settings/language_provider.dart';
import 'package:shimmer/shimmer.dart';

class ChurchesStatCard extends ConsumerWidget {
  const ChurchesStatCard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);
    return statsAsync.when(
      data: (stats) {
        if (stats is! SuperAdminDashboardStats) return const SizedBox.shrink();
        return _StatCard(
          gradientColors: const [Color(0xFF667eea), Color(0xFF764ba2)],
          onTap: () => context.go('/report-churchs'),
          value: (stats.totals?.totalChurches ?? 0).toString(),
          label: loc.totalChurches,
          icon: Iconsax.building,
          chart: _buildPieChart(),
        );
      },
      loading: () => const _StatCardLoading(),
      error: (e, s) => _StatCardError(label: 'Churches'),
    );
  }
}

class PastorsStatCard extends ConsumerWidget {
  const PastorsStatCard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);
    return statsAsync.when(
      data: (stats) {
        if (stats is! SuperAdminDashboardStats) return const SizedBox.shrink();
        return _StatCard(
          gradientColors: const [Color(0xFF11998e), Color(0xFF38ef7d)],
          onTap: () => context.go('/report-pastors'),
          value: (stats.totals?.totalPastors ?? 0).toString(),
          subtitle:
              '${stats.totals?.totalChurches ?? 0} ${loc.churchesAssigned}',
          label: loc.totalPastors,
          icon: Iconsax.user_octagon,
          chart: _buildBarChart((stats.totals?.totalPastors ?? 0).toDouble()),
        );
      },
      loading: () => const _StatCardLoading(),
      error: (e, s) => _StatCardError(label: 'Pastors'),
    );
  }
}

class MembersStatCard extends ConsumerWidget {
  const MembersStatCard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);
    return statsAsync.when(
      data: (stats) {
        String value = '0';
        String label = loc.navMembers;

        if (stats is SuperAdminDashboardStats) {
          value = (stats.totals?.totalMembers ?? 0).toString();
          label = loc.totalMembers;
        } else if (stats is PastorDashboardStats) {
          value = (stats.totals?.totalMembers ?? 0).toString();
          label = loc.yourMembers;
        }

        return _StatCard(
          gradientColors: const [Color(0xFFf093fb), Color(0xFFf5576c)],
          onTap: () => context.go('/show-members'),
          value: value,
          label: label,
          icon: Iconsax.people,
          chart: _buildLineChart(),
        );
      },
      loading: () => const _StatCardLoading(),
      error: (e, s) => _StatCardError(label: 'Members'),
    );
  }
}

class ServantsStatCard extends ConsumerWidget {
  const ServantsStatCard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);
    return statsAsync.when(
      data: (stats) {
        String value = '0';
        String label = loc.navServants;

        if (stats is SuperAdminDashboardStats) {
          value = (stats.totals?.totalServants ?? 0).toString();
          label = loc.totalServants;
        } else if (stats is PastorDashboardStats) {
          value = (stats.totals?.totalServants ?? 0).toString();
          label = loc.yourServants;
        }

        return _StatCard(
          gradientColors: const [Color(0xFFf5a623), Color(0xFFf76b1c)],
          onTap: () => context.go('/report-servants'),
          value: value,
          label: label,
          icon: Iconsax.lifebuoy,
          chart: _buildBarChart(double.tryParse(value) ?? 0),
        );
      },
      loading: () => const _StatCardLoading(),
      error: (e, s) => _StatCardError(label: 'Servants'),
    );
  }
}

class DepartmentsStatCard extends ConsumerWidget {
  const DepartmentsStatCard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departmentsAsync = ref.watch(departmentsProvider);
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);
    return departmentsAsync.when(
      data: (departments) {
        return _StatCard(
          gradientColors: const [Color(0xFF4facfe), Color(0xFF00f2fe)],
          onTap: () => context.go('/departments'),
          value: departments?.length.toString() ?? '0',
          label: loc.yourDepartments,
          icon: Iconsax.folder_open,
          chart: _buildBarChart((departments?.length ?? 0).toDouble()),
        );
      },
      loading: () => const _StatCardLoading(),
      error: (e, s) => _StatCardError(label: 'Departments'),
    );
  }
}

Widget _buildPieChart() {
  return SizedBox(
    width: 80,
    height: 80,
    child: PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 24,
        startDegreeOffset: -90,
        sections: [
          PieChartSectionData(
            color: Colors.white.withValues(alpha: 0.9),
            value: 35,
            showTitle: false,
            radius: 10,
          ),
          PieChartSectionData(
            color: Colors.white.withValues(alpha: 0.6),
            value: 25,
            showTitle: false,
            radius: 10,
          ),
          PieChartSectionData(
            color: Colors.white.withValues(alpha: 0.4),
            value: 20,
            showTitle: false,
            radius: 10,
          ),
          PieChartSectionData(
            color: Colors.white.withValues(alpha: 0.2),
            value: 20,
            showTitle: false,
            radius: 10,
          ),
        ],
      ),
    ),
  );
}

Widget _buildBarChart(double total) {
  return SizedBox(
    width: 90,
    height: 50,
    child: BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (total * 1.5).clamp(10, double.infinity),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: total * 0.8,
                color: Colors.white.withValues(alpha: 0.9),
                width: 8,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: total * 0.6,
                color: Colors.white.withValues(alpha: 0.6),
                width: 8,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: total * 0.9,
                color: Colors.white.withValues(alpha: 0.8),
                width: 8,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildLineChart() {
  return SizedBox(
    width: 100,
    height: 60,
    child: LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 3),
              FlSpot(1, 1.5),
              FlSpot(2.5, 4),
              FlSpot(4, 2.8),
              FlSpot(5, 3.5),
            ],
            isCurved: true,
            curveSmoothness: 0.4,
            color: Colors.white,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                    radius: 3,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: Colors.white.withValues(alpha: 0.5),
                  ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.3),
                  Colors.white.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _StatCard extends StatefulWidget {
  final List<Color> gradientColors;
  final VoidCallback onTap;
  final String value;
  final String? subtitle;
  final String label;
  final Widget chart;
  final IconData icon;

  const _StatCard({
    required this.gradientColors,
    required this.onTap,
    required this.value,
    this.subtitle,
    required this.label,
    required this.chart,
    required this.icon,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> with TickerProviderStateMixin {
  late AnimationController _hoverController;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
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
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return SizedBox(
          width: isMobile ? double.infinity : 350,
          height: isMobile ? 120 : 180,
          child: MouseRegion(
            onEnter: (_) => _hoverController.forward(),
            onExit: (_) => _hoverController.reverse(),
            child: AnimatedBuilder(
              animation: _hoverController,
              builder: (context, child) {
                final scale = 1.0 + (_hoverController.value * 0.03);
                final translateY = -_hoverController.value * 8;

                return Transform(
                  transform: Matrix4.identity()
                    ..scale(scale)
                    ..translate(0.0, translateY),
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: widget.onTap,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: widget.gradientColors[0].withValues(
                              alpha: 0.2 + (_hoverController.value * 0.2),
                            ),
                            blurRadius: 20 + (_hoverController.value * 10),
                            offset: Offset(
                              0,
                              10 + (_hoverController.value * 5),
                            ),
                            spreadRadius: _hoverController.value * 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          children: [
                            // Background Gradient
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: widget.gradientColors,
                                ),
                              ),
                            ),

                            // Glassmorphism Overlay
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white.withValues(alpha: 0.1),
                                    Colors.white.withValues(alpha: 0.05),
                                  ],
                                ),
                              ),
                            ),

                            // Content
                            Padding(
                              padding: EdgeInsets.all(isMobile ? 12 : 24),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(
                                                isMobile ? 8 : 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(
                                                  alpha: 0.2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.2),
                                                ),
                                              ),
                                              child: Icon(
                                                widget.icon,
                                                color: Colors.white,
                                                size: isMobile ? 16 : 20,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                widget.label,
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.9),
                                                  fontSize: isMobile ? 11 : 14,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.5,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text(
                                          widget.value,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isMobile ? 24 : 36,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -1,
                                            height: 1,
                                          ),
                                        ),
                                        if (widget.subtitle != null) ...[
                                          const SizedBox(height: 6),
                                          Text(
                                            widget.subtitle!,
                                            style: TextStyle(
                                              color: Colors.white.withValues(
                                                alpha: 0.8,
                                              ),
                                              fontSize: isMobile ? 9 : 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: EdgeInsets.all(isMobile ? 8 : 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: widget.chart,
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
              },
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.2, curve: Curves.easeOut);
  }
}

class _StatCardLoading extends StatelessWidget {
  const _StatCardLoading();

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Shimmer.fromColors(
      baseColor: appColors.shimmerBase,
      highlightColor: appColors.shimmerHighlight,
      child: Container(
        height: 180,
        width: 350,
        decoration: BoxDecoration(
          color: appColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}

class _StatCardError extends StatelessWidget {
  final String label;
  const _StatCardError({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 350,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.warning_2,
              color: Theme.of(context).colorScheme.error,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Could not load\n$label',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
