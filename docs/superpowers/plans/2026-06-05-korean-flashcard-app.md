# Korean Flashcard App Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a fully offline Flutter Android app for learning Korean with flashcards, spaced repetition, and gamification.

**Architecture:** Clean Architecture (Domain / Data / Presentation), Riverpod state management, Drift (type-safe SQLite wrapper) for local persistence. SM-2 spaced repetition implemented as a pure domain use case.

**Tech Stack:** Flutter 3.44+, Dart 3.12+, flutter_riverpod, drift, sqlite3_flutter_libs, fl_chart, shared_preferences, intl, uuid

---

## File Map

```
lib/
├── main.dart
├── core/
│   ├── l10n/
│   │   ├── app_zh.arb
│   │   └── app_en.arb
│   └── theme/
│       └── app_theme.dart
├── domain/
│   ├── entities/
│   │   ├── deck.dart
│   │   ├── card.dart
│   │   ├── review_record.dart
│   │   ├── achievement.dart
│   │   └── user_stats.dart
│   ├── repositories/
│   │   ├── deck_repository.dart
│   │   ├── card_repository.dart
│   │   ├── review_repository.dart
│   │   └── stats_repository.dart
│   └── usecases/
│       ├── calculate_sm2.dart
│       └── evaluate_achievements.dart
├── data/
│   ├── database/
│   │   ├── app_database.dart       (drift @DriftDatabase)
│   │   ├── tables.dart
│   │   ├── daos/
│   │   │   ├── deck_dao.dart
│   │   │   ├── card_dao.dart
│   │   │   ├── review_dao.dart
│   │   │   └── stats_dao.dart
│   │   └── seed_data.dart
│   └── repositories/
│       ├── deck_repository_impl.dart
│       ├── card_repository_impl.dart
│       ├── review_repository_impl.dart
│       └── stats_repository_impl.dart
└── presentation/
    ├── providers/
    │   ├── database_provider.dart
    │   ├── deck_provider.dart
    │   ├── review_provider.dart
    │   ├── stats_provider.dart
    │   └── locale_provider.dart
    └── screens/
        ├── home/
        │   └── home_screen.dart
        ├── study/
        │   ├── deck_selection_screen.dart
        │   ├── mode_selection_screen.dart
        │   └── review_screen.dart
        ├── library/
        │   ├── library_screen.dart
        │   └── card_edit_screen.dart
        ├── progress/
        │   └── progress_screen.dart
        └── settings/
            └── settings_screen.dart

test/
├── domain/
│   └── usecases/
│       ├── calculate_sm2_test.dart
│       └── evaluate_achievements_test.dart
└── widget/
    └── review_screen_test.dart
```

---

### Task 1: Flutter Project Scaffold

**Files:**
- Modify: `pubspec.yaml`
- Modify: `.gitignore`
- Create: `l10n.yaml`

- [ ] **Step 1: Initialise Flutter project inside existing directory**

```bash
cd C:/Users/User/project/kapp
flutter create . --org com.kapp --project-name kapp
```

Expected: Flutter generates `lib/main.dart`, `android/`, `pubspec.yaml`, etc.

- [ ] **Step 2: Replace pubspec.yaml dependencies**

Replace the `dependencies` and `dev_dependencies` sections in `pubspec.yaml`:

```yaml
name: kapp
description: Korean flashcard learning app
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.12.0 <4.0.0'

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

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  drift_dev: ^2.22.0
  build_runner: ^2.4.13

flutter:
  generate: true
  uses-material-design: true
```

- [ ] **Step 3: Create l10n.yaml**

```yaml
arb-dir: lib/core/l10n
template-arb-file: app_zh.arb
output-localization-file: app_localizations.dart
```

- [ ] **Step 4: Get dependencies**

```bash
flutter pub get
```

Expected: `Running "flutter pub get" in kapp...` with no errors.

- [ ] **Step 5: Add `.superpowers/` to .gitignore**

Append to `.gitignore`:

```
# Superpowers brainstorm sessions
.superpowers/
```

- [ ] **Step 6: Commit**

```bash
git add pubspec.yaml pubspec.lock l10n.yaml .gitignore
git commit -m "chore: flutter project scaffold with dependencies"
```

---

### Task 2: Domain Entities

**Files:**
- Create: `lib/domain/entities/deck.dart`
- Create: `lib/domain/entities/card.dart`
- Create: `lib/domain/entities/review_record.dart`
- Create: `lib/domain/entities/achievement.dart`
- Create: `lib/domain/entities/user_stats.dart`

- [ ] **Step 1: Create deck.dart**

```dart
// lib/domain/entities/deck.dart
enum DeckLevel { beginner, intermediate, all }

class Deck {
  final String id;
  final String name;
  final String description;
  final DeckLevel level;
  final bool isBuiltIn;
  final DateTime createdAt;

  const Deck({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.isBuiltIn,
    required this.createdAt,
  });
}
```

- [ ] **Step 2: Create card.dart**

```dart
// lib/domain/entities/card.dart
class KoreanCard {
  final String id;
  final String deckId;
  final String korean;
  final String romanization;
  final String meaningZh;
  final String meaningEn;
  final String exampleSentence;
  final String exampleTranslation;
  final DateTime createdAt;

  const KoreanCard({
    required this.id,
    required this.deckId,
    required this.korean,
    required this.romanization,
    required this.meaningZh,
    required this.meaningEn,
    required this.exampleSentence,
    required this.exampleTranslation,
    required this.createdAt,
  });
}
```

- [ ] **Step 3: Create review_record.dart**

```dart
// lib/domain/entities/review_record.dart
class ReviewRecord {
  final String cardId;
  final double easeFactor;
  final int interval;
  final int repetitions;
  final DateTime nextReviewAt;
  final DateTime lastReviewedAt;

  const ReviewRecord({
    required this.cardId,
    required this.easeFactor,
    required this.interval,
    required this.repetitions,
    required this.nextReviewAt,
    required this.lastReviewedAt,
  });

  ReviewRecord copyWith({
    double? easeFactor,
    int? interval,
    int? repetitions,
    DateTime? nextReviewAt,
    DateTime? lastReviewedAt,
  }) {
    return ReviewRecord(
      cardId: cardId,
      easeFactor: easeFactor ?? this.easeFactor,
      interval: interval ?? this.interval,
      repetitions: repetitions ?? this.repetitions,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
    );
  }
}
```

- [ ] **Step 4: Create achievement.dart**

```dart
// lib/domain/entities/achievement.dart
enum AchievementCondition {
  firstReview,
  streakDays,
  totalReviewed,
  perfectSession,
  createdDeck,
}

class Achievement {
  final String id;
  final String titleKey;
  final String descKey;
  final String iconName;
  final AchievementCondition condition;
  final int threshold;
  final bool unlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.titleKey,
    required this.descKey,
    required this.iconName,
    required this.condition,
    required this.threshold,
    required this.unlocked,
    this.unlockedAt,
  });

  Achievement copyWith({bool? unlocked, DateTime? unlockedAt}) {
    return Achievement(
      id: id,
      titleKey: titleKey,
      descKey: descKey,
      iconName: iconName,
      condition: condition,
      threshold: threshold,
      unlocked: unlocked ?? this.unlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}
```

- [ ] **Step 5: Create user_stats.dart**

```dart
// lib/domain/entities/user_stats.dart
class UserStats {
  final int currentStreak;
  final int longestStreak;
  final int totalCardsReviewed;
  final int totalCorrect;
  final DateTime? lastStudiedAt;

  const UserStats({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalCardsReviewed,
    required this.totalCorrect,
    this.lastStudiedAt,
  });

  static const empty = UserStats(
    currentStreak: 0,
    longestStreak: 0,
    totalCardsReviewed: 0,
    totalCorrect: 0,
  );

  UserStats copyWith({
    int? currentStreak,
    int? longestStreak,
    int? totalCardsReviewed,
    int? totalCorrect,
    DateTime? lastStudiedAt,
  }) {
    return UserStats(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalCardsReviewed: totalCardsReviewed ?? this.totalCardsReviewed,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      lastStudiedAt: lastStudiedAt ?? this.lastStudiedAt,
    );
  }
}
```

- [ ] **Step 6: Verify project compiles**

```bash
flutter analyze lib/domain/
```

Expected: No issues found.

- [ ] **Step 7: Commit**

```bash
git add lib/domain/entities/
git commit -m "feat: add domain entities (Deck, KoreanCard, ReviewRecord, Achievement, UserStats)"
```

---

### Task 3: Repository Interfaces

**Files:**
- Create: `lib/domain/repositories/deck_repository.dart`
- Create: `lib/domain/repositories/card_repository.dart`
- Create: `lib/domain/repositories/review_repository.dart`
- Create: `lib/domain/repositories/stats_repository.dart`

- [ ] **Step 1: Create deck_repository.dart**

```dart
// lib/domain/repositories/deck_repository.dart
import '../entities/deck.dart';

abstract class DeckRepository {
  Future<List<Deck>> getAllDecks();
  Future<List<Deck>> getDecksByLevel(DeckLevel level);
  Future<void> createDeck(Deck deck);
  Future<void> deleteDeck(String deckId);
}
```

- [ ] **Step 2: Create card_repository.dart**

```dart
// lib/domain/repositories/card_repository.dart
import '../entities/card.dart';

abstract class CardRepository {
  Future<List<KoreanCard>> getCardsByDeck(String deckId);
  Future<void> createCard(KoreanCard card);
  Future<void> updateCard(KoreanCard card);
  Future<void> deleteCard(String cardId);
}
```

- [ ] **Step 3: Create review_repository.dart**

```dart
// lib/domain/repositories/review_repository.dart
import '../entities/review_record.dart';

abstract class ReviewRepository {
  Future<ReviewRecord?> getRecord(String cardId);
  Future<List<ReviewRecord>> getDueRecords(DateTime before);
  Future<void> saveRecord(ReviewRecord record);
}
```

- [ ] **Step 4: Create stats_repository.dart**

```dart
// lib/domain/repositories/stats_repository.dart
import '../entities/user_stats.dart';
import '../entities/achievement.dart';

abstract class StatsRepository {
  Future<UserStats> getStats();
  Future<void> saveStats(UserStats stats);
  Future<List<Achievement>> getAchievements();
  Future<void> unlockAchievement(String achievementId);
  Future<Map<DateTime, int>> getDailyReviewCounts(int lastNDays);
}
```

- [ ] **Step 5: Commit**

```bash
git add lib/domain/repositories/
git commit -m "feat: add domain repository interfaces"
```

---

### Task 4: SM-2 Use Case (TDD)

**Files:**
- Create: `lib/domain/usecases/calculate_sm2.dart`
- Create: `test/domain/usecases/calculate_sm2_test.dart`

- [ ] **Step 1: Write failing tests**

```dart
// test/domain/usecases/calculate_sm2_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kapp/domain/usecases/calculate_sm2.dart';

void main() {
  group('calculateSM2', () {
    const baseEaseFactor = 2.5;

    test('rating < 2 resets repetitions to 0 and interval to 1', () {
      final result = calculateSM2(
        rating: 0,
        easeFactor: baseEaseFactor,
        interval: 10,
        repetitions: 5,
      );
      expect(result.repetitions, 0);
      expect(result.interval, 1);
      expect(result.easeFactor, baseEaseFactor);
    });

    test('first correct answer sets interval to 1', () {
      final result = calculateSM2(
        rating: 2,
        easeFactor: baseEaseFactor,
        interval: 1,
        repetitions: 0,
      );
      expect(result.repetitions, 1);
      expect(result.interval, 1);
    });

    test('second correct answer sets interval to 6', () {
      final result = calculateSM2(
        rating: 2,
        easeFactor: baseEaseFactor,
        interval: 1,
        repetitions: 1,
      );
      expect(result.repetitions, 2);
      expect(result.interval, 6);
    });

    test('subsequent interval = round(previous * easeFactor)', () {
      final result = calculateSM2(
        rating: 2,
        easeFactor: 2.5,
        interval: 6,
        repetitions: 2,
      );
      expect(result.interval, 15); // round(6 * 2.5)
    });

    test('easy rating increases easeFactor by 0.1', () {
      final result = calculateSM2(
        rating: 3,
        easeFactor: 2.5,
        interval: 1,
        repetitions: 0,
      );
      expect(result.easeFactor, closeTo(2.6, 0.001));
    });

    test('easeFactor never drops below 1.3', () {
      final result = calculateSM2(
        rating: 1,
        easeFactor: 1.3,
        interval: 6,
        repetitions: 2,
      );
      expect(result.easeFactor, greaterThanOrEqualTo(1.3));
    });

    test('nextReviewAt is in the future by interval days', () {
      final before = DateTime.now();
      final result = calculateSM2(
        rating: 2,
        easeFactor: 2.5,
        interval: 1,
        repetitions: 1,
      );
      final expectedDate = before.add(const Duration(days: 6));
      expect(result.nextReviewAt.day, expectedDate.day);
    });
  });
}
```

- [ ] **Step 2: Run tests — confirm they fail**

```bash
flutter test test/domain/usecases/calculate_sm2_test.dart
```

Expected: `Could not find package 'kapp'` or import error — file doesn't exist yet.

- [ ] **Step 3: Implement calculate_sm2.dart**

```dart
// lib/domain/usecases/calculate_sm2.dart
class SM2Result {
  final double easeFactor;
  final int interval;
  final int repetitions;
  final DateTime nextReviewAt;

  const SM2Result({
    required this.easeFactor,
    required this.interval,
    required this.repetitions,
    required this.nextReviewAt,
  });
}

SM2Result calculateSM2({
  required int rating, // 0=Don't Know, 1=Hard, 2=Good, 3=Easy
  required double easeFactor,
  required int interval,
  required int repetitions,
}) {
  int newRepetitions;
  int newInterval;
  double newEaseFactor = easeFactor;

  if (rating < 2) {
    newRepetitions = 0;
    newInterval = 1;
  } else {
    newRepetitions = repetitions + 1;
    if (repetitions == 0) {
      newInterval = 1;
    } else if (repetitions == 1) {
      newInterval = 6;
    } else {
      newInterval = (interval * easeFactor).round();
    }
    newEaseFactor = easeFactor +
        (0.1 - (3 - rating) * 0.08 + (3 - rating) * 0.02);
    if (newEaseFactor < 1.3) newEaseFactor = 1.3;
  }

  return SM2Result(
    easeFactor: newEaseFactor,
    interval: newInterval,
    repetitions: newRepetitions,
    nextReviewAt: DateTime.now().add(Duration(days: newInterval)),
  );
}
```

- [ ] **Step 4: Run tests — confirm they pass**

```bash
flutter test test/domain/usecases/calculate_sm2_test.dart
```

Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/domain/usecases/calculate_sm2.dart test/domain/usecases/calculate_sm2_test.dart
git commit -m "feat: SM-2 spaced repetition algorithm with tests"
```

---

### Task 5: Achievement Evaluation Use Case (TDD)

**Files:**
- Create: `lib/domain/usecases/evaluate_achievements.dart`
- Create: `test/domain/usecases/evaluate_achievements_test.dart`

- [ ] **Step 1: Write failing tests**

```dart
// test/domain/usecases/evaluate_achievements_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kapp/domain/entities/achievement.dart';
import 'package:kapp/domain/entities/user_stats.dart';
import 'package:kapp/domain/usecases/evaluate_achievements.dart';

Achievement makeAchievement(AchievementCondition condition, int threshold) {
  return Achievement(
    id: 'test',
    titleKey: 'title',
    descKey: 'desc',
    iconName: 'star',
    condition: condition,
    threshold: threshold,
    unlocked: false,
  );
}

void main() {
  group('evaluateAchievements', () {
    test('firstReview unlocks when totalCardsReviewed >= 1', () {
      final achievement = makeAchievement(AchievementCondition.firstReview, 1);
      final stats = UserStats.empty.copyWith(totalCardsReviewed: 1);
      final result = evaluateAchievements(
        achievements: [achievement],
        stats: stats,
        sessionCorrect: 1,
        sessionTotal: 1,
        customDecksCount: 0,
      );
      expect(result.first.unlocked, isTrue);
    });

    test('streakDays unlocks when currentStreak >= threshold', () {
      final achievement = makeAchievement(AchievementCondition.streakDays, 7);
      final stats = UserStats.empty.copyWith(currentStreak: 7);
      final result = evaluateAchievements(
        achievements: [achievement],
        stats: stats,
        sessionCorrect: 1,
        sessionTotal: 1,
        customDecksCount: 0,
      );
      expect(result.first.unlocked, isTrue);
    });

    test('perfectSession unlocks when sessionCorrect == sessionTotal', () {
      final achievement =
          makeAchievement(AchievementCondition.perfectSession, 1);
      final stats = UserStats.empty.copyWith(totalCardsReviewed: 5);
      final result = evaluateAchievements(
        achievements: [achievement],
        stats: stats,
        sessionCorrect: 5,
        sessionTotal: 5,
        customDecksCount: 0,
      );
      expect(result.first.unlocked, isTrue);
    });

    test('already unlocked achievement stays unlocked', () {
      final achievement = Achievement(
        id: 'a1',
        titleKey: 't',
        descKey: 'd',
        iconName: 'star',
        condition: AchievementCondition.firstReview,
        threshold: 1,
        unlocked: true,
        unlockedAt: DateTime(2026),
      );
      final stats = UserStats.empty.copyWith(totalCardsReviewed: 10);
      final result = evaluateAchievements(
        achievements: [achievement],
        stats: stats,
        sessionCorrect: 1,
        sessionTotal: 1,
        customDecksCount: 0,
      );
      expect(result.first.unlocked, isTrue);
      expect(result.first.unlockedAt, DateTime(2026));
    });
  });
}
```

- [ ] **Step 2: Run tests — confirm they fail**

```bash
flutter test test/domain/usecases/evaluate_achievements_test.dart
```

Expected: Import error.

- [ ] **Step 3: Implement evaluate_achievements.dart**

```dart
// lib/domain/usecases/evaluate_achievements.dart
import '../entities/achievement.dart';
import '../entities/user_stats.dart';

List<Achievement> evaluateAchievements({
  required List<Achievement> achievements,
  required UserStats stats,
  required int sessionCorrect,
  required int sessionTotal,
  required int customDecksCount,
}) {
  return achievements.map((a) {
    if (a.unlocked) return a;
    final shouldUnlock = _check(
      a,
      stats: stats,
      sessionCorrect: sessionCorrect,
      sessionTotal: sessionTotal,
      customDecksCount: customDecksCount,
    );
    if (shouldUnlock) {
      return a.copyWith(unlocked: true, unlockedAt: DateTime.now());
    }
    return a;
  }).toList();
}

bool _check(
  Achievement a, {
  required UserStats stats,
  required int sessionCorrect,
  required int sessionTotal,
  required int customDecksCount,
}) {
  switch (a.condition) {
    case AchievementCondition.firstReview:
      return stats.totalCardsReviewed >= a.threshold;
    case AchievementCondition.streakDays:
      return stats.currentStreak >= a.threshold;
    case AchievementCondition.totalReviewed:
      return stats.totalCardsReviewed >= a.threshold;
    case AchievementCondition.perfectSession:
      return sessionTotal > 0 && sessionCorrect == sessionTotal;
    case AchievementCondition.createdDeck:
      return customDecksCount >= a.threshold;
  }
}
```

- [ ] **Step 4: Run tests — confirm they pass**

```bash
flutter test test/domain/usecases/evaluate_achievements_test.dart
```

Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/domain/usecases/evaluate_achievements.dart test/domain/usecases/evaluate_achievements_test.dart
git commit -m "feat: achievement evaluation use case with tests"
```

---

### Task 6: Drift Database Schema & DAOs

**Files:**
- Create: `lib/data/database/tables.dart`
- Create: `lib/data/database/app_database.dart`
- Create: `lib/data/database/daos/deck_dao.dart`
- Create: `lib/data/database/daos/card_dao.dart`
- Create: `lib/data/database/daos/review_dao.dart`
- Create: `lib/data/database/daos/stats_dao.dart`

- [ ] **Step 1: Create tables.dart**

`@DataClassName` avoids naming conflicts with the domain entities `Deck`, `KoreanCard`, `ReviewRecord` and Flutter's `Card` widget.

```dart
// lib/data/database/tables.dart
import 'package:drift/drift.dart';

@DataClassName('DeckRow')
class Decks extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get level => text()(); // 'beginner' | 'intermediate' | 'all'
  BoolColumn get isBuiltIn =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CardRow')
class Cards extends Table {
  TextColumn get id => text()();
  TextColumn get deckId =>
      text().references(Decks, #id, onDelete: KeyAction.cascade)();
  TextColumn get korean => text()();
  TextColumn get romanization => text()();
  TextColumn get meaningZh => text()();
  TextColumn get meaningEn => text()();
  TextColumn get exampleSentence =>
      text().withDefault(const Constant(''))();
  TextColumn get exampleTranslation =>
      text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ReviewRecordRow')
class ReviewRecords extends Table {
  TextColumn get cardId =>
      text().references(Cards, #id, onDelete: KeyAction.cascade)();
  RealColumn get easeFactor =>
      real().withDefault(const Constant(2.5))();
  IntColumn get interval => integer().withDefault(const Constant(1))();
  IntColumn get repetitions =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get nextReviewAt => dateTime()();
  DateTimeColumn get lastReviewedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {cardId};
}

class AchievementsTable extends Table {
  @override
  String get tableName => 'achievements';

  TextColumn get id => text()();
  TextColumn get titleKey => text()();
  TextColumn get descKey => text()();
  TextColumn get iconName => text()();
  TextColumn get condition => text()();
  IntColumn get threshold => integer()();
  BoolColumn get unlocked =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get unlockedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class UserStatsTable extends Table {
  @override
  String get tableName => 'user_stats';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get currentStreak =>
      integer().withDefault(const Constant(0))();
  IntColumn get longestStreak =>
      integer().withDefault(const Constant(0))();
  IntColumn get totalCardsReviewed =>
      integer().withDefault(const Constant(0))();
  IntColumn get totalCorrect =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get lastStudiedAt => dateTime().nullable()();
}

class DailyReviewCounts extends Table {
  DateTimeColumn get date => dateTime()();
  IntColumn get count => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {date};
}
```

- [ ] **Step 2: Create deck_dao.dart**

```dart
// lib/data/database/daos/deck_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'deck_dao.g.dart';

@DriftAccessor(tables: [Decks])
class DeckDao extends DatabaseAccessor<AppDatabase> with _$DeckDaoMixin {
  DeckDao(super.db);

  Future<List<Deck>> getAllDecks() => select(decks).get();

  Future<List<Deck>> getDecksByLevel(String level) =>
      (select(decks)..where((t) => t.level.equals(level))).get();

  Future<void> insertDeck(DecksCompanion companion) =>
      into(decks).insertOnConflictUpdate(companion);

  Future<void> deleteDeckById(String id) =>
      (delete(decks)..where((t) => t.id.equals(id))).go();
}
```

- [ ] **Step 3: Create card_dao.dart**

```dart
// lib/data/database/daos/card_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'card_dao.g.dart';

@DriftAccessor(tables: [Cards])
class CardDao extends DatabaseAccessor<AppDatabase> with _$CardDaoMixin {
  CardDao(super.db);

  Future<List<Card>> getCardsByDeck(String deckId) =>
      (select(cards)..where((t) => t.deckId.equals(deckId))).get();

  Future<void> insertCard(CardsCompanion companion) =>
      into(cards).insertOnConflictUpdate(companion);

  Future<void> updateCardById(CardsCompanion companion) =>
      (update(cards)..where((t) => t.id.equals(companion.id.value)))
          .write(companion);

  Future<void> deleteCardById(String id) =>
      (delete(cards)..where((t) => t.id.equals(id))).go();
}
```

- [ ] **Step 4: Create review_dao.dart**

```dart
// lib/data/database/daos/review_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'review_dao.g.dart';

@DriftAccessor(tables: [ReviewRecords])
class ReviewDao extends DatabaseAccessor<AppDatabase>
    with _$ReviewDaoMixin {
  ReviewDao(super.db);

  Future<ReviewRecord?> getRecord(String cardId) =>
      (select(reviewRecords)
            ..where((t) => t.cardId.equals(cardId)))
          .getSingleOrNull();

  Future<List<ReviewRecord>> getDueRecords(DateTime before) =>
      (select(reviewRecords)
            ..where((t) => t.nextReviewAt.isSmallerOrEqualValue(before)))
          .get();

  Future<void> saveRecord(ReviewRecordsCompanion companion) =>
      into(reviewRecords).insertOnConflictUpdate(companion);
}
```

- [ ] **Step 5: Create stats_dao.dart**

```dart
// lib/data/database/daos/stats_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'stats_dao.g.dart';

@DriftAccessor(tables: [UserStatsTable, AchievementsTable, DailyReviewCounts])
class StatsDao extends DatabaseAccessor<AppDatabase> with _$StatsDaoMixin {
  StatsDao(super.db);

  Future<UserStatsTableData?> getStats() =>
      select(userStatsTable).getSingleOrNull();

  Future<void> saveStats(UserStatsTableCompanion companion) =>
      into(userStatsTable).insertOnConflictUpdate(companion);

  Future<List<AchievementsTableData>> getAchievements() =>
      select(achievementsTable).get();

  Future<void> unlockAchievement(String id) =>
      (update(achievementsTable)..where((t) => t.id.equals(id))).write(
        AchievementsTableCompanion(
          unlocked: const Value(true),
          unlockedAt: Value(DateTime.now()),
        ),
      );

  Future<List<DailyReviewCount>> getDailyCountsSince(DateTime since) =>
      (select(dailyReviewCounts)
            ..where((t) => t.date.isBiggerOrEqualValue(since))
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .get();

  Future<void> incrementDailyCount(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);
    final existing = await (select(dailyReviewCounts)
          ..where((t) => t.date.equals(normalized)))
        .getSingleOrNull();
    if (existing == null) {
      await into(dailyReviewCounts).insert(
        DailyReviewCountsCompanion(
          date: Value(normalized),
          count: const Value(1),
        ),
      );
    } else {
      await (update(dailyReviewCounts)
            ..where((t) => t.date.equals(normalized)))
          .write(DailyReviewCountsCompanion(count: Value(existing.count + 1)));
    }
  }
}
```

- [ ] **Step 6: Create app_database.dart**

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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await seedBuiltInData(this);
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

- [ ] **Step 7: Run code generation**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: Creates `app_database.g.dart`, `deck_dao.g.dart`, `card_dao.g.dart`, `review_dao.g.dart`, `stats_dao.g.dart`.

- [ ] **Step 8: Commit**

```bash
git add lib/data/database/
git commit -m "feat: drift database schema and DAOs"
```

---

### Task 7: Seed Data & Repository Implementations

**Files:**
- Create: `lib/data/database/seed_data.dart`
- Create: `lib/data/repositories/deck_repository_impl.dart`
- Create: `lib/data/repositories/card_repository_impl.dart`
- Create: `lib/data/repositories/review_repository_impl.dart`
- Create: `lib/data/repositories/stats_repository_impl.dart`

- [ ] **Step 1: Create seed_data.dart**

```dart
// lib/data/database/seed_data.dart
import 'package:drift/drift.dart';
import 'app_database.dart';
import 'tables.dart';

Future<void> seedBuiltInData(AppDatabase db) async {
  // Seed decks
  await db.into(db.decks).insertOnConflictUpdate(DecksCompanion(
    id: const Value('deck-beginner'),
    name: const Value('初級韓文 / Beginner Korean'),
    description: const Value('基礎詞彙、問候語、數字'),
    level: const Value('beginner'),
    isBuiltIn: const Value(true),
    createdAt: Value(DateTime(2026)),
  ));
  await db.into(db.decks).insertOnConflictUpdate(DecksCompanion(
    id: const Value('deck-intermediate'),
    name: const Value('進階韓文 / Intermediate Korean'),
    description: const Value('常用句型、旅遊、購物'),
    level: const Value('intermediate'),
    isBuiltIn: const Value(true),
    createdAt: Value(DateTime(2026)),
  ));

  // Seed beginner cards
  final beginnerCards = [
    _card('b01', 'deck-beginner', '안녕하세요', 'annyeonghaseyo', '你好', 'Hello',
        '안녕하세요, 만나서 반갑습니다.', '你好，很高興認識你。'),
    _card('b02', 'deck-beginner', '감사합니다', 'gamsahamnida', '謝謝', 'Thank you',
        '도와줘서 감사합니다.', '謝謝你的幫助。'),
    _card('b03', 'deck-beginner', '미안합니다', 'mianhamnida', '對不起', 'I\'m sorry',
        '늦어서 미안합니다.', '對不起，我遲到了。'),
    _card('b04', 'deck-beginner', '네', 'ne', '是', 'Yes', '네, 알겠습니다.', '是，我明白了。'),
    _card('b05', 'deck-beginner', '아니요', 'aniyo', '不', 'No', '아니요, 괜찮아요.',
        '不，沒關係。'),
    _card('b06', 'deck-beginner', '이름이 뭐예요?', 'iriumi mwoyeyo?', '你叫什麼名字？',
        'What\'s your name?', '이름이 뭐예요? 저는 민준이에요.', '你叫什麼名字？我叫民俊。'),
    _card('b07', 'deck-beginner', '하나', 'hana', '一', 'One', '사과 하나 주세요.', '請給我一個蘋果。'),
    _card('b08', 'deck-beginner', '둘', 'dul', '二', 'Two', '커피 두 잔 주세요.', '請給我兩杯咖啡。'),
    _card('b09', 'deck-beginner', '물', 'mul', '水', 'Water', '물 한 잔 주세요.', '請給我一杯水。'),
    _card('b10', 'deck-beginner', '밥', 'bap', '飯', 'Rice/Meal', '밥 먹었어요?', '你吃飯了嗎？'),
  ];

  // Seed intermediate cards
  final intermediateCards = [
    _card('i01', 'deck-intermediate', '얼마예요?', 'eolmayeyo?', '多少錢？',
        'How much is it?', '이거 얼마예요?', '這個多少錢？'),
    _card('i02', 'deck-intermediate', '어디예요?', 'eodiyeyo?', '在哪裡？',
        'Where is it?', '화장실이 어디예요?', '廁所在哪裡？'),
    _card('i03', 'deck-intermediate', '맛있어요', 'masisseoyo', '好吃', 'Delicious',
        '정말 맛있어요!', '真的很好吃！'),
    _card('i04', 'deck-intermediate', '주세요', 'juseyo', '請給我', 'Please give me',
        '메뉴 주세요.', '請給我菜單。'),
    _card('i05', 'deck-intermediate', '괜찮아요', 'gwaenchanayo', '沒關係', 'It\'s okay',
        '걱정하지 마세요, 괜찮아요.', '不要擔心，沒關係。'),
  ];

  for (final c in [...beginnerCards, ...intermediateCards]) {
    await db.into(db.cards).insertOnConflictUpdate(c);
  }

  // Seed achievements
  final achievements = [
    _achievement('ach-first', 'achievementFirstTitle', 'achievementFirstDesc',
        'star', 'first_review', 1),
    _achievement('ach-streak7', 'achievementStreak7Title',
        'achievementStreak7Desc', 'local_fire_department', 'streak_days', 7),
    _achievement('ach-total500', 'achievementTotal500Title',
        'achievementTotal500Desc', 'menu_book', 'total_reviewed', 500),
    _achievement('ach-perfect', 'achievementPerfectTitle',
        'achievementPerfectDesc', 'verified', 'perfect_session', 1),
    _achievement('ach-deck', 'achievementDeckTitle', 'achievementDeckDesc',
        'library_add', 'created_deck', 1),
  ];

  for (final a in achievements) {
    await db.into(db.achievementsTable).insertOnConflictUpdate(a);
  }

  // Seed initial user stats row
  await db.into(db.userStatsTable).insertOnConflictUpdate(
        UserStatsTableCompanion(
          id: const Value(1),
          currentStreak: const Value(0),
          longestStreak: const Value(0),
          totalCardsReviewed: const Value(0),
          totalCorrect: const Value(0),
        ),
      );
}

CardsCompanion _card(
  String id,
  String deckId,
  String korean,
  String romanization,
  String meaningZh,
  String meaningEn,
  String exampleSentence,
  String exampleTranslation,
) {
  return CardsCompanion(
    id: Value(id),
    deckId: Value(deckId),
    korean: Value(korean),
    romanization: Value(romanization),
    meaningZh: Value(meaningZh),
    meaningEn: Value(meaningEn),
    exampleSentence: Value(exampleSentence),
    exampleTranslation: Value(exampleTranslation),
    createdAt: Value(DateTime(2026)),
  );
}

AchievementsTableCompanion _achievement(
  String id,
  String titleKey,
  String descKey,
  String iconName,
  String condition,
  int threshold,
) {
  return AchievementsTableCompanion(
    id: Value(id),
    titleKey: Value(titleKey),
    descKey: Value(descKey),
    iconName: Value(iconName),
    condition: Value(condition),
    threshold: Value(threshold),
    unlocked: const Value(false),
  );
}
```

- [ ] **Step 2: Create deck_repository_impl.dart**

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
        createdAt: row.createdAt,
      );

  String _levelToString(DeckLevel l) => l.name;
  DeckLevel _levelFromString(String s) =>
      DeckLevel.values.firstWhere((e) => e.name == s, orElse: () => DeckLevel.all);
}
```

- [ ] **Step 3: Create card_repository_impl.dart**

```dart
// lib/data/repositories/card_repository_impl.dart
import 'package:drift/drift.dart';
import '../../domain/entities/card.dart';
import '../../domain/repositories/card_repository.dart';
import '../database/app_database.dart';

class CardRepositoryImpl implements CardRepository {
  final AppDatabase _db;
  CardRepositoryImpl(this._db);

  @override
  Future<List<KoreanCard>> getCardsByDeck(String deckId) async {
    final rows = await _db.cardDao.getCardsByDeck(deckId);
    return rows.map(_toDomain).toList();
  }

  @override
  Future<void> createCard(KoreanCard card) async {
    await _db.cardDao.insertCard(CardsCompanion(
      id: Value(card.id),
      deckId: Value(card.deckId),
      korean: Value(card.korean),
      romanization: Value(card.romanization),
      meaningZh: Value(card.meaningZh),
      meaningEn: Value(card.meaningEn),
      exampleSentence: Value(card.exampleSentence),
      exampleTranslation: Value(card.exampleTranslation),
      createdAt: Value(card.createdAt),
    ));
  }

  @override
  Future<void> updateCard(KoreanCard card) async {
    await _db.cardDao.updateCardById(CardsCompanion(
      id: Value(card.id),
      deckId: Value(card.deckId),
      korean: Value(card.korean),
      romanization: Value(card.romanization),
      meaningZh: Value(card.meaningZh),
      meaningEn: Value(card.meaningEn),
      exampleSentence: Value(card.exampleSentence),
      exampleTranslation: Value(card.exampleTranslation),
      createdAt: Value(card.createdAt),
    ));
  }

  @override
  Future<void> deleteCard(String cardId) =>
      _db.cardDao.deleteCardById(cardId);

  KoreanCard _toDomain(CardRow row) => KoreanCard(
        id: row.id,
        deckId: row.deckId,
        korean: row.korean,
        romanization: row.romanization,
        meaningZh: row.meaningZh,
        meaningEn: row.meaningEn,
        exampleSentence: row.exampleSentence,
        exampleTranslation: row.exampleTranslation,
        createdAt: row.createdAt,
      );
}
```

- [ ] **Step 4: Create review_repository_impl.dart**

```dart
// lib/data/repositories/review_repository_impl.dart
import 'package:drift/drift.dart';
import '../../domain/entities/review_record.dart';
import '../../domain/repositories/review_repository.dart';
import '../database/app_database.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final AppDatabase _db;
  ReviewRepositoryImpl(this._db);

  @override
  Future<ReviewRecord?> getRecord(String cardId) async {
    final row = await _db.reviewDao.getRecord(cardId);
    if (row == null) return null;
    return _toDomain(row);
  }

  @override
  Future<List<ReviewRecord>> getDueRecords(DateTime before) async {
    final rows = await _db.reviewDao.getDueRecords(before);
    return rows.map(_toDomain).toList();
  }

  @override
  Future<void> saveRecord(ReviewRecord record) async {
    await _db.reviewDao.saveRecord(ReviewRecordsCompanion(
      cardId: Value(record.cardId),
      easeFactor: Value(record.easeFactor),
      interval: Value(record.interval),
      repetitions: Value(record.repetitions),
      nextReviewAt: Value(record.nextReviewAt),
      lastReviewedAt: Value(record.lastReviewedAt),
    ));
  }

  ReviewRecord _toDomain(ReviewRecordRow row) => ReviewRecord(
        cardId: row.cardId,
        easeFactor: row.easeFactor,
        interval: row.interval,
        repetitions: row.repetitions,
        nextReviewAt: row.nextReviewAt,
        lastReviewedAt: row.lastReviewedAt,
      );
}
```

- [ ] **Step 5: Create stats_repository_impl.dart**

```dart
// lib/data/repositories/stats_repository_impl.dart
import 'package:drift/drift.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/user_stats.dart';
import '../../domain/repositories/stats_repository.dart';
import '../database/app_database.dart';

class StatsRepositoryImpl implements StatsRepository {
  final AppDatabase _db;
  StatsRepositoryImpl(this._db);

  @override
  Future<UserStats> getStats() async {
    final row = await _db.statsDao.getStats();
    if (row == null) return UserStats.empty;
    return UserStats(
      currentStreak: row.currentStreak,
      longestStreak: row.longestStreak,
      totalCardsReviewed: row.totalCardsReviewed,
      totalCorrect: row.totalCorrect,
      lastStudiedAt: row.lastStudiedAt,
    );
  }

  @override
  Future<void> saveStats(UserStats stats) async {
    await _db.statsDao.saveStats(UserStatsTableCompanion(
      id: const Value(1),
      currentStreak: Value(stats.currentStreak),
      longestStreak: Value(stats.longestStreak),
      totalCardsReviewed: Value(stats.totalCardsReviewed),
      totalCorrect: Value(stats.totalCorrect),
      lastStudiedAt: Value(stats.lastStudiedAt),
    ));
  }

  @override
  Future<List<Achievement>> getAchievements() async {
    final rows = await _db.statsDao.getAchievements();
    return rows.map(_achievementToDomain).toList();
  }

  @override
  Future<void> unlockAchievement(String achievementId) =>
      _db.statsDao.unlockAchievement(achievementId);

  @override
  Future<Map<DateTime, int>> getDailyReviewCounts(int lastNDays) async {
    final since = DateTime.now().subtract(Duration(days: lastNDays));
    final rows = await _db.statsDao.getDailyCountsSince(since);
    return {for (final r in rows) r.date: r.count};
  }

  Achievement _achievementToDomain(AchievementsTableData row) => Achievement(
        id: row.id,
        titleKey: row.titleKey,
        descKey: row.descKey,
        iconName: row.iconName,
        condition: _conditionFromString(row.condition),
        threshold: row.threshold,
        unlocked: row.unlocked,
        unlockedAt: row.unlockedAt,
      );

  AchievementCondition _conditionFromString(String s) {
    switch (s) {
      case 'streak_days': return AchievementCondition.streakDays;
      case 'total_reviewed': return AchievementCondition.totalReviewed;
      case 'perfect_session': return AchievementCondition.perfectSession;
      case 'created_deck': return AchievementCondition.createdDeck;
      default: return AchievementCondition.firstReview;
    }
  }
}
```

- [ ] **Step 6: Verify build**

```bash
flutter analyze lib/data/
```

Expected: No issues.

- [ ] **Step 7: Commit**

```bash
git add lib/data/
git commit -m "feat: seed data and repository implementations"
```

---

### Task 8: Riverpod Providers & main.dart

**Files:**
- Create: `lib/presentation/providers/database_provider.dart`
- Create: `lib/presentation/providers/deck_provider.dart`
- Create: `lib/presentation/providers/review_provider.dart`
- Create: `lib/presentation/providers/stats_provider.dart`
- Create: `lib/presentation/providers/locale_provider.dart`
- Modify: `lib/main.dart`

- [ ] **Step 1: Create database_provider.dart**

```dart
// lib/presentation/providers/database_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/deck_repository_impl.dart';
import '../../data/repositories/card_repository_impl.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../data/repositories/stats_repository_impl.dart';
import '../../domain/repositories/deck_repository.dart';
import '../../domain/repositories/card_repository.dart';
import '../../domain/repositories/review_repository.dart';
import '../../domain/repositories/stats_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final deckRepositoryProvider = Provider<DeckRepository>((ref) {
  return DeckRepositoryImpl(ref.watch(appDatabaseProvider));
});

final cardRepositoryProvider = Provider<CardRepository>((ref) {
  return CardRepositoryImpl(ref.watch(appDatabaseProvider));
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(ref.watch(appDatabaseProvider));
});

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepositoryImpl(ref.watch(appDatabaseProvider));
});
```

- [ ] **Step 2: Create deck_provider.dart**

```dart
// lib/presentation/providers/deck_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/deck.dart';
import '../../domain/entities/card.dart';
import 'database_provider.dart';

final allDecksProvider = FutureProvider<List<Deck>>((ref) {
  return ref.watch(deckRepositoryProvider).getAllDecks();
});

final cardsForDeckProvider =
    FutureProvider.family<List<KoreanCard>, String>((ref, deckId) {
  return ref.watch(cardRepositoryProvider).getCardsByDeck(deckId);
});

final customDecksCountProvider = FutureProvider<int>((ref) async {
  final all = await ref.watch(allDecksProvider.future);
  return all.where((d) => !d.isBuiltIn).length;
});
```

- [ ] **Step 3: Create stats_provider.dart**

```dart
// lib/presentation/providers/stats_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_stats.dart';
import '../../domain/entities/achievement.dart';
import 'database_provider.dart';

final userStatsProvider = FutureProvider<UserStats>((ref) {
  return ref.watch(statsRepositoryProvider).getStats();
});

final achievementsProvider = FutureProvider<List<Achievement>>((ref) {
  return ref.watch(statsRepositoryProvider).getAchievements();
});

final dailyCountsProvider =
    FutureProvider.family<Map<DateTime, int>, int>((ref, days) {
  return ref.watch(statsRepositoryProvider).getDailyReviewCounts(days);
});
```

- [ ] **Step 4: Create locale_provider.dart**

```dart
// lib/presentation/providers/locale_provider.dart
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((ref) => LocaleNotifier());

class LocaleNotifier extends StateNotifier<Locale> {
  static const _key = 'app_locale';

  LocaleNotifier() : super(const Locale('zh')) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key) ?? 'zh';
    state = Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }
}
```

- [ ] **Step 5: Write main.dart**

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/locale_provider.dart';
import 'presentation/screens/home/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: KappApp()));
}

class KappApp extends ConsumerWidget {
  const KappApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      title: 'Kapp',
      theme: AppTheme.light,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh'),
        Locale('en'),
      ],
      home: const HomeScreen(),
    );
  }
}
```

- [ ] **Step 6: Commit**

```bash
git add lib/presentation/providers/ lib/main.dart
git commit -m "feat: Riverpod providers and app entry point"
```

---

### Task 9: Localization & Theme

**Files:**
- Create: `lib/core/l10n/app_zh.arb`
- Create: `lib/core/l10n/app_en.arb`
- Create: `lib/core/theme/app_theme.dart`

- [ ] **Step 1: Create app_zh.arb**

