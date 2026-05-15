import 'package:flutter_test/flutter_test.dart';
import 'package:food_hub/features/recipes/data/models/meal_detail_model.dart';

void main() {
  group('MealDetailModel', () {
    final tJson = {
      'idMeal': '52772',
      'strMeal': 'Teriyaki Chicken Casserole',
      'strCategory': 'Chicken',
      'strArea': 'Japanese',
      'strInstructions': 'Step 1. Do something. Step 2. Do another thing.',
      'strMealThumb': 'https://example.com/teriyaki.jpg',
      'strYoutube': 'https://www.youtube.com/watch?v=abc123',
      'strSource': 'https://example.com/source',
      'strTags': 'Chicken,Japanese,Casserole',
      // Ingredients
      'strIngredient1': 'Soy Sauce',
      'strMeasure1': '3/4 cup',
      'strIngredient2': 'Water',
      'strMeasure2': '1/2 cup',
      'strIngredient3': 'Sugar',
      'strMeasure3': '1/4 cup',
      // Empty slots (should be skipped)
      'strIngredient4': '',
      'strMeasure4': '',
    };

    test('fromJson parses basic fields correctly', () {
      final model = MealDetailModel.fromJson(tJson);

      expect(model.id, '52772');
      expect(model.name, 'Teriyaki Chicken Casserole');
      expect(model.category, 'Chicken');
      expect(model.area, 'Japanese');
      expect(model.youtubeUrl, 'https://www.youtube.com/watch?v=abc123');
    });

    test('fromJson parses exactly 3 non-empty ingredients', () {
      final model = MealDetailModel.fromJson(tJson);

      expect(model.ingredients.length, 3);
      expect(model.ingredients[0].name, 'Soy Sauce');
      expect(model.ingredients[0].measure, '3/4 cup');
      expect(model.ingredients[1].name, 'Water');
      expect(model.ingredients[2].name, 'Sugar');
    });

    test('fromJson skips empty ingredient slots', () {
      final model = MealDetailModel.fromJson(tJson);
      // strIngredient4 is '' so should not appear
      final names = model.ingredients.map((i) => i.name).toList();
      expect(names.contains(''), isFalse);
    });

    test('fromJson parses comma-separated tags', () {
      final model = MealDetailModel.fromJson(tJson);

      expect(model.tags, ['Chicken', 'Japanese', 'Casserole']);
    });

    test('fromJson returns empty tags list when strTags is null', () {
      final jsonNoTags = Map<String, dynamic>.from(tJson)..remove('strTags');
      final model = MealDetailModel.fromJson(jsonNoTags);

      expect(model.tags, isEmpty);
    });

    test('toJson round-trip preserves id and name', () {
      final original = MealDetailModel.fromJson(tJson);
      final json = original.toJson();
      final restored = MealDetailModel.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.ingredients.length, original.ingredients.length);
    });

    test('previewUrl appends /preview suffix', () {
      final model = MealDetailModel.fromJson(tJson);

      expect(model.previewUrl, endsWith('/preview'));
    });
  });
}
