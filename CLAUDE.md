# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Kapp** 是一個用 Flutter 開發的韓語單字卡學習 App（Android APK），支援繁體中文與英文雙語介面，完全離線運作。使用 SM-2 間隔重複演算法排程複習。

## Commands

```bash
# 安裝依賴
flutter pub get

# 程式碼生成（Drift ORM + 本地化）— 修改資料庫 schema 後必須執行
flutter pub run build_runner build --delete-conflicting-outputs

# 執行 App（需連接裝置或模擬器）
flutter run

# 執行所有測試
flutter test

# 執行單一測試檔案
flutter test test/calculate_sm2_test.dart

# 靜態分析
flutter analyze

# 建置 Release APK
flutter build apk --release

# 清理建置產物
flutter clean
```

## Architecture

採用四層 Clean Architecture：

```
domain/       → 商業邏輯（Entity 定義、Repository 介面、Use Case 演算法）
data/         → 資料存取（Drift SQLite DAO 實作、Repository 實作）
presentation/ → UI 與狀態（Riverpod Provider/Notifier、Screen widgets）
core/         → 共用基礎（l10n ARB 檔案、Material 3 主題）
```

### 資料流

UI Screen → Riverpod FutureProvider/StateNotifier → Repository Interface (domain) → RepositoryImpl (data) → Drift DAO → SQLite

依賴注入透過 `presentation/providers/database_provider.dart` 完成，所有 Repository 實例由 Riverpod ProviderScope 管理。`sharedPreferencesProvider` 在 `main()` 以 `overrideWithValue` 注入，確保 locale 同步初始化不閃爍。

### 核心演算法

- **SM-2 間隔重複**：`domain/usecases/calculate_sm2.dart`
  - 評分：0 = 不會、1 = 困難、2 = 普通、3 = 簡單；easeFactor 下限為 1.3
  - 評分 0–1：重置 interval 為 1；評分 ≥ 2：interval 依序為 1 天 → 6 天 → `round(prev * easeFactor)`
- **成就解鎖判斷**：`domain/usecases/evaluate_achievements.dart`
  - `AchievementCondition` 的 `_conditionFromString` 使用明確 case + `throw ArgumentError`，不可用 default fallback

### 資料庫

Drift ORM 管理六張 SQLite 資料表（schema 定義於 `data/database/tables.dart`）：

| Table | 說明 |
|-------|------|
| `decks` | 牌組（內建 + 自訂） |
| `cards` | 韓語單字卡 |
| `review_records` | SM-2 複習記錄 |
| `daily_counts` | 每日複習數量（圖表用） |
| `user_stats` | 連續天數、總複習數 |
| `achievements` | 成就解鎖狀態 |

`@DataClassName` 標註避免命名衝突（`DeckRow`、`CardRow`、`ReviewRecordRow`）。資料庫檔案位於裝置的 Application Documents Directory（`kapp.sqlite`）。

### 導航結構

`HomeScreen`（BottomNavigationBar 四個分頁）→ Study / Library / Progress / Settings。
Study 流程：`DeckSelectionScreen` → `ModeSelectionScreen` → `ReviewScreen`（卡片翻轉 + SM-2 評分）。

### 本地化

- ARB 檔案位於 `lib/core/l10n/`；模板檔為 `app_zh.arb`（繁體中文），`app_en.arb` 為英文
- 語言設定儲存於 SharedPreferences，透過 `locale_provider.dart` 在 runtime 切換
- `app_localizations.dart` 為自動生成，勿手動編輯

## Key Implementation Notes

- **StateNotifier 非同步載入**：`_load()` 內必須加 `if (mounted)` 防止 build scope 錯誤
- **連續天數計算**：使用 `_calendarDaysBetween()`（截斷至日期）而非 `.inDays`，避免跨日邊界錯誤
- **Session 防重複**：`_SessionComplete` 使用 `_finalized` flag 防止 `finalizeSession()` 重複觸發
- **Schema 變更**：修改任何 `tables.dart` 後必須重跑 `build_runner`
