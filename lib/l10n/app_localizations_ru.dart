// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get refreshNowTooltip => 'Обновить';

  @override
  String get settingsTooltip => 'Настройки';

  @override
  String get noForecastData => 'Нет данных прогноза.';

  @override
  String get hourlyBreakdown => 'Почасовой прогноз';

  @override
  String get sevenDayOutlook => 'Прогноз на 7 дней';

  @override
  String get today => 'Сегодня';

  @override
  String get swellLabel => 'Зыбь';

  @override
  String get windLabel => 'Ветер';

  @override
  String windWavesSubvalue(String value) {
    return 'Ветровые волны $value';
  }

  @override
  String get airWaterTemp => 'Темп. воздуха / воды';

  @override
  String get uvIndexLabel => 'УФ-индекс';

  @override
  String cloudCoverSubvalue(String value) {
    return 'Облачность $value%';
  }

  @override
  String avgWaveMax(String avg, String max) {
    return 'Волна ср. $avg · макс. $max';
  }

  @override
  String bestWindow(String time, String label, String score) {
    return 'Лучшее время: $time · $label ($score)';
  }

  @override
  String get chooseCoast => 'Выбор побережья';

  @override
  String get searchHint => 'Поиск города или пляжа на побережье…';

  @override
  String get useMyLocation => 'Использовать моё местоположение';

  @override
  String get locationPermissionDenied => 'Доступ к геопозиции запрещён.';

  @override
  String get locationServicesOff => 'Службы геолокации выключены.';

  @override
  String get myLocationName => 'Моё местоположение';

  @override
  String couldntGetLocation(String error) {
    return 'Не удалось получить местоположение: $error';
  }

  @override
  String searchFailed(String error) {
    return 'Ошибка поиска: $error';
  }

  @override
  String get searchResults => 'Результаты поиска';

  @override
  String get savedCoasts => 'Сохранённые места';

  @override
  String get suggestedCoasts => 'Популярные места';

  @override
  String get couldntLoadConditions => 'Не удалось загрузить данные об условиях';

  @override
  String get retry => 'Повторить';

  @override
  String get fetchingConditions => 'Загружаем данные об условиях…';

  @override
  String waveHeightCaption(String period, String direction) {
    return 'Высота волны · зыбь с периодом $period с со стороны $direction';
  }

  @override
  String get waveHeightChartTitle => 'Высота волны';

  @override
  String get windSpeedChartTitle => 'Скорость ветра';

  @override
  String get waveShort => 'волна';

  @override
  String get sunrise => 'Восход';

  @override
  String get sunset => 'Закат';

  @override
  String litPercent(String percent) {
    return 'Освещено $percent%';
  }

  @override
  String tideWithTrend(String trend) {
    return 'Прилив · $trend';
  }

  @override
  String get tideCaption =>
      'Приблизительный тренд по модели уровня моря, не таблица приливов';

  @override
  String get unitsSection => 'Единицы измерения';

  @override
  String get metricUnits => 'Метрическая система';

  @override
  String get unitsMetricSubtitle => 'Метры, км/ч, °C';

  @override
  String get unitsImperialSubtitle => 'Футы, узлы, °F';

  @override
  String get refreshSection => 'Обновление';

  @override
  String get autoRefreshInterval => 'Интервал автообновления';

  @override
  String minutesShort(int minutes) {
    return '$minutes мин';
  }

  @override
  String hoursShort(int hours) {
    return '$hours ч';
  }

  @override
  String get widgetAutoRefresh => 'Автообновление виджета на рабочем столе';

  @override
  String get widgetAutoRefreshSubtitle =>
      'Используется интервал выше. Можно также обновить вручную — тапом по иконке обновления на виджете.';

  @override
  String get aboutDataSection => 'Об источниках данных';

  @override
  String get aboutDataIntro =>
      'ShoreCast использует бесплатные открытые данные о погоде и море:';

  @override
  String get aboutDataSources =>
      '• Open-Meteo Marine Weather API — высота волн, зыбь, ветровые волны, температура воды\n• Open-Meteo Weather API — температура воздуха, ветер, восход/закат, УФ-индекс, облачность\n• Open-Meteo Geocoding API — поиск локаций на побережье\n• Фаза луны рассчитывается локально по астрономической формуле (без запросов к API)';

  @override
  String get tideNoteTitle => 'О приливах';

  @override
  String get tideNoteBody =>
      'Сейчас нет бесплатного источника точных таблиц приливов, доступного без API-ключа, по всему миру. Показанный тренд прилива (растёт/падает) рассчитан по смешанному сигналу уровня моря Open-Meteo — это хороший качественный ориентир, но не точное время или высота прилива. Воспринимайте это как оценку.';

  @override
  String get languageSection => 'Язык';

  @override
  String get languageSystem => 'Системный';

  @override
  String get languageSystemSubtitle => 'Как в настройках телефона';
}
