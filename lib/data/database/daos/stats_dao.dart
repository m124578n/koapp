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
