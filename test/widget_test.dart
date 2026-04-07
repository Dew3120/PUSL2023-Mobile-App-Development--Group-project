// Basic smoke test for My Cartier app.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_cartier/main.dart';

void main() {
  testWidgets('App boots without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const CartierApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
