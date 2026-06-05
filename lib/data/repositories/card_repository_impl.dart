// lib/data/repositories/card_repository_impl.dart
import 'package:drift/drift.dart';
import '../../domain/entities/card.dart';
import '../../domain/repositories/card_repository.dart';
import '../database/app_database.dart';

class CardRepositoryImpl implements CardRepository {
  final AppDatabase _db;
  CardRepositoryImpl(this._db);

  @override
  Future<List<KoreanCard>> getCardsByDeck(String deckId) async {
    final rows = await _db.cardDao.getCardsByDeck(deckId);
    return rows.map(_toDomain).toList();
  }

  @override
  Future<void> createCard(KoreanCard card) async {
    await _db.cardDao.insertCard(CardsCompanion(
      id: Value(card.id),
      deckId: Value(card.deckId),
      korean: Value(card.korean),
      romanization: Value(card.romanization),
      meaningZh: Value(card.meaningZh),
      meaningEn: Value(card.meaningEn),
      exampleSentence: Value(card.exampleSentence),
      exampleTranslation: Value(card.exampleTranslation),
      createdAt: Value(card.createdAt),
    ));
  }

  @override
  Future<void> updateCard(KoreanCard card) async {
    await _db.cardDao.updateCardById(CardsCompanion(
      id: Value(card.id),
      deckId: Value(card.deckId),
      korean: Value(card.korean),
      romanization: Value(card.romanization),
      meaningZh: Value(card.meaningZh),
      meaningEn: Value(card.meaningEn),
      exampleSentence: Value(card.exampleSentence),
      exampleTranslation: Value(card.exampleTranslation),
      createdAt: Value(card.createdAt),
    ));
  }

  @override
  Future<void> deleteCard(String cardId) =>
      _db.cardDao.deleteCardById(cardId);

  KoreanCard _toDomain(CardRow row) => KoreanCard(
        id: row.id,
        deckId: row.deckId,
        korean: row.korean,
        romanization: row.romanization,
        meaningZh: row.meaningZh,
        meaningEn: row.meaningEn,
        exampleSentence: row.exampleSentence,
        exampleTranslation: row.exampleTranslation,
        createdAt: row.createdAt,
      );
}
