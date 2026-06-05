// lib/presentation/providers/review_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/review_record.dart';
import 'database_provider.dart';

final dueReviewsProvider = FutureProvider<List<ReviewRecord>>((ref) {
  return ref.watch(reviewRepositoryProvider).getDueRecords(DateTime.now());
});
