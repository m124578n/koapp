// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '韓文單字卡';

  @override
  String get tabStudy => '學習';

  @override
  String get tabLibrary => '詞庫';

  @override
  String get tabProgress => '進度';

  @override
  String get tabSettings => '設定';

  @override
  String get selectDeck => '選擇牌組';

  @override
  String get selectMode => '選擇模式';

  @override
  String get modeFlip => '翻牌模式';

  @override
  String get modeFlipDesc => '自由翻牌，自己掌握學習節奏';

  @override
  String get modeSR => '間隔重複';

  @override
  String get modeSRDesc => '根據答題表現智慧安排複習時間';

  @override
  String get btnDontKnow => '不會';

  @override
  String get btnHard => '困難';

  @override
  String get btnGood => '良好';

  @override
  String get btnEasy => '簡單';

  @override
  String get flipToReveal => '點擊卡片查看答案';

  @override
  String get builtInDecks => '內建牌組';

  @override
  String get myDecks => '我的牌組';

  @override
  String get newDeck => '新增牌組';

  @override
  String get newCard => '新增卡片';

  @override
  String get editCard => '編輯卡片';

  @override
  String get korean => '韓文';

  @override
  String get romanization => '羅馬拼音';

  @override
  String get meaningZh => '中文意思';

  @override
  String get meaningEn => '英文意思';

  @override
  String get exampleSentence => '例句';

  @override
  String get exampleTranslation => '例句翻譯';

  @override
  String get save => '儲存';

  @override
  String get delete => '刪除';

  @override
  String get cancel => '取消';

  @override
  String get confirmDelete => '確認刪除？';

  @override
  String get streak => '連續學習天數';

  @override
  String get longestStreak => '最長紀錄';

  @override
  String get totalReviewed => '累計複習';

  @override
  String get accuracy => '正確率';

  @override
  String get achievements => '成就';

  @override
  String get dailyGoal => '每日目標';

  @override
  String get cards => '張';

  @override
  String get days => '天';

  @override
  String get language => '語言';

  @override
  String get about => '關於';

  @override
  String get sessionComplete => '本次完成！';

  @override
  String cardsReviewed(int count) {
    return '複習了 $count 張';
  }

  @override
  String achievementUnlocked(String title) {
    return '成就解鎖：$title';
  }

  @override
  String get achievementFirstTitle => '初心者';

  @override
  String get achievementFirstDesc => '完成第一次複習';

  @override
  String get achievementStreak7Title => '一週挑戰';

  @override
  String get achievementStreak7Desc => '連續學習 7 天';

  @override
  String get achievementTotal500Title => '單字王';

  @override
  String get achievementTotal500Desc => '累計複習 500 張卡片';

  @override
  String get achievementPerfectTitle => '完美主義者';

  @override
  String get achievementPerfectDesc => '單次複習答對率 100%';

  @override
  String get achievementDeckTitle => '詞庫創作者';

  @override
  String get achievementDeckDesc => '建立第一個自訂牌組';

  @override
  String get nextCard => '下一張';
}
