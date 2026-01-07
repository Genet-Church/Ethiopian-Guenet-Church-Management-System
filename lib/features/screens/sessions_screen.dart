import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/data/models/session_model.dart';
import 'package:genet_church_portal/data/repositories/api_repository.dart';
import 'package:genet_church_portal/shared_widgets/modern_button.dart';
import 'package:genet_church_portal/shared_widgets/modern_card.dart';
import 'package:genet_church_portal/shared_widgets/notification_system.dart';
import 'package:genet_church_portal/shared_widgets/table_shimmer_loader.dart';
import 'package:iconsax/iconsax.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'sessions_screen.g.dart';

@riverpod
Future<List<Session>> userSessions(UserSessionsRef ref) {
  return ref.watch(apiRepositoryProvider).getSessions();
}

class SessionsScreen extends ConsumerWidget {
  const SessionsScreen({super.key});

  static IconData _getDeviceIcon(String userAgent) {
    final ua = userAgent.toLowerCase();
    if (ua.contains('mobile') ||
        ua.contains('android') ||
        ua.contains('iphone')) {
      return Iconsax.mobile;
    } else if (ua.contains('ipad') || ua.contains('tablet')) {
      return Iconsax.device_message;
    } else {
      return Iconsax.monitor;
    }
  }

  static String _getDeviceName(String userAgent) {
    if (userAgent.contains('Macintosh')) return 'Mac';
    if (userAgent.contains('Windows')) return 'Windows';
    if (userAgent.contains('iPhone')) return 'iPhone';
    if (userAgent.contains('Android')) return 'Android';
    if (userAgent.contains('Linux')) return 'Linux';
    return 'Unknown Device';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(userSessionsProvider);
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ultra-modern header with gradient background
        Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                    theme.colorScheme.secondary.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: appColors.border.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Iconsax.security_user,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Sessions',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Manage your logged-in devices',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: appColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  DestructiveButton(
                    text: 'Log out all others',
                    icon: Iconsax.logout,
                    size: ButtonSize.small,
                    onPressedAsync: () async {
                      try {
                        await ref
                            .read(apiRepositoryProvider)
                            .revokeAllSessions(keepCurrent: true);
                        ref.invalidate(userSessionsProvider);
                        if (context.mounted) {
                          context.showSuccessNotification(
                            title: 'Success',
                            message: 'All other sessions have been revoked.',
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          context.showErrorNotification(
                            title: 'Error',
                            message: 'Failed to revoke sessions.',
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms)
            .slideY(begin: -0.1, curve: Curves.easeOut),
        const SizedBox(height: 24),
        // Sessions list
        sessionsAsync.when(
          data: (sessions) {
            return Expanded(
              child: ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  return _SessionCard(session: session, ref: ref, index: index);
                },
              ),
            );
          },
          loading: () => const TableShimmerLoader(columnCount: 5),
          error: (e, s) => Center(
            child: ModernCard(
              variant: CardVariant.glass,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.warning_2,
                      size: 48,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading sessions',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      e.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: appColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SessionCard extends StatefulWidget {
  final Session session;
  final WidgetRef ref;
  final int index;

  const _SessionCard({
    required this.session,
    required this.ref,
    required this.index,
  });

  @override
  State<_SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<_SessionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final session = widget.session;

    // Define gradient colors based on session status
    final gradientColors = session.isCurrent
        ? [const Color(0xFF11998e), const Color(0xFF38ef7d)]
        : [const Color(0xFF667eea), const Color(0xFF764ba2)];

    return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 16),
            child: ModernCard(
              variant: session.isCurrent ? CardVariant.neon : CardVariant.glass,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Device icon with gradient
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _isHovered || session.isCurrent
                              ? gradientColors
                              : [
                                  gradientColors[0].withValues(alpha: 0.2),
                                  gradientColors[1].withValues(alpha: 0.1),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: session.isCurrent || _isHovered
                            ? [
                                BoxShadow(
                                  color: gradientColors[0].withValues(alpha: 0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        SessionsScreen._getDeviceIcon(session.userAgent),
                        color: _isHovered || session.isCurrent
                            ? Colors.white
                            : gradientColors[0],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Session info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                SessionsScreen._getDeviceName(
                                  session.userAgent,
                                ),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _isHovered
                                      ? gradientColors[0]
                                      : appColors.textPrimary,
                                ),
                              ),
                              if (session.isCurrent) ...[
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: gradientColors,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: gradientColors[0].withOpacity(
                                          0.4,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'This Device',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            session.userAgent,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: appColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Iconsax.clock,
                                size: 14,
                                color: appColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Last active ${timeago.format(session.updatedAt)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: appColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Action button
                    if (!session.isCurrent)
                      ModernButton(
                        text: 'Revoke',
                        size: ButtonSize.small,
                        variant: ButtonVariant.outline,
                        customColor: theme.colorScheme.error,
                        onPressedAsync: () async {
                          try {
                            await widget.ref
                                .read(apiRepositoryProvider)
                                .revokeSession(session.id);
                            widget.ref.invalidate(userSessionsProvider);
                            if (context.mounted) {
                              context.showSuccessNotification(
                                title: 'Success',
                                message: 'Session revoked.',
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              context.showErrorNotification(
                                title: 'Error',
                                message: 'Failed to revoke session.',
                              );
                            }
                          }
                        },
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: gradientColors[0].withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: gradientColors[0].withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          'Current',
                          style: TextStyle(
                            color: gradientColors[0],
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: (widget.index * 100).ms)
        .slideX(begin: 0.1, curve: Curves.easeOut);
  }
}
