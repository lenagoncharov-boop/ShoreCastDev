import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'providers/settings_provider.dart';
import 'screens/home/home_screen.dart';

class ShoreCastApp extends ConsumerWidget {
  const ShoreCastApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = ref.watch(settingsProvider.select((s) => s.languageCode));

    return MaterialApp(
      title: 'ShoreCast',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // null = follow the system locale (falls back to English if the
      // phone's language isn't one of en/ru/he); otherwise pin the
      // language the user picked in Settings.
      locale: languageCode == 'system' ? null : Locale(languageCode),
      home: const HomeScreen(),
    );
  }
}
