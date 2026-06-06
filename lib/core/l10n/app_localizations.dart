import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'韓文單字卡'**
  String get appTitle;

  /// No description provided for @tabStudy.
  ///
  /// In zh, this message translates to:
  /// **'學習'**
  String get tabStudy;

  /// No description provided for @tabLibrary.
  ///
  /// In zh, this message translates to:
  /// **'詞庫'**
  String get tabLibrary;

  /// No description provided for @tabProgress.
  ///
  /// In zh, this message translates to:
  /// **'進度'**
  String get tabProgress;

  /// No description provided for @tabSettings.
  ///
  /// In zh, this message translates to:
  /// **'設定'**
  String get tabSettings;

  /// No description provided for @selectDeck.
  ///
  /// In zh, this message translates to:
  /// **'選擇牌組'**
  String get selectDeck;

  /// No description provided for @selectMode.
  ///
  /// In zh, this message translates to:
  /// **'選擇模式'**
  String get selectMode;

  /// No description provided for @modeFlip.
  ///
  /// In zh, this message translates to:
  /// **'翻牌模式'**
  String get modeFlip;

  /// No description provided for @modeFlipDesc.
  ///
  /// In zh, this message translates to:
  /// **'自由翻牌，自己掌握學習節奏'**
  String get modeFlipDesc;

  /// No description provided for @modeSR.
  ///
  /// In zh, this message translates to:
  /// **'間隔重複'**
  String get modeSR;

  /// No description provided for @modeSRDesc.
  ///
  /// In zh, this message translates to:
  /// **'根據答題表現智慧安排複習時間'**
  String get modeSRDesc;

  /// No description provided for @btnDontKnow.
  ///
  /// In zh, this message translates to:
  /// **'不會'**
  String get btnDontKnow;

  /// No description provided for @btnHard.
  ///
  /// In zh, this message translates to:
  /// **'困難'**
  String get btnHard;

  /// No description provided for @btnGood.
  ///
  /// In zh, this message translates to:
  /// **'良好'**
  String get btnGood;

  /// No description provided for @btnEasy.
  ///
  /// In zh, this message translates to:
  /// **'簡單'**
  String get btnEasy;

  /// No description provided for @flipToReveal.
  ///
  /// In zh, this message translates to:
  /// **'點擊卡片查看答案'**
  String get flipToReveal;

  /// No description provided for @builtInDecks.
  ///
  /// In zh, this message translates to:
  /// **'內建牌組'**
  String get builtInDecks;

  /// No description provided for @myDecks.
  ///
  /// In zh, this message translates to:
  /// **'我的牌組'**
  String get myDecks;

  /// No description provided for @newDeck.
  ///
  /// In zh, this message translates to:
  /// **'新增牌組'**
  String get newDeck;

  /// No description provided for @newCard.
  ///
  /// In zh, this message translates to:
  /// **'新增卡片'**
  String get newCard;

  /// No description provided for @editCard.
  ///
  /// In zh, this message translates to:
  /// **'編輯卡片'**
  String get editCard;

  /// No description provided for @korean.
  ///
  /// In zh, this message translates to:
  /// **'韓文'**
  String get korean;

  /// No description provided for @romanization.
  ///
  /// In zh, this message translates to:
  /// **'羅馬拼音'**
  String get romanization;

  /// No description provided for @meaningZh.
  ///
  /// In zh, this message translates to:
  /// **'中文意思'**
  String get meaningZh;

  /// No description provided for @meaningEn.
  ///
  /// In zh, this message translates to:
  /// **'英文意思'**
  String get meaningEn;

  /// No description provided for @exampleSentence.
  ///
  /// In zh, this message translates to:
  /// **'例句'**
  String get exampleSentence;

  /// No description provided for @exampleTranslation.
  ///
  /// In zh, this message translates to:
  /// **'例句翻譯'**
  String get exampleTranslation;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'儲存'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'刪除'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @confirmDelete.
  ///
  /// In zh, this message translates to:
  /// **'確認刪除？'**
  String get confirmDelete;

  /// No description provided for @streak.
  ///
  /// In zh, this message translates to:
  /// **'連續學習天數'**
  String get streak;

  /// No description provided for @longestStreak.
  ///
  /// In zh, this message translates to:
  /// **'最長紀錄'**
  String get longestStreak;

  /// No description provided for @totalReviewed.
  ///
  /// In zh, this message translates to:
  /// **'累計複習'**
  String get totalReviewed;

  /// No description provided for @accuracy.
  ///
  /// In zh, this message translates to:
  /// **'正確率'**
  String get accuracy;

  /// No description provided for @achievements.
  ///
  /// In zh, this message translates to:
  /// **'成就'**
  String get achievements;

  /// No description provided for @dailyGoal.
  ///
  /// In zh, this message translates to:
  /// **'每日目標'**
  String get dailyGoal;

  /// No description provided for @cards.
  ///
  /// In zh, this message translates to:
  /// **'張'**
  String get cards;

  /// No description provided for @days.
  ///
  /// In zh, this message translates to:
  /// **'天'**
  String get days;

  /// No description provided for @language.
  ///
  /// In zh, this message translates to:
  /// **'語言'**
  String get language;

  /// No description provided for @about.
  ///
  /// In zh, this message translates to:
  /// **'關於'**
  String get about;

  /// No description provided for @sessionComplete.
  ///
  /// In zh, this message translates to:
  /// **'本次完成！'**
  String get sessionComplete;

  /// No description provided for @cardsReviewed.
  ///
  /// In zh, this message translates to:
  /// **'複習了 {count} 張'**
  String cardsReviewed(int count);

  /// No description provided for @achievementUnlocked.
  ///
  /// In zh, this message translates to:
  /// **'成就解鎖：{title}'**
  String achievementUnlocked(String title);

  /// No description provided for @achievementFirstTitle.
  ///
  /// In zh, this message translates to:
  /// **'初心者'**
  String get achievementFirstTitle;

  /// No description provided for @achievementFirstDesc.
  ///
  /// In zh, this message translates to:
  /// **'完成第一次複習'**
  String get achievementFirstDesc;

  /// No description provided for @achievementStreak7Title.
  ///
  /// In zh, this message translates to:
  /// **'一週挑戰'**
  String get achievementStreak7Title;

  /// No description provided for @achievementStreak7Desc.
  ///
  /// In zh, this message translates to:
  /// **'連續學習 7 天'**
  String get achievementStreak7Desc;

  /// No description provided for @achievementTotal500Title.
  ///
  /// In zh, this message translates to:
  /// **'單字王'**
  String get achievementTotal500Title;

  /// No description provided for @achievementTotal500Desc.
  ///
  /// In zh, this message translates to:
  /// **'累計複習 500 張卡片'**
  String get achievementTotal500Desc;

  /// No description provided for @achievementPerfectTitle.
  ///
  /// In zh, this message translates to:
  /// **'完美主義者'**
  String get achievementPerfectTitle;

  /// No description provided for @achievementPerfectDesc.
  ///
  /// In zh, this message translates to:
  /// **'單次複習答對率 100%'**
  String get achievementPerfectDesc;

  /// No description provided for @achievementDeckTitle.
  ///
  /// In zh, this message translates to:
  /// **'詞庫創作者'**
  String get achievementDeckTitle;

  /// No description provided for @achievementDeckDesc.
  ///
  /// In zh, this message translates to:
  /// **'建立第一個自訂牌組'**
  String get achievementDeckDesc;

  /// No description provided for @nextCard.
  ///
  /// In zh, this message translates to:
  /// **'下一張'**
  String get nextCard;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
