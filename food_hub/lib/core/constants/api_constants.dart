/// API base URLs and endpoint paths for TheMealDB.
abstract final class ApiConstants {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Categories
  static const String categories = '$baseUrl/categories.php';

  // Meals by category
  static const String filterByCategory = '$baseUrl/filter.php';

  // Meal details
  static const String mealDetails = '$baseUrl/lookup.php';

  // Search meals by name
  static const String searchMeal = '$baseUrl/search.php';

  // Random meal (Meal of the Day)
  static const String randomMeal = '$baseUrl/random.php';

  // Filter by area
  static const String filterByArea = '$baseUrl/filter.php';
}
