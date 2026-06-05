// lib/domain/entities/deck.dart
enum DeckLevel { beginner, intermediate, all }

class Deck {
  final String id;
  final String name;
  final String description;
  final DeckLevel level;
  final bool isBuiltIn;
  final DateTime createdAt;

  const Deck({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.isBuiltIn,
    required this.createdAt,
  });
}
