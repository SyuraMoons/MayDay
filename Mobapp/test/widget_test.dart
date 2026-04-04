import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobapps/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('app opens on home tab by default', (WidgetTester tester) async {
    await pumpApp(tester);

    expect(find.text('Movement readiness'), findsOneWidget);
    expect(find.text('Profile incomplete'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Input'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('bottom navigation switches between tabs', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Input'));
    await tester.pumpAndSettle();
    expect(find.text('Body input'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Clear local data'), findsOneWidget);
  });

  testWidgets('saving valid input updates home and profile summaries', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Input'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), '180');
    await tester.enterText(find.byType(TextFormField).at(1), '75');
    await tester.enterText(find.byType(TextFormField).at(2), '29');
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Male').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Save profile'),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Save profile'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Profile ready'), findsOneWidget);
    expect(find.text('180 cm'), findsOneWidget);
    expect(find.text('75 kg'), findsOneWidget);
    expect(find.text('29 years'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Male'), findsOneWidget);
    expect(find.text('Saved profile'), findsOneWidget);
  });

  testWidgets('clearing local data resets the app to empty state', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'profile_height': '172',
      'profile_weight': '68',
      'profile_age': '31',
      'profile_gender': 'Female',
    });

    await pumpApp(tester);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.widgetWithText(OutlinedButton, 'Clear local data'),
    );
    await tester.tap(find.widgetWithText(OutlinedButton, 'Clear local data'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Not set'), findsNWidgets(4));

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Profile incomplete'), findsOneWidget);
    expect(find.text('Complete profile'), findsOneWidget);
  });
}
