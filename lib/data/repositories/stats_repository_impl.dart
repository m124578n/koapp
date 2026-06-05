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
      case 'first_review':
        return AchievementCondition.firstReview;
      case 'streak_days':
        return AchievementCondition.streakDays;
      case 'total_reviewed':
        return AchievementCondition.totalReviewed;
      case 'perfect_session':
        return AchievementCondition.perfectSession;
      case 'created_deck':
        return AchievementCondition.createdDeck;
      default:
        throw ArgumentError('Unknown achievement condition: $s');
    }
  }

  @override
  Future<void> incrementDailyCount(DateTime date) =>
      _db.statsDao.incrementDailyCount(date);
}
