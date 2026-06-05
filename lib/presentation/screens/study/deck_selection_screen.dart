// lib/presentation/screens/study/deck_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../domain/entities/deck.dart';
import '../../providers/deck_provider.dart';
import 'mode_selection_screen.dart';

class DeckSelectionScreen extends ConsumerWidget {
  const DeckSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final decksAsync = ref.watch(allDecksProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.selectDeck)),
      body: decksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (decks) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: decks.length,
          itemBuilder: (ctx, i) => _DeckCard(deck: decks[i]),
        ),
      ),
    );
  }
}

class _DeckCard extends StatelessWidget {
  final Deck deck;
  const _DeckCard({required this.deck});

  @override
  Widget build(BuildContext context) {
    final badge = deck.level == DeckLevel.beginner ? '初級' : '進階';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(deck.name, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(deck.description),
        trailing: Chip(label: Text(badge)),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ModeSelectionScreen(deck: deck)),
        ),
      ),
    );
  }
}
