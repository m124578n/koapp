// lib/presentation/providers/review_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/card.dart';
import '../../domain/entities/review_record.dart';
import '../../domain/usecases/calculate_sm2.dart';
import 'database_provider.dart';

final dueReviewsProvider = FutureProvider.autoDispose<List<ReviewRecord>>((ref) {
  return ref.watch(reviewRepositoryProvider).getDueRecords(DateTime.now());
});

class ReviewSession {
  final List<KoreanCard> cards;
  final int currentIndex;
  final bool isFlipped;
  final int sessionCorrect;

  const ReviewSession({
    required this.cards,
    required this.currentIndex,
    required this.isFlipped,
    required this.sessionCorrect,
  });

  bool get isComplete => currentIndex >= cards.length;
  KoreanCard? get currentCard =>
      isComplete ? null : cards[currentIndex];

  ReviewSession copyWith({
    int? currentIndex,
    bool? isFlipped,
    int? sessionCorrect,
  }) {
    return ReviewSession(
      cards: cards,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
      sessionCorrect: sessionCorrect ?? this.sessionCorrect,
    );
  }
}

class ReviewNotifier extends StateNotifier<AsyncValue<ReviewSession>> {
  final Ref _ref;
  final String deckId;

  ReviewNotifier(this._ref, this.deckId)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    final cards =
        await _ref.read(cardRepositoryProvider).getCardsByDeck(deckId);
    state = AsyncValue.data(ReviewSession(
      cards: cards,
      currentIndex: 0,
      isFlipped: false,
      sessionCorrect: 0,
    ));
  }

  void flip() {
    state.whenData((s) => state = AsyncValue.data(s.copyWith(isFlipped: true)));
  }

  Future<void> rateCard(int rating) async {
    final session = state.valueOrNull;
    if (session == null || session.isComplete) return;

    final card = session.currentCard!;
    final repo = _ref.read(reviewRepositoryProvider);
    final existing = await repo.getRecord(card.id);

    final result = calculateSM2(
      rating: rating,
      easeFactor: existing?.easeFactor ?? 2.5,
      interval: existing?.interval ?? 1,
      repetitions: existing?.repetitions ?? 0,
    );

    await repo.saveRecord(ReviewRecord(
      cardId: card.id,
      easeFactor: result.easeFactor,
      interval: result.interval,
      repetitions: result.repetitions,
      nextReviewAt: result.nextReviewAt,
      lastReviewedAt: DateTime.now(),
    ));

    final correct = rating >= 2 ? session.sessionCorrect + 1 : session.sessionCorrect;
    state = AsyncValue.data(session.copyWith(
      currentIndex: session.currentIndex + 1,
      isFlipped: false,
      sessionCorrect: correct,
    ));
  }

  Future<void> nextFlipCard() async {
    state.whenData((s) => state = AsyncValue.data(s.copyWith(
          currentIndex: s.currentIndex + 1,
          isFlipped: false,
          sessionCorrect: s.sessionCorrect + 1,
        )));
  }
}

final reviewNotifierProvider = StateNotifierProvider.autoDispose
    .family<ReviewNotifier, AsyncValue<ReviewSession>, String>(
  (ref, deckId) => ReviewNotifier(ref, deckId),
);
