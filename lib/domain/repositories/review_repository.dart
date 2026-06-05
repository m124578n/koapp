// lib/domain/repositories/review_repository.dart
import '../entities/review_record.dart';

abstract class ReviewRepository {
  Future<ReviewRecord?> getRecord(String cardId);
  Future<List<ReviewRecord>> getDueRecords(DateTime before);
  Future<void> saveRecord(ReviewRecord record);
}
