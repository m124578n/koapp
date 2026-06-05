// lib/presentation/providers/locale_provider.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in ProviderScope');
});

final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});

class LocaleNotifier extends StateNotifier<Locale> {
  static const _key = 'app_locale';
  final SharedPreferences _prefs;

  LocaleNotifier(this._prefs)
      : super(Locale(_prefs.getString(_key) ?? 'zh'));

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _prefs.setString(_key, locale.languageCode);
  }
}
