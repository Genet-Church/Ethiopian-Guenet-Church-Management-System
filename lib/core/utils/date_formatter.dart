import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genet_church_portal/core/settings/date_format_provider.dart';
import 'package:intl/intl.dart';
import 'package:abushakir/abushakir.dart';

class AppDateFormatter {
  static String format(DateTime date, WidgetRef ref) {
    final dateFormatType = ref.watch(dateFormatNotifierProvider);

    if (dateFormatType == DateFormatType.ethiopian) {
      final ethiopianDate = EtDatetime.fromMillisecondsSinceEpoch(
        date.millisecondsSinceEpoch,
      );
      final calendar = ETC(
        year: ethiopianDate.year,
        month: ethiopianDate.month,
        day: ethiopianDate.day,
      );
      // Format: Month Day, Year (e.g., Meskerem 1, 2016)
      return '${calendar.monthName} ${calendar.day}, ${calendar.year}';
    } else {
      return DateFormat.yMMMMd().format(date);
    }
  }

  static String formatShort(DateTime date, WidgetRef ref) {
    final dateFormatType = ref.watch(dateFormatNotifierProvider);

    if (dateFormatType == DateFormatType.ethiopian) {
      final ethiopianDate = EtDatetime.fromMillisecondsSinceEpoch(
        date.millisecondsSinceEpoch,
      );
      return '${ethiopianDate.day}/${ethiopianDate.month}/${ethiopianDate.year}';
    } else {
      return DateFormat.yMd().format(date);
    }
  }
}
