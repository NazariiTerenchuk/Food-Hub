import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_uk.dart';

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
    Locale('pl'),
    Locale('uk')
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'FoodHub'**
  String get appTitle;

  /// Bottom nav: Home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom nav: Favorites
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// Bottom nav: Add recipe
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get navAdd;

  /// Bottom nav: Profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Login screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get loginTitle;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to discover amazing recipes'**
  String get loginSubtitle;

  /// Register screen title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Login button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login;

  /// Register button
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get register;

  /// Forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No account text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// Has account text
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get hasAccount;

  /// Home screen greeting
  ///
  /// In en, this message translates to:
  /// **'What would you like to cook today?'**
  String get homeGreeting;

  /// Categories section title
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Meal of the day section title
  ///
  /// In en, this message translates to:
  /// **'Meal of the Day'**
  String get mealOfDay;

  /// Search bar placeholder
  ///
  /// In en, this message translates to:
  /// **'Search recipes...'**
  String get search;

  /// Favorites page title
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Empty favorites message
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavorites;

  /// Empty favorites subtitle
  ///
  /// In en, this message translates to:
  /// **'Start exploring and save recipes you love!'**
  String get noFavoritesSubtitle;

  /// Add recipe page title
  ///
  /// In en, this message translates to:
  /// **'Add Recipe'**
  String get addRecipe;

  /// Recipe name field
  ///
  /// In en, this message translates to:
  /// **'Recipe Name'**
  String get recipeName;

  /// Recipe description field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get recipeDescription;

  /// Ingredients label
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// Instructions label
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// Upload photo button
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// Camera option
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Gallery option
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Profile page title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Settings section
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Theme setting
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Logout button
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get logout;

  /// General error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneral;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network.'**
  String get errorNetwork;

  /// Loading state text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// YouTube link button
  ///
  /// In en, this message translates to:
  /// **'Watch on YouTube'**
  String get watchOnYoutube;

  /// Snackbar: added to favorites
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// Snackbar: removed from favorites
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;
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
      <String>['en', 'pl', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
