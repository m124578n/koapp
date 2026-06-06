# TTS 語音朗讀功能 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在練習畫面加入語音朗讀功能，有 API key 走 Google Cloud TTS，無 key 降級用 flutter_tts。

**Architecture:** TtsService 封裝 HTTP + flutter_tts 雙引擎，TtsNotifier 管理 autoPlay / apiKeyInvalid 狀態並暴露 speak() 給 UI。Deck entity 加 language(BCP-47) 欄位，ReviewScreen 透過 ref.listen 監聽卡片切換觸發自動播放。

**Tech Stack:** flutter_tts ^4.2.0、audioplayers ^6.1.0、http ^1.2.0、Riverpod StateNotifierProvider、Drift schemaVersion 2 migration

---

### Task 1: 新增套件依賴

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: 在 pubspec.yaml 的 dependencies 區塊加入三個套件**

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  flutter_riverpod: ^2.6.0
  drift: ^2.22.0
  sqlite3_flutter_libs: ^0.5.21
  path_provider: ^2.1.3
  path: ^1.9.0
  uuid: ^4.5.0
  fl_chart: ^0.69.0
  shared_preferences: ^2.3.2
  intl: ^0.20.1
  url_launcher: ^6.3.0
  flutter_tts: ^4.2.0
  audioplayers: ^6.1.0
  http: ^1.2.0
```

- [ ] **Step 2: 安裝套件**

```bash
flutter pub get
```

Expected output 包含：`+ flutter_tts`, `+ audioplayers`, `+ http`，結尾 `Got dependencies!`

- [ ] **Step 3: 確認無分析錯誤**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: add flutter_tts, audioplayers, http dependencies"
```

---

### Task 2: DB Migration — Decks 加 language 欄位

**Files:**
- Modify: `lib/data/database/tables.dart`
- Modify: `lib/data/database/app_database.dart`
- Modify: `lib/data/database/seed_data.dart`

- [ ] **Step 1: 在 tables.dart 的 Decks class 加入 language 欄位**

在 `isBuiltIn` 欄位後加一行：

```dart
@DataClassName('DeckRow')
class Decks extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get level => text()(); // 'beginner' | 'intermediate' | 'all'
  BoolColumn get isBuiltIn =>
      boolean().withDefault(const Constant(false))();
  TextColumn get language =>
      text().withDefault(const Constant('ko-KR'))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
```

- [ ] **Step 2: 在 app_database.dart 升版到 schemaVersion 2 並加 onUpgrade**

```dart
// lib/data/database/app_database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';
import 'daos/deck_dao.dart';
import 'daos/card_dao.dart';
import 'daos/review_dao.dart';
import 'daos/stats_dao.dart';
import 'seed_data.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Decks,
    Cards,
    ReviewRecords,
    AchievementsTable,
    UserStatsTable,
    DailyReviewCounts,
  ],
  daos: [DeckDao, CardDao, ReviewDao, StatsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await seedBuiltInData(this);
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(decks, decks.language);
            // 現有內建牌組補 ko-KR
            await (update(decks)..where((t) => t.isBuiltIn.equals(true)))
                .write(const DecksCompanion(language: Value('ko-KR')));
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'kapp.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
```

- [ ] **Step 3: 在 seed_data.dart 的兩個內建 deck companion 加上 language**

```dart
await db.into(db.decks).insertOnConflictUpdate(DecksCompanion(
  id: const Value('deck-beginner'),
  name: const Value('初級韓文 / Beginner Korean'),
  description: const Value('基礎詞彙、問候語、數字'),
  level: const Value('beginner'),
  isBuiltIn: const Value(true),
  language: const Value('ko-KR'),
  createdAt: Value(DateTime(2026)),
));
await db.into(db.decks).insertOnConflictUpdate(DecksCompanion(
  id: const Value('deck-intermediate'),
  name: const Value('進階韓文 / Intermediate Korean'),
  description: const Value('常用句型、旅遊、購物'),
  level: const Value('intermediate'),
  isBuiltIn: const Value(true),
  language: const Value('ko-KR'),
  createdAt: Value(DateTime(2026)),
));
```

