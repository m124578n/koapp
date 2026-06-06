# Kapp — 韓語單字卡學習 App

一款以間隔重複演算法為核心的韓語學習 Flutter 應用程式，支援離線使用，介面提供繁體中文與英文雙語切換。

> 本專案由 [Claude Code](https://claude.ai/code) 撰寫。

## 功能特色

- **翻牌模式** — 點擊卡片翻面，查看韓文、羅馬拼音與中文意思
- **間隔重複（SM-2）** — 根據記憶難度自動排定下次複習時間
- **內建單字牌組** — 預載常用韓語詞彙，開啟即可學習
- **自訂牌組** — 新增、編輯、刪除個人單字卡
- **學習進度圖表** — 14 天每日複習量長條圖
- **連續學習天數與成就徽章** — 激勵持續學習習慣
- **雙語介面** — 繁體中文 / English 即時切換
- **完整離線支援** — 所有資料儲存於本機 SQLite

## 技術架構

| 層級 | 技術 |
|------|------|
| UI 框架 | Flutter 3.44 / Dart 3.12 |
| 狀態管理 | Riverpod 2.6 |
| 本機資料庫 | Drift 2.22（SQLite ORM） |
| 間隔重複 | SM-2 演算法 |
| 圖表 | fl_chart |
| 多語系 | flutter_localizations + intl（ARB） |

## 專案結構

```
lib/
├── core/
│   └── l10n/          # 多語系 ARB 檔案
├── data/
│   ├── database/      # Drift 資料庫定義與 DAO
│   └── repositories/  # Repository 實作
├── domain/
│   ├── entities/      # 資料模型
│   └── usecases/      # SM-2 計算、成就判斷
└── presentation/
    ├── providers/     # Riverpod providers
    └── screens/       # 各頁面 UI
```

## 安裝與執行

### 環境需求

- Flutter 3.44+
- Android Studio（含 Android SDK Command-line Tools）

### 執行步驟

```bash
# 安裝依賴
flutter pub get

# 產生 Drift 程式碼
flutter pub run build_runner build --delete-conflicting-outputs

# 啟動 App（連接裝置或模擬器）
flutter run

# 打包 APK
flutter build apk --release
```

## GitHub

[https://github.com/m124578n/koapp](https://github.com/m124578n/koapp)
