import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/custom_recipe_model.dart';

/// Handles uploading photos to Firebase Storage and saving recipes to Firestore.
final class AddRecipeRepository {
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;
  const AddRecipeRepository(this._db, this._storage);

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('custom_recipes');

  /// Uploads [photo] to Storage (if provided) then saves [recipe] to Firestore.
  Future<CustomRecipeModel> saveRecipe({
    required String uid,
    required String name,
    required String description,
    required List<String> ingredients,
    required List<String> steps,
    File? photo,
  }) async {
    final id = const Uuid().v4();
    String? photoUrl;

    if (photo != null) {
      final ref = _storage.ref('recipe_images/$uid/$id.jpg');
      final task = await ref.putFile(photo);
      photoUrl = await task.ref.getDownloadURL();
    }

    final recipe = CustomRecipeModel(
      id: id,
      name: name,
      description: description,
      ingredients: ingredients,
      steps: steps,
      photoUrl: photoUrl,
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
}
