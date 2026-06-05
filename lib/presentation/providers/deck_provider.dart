// lib/presentation/providers/deck_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/deck.dart';
import '../../domain/entities/card.dart';
import 'database_provider.dart';

final allDecksProvider = FutureProvider<List<Deck>>((ref) {
  return ref.watch(deckRepositoryProvider).getAllDecks();
});

final cardsForDeckProvider =
    FutureProvider.family<List<KoreanCard>, String>((ref, deckId) {
  return ref.watch(cardRepositoryProvider).getCardsByDeck(deckId);
});

final customDecksCountProvider = FutureProvider<int>((ref) async {
  final all = await ref.watch(allDecksProvider.future);
  return all.where((d) => !d.isBuiltIn).length;
});
