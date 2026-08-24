// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get settingsTitle => 'הגדרות';

  @override
  String get refreshNowTooltip => 'רענן עכשיו';

  @override
  String get settingsTooltip => 'הגדרות';

  @override
  String get noForecastData => 'לא התקבל מידע תחזית.';

  @override
  String get hourlyBreakdown => 'פירוט שעתי';

  @override
  String get sevenDayOutlook => 'תחזית ל-7 ימים';

  @override
  String get today => 'היום';

  @override
  String get swellLabel => 'גלי גאות';

  @override
  String get windLabel => 'רוח';

  @override
  String windWavesSubvalue(String value) {
    return 'גלי רוח $value';
  }

  @override
  String get airWaterTemp => 'טמפ׳ אוויר / מים';

  @override
  String get uvIndexLabel => 'מדד UV';

  @override
  String cloudCoverSubvalue(String value) {
    return 'עננות $value%';
  }

  @override
  String avgWaveMax(String avg, String max) {
    return 'גל ממוצע $avg · מקסימום $max';
  }

  @override
  String bestWindow(String time, String label, String score) {
    return 'החלון הטוב ביותר: $time · $label ($score)';
  }

  @override
  String get chooseCoast => 'בחירת חוף';

  @override
  String get searchHint => 'חיפוש עיר או חוף…';

  @override
  String get useMyLocation => 'השתמש במיקום הנוכחי שלי';

  @override
  String get locationPermissionDenied => 'הגישה למיקום נדחתה.';

  @override
  String get locationServicesOff => 'שירותי המיקום כבויים.';

  @override
  String get myLocationName => 'המיקום שלי';

  @override
  String couldntGetLocation(String error) {
    return 'לא ניתן היה לקבל מיקום: $error';
  }

  @override
  String searchFailed(String error) {
    return 'החיפוש נכשל: $error';
  }

  @override
  String get searchResults => 'תוצאות חיפוש';

  @override
  String get savedCoasts => 'חופים שמורים';

  @override
  String get suggestedCoasts => 'חופים מומלצים';

  @override
  String get couldntLoadConditions => 'לא ניתן היה לטעון את תנאי הים';

  @override
  String get retry => 'נסה שוב';

  @override
  String get fetchingConditions => 'טוען תנאי ים…';

  @override
  String waveHeightCaption(String period, String direction) {
    return 'גובה גל · גלי גאות בתקופה של $period שנ׳ מכיוון $direction';
  }

  @override
  String get waveHeightChartTitle => 'גובה גל';

  @override
  String get windSpeedChartTitle => 'מהירות רוח';

  @override
  String get tideLevelChartTitle => 'גאות ושפל';

  @override
  String get waveShort => 'גל';

  @override
  String get sunrise => 'זריחה';

  @override
  String get sunset => 'שקיעה';

  @override
  String litPercent(String percent) {
    return '$percent% מואר';
  }

  @override
  String tideWithTrend(String trend) {
    return 'גאות ושפל · $trend';
  }

  @override
  String get tideCaption => 'מגמה משוערת ממודל מפלס הים, לא טבלת גאות ושפל';

  @override
  String get unitsSection => 'יחידות מידה';

  @override
  String get metricUnits => 'יחידות מטריות';

  @override
  String get unitsMetricSubtitle => 'מטרים, קמ״ש, °C';

  @override
  String get unitsImperialSubtitle => 'רגל, קשר, °F';

  @override
  String get refreshSection => 'רענון';

  @override
  String get autoRefreshInterval => 'מרווח רענון אוטומטי';

  @override
  String minutesShort(int minutes) {
    return '$minutes דק׳';
  }

  @override
  String hoursShort(int hours) {
    return '$hours שע׳';
  }

  @override
  String get widgetAutoRefresh => 'רענון אוטומטי של הווידג׳ט במסך הבית';

  @override
  String get widgetAutoRefreshSubtitle =>
      'משתמש במרווח שנבחר למעלה. אפשר גם ללחוץ בכל עת על סמל הרענון בווידג׳ט.';

  @override
  String get aboutDataSection => 'על מקורות המידע';

  @override
  String get aboutDataIntro =>
      'ShoreCast משתמש במקורות מידע פתוחים וחינמיים על מזג אוויר וים:';

  @override
  String get aboutDataSources =>
      '• Open-Meteo Marine Weather API — גובה גלים, גלי גאות, גלי רוח, טמפרטורת מים\n• Open-Meteo Weather API — טמפרטורת אוויר, רוח, זריחה/שקיעה, מדד UV, עננות\n• Open-Meteo Geocoding API — חיפוש מיקומים לאורך החוף\n• שלב הירח מחושב מקומית לפי נוסחה אסטרונומית (ללא קריאה לשרת)';

  @override
  String get tideNoteTitle => 'לגבי גאות ושפל';

  @override
  String get tideNoteBody =>
      'כרגע אין מקור מידע חינמי, ללא מפתח API, לטבלאות גאות ושפל מדויקות בעולם. מגמת הגאות המוצגת (עולה/יורדת) מחושבת מהאות המשולב של מפלס הים של Open-Meteo — אינדיקציה איכותית טובה, אך לא זמן או גובה מדויקים מטבלת גאות ושפל. יש להתייחס לכך כאל הערכה בלבד.';

  @override
  String get languageSection => 'שפה';

  @override
  String get languageSystem => 'לפי המערכת';

  @override
  String get languageSystemSubtitle => 'בהתאם לשפת הטלפון';
}
