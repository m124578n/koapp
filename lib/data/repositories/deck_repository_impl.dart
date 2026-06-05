// lib/data/repositories/deck_repository_impl.dart
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/deck.dart';
import '../../domain/repositories/deck_repository.dart';
import '../database/app_database.dart';

class DeckRepositoryImpl implements DeckRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  DeckRepositoryImpl(this._db);

  @override
  Future<List<Deck>> getAllDecks() async {
    final rows = await _db.deckDao.getAllDecks();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<List<Deck>> getDecksByLevel(DeckLevel level) async {
    final rows = await _db.deckDao.getDecksByLevel(_levelToString(level));
    return rows.map(_toDomain).toList();
  }

  @override
  Future<void> createDeck(Deck deck) async {
    await _db.deckDao.insertDeck(DecksCompanion(
      id: Value(deck.id.isEmpty ? _uuid.v4() : deck.id),
      name: Value(deck.name),
      description: Value(deck.description),
      level: Value(_levelToString(deck.level)),
      isBuiltIn: Value(deck.isBuiltIn),
      createdAt: Value(deck.createdAt),
    ));
  }

  @override
  Future<void> deleteDeck(String deckId) =>
      _db.deckDao.deleteDeckById(deckId);

  Deck _toDomain(DeckRow row) => Deck(
        id: row.id,
        name: row.name,
        description: row.description,
        level: _levelFromString(row.level),
        isBuiltIn: row.isBuiltIn,
        createdAt: row.createdAt,
      );

  String _levelToString(DeckLevel l) => l.name;
  DeckLevel _levelFromString(String s) =>
      DeckLevel.values.firstWhere((e) => e.name == s, orElse: () => DeckLevel.all);
}
