// lib/data/repositories/review_repository_impl.dart
import 'package:drift/drift.dart';
import '../../domain/entities/review_record.dart';
import '../../domain/repositories/review_repository.dart';
import '../database/app_database.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final AppDatabase _db;
  ReviewRepositoryImpl(this._db);

  @override
  Future<ReviewRecord?> getRecord(String cardId) async {
    final row = await _db.reviewDao.getRecord(cardId);
    if (row == null) return null;
    return _toDomain(row);
  }

  @override
  Future<List<ReviewRecord>> getDueRecords(DateTime before) async {
    final rows = await _db.reviewDao.getDueRecords(before);
    return rows.map(_toDomain).toList();
  }

  @override
  Future<void> saveRecord(ReviewRecord record) async {
    await _db.reviewDao.saveRecord(ReviewRecordsCompanion(
      cardId: Value(record.cardId),
      easeFactor: Value(record.easeFactor),
      interval: Value(record.interval),
      repetitions: Value(record.repetitions),
      nextReviewAt: Value(record.nextReviewAt),
      lastReviewedAt: Value(record.lastReviewedAt),
    ));
  }

  ReviewRecord _toDomain(ReviewRecordRow row) => ReviewRecord(
        cardId: row.cardId,
        easeFactor: row.easeFactor,
        interval: row.interval,
        repetitions: row.repetitions,
        nextReviewAt: row.nextReviewAt,
        lastReviewedAt: row.lastReviewedAt,
      );
}
