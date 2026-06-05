// lib/data/database/daos/review_dao.dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'review_dao.g.dart';

@DriftAccessor(tables: [ReviewRecords])
class ReviewDao extends DatabaseAccessor<AppDatabase>
    with _$ReviewDaoMixin {
  ReviewDao(super.db);

  Future<ReviewRecordRow?> getRecord(String cardId) =>
      (select(reviewRecords)
            ..where((t) => t.cardId.equals(cardId)))
          .getSingleOrNull();

  Future<List<ReviewRecordRow>> getDueRecords(DateTime before) =>
      (select(reviewRecords)
            ..where((t) => t.nextReviewAt.isSmallerOrEqualValue(before)))
          .get();

  Future<void> saveRecord(ReviewRecordsCompanion companion) =>
      into(reviewRecords).insertOnConflictUpdate(companion);
}
