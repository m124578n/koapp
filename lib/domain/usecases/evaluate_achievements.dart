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
