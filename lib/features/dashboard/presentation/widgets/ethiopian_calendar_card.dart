import 'package:abushakir/abushakir.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class EthiopianCalendarCard extends HookConsumerWidget {
  const EthiopianCalendarCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    final ethiopianDate = useState(EtDatetime.now());

    useEffect(() {
      final timer = Stream.periodic(const Duration(seconds: 1), (i) => EtDatetime.now())
          .listen((date) {
        ethiopianDate.value = date;
      });
      return timer.cancel;
    }, const []);

    final holidayInfo = useMemoized(() {
      try {
        final bh = BahireHasab(year: ethiopianDate.value.year);
        return bh.getSingleBealOrTsom("${ethiopianDate.value.month}/${ethiopianDate.value.day}");
      } catch (e) {
        return null;
      }
    }, [ethiopianDate.value.year, ethiopianDate.value.month, ethiopianDate.value.day]);

    final ETC calendar = ETC(year: ethiopianDate.value.year, month: ethiopianDate.value.month, day: ethiopianDate.value.day);
    final gregorianDateTime = DateTime.fromMillisecondsSinceEpoch(ethiopianDate.value.moment);
    const dayNames = ['ሰኞ', 'ማክሰኞ', 'ረቡዕ', 'ሐሙስ', 'አርብ', 'ቅዳሜ', 'እሁድ'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appColors.surface.withValues(alpha: 0.9),
            appColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: appColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: appColors.shadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${dayNames[gregorianDateTime.weekday-1]}, ${calendar.monthName} ${calendar.day}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: appColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                calendar.year.toString(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('h:mm:ss a').format(DateTime.now()),
            style: theme.textTheme.titleLarge?.copyWith(
              color: appColors.textSecondary,
            ),
          ),
          const Divider(height: 32),
          if (holidayInfo != null && holidayInfo.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Celebration: ${holidayInfo['name']}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Text(
              'No special celebration today.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: appColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}