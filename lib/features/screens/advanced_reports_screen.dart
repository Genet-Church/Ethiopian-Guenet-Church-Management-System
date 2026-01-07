import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/data/models/dashboard_model.dart';
import 'package:genet_church_portal/data/models/pastor_dashboard_model.dart';
import 'package:genet_church_portal/shared_widgets/export_report_dialog.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:genet_church_portal/shared_widgets/modern_button.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:math';
import 'package:genet_church_portal/core/settings/language_provider.dart';

import '../../core/localization/app_localization.dart';

class AdvancedReportsScreen extends ConsumerStatefulWidget {
  const AdvancedReportsScreen({super.key});

  @override
  ConsumerState<AdvancedReportsScreen> createState() =>
      _AdvancedReportsScreenState();
}

class _AdvancedReportsScreenState extends ConsumerState<AdvancedReportsScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final statsAsync = ref.watch(dashboardStatsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 650;
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);

    return statsAsync.when(
      data: (stats) {
        int totalMembers = 0;
        int totalChurches = 0;
        int totalPastors = 0;
        int totalServants = 0;
        Map<String, int> membersByGender = {};
        Map<String, int> membersByStatus = {};

        if (stats is SuperAdminDashboardStats) {
          totalMembers = stats.totals?.totalMembers ?? 0;
          totalChurches = stats.totals?.totalChurches ?? 0;
          totalPastors = stats.totals?.totalPastors ?? 0;
          totalServants = stats.totals?.totalServants ?? 0;
          membersByGender = stats.distributions?.membersByGender ?? {};
          membersByStatus = stats.distributions?.membersByStatus ?? {};
        } else if (stats is PastorDashboardStats) {
          totalMembers = stats.totals?.totalMembers ?? 0;
          totalServants = stats.totals?.totalServants ?? 0;
          membersByGender = stats.distributions?.membersByGender ?? {};
          membersByStatus = stats.distributions?.membersByStatus ?? {};
        }

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                appColors.scaffold,
                appColors.scaffold,
                appColors.surface.withAlpha(128),
              ],
            ),
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(isSmallScreen ? 12 : 32),
            children: [
              // Ultra-Modern Header with Animated Background
              _buildUltraModernHeader(context, isSmallScreen, loc),
              const SizedBox(height: 32),

              // Stat Cards Grid with Staggered Animation
              LayoutBuilder(
                builder: (context, constraints) {
                  final statCards = _buildStatCards(
                    stats,
                    totalMembers,
                    totalChurches,
                    totalPastors,
                    totalServants,
                    theme,
                    loc,
                  );

                  int crossAxisCount = statCards.length <= 2
                      ? 2
                      : (constraints.maxWidth < 1200 ? 4 : 4);
                  if (constraints.maxWidth < 650) {
                    crossAxisCount = 2;
                  }

                  double childAspectRatio = constraints.maxWidth < 650
                      ? 1.0
                      : 1.2;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: isSmallScreen ? 12 : 24,
                      mainAxisSpacing: isSmallScreen ? 12 : 24,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: statCards.length,
                    itemBuilder: (context, index) => statCards[index]
                        .animate()
                        .fadeIn(
                      duration: 600.ms,
                      delay: Duration(milliseconds: 100 * index),
                    )
                        .slideY(
                      begin: 0.3,
                      end: 0,
                      duration: 600.ms,
                      delay: Duration(milliseconds: 100 * index),
                      curve: Curves.easeOutCubic,
                    )
                        .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                      duration: 600.ms,
                      delay: Duration(milliseconds: 100 * index),
                      curve: Curves.easeOutBack,
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Charts Section with Glass Effect
              _ResponsiveChartLayout(
                genderData: membersByGender,
                statusData: membersByStatus,
                loc: loc,
              ),
            ],
          ),
        );
      },
      loading: () => _buildLoadingState(theme, appColors, loc),
      error: (e, s) => _buildErrorState(theme, e.toString(), loc),
    );
  }

  Widget _buildUltraModernHeader(BuildContext context, bool isSmallScreen, AppLocalization loc) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return AnimatedBuilder(
      animation: _headerAnimationController,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment(
                _headerAnimationController.value * 2 - 1,
                -1,
              ),
              end: Alignment(1 - _headerAnimationController.value * 2, 1),
              colors: [
                theme.colorScheme.primary.withAlpha(25),
                theme.colorScheme.secondary.withAlpha(25),
                theme.colorScheme.tertiary.withAlpha(25),
                theme.colorScheme.primary.withAlpha(25),
              ],
            ),
            border: Border.all(
              color: theme.colorScheme.primary.withAlpha(51),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withAlpha(25),
                blurRadius: 60,
                offset: const Offset(0, 20),
                spreadRadius: -10,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative Elements
              Positioned(
                top: -30,
                right: -30,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) => Container(
                    width: 120 + _pulseController.value * 20,
                    height: 120 + _pulseController.value * 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          theme.colorScheme.primary.withAlpha(
                            (51 - _pulseController.value * 25).toInt(),
                          ),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                left: -40,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        theme.colorScheme.secondary.withAlpha(38),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withAlpha(51),
                              theme.colorScheme.secondary.withAlpha(51),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.primary.withAlpha(76),
                          ),
                        ),
                        child: Icon(
                          Iconsax.chart_21,
                          color: theme.colorScheme.primary,
                          size: isSmallScreen ? 20 : 28,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.analyticsDashboard,
                              style: theme.textTheme.headlineLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                fontSize: isSmallScreen ? 20 : 32,
                                foreground: Paint()
                                  ..shader =
                                  LinearGradient(
                                    colors: [
                                      appColors.textPrimary,
                                      appColors.textPrimary
                                          .withAlpha(204),
                                    ],
                                  ).createShader(
                                    const Rect.fromLTWH(
                                      0,
                                      0,
                                      300,
                                      70,
                                    ),
                                  ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              loc.analyticsDesc,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: appColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: isSmallScreen ? 8 : 12,
                    runSpacing: isSmallScreen ? 8 : 12,
                    children: [
                      _buildHeaderChip(
                        context,
                        isSmallScreen: isSmallScreen,
                        icon: Iconsax.calendar_1,
                        label: loc.updatedJustNow,
                        color: theme.colorScheme.primary,
                      ),
                      _buildHeaderChip(
                        context,
                        isSmallScreen: isSmallScreen,
                        icon: Iconsax.status_up,
                        label: loc.liveData,
                        color: const Color(0xFF00C853),
                      ),
                      PrimaryButton(
                        text: loc.exportReport,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                            const ExportReportDialog(),
                          );
                        },
                        icon: Iconsax.document_download,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 800.ms)
            .slideY(
          begin: -0.2,
          end: 0,
          duration: 800.ms,
          curve: Curves.easeOutCubic,
        );
      },
    );
  }

  Widget _buildHeaderChip(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required bool isSmallScreen,
      }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 10 : 14,
        vertical: isSmallScreen ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withAlpha(76)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isSmallScreen ? 14 : 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: isSmallScreen ? 11 : 13,
            ),
          ),
        ],
      ),
    );
  }

  String? _calculateGrowth(int total, int newItems, String newLabel) {
    if (total == 0 || newItems == 0) return null;
    int previous = total - newItems;
    if (previous <= 0) return newLabel;
    double growth = (newItems / previous) * 100;
    return '+${growth.toStringAsFixed(1)}%';
  }

  List<Widget> _buildStatCards(
      dynamic stats,
      int totalMembers,
      int totalChurches,
      int totalPastors,
      int totalServants,
      ThemeData theme,
      AppLocalization loc,
      ) {
    int newMembers = 0;
    int newChurches = 0;

    if (stats is SuperAdminDashboardStats) {
      newMembers = stats.newInTimeframe?.newMembers ?? 0;
      newChurches = stats.newInTimeframe?.newChurches ?? 0;
    } else if (stats is PastorDashboardStats) {
      newMembers = stats.newInTimeframe?.newMembers ?? 0;
    }

    if (stats == null) {
      return [];
    }

    return [
      if (stats is SuperAdminDashboardStats) ...[
        _UltraModernStatCard(
          icon: Iconsax.people,
          value: totalMembers.toString(),
          label: loc.totalMembers,
          gradientColors: const [Color(0xFF667eea), Color(0xFF764ba2)],
          percentage: _calculateGrowth(totalMembers, newMembers, 'New'),
        ),
        _UltraModernStatCard(
          icon: Iconsax.building,
          value: totalChurches.toString(),
          label: loc.totalChurches,
          gradientColors: const [Color(0xFF11998e), Color(0xFF38ef7d)],
          percentage: _calculateGrowth(totalChurches, newChurches, 'New'),
        ),
        _UltraModernStatCard(
          icon: Iconsax.user_octagon,
          value: totalPastors.toString(),
          label: loc.totalPastors,
          gradientColors: const [Color(0xFFF5A623), Color(0xFFf76b1c)],
          percentage: null,
        ),
        _UltraModernStatCard(
          icon: Iconsax.lifebuoy,
          value: totalServants.toString(),
          label: loc.totalServants,
          gradientColors: const [Color(0xFFf093fb), Color(0xFFf5576c)],
          percentage: null,
        ),
      ],
      if (stats is PastorDashboardStats) ...[
        _UltraModernStatCard(
          icon: Iconsax.people,
          value: totalMembers.toString(),
          label: loc.totalMembers,
          gradientColors: const [Color(0xFF667eea), Color(0xFF764ba2)],
          percentage: _calculateGrowth(totalMembers, newMembers, 'New'),
        ),
        _UltraModernStatCard(
          icon: Iconsax.lifebuoy,
          value: totalServants.toString(),
          label: loc.totalServants,
          gradientColors: const [Color(0xFFf093fb), Color(0xFFf5576c)],
          percentage: null,
        ),
      ],
    ];
  }

  Widget _buildLoadingState(ThemeData theme, AppColors appColors, AppLocalization loc) {
    return Center(
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withAlpha(25),
                  theme.colorScheme.secondary.withAlpha(25),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withAlpha(51),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            loc.loadingAnalytics,
            style: theme.textTheme.titleMedium?.copyWith(
              color: appColors.textSecondary,
            ),
          ),
        ],
      )
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(
        duration: 1500.ms,
        color: theme.colorScheme.primary.withAlpha(51),
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, String error, AppLocalization loc) {
    return Center(
      child:
      Container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.errorContainer.withAlpha(204),
              theme.colorScheme.errorContainer.withAlpha(153),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.colorScheme.error.withAlpha(76),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.error.withAlpha(38),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withAlpha(51),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.warning_2,
                color: theme.colorScheme.error,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              loc.failedLoadAnalytics,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onErrorContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer.withAlpha(
                  179,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 600.ms)
          .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
    );
  }
}