- [ ] **Step 4: 重新生成 Drift 程式碼**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Expected: `[INFO] build_runner: Succeeded after ...`，無 error。

- [ ] **Step 5: 分析確認**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib/data/database/tables.dart lib/data/database/app_database.dart lib/data/database/seed_data.dart lib/data/database/app_database.g.dart lib/data/database/daos/deck_dao.g.dart
git commit -m "feat: add language column to decks table (migration v2)"
```

---

### Task 3: Deck Entity + Repository 加入 language

**Files:**
- Modify: `lib/domain/entities/deck.dart`
- Modify: `lib/data/repositories/deck_repository_impl.dart`

- [ ] **Step 1: 更新 Deck entity**

```dart
// lib/domain/entities/deck.dart
enum DeckLevel { beginner, intermediate, all }

class Deck {
  final String id;
  final String name;
  final String description;
  final DeckLevel level;
  final bool isBuiltIn;
  final String language;
  final DateTime createdAt;

  const Deck({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.isBuiltIn,
    required this.language,
    required this.createdAt,
  });
}
```

- [ ] **Step 2: 更新 DeckRepositoryImpl**

`_toDomain` 加入 `language: row.language`；`createDeck` 的 `DecksCompanion` 加入 `language: Value(deck.language)`：

```dart
// lib/data/repositories/deck_repository_impl.dart
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/deck.dart';
import '../../domain/repositories/deck_repository.dart';
import '../database/app_database.dart';

class DeckRepositoryImpl implements DeckRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  DeckRepositoryImpl(this._db);

  @override
  Future<List<Deck>> getAllDecks() async {
    final rows = await _db.deckDao.getAllDecks();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<List<Deck>> getDecksByLevel(DeckLevel level) async {
    final rows = await _db.deckDao.getDecksByLevel(_levelToString(level));
    return rows.map(_toDomain).toList();
  }

  @override
  Future<void> createDeck(Deck deck) async {
    await _db.deckDao.insertDeck(DecksCompanion(
      id: Value(deck.id.isEmpty ? _uuid.v4() : deck.id),
      name: Value(deck.name),
      description: Value(deck.description),
      level: Value(_levelToString(deck.level)),
      isBuiltIn: Value(deck.isBuiltIn),
      language: Value(deck.language),
      createdAt: Value(deck.createdAt),
    ));
  }

  @override
  Future<void> deleteDeck(String deckId) =>
      _db.deckDao.deleteDeckById(deckId);

  Deck _toDomain(DeckRow row) => Deck(
        id: row.id,
        name: row.name,
        description: row.description,
        level: _levelFromString(row.level),
        isBuiltIn: row.isBuiltIn,
        language: row.language,
        createdAt: row.createdAt,
      );

  String _levelToString(DeckLevel l) => l.name;
  DeckLevel _levelFromString(String s) =>
      DeckLevel.values.firstWhere((e) => e.name == s, orElse: () => DeckLevel.all);
}
```

- [ ] **Step 3: 分析確認**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add lib/domain/entities/deck.dart lib/data/repositories/deck_repository_impl.dart
git commit -m "feat: add language field to Deck entity and repository"
```

---

### Task 4: TtsService

**Files:**
- Create: `lib/core/services/tts_service.dart`

- [ ] **Step 1: 建立 lib/core/services/ 目錄並建立 tts_service.dart**

```dart
// lib/core/services/tts_service.dart
import 'dart:convert';
import 'dart:typed_data';
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
```

- [ ] **Step 2: 分析確認**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/core/services/tts_service.dart
git commit -m "feat: add TtsService with Google Cloud TTS and flutter_tts fallback"
```

---

### Task 5: TtsProvider

**Files:**
- Create: `lib/presentation/providers/tts_provider.dart`

- [ ] **Step 1: 建立 tts_provider.dart**

```dart
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
```

- [ ] **Step 2: 分析確認**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/providers/tts_provider.dart
git commit -m "feat: add TtsProvider with autoPlay and apiKeyInvalid state"
```

---

