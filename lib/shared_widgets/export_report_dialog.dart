import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:genet_church_portal/data/services/report_service.dart';
import 'package:iconsax/iconsax.dart';

class ExportReportDialog extends HookConsumerWidget {
  const ExportReportDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pastorLoading = useState(false);
    final churchLoading = useState(false);
    final memberLoading = useState(false);
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: appColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Iconsax.document_download,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Export Report',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Please select the type of report you would like to export as a CSV file.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: appColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            _ExportOptionTile(
              icon: Iconsax.user_octagon,
              title: 'Pastors Report',
              subtitle: 'Export a list of all pastors.',
              isLoading: pastorLoading.value,
              onTap: () async {
                pastorLoading.value = true;
                try {
                  await ref
                      .read(reportServiceProvider)
                      .generateAndDownloadCsv(ReportType.pastors);
                } finally {
                  if (context.mounted) {
                    pastorLoading.value = false;
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            _ExportOptionTile(
              icon: Iconsax.building,
              title: 'Churches Report',
              subtitle: 'Export a list of all church branches.',
              isLoading: churchLoading.value,
              onTap: () async {
                churchLoading.value = true;
                try {
                  await ref
                      .read(reportServiceProvider)
                      .generateAndDownloadCsv(ReportType.churches);
                } finally {
                  if (context.mounted) {
                    churchLoading.value = false;
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            _ExportOptionTile(
              icon: Iconsax.people,
              title: 'Members Report',
              subtitle: 'Export a sample list of members.',
              isLoading: memberLoading.value,
              onTap: () async {
                memberLoading.value = true;
                try {
                  await ref
                      .read(reportServiceProvider)
                      .generateAndDownloadCsv(ReportType.members);
                } finally {
                  if (context.mounted) {
                    memberLoading.value = false;
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: appColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExportOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isLoading;

  const _ExportOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: appColors.scaffold.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              width: 1.5,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: appColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  Container(
                    width: 28,
                    height: 28,
                    padding: const EdgeInsets.all(4),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: theme.colorScheme.primary,
                    ),
                  )
                else
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.arrow_right_3,
                      color: theme.colorScheme.primary,
                      size: 20,
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