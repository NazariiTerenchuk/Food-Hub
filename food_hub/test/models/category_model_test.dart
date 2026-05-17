import 'package:flutter_test/flutter_test.dart';
import 'package:food_hub/features/recipes/data/models/category_model.dart';

void main() {
  group('CategoryModel', () {
    test('fromJson creates a valid instance', () {
      final json = {
        'idCategory': '1',
        'strCategory': 'Beef',
        'strCategoryThumb': 'https://www.themealdb.com/images/category/beef.png',
        'strCategoryDescription': 'Beef is the culinary name for meat from cattle.',
      };

      final category = CategoryModel.fromJson(json);

      expect(category.id, '1');
      expect(category.name, 'Beef');
      expect(category.thumbnailUrl, 'https://www.themealdb.com/images/category/beef.png');
      expect(category.description, 'Beef is the culinary name for meat from cattle.');
    });

    test('toJson returns correct map', () {
      const category = CategoryModel(
        id: '2',
        name: 'Chicken',
        thumbnailUrl: 'thumb_url',
        description: 'desc',
      );

      final json = category.toJson();

      expect(json['idCategory'], '2');
      expect(json['strCategory'], 'Chicken');
      expect(json['strCategoryThumb'], 'thumb_url');
      expect(json['strCategoryDescription'], 'desc');
    });
  });
}