class _UltraModernStatCard extends StatefulWidget {
  final IconData icon;
  final String value;
  final String label;
  final List<Color> gradientColors;
  final String? percentage;
  final bool isPositive;

  const _UltraModernStatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.gradientColors,
    this.percentage,
    this.isPositive = true,
  });

  @override
  State<_UltraModernStatCard> createState() => _UltraModernStatCardState();
}

class _UltraModernStatCardState extends State<_UltraModernStatCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _shimmerController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final isSmallScreen = MediaQuery.of(context).size.width < 650;

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
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_hoverController.value * 0.03),
            child: Transform.translate(
              offset: Offset(0, -_hoverController.value * 8),
              child: Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      appColors.surface,
                      appColors.surface.withAlpha(240),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isHovered
                        ? widget.gradientColors[0].withAlpha(128)
                        : appColors.border.withAlpha(76),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.gradientColors[0].withAlpha(
                        (25 + _hoverController.value * 51).toInt(),
                      ),
                      blurRadius: 30 + _hoverController.value * 20,
                      offset: Offset(0, 10 + _hoverController.value * 10),
                      spreadRadius: -5,
                    ),
                    BoxShadow(
                      color: appColors.shadow.withAlpha(13),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: -8,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Animated background decoration
                    Positioned(
                      top: -30,
                      right: -30,
                      child: AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, child) => Transform.rotate(
                          angle: _shimmerController.value * 2 * 3.14159,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: SweepGradient(
                                colors: [
                                  widget.gradientColors[0].withAlpha(13),
                                  widget.gradientColors[1].withAlpha(25),
                                  widget.gradientColors[0].withAlpha(13),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: widget.gradientColors,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.gradientColors[0].withAlpha(
                                      102,
                                    ),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.icon,
                                color: Colors.white,
                                size: isSmallScreen ? 18 : 22,
                              ),
                            ),
                            if (widget.percentage != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: widget.isPositive
                                      ? const Color(0xFF00C853).withAlpha(25)
                                      : const Color(0xFFFF5252).withAlpha(25),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: widget.isPositive
                                        ? const Color(0xFF00C853).withAlpha(76)
                                        : const Color(0xFFFF5252).withAlpha(76),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      widget.isPositive
                                          ? Iconsax.arrow_up_3
                                          : Iconsax.arrow_down,
                                      size: 12,
                                      color: widget.isPositive
                                          ? const Color(0xFF00C853)
                                          : const Color(0xFFFF5252),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.percentage!,
                                      style: TextStyle(
                                        color: widget.isPositive
                                            ? const Color(0xFF00C853)
                                            : const Color(0xFFFF5252),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.value,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 24 : 36,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                                foreground: Paint()
                                  ..shader =
                                  LinearGradient(
                                    colors: widget.gradientColors,
                                  ).createShader(
                                    const Rect.fromLTWH(0, 0, 100, 50),
                                  ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.label,
                              style: TextStyle(
                                color: appColors.textSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: isSmallScreen ? 12 : 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ResponsiveChartLayout extends StatelessWidget {
  final Map<String, int> genderData;
  final Map<String, int> statusData;
  final AppLocalization loc;

  const _ResponsiveChartLayout({
    required this.genderData,
    required this.statusData,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 950) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: GenderDistributionCard(genderData: genderData, loc: loc),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: MemberStatusCard(statusData: statusData, loc: loc),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              GenderDistributionCard(genderData: genderData, loc: loc),
              const SizedBox(height: 24),
              MemberStatusCard(statusData: statusData, loc: loc),
            ],
          );
        }
      },
    );
  }
}

class GenderDistributionCard extends StatelessWidget {
  final Map<String, int> genderData;
  final AppLocalization loc;
  const GenderDistributionCard({super.key, required this.genderData, required this.loc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final maleCount = genderData['MALE'] ?? 0;
    final femaleCount = genderData['FEMALE'] ?? 0;
    final total = maleCount + femaleCount;
    final malePercentage = total > 0 ? (maleCount / total * 100).round() : 0;
    final femalePercentage = total > 0
        ? (femaleCount / total * 100).round()
        : 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 450;
        final barWidth = isSmall ? 24.0 : 60.0;
        final chartHeight = isSmall ? 180.0 : 260.0;
        final maxCount =
            (maleCount > femaleCount ? maleCount : femaleCount) * 1.2;

        return Container(
          padding: EdgeInsets.all(isSmall ? 16 : 28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                appColors.surface,
                appColors.surface.withValues(alpha: 0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 5,
              ),
              BoxShadow(
                color: appColors.shadow.withValues(alpha: 0.05),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    loc.memberGenderDist,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      fontSize: isSmall ? 16 : null,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.people,
                          color: theme.colorScheme.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          loc.totalLabel.replaceAll('{count}', total.toString()),
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: isSmall ? 12 : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: chartHeight,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxCount > 0 ? maxCount : 1,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: maleCount.toDouble(),
                            width: barWidth,
                            color: theme.colorScheme.primary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxCount > 0 ? maxCount : 1,
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: femaleCount.toDouble(),
                            width: barWidth,
                            color: theme.colorScheme.secondary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxCount > 0 ? maxCount : 1,
                              color: theme.colorScheme.secondary.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 110,
                          getTitlesWidget: (value, meta) {
                            Widget content;
                            switch (value.toInt()) {
                              case 0:
                                content = _GenderIndicator(
                                  isSmall: isSmall,
                                  icon: Iconsax.man,
                                  label: loc.male,
                                  percentage: malePercentage,
                                  color: theme.colorScheme.primary,
                                );
                                break;
                              case 1:
                                content = _GenderIndicator(
                                  isSmall: isSmall,
                                  icon: Iconsax.woman,
                                  label: loc.female,
                                  percentage: femalePercentage,
                                  color: theme.colorScheme.secondary,
                                );
                                break;
                              default:
                                content = const SizedBox();
                                break;
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: content,
                            );
                          },
                        ),
                      ),
                    ),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipPadding: const EdgeInsets.all(12),
                        tooltipMargin: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${group.x == 0 ? loc.male : loc.female}: ${rod.toY.toInt()}',
                            TextStyle(
                              color: appColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
            .animate()
            .fade(duration: 500.ms, delay: 200.ms)
            .slideY(
          begin: 0.1,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOutQuint,
          delay: 200.ms,
        );
      },
    );
  }
}

class _GenderIndicator extends StatelessWidget {
  const _GenderIndicator({
    required this.isSmall,
    required this.icon,
    required this.label,
    required this.percentage,
    required this.color,
  });

  final bool isSmall;
  final IconData icon;
  final String label;
  final int percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: isSmall ? 32 : 48,
          height: isSmall ? 32 : 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: isSmall ? 16 : 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isSmall ? 10 : 14,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        Text(
          '$percentage%',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmall ? 9 : 12,
            color: color,
          ),
        ),
      ],
    );
  }
}

