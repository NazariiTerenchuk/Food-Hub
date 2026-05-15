import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/meal_remote_datasource.dart';
import '../../data/models/category_model.dart';
import '../../data/models/meal_detail_model.dart';
import '../../data/models/meal_model.dart';
import '../../data/repositories/meal_repository_impl.dart';
import '../../domain/repositories/meal_repository.dart';
import '../../domain/usecases/meal_usecases.dart';

// ── Infrastructure ───────────────────────────────────────────────────────────

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final mealRemoteDatasourceProvider = Provider<MealRemoteDatasource>(
  (ref) => MealRemoteDatasourceImpl(ref.watch(apiClientProvider)),
);

final mealRepositoryProvider = Provider<MealRepository>(
  (ref) => MealRepositoryImpl(ref.watch(mealRemoteDatasourceProvider)),
);

// ── Use-case providers ────────────────────────────────────────────────────────

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>(
  (ref) => GetCategoriesUseCase(ref.watch(mealRepositoryProvider)),
);

final getMealsByCategoryUseCaseProvider = Provider<GetMealsByCategoryUseCase>(
  (ref) => GetMealsByCategoryUseCase(ref.watch(mealRepositoryProvider)),
);

final getMealDetailUseCaseProvider = Provider<GetMealDetailUseCase>(
  (ref) => GetMealDetailUseCase(ref.watch(mealRepositoryProvider)),
);

final searchMealsUseCaseProvider = Provider<SearchMealsUseCase>(
  (ref) => SearchMealsUseCase(ref.watch(mealRepositoryProvider)),
);

final getRandomMealUseCaseProvider = Provider<GetRandomMealUseCase>(
  (ref) => GetRandomMealUseCase(ref.watch(mealRepositoryProvider)),
);

// ── Data providers ────────────────────────────────────────────────────────────

final categoriesProvider = FutureProvider<List<CategoryModel>>(
  (ref) => ref.watch(getCategoriesUseCaseProvider)(),
);

/// Meals for a specific category name.
final mealsByCategoryProvider =
    FutureProvider.family<List<MealModel>, String>(
  (ref, category) =>
      ref.watch(getMealsByCategoryUseCaseProvider)(category),
);

/// Full meal details by ID.
final mealDetailProvider =
    FutureProvider.family<MealDetailModel, String>(
  (ref, id) => ref.watch(getMealDetailUseCaseProvider)(id),
);

/// Random meal — used for "Meal of the Day".
final mealOfDayProvider = FutureProvider<MealDetailModel>(
  (ref) => ref.watch(getRandomMealUseCaseProvider)(),
);
