// lib/domain/entities/review_record.dart
class ReviewRecord {
  final String cardId;
  final double easeFactor;
  final int interval;
  final int repetitions;
  final DateTime nextReviewAt;
  final DateTime lastReviewedAt;

  const ReviewRecord({
    required this.cardId,
    required this.easeFactor,
    required this.interval,
    required this.repetitions,
    required this.nextReviewAt,
    required this.lastReviewedAt,
  });

  ReviewRecord copyWith({
    double? easeFactor,
    int? interval,
    int? repetitions,
    DateTime? nextReviewAt,
    DateTime? lastReviewedAt,
  }) {
    return ReviewRecord(
      cardId: cardId,
      easeFactor: easeFactor ?? this.easeFactor,
      interval: interval ?? this.interval,
      repetitions: repetitions ?? this.repetitions,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
    );
  }
}
