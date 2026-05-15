/// API base URL and endpoint paths for TheMealDB.
/// All paths are relative to [baseUrl] and used by [ApiClient].
abstract final class ApiConstants {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Endpoint paths
  static const String categories = '/categories.php';
  static const String filter = '/filter.php';
  static const String lookup = '/lookup.php';
  static const String search = '/search.php';
  static const String random = '/random.php';

  // Query parameter names
  static const String categoryParam = 'c';
  static const String idParam = 'i';
  static const String searchParam = 's';
  static const String areaParam = 'a';
}
