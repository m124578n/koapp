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
