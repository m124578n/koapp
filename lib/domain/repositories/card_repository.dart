// lib/domain/repositories/card_repository.dart
import '../entities/card.dart';

abstract class CardRepository {
  Future<List<KoreanCard>> getCardsByDeck(String deckId);
  Future<void> createCard(KoreanCard card);
  Future<void> updateCard(KoreanCard card);
  Future<void> deleteCard(String cardId);
}