class MemberStatusCard extends StatelessWidget {
  final Map<String, int> statusData;
  final AppLocalization loc;
  const MemberStatusCard({super.key, required this.statusData, required this.loc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      const Color(0xFFF5A623),
      theme.colorScheme.error,
      Colors.green,
      Colors.purple,
    ];
    final statusEntries = statusData.entries
        .where((entry) => entry.value > 0)
        .toList();
    final totalMembers = statusEntries.fold(
      0,
          (sum, entry) => sum + entry.value,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 350;
        final chartSize = min(
          constraints.maxWidth * 0.6,
          isSmall ? 140.0 : 220.0,
        );
        final radius = chartSize / 2;
        final centerSpaceRadius = radius * 0.6;

        return Container(
          padding: EdgeInsets.all(isSmall ? 16 : 28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                appColors.surface,
                appColors.surface.withValues(alpha: 0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.secondary.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 5,
              ),
              BoxShadow(
                color: appColors.shadow.withValues(alpha: 0.05),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
            border: Border.all(
              color: theme.colorScheme.secondary.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    loc.memberStatus,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      fontSize: isSmall ? 18 : null,
                    ),
                  ),
                  if (totalMembers > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.chart,
                            color: theme.colorScheme.secondary,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            loc.totalLabel.replaceAll('{count}', totalMembers.toString()),
                            style: TextStyle(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                              fontSize: isSmall ? 12 : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 32),
              if (totalMembers == 0)
                SizedBox(
                  height: chartSize,
                  child: Center(
                    child: Text(
                      loc.noDataAvailable,
                      style: TextStyle(color: appColors.textSecondary),
                    ),
                  ),
                )
              else
                SizedBox(
                  height: chartSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: centerSpaceRadius,
                          sections: List.generate(statusEntries.length, (
                              i,
                              ) {
                            final entry = statusEntries[i];
                            return PieChartSectionData(
                              color: colors[i % colors.length],
                              value: entry.value.toDouble(),
                              title: '',
                              radius: (radius - centerSpaceRadius) * 0.9,
                            );
                          }),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$totalMembers',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: appColors.textPrimary,
                              fontSize: isSmall ? 24 : null,
                            ),
                          ),
                          Text(
                            loc.membersLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: appColors.textSecondary,
                              fontSize: isSmall ? 10 : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              if (totalMembers > 0)
                Column(
                  children: List.generate(statusEntries.length, (i) {
                    final entry = statusEntries[i];
                    final percentage = (entry.value / totalMembers * 100)
                        .toStringAsFixed(1);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          _Indicator(
                            color: colors[i % colors.length],
                            text: entry.key,
                            isSmall: isSmall,
                          ),
                          const Spacer(),
                          Text(
                            '${entry.value} ($percentage%)',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: colors[i % colors.length],
                              fontSize: isSmall ? 12 : null,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
            ],
          ),
        )
            .animate()
            .fade(duration: 500.ms, delay: 400.ms)
            .slideY(
          begin: 0.1,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOutQuint,
          delay: 400.ms,
        );
      },
    );
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSmall;

  const _Indicator({
    required this.color,
    required this.text,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    String formattedText = text.toLowerCase();
    formattedText =
        formattedText.substring(0, 1).toUpperCase() +
            formattedText.substring(1);

    return Row(
      children: <Widget>[
        Container(
          width: isSmall ? 12 : 18,
          height: isSmall ? 12 : 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          formattedText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: isSmall ? 11 : null,
          ),
        ),
      ],
    );
  }
}