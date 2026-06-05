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