### Task 6: l10n — 新增 TTS 相關字串

**Files:**
- Modify: `lib/core/l10n/app_zh.arb`
- Modify: `lib/core/l10n/app_en.arb`
- Modify: `lib/core/l10n/app_localizations.dart`
- Modify: `lib/core/l10n/app_localizations_zh.dart`
- Modify: `lib/core/l10n/app_localizations_en.dart`

- [ ] **Step 1: 在 app_zh.arb 的最後一個 key 前加入新字串**

在 `"meaningRequired"` 之前加入：

```json
  "deckLanguage": "語言",
  "ttsAutoPlay": "自動朗讀單字",
  "ttsApiKeyLabel": "Google TTS API Key",
  "ttsApiKeyHint": "預設使用裝置內建語音。輸入 Google Cloud TTS API key 可獲得更自然的朗讀效果。",
  "ttsTest": "測試",
  "ttsTestSuccess": "API key 正常",
  "ttsTestInvalidKey": "API key 無效，請確認後重試",
  "ttsTestNetworkError": "網路連線失敗",
  "ttsApiKeyInvalidWarning": "API key 無效，目前使用裝置內建語音",
  "ttsSpeakUnsupportedWithKey": "無法朗讀，請確認 API key 是否正確",
  "ttsSpeakUnsupportedNoKey": "請先在設定頁輸入 Google TTS API key，或確認裝置已安裝語音套件",
```

- [ ] **Step 2: 在 app_en.arb 同位置加入對應英文**

```json
  "deckLanguage": "Language",
  "ttsAutoPlay": "Auto-play pronunciation",
  "ttsApiKeyLabel": "Google TTS API Key",
  "ttsApiKeyHint": "Uses device TTS by default. Enter a Google Cloud TTS API key for higher quality audio.",
  "ttsTest": "Test",
  "ttsTestSuccess": "API key is valid",
  "ttsTestInvalidKey": "Invalid API key, please check and try again",
  "ttsTestNetworkError": "Network connection failed",
  "ttsApiKeyInvalidWarning": "Invalid API key, using device TTS",
  "ttsSpeakUnsupportedWithKey": "Cannot play audio, please check your API key",
  "ttsSpeakUnsupportedNoKey": "Please enter a Google TTS API key in Settings, or ensure your device has TTS installed",
```

- [ ] **Step 3: 在 app_localizations.dart 新增 abstract getters**

在最後一個 getter (`String get meaningRequired;`) 後加入：

```dart
  /// No description provided for @deckLanguage.
  ///
  /// In zh, this message translates to:
  /// **'語言'**
  String get deckLanguage;

  /// No description provided for @ttsAutoPlay.
  ///
  /// In zh, this message translates to:
  /// **'自動朗讀單字'**
  String get ttsAutoPlay;

  /// No description provided for @ttsApiKeyLabel.
  ///
  /// In zh, this message translates to:
  /// **'Google TTS API Key'**
  String get ttsApiKeyLabel;

  /// No description provided for @ttsApiKeyHint.
  ///
  /// In zh, this message translates to:
  /// **'預設使用裝置內建語音。輸入 Google Cloud TTS API key 可獲得更自然的朗讀效果。'**
  String get ttsApiKeyHint;

  /// No description provided for @ttsTest.
  ///
  /// In zh, this message translates to:
  /// **'測試'**
  String get ttsTest;

  /// No description provided for @ttsTestSuccess.
  ///
  /// In zh, this message translates to:
  /// **'API key 正常'**
  String get ttsTestSuccess;

  /// No description provided for @ttsTestInvalidKey.
  ///
  /// In zh, this message translates to:
  /// **'API key 無效，請確認後重試'**
  String get ttsTestInvalidKey;

  /// No description provided for @ttsTestNetworkError.
  ///
  /// In zh, this message translates to:
  /// **'網路連線失敗'**
  String get ttsTestNetworkError;

  /// No description provided for @ttsApiKeyInvalidWarning.
  ///
  /// In zh, this message translates to:
  /// **'API key 無效，目前使用裝置內建語音'**
  String get ttsApiKeyInvalidWarning;

  /// No description provided for @ttsSpeakUnsupportedWithKey.
  ///
  /// In zh, this message translates to:
  /// **'無法朗讀，請確認 API key 是否正確'**
  String get ttsSpeakUnsupportedWithKey;

  /// No description provided for @ttsSpeakUnsupportedNoKey.
  ///
  /// In zh, this message translates to:
  /// **'請先在設定頁輸入 Google TTS API key，或確認裝置已安裝語音套件'**
  String get ttsSpeakUnsupportedNoKey;
```

