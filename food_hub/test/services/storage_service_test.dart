import 'package:flutter_test/flutter_test.dart';
import 'package:food_hub/core/services/storage_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late StorageService storageService;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    storageService = StorageService(mockPrefs);
  });

  group('StorageService', () {
    test('themeModeName returns stored value or default', () {
      when(() => mockPrefs.getString('app_theme_mode')).thenReturn('dark');
      expect(storageService.themeModeName, 'dark');

      when(() => mockPrefs.getString('app_theme_mode')).thenReturn(null);
      expect(storageService.themeModeName, 'system');
    });

    test('setThemeMode saves to SharedPreferences', () async {
      when(() => mockPrefs.setString('app_theme_mode', 'light'))
          .thenAnswer((_) async => true);

      await storageService.setThemeMode('light');

      verify(() => mockPrefs.setString('app_theme_mode', 'light')).called(1);
    });

    test('languageCode returns stored value or default', () {
      when(() => mockPrefs.getString('app_language_code')).thenReturn('uk');
      expect(storageService.languageCode, 'uk');

      when(() => mockPrefs.getString('app_language_code')).thenReturn(null);
      expect(storageService.languageCode, 'en');
    });

    test('setLanguageCode saves to SharedPreferences', () async {
      when(() => mockPrefs.setString('app_language_code', 'pl'))
          .thenAnswer((_) async => true);

      await storageService.setLanguageCode('pl');

      verify(() => mockPrefs.setString('app_language_code', 'pl')).called(1);
    });
  });
}
