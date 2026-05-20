import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/custom_recipe_model.dart';

/// Saves recipes directly to Firestore.
/// Uses Base64 strings for images instead of Firebase Storage to avoid billing requirements.
final class AddRecipeRepository {
  final FirebaseFirestore _db;
  const AddRecipeRepository(this._db);

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('custom_recipes');

  /// Saves [recipe] to Firestore. Photo is expected to be a Base64 string.
  Future<CustomRecipeModel> saveRecipe({
    required String uid,
    required String name,
    required String description,
    required List<String> ingredients,
    required List<String> steps,
    String? photoBase64,
  }) async {
    final id = const Uuid().v4();

    final recipe = CustomRecipeModel(
      id: id,
      name: name,
      description: description,
      ingredients: ingredients,
      steps: steps,
      photoBase64: photoBase64,
      authorId: uid,
      createdAt: DateTime.now(),
    );

    await _col(uid).doc(id).set(recipe.toFirestore());
    return recipe;
  }

  Stream<List<CustomRecipeModel>> watchMyRecipes(String uid) =>
      _col(uid).orderBy('createdAt', descending: true).snapshots().map(
            (snap) => snap.docs
                .map((d) => CustomRecipeModel.fromFirestore(d.data()))
                .toList(),
          );

  Future<void> deleteRecipe(String uid, String id) =>
      _col(uid).doc(id).delete();

  /// Updates an existing recipe in Firestore.
  Future<void> updateRecipe({
    required String uid,
    required String id,
    required String name,
    required String description,
    required List<String> ingredients,
    required List<String> steps,
    String? photoBase64,
  }) =>
      _col(uid).doc(id).update({
        'name': name,
        'description': description,
        'ingredients': ingredients,
        'steps': steps,
        if (photoBase64 != null) 'photoBase64': photoBase64,
      });
}
