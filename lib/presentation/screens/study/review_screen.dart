// lib/presentation/screens/study/review_screen.dart
// Stub — replaced in Task 12
import 'package:flutter/material.dart';
import '../../../domain/entities/deck.dart';

enum ReviewMode { flip, spacedRepetition }

class ReviewScreen extends StatelessWidget {
  final Deck deck;
  final ReviewMode mode;
  const ReviewScreen({super.key, required this.deck, required this.mode});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: Text('Review')),
  );
}
