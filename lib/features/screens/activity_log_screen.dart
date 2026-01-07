import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/shared_widgets/page_header.dart';
import 'package:genet_church_portal/shared_widgets/modern_loading.dart';
import 'package:genet_church_portal/shared_widgets/modern_card.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:genet_church_portal/core/utils/date_formatter.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/localization/app_localization.dart';

import 'package:genet_church_portal/core/settings/language_provider.dart';

class ActivityLogScreen extends ConsumerWidget {
  const ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final activitiesAsync = ref.watch(activityLogProvider);
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);

    return activitiesAsync.when(
      data: (activities) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title: loc.activityLog,
              description: loc.activityLogDesc,
            ),
            const SizedBox(height: 24),
            if (activities.isEmpty)
              EmptyState(
                icon: Iconsax.activity,
                title: loc.noActivitiesYet,
                subtitle: loc.noActivitiesDesc,
              ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms)
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ModernCard(
                          child: ListTile(
                            onTap: () => context.go(activity.path),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    theme.colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                activity.icon,
                                color: theme.colorScheme.primary,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              activity.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                activity.subtitle,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: appColors.textSecondary,
                                ),
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  AppDateFormatter.formatShort(
                                    activity.timestamp,
                                    ref,
                                  ),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: appColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  DateFormat.jm(
                                    locale.languageCode,
                                  ).format(activity.timestamp),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: appColors.textSecondary.withValues(
                                      alpha: 0.7,
                                    ),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: (index * 50).ms)
                      .slideX(begin: -0.1, curve: Curves.easeOut);
                },
              ),
          ],
        );
      },
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(title: loc.activityLog, description: loc.activityLogDesc),
          const SizedBox(height: 24),
          const SkeletonList(itemCount: 5),
        ],
      ),
      error: (err, stack) => Column(
        children: [
          PageHeader(title: loc.activityLog, description: loc.activityLogDesc),
          const SizedBox(height: 24),
          ErrorState(
            title: loc.failedLoadActivities,
            subtitle: err.toString(),
            onRetry: () => ref.refresh(activityLogProvider),
          ),
        ],
      ),
    );
  }
}
