import 'package:flutter_test/flutter_test.dart';
import 'package:food_hub/features/recipes/data/models/category_model.dart';

void main() {
  group('CategoryModel', () {
    const tJson = {
      'idCategory': '1',
      'strCategory': 'Beef',
      'strCategoryThumb': 'https://example.com/beef.png',
      'strCategoryDescription': 'All beef dishes',
    };

    test('fromJson creates a correct CategoryModel', () {
      final model = CategoryModel.fromJson(tJson);

      expect(model.id, '1');
      expect(model.name, 'Beef');
      expect(model.thumbnailUrl, 'https://example.com/beef.png');
      expect(model.description, 'All beef dishes');
    });

    test('toJson produces correct map', () {
      final model = CategoryModel.fromJson(tJson);
      final json = model.toJson();

      expect(json['idCategory'], '1');
      expect(json['strCategory'], 'Beef');
      expect(json['strCategoryThumb'], 'https://example.com/beef.png');
    });

    test('fromJson handles missing fields gracefully', () {
      final model = CategoryModel.fromJson(const {});

      expect(model.id, '');
      expect(model.name, '');
      expect(model.thumbnailUrl, '');
      expect(model.description, '');
    });

    test('two models with same id are equal', () {
      final a = CategoryModel.fromJson(tJson);
      final b = CategoryModel.fromJson(tJson);

      expect(a, equals(b));
    });

    test('two models with different ids are not equal', () {
      final a = CategoryModel.fromJson(tJson);
      final b = CategoryModel.fromJson(const {
        'idCategory': '2',
        'strCategory': 'Beef',
        'strCategoryThumb': 'https://example.com/beef.png',
        'strCategoryDescription': 'All beef dishes',
      });

      expect(a, isNot(equals(b)));
    });
  });
}
