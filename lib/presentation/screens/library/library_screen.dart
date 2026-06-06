import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../domain/entities/deck.dart';
import '../../providers/deck_provider.dart';
import '../../providers/database_provider.dart';
import 'card_edit_screen.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final decksAsync = ref.watch(allDecksProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.tabLibrary)),
      body: decksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (decks) {
          final builtIn = decks.where((d) => d.isBuiltIn).toList();
          final custom = decks.where((d) => !d.isBuiltIn).toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionHeader(title: l.builtInDecks),
              ...builtIn.map((d) => _DeckTile(deck: d)),
              const SizedBox(height: 16),
              _SectionHeader(title: l.myDecks),
              ...custom.map((d) => _DeckTile(deck: d)),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewDeckDialog(context, ref),
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.newDeck),
      ),
    );
  }

  void _showNewDeckDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _NewDeckDialog(onSave: (name, language) async {
        final repo = ref.read(deckRepositoryProvider);
        await repo.createDeck(Deck(
          id: '',
          name: name,
          description: '',
          level: DeckLevel.all,
          isBuiltIn: false,
          createdAt: DateTime.now(),
          language: language,
        ));
        ref.invalidate(allDecksProvider);
      }),
    );
  }
}

class _NewDeckDialog extends StatefulWidget {
  final Future<void> Function(String name, String language) onSave;
  const _NewDeckDialog({required this.onSave});

  @override
  State<_NewDeckDialog> createState() => _NewDeckDialogState();
}

class _NewDeckDialogState extends State<_NewDeckDialog> {
  final _controller = TextEditingController();
  String _language = 'ko-KR';

  static const _languages = [
    ('ko-KR', '한국어 (Korean)'),
    ('ja-JP', '日本語 (Japanese)'),
    ('en-US', 'English'),
    ('zh-TW', '繁體中文 (Traditional Chinese)'),
    ('fr-FR', 'Français (French)'),
    ('es-ES', 'Español (Spanish)'),
    ('de-DE', 'Deutsch (German)'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l.newDeck),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: l.deckName),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          InputDecorator(
            decoration: InputDecoration(labelText: l.deckLanguage),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _language,
                isExpanded: true,
                items: _languages
                    .map((e) =>
                        DropdownMenuItem(value: e.$1, child: Text(e.$2)))
                    .toList(),
                onChanged: (v) => setState(() => _language = v!),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_controller.text.trim().isEmpty) return;
            await widget.onSave(_controller.text.trim(), _language);
            if (context.mounted) Navigator.pop(context);
          },
          child: Text(l.save),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Colors.grey)),
    );
  }
}

class _DeckTile extends ConsumerWidget {
  final Deck deck;
  const _DeckTile({required this.deck});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final cardsAsync = ref.watch(cardsForDeckProvider(deck.id));
    final count = cardsAsync.valueOrNull?.length ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(deck.name),
        subtitle: Text('$count ${l.cards}'),
        trailing: deck.isBuiltIn
            ? null
            : IconButton(
                icon: const Icon(Icons.add_card),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CardEditScreen(deckId: deck.id),
                  ),
                ),
              ),
      ),
    );
  }
}
