import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_hub/features/recipes/data/models/category_model.dart';
import 'package:food_hub/features/home/presentation/widgets/category_card.dart';

void main() {
  setUpAll(() {
    // Override HTTP calls for cached_network_image in tests
    HttpOverrides.global = _TestHttpOverrides();
  });

  testWidgets('CategoryCard displays category name and calls onTap', (tester) async {
    const category = CategoryModel(
      id: '1',
      name: 'Beef',
      thumbnailUrl: 'https://example.com/beef.png',
      description: 'Test description',
    );

    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CategoryCard(
            category: category,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Beef'), findsOneWidget);

    await tester.tap(find.byType(CategoryCard));
    await tester.pump();

    expect(tapped, isTrue);
  });
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
