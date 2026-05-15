import 'package:flutter_test/flutter_test.dart';
import 'package:food_hub/features/recipes/data/models/meal_model.dart';

void main() {
  group('MealModel', () {
    const tJson = {
      'idMeal': '52772',
      'strMeal': 'Teriyaki Chicken Casserole',
      'strMealThumb': 'https://example.com/teriyaki.jpg',
    };

    const tJsonFull = {
      'idMeal': '52772',
      'strMeal': 'Teriyaki Chicken Casserole',
      'strMealThumb': 'https://example.com/teriyaki.jpg',
      'strCategory': 'Chicken',
      'strArea': 'Japanese',
    };

    test('fromJson creates correct MealModel (filter response)', () {
      final model = MealModel.fromJson(tJson);

      expect(model.id, '52772');
      expect(model.name, 'Teriyaki Chicken Casserole');
      expect(model.thumbnailUrl, 'https://example.com/teriyaki.jpg');
      expect(model.category, isNull);
      expect(model.area, isNull);
    });

    test('fromJson creates correct MealModel (search response with category)', () {
      final model = MealModel.fromJson(tJsonFull);

      expect(model.category, 'Chicken');
      expect(model.area, 'Japanese');
    });

    test('toJson omits null fields', () {
      final model = MealModel.fromJson(tJson);
      final json = model.toJson();

      expect(json.containsKey('strCategory'), isFalse);
      expect(json.containsKey('strArea'), isFalse);
    });

    test('toJson includes optional fields when present', () {
      final model = MealModel.fromJson(tJsonFull);
      final json = model.toJson();

      expect(json['strCategory'], 'Chicken');
      expect(json['strArea'], 'Japanese');
    });

    test('fromJson handles empty json gracefully', () {
      final model = MealModel.fromJson(const {});

      expect(model.id, '');
      expect(model.name, '');
    });
  });
}
