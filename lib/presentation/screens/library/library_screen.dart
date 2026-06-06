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
    final controller = TextEditingController();
    final l = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.newDeck),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: l.deckName),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.dispose();
              Navigator.pop(ctx);
            },
            child: Text(l.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              final repo = ref.read(deckRepositoryProvider);
              await repo.createDeck(Deck(
                id: '',
                name: controller.text.trim(),
                description: '',
                level: DeckLevel.all,
                isBuiltIn: false,
                createdAt: DateTime.now(),
              ));
              ref.invalidate(allDecksProvider);
              controller.dispose();
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(l.save),
          ),
        ],
      ),
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
