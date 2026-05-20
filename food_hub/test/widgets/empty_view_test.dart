import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_hub/shared/widgets/empty_view.dart';

void main() {
  testWidgets('EmptyView displays title and icon', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyView(
            title: 'No items',
          ),
        ),
      ),
    );

    expect(find.text('No items'), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);
  });

  testWidgets('EmptyView displays subtitle when provided', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyView(
            title: 'No items',
            subtitle: 'Check back later',
          ),
        ),
      ),
    );

    expect(find.text('No items'), findsOneWidget);
    expect(find.text('Check back later'), findsOneWidget);
  });
}
