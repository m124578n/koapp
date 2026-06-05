// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_dao.dart';

// ignore_for_file: type=lint
mixin _$DeckDaoMixin on DatabaseAccessor<AppDatabase> {
  $DecksTable get decks => attachedDatabase.decks;
  DeckDaoManager get managers => DeckDaoManager(this);
}

class DeckDaoManager {
  final _$DeckDaoMixin _db;
  DeckDaoManager(this._db);
  $$DecksTableTableManager get decks =>
      $$DecksTableTableManager(_db.attachedDatabase, _db.decks);
}
