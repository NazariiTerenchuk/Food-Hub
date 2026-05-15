import 'package:equatable/equatable.dart';

/// Lightweight meal summary returned by
/// `/filter.php?c=...` and `/search.php?s=...` endpoints.
class MealModel extends Equatable {
  final String id;
  final String name;
  final String thumbnailUrl;
  /// Present only in search results, null in filter results.
  final String? category;
  final String? area;

  const MealModel({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    this.category,
    this.area,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['idMeal'] as String? ?? '',
      name: json['strMeal'] as String? ?? '',
      thumbnailUrl: json['strMealThumb'] as String? ?? '',
      category: json['strCategory'] as String?,
      area: json['strArea'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'idMeal': id,
        'strMeal': name,
        'strMealThumb': thumbnailUrl,
        if (category != null) 'strCategory': category,
        if (area != null) 'strArea': area,
      };

  @override
  List<Object?> get props => [id, name, thumbnailUrl, category, area];
}
