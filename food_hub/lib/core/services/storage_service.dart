import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Thin wrapper around [SharedPreferences] that provides typed accessors
/// for all app-wide persisted settings and cache values.
final class StorageService {
  final SharedPreferences _prefs;
  const StorageService(this._prefs);

  // ── Theme ────────────────────────────────────────────────────────────────

  /// Returns the stored [ThemeMode], defaults to system if never set.
  String get themeModeName =>
      _prefs.getString(AppConstants.themeKey) ?? 'system';

  Future<void> setThemeMode(String modeName) =>
      _prefs.setString(AppConstants.themeKey, modeName);

  // ── Language ─────────────────────────────────────────────────────────────

  /// Returns the stored BCP-47 language code, defaults to 'en'.
  String get languageCode =>
      _prefs.getString(AppConstants.languageKey) ?? 'en';

  Future<void> setLanguageCode(String code) =>
      _prefs.setString(AppConstants.languageKey, code);

  // ── Meal of the Day ──────────────────────────────────────────────────────

  String? get mealOfDayId => _prefs.getString(AppConstants.mealOfDayKey);
  String? get mealOfDayDate =>
      _prefs.getString(AppConstants.mealOfDayDateKey);

  Future<void> saveMealOfDay(String id, String date) async {
    await _prefs.setString(AppConstants.mealOfDayKey, id);
    await _prefs.setString(AppConstants.mealOfDayDateKey, date);
  }

  // ── Recently Viewed ───────────────────────────────────────────────────────

  List<String> get recentlyViewed =>
      _prefs.getStringList(AppConstants.recentlyViewedKey) ?? [];

  Future<void> addRecentlyViewed(String id) async {
    final list = List<String>.from(recentlyViewed);
    list
      ..remove(id)
      ..insert(0, id);
    if (list.length > AppConstants.recentlyViewedLimit) list.removeLast();
    await _prefs.setStringList(AppConstants.recentlyViewedKey, list);
  }
}
