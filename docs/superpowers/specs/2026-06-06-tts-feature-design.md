# TTS 語音朗讀功能 設計文件

## 目標

在練習畫面加入語音朗讀功能，讓使用者在翻牌時能聽到單字發音。預設使用裝置內建 TTS（`flutter_tts`），使用者可在設定頁輸入 Google Cloud TTS API key 升級為更自然的語音品質。

---

## 功能範圍

### 1. TtsService（核心服務）

**位置：** `lib/core/services/tts_service.dart`

**對外介面：**
```dart
Future<void> speak(String text, String languageCode);
Future<void> stop();
bool get isSupported; // 目前語言是否可用
```

**內部邏輯（優先順序）：**
1. 若 `apiKey` 不為空 → 呼叫 Google Cloud TTS REST API，拿回 base64 MP3，用 `audioplayers` 從記憶體播放
2. 若 `apiKey` 為空 → 呼叫 `flutter_tts`
3. 若 `flutter_tts` 回報語言不支援 → 設 `isSupported = false`

**Google Cloud TTS REST：**
- Endpoint：`POST https://texttospeech.googleapis.com/v1/text:synthesize?key={apiKey}`
- Request body：
  ```json
  {
    "input": { "text": "단어" },
    "voice": { "languageCode": "ko-KR" },
    "audioConfig": { "audioEncoding": "MP3" }
  }
  ```
- Response：`{ "audioContent": "<base64 MP3>" }`
- 解碼 base64 → `Uint8List` bytes → `audioplayers` 的 `playBytes()` 直接播放，不寫入任何檔案

**錯誤處理：**
- HTTP 403 / 400（key 錯誤）→ 降級至 `flutter_tts` 並在 provider 標記 `apiKeyInvalid = true`
- 網路錯誤 → 降級至 `flutter_tts`
- 所有錯誤靜默處理，不打斷練習流程

---

### 2. Riverpod Provider

**位置：** `lib/presentation/providers/tts_provider.dart`

```dart
final ttsProvider = StateNotifierProvider<TtsNotifier, TtsState>(...);

class TtsState {
  final bool autoPlay;       // 自動播放開關
  final bool apiKeyInvalid;  // API key 無效標記
}
```

- 啟動時從 `SharedPreferences` 讀取 `api_key` 和 `auto_play`
- 提供 `speak(text, languageCode)`、`setApiKey(key)`、`setAutoPlay(bool)` 方法

---

### 3. 資料層：Deck 語言欄位

**DB Migration：schemaVersion 1 → 2**

`Decks` table 新增：
```dart
TextColumn get language => text().withDefault(const Constant('ko-KR'))();
```

`Deck` entity 新增：
```dart
final String language; // BCP-47，例如 'ko-KR'、'ja-JP'
```

**內建牌組 seed data** 的 language 統一設為 `'ko-KR'`。

---

### 4. 牌組建立 / 編輯畫面

**位置：** `lib/presentation/screens/library/library_screen.dart`（新增牌組 dialog）

新增語言下拉選單（`DropdownButton`），選項：

| 顯示名稱 | languageCode |
|----------|-------------|
| 韓文 | `ko-KR` |
| 日文 | `ja-JP` |
| 英文 | `en-US` |
| 中文（普通話）| `zh-CN` |
| 法文 | `fr-FR` |
| 西班牙文 | `es-ES` |
| 德文 | `de-DE` |

預設選 `ko-KR`。

---

### 5. 設定頁

**位置：** `lib/presentation/screens/settings/settings_screen.dart`

新增兩個項目：

**自動播放開關：**
```
[🔊] 自動朗讀單字    [開關]
```

**Google TTS API Key 輸入：**
```
[🔑] Google TTS API Key
     預設使用裝置內建語音。輸入 Google Cloud TTS API key 可獲得更自然的朗讀效果。
     [輸入框（obscureText）] [儲存]
```
- 若 `apiKeyInvalid == true`，輸入框下方顯示紅色提示「API key 無效，目前使用裝置內建語音」

---

### 6. Review 畫面

**位置：** `lib/presentation/screens/study/review_screen.dart`

**喇叭按鈕：**
- 卡片正面右上角：`IconButton(icon: Icons.volume_up)`
- 卡片背面右上角：同上
- `isSupported == false` 時按鈕顯示灰色（`color: Colors.grey`），點擊後顯示 Snackbar：
  - 有 key：「無法朗讀，請確認 API key 是否正確」
  - 無 key：「請先在設定頁輸入 Google TTS API key，或確認裝置已安裝語音套件」

**自動播放邏輯：**
- `autoPlay == true` 時：
  - 卡片正面出現（`currentIndex` 改變）→ `tts.speak(card.word, deck.language)`
  - 翻到背面（`isFlipped` 變 `true`）→ `tts.speak(card.word, deck.language)`
- 透過 `ref.listen(reviewNotifierProvider(...), ...)` 監聽狀態變化觸發播放

---

## 新增依賴

```yaml
flutter_tts: ^4.2.0
audioplayers: ^6.1.0
http: ^1.2.0
```

---

## 不在範圍內

- 音頻快取（可日後加）
- 語速 / 音調調整
- 錄音 / 使用者發音練習
- 離線 Google TTS
