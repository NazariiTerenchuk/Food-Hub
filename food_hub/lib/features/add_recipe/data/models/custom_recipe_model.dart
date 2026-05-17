import 'package:cloud_firestore/cloud_firestore.dart';

/// Custom recipe created by the user and stored in Firestore.
final class CustomRecipeModel {
  final String id;
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final String? photoBase64;
  final String authorId;
  final DateTime createdAt;

  const CustomRecipeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.steps,
    this.photoBase64,
    required this.authorId,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'name': name,
        'description': description,
        'ingredients': ingredients,
        'steps': steps,
        'photoBase64': photoBase64,
        'authorId': authorId,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory CustomRecipeModel.fromFirestore(Map<String, dynamic> data) =>
      CustomRecipeModel(
        id: data['id'] as String,
        name: data['name'] as String,
        description: data['description'] as String? ?? '',
        ingredients: List<String>.from(data['ingredients'] as List),
        steps: List<String>.from(data['steps'] as List),
        photoBase64: data['photoBase64'] as String?,
        authorId: data['authorId'] as String,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
}
