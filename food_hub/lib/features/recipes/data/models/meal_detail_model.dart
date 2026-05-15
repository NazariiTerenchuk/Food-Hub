import 'package:equatable/equatable.dart';

/// Ingredient + measure pair.
class IngredientModel extends Equatable {
  final String name;
  final String measure;

  const IngredientModel({required this.name, required this.measure});

  @override
  List<Object?> get props => [name, measure];
}

/// Full meal details returned by `/lookup.php?i=...` endpoint.
///
/// TheMealDB stores ingredients as strIngredient1–20 / strMeasure1–20.
/// This model flattens them into a typed [ingredients] list.
class MealDetailModel extends Equatable {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnailUrl;
  final String? youtubeUrl;
  final String? sourceUrl;
  final List<IngredientModel> ingredients;
  final List<String> tags;

  const MealDetailModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnailUrl,
    this.youtubeUrl,
    this.sourceUrl,
    required this.ingredients,
    required this.tags,
  });

  factory MealDetailModel.fromJson(Map<String, dynamic> json) {
    // Parse strIngredient1..20 + strMeasure1..20
    final ingredients = <IngredientModel>[];
    for (int i = 1; i <= 20; i++) {
      final name = (json['strIngredient$i'] as String?)?.trim() ?? '';
      final measure = (json['strMeasure$i'] as String?)?.trim() ?? '';
      if (name.isNotEmpty) {
        ingredients.add(IngredientModel(name: name, measure: measure));
      }
    }

    // Parse comma-separated tags
    final rawTags = json['strTags'] as String?;
    final tags = rawTags != null && rawTags.isNotEmpty
        ? rawTags.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList()
        : <String>[];

    return MealDetailModel(
      id: json['idMeal'] as String? ?? '',
      name: json['strMeal'] as String? ?? '',
      category: json['strCategory'] as String? ?? '',
      area: json['strArea'] as String? ?? '',
      instructions: json['strInstructions'] as String? ?? '',
      thumbnailUrl: json['strMealThumb'] as String? ?? '',
      youtubeUrl: json['strYoutube'] as String?,
      sourceUrl: json['strSource'] as String?,
      ingredients: ingredients,
      tags: tags,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'idMeal': id,
      'strMeal': name,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strMealThumb': thumbnailUrl,
      'strYoutube': youtubeUrl,
      'strSource': sourceUrl,
      'strTags': tags.join(','),
    };
    for (int i = 0; i < ingredients.length; i++) {
      map['strIngredient${i + 1}'] = ingredients[i].name;
      map['strMeasure${i + 1}'] = ingredients[i].measure;
    }
    return map;
  }

  /// Returns a thumbnail URL at a specific size from TheMealDB CDN.
  /// Supported sizes: /preview (small), /medium (unused by API but works).
  String get previewUrl => '$thumbnailUrl/preview';

  @override
  List<Object?> get props => [id, name, category, area, thumbnailUrl];
}
