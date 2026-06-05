// test/domain/usecases/calculate_sm2_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kapp/domain/usecases/calculate_sm2.dart';

void main() {
  group('calculateSM2', () {
    const baseEaseFactor = 2.5;

    test('rating < 2 resets repetitions to 0 and interval to 1', () {
      final result = calculateSM2(
        rating: 0,
        easeFactor: baseEaseFactor,
        interval: 10,
        repetitions: 5,
      );
      expect(result.repetitions, 0);
      expect(result.interval, 1);
      expect(result.easeFactor, baseEaseFactor);
    });

    test('first correct answer sets interval to 1', () {
      final result = calculateSM2(
        rating: 2,
        easeFactor: baseEaseFactor,
        interval: 1,
        repetitions: 0,
      );
      expect(result.repetitions, 1);
      expect(result.interval, 1);
    });

    test('second correct answer sets interval to 6', () {
      final result = calculateSM2(
        rating: 2,
        easeFactor: baseEaseFactor,
        interval: 1,
        repetitions: 1,
      );
      expect(result.repetitions, 2);
      expect(result.interval, 6);
    });

    test('subsequent interval = round(previous * easeFactor)', () {
      final result = calculateSM2(
        rating: 2,
        easeFactor: 2.5,
        interval: 6,
        repetitions: 2,
      );
      expect(result.interval, 15); // round(6 * 2.5)
    });

    test('easy rating increases easeFactor by 0.1', () {
      final result = calculateSM2(
        rating: 3,
        easeFactor: 2.5,
        interval: 1,
        repetitions: 0,
      );
      expect(result.easeFactor, closeTo(2.6, 0.001));
    });

    test('easeFactor never drops below 1.3', () {
      final result = calculateSM2(
        rating: 1,
        easeFactor: 1.3,
        interval: 6,
        repetitions: 2,
      );
      expect(result.easeFactor, greaterThanOrEqualTo(1.3));
    });

    test('nextReviewAt is in the future by interval days', () {
      final before = DateTime.now();
      final result = calculateSM2(
        rating: 2,
        easeFactor: 2.5,
        interval: 1,
        repetitions: 1,
      );
      final expectedDate = before.add(const Duration(days: 6));
      expect(result.nextReviewAt.day, expectedDate.day);
    });
  });
}
