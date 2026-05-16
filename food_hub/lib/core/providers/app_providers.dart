import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

// ── Storage ───────────────────────────────────────────────────────────────────

/// Override this provider in [ProviderScope] with a real [StorageService]
/// after SharedPreferences is initialized in main().
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError(
    'storageServiceProvider must be overridden in ProviderScope',
  );
});

// ── Theme ─────────────────────────────────────────────────────────────────────

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final name = ref.watch(storageServiceProvider).themeModeName;
    return ThemeMode.values.firstWhere(
      (m) => m.name == name,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setMode(ThemeMode mode) async {
    await ref.read(storageServiceProvider).setThemeMode(mode.name);
    state = mode;
  }

  void toggle() => setMode(
        state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
      );
}

final themeProvider =
    NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

// ── Language ──────────────────────────────────────────────────────────────────

/// Supported locales for the app: English, Ukrainian, Polish.
const List<Locale> appSupportedLocales = [
  Locale('en'),
  Locale('uk'),
  Locale('pl'),
];

class LanguageNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final code = ref.watch(storageServiceProvider).languageCode;
    return Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    await ref
        .read(storageServiceProvider)
        .setLanguageCode(locale.languageCode);
    state = locale;
  }
}

final languageProvider =
    NotifierProvider<LanguageNotifier, Locale>(LanguageNotifier.new);
