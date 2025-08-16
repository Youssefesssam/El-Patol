import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginScreen.
  ///
  /// In en, this message translates to:
  /// **'Login Screen'**
  String get loginScreen;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @task.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get task;

  /// No description provided for @event.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get event;

  /// No description provided for @absent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get absent;

  /// No description provided for @word.
  ///
  /// In en, this message translates to:
  /// **'Word'**
  String get word;

  /// No description provided for @talent.
  ///
  /// In en, this message translates to:
  /// **'Talent'**
  String get talent;

  /// No description provided for @opinion.
  ///
  /// In en, this message translates to:
  /// **'Opinion'**
  String get opinion;

  /// No description provided for @ideas.
  ///
  /// In en, this message translates to:
  /// **'Ideas'**
  String get ideas;

  /// No description provided for @sweet.
  ///
  /// In en, this message translates to:
  /// **'Sweet'**
  String get sweet;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get waiting;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'reset'**
  String get reset;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @usersCode.
  ///
  /// In en, this message translates to:
  /// **'Users Code'**
  String get usersCode;

  /// No description provided for @addUser.
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get addUser;

  /// No description provided for @helpandsupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpandsupport;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @selectWeek.
  ///
  /// In en, this message translates to:
  /// **'Select Week'**
  String get selectWeek;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @confirmSelection.
  ///
  /// In en, this message translates to:
  /// **'Confirm Selection'**
  String get confirmSelection;

  /// No description provided for @nextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next Week'**
  String get nextWeek;

  /// No description provided for @currentWeek.
  ///
  /// In en, this message translates to:
  /// **'Current Week'**
  String get currentWeek;

  /// No description provided for @youSelectedWeek.
  ///
  /// In en, this message translates to:
  /// **'You Selected Week'**
  String get youSelectedWeek;

  /// No description provided for @perfectChoice.
  ///
  /// In en, this message translates to:
  /// **'Perfect Choice!'**
  String get perfectChoice;

  /// No description provided for @cancle.
  ///
  /// In en, this message translates to:
  /// **'Cancle'**
  String get cancle;

  /// No description provided for @votingOnOpinion.
  ///
  /// In en, this message translates to:
  /// **'VOTING ON OPINION'**
  String get votingOnOpinion;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @noOpinion.
  ///
  /// In en, this message translates to:
  /// **'No Opinion'**
  String get noOpinion;

  /// No description provided for @timesUp.
  ///
  /// In en, this message translates to:
  /// **'Time\'s Up!'**
  String get timesUp;

  /// No description provided for @votes.
  ///
  /// In en, this message translates to:
  /// **'Votes'**
  String get votes;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @noImageUploaded.
  ///
  /// In en, this message translates to:
  /// **'No Image Uploaded'**
  String get noImageUploaded;

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type Your Message'**
  String get typeYourMessage;

  /// No description provided for @writeYourOpinion.
  ///
  /// In en, this message translates to:
  /// **'Write Your Opinion'**
  String get writeYourOpinion;

  /// No description provided for @typeYourOpinionHere.
  ///
  /// In en, this message translates to:
  /// **'Type Your Opinion Here'**
  String get typeYourOpinionHere;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @latestWord.
  ///
  /// In en, this message translates to:
  /// **'Latest Word'**
  String get latestWord;

  /// No description provided for @typeYourWordSayNextWeekHere.
  ///
  /// In en, this message translates to:
  /// **'Type your word say next week here...'**
  String get typeYourWordSayNextWeekHere;

  /// No description provided for @writethetask.
  ///
  /// In en, this message translates to:
  /// **'Write the task'**
  String get writethetask;

  /// No description provided for @answers.
  ///
  /// In en, this message translates to:
  /// **'Answers'**
  String get answers;

  /// No description provided for @noanswersyet.
  ///
  /// In en, this message translates to:
  /// **'No answers yet'**
  String get noanswersyet;

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get basicInfo;

  /// No description provided for @moreDetails.
  ///
  /// In en, this message translates to:
  /// **'More Details'**
  String get moreDetails;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @passwordmustcontain.
  ///
  /// In en, this message translates to:
  /// **'Password must contain:'**
  String get passwordmustcontain;

  /// No description provided for @atleastonenumber.
  ///
  /// In en, this message translates to:
  /// **'• At least one number (0-9)'**
  String get atleastonenumber;

  /// No description provided for @atleastoneletter.
  ///
  /// In en, this message translates to:
  /// **'• At least one letter (a-z)'**
  String get atleastoneletter;

  /// No description provided for @atleast8characters.
  ///
  /// In en, this message translates to:
  /// **'• At least 8 characters'**
  String get atleast8characters;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @additionalDetails.
  ///
  /// In en, this message translates to:
  /// **'Additional Details'**
  String get additionalDetails;

  /// No description provided for @selectTalent.
  ///
  /// In en, this message translates to:
  /// **'Select Talent'**
  String get selectTalent;

  /// No description provided for @university.
  ///
  /// In en, this message translates to:
  /// **'University/school'**
  String get university;

  /// No description provided for @birthDay.
  ///
  /// In en, this message translates to:
  /// **'Birth Day'**
  String get birthDay;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @uploadProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Upload Profile Picture'**
  String get uploadProfilePicture;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'general..!'**
  String get general;

  /// No description provided for @competition.
  ///
  /// In en, this message translates to:
  /// **'compitition..!'**
  String get competition;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @addPicture.
  ///
  /// In en, this message translates to:
  /// **'add Picture'**
  String get addPicture;

  /// No description provided for @endVotes.
  ///
  /// In en, this message translates to:
  /// **'Voting for this week has ended ✅'**
  String get endVotes;

  /// No description provided for @wordOfWeek.
  ///
  /// In en, this message translates to:
  /// **'The Word of the Week'**
  String get wordOfWeek;

  /// No description provided for @noTask.
  ///
  /// In en, this message translates to:
  /// **'No Tasks available'**
  String get noTask;

  /// No description provided for @typeAnswer.
  ///
  /// In en, this message translates to:
  /// **'Type your Answer here...'**
  String get typeAnswer;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @didIGo.
  ///
  /// In en, this message translates to:
  /// **'Did I Go ?!'**
  String get didIGo;

  /// No description provided for @lang.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get lang;

  /// No description provided for @chooseLang.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLang;

  /// No description provided for @sureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout ?'**
  String get sureLogout;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
