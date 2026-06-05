# Korean Flashcard App — Design Spec
Date: 2026-06-05

## Overview

A Flutter-based Korean language learning app using flashcard-style memorization. Targets both complete beginners (starting from Hangul) and intermediate learners expanding vocabulary, with graded content, two review modes, full offline support, bilingual UI, and a gamification system.

**Output target:** Android APK (`flutter build apk --release`)

---

## Goals & Constraints

- **Users:** Beginners and intermediate Korean learners
- **Offline:** Fully offline — no network required, all data stored locally
- **Platform:** Android (Flutter, APK output)
- **Languages:** Traditional Chinese + English UI, switchable at runtime

---

## Architecture

Clean Architecture with three layers, using Riverpod for state management.

```
lib/
├── domain/
│   ├── entities/       # Card, Deck, ReviewRecord, Achievement, UserStats
│   ├── repositories/   # Abstract interfaces
│   └── usecases/       # SM-2 calculation, achievement evaluation
├── data/
│   ├── database/       # SQLite schema via drift, migrations
│   └── repositories/   # Concrete implementations
├── presentation/
│   ├── providers/      # Riverpod providers
│   └── screens/        # All UI screens
└── core/
    ├── l10n/           # zh-TW and en ARB files
    └── theme/          # Colors, typography
```

**Tech stack:**
| Concern | Package |
|---------|---------|
| State management | `riverpod` |
| Local database | `sqflite` + `drift` |
| Spaced repetition | Built-in SM-2 (no external package) |
| Localization | `flutter_localizations` (built-in) |
| APK build | `flutter build apk --release` |

---

## Data Model

### Deck
```
id            UUID
name          String
description   String
level         enum: beginner | intermediate | all
isBuiltIn     bool
language      enum: zh | en
createdAt     DateTime
```

### Card
```
id                  UUID
deckId              UUID (FK → Deck)
korean              String        # e.g. 안녕하세요
romanization        String        # e.g. annyeonghaseyo
meaningZh           String        # 中文意思，e.g. 你好
meaningEn           String        # English meaning, e.g. Hello
exampleSentence     String        # Korean example sentence
exampleTranslation  String        # Translation (zh or en, stored as-is)
createdAt           DateTime
```
Built-in cards always populate both `meaningZh` and `meaningEn`. For user-created cards, at least one meaning field must be non-empty; the UI shows the field matching the current language setting, falling back to the other if empty.

### ReviewRecord
```
cardId          UUID (FK → Card)
easeFactor      double        # default 2.5
interval        int           # days until next review
repetitions     int           # consecutive correct answers
nextReviewAt    DateTime
lastReviewedAt  DateTime
```

### Achievement
```
id          UUID
titleKey    String    # l10n key
descKey     String    # l10n key
iconName    String
condition   enum      # first_review | streak_days | total_reviewed | perfect_session | created_deck
threshold   int
```

### UserStats
```
currentStreak       int
longestStreak       int
totalCardsReviewed  int
totalCorrect        int
lastStudiedAt       DateTime
```

---

## Navigation & Screens

```
Splash Screen
└── Home
    └── Bottom Navigation Bar (4 tabs)
        ├── Study
        │   ├── Deck selection screen
        │   ├── Mode selection (Flip / Spaced Repetition)
        │   └── Review screen
        │       ├── Front: Korean text (large)
        │       ├── Back: Romanization + Meaning + Example sentence
        │       └── SR mode: rating buttons (Don't Know / Hard / Good / Easy)
        ├── Library
        │   ├── Built-in decks (grouped: Beginner / Intermediate)
        │   ├── My decks (user-created)
        │   └── Add / Edit card screen
        ├── Progress
        │   ├── Daily study bar chart
        │   ├── Accuracy trend line
        │   ├── Streak display
        │   └── Achievement badge wall
        └── Settings
            ├── Language toggle (繁中 / English)
            ├── Daily goal (cards per day)
            └── About
```

---

## Spaced Repetition — SM-2 Algorithm

User rates each card after flip: **Don't Know (0) / Hard (1) / Good (2) / Easy (3)**.

```
if rating < 2:
    repetitions = 0
    interval = 1

else:
    if repetitions == 0: interval = 1
    elif repetitions == 1: interval = 6
    else: interval = round(previous_interval × easeFactor)

    easeFactor = easeFactor + (0.1 - (3 - rating) × 0.08 + (3 - rating) × 0.02)
    easeFactor = max(easeFactor, 1.3)
    repetitions += 1

nextReviewAt = today + interval days
```

**Flip mode** does not run SM-2; it only records card-touched count for streak and statistics.

---

## Gamification

### Streak Rules
- Completing ≥ 1 card review on a calendar day counts as that day's activity.
- Missing a day resets `currentStreak` to 0 (but `longestStreak` is preserved).

### Achievements
| Key | Title | Condition |
|-----|-------|-----------|
| `first_review` | 初心者 / Beginner | Complete first review session |
| `streak_7` | 一週挑戰 / 7-Day Streak | currentStreak ≥ 7 |
| `total_500` | 單字王 / Vocab King | totalCardsReviewed ≥ 500 |
| `perfect_session` | 完美主義者 / Perfectionist | 100% accuracy in one session |
| `created_deck` | 詞庫創作者 / Deck Creator | Create first custom deck |

Achievement evaluation runs at the end of each review session and on app launch.

---

## Built-in Vocabulary

Two built-in decks (not user-editable):
- **Beginner:** Hangul basics, greetings, numbers, days of week (~100 cards)
- **Intermediate:** Common phrases, travel, food, shopping (~200 cards)

Both decks provide `meaning` in both `zh` and `en` fields; the displayed language follows the UI language setting.

---

## Localization

- Two ARB files: `app_zh.arb` (Traditional Chinese), `app_en.arb` (English)
- Language preference stored in `UserStats` / shared preferences
- Switching language rebuilds the widget tree via Riverpod provider

---

## Out of Scope

- iOS support (APK target only for now)
- Cloud sync / user accounts
- Audio pronunciation
- Romanization auto-generation (stored as static data)
- Social / sharing features
