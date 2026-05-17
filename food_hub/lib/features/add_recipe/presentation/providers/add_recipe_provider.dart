import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/add_recipe_repository.dart';

final addRecipeRepositoryProvider = Provider<AddRecipeRepository>(
  (ref) => AddRecipeRepository(FirebaseFirestore.instance),
);

/// State for the add-recipe form.
final class AddRecipeState {
  final bool loading;
  final String? error;
  final bool success;
  const AddRecipeState(
      {this.loading = false, this.error, this.success = false});
}

class AddRecipeNotifier extends AutoDisposeNotifier<AddRecipeState> {
  @override
  AddRecipeState build() => const AddRecipeState();

  Future<void> submit({
    required String name,
    required String description,
    required List<String> ingredients,
    required List<String> steps,
    File? photo,
  }) async {
    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null) {
      state = const AddRecipeState(error: 'You must be signed in.');
      return;
    }
    state = const AddRecipeState(loading: true);
    try {
      String? photoBase64;
      if (photo != null) {
        final bytes = await photo.readAsBytes();
        photoBase64 = base64Encode(bytes);
      }

      await ref.read(addRecipeRepositoryProvider).saveRecipe(
            uid: uid,
            name: name,
            description: description,
            ingredients: ingredients,
            steps: steps,
            photoBase64: photoBase64,
          );
      state = const AddRecipeState(success: true);
    } catch (e) {
      state = AddRecipeState(error: e.toString());
    }
  }
}

final addRecipeProvider =
    AutoDisposeNotifierProvider<AddRecipeNotifier, AddRecipeState>(
  AddRecipeNotifier.new,
);
