import '../../data/models/category_model.dart';
import '../../data/models/meal_detail_model.dart';
import '../../data/models/meal_model.dart';
import '../repositories/meal_repository.dart';

/// Returns the full list of meal categories.
final class GetCategoriesUseCase {
  final MealRepository _repository;
  const GetCategoriesUseCase(this._repository);
  Future<List<CategoryModel>> call() => _repository.getCategories();
}

/// Returns all meals belonging to a given [category] name.
final class GetMealsByCategoryUseCase {
  final MealRepository _repository;
  const GetMealsByCategoryUseCase(this._repository);
  Future<List<MealModel>> call(String category) =>
      _repository.getMealsByCategory(category);
}

/// Returns all meals from a given cuisine [area] (e.g. "Italian", "Chinese").
final class GetMealsByAreaUseCase {
  final MealRepository _repository;
  const GetMealsByAreaUseCase(this._repository);
  Future<List<MealModel>> call(String area) =>
      _repository.getMealsByArea(area);
}

/// Returns full details for a meal identified by [id].
final class GetMealDetailUseCase {
  final MealRepository _repository;
  const GetMealDetailUseCase(this._repository);
  Future<MealDetailModel> call(String id) => _repository.getMealDetail(id);
}

/// Searches meals by [query] string.
final class SearchMealsUseCase {
  final MealRepository _repository;
  const SearchMealsUseCase(this._repository);
  Future<List<MealModel>> call(String query) => _repository.searchMeals(query);
}

/// Returns a random meal (used for "Meal of the Day").
final class GetRandomMealUseCase {
  final MealRepository _repository;
  const GetRandomMealUseCase(this._repository);
  Future<MealDetailModel> call() => _repository.getRandomMeal();
}
