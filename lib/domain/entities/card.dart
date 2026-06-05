// lib/domain/entities/card.dart
class KoreanCard {
  final String id;
  final String deckId;
  final String korean;
  final String romanization;
  final String meaningZh;
  final String meaningEn;
  final String exampleSentence;
  final String exampleTranslation;
  final DateTime createdAt;

  const KoreanCard({
    required this.id,
    required this.deckId,
    required this.korean,
    required this.romanization,
    required this.meaningZh,
    required this.meaningEn,
    required this.exampleSentence,
    required this.exampleTranslation,
    required this.createdAt,
  });
}
