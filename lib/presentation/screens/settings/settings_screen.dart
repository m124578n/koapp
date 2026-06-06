import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/locale_provider.dart';
import '../../providers/tts_provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/services/tts_service.dart';

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
    if (mounted) state = prefs.getInt(_key) ?? 10;
  }
  Future<void> setGoal(int goal) async {
    state = goal;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, goal);
  }
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _apiKeyCtrl;
  bool _testing = false;

  @override
  void initState() {
    super.initState();
    _apiKeyCtrl = TextEditingController();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('tts_api_key') ?? '';
    if (mounted) _apiKeyCtrl.text = key;
  }

  @override
  void dispose() {
    _apiKeyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final goal = ref.watch(dailyGoalProvider);
    final tts = ref.watch(ttsProvider);

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
          // TTS Section
          SwitchListTile(
            secondary: const Icon(Icons.volume_up),
            title: Text(l.ttsAutoPlay),
            value: tts.autoPlay,
            onChanged: (v) => ref.read(ttsProvider.notifier).setAutoPlay(v),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _apiKeyCtrl,
                  decoration: InputDecoration(
                    labelText: l.ttsApiKeyLabel,
                    hintText: l.ttsApiKeyHint,
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        await ref
                            .read(ttsProvider.notifier)
                            .setApiKey(_apiKeyCtrl.text.trim());
                        if (mounted) {
                          messenger.showSnackBar(
                            SnackBar(content: Text(l.save)),
                          );
                        }
                      },
                      child: Text(l.save),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _testing
                          ? null
                          : () async {
                              final messenger = ScaffoldMessenger.of(context);
                              setState(() => _testing = true);
                              final result = await ref
                                  .read(ttsProvider.notifier)
                                  .testApiKey(_apiKeyCtrl.text.trim());
                              if (mounted) {
                                setState(() => _testing = false);
                                String msg;
                                switch (result) {
                                  case TtsTestResult.success:
                                    msg = l.ttsTestSuccess;
                                  case TtsTestResult.invalidKey:
                                    msg = l.ttsTestInvalidKey;
                                  case TtsTestResult.networkError:
                                    msg = l.ttsTestNetworkError;
                                }
                                messenger.showSnackBar(
                                  SnackBar(content: Text(msg)),
                                );
                              }
                            },
                      child: _testing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l.ttsTest),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l.about),
            onTap: () => showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(l.appTitle),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Version 1.0.0',
                        style: Theme.of(ctx).textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    const Text('Written by Claude Code',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => launchUrl(
                        Uri.parse('https://github.com/m124578n/koapp'),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: const Text(
                        'github.com/m124578n/koapp',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
