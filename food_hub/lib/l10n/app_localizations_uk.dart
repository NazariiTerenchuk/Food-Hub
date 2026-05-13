// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'FoodHub';

  @override
  String get navHome => 'Головна';

  @override
  String get navFavorites => 'Вибране';

  @override
  String get navAdd => 'Додати';

  @override
  String get navProfile => 'Профіль';

  @override
  String get loginTitle => 'З поверненням!';

  @override
  String get loginSubtitle => 'Увійдіть, щоб відкрити нові рецепти';

  @override
  String get registerTitle => 'Створити акаунт';

  @override
  String get email => 'Електронна пошта';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Підтвердити пароль';

  @override
  String get login => 'Увійти';

  @override
  String get register => 'Зареєструватися';

  @override
  String get forgotPassword => 'Забули пароль?';

  @override
  String get noAccount => 'Немає акаунту? ';

  @override
  String get hasAccount => 'Вже є акаунт? ';

  @override
  String get homeGreeting => 'Що приготуємо сьогодні?';

  @override
  String get categories => 'Категорії';

  @override
  String get mealOfDay => 'Рецепт дня';

  @override
  String get search => 'Шукати рецепти...';

  @override
  String get favorites => 'Вибране';

  @override
  String get noFavorites => 'Поки що немає вибраного';

  @override
  String get noFavoritesSubtitle =>
      'Починайте досліджувати та зберігайте рецепти, які вам подобаються!';

  @override
  String get addRecipe => 'Додати рецепт';

  @override
  String get recipeName => 'Назва рецепту';

  @override
  String get recipeDescription => 'Опис';

  @override
  String get ingredients => 'Інгредієнти';

  @override
  String get instructions => 'Приготування';

  @override
  String get uploadPhoto => 'Завантажити фото';

  @override
  String get camera => 'Камера';

  @override
  String get gallery => 'Галерея';

  @override
  String get save => 'Зберегти';

  @override
  String get cancel => 'Скасувати';

  @override
  String get profile => 'Профіль';

  @override
  String get settings => 'Налаштування';

  @override
  String get theme => 'Тема';

  @override
  String get language => 'Мова';

  @override
  String get logout => 'Вийти';

  @override
  String get errorGeneral => 'Щось пішло не так. Спробуйте ще раз.';

  @override
  String get errorNetwork => 'Немає підключення до мережі. Перевірте інтернет.';

  @override
  String get loading => 'Завантаження...';

  @override
  String get retry => 'Повторити';

  @override
  String get watchOnYoutube => 'Дивитися на YouTube';

  @override
  String get addedToFavorites => 'Додано до вибраного';

  @override
  String get removedFromFavorites => 'Видалено з вибраного';
}
