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
