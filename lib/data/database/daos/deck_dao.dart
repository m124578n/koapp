// lib/data/database/daos/deck_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'deck_dao.g.dart';

@DriftAccessor(tables: [Decks])
class DeckDao extends DatabaseAccessor<AppDatabase> with _$DeckDaoMixin {
  DeckDao(super.db);

  Future<List<DeckRow>> getAllDecks() => select(decks).get();

  Future<List<DeckRow>> getDecksByLevel(String level) =>
      (select(decks)..where((t) => t.level.equals(level))).get();

  Future<void> insertDeck(DecksCompanion companion) =>
      into(decks).insertOnConflictUpdate(companion);

  Future<void> deleteDeckById(String id) =>
      (delete(decks)..where((t) => t.id.equals(id))).go();
}
