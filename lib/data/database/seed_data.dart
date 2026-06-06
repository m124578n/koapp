// lib/data/database/seed_data.dart
import 'package:drift/drift.dart';
import 'app_database.dart';

Future<void> seedBuiltInData(AppDatabase db) async {
  // Seed decks
  await db.into(db.decks).insertOnConflictUpdate(DecksCompanion(
    id: const Value('deck-beginner'),
    name: const Value('初級韓文 / Beginner Korean'),
    description: const Value('基礎詞彙、問候語、數字'),
    level: const Value('beginner'),
    isBuiltIn: const Value(true),
    language: const Value('ko-KR'),
    createdAt: Value(DateTime(2026)),
  ));
  await db.into(db.decks).insertOnConflictUpdate(DecksCompanion(
    id: const Value('deck-intermediate'),
    name: const Value('進階韓文 / Intermediate Korean'),
    description: const Value('常用句型、旅遊、購物'),
    level: const Value('intermediate'),
    isBuiltIn: const Value(true),
    language: const Value('ko-KR'),
    createdAt: Value(DateTime(2026)),
  ));

  // Seed beginner cards
  final beginnerCards = [
    _card('b01', 'deck-beginner', '안녕하세요', 'annyeonghaseyo', '你好', 'Hello',
        '안녕하세요, 만나서 반갑습니다.', '你好，很高興認識你。'),
    _card('b02', 'deck-beginner', '감사합니다', 'gamsahamnida', '謝謝', 'Thank you',
        '도와줘서 감사합니다.', '謝謝你的幫助。'),
    _card('b03', 'deck-beginner', '미안합니다', 'mianhamnida', '對不起', 'I\'m sorry',
        '늦어서 미안합니다.', '對不起，我遲到了。'),
    _card('b04', 'deck-beginner', '네', 'ne', '是', 'Yes', '네, 알겠습니다.', '是，我明白了。'),
    _card('b05', 'deck-beginner', '아니요', 'aniyo', '不', 'No', '아니요, 괜찮아요.',
        '不，沒關係。'),
    _card('b06', 'deck-beginner', '이름이 뭐예요?', 'iriumi mwoyeyo?', '你叫什麼名字？',
        'What\'s your name?', '이름이 뭐예요? 저는 민준이에요.', '你叫什麼名字？我叫民俊。'),
    _card('b07', 'deck-beginner', '하나', 'hana', '一', 'One', '사과 하나 주세요.', '請給我一個蘋果。'),
    _card('b08', 'deck-beginner', '둘', 'dul', '二', 'Two', '커피 두 잔 주세요.', '請給我兩杯咖啡。'),
    _card('b09', 'deck-beginner', '물', 'mul', '水', 'Water', '물 한 잔 주세요.', '請給我一杯水。'),
    _card('b10', 'deck-beginner', '밥', 'bap', '飯', 'Rice/Meal', '밥 먹었어요?', '你吃飯了嗎？'),
  ];

  // Seed intermediate cards
  final intermediateCards = [
    _card('i01', 'deck-intermediate', '얼마예요?', 'eolmayeyo?', '多少錢？',
        'How much is it?', '이거 얼마예요?', '這個多少錢？'),
    _card('i02', 'deck-intermediate', '어디예요?', 'eodiyeyo?', '在哪裡？',
        'Where is it?', '화장실이 어디예요?', '廁所在哪裡？'),
    _card('i03', 'deck-intermediate', '맛있어요', 'masisseoyo', '好吃', 'Delicious',
        '정말 맛있어요!', '真的很好吃！'),
    _card('i04', 'deck-intermediate', '주세요', 'juseyo', '請給我', 'Please give me',
        '메뉴 주세요.', '請給我菜單。'),
    _card('i05', 'deck-intermediate', '괜찮아요', 'gwaenchanayo', '沒關係', 'It\'s okay',
        '걱정하지 마세요, 괜찮아요.', '不要擔心，沒關係。'),
  ];

  for (final c in [...beginnerCards, ...intermediateCards]) {
    await db.into(db.cards).insertOnConflictUpdate(c);
  }

  // Seed achievements
  final achievements = [
    _achievement('ach-first', 'achievementFirstTitle', 'achievementFirstDesc',
        'star', 'first_review', 1),
    _achievement('ach-streak7', 'achievementStreak7Title',
        'achievementStreak7Desc', 'local_fire_department', 'streak_days', 7),
    _achievement('ach-total500', 'achievementTotal500Title',
        'achievementTotal500Desc', 'menu_book', 'total_reviewed', 500),
    _achievement('ach-perfect', 'achievementPerfectTitle',
        'achievementPerfectDesc', 'verified', 'perfect_session', 1),
    _achievement('ach-deck', 'achievementDeckTitle', 'achievementDeckDesc',
        'library_add', 'created_deck', 1),
  ];

  for (final a in achievements) {
    await db.into(db.achievementsTable).insertOnConflictUpdate(a);
  }

  // Seed initial user stats row
  await db.into(db.userStatsTable).insertOnConflictUpdate(
        UserStatsTableCompanion(
          id: const Value(1),
          currentStreak: const Value(0),
          longestStreak: const Value(0),
          totalCardsReviewed: const Value(0),
          totalCorrect: const Value(0),
        ),
      );
}

CardsCompanion _card(
  String id,
  String deckId,
  String korean,
  String romanization,
  String meaningZh,
  String meaningEn,
  String exampleSentence,
  String exampleTranslation,
) {
  return CardsCompanion(
    id: Value(id),
    deckId: Value(deckId),
    korean: Value(korean),
    romanization: Value(romanization),
    meaningZh: Value(meaningZh),
    meaningEn: Value(meaningEn),
    exampleSentence: Value(exampleSentence),
    exampleTranslation: Value(exampleTranslation),
    createdAt: Value(DateTime(2026)),
  );
}

AchievementsTableCompanion _achievement(
  String id,
  String titleKey,
  String descKey,
  String iconName,
  String condition,
  int threshold,
) {
  return AchievementsTableCompanion(
    id: Value(id),
    titleKey: Value(titleKey),
    descKey: Value(descKey),
    iconName: Value(iconName),
    condition: Value(condition),
    threshold: Value(threshold),
    unlocked: const Value(false),
  );
}
