import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/meal_remote_datasource.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/meal_repository_impl.dart';
import '../../domain/repositories/meal_repository.dart';
import '../../domain/usecases/meal_usecases.dart';

// ── Infrastructure providers ────────────────────────────────────────────────

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(),
);

final mealRemoteDatasourceProvider = Provider<MealRemoteDatasource>(
  (ref) => MealRemoteDatasourceImpl(ref.watch(apiClientProvider)),
);

final mealRepositoryProvider = Provider<MealRepository>(
  (ref) => MealRepositoryImpl(ref.watch(mealRemoteDatasourceProvider)),
);

// ── Use-case providers ──────────────────────────────────────────────────────

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>(
  (ref) => GetCategoriesUseCase(ref.watch(mealRepositoryProvider)),
);

final getMealsByCategoryUseCaseProvider =
    Provider<GetMealsByCategoryUseCase>(
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

// ── Data providers ──────────────────────────────────────────────────────────

/// Loads all meal categories. Cached by Riverpod until the widget tree is disposed.
final categoriesProvider = FutureProvider<List<CategoryModel>>(
  (ref) => ref.watch(getCategoriesUseCaseProvider)(),
);

/// Loads meals for a specific category.
final mealsByCategoryProvider =
    FutureProvider.family<List<CategoryModel>, String>(
  (ref, category) async {
    final useCase = ref.watch(getMealsByCategoryUseCaseProvider);
    final results = await useCase(category);
    // MealModel has same shape — cast via toJson for consistency
    return results
        .map((m) => CategoryModel.fromJson({
              'idCategory': m.id,
              'strCategory': m.name,
              'strCategoryThumb': m.thumbnailUrl,
              'strCategoryDescription': '',
            }))
        .toList();
  },
);
