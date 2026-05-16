import '../../../../core/network/network_exceptions.dart';
import '../../domain/repositories/meal_repository.dart';
import '../datasources/meal_remote_datasource.dart';
import '../models/category_model.dart';
import '../models/meal_detail_model.dart';
import '../models/meal_model.dart';

/// Concrete [MealRepository] that delegates to [MealRemoteDatasource].
/// Re-throws [NetworkException] so the UI layer can handle errors uniformly.
final class MealRepositoryImpl implements MealRepository {
  final MealRemoteDatasource _datasource;
  const MealRepositoryImpl(this._datasource);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      return await _datasource.getCategories();
    } on NetworkException {
      rethrow;
    }
  }

  @override
  Future<List<MealModel>> getMealsByCategory(String category) async {
    try {
      return await _datasource.getMealsByCategory(category);
    } on NetworkException {
      rethrow;
    }
  }

  @override
  Future<List<MealModel>> getMealsByArea(String area) async {
    try {
      return await _datasource.getMealsByArea(area);
    } on NetworkException {
      rethrow;
    }
  }

  @override
  Future<MealDetailModel> getMealDetail(String id) async {
    try {
      return await _datasource.getMealDetail(id);
    } on NetworkException {
      rethrow;
    }
  }

  @override
  Future<List<MealModel>> searchMeals(String query) async {
    try {
      return await _datasource.searchMeals(query);
    } on NetworkException {
      rethrow;
    }
  }

  @override
  Future<MealDetailModel> getRandomMeal() async {
    try {
      return await _datasource.getRandomMeal();
    } on NetworkException {
      rethrow;
    }
  }
}
