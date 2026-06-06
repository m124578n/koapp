// lib/data/database/app_database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';
import 'daos/deck_dao.dart';
import 'daos/card_dao.dart';
import 'daos/review_dao.dart';
import 'daos/stats_dao.dart';
import 'seed_data.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Decks,
    Cards,
    ReviewRecords,
    AchievementsTable,
    UserStatsTable,
    DailyReviewCounts,
  ],
  daos: [DeckDao, CardDao, ReviewDao, StatsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await seedBuiltInData(this);
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(decks, decks.language);
            // 現有內建牌組補 ko-KR
            await (update(decks)..where((t) => t.isBuiltIn.equals(true)))
                .write(const DecksCompanion(language: Value('ko-KR')));
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'kapp.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
