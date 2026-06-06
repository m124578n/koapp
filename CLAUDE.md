# Kapp — 韓語單字卡 App

## 專案簡介

Flutter 韓語學習 App，使用 SM-2 間隔重複演算法，目標平台為 Android APK。

## 常用指令

```bash
# 安裝依賴
flutter pub get

# 產生 Drift 程式碼（修改 database schema 後必須執行）
flutter pub run build_runner build --delete-conflicting-outputs

# 靜態分析
flutter analyze

# 執行 App（需連接裝置或啟動模擬器）
flutter run

# 打包 Release APK
flutter build apk --release
```

## 架構

Clean Architecture 三層：

- `lib/domain/` — 純 Dart，無 Flutter 依賴：entities、use cases（SM-2 計算、成就判斷）
- `lib/data/` — Drift SQLite ORM、repository 實作
- `lib/presentation/` — Riverpod providers、Flutter UI screens

## 關鍵技術決策

- **Drift ORM**：`@DataClassName` 標註避免命名衝突（`DeckRow`、`CardRow`、`ReviewRecordRow`）
- **Riverpod**：`sharedPreferencesProvider` 在 `main()` 以 `overrideWithValue` 注入，確保 locale 同步初始化不閃爍
- **StateNotifier 非同步載入**：`_load()` 內必須加 `if (mounted)` 防止 build scope 錯誤
- **SM-2 評分**：0 = 不會、1 = 困難、2 = 普通、3 = 簡單；easeFactor 最低 1.3
- **連續天數計算**：使用 `_calendarDaysBetween()`（截斷至日期）而非 `.inDays`，避免跨日邊界錯誤

## 多語系

- ARB 檔案位於 `lib/core/l10n/`
- 模板檔為 `app_zh.arb`（繁體中文）
- 支援語言：`zh`（繁體中文）、`en`（英文）

## 資料庫 Schema

| Table | 說明 |
|-------|------|
| `decks` | 牌組（內建 + 自訂） |
| `cards` | 韓語單字卡 |
| `review_records` | SM-2 複習記錄 |
| `daily_counts` | 每日複習數量（圖表用） |
| `user_stats` | 連續天數、總複習數 |
| `achievements` | 成就解鎖狀態 |

## 注意事項

- 修改 `.dart` 資料庫 schema 後必須重跑 `build_runner`
- `_SessionComplete` 使用 `_finalized` flag 防止 `finalizeSession()` 重複觸發
- `AchievementCondition` 的 `_conditionFromString` 使用明確 case + `throw ArgumentError`，不可用 default fallback
