// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_dao.dart';

// ignore_for_file: type=lint
mixin _$ReviewDaoMixin on DatabaseAccessor<AppDatabase> {
  $DecksTable get decks => attachedDatabase.decks;
  $CardsTable get cards => attachedDatabase.cards;
  $ReviewRecordsTable get reviewRecords => attachedDatabase.reviewRecords;
  ReviewDaoManager get managers => ReviewDaoManager(this);
}

class ReviewDaoManager {
  final _$ReviewDaoMixin _db;
  ReviewDaoManager(this._db);
  $$DecksTableTableManager get decks =>
      $$DecksTableTableManager(_db.attachedDatabase, _db.decks);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db.attachedDatabase, _db.cards);
  $$ReviewRecordsTableTableManager get reviewRecords =>
      $$ReviewRecordsTableTableManager(_db.attachedDatabase, _db.reviewRecords);
}
