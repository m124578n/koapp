// lib/data/database/daos/card_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'card_dao.g.dart';

@DriftAccessor(tables: [Cards])
class CardDao extends DatabaseAccessor<AppDatabase> with _$CardDaoMixin {
  CardDao(super.db);

  Future<List<CardRow>> getCardsByDeck(String deckId) =>
      (select(cards)..where((t) => t.deckId.equals(deckId))).get();

  Future<void> insertCard(CardsCompanion companion) =>
      into(cards).insertOnConflictUpdate(companion);

  Future<void> updateCardById(CardsCompanion companion) =>
      (update(cards)..where((t) => t.id.equals(companion.id.value)))
          .write(companion);

  Future<void> deleteCardById(String id) =>
      (delete(cards)..where((t) => t.id.equals(id))).go();
}