- [ ] **Step 4: 在 app_localizations_zh.dart 加入繁中實作**

在最後一個 `@override` getter 後加入：

```dart
  @override
  String get deckLanguage => '語言';

  @override
  String get ttsAutoPlay => '自動朗讀單字';

  @override
  String get ttsApiKeyLabel => 'Google TTS API Key';

  @override
  String get ttsApiKeyHint => '預設使用裝置內建語音。輸入 Google Cloud TTS API key 可獲得更自然的朗讀效果。';

  @override
  String get ttsTest => '測試';

  @override
  String get ttsTestSuccess => 'API key 正常';

  @override
  String get ttsTestInvalidKey => 'API key 無效，請確認後重試';

  @override
  String get ttsTestNetworkError => '網路連線失敗';

  @override
  String get ttsApiKeyInvalidWarning => 'API key 無效，目前使用裝置內建語音';

  @override
  String get ttsSpeakUnsupportedWithKey => '無法朗讀，請確認 API key 是否正確';

  @override
  String get ttsSpeakUnsupportedNoKey => '請先在設定頁輸入 Google TTS API key，或確認裝置已安裝語音套件';
```

- [ ] **Step 5: 在 app_localizations_en.dart 加入英文實作**

```dart
  @override
  String get deckLanguage => 'Language';

  @override
  String get ttsAutoPlay => 'Auto-play pronunciation';

  @override
  String get ttsApiKeyLabel => 'Google TTS API Key';

  @override
  String get ttsApiKeyHint => 'Uses device TTS by default. Enter a Google Cloud TTS API key for higher quality audio.';

  @override
  String get ttsTest => 'Test';

  @override
  String get ttsTestSuccess => 'API key is valid';

  @override
  String get ttsTestInvalidKey => 'Invalid API key, please check and try again';

  @override
  String get ttsTestNetworkError => 'Network connection failed';

  @override
  String get ttsApiKeyInvalidWarning => 'Invalid API key, using device TTS';

  @override
  String get ttsSpeakUnsupportedWithKey => 'Cannot play audio, please check your API key';

  @override
  String get ttsSpeakUnsupportedNoKey => 'Please enter a Google TTS API key in Settings, or ensure your device has TTS installed';
```

- [ ] **Step 6: 分析確認**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 7: Commit**

```bash
git add lib/core/l10n/
git commit -m "feat: add TTS l10n strings (zh/en)"
```

---

### Task 7: 設定頁 — autoPlay 開關 + API Key 輸入

**Files:**
- Modify: `lib/presentation/screens/settings/settings_screen.dart`

- [ ] **Step 1: 將 settings_screen.dart 完整替換為以下內容**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/locale_provider.dart';
import '../../providers/tts_provider.dart';
import '../../../core/l10n/app_localizations.dart';

final dailyGoalProvider = StateNotifierProvider<DailyGoalNotifier, int>(
  (ref) => DailyGoalNotifier(),
);

