// lib/presentation/screens/study/review_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../domain/entities/deck.dart';
import '../../providers/review_provider.dart';
import '../../providers/locale_provider.dart';

enum ReviewMode { flip, spacedRepetition }

class ReviewScreen extends ConsumerWidget {
  final Deck deck;
  final ReviewMode mode;

  const ReviewScreen({super.key, required this.deck, required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final sessionAsync = ref.watch(reviewNotifierProvider(deck.id));
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(deck.name)),
      body: sessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (session) {
          if (session.isComplete) {
            return _SessionComplete(
              total: session.cards.length,
              correct: session.sessionCorrect,
              deckId: deck.id,
            );
          }

          final card = session.currentCard!;
          final meaning = locale.languageCode == 'zh'
              ? card.meaningZh
              : card.meaningEn;

          return Column(
            children: [
              LinearProgressIndicator(
                value: session.currentIndex / session.cards.length,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: session.isFlipped
                      ? null
                      : () => ref
                          .read(reviewNotifierProvider(deck.id).notifier)
                          .flip(),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: session.isFlipped
                        ? _CardBack(
                            key: const ValueKey('back'),
                            korean: card.korean,
                            romanization: card.romanization,
                            meaning: meaning,
                            example: card.exampleSentence,
                            translation: card.exampleTranslation,
                          )
                        : _CardFront(
                            key: const ValueKey('front'),
                            korean: card.korean,
                            hint: l.flipToReveal,
                          ),
                  ),
                ),
              ),
              if (session.isFlipped)
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: _RatingButtons(mode: mode, deckId: deck.id),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _CardFront extends StatelessWidget {
  final String korean;
  final String hint;
  const _CardFront({super.key, required this.korean, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(korean,
                    style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 24),
                Text(hint,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  final String korean;
  final String romanization;
  final String meaning;
  final String example;
  final String translation;

  const _CardBack({
    super.key,
    required this.korean,
    required this.romanization,
    required this.meaning,
    required this.example,
    required this.translation,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(korean,
                    style: Theme.of(context).textTheme.displaySmall),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(romanization,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.blueGrey)),
              ),
              const Divider(height: 32),
              Text(meaning,
                  style: Theme.of(context).textTheme.headlineSmall),
              if (example.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(example,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontStyle: FontStyle.italic)),
                const SizedBox(height: 4),
                Text(translation,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingButtons extends ConsumerWidget {
  final ReviewMode mode;
  final String deckId;

  const _RatingButtons({required this.mode, required this.deckId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;

    if (mode == ReviewMode.flip) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => ref.read(reviewNotifierProvider(deckId).notifier).nextFlipCard(),
            child: Text(l.nextCard),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _ratingBtn(context, ref, l.btnDontKnow, 0, Colors.red),
          _ratingBtn(context, ref, l.btnHard, 1, Colors.orange),
          _ratingBtn(context, ref, l.btnGood, 2, Colors.blue),
          _ratingBtn(context, ref, l.btnEasy, 3, Colors.green),
        ],
      ),
    );
  }

  Widget _ratingBtn(
    BuildContext context,
    WidgetRef ref,
    String label,
    int rating,
    Color color,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: color),
          onPressed: () => ref.read(reviewNotifierProvider(deckId).notifier).rateCard(rating),
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}

class _SessionComplete extends ConsumerStatefulWidget {
  final int total;
  final int correct;
  final String deckId;

  const _SessionComplete({
    required this.total,
    required this.correct,
    required this.deckId,
  });

  @override
  ConsumerState<_SessionComplete> createState() => _SessionCompleteState();
}

class _SessionCompleteState extends ConsumerState<_SessionComplete> {
  bool _finalized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_finalized || !mounted) return;
      _finalized = true;
      ref
          .read(reviewNotifierProvider(widget.deckId).notifier)
          .finalizeSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final accuracy =
        widget.total > 0 ? (widget.correct / widget.total * 100).round() : 0;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
          const SizedBox(height: 16),
          Text(l.sessionComplete,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(l.cardsReviewed(widget.total)),
          Text('$accuracy% ${l.accuracy}'),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.tabStudy),
          ),
        ],
      ),
    );
  }
}
