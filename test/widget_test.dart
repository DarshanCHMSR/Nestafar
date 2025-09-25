// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Basic app widget test', (WidgetTester tester) async {
    // Build a simple app widget to test basic functionality
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Nestafar')),
          body: const Center(child: Text('Test App')),
        ),
      ),
    );

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify that the app elements appear in the UI
    expect(find.text('Nestafar'), findsOneWidget);
    expect(find.text('Test App'), findsOneWidget);
  });
}
