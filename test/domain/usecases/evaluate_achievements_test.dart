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
