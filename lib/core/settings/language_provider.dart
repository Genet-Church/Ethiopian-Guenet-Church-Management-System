import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_provider.g.dart';

@riverpod
class LanguageNotifier extends _$LanguageNotifier {
  @override
  Locale build() {
    _loadLanguageFromPrefs();
    return const Locale('en');
  }

  Future<void> _loadLanguageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'en';
    state = Locale(languageCode);
  }

  Future<void> setLanguage(String languageCode) async {
    if (state.languageCode != languageCode) {
      state = Locale(languageCode);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', languageCode);
    }
  }
}
