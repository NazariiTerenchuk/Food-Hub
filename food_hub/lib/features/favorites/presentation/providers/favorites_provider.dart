import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/favorite_meal_model.dart';
import '../../data/repositories/favorites_repository.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(FirebaseFirestore.instance),
);

/// Stream of all favorites for the current user.
final favoritesProvider = StreamProvider<List<FavoriteMealModel>>((ref) {
  final uid = ref.watch(currentUserProvider)?.uid;
  if (uid == null) return const Stream.empty();
  return ref.watch(favoritesRepositoryProvider).watchFavorites(uid);
});

/// Returns true if [mealId] is in the current user's favorites.
final isFavoriteProvider =
    FutureProvider.family<bool, String>((ref, mealId) async {
  final uid = ref.watch(currentUserProvider)?.uid;
  if (uid == null) return false;
  return ref.watch(favoritesRepositoryProvider).isFavorite(uid, mealId);
});
