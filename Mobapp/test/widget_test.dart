import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobapps/main.dart';

void main() {
  testWidgets('app opens on login screen by default', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.widgetWithText(FilledButton, 'Login'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'Create account'), findsOneWidget);
    expect(find.text('Movement readiness'), findsNothing);
  });
}
