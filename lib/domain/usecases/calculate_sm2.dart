// lib/domain/usecases/calculate_sm2.dart
class SM2Result {
  final double easeFactor;
  final int interval;
  final int repetitions;
  final DateTime nextReviewAt;

  const SM2Result({
    required this.easeFactor,
    required this.interval,
    required this.repetitions,
    required this.nextReviewAt,
  });
}

SM2Result calculateSM2({
  required int rating, // 0=Don't Know, 1=Hard, 2=Good, 3=Easy
  required double easeFactor,
  required int interval,
  required int repetitions,
}) {
  int newRepetitions;
  int newInterval;
  double newEaseFactor = easeFactor;

  if (rating < 2) {
    newRepetitions = 0;
    newInterval = 1;
  } else {
    newRepetitions = repetitions + 1;
    if (repetitions == 0) {
      newInterval = 1;
    } else if (repetitions == 1) {
      newInterval = 6;
    } else {
      newInterval = (interval * easeFactor).round();
    }
    newEaseFactor = easeFactor +
        (0.1 - (3 - rating) * 0.08 + (3 - rating) * 0.02);
    if (newEaseFactor < 1.3) newEaseFactor = 1.3;
  }

  return SM2Result(
    easeFactor: newEaseFactor,
    interval: newInterval,
    repetitions: newRepetitions,
    nextReviewAt: DateTime.now().add(Duration(days: newInterval)),
  );
}
