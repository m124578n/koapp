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
