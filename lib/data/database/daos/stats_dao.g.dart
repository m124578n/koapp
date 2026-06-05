// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_dao.dart';

// ignore_for_file: type=lint
mixin _$StatsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserStatsTableTable get userStatsTable => attachedDatabase.userStatsTable;
  $AchievementsTableTable get achievementsTable =>
      attachedDatabase.achievementsTable;
  $DailyReviewCountsTable get dailyReviewCounts =>
      attachedDatabase.dailyReviewCounts;
  StatsDaoManager get managers => StatsDaoManager(this);
}

class StatsDaoManager {
  final _$StatsDaoMixin _db;
  StatsDaoManager(this._db);
  $$UserStatsTableTableTableManager get userStatsTable =>
      $$UserStatsTableTableTableManager(
        _db.attachedDatabase,
        _db.userStatsTable,
      );
  $$AchievementsTableTableTableManager get achievementsTable =>
      $$AchievementsTableTableTableManager(
        _db.attachedDatabase,
        _db.achievementsTable,
      );
  $$DailyReviewCountsTableTableManager get dailyReviewCounts =>
      $$DailyReviewCountsTableTableManager(
        _db.attachedDatabase,
        _db.dailyReviewCounts,
      );
}
