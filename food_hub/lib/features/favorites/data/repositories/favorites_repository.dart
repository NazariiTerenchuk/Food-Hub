import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_meal_model.dart';

/// Firestore favorites CRUD: users/{uid}/favorites/{mealId}
final class FavoritesRepository {
  final FirebaseFirestore _db;
  const FavoritesRepository(this._db);

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('favorites');

  /// Stream of all favorites for [uid], ordered newest first.
  Stream<List<FavoriteMealModel>> watchFavorites(String uid) =>
      _col(uid).orderBy('addedAt', descending: true).snapshots().map(
            (snap) => snap.docs
                .map((d) => FavoriteMealModel.fromFirestore(d.data()))
                .toList(),
          );

  Future<bool> isFavorite(String uid, String mealId) async {
    final doc = await _col(uid).doc(mealId).get();
    return doc.exists;
  }

  Future<void> addFavorite(String uid, FavoriteMealModel meal) =>
      _col(uid).doc(meal.mealId).set(meal.toFirestore());

  Future<void> removeFavorite(String uid, String mealId) =>
      _col(uid).doc(mealId).delete();
}
