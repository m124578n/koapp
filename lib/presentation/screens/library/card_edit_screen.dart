import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../domain/entities/card.dart';
import '../../providers/deck_provider.dart';
import '../../providers/database_provider.dart';

class CardEditScreen extends ConsumerStatefulWidget {
  final String deckId;
  final KoreanCard? existing;

  const CardEditScreen({super.key, required this.deckId, this.existing});

  @override
  ConsumerState<CardEditScreen> createState() => _CardEditScreenState();
}

class _CardEditScreenState extends ConsumerState<CardEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _koreanCtrl = TextEditingController(text: widget.existing?.korean);
  late final _romanCtrl =
      TextEditingController(text: widget.existing?.romanization);
  late final _zhCtrl =
      TextEditingController(text: widget.existing?.meaningZh);
  late final _enCtrl =
      TextEditingController(text: widget.existing?.meaningEn);
  late final _exCtrl =
      TextEditingController(text: widget.existing?.exampleSentence);
  late final _transCtrl =
      TextEditingController(text: widget.existing?.exampleTranslation);

  @override
  void dispose() {
    for (final c in [
      _koreanCtrl,
      _romanCtrl,
      _zhCtrl,
      _enCtrl,
      _exCtrl,
      _transCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? l.editCard : l.newCard)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_koreanCtrl, l.korean, required: true),
            _field(_romanCtrl, l.romanization, required: true),
            _field(_zhCtrl, l.meaningZh),
            _field(_enCtrl, l.meaningEn),
            _field(_exCtrl, l.exampleSentence),
            _field(_transCtrl, l.exampleTranslation),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              child: Text(l.save),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label,
      {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: required
            ? (v) => (v == null || v.isEmpty) ? 'Required' : null
            : null,
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_zhCtrl.text.trim().isEmpty && _enCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least one meaning')),
      );
      return;
    }

    final repo = ref.read(cardRepositoryProvider);
    final card = KoreanCard(
      id: widget.existing?.id ?? const Uuid().v4(),
      deckId: widget.deckId,
      korean: _koreanCtrl.text.trim(),
      romanization: _romanCtrl.text.trim(),
      meaningZh: _zhCtrl.text.trim(),
      meaningEn: _enCtrl.text.trim(),
      exampleSentence: _exCtrl.text.trim(),
      exampleTranslation: _transCtrl.text.trim(),
      createdAt: widget.existing?.createdAt ?? DateTime.now(),
    );

    if (widget.existing == null) {
      await repo.createCard(card);
    } else {
      await repo.updateCard(card);
    }

    ref.invalidate(cardsForDeckProvider(widget.deckId));
    if (mounted) Navigator.pop(context);
  }
}
