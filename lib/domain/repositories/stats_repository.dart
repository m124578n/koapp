// lib/domain/repositories/stats_repository.dart
import '../entities/user_stats.dart';
import '../entities/achievement.dart';

abstract class StatsRepository {
  Future<UserStats> getStats();
  Future<void> saveStats(UserStats stats);
  Future<List<Achievement>> getAchievements();
  Future<void> unlockAchievement(String achievementId);
  Future<Map<DateTime, int>> getDailyReviewCounts(int lastNDays);
  Future<void> incrementDailyCount(DateTime date);
}
