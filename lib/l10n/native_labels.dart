import '../core/utils/moon_phase.dart';
import '../core/utils/wave_rating.dart';
import '../models/sea_condition_point.dart';

/// Translations for the small set of "domain" labels (fishing rating,
/// tide trend, moon phase, weather condition) that are shown both inside
/// normal widgets (which have a BuildContext, so could use the generated
/// AppLocalizations) AND pushed to the native Android home-screen widget
/// from a headless background isolate in widget_service.dart, which has
/// no BuildContext at all.
///
/// To keep exactly one source of truth for these labels instead of two
/// parallel translation systems, every call site — UI or background —
/// goes through these plain functions with an explicit language code
/// ('en' | 'ru' | 'he'). In UI code that language code is
/// `Localizations.localeOf(context).languageCode`, which already
/// reflects the resolved locale whether the user picked one explicitly
/// or left it on "System".
///
/// Static screen chrome (titles, buttons, section headers, hints) is
/// NOT handled here — that goes through the standard generated
/// AppLocalizations (see lib/l10n/app_*.arb), since it always has a
/// BuildContext available.
const _fallbackLang = 'en';

String _pick(String lang, Map<String, String> table) =>
    table[lang] ?? table[_fallbackLang]!;

String ratingLabel(String lang, RatingLevel level) {
  switch (level) {
    case RatingLevel.excellent:
      return _pick(lang, {'en': 'Excellent', 'ru': 'Отлично', 'he': 'מצוין'});
    case RatingLevel.good:
      return _pick(lang, {'en': 'Good', 'ru': 'Хорошо', 'he': 'טוב'});
    case RatingLevel.fair:
      return _pick(lang, {'en': 'Fair', 'ru': 'Средне', 'he': 'בינוני'});
    case RatingLevel.poor:
      return _pick(lang, {'en': 'Poor', 'ru': 'Плохо', 'he': 'גרוע'});
  }
}

String tideTrendLabel(String lang, TideTrend trend) {
  switch (trend) {
    case TideTrend.rising:
      return _pick(lang, {'en': 'Rising', 'ru': 'Растёт', 'he': 'עולה'});
    case TideTrend.falling:
      return _pick(lang, {'en': 'Falling', 'ru': 'Падает', 'he': 'יורד'});
    case TideTrend.slack:
      return _pick(lang, {'en': 'Slack', 'ru': 'Без изменений', 'he': 'יציב'});
  }
}

String moonPhaseLabel(String lang, MoonPhaseName phase) {
  switch (phase) {
    case MoonPhaseName.newMoon:
      return _pick(lang, {'en': 'New Moon', 'ru': 'Новолуние', 'he': 'ירח חדש'});
    case MoonPhaseName.waxingCrescent:
      return _pick(lang, {'en': 'Waxing Crescent', 'ru': 'Растущий серп', 'he': 'סהר גדל'});
    case MoonPhaseName.firstQuarter:
      return _pick(lang, {'en': 'First Quarter', 'ru': 'Первая четверть', 'he': 'רבע ראשון'});
    case MoonPhaseName.waxingGibbous:
      return _pick(lang, {'en': 'Waxing Gibbous', 'ru': 'Растущая луна', 'he': 'ירח גדל'});
    case MoonPhaseName.fullMoon:
      return _pick(lang, {'en': 'Full Moon', 'ru': 'Полнолуние', 'he': 'ירח מלא'});
    case MoonPhaseName.waningGibbous:
      return _pick(lang, {'en': 'Waning Gibbous', 'ru': 'Убывающая луна', 'he': 'ירח דועך'});
    case MoonPhaseName.lastQuarter:
      return _pick(lang, {'en': 'Last Quarter', 'ru': 'Последняя четверть', 'he': 'רבע אחרון'});
    case MoonPhaseName.waningCrescent:
      return _pick(lang, {'en': 'Waning Crescent', 'ru': 'Убывающий серп', 'he': 'סהר דועך'});
  }
}

/// Mirrors the WMO code buckets in core/utils/weather_code.dart — keep
/// the two switches in sync if weather codes are ever added/changed.
String weatherLabel(String lang, int code) {
  switch (code) {
    case 0:
      return _pick(lang, {'en': 'Clear', 'ru': 'Ясно', 'he': 'בהיר'});
    case 1:
    case 2:
      return _pick(lang, {'en': 'Partly cloudy', 'ru': 'Переменная облачность', 'he': 'מעונן חלקית'});
    case 3:
      return _pick(lang, {'en': 'Overcast', 'ru': 'Пасмурно', 'he': 'מעונן'});
    case 45:
    case 48:
      return _pick(lang, {'en': 'Fog', 'ru': 'Туман', 'he': 'ערפל'});
    case 51:
    case 53:
    case 55:
      return _pick(lang, {'en': 'Drizzle', 'ru': 'Морось', 'he': 'טפטוף'});
    case 56:
    case 57:
      return _pick(lang, {'en': 'Freezing drizzle', 'ru': 'Ледяная морось', 'he': 'טפטוף קופא'});
    case 61:
    case 63:
    case 65:
      return _pick(lang, {'en': 'Rain', 'ru': 'Дождь', 'he': 'גשם'});
    case 66:
    case 67:
      return _pick(lang, {'en': 'Freezing rain', 'ru': 'Ледяной дождь', 'he': 'גשם קופא'});
    case 71:
    case 73:
    case 75:
    case 77:
      return _pick(lang, {'en': 'Snow', 'ru': 'Снег', 'he': 'שלג'});
    case 80:
    case 81:
    case 82:
      return _pick(lang, {'en': 'Rain showers', 'ru': 'Ливень', 'he': 'ממטרים'});
    case 85:
    case 86:
      return _pick(lang, {'en': 'Snow showers', 'ru': 'Снежные ливни', 'he': 'ממטרי שלג'});
    case 95:
      return _pick(lang, {'en': 'Thunderstorm', 'ru': 'Гроза', 'he': 'סופת רעמים'});
    case 96:
    case 99:
      return _pick(lang, {'en': 'Thunderstorm + hail', 'ru': 'Гроза с градом', 'he': 'סופת רעמים עם ברד'});
    default:
      return _pick(lang, {'en': 'Unknown', 'ru': 'Неизвестно', 'he': 'לא ידוע'});
  }
}

/// Small fixed vocabulary used only inside the strings pushed to the
/// native widget (widget_service.dart), which has no BuildContext.
String widgetUpdatedPrefix(String lang) =>
    _pick(lang, {'en': 'Updated', 'ru': 'Обновлено', 'he': 'עודכן'});

String widgetPeriodSwellSuffix(String lang) =>
    _pick(lang, {'en': 'period swell', 'ru': 'период зыби', 'he': 'תקופת גלים'});

String widgetGustsLabel(String lang) =>
    _pick(lang, {'en': 'gusts', 'ru': 'порывы', 'he': 'משבים'});

String widgetAirTemperatureLabel(String lang) =>
    _pick(lang, {'en': 'Air temperature', 'ru': 'Температура воздуха', 'he': 'טמפרטורת אוויר'});

String widgetWaterTemperatureLabel(String lang) =>
    _pick(lang, {'en': 'Water temperature', 'ru': 'Температура воды', 'he': 'טמפרטורת מים'});

String widgetSeaLevelTrendEstimateLabel(String lang) => _pick(lang, {
      'en': 'Sea-level trend (estimate)',
      'ru': 'Тренд уровня моря (оценка)',
      'he': 'מגמת מפלס הים (הערכה)',
    });
