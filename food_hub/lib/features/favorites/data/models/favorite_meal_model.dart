import 'package:cloud_firestore/cloud_firestore.dart';

/// Lightweight model stored in Firestore under users/{uid}/favorites/{mealId}.
final class FavoriteMealModel {
  final String mealId;
  final String name;
  final String thumbnailUrl;
  final String category;
  final DateTime addedAt;

  const FavoriteMealModel({
    required this.mealId,
    required this.name,
    required this.thumbnailUrl,
    required this.category,
    required this.addedAt,
  });

  Map<String, dynamic> toFirestore() => {
        'mealId': mealId,
        'name': name,
        'thumbnailUrl': thumbnailUrl,
        'category': category,
        'addedAt': Timestamp.fromDate(addedAt),
      };

  factory FavoriteMealModel.fromFirestore(Map<String, dynamic> data) =>
      FavoriteMealModel(
        mealId: data['mealId'] as String,
        name: data['name'] as String,
        thumbnailUrl: data['thumbnailUrl'] as String,
        category: data['category'] as String? ?? '',
        addedAt: (data['addedAt'] as Timestamp).toDate(),
      );
}
