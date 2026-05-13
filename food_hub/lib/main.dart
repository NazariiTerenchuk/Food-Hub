import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait orientation by default
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    // ProviderScope is required by Riverpod — wraps the entire widget tree
    const ProviderScope(
      child: FoodHubApp(),
    ),
  );
}

/// Root application widget.
class FoodHubApp extends ConsumerWidget {
  const FoodHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(theme): Watch themeProvider in Commit 13 for dynamic switching
    return MaterialApp.router(
      title: 'FoodHub',
      debugShowCheckedModeBanner: false,

      // MD3 Themes
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      // GoRouter
      routerConfig: appRouter,
    );
  }
}
