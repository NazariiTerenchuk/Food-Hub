import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/providers/app_providers.dart';
import '../../data/datasources/meal_remote_datasource.dart';
import '../../data/models/category_model.dart';
import '../../data/models/meal_detail_model.dart';
import '../../data/models/meal_model.dart';
import '../../data/repositories/meal_repository_impl.dart';
import '../../domain/repositories/meal_repository.dart';
import '../../domain/usecases/meal_usecases.dart';

// ── Infrastructure ────────────────────────────────────────────────────────────

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

final getMealsByAreaUseCaseProvider = Provider<GetMealsByAreaUseCase>(
  (ref) => GetMealsByAreaUseCase(ref.watch(mealRepositoryProvider)),
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

/// All meal categories.
final categoriesProvider = FutureProvider<List<CategoryModel>>(
  (ref) => ref.watch(getCategoriesUseCaseProvider)(),
);

/// Meals for a specific category name.
final mealsByCategoryProvider =
    FutureProvider.family<List<MealModel>, String>(
  (ref, category) =>
      ref.watch(getMealsByCategoryUseCaseProvider)(category),
);

/// Meals filtered by cuisine area (e.g. "Italian", "Chinese").
final mealsByAreaProvider = FutureProvider.family<List<MealModel>, String>(
  (ref, area) => ref.watch(getMealsByAreaUseCaseProvider)(area),
);

/// Full meal details by meal ID.
final mealDetailProvider =
    FutureProvider.family<MealDetailModel, String>(
  (ref, id) => ref.watch(getMealDetailUseCaseProvider)(id),
);

/// Meal of the Day — fetches a random meal and caches it for the calendar day.
/// Returns the cached meal if the stored date matches today's date.
final mealOfDayProvider = FutureProvider<MealDetailModel>((ref) async {
  final storage = ref.watch(storageServiceProvider);
  final today = DateTime.now().toIso8601String().substring(0, 10);

  final cachedId = storage.mealOfDayId;
  final cachedDate = storage.mealOfDayDate;

  // Return cached meal if it was fetched today
  if (cachedDate == today && cachedId != null) {
    return ref.watch(getMealDetailUseCaseProvider)(cachedId);
  }

  // Fetch a fresh random meal and cache its ID
  final meal = await ref.watch(getRandomMealUseCaseProvider)();
  await storage.saveMealOfDay(meal.id, today);
  return meal;
});
