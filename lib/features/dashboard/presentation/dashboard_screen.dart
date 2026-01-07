import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/data/models/user_model.dart';
import 'package:genet_church_portal/data/repositories/auth_repository.dart';
import 'package:genet_church_portal/features/dashboard/presentation/widgets/analytics_card.dart';
import 'package:genet_church_portal/features/dashboard/presentation/widgets/departments_overview_card.dart';
import 'package:genet_church_portal/features/dashboard/presentation/widgets/recent_activity_card.dart';
import 'package:genet_church_portal/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:genet_church_portal/shared_widgets/responsive_layout.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/localization/app_localization.dart';
import 'package:genet_church_portal/core/settings/language_provider.dart';

class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final user = ref.watch(authStateProvider);
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);

    ref.watch(dashboardTimeframeProvider);

    ref.listen(dashboardTimeframeProvider, (previous, next) {
      if (previous != next) {
        ref.invalidate(dashboardStatsProvider);
      }
    });

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    Widget statCards;
    if (user.roleEnum == UserRole.SUPER_ADMIN) {
      statCards = const Wrap(
        spacing: 24,
        runSpacing: 24,
        alignment: WrapAlignment.spaceEvenly,
        children: [ChurchesStatCard(), PastorsStatCard(), MembersStatCard()],
      );
    } else if (user.roleEnum == UserRole.PASTOR) {
      statCards = const Wrap(
        spacing: 24,
        runSpacing: 24,
        alignment: WrapAlignment.spaceEvenly,
        children: [
          MembersStatCard(),
          ServantsStatCard(),
          DepartmentsStatCard(),
        ],
      );
    } else {
      statCards = Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Text(
            loc.welcomeMessage,
            style: TextStyle(fontSize: 18, color: appColors.textPrimary),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [appColors.scaffold, appColors.scaffold],
        ),
      ),
      child: ResponsiveLayout(
        mobileBody: _DashboardMobileLayout(statCards: statCards, user: user),
        desktopBody: _DashboardDesktopLayout(statCards: statCards, user: user),
      ),
    );
  }
}

class _DashboardHeader extends StatefulWidget {
  const _DashboardHeader();

