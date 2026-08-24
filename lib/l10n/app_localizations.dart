import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_he.dart';
import 'app_localizations_ru.dart';

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
    Locale('he'),
    Locale('ru')
  ];

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @refreshNowTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh now'**
  String get refreshNowTooltip;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @noForecastData.
  ///
  /// In en, this message translates to:
  /// **'No forecast data returned.'**
  String get noForecastData;

  /// No description provided for @hourlyBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Hourly breakdown'**
  String get hourlyBreakdown;

  /// No description provided for @sevenDayOutlook.
  ///
  /// In en, this message translates to:
  /// **'7-day outlook'**
  String get sevenDayOutlook;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @swellLabel.
  ///
  /// In en, this message translates to:
  /// **'Swell'**
  String get swellLabel;

  /// No description provided for @windLabel.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get windLabel;

  /// No description provided for @windWavesSubvalue.
  ///
  /// In en, this message translates to:
  /// **'Wind waves {value}'**
  String windWavesSubvalue(String value);

  /// No description provided for @airWaterTemp.
  ///
  /// In en, this message translates to:
  /// **'Air / Water temp'**
  String get airWaterTemp;

  /// No description provided for @uvIndexLabel.
  ///
  /// In en, this message translates to:
  /// **'UV index'**
  String get uvIndexLabel;

  /// No description provided for @cloudCoverSubvalue.
  ///
  /// In en, this message translates to:
  /// **'Cloud cover {value}%'**
  String cloudCoverSubvalue(String value);

  /// No description provided for @avgWaveMax.
  ///
  /// In en, this message translates to:
  /// **'Avg wave {avg} · max {max}'**
  String avgWaveMax(String avg, String max);

  /// No description provided for @bestWindow.
  ///
  /// In en, this message translates to:
  /// **'Best window: {time} · {label} ({score})'**
  String bestWindow(String time, String label, String score);

  /// No description provided for @chooseCoast.
  ///
  /// In en, this message translates to:
  /// **'Choose a coast'**
  String get chooseCoast;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search a coastal town or beach…'**
  String get searchHint;

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get useMyLocation;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied.'**
  String get locationPermissionDenied;

  /// No description provided for @locationServicesOff.
  ///
  /// In en, this message translates to:
  /// **'Location services are off.'**
  String get locationServicesOff;

  /// No description provided for @myLocationName.
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get myLocationName;

  /// No description provided for @couldntGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get location: {error}'**
  String couldntGetLocation(String error);

  /// No description provided for @searchFailed.
  ///
  /// In en, this message translates to:
  /// **'Search failed: {error}'**
  String searchFailed(String error);

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search results'**
  String get searchResults;

  /// No description provided for @savedCoasts.
  ///
  /// In en, this message translates to:
  /// **'Saved coasts'**
  String get savedCoasts;

  /// No description provided for @suggestedCoasts.
  ///
  /// In en, this message translates to:
  /// **'Suggested coasts'**
  String get suggestedCoasts;

  /// No description provided for @couldntLoadConditions.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load sea conditions'**
  String get couldntLoadConditions;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @fetchingConditions.
  ///
  /// In en, this message translates to:
  /// **'Fetching sea conditions…'**
  String get fetchingConditions;

  /// No description provided for @waveHeightCaption.
  ///
  /// In en, this message translates to:
  /// **'Wave height · {period}s period swell from the {direction}'**
  String waveHeightCaption(String period, String direction);

  /// No description provided for @waveHeightChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Wave height'**
  String get waveHeightChartTitle;

  /// No description provided for @windSpeedChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Wind speed'**
  String get windSpeedChartTitle;

  /// No description provided for @tideLevelChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Tide'**
  String get tideLevelChartTitle;

  /// No description provided for @waveShort.
  ///
  /// In en, this message translates to:
  /// **'wave'**
  String get waveShort;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @sunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunset;

  /// No description provided for @litPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% lit'**
  String litPercent(String percent);

  /// No description provided for @tideWithTrend.
  ///
  /// In en, this message translates to:
  /// **'Tide · {trend}'**
  String tideWithTrend(String trend);

  /// No description provided for @tideCaption.
  ///
  /// In en, this message translates to:
  /// **'Approx. trend from sea-level model, not a tide-table prediction'**
  String get tideCaption;

  /// No description provided for @unitsSection.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get unitsSection;

  /// No description provided for @metricUnits.
  ///
  /// In en, this message translates to:
  /// **'Metric units'**
  String get metricUnits;

  /// No description provided for @unitsMetricSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Meters, km/h, °C'**
  String get unitsMetricSubtitle;

  /// No description provided for @unitsImperialSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Feet, knots, °F'**
  String get unitsImperialSubtitle;

  /// No description provided for @refreshSection.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshSection;

  /// No description provided for @autoRefreshInterval.
  ///
  /// In en, this message translates to:
  /// **'Auto-refresh interval'**
  String get autoRefreshInterval;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @hoursShort.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String hoursShort(int hours);

  /// No description provided for @widgetAutoRefresh.
  ///
  /// In en, this message translates to:
  /// **'Auto-refresh home-screen widget'**
  String get widgetAutoRefresh;

  /// No description provided for @widgetAutoRefreshSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Uses the interval above. You can always tap the widget\'s refresh icon manually.'**
  String get widgetAutoRefreshSubtitle;

  /// No description provided for @aboutDataSection.
  ///
  /// In en, this message translates to:
  /// **'About the data'**
  String get aboutDataSection;

  /// No description provided for @aboutDataIntro.
  ///
  /// In en, this message translates to:
  /// **'ShoreCast uses free, open weather and marine data:'**
  String get aboutDataIntro;

  /// No description provided for @aboutDataSources.
  ///
  /// In en, this message translates to:
  /// **'• Open-Meteo Marine Weather API — wave height, swell, wind waves, sea temperature\n• Open-Meteo Weather API — air temperature, wind, sunrise/sunset, UV, cloud cover\n• Open-Meteo Geocoding API — coastal location search\n• Moon phase is computed locally from an astronomical formula (no API call)'**
  String get aboutDataSources;

  /// No description provided for @tideNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Tide note'**
  String get tideNoteTitle;

  /// No description provided for @tideNoteBody.
  ///
  /// In en, this message translates to:
  /// **'There is currently no free, key-less, worldwide source of real harmonic tide predictions. The tide trend shown (rising/falling) is derived from Open-Meteo\'s blended sea-level signal, which is a good qualitative guide but not a precise tide-table time or height — treat it as an estimate.'**
  String get tideNoteBody;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSection;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageSystemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follows your phone\'s language'**
  String get languageSystemSubtitle;
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
      <String>['en', 'he', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'he':
      return AppLocalizationsHe();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
