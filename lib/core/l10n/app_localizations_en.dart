// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Korean Flashcards';

  @override
  String get tabStudy => 'Study';

  @override
  String get tabLibrary => 'Library';

  @override
  String get tabProgress => 'Progress';

  @override
  String get tabSettings => 'Settings';

  @override
  String get selectDeck => 'Select Deck';

  @override
  String get selectMode => 'Select Mode';

  @override
  String get modeFlip => 'Flip Mode';

  @override
  String get modeFlipDesc => 'Flip cards at your own pace';

  @override
  String get modeSR => 'Spaced Repetition';

  @override
  String get modeSRDesc => 'Smart scheduling based on your answers';

  @override
  String get btnDontKnow => 'Don\'t Know';

  @override
  String get btnHard => 'Hard';

  @override
  String get btnGood => 'Good';

  @override
  String get btnEasy => 'Easy';

  @override
  String get flipToReveal => 'Tap card to reveal answer';

  @override
  String get builtInDecks => 'Built-in Decks';

  @override
  String get myDecks => 'My Decks';

  @override
  String get newDeck => 'New Deck';

  @override
  String get newCard => 'New Card';

  @override
  String get editCard => 'Edit Card';

  @override
  String get word => 'Word';

  @override
  String get romanization => 'Romanization';

  @override
  String get meaningZh => 'Chinese Meaning';

  @override
  String get meaningEn => 'English Meaning';

  @override
  String get exampleSentence => 'Example Sentence';

  @override
  String get exampleTranslation => 'Translation';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmDelete => 'Confirm delete?';

  @override
  String get streak => 'Current Streak';

  @override
  String get longestStreak => 'Longest Streak';

  @override
  String get totalReviewed => 'Total Reviewed';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get achievements => 'Achievements';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String get cards => 'cards';

  @override
  String get days => 'days';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';

  @override
  String get sessionComplete => 'Session Complete!';

  @override
  String cardsReviewed(int count) {
    return 'Reviewed $count cards';
  }

  @override
  String achievementUnlocked(String title) {
    return 'Achievement Unlocked: $title';
  }

  @override
  String get achievementFirstTitle => 'Beginner';

  @override
  String get achievementFirstDesc => 'Complete your first review';

  @override
  String get achievementStreak7Title => '7-Day Streak';

  @override
  String get achievementStreak7Desc => 'Study 7 days in a row';

  @override
  String get achievementTotal500Title => 'Vocab King';

  @override
  String get achievementTotal500Desc => 'Review 500 cards total';

  @override
  String get achievementPerfectTitle => 'Perfectionist';

  @override
  String get achievementPerfectDesc => '100% accuracy in one session';

  @override
  String get achievementDeckTitle => 'Deck Creator';

  @override
  String get achievementDeckDesc => 'Create your first custom deck';

  @override
  String get nextCard => 'Next →';

  @override
  String get deckName => 'Deck Name';

  @override
  String get meaningRequired => 'Please enter at least one meaning';
}
