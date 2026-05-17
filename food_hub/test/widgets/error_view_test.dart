import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_hub/shared/widgets/error_view.dart';

void main() {
  testWidgets('ErrorView displays message and retry button', (tester) async {
    bool retryCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorView(
            message: 'Something went wrong',
            onRetry: () {
              retryCalled = true;
            },
          ),
        ),
      ),
    );

    // Verify text is displayed
    expect(find.text('Something went wrong'), findsOneWidget);

    // Verify button exists and tap it
    final retryButton = find.text('Retry');
    expect(retryButton, findsOneWidget);

    await tester.tap(retryButton);
    await tester.pumpAndSettle();

    expect(retryCalled, isTrue);
  });
}
