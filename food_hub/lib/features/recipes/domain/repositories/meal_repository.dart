import '../../data/models/category_model.dart';
import '../../data/models/meal_detail_model.dart';
import '../../data/models/meal_model.dart';

/// Domain-layer contract for recipe data.
/// Implementations live in the data layer.
abstract interface class MealRepository {
  Future<List<CategoryModel>> getCategories();
  Future<List<MealModel>> getMealsByCategory(String category);
  Future<MealDetailModel> getMealDetail(String id);
  Future<List<MealModel>> searchMeals(String query);
  Future<MealDetailModel> getRandomMeal();
}