class DailyGoalNotifier extends StateNotifier<int> {
  static const _key = 'daily_goal';
  DailyGoalNotifier() : super(10) {
    _load();
  }
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) state = prefs.getInt(_key) ?? 10;
  }
  Future<void> setGoal(int goal) async {
    state = goal;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, goal);
  }
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _apiKeyCtrl = TextEditingController();
  bool _testing = false;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('tts_api_key') ?? '';
    if (mounted) _apiKeyCtrl.text = key;
  }

  @override
  void dispose() {
    _apiKeyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final goal = ref.watch(dailyGoalProvider);
    final ttsState = ref.watch(ttsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.tabSettings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l.language),
            trailing: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'zh', label: Text('繁中')),
                ButtonSegment(value: 'en', label: Text('EN')),
              ],
              selected: {locale.languageCode},
              onSelectionChanged: (set) {
                ref.read(localeProvider.notifier).setLocale(Locale(set.first));
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: Text(l.dailyGoal),
            subtitle: Text('$goal ${l.cards}'),
            trailing: SizedBox(
              width: 120,
              child: Slider(
                value: goal.toDouble(),
                min: 5,
                max: 50,
                divisions: 9,
                label: '$goal',
                onChanged: (v) =>
                    ref.read(dailyGoalProvider.notifier).setGoal(v.round()),
              ),
            ),
          ),
          const Divider(),
          // TTS: auto-play toggle
          SwitchListTile(
            secondary: const Icon(Icons.volume_up),
            title: Text(l.ttsAutoPlay),
            value: ttsState.autoPlay,
            onChanged: (v) =>
                ref.read(ttsProvider.notifier).setAutoPlay(v),
          ),
          // TTS: API key
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.key, size: 20, color: Colors.grey),
                    const SizedBox(width: 12),
                    Text(l.ttsApiKeyLabel,
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                const SizedBox(height: 4),
                Text(l.ttsApiKeyHint,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey)),
                const SizedBox(height: 8),
                TextField(
                  controller: _apiKeyCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    isDense: true,
                    errorText: ttsState.apiKeyInvalid
                        ? l.ttsApiKeyInvalidWarning
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(ttsProvider.notifier)
                            .setApiKey(_apiKeyCtrl.text.trim());
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('已儲存')),
                          );
                        }
                      },
                      child: Text(l.save),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _testing
                          ? null
                          : () async {
                              setState(() => _testing = true);
                              final result = await ref
                                  .read(ttsProvider.notifier)
                                  .testApiKey(_apiKeyCtrl.text.trim());
                              if (!mounted) return;
                              setState(() => _testing = false);
                              final msg = switch (result) {
                                TtsTestResult.success => l.ttsTestSuccess,
                                TtsTestResult.invalidKey => l.ttsTestInvalidKey,
                                TtsTestResult.networkError =>
                                  l.ttsTestNetworkError,
                              };
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(msg)),
                              );
                            },
                      child: _testing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l.ttsTest),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l.about),
            onTap: () => showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(l.appTitle),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Version 1.0.0',
                        style: Theme.of(ctx).textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    const Text('Written by Claude Code',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => launchUrl(
                        Uri.parse('https://github.com/m124578n/koapp'),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: const Text(
                        'github.com/m124578n/koapp',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: 分析確認**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/screens/settings/settings_screen.dart
git commit -m "feat: add TTS settings (auto-play toggle, API key input with test button)"
```

---

### Task 8: Library Screen — 語言下拉選單

**Files:**
- Modify: `lib/presentation/screens/library/library_screen.dart`

- [ ] **Step 1: 更新 _showNewDeckDialog 加入語言選擇**

將 `_showNewDeckDialog` 方法和 `LibraryScreen` 的 `build` 一起換成使用 `StatefulBuilder`：

```dart
void _showNewDeckDialog(BuildContext context, WidgetRef ref) {
  final controller = TextEditingController();
  final l = AppLocalizations.of(context)!;
  String selectedLanguage = 'ko-KR';

  const languages = [
    ('韓文', 'ko-KR'),
    ('日文', 'ja-JP'),
    ('英文', 'en-US'),
    ('中文（台灣）', 'zh-TW'),
    ('法文', 'fr-FR'),
    ('西班牙文', 'es-ES'),
    ('德文', 'de-DE'),
  ];

  showDialog<void>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) => AlertDialog(
        title: Text(l.newDeck),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: l.deckName),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              decoration: InputDecoration(labelText: l.deckLanguage),
              items: languages
                  .map((e) => DropdownMenuItem(
                        value: e.$2,
                        child: Text(e.$1),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) setDialogState(() => selectedLanguage = v);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.dispose();
              Navigator.pop(ctx);
            },
            child: Text(l.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              final repo = ref.read(deckRepositoryProvider);
              await repo.createDeck(Deck(
                id: '',
                name: controller.text.trim(),
                description: '',
                level: DeckLevel.all,
                isBuiltIn: false,
                language: selectedLanguage,
                createdAt: DateTime.now(),
              ));
              ref.invalidate(allDecksProvider);
              controller.dispose();
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(l.save),
          ),
        ],
      ),
    ),
  );
}
```

- [ ] **Step 2: 分析確認**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/screens/library/library_screen.dart
git commit -m "feat: add language dropdown to new deck dialog"
```

