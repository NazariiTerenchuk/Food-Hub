import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/app_providers.dart';
import 'core/router/app_router.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences before the widget tree is built
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ProviderScope(
      // Override the storage provider so all notifiers have access to it
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const FoodHubApp(),
    ),
  );
}

/// Root application widget.
/// Watches [themeProvider] and [languageProvider] so the whole app rebuilds
/// when the user changes the theme or language in settings.
class FoodHubApp extends ConsumerWidget {
  const FoodHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(languageProvider);

    return MaterialApp.router(
      title: 'FoodHub',
      debugShowCheckedModeBanner: false,

      // MD3 Themes
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // Localizations
      locale: locale,
      supportedLocales: appSupportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // GoRouter
      routerConfig: appRouter,
    );
  }
}
