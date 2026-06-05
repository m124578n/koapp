// lib/domain/repositories/deck_repository.dart
import '../entities/deck.dart';

abstract class DeckRepository {
  Future<List<Deck>> getAllDecks();
  Future<List<Deck>> getDecksByLevel(DeckLevel level);
  Future<void> createDeck(Deck deck);
  Future<void> deleteDeck(String deckId);
}
