import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/locale_provider.dart';
import '../../../core/l10n/app_localizations.dart';

final dailyGoalProvider = StateNotifierProvider<DailyGoalNotifier, int>(
  (ref) => DailyGoalNotifier(),
);

class DailyGoalNotifier extends StateNotifier<int> {
  static const _key = 'daily_goal';
  DailyGoalNotifier() : super(10) {
    _load();
  }
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt(_key) ?? 10;
  }
  Future<void> setGoal(int goal) async {
    state = goal;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, goal);
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final goal = ref.watch(dailyGoalProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.tabSettings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l.language),
            trailing: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'zh', label: Text('繁中')),
                ButtonSegment(value: 'en', label: Text('EN')),
              ],
              selected: {locale.languageCode},
              onSelectionChanged: (set) {
                ref
                    .read(localeProvider.notifier)
                    .setLocale(Locale(set.first));
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: Text(l.dailyGoal),
            subtitle: Text('$goal ${l.cards}'),
            trailing: SizedBox(
              width: 120,
              child: Slider(
                value: goal.toDouble(),
                min: 5,
                max: 50,
                divisions: 9,
                label: '$goal',
                onChanged: (v) =>
                    ref.read(dailyGoalProvider.notifier).setGoal(v.round()),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l.about),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: l.appTitle,
              applicationVersion: '1.0.0',
            ),
          ),
        ],
      ),
    );
  }
}
