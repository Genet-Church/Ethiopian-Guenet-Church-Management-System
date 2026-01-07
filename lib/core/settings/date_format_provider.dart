import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'date_format_provider.g.dart';

enum DateFormatType { gregorian, ethiopian }

@riverpod
class DateFormatNotifier extends _$DateFormatNotifier {
  @override
  DateFormatType build() {
    _loadDateFormatFromPrefs();
    return DateFormatType.gregorian;
  }

  Future<void> _loadDateFormatFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('dateFormat') ?? DateFormatType.gregorian.index;
    state = DateFormatType.values[index];
  }

  Future<void> setDateFormat(DateFormatType type) async {
    if (state != type) {
      state = type;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('dateFormat', type.index);
    }
  }
}
