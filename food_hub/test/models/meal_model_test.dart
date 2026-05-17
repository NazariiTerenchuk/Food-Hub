import 'package:flutter_test/flutter_test.dart';
import 'package:food_hub/features/recipes/data/models/meal_model.dart';

void main() {
  group('MealModel', () {
    test('fromJson parses standard meal', () {
      final json = {
        'strMeal': 'Baked salmon',
        'strMealThumb': 'https://www.themealdb.com/images/media/meals/1548772327.jpg',
        'idMeal': '52959',
      };

      final meal = MealModel.fromJson(json);

      expect(meal.name, 'Baked salmon');
      expect(meal.id, '52959');
      expect(meal.thumbnailUrl, 'https://www.themealdb.com/images/media/meals/1548772327.jpg');
      expect(meal.area, isNull);
      expect(meal.category, isNull);
    });

    test('toJson returns correct map', () {
      const meal = MealModel(
        id: '123',
        name: 'Test Meal',
        thumbnailUrl: 'url',
        category: 'Seafood',
        area: 'British',
      );

      final json = meal.toJson();

      expect(json['idMeal'], '123');
      expect(json['strMeal'], 'Test Meal');
      expect(json['strMealThumb'], 'url');
      expect(json['strCategory'], 'Seafood');
      expect(json['strArea'], 'British');
    });
  });
}