---

### Task 9: Review Screen — 喇叭按鈕 + 自動播放

**Files:**
- Modify: `lib/presentation/screens/study/review_screen.dart`

- [ ] **Step 1: 將 review_screen.dart 完整替換為以下內容**

```dart
// lib/presentation/screens/study/review_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../domain/entities/deck.dart';
import '../../providers/review_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/tts_provider.dart';

enum ReviewMode { flip, spacedRepetition }

class ReviewScreen extends ConsumerWidget {
  final Deck deck;
  final ReviewMode mode;

  const ReviewScreen({super.key, required this.deck, required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final sessionAsync = ref.watch(reviewNotifierProvider(deck.id));
    final locale = ref.watch(localeProvider);
    final ttsState = ref.watch(ttsProvider);
    final ttsNotifier = ref.read(ttsProvider.notifier);

    // Auto-play listener
    ref.listen<AsyncValue<ReviewSession>>(
      reviewNotifierProvider(deck.id),
      (previous, current) {
        current.whenData((session) {
          if (!ttsState.autoPlay || session.isComplete) return;
          final prev = previous?.valueOrNull;
          // First card loaded
          if (prev == null && !session.isFlipped) {
            ttsNotifier.speak(session.currentCard!.korean, deck.language);
            return;
          }
          // Next card
          if (prev != null &&
              prev.currentIndex != session.currentIndex &&
              !session.isFlipped) {
            ttsNotifier.speak(session.currentCard!.korean, deck.language);
            return;
          }
          // Card flipped
          if (prev != null && !prev.isFlipped && session.isFlipped) {
            ttsNotifier.speak(session.currentCard!.korean, deck.language);
          }
        });
      },
    );

    void onSpeak(String word) {
      if (!ttsState.ttsSupported) {
        final hasKey = !ttsState.apiKeyInvalid;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(hasKey
                ? l.ttsSpeakUnsupportedWithKey
                : l.ttsSpeakUnsupportedNoKey),
          ),
        );
        return;
      }
      ttsNotifier.speak(word, deck.language);
    }

    return Scaffold(
      appBar: AppBar(title: Text(deck.name)),
      body: sessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (session) {
          if (session.isComplete) {
            return _SessionComplete(
              total: session.cards.length,
              correct: session.sessionCorrect,
              deckId: deck.id,
            );
          }

          final card = session.currentCard!;
          final meaning = locale.languageCode == 'zh'
              ? card.meaningZh
              : card.meaningEn;

          return Column(
            children: [
              LinearProgressIndicator(
                value: session.currentIndex / session.cards.length,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: session.isFlipped
                      ? null
                      : () => ref
                          .read(reviewNotifierProvider(deck.id).notifier)
                          .flip(),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: session.isFlipped
                        ? _CardBack(
                            key: const ValueKey('back'),
                            korean: card.korean,
                            romanization: card.romanization,
                            meaning: meaning,
                            example: card.exampleSentence,
                            translation: card.exampleTranslation,
                            ttsSupported: ttsState.ttsSupported,
                            onSpeak: () => onSpeak(card.korean),
                          )
                        : _CardFront(
                            key: const ValueKey('front'),
                            korean: card.korean,
                            hint: l.flipToReveal,
                            ttsSupported: ttsState.ttsSupported,
                            onSpeak: () => onSpeak(card.korean),
                          ),
                  ),
                ),
              ),
              if (session.isFlipped)
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: _RatingButtons(mode: mode, deckId: deck.id),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _CardFront extends StatelessWidget {
  final String korean;
  final String hint;
  final bool ttsSupported;
  final VoidCallback onSpeak;

  const _CardFront({
    super.key,
    required this.korean,
    required this.hint,
    required this.ttsSupported,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(korean,
                        style: Theme.of(context).textTheme.displayMedium),
                    const SizedBox(height: 24),
                    Text(hint,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey)),
                  ],
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  icon: Icon(Icons.volume_up,
                      color: ttsSupported ? null : Colors.grey),
                  onPressed: onSpeak,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  final String korean;
  final String romanization;
  final String meaning;
  final String example;
  final String translation;
  final bool ttsSupported;
  final VoidCallback onSpeak;

  const _CardBack({
    super.key,
    required this.korean,
    required this.romanization,
    required this.meaning,
    required this.example,
    required this.translation,
    required this.ttsSupported,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(korean,
                        style: Theme.of(context).textTheme.displaySmall),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(romanization,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.blueGrey)),
                  ),
                  const Divider(height: 32),
                  Text(meaning,
                      style: Theme.of(context).textTheme.headlineSmall),
                  if (example.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(example,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontStyle: FontStyle.italic)),
                    const SizedBox(height: 4),
                    Text(translation,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey)),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.volume_up,
                      color: ttsSupported ? null : Colors.grey),
                  onPressed: onSpeak,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingButtons extends ConsumerWidget {
  final ReviewMode mode;
  final String deckId;

  const _RatingButtons({required this.mode, required this.deckId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;

    if (mode == ReviewMode.flip) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () =>
                ref.read(reviewNotifierProvider(deckId).notifier).nextFlipCard(),
            child: Text(l.nextCard),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _ratingBtn(context, ref, l.btnDontKnow, 0, Colors.red),
          _ratingBtn(context, ref, l.btnHard, 1, Colors.orange),
          _ratingBtn(context, ref, l.btnGood, 2, Colors.blue),
          _ratingBtn(context, ref, l.btnEasy, 3, Colors.green),
        ],
      ),
    );
  }

  Widget _ratingBtn(
    BuildContext context,
    WidgetRef ref,
    String label,
    int rating,
    Color color,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: color),
          onPressed: () =>
              ref.read(reviewNotifierProvider(deckId).notifier).rateCard(rating),
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}

class _SessionComplete extends ConsumerStatefulWidget {
  final int total;
  final int correct;
  final String deckId;

  const _SessionComplete({
    required this.total,
    required this.correct,
    required this.deckId,
  });

  @override
  ConsumerState<_SessionComplete> createState() => _SessionCompleteState();
}

class _SessionCompleteState extends ConsumerState<_SessionComplete> {
  bool _finalized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_finalized || !mounted) return;
      _finalized = true;
      ref
          .read(reviewNotifierProvider(widget.deckId).notifier)
          .finalizeSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final accuracy =
        widget.total > 0 ? (widget.correct / widget.total * 100).round() : 0;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
          const SizedBox(height: 16),
          Text(l.sessionComplete,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(l.cardsReviewed(widget.total)),
          Text('$accuracy% ${l.accuracy}'),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.tabStudy),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: 分析確認**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/screens/study/review_screen.dart
git commit -m "feat: add speaker button and auto-play to review screen"
```

---

### Task 10: 最終整合驗證

- [ ] **Step 1: 完整分析**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 2: 在模擬器或實機執行 App**

```bash
flutter run
```

驗證清單：
- [ ] 設定頁有「自動朗讀單字」開關
- [ ] 設定頁有 Google TTS API Key 輸入框 + 儲存 + 測試按鈕
- [ ] 測試按鈕期間顯示 loading
- [ ] 新增牌組 dialog 有語言下拉選單，預設韓文
- [ ] 練習卡片正面和背面都有喇叭按鈕
- [ ] 沒有 API key 時卡片切換可以聽到系統 TTS（如果裝置有安裝）

- [ ] **Step 3: Final commit**

```bash
git add .
git commit -m "feat: TTS pronunciation feature complete"
git push origin master
```
