/// Application-wide constants.
abstract final class AppConstants {
  // SharedPreferences keys
  static const String themeKey = 'app_theme_mode';
  static const String languageKey = 'app_language_code';
  static const String mealOfDayKey = 'meal_of_day';
  static const String mealOfDayDateKey = 'meal_of_day_date';
  static const String recentlyViewedKey = 'recently_viewed_meals';

  // Limits
  static const int recentlyViewedLimit = 10;
  static const int gridCrossAxisCount = 2;
  static const double gridChildAspectRatio = 0.85;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Firestore collection names
  static const String usersCollection = 'users';
  static const String favoritesCollection = 'favorites';
  static const String customRecipesCollection = 'custom_recipes';

  // Firebase Storage paths
  static const String recipeImagesPath = 'recipe_images';

  // TheMealDB YouTube base
  static const String youtubeBase = 'https://www.youtube.com/watch?v=';
}
