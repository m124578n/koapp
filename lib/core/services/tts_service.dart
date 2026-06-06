// lib/core/services/tts_service.dart
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;

enum TtsTestResult { success, invalidKey, networkError }

class TtsService {
  final http.Client _client;
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _player = AudioPlayer();

  String _apiKey = '';
  bool _isSupported = true;
  bool _apiKeyFailed = false;

  bool get isSupported => _isSupported;
  bool get apiKeyFailed => _apiKeyFailed;

  TtsService({http.Client? client}) : _client = client ?? http.Client();

  void setApiKey(String key) {
    _apiKey = key;
    _apiKeyFailed = false;
  }

  Future<void> speak(String text, String languageCode) async {
    if (_apiKey.isNotEmpty && !_apiKeyFailed) {
      final ok = await _speakWithGoogle(text, languageCode);
      if (ok) return;
    }
    await _speakWithFlutterTts(text, languageCode);
  }

  Future<bool> _speakWithGoogle(String text, String languageCode) async {
    try {
      final response = await _client.post(
        Uri.parse(
            'https://texttospeech.googleapis.com/v1/text:synthesize?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'input': {'text': text},
          'voice': {'languageCode': languageCode},
          'audioConfig': {'audioEncoding': 'MP3'},
        }),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final bytes = base64Decode(json['audioContent'] as String);
        await _player.play(BytesSource(bytes));
        return true;
      } else if (response.statusCode == 400 || response.statusCode == 403) {
        _apiKeyFailed = true;
        return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _speakWithFlutterTts(String text, String languageCode) async {
    final result = await _flutterTts.setLanguage(languageCode);
    if (result == -1) {
      _isSupported = false;
      return;
    }
    _isSupported = true;
    await _flutterTts.speak(text);
  }

  Future<TtsTestResult> testApiKey(String key) async {
    try {
      final response = await _client.post(
        Uri.parse(
            'https://texttospeech.googleapis.com/v1/text:synthesize?key=$key'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'input': {'text': '안녕하세요'},
          'voice': {'languageCode': 'ko-KR'},
          'audioConfig': {'audioEncoding': 'MP3'},
        }),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final bytes = base64Decode(json['audioContent'] as String);
        await _player.play(BytesSource(bytes));
        return TtsTestResult.success;
      } else if (response.statusCode == 400 || response.statusCode == 403) {
        return TtsTestResult.invalidKey;
      }
      return TtsTestResult.networkError;
    } catch (_) {
      return TtsTestResult.networkError;
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    await _player.stop();
  }

  void dispose() {
    _client.close();
    _player.dispose();
  }
}