```json
{
  "@@locale": "zh",
  "appTitle": "韓文單字卡",
  "tabStudy": "學習",
  "tabLibrary": "詞庫",
  "tabProgress": "進度",
  "tabSettings": "設定",
  "selectDeck": "選擇牌組",
  "selectMode": "選擇模式",
  "modeFlip": "翻牌模式",
  "modeFlipDesc": "自由翻牌，自己掌握學習節奏",
  "modeSR": "間隔重複",
  "modeSRDesc": "根據答題表現智慧安排複習時間",
  "btnDontKnow": "不會",
  "btnHard": "困難",
  "btnGood": "良好",
  "btnEasy": "簡單",
  "flipToReveal": "點擊卡片查看答案",
  "builtInDecks": "內建牌組",
  "myDecks": "我的牌組",
  "newDeck": "新增牌組",
  "newCard": "新增卡片",
  "editCard": "編輯卡片",
  "korean": "韓文",
  "romanization": "羅馬拼音",
  "meaningZh": "中文意思",
  "meaningEn": "英文意思",
  "exampleSentence": "例句",
  "exampleTranslation": "例句翻譯",
  "save": "儲存",
  "delete": "刪除",
  "cancel": "取消",
  "confirmDelete": "確認刪除？",
  "streak": "連續學習天數",
  "longestStreak": "最長紀錄",
  "totalReviewed": "累計複習",
  "accuracy": "正確率",
  "achievements": "成就",
  "dailyGoal": "每日目標",
  "cards": "張",
  "days": "天",
  "language": "語言",
  "about": "關於",
  "sessionComplete": "本次完成！",
  "cardsReviewed": "複習了 {count} 張",
  "@cardsReviewed": { "placeholders": { "count": { "type": "int" } } },
  "achievementUnlocked": "成就解鎖：{title}",
  "@achievementUnlocked": { "placeholders": { "title": { "type": "String" } } },
  "achievementFirstTitle": "初心者",
  "achievementFirstDesc": "完成第一次複習",
  "achievementStreak7Title": "一週挑戰",
  "achievementStreak7Desc": "連續學習 7 天",
  "achievementTotal500Title": "單字王",
  "achievementTotal500Desc": "累計複習 500 張卡片",
  "achievementPerfectTitle": "完美主義者",
  "achievementPerfectDesc": "單次複習答對率 100%",
  "achievementDeckTitle": "詞庫創作者",
  "achievementDeckDesc": "建立第一個自訂牌組"
}
```

- [ ] **Step 2: Create app_en.arb**

```json
{
  "@@locale": "en",
  "appTitle": "Korean Flashcards",
  "tabStudy": "Study",
  "tabLibrary": "Library",
  "tabProgress": "Progress",
  "tabSettings": "Settings",
  "selectDeck": "Select Deck",
  "selectMode": "Select Mode",
  "modeFlip": "Flip Mode",
  "modeFlipDesc": "Flip cards at your own pace",
  "modeSR": "Spaced Repetition",
  "modeSRDesc": "Smart scheduling based on your answers",
  "btnDontKnow": "Don't Know",
  "btnHard": "Hard",
  "btnGood": "Good",
  "btnEasy": "Easy",
  "flipToReveal": "Tap card to reveal answer",
  "builtInDecks": "Built-in Decks",
  "myDecks": "My Decks",
  "newDeck": "New Deck",
  "newCard": "New Card",
  "editCard": "Edit Card",
  "korean": "Korean",
  "romanization": "Romanization",
  "meaningZh": "Chinese Meaning",
  "meaningEn": "English Meaning",
  "exampleSentence": "Example Sentence",
  "exampleTranslation": "Translation",
  "save": "Save",
  "delete": "Delete",
  "cancel": "Cancel",
  "confirmDelete": "Confirm delete?",
  "streak": "Current Streak",
  "longestStreak": "Longest Streak",
  "totalReviewed": "Total Reviewed",
  "accuracy": "Accuracy",
  "achievements": "Achievements",
  "dailyGoal": "Daily Goal",
  "cards": "cards",
  "days": "days",
  "language": "Language",
  "about": "About",
  "sessionComplete": "Session Complete!",
  "cardsReviewed": "Reviewed {count} cards",
  "@cardsReviewed": { "placeholders": { "count": { "type": "int" } } },
  "achievementUnlocked": "Achievement Unlocked: {title}",
  "@achievementUnlocked": { "placeholders": { "title": { "type": "String" } } },
  "achievementFirstTitle": "Beginner",
  "achievementFirstDesc": "Complete your first review",
  "achievementStreak7Title": "7-Day Streak",
  "achievementStreak7Desc": "Study 7 days in a row",
  "achievementTotal500Title": "Vocab King",
  "achievementTotal500Desc": "Review 500 cards total",
  "achievementPerfectTitle": "Perfectionist",
  "achievementPerfectDesc": "100% accuracy in one session",
  "achievementDeckTitle": "Deck Creator",
  "achievementDeckDesc": "Create your first custom deck"
}
```

- [ ] **Step 3: Generate localizations**

```bash
flutter gen-l10n
```

Expected: Creates `lib/flutter_gen/gen_l10n/app_localizations.dart` (or `.dart_tool/flutter_gen/`).

- [ ] **Step 4: Create app_theme.dart**

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const _primary = Color(0xFF0B3D91);   // Korean blue
  static const _secondary = Color(0xFFCD2E3A); // Korean red

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primary,
      secondary: _secondary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
  );
}
```

- [ ] **Step 5: Commit**

```bash
git add lib/core/
git commit -m "feat: localization (zh/en) and app theme"
```

---

### Task 10: Home Screen & Navigation Shell

**Files:**
- Modify: `lib/presentation/screens/home/home_screen.dart`

- [ ] **Step 1: Write home_screen.dart**

```dart
// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../study/deck_selection_screen.dart';
import '../library/library_screen.dart';
import '../progress/progress_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  static const _screens = [
    DeckSelectionScreen(),
    LibraryScreen(),
    ProgressScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.school), label: l.tabStudy),
          NavigationDestination(icon: const Icon(Icons.library_books), label: l.tabLibrary),
          NavigationDestination(icon: const Icon(Icons.bar_chart), label: l.tabProgress),
          NavigationDestination(icon: const Icon(Icons.settings), label: l.tabSettings),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Create stub screens so the project compiles**

Create each of these with a minimal `Scaffold` placeholder:

`lib/presentation/screens/study/deck_selection_screen.dart`:
```dart
import 'package:flutter/material.dart';
class DeckSelectionScreen extends StatelessWidget {
  const DeckSelectionScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Study')));
}
```

`lib/presentation/screens/library/library_screen.dart`:
```dart
import 'package:flutter/material.dart';
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Library')));
}
```

`lib/presentation/screens/progress/progress_screen.dart`:
```dart
import 'package:flutter/material.dart';
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Progress')));
}
```

`lib/presentation/screens/settings/settings_screen.dart`:
```dart
import 'package:flutter/material.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Settings')));
}
```

- [ ] **Step 3: Verify the app runs on a connected device/emulator**

```bash
flutter run
```

Expected: App launches showing bottom navigation with 4 tabs. Each tab shows a placeholder text.

- [ ] **Step 4: Commit**

```bash
git add lib/presentation/screens/
git commit -m "feat: home screen with bottom navigation shell"
```

---

### Task 11: Study Flow — Deck Selection & Mode Selection

**Files:**
- Modify: `lib/presentation/screens/study/deck_selection_screen.dart`
- Create: `lib/presentation/screens/study/mode_selection_screen.dart`

- [ ] **Step 1: Replace DeckSelectionScreen**

