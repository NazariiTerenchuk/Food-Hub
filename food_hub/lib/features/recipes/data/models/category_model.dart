import 'package:equatable/equatable.dart';

/// Model for a meal category from TheMealDB `/categories.php`.
class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String thumbnailUrl;
  final String description;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['idCategory'] as String? ?? '',
      name: json['strCategory'] as String? ?? '',
      thumbnailUrl: json['strCategoryThumb'] as String? ?? '',
      description: json['strCategoryDescription'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'idCategory': id,
        'strCategory': name,
        'strCategoryThumb': thumbnailUrl,
        'strCategoryDescription': description,
      };

  @override
  List<Object?> get props => [id, name, thumbnailUrl, description];
}
