import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/data/models/member_model.dart';
import 'package:genet_church_portal/shared_widgets/api_error_widget.dart';
import 'package:genet_church_portal/shared_widgets/modern_card.dart';
import 'package:genet_church_portal/shared_widgets/modern_loading.dart';
import 'package:genet_church_portal/state/providers.dart';
import 'package:iconsax/iconsax.dart';

import 'package:genet_church_portal/core/utils/date_formatter.dart';
import 'package:genet_church_portal/core/settings/language_provider.dart';

import '../../core/localization/app_localization.dart';

class MemberDetailsScreen extends ConsumerWidget {
  final String memberId;
  const MemberDetailsScreen({super.key, required this.memberId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberAsync = ref.watch(memberDetailsProvider(memberId));
    final theme = Theme.of(context);
    final locale = ref.watch(languageNotifierProvider);
    final loc = AppLocalization(locale);

    String getLocalizedStatus(String status) {
      switch (status) {
        case 'NEW_BELIEVER':
          return loc.newBeliever;
        case 'ACTIVE':
          return loc.active;
        case 'INACTIVE':
          return loc.inactive;
        default:
          return status;
      }
    }

    return memberAsync.when(
      data: (member) {
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              children: [
                ModernCard(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: theme.colorScheme.primary.withValues(
                          alpha: 0.1,
                        ),
                        child: Text(
                          member.fullName.isNotEmpty
                              ? member.fullName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        member.fullName,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text(
                          getLocalizedStatus(member.memberStatus.name),
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: theme.colorScheme.secondary.withValues(
                          alpha: 0.1,
                        ),
                        side: BorderSide.none,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ModernCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.personalInformation,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const Divider(height: 32),
                      _InfoRow(
                        icon: Iconsax.call,
                        label: loc.phone,
                        value: member.phoneNumber,
                      ),
                      _InfoRow(
                        icon: Iconsax.calendar_1,
                        label: loc.birthDate,
                        value: AppDateFormatter.format(
                          DateTime.parse(member.birthDate),
                          ref,
                        ),
                      ),
                      _InfoRow(
                        icon: Iconsax.location,
                        label: loc.birthPlace,
                        value: member.birthPlace,
                      ),
                      _InfoRow(
                        icon: member.gender == Gender.MALE
                            ? Iconsax.man
                            : Iconsax.woman,
                        label: loc.gender,
                        value: member.gender == Gender.MALE
                            ? loc.male
                            : loc.female,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ModernCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.membershipDetails,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const Divider(height: 32),
                      _InfoRow(
                        icon: Iconsax.verify,
                        label: loc.status,
                        value: getLocalizedStatus(member.memberStatus.name),
                      ),
                      if (member.statusChangedAt != null)
                        _InfoRow(
                          icon: Iconsax.clock,
                          label: loc.statusChanged,
                          value: AppDateFormatter.format(
                            DateTime.parse(member.statusChangedAt!),
                            ref,
                          ),
                        ),
                      if (member.baptizedAt != null)
                        _InfoRow(
                          icon: Iconsax.drop,
                          label: loc.baptizedDate,
                          value: AppDateFormatter.format(
                            DateTime.parse(member.baptizedAt!),
                            ref,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ModernCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loc.address, style: theme.textTheme.headlineSmall),
                      const Divider(height: 32),
                      _InfoRow(
                        icon: Iconsax.buildings,
                        label: loc.citySubCity,
                        value:
                            '${member.address.city} / ${member.address.subCity}',
                      ),
                      _InfoRow(
                        icon: Iconsax.routing,
                        label: loc.woreda,
                        value: member.address.woreda,
                      ),
                      _InfoRow(
                        icon: Iconsax.location_tick,
                        label: loc.placeName,
                        value: member.address.placeName,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: ModernLoading(size: 40)),
      error: (err, stack) => Center(child: ApiErrorWidget(error: err)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: appColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: appColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