```dart
// lib/presentation/screens/study/deck_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../domain/entities/deck.dart';
import '../../providers/deck_provider.dart';
import 'mode_selection_screen.dart';

class DeckSelectionScreen extends ConsumerWidget {
  const DeckSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final decksAsync = ref.watch(allDecksProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.selectDeck)),
      body: decksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (decks) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: decks.length,
          itemBuilder: (ctx, i) => _DeckCard(deck: decks[i]),
        ),
      ),
    );
  }
}

class _DeckCard extends StatelessWidget {
  final Deck deck;
  const _DeckCard({required this.deck});

  @override
  Widget build(BuildContext context) {
    final badge = deck.level == DeckLevel.beginner ? '初級' : '進階';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(deck.name, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(deck.description),
        trailing: Chip(label: Text(badge)),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ModeSelectionScreen(deck: deck),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Create mode_selection_screen.dart**

```dart
// lib/presentation/screens/study/mode_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../domain/entities/deck.dart';
import 'review_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  final Deck deck;
  const ModeSelectionScreen({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.selectMode)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ModeCard(
              icon: Icons.flip,
              title: l.modeFlip,
              description: l.modeFlipDesc,
              onTap: () => _startReview(context, ReviewMode.flip),
            ),
            const SizedBox(height: 16),
            _ModeCard(
              icon: Icons.auto_awesome,
              title: l.modeSR,
              description: l.modeSRDesc,
              onTap: () => _startReview(context, ReviewMode.spacedRepetition),
            ),
          ],
        ),
      ),
    );
  }

  void _startReview(BuildContext context, ReviewMode mode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewScreen(deck: deck, mode: mode),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(description,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/screens/study/deck_selection_screen.dart lib/presentation/screens/study/mode_selection_screen.dart
git commit -m "feat: deck selection and mode selection screens"
```

---

### Task 12: Review Screen

**Files:**
- Create: `lib/presentation/screens/study/review_screen.dart`
- Create: `lib/presentation/providers/review_provider.dart`

- [ ] **Step 1: Create review_provider.dart**

```dart
// lib/presentation/providers/review_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/card.dart';
import '../../domain/entities/review_record.dart';
import '../../domain/usecases/calculate_sm2.dart';
import 'database_provider.dart';

class ReviewSession {
  final List<KoreanCard> cards;
  final int currentIndex;
  final bool isFlipped;
  final int sessionCorrect;

  const ReviewSession({
    required this.cards,
    required this.currentIndex,
    required this.isFlipped,
    required this.sessionCorrect,
  });

  bool get isComplete => currentIndex >= cards.length;
  KoreanCard? get currentCard =>
      isComplete ? null : cards[currentIndex];

  ReviewSession copyWith({
    int? currentIndex,
    bool? isFlipped,
    int? sessionCorrect,
  }) {
    return ReviewSession(
      cards: cards,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
      sessionCorrect: sessionCorrect ?? this.sessionCorrect,
    );
  }
}

class ReviewNotifier extends StateNotifier<AsyncValue<ReviewSession>> {
  final Ref _ref;
  final String deckId;

  ReviewNotifier(this._ref, this.deckId)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    final cards =
        await _ref.read(cardRepositoryProvider).getCardsByDeck(deckId);
    state = AsyncValue.data(ReviewSession(
      cards: cards,
      currentIndex: 0,
      isFlipped: false,
      sessionCorrect: 0,
    ));
  }

  void flip() {
    state.whenData((s) => state = AsyncValue.data(s.copyWith(isFlipped: true)));
  }

  Future<void> rateCard(int rating) async {
    final session = state.valueOrNull;
    if (session == null || session.isComplete) return;

    final card = session.currentCard!;
    final repo = _ref.read(reviewRepositoryProvider);
    final existing = await repo.getRecord(card.id);

    final result = calculateSM2(
      rating: rating,
      easeFactor: existing?.easeFactor ?? 2.5,
      interval: existing?.interval ?? 1,
      repetitions: existing?.repetitions ?? 0,
    );

    await repo.saveRecord(ReviewRecord(
      cardId: card.id,
      easeFactor: result.easeFactor,
      interval: result.interval,
      repetitions: result.repetitions,
      nextReviewAt: result.nextReviewAt,
      lastReviewedAt: DateTime.now(),
    ));

    final correct = rating >= 2 ? session.sessionCorrect + 1 : session.sessionCorrect;
    state = AsyncValue.data(session.copyWith(
      currentIndex: session.currentIndex + 1,
      isFlipped: false,
      sessionCorrect: correct,
    ));
  }

  Future<void> nextFlipCard() async {
    state.whenData((s) => state = AsyncValue.data(s.copyWith(
          currentIndex: s.currentIndex + 1,
          isFlipped: false,
          sessionCorrect: s.sessionCorrect + 1,
        )));
  }
}

final reviewNotifierProvider = StateNotifierProvider.autoDispose
    .family<ReviewNotifier, AsyncValue<ReviewSession>, String>(
  (ref, deckId) => ReviewNotifier(ref, deckId),
);
```

- [ ] **Step 2: Create review_screen.dart**

```dart
// lib/presentation/screens/study/review_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../domain/entities/deck.dart';
import '../../providers/review_provider.dart';
import '../../providers/locale_provider.dart';

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
                          )
                        : _CardFront(
                            key: const ValueKey('front'),
                            korean: card.korean,
                            hint: l.flipToReveal,
                          ),
                  ),
                ),
              ),
              if (session.isFlipped)
                _RatingButtons(mode: mode, deckId: deck.id),
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
  const _CardFront({super.key, required this.korean, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
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

  const _CardBack({
    super.key,
    required this.korean,
    required this.romanization,
    required this.meaning,
    required this.example,
    required this.translation,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
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
    final notifier = ref.read(reviewNotifierProvider(deckId).notifier);

    if (mode == ReviewMode.flip) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: notifier.nextFlipCard,
            child: const Text('Next →'),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _ratingBtn(context, l.btnDontKnow, 0, Colors.red, notifier),
          _ratingBtn(context, l.btnHard, 1, Colors.orange, notifier),
          _ratingBtn(context, l.btnGood, 2, Colors.blue, notifier),
          _ratingBtn(context, l.btnEasy, 3, Colors.green, notifier),
        ],
      ),
    );
  }

  Widget _ratingBtn(
    BuildContext context,
    String label,
    int rating,
    Color color,
    ReviewNotifier notifier,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: color),
          onPressed: () => notifier.rateCard(rating),
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}

class _SessionComplete extends StatelessWidget {
  final int total;
  final int correct;