  @override
  State<_DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<_DashboardHeader>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String _getGreeting(AppLocalization loc) {
    final hour = DateTime.now().hour;
    if (hour < 12) return loc.goodMorning;
    if (hour < 18) return loc.goodAfternoon;
    return loc.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final isSmallScreen = MediaQuery.of(context).size.width < 800;

    return Consumer(
      builder: (context, ref, child) {
        final user = ref.watch(authStateProvider);
        final userName = user?.fullName.split(' ').first ?? 'User';
        final locale = ref.watch(languageNotifierProvider);
        final loc = AppLocalization(locale);
        final greeting = _getGreeting(loc);

        return AnimatedBuilder(
          animation: Listenable.merge([
            _headerAnimationController,
            _pulseController,
          ]),
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(
                      theme.colorScheme.primary.withValues(alpha: 0.15),
                      theme.colorScheme.secondary.withValues(alpha: 0.15),
                      _headerAnimationController.value,
                    )!,
                    Color.lerp(
                      theme.colorScheme.secondary.withValues(alpha: 0.1),
                      theme.colorScheme.primary.withValues(alpha: 0.1),
                      _headerAnimationController.value,
                    )!,
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative background elements
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Transform.scale(
                      scale: 1.0 + (_pulseController.value * 0.1),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Iconsax.element_4,
                                        color: theme.colorScheme.primary,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.green.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                                width: 6,
                                                height: 6,
                                                decoration: const BoxDecoration(
                                                  color: Colors.green,
                                                  shape: BoxShape.circle,
                                                ),
                                              )
                                              .animate(
                                                onPlay: (c) =>
                                                    c.repeat(reverse: true),
                                              )
                                              .fade(duration: 1.seconds),
                                          const SizedBox(width: 6),
                                          Text(
                                            loc.liveUpdates,
                                            style: TextStyle(
                                              color: Colors.green[700],
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '$greeting, $userName!',
                                  style: isSmallScreen
                                      ? theme.textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: appColors.textPrimary,
                                        )
                                      : theme.textTheme.headlineLarge?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: appColors.textPrimary,
                                          letterSpacing: -0.5,
                                          height: 1.1,
                                        ),
                                ).animate().fadeIn().slideX(begin: -0.1),
                                const SizedBox(height: 8),
                                Text(
                                      loc.happeningToday,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            color: appColors.textSecondary,
                                            height: 1.5,
                                          ),
                                    )
                                    .animate()
                                    .fadeIn(delay: 100.ms)
                                    .slideX(begin: -0.1),
                              ],
                            ),
                          ),
                          if (!isSmallScreen) const _TimeframeSelector(),
                        ],
                      ),
                      if (isSmallScreen) ...[
                        const SizedBox(height: 24),
                        const Center(child: _TimeframeSelector()),
                      ],
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _TimeframeSelector extends ConsumerWidget {
  const _TimeframeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTimeframe = ref.watch(dashboardTimeframeProvider);
    final appColors = Theme.of(context).extension<AppColors>()!;
    final statsAsync = ref.watch(dashboardStatsProvider);
    final isLoading = statsAsync.isLoading;
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: appColors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: appColors.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TimeframeButton(
            label: loc.timeframe7d,
            value: '7d',
            isSelected: selectedTimeframe == '7d',
            isLoading: isLoading && selectedTimeframe == '7d',
            onTap: () {
              if (!isLoading) {
                ref.read(dashboardTimeframeProvider.notifier).state = '7d';
              }
            },
          ),
          _TimeframeButton(
            label: loc.timeframe30d,
            value: '30d',
            isSelected: selectedTimeframe == '30d',
            isLoading: isLoading && selectedTimeframe == '30d',
            onTap: () {
              if (!isLoading) {
                ref.read(dashboardTimeframeProvider.notifier).state = '30d';
              }
            },
          ),
          _TimeframeButton(
            label: loc.timeframe1y,
            value: '1y',
            isSelected: selectedTimeframe == '1y',
            isLoading: isLoading && selectedTimeframe == '1y',
            onTap: () {
              if (!isLoading) {
                ref.read(dashboardTimeframeProvider.notifier).state = '1y';
              }
            },
          ),
          _TimeframeButton(
            label: loc.timeframeAll,
            value: 'all',
            isSelected: selectedTimeframe == 'all',
            isLoading: isLoading && selectedTimeframe == 'all',
            onTap: () {
              if (!isLoading) {
                ref.read(dashboardTimeframeProvider.notifier).state = 'all';
              }
            },
          ),
        ],
      ),
    );
  }
}

class _TimeframeButton extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const _TimeframeButton({
    required this.label,
    required this.value,
    required this.isSelected,
    this.isLoading = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : appColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 11,
              ),
            ),
            if (isLoading) ...[
              const SizedBox(width: 8),
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DashboardDesktopLayout extends StatelessWidget {
  final Widget statCards;
  final UserModel user;
  const _DashboardDesktopLayout({required this.statCards, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32.0),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        const _DashboardHeader(),
        const SizedBox(height: 32),
        statCards.animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
        const SizedBox(height: 32),
        // Show Departments Overview for Pastors only
        if (user.roleEnum != UserRole.SUPER_ADMIN)
          const DepartmentsOverviewCard()
              .animate()
              .fadeIn(delay: 300.ms)
              .slideY(begin: 0.1),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: const RecentActivityCard()
                  .animate()
                  .fadeIn(delay: 400.ms)
                  .slideY(begin: 0.1),
            ),
            const SizedBox(width: 32),
            Expanded(
              flex: 3,
              child: const AnalyticsCard()
                  .animate()
                  .fadeIn(delay: 500.ms)
                  .slideY(begin: 0.1),
            ),
          ],
        ),
      ],
    );
  }
}

class _DashboardMobileLayout extends StatelessWidget {
  final Widget statCards;
  final UserModel user;
  const _DashboardMobileLayout({required this.statCards, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12.0),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        const _DashboardHeader(),
        const SizedBox(height: 24),
        if (statCards is Wrap)
          ...(statCards as Wrap).children
              .expand((widget) => [widget, const SizedBox(height: 16)])
              .toList()
            ..removeLast()
        else
          statCards,
        const SizedBox(height: 24),
        if (user.roleEnum != UserRole.SUPER_ADMIN)
          const DepartmentsOverviewCard(),
        const SizedBox(height: 24),
        const RecentActivityCard(),
        const SizedBox(height: 24),
        const AnalyticsCard(),
      ],
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}
