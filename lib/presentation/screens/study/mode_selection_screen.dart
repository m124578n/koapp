// lib/presentation/screens/study/mode_selection_screen.dart
import 'package:flutter/material.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../domain/entities/deck.dart';
import 'review_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  final Deck deck;
  const ModeSelectionScreen({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.selectMode)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ModeCard(
              icon: Icons.flip,
              title: l.modeFlip,
              description: l.modeFlipDesc,
              onTap: () => _startReview(context, ReviewMode.flip),
            ),
            const SizedBox(height: 16),
            _ModeCard(
              icon: Icons.auto_awesome,
              title: l.modeSR,
              description: l.modeSRDesc,
              onTap: () => _startReview(context, ReviewMode.spacedRepetition),
            ),
          ],
        ),
      ),
    );
  }

  void _startReview(BuildContext context, ReviewMode mode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewScreen(deck: deck, mode: mode),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