  const _SessionComplete({required this.total, required this.correct});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final accuracy = total > 0 ? (correct / total * 100).round() : 0;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
          const SizedBox(height: 16),
          Text(l.sessionComplete,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(l.cardsReviewed(total)),
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

- [ ] **Step 3: Hot reload and test the review flow end-to-end**

Run the app, select a deck, choose a mode, flip cards, confirm:
- Flip mode: tapping card reveals answer, Next button advances
- SR mode: rating buttons appear after flip, they advance to next card
- Progress bar updates with each card

- [ ] **Step 4: Commit**

```bash
git add lib/presentation/screens/study/review_screen.dart lib/presentation/providers/review_provider.dart
git commit -m "feat: review screen (flip + spaced repetition modes)"
```

---

### Task 13: Library Screen & Card Edit

**Files:**
- Modify: `lib/presentation/screens/library/library_screen.dart`
- Create: `lib/presentation/screens/library/card_edit_screen.dart`

- [ ] **Step 1: Replace LibraryScreen**

```dart
// lib/presentation/screens/library/library_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../domain/entities/deck.dart';
import '../../providers/deck_provider.dart';
import 'card_edit_screen.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final decksAsync = ref.watch(allDecksProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.tabLibrary)),
      body: decksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (decks) {
          final builtIn = decks.where((d) => d.isBuiltIn).toList();
          final custom = decks.where((d) => !d.isBuiltIn).toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionHeader(title: l.builtInDecks),
              ...builtIn.map((d) => _DeckTile(deck: d)),
              const SizedBox(height: 16),
              _SectionHeader(title: l.myDecks),
              ...custom.map((d) => _DeckTile(deck: d)),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewDeckDialog(context, ref),
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.newDeck),
      ),
    );
  }

  void _showNewDeckDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final l = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.newDeck),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
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
                createdAt: DateTime.now(),
              ));
              ref.invalidate(allDecksProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(l.save),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Colors.grey)),
    );
  }
}

class _DeckTile extends ConsumerWidget {
  final Deck deck;
  const _DeckTile({required this.deck});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final cardsAsync = ref.watch(cardsForDeckProvider(deck.id));
    final count = cardsAsync.valueOrNull?.length ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(deck.name),
        subtitle: Text('$count ${l.cards}'),
        trailing: deck.isBuiltIn
            ? null
            : IconButton(
                icon: const Icon(Icons.add_card),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CardEditScreen(deckId: deck.id),
                  ),
                ),
              ),
      ),
    );
  }
}
```

- [ ] **Step 2: Create card_edit_screen.dart**

```dart
// lib/presentation/screens/library/card_edit_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/card.dart';
import '../../providers/deck_provider.dart';
import '../../providers/database_provider.dart';

class CardEditScreen extends ConsumerStatefulWidget {
  final String deckId;
  final KoreanCard? existing;

  const CardEditScreen({super.key, required this.deckId, this.existing});

  @override
  ConsumerState<CardEditScreen> createState() => _CardEditScreenState();
}

class _CardEditScreenState extends ConsumerState<CardEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _koreanCtrl = TextEditingController(text: widget.existing?.korean);
  late final _romanCtrl = TextEditingController(text: widget.existing?.romanization);
  late final _zhCtrl = TextEditingController(text: widget.existing?.meaningZh);
  late final _enCtrl = TextEditingController(text: widget.existing?.meaningEn);
  late final _exCtrl = TextEditingController(text: widget.existing?.exampleSentence);
  late final _transCtrl = TextEditingController(text: widget.existing?.exampleTranslation);

  @override
  void dispose() {
    for (final c in [_koreanCtrl, _romanCtrl, _zhCtrl, _enCtrl, _exCtrl, _transCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? l.editCard : l.newCard)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_koreanCtrl, l.korean, required: true),
            _field(_romanCtrl, l.romanization, required: true),
            _field(_zhCtrl, l.meaningZh),
            _field(_enCtrl, l.meaningEn),
            _field(_exCtrl, l.exampleSentence),
            _field(_transCtrl, l.exampleTranslation),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              child: Text(l.save),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label,
      {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: required
            ? (v) => (v == null || v.isEmpty) ? 'Required' : null
            : null,
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_zhCtrl.text.trim().isEmpty && _enCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least one meaning')),
      );
      return;
    }

    final repo = ref.read(cardRepositoryProvider);
    final card = KoreanCard(
      id: widget.existing?.id ?? const Uuid().v4(),
      deckId: widget.deckId,
      korean: _koreanCtrl.text.trim(),
      romanization: _romanCtrl.text.trim(),
      meaningZh: _zhCtrl.text.trim(),
      meaningEn: _enCtrl.text.trim(),
      exampleSentence: _exCtrl.text.trim(),
      exampleTranslation: _transCtrl.text.trim(),
      createdAt: widget.existing?.createdAt ?? DateTime.now(),
    );

    if (widget.existing == null) {
      await repo.createCard(card);
    } else {
      await repo.updateCard(card);
    }

    ref.invalidate(cardsForDeckProvider(widget.deckId));
    if (mounted) Navigator.pop(context);
  }
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/screens/library/
git commit -m "feat: library screen and card edit screen"
```

---

### Task 14: Post-Session Streak & Achievement Update

**Files:**
- Modify: `lib/presentation/providers/review_provider.dart`
- Modify: `lib/presentation/screens/study/review_screen.dart`

- [ ] **Step 1: Add `_finalizeSession` to ReviewNotifier**

Add this method inside `ReviewNotifier` in `review_provider.dart`:

```dart
Future<void> finalizeSession() async {
  final session = state.valueOrNull;
  if (session == null) return;

  final statsRepo = _ref.read(statsRepositoryProvider);
  final db = _ref.read(appDatabaseProvider);

  // Update daily count
  await _ref.read(appDatabaseProvider).statsDao.incrementDailyCount(DateTime.now());

  // Update streak
  var stats = await statsRepo.getStats();
  final today = DateTime.now();
  final isNewDay = stats.lastStudiedAt == null ||
      !_sameDay(stats.lastStudiedAt!, today);
  final wasMissed = stats.lastStudiedAt != null &&
      today.difference(stats.lastStudiedAt!).inDays > 1;

  if (isNewDay) {
    final newStreak = wasMissed ? 1 : stats.currentStreak + 1;
    stats = stats.copyWith(
      currentStreak: newStreak,
      longestStreak: newStreak > stats.longestStreak
          ? newStreak
          : stats.longestStreak,
      totalCardsReviewed: stats.totalCardsReviewed + session.cards.length,
      totalCorrect: stats.totalCorrect + session.sessionCorrect,
      lastStudiedAt: today,
    );
  } else {
    stats = stats.copyWith(
      totalCardsReviewed: stats.totalCardsReviewed + session.cards.length,
      totalCorrect: stats.totalCorrect + session.sessionCorrect,
    );
  }
  await statsRepo.saveStats(stats);

  // Evaluate achievements
  final achievements = await statsRepo.getAchievements();
  final customDecks = await _ref.read(customDecksCountProvider.future);
  final updated = evaluateAchievements(
    achievements: achievements,
    stats: stats,
    sessionCorrect: session.sessionCorrect,
    sessionTotal: session.cards.length,
    customDecksCount: customDecks,
  );
  for (final a in updated) {
    if (a.unlocked && !achievements.any((old) => old.id == a.id && old.unlocked)) {
      await statsRepo.unlockAchievement(a.id);
    }
  }
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
```

Also add the import at the top of `review_provider.dart`:

```dart
import '../../domain/usecases/evaluate_achievements.dart';
import 'stats_provider.dart';
```

- [ ] **Step 2: Call finalizeSession when session completes**

In `review_screen.dart`, in `_SessionComplete.build`, add a call in `initState`. Replace the `_SessionComplete` class:

```dart
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewNotifierProvider(widget.deckId).notifier).finalizeSession();
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

Update the `ReviewScreen.build` method to pass `deckId` to `_SessionComplete`:

```dart
if (session.isComplete) {
  return _SessionComplete(
    total: session.cards.length,
    correct: session.sessionCorrect,
    deckId: deck.id,
  );
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/providers/review_provider.dart lib/presentation/screens/study/review_screen.dart
git commit -m "feat: post-session streak update and achievement evaluation"
```

---

### Task 15: Progress Screen

**Files:**
- Modify: `lib/presentation/screens/progress/progress_screen.dart`

- [ ] **Step 1: Replace ProgressScreen**

```dart
// lib/presentation/screens/progress/progress_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../domain/entities/achievement.dart';
import '../../providers/stats_provider.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final statsAsync = ref.watch(userStatsProvider);
    final achievementsAsync = ref.watch(achievementsProvider);
    final dailyAsync = ref.watch(dailyCountsProvider(14));

    return Scaffold(
      appBar: AppBar(title: Text(l.tabProgress)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stats row
          statsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('$e'),
            data: (stats) => Row(
              children: [
                _StatCard(label: l.streak, value: '${stats.currentStreak}', unit: l.days),
                _StatCard(label: l.longestStreak, value: '${stats.longestStreak}', unit: l.days),
                _StatCard(label: l.totalReviewed, value: '${stats.totalCardsReviewed}', unit: l.cards),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Daily bar chart
          Text(l.tabProgress, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: dailyAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('$e'),
              data: (counts) => _DailyBarChart(counts: counts),
            ),
          ),
          const SizedBox(height: 24),

          // Achievements
          Text(l.achievements, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          achievementsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('$e'),
            data: (achievements) => Wrap(
              spacing: 12,
              runSpacing: 12,
              children: achievements
                  .map((a) => _AchievementBadge(achievement: a))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _StatCard({required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      )),
              Text(unit, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(label,
                  style: Theme.of(context).textTheme.labelSmall,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyBarChart extends StatelessWidget {
  final Map<DateTime, int> counts;
  const _DailyBarChart({required this.counts});

  @override
  Widget build(BuildContext context) {
    if (counts.isEmpty) {
      return const Center(child: Text('No data yet'));
    }
    final sorted = counts.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    final bars = sorted.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.value.toDouble(),
            color: Theme.of(context).colorScheme.primary,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: bars,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final idx = value.toInt();
                if (idx < 0 || idx >= sorted.length) return const SizedBox();
                final d = sorted[idx].key;
                return Text('${d.month}/${d.day}',
                    style: const TextStyle(fontSize: 10));
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final Achievement achievement;
  const _AchievementBadge({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.unlocked;
    return Tooltip(
      message: achievement.descKey, // replace with l10n lookup in full impl
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: unlocked
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              _iconFromName(achievement.iconName),
              size: 32,
              color: unlocked
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              achievement.titleKey,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFromName(String name) {
    switch (name) {
      case 'local_fire_department': return Icons.local_fire_department;
      case 'menu_book': return Icons.menu_book;
      case 'verified': return Icons.verified;
      case 'library_add': return Icons.library_add;
      default: return Icons.star;
    }
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/presentation/screens/progress/progress_screen.dart
git commit -m "feat: progress screen with bar chart and achievement wall"
```

---

### Task 16: Settings Screen

**Files:**
- Modify: `lib/presentation/screens/settings/settings_screen.dart`

- [ ] **Step 1: Replace SettingsScreen**

```dart
// lib/presentation/screens/settings/settings_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/locale_provider.dart';

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
    state = prefs.getInt(_key) ?? 10;
  }
  Future<void> setGoal(int goal) async {
    state = goal;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, goal);
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final goal = ref.watch(dailyGoalProvider);

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
                ref
                    .read(localeProvider.notifier)
                    .setLocale(Locale(set.first));
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
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l.about),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: l.appTitle,
              applicationVersion: '1.0.0',
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/presentation/screens/settings/settings_screen.dart
git commit -m "feat: settings screen (language toggle, daily goal)"
```

---

### Task 17: Build Release APK

**Files:**
- Modify: `android/app/build.gradle`
- Modify: `pubspec.yaml` (version bump)

- [ ] **Step 1: Verify the app compiles and runs without errors**

```bash
flutter analyze
flutter test
```

Expected: No analysis issues. All tests pass.

- [ ] **Step 2: Set app name for Android**

Edit `android/app/src/main/AndroidManifest.xml` — change `android:label`:

```xml
android:label="韓文單字卡"
```

- [ ] **Step 3: Set minimum SDK version**

In `android/app/build.gradle`, confirm or set:

```gradle
defaultConfig {
    minSdkVersion 21
    targetSdkVersion 34
}
```

- [ ] **Step 4: Build release APK**

```bash
flutter build apk --release
```

Expected output (last lines):
```
✓ Built build/app/outputs/flutter-apk/app-release.apk (XX.XMB)
```

- [ ] **Step 5: Verify APK exists**

```bash
ls build/app/outputs/flutter-apk/
```

Expected: `app-release.apk` present.

- [ ] **Step 6: Final commit**

```bash
git add android/app/src/main/AndroidManifest.xml android/app/build.gradle
git commit -m "build: configure Android manifest and release APK build"
```

---

## Implementation Order

Execute tasks in this order — each task compiles and tests before the next begins:

1. Task 1 — Scaffold
2. Task 2 — Entities
3. Task 3 — Interfaces
4. Task 4 — SM-2 (TDD)
5. Task 5 — Achievements (TDD)
6. Task 6 — Database & DAOs
7. Task 7 — Seed + Repositories
8. Task 8 — Providers + main.dart
9. Task 9 — L10n + Theme
10. Task 10 — Home shell (first `flutter run` smoke test)
11. Task 11 — Study flow
12. Task 12 — Review screen
13. Task 14 — Post-session logic
14. Task 13 — Library
15. Task 15 — Progress
16. Task 16 — Settings
17. Task 17 — APK build
