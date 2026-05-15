import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_exceptions.dart';
import '../models/category_model.dart';
import '../models/meal_detail_model.dart';
import '../models/meal_model.dart';

/// Contract for all remote TheMealDB data operations.
abstract interface class MealRemoteDatasource {
  Future<List<CategoryModel>> getCategories();
  Future<List<MealModel>> getMealsByCategory(String category);
  Future<MealDetailModel> getMealDetail(String id);
  Future<List<MealModel>> searchMeals(String query);
  Future<MealDetailModel> getRandomMeal();
}

/// Implementation that fetches data from TheMealDB via [ApiClient].
final class MealRemoteDatasourceImpl implements MealRemoteDatasource {
  final ApiClient _client;
  const MealRemoteDatasourceImpl(this._client);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final data = await _client.get(ApiConstants.categories);
    final list = data['categories'] as List? ?? [];
    return list
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MealModel>> getMealsByCategory(String category) async {
    final data = await _client.get(
      ApiConstants.filter,
      queryParameters: {ApiConstants.categoryParam: category},
    );
    final list = data['meals'] as List? ?? [];
    return list
        .map((e) => MealModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MealDetailModel> getMealDetail(String id) async {
    final data = await _client.get(
      ApiConstants.lookup,
      queryParameters: {ApiConstants.idParam: id},
    );
    final meals = data['meals'] as List?;
    if (meals == null || meals.isEmpty) throw const UnknownException();
    return MealDetailModel.fromJson(meals.first as Map<String, dynamic>);
  }

  @override
  Future<List<MealModel>> searchMeals(String query) async {
    final data = await _client.get(
      ApiConstants.search,
      queryParameters: {ApiConstants.searchParam: query},
    );
    final list = data['meals'] as List? ?? [];
    return list
        .map((e) => MealModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MealDetailModel> getRandomMeal() async {
    final data = await _client.get(ApiConstants.random);
    final meals = data['meals'] as List?;
    if (meals == null || meals.isEmpty) throw const UnknownException();
    return MealDetailModel.fromJson(meals.first as Map<String, dynamic>);
  }
}
