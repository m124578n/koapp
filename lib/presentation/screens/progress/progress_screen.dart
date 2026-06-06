import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../domain/entities/achievement.dart';
import '../../providers/stats_provider.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final statsAsync = ref.watch(userStatsProvider);
    final achievementsAsync = ref.watch(achievementsProvider);
    final dailyAsync = ref.watch(dailyCountsProvider(14));

    return Scaffold(
      appBar: AppBar(title: Text(l.tabProgress)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stats row
          statsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('$e'),
            data: (stats) => Row(
              children: [
                _StatCard(label: l.streak, value: '${stats.currentStreak}', unit: l.days),
                _StatCard(label: l.longestStreak, value: '${stats.longestStreak}', unit: l.days),
                _StatCard(label: l.totalReviewed, value: '${stats.totalCardsReviewed}', unit: l.cards),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Daily bar chart
          Text(l.tabProgress, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: dailyAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('$e'),
              data: (counts) => _DailyBarChart(counts: counts),
            ),
          ),
          const SizedBox(height: 24),

          // Achievements
          Text(l.achievements, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          achievementsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('$e'),
            data: (achievements) => Wrap(
              spacing: 12,
              runSpacing: 12,
              children: achievements
                  .map((a) => _AchievementBadge(achievement: a))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _StatCard({required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      )),
              Text(unit, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(label,
                  style: Theme.of(context).textTheme.labelSmall,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyBarChart extends StatelessWidget {
  final Map<DateTime, int> counts;
  const _DailyBarChart({required this.counts});

  @override
  Widget build(BuildContext context) {
    if (counts.isEmpty) {
      return const Center(child: Text('No data yet'));
    }
    final sorted = counts.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    final bars = sorted.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.value.toDouble(),
            color: Theme.of(context).colorScheme.primary,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: bars,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final idx = value.toInt();
                if (idx < 0 || idx >= sorted.length) return const SizedBox();
                final d = sorted[idx].key;
                return Text('${d.month}/${d.day}',
                    style: const TextStyle(fontSize: 10));
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final Achievement achievement;
  const _AchievementBadge({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.unlocked;
    return Tooltip(
      message: achievement.descKey,
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: unlocked
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              _iconFromName(achievement.iconName),
              size: 32,
              color: unlocked
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              achievement.titleKey,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFromName(String name) {
    switch (name) {
      case 'local_fire_department': return Icons.local_fire_department;
      case 'menu_book': return Icons.menu_book;
      case 'verified': return Icons.verified;
      case 'library_add': return Icons.library_add;
      default: return Icons.star;
    }
  }
}
