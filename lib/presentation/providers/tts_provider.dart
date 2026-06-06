// lib/presentation/providers/tts_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/tts_service.dart';

class TtsState {
  final bool autoPlay;
  final bool apiKeyInvalid;
  final bool ttsSupported;

  const TtsState({
    this.autoPlay = true,
    this.apiKeyInvalid = false,
    this.ttsSupported = true,
  });

  TtsState copyWith({
    bool? autoPlay,
    bool? apiKeyInvalid,
    bool? ttsSupported,
  }) =>
      TtsState(
        autoPlay: autoPlay ?? this.autoPlay,
        apiKeyInvalid: apiKeyInvalid ?? this.apiKeyInvalid,
        ttsSupported: ttsSupported ?? this.ttsSupported,
      );
}

class TtsNotifier extends StateNotifier<TtsState> {
  static const _keyApiKey = 'tts_api_key';
  static const _keyAutoPlay = 'tts_auto_play';

  final TtsService _service;

  TtsNotifier(this._service) : super(const TtsState()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(_keyApiKey) ?? '';
    final autoPlay = prefs.getBool(_keyAutoPlay) ?? true;
    _service.setApiKey(key);
    if (mounted) state = state.copyWith(autoPlay: autoPlay);
  }

  Future<void> speak(String text, String languageCode) async {
    await _service.speak(text, languageCode);
    if (mounted) {
      state = state.copyWith(
        apiKeyInvalid: _service.apiKeyFailed ? true : state.apiKeyInvalid,
        ttsSupported: _service.isSupported,
      );
    }
  }

  Future<void> setApiKey(String key) async {
    _service.setApiKey(key);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyApiKey, key);
    if (mounted) state = state.copyWith(apiKeyInvalid: false);
  }

  Future<void> setAutoPlay(bool value) async {
    if (mounted) state = state.copyWith(autoPlay: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoPlay, value);
  }

  Future<TtsTestResult> testApiKey(String key) =>
      _service.testApiKey(key);

  Future<void> stop() => _service.stop();
}

final ttsServiceProvider = Provider<TtsService>((ref) => TtsService());

final ttsProvider = StateNotifierProvider<TtsNotifier, TtsState>(
  (ref) => TtsNotifier(ref.read(ttsServiceProvider)),
);
