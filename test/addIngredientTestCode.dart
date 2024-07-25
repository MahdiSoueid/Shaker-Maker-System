import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebaseproject/addIngredientTest.dart';

void main() {
  testWidgets('Adding an ingredient with an existing name should show an error', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: InventoryManagementScreen()));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    await tester.enterText(find.widgetWithText(TextField, 'Ingredient Name'), 'Test Ingredient');
    await tester.enterText(find.widgetWithText(TextField, 'Price'), '5.99');

    await tester.tap(find.widgetWithText(TextButton, 'Add'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    await tester.enterText(find.widgetWithText(TextField, 'Ingredient Name'), 'Test Ingredient');
    await tester.enterText(find.widgetWithText(TextField, 'Price'), '4.99');

    await tester.tap(find.widgetWithText(TextButton, 'Add'));
    await tester.pumpAndSettle();

    expect(find.text('Error'), findsOneWidget);
    expect(find.text('An ingredient with this name already exists.'), findsOneWidget);
  });

  testWidgets('Adding another ingredient with an existing name should show an error 2', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: InventoryManagementScreen()));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    await tester.enterText(find.widgetWithText(TextField, 'Ingredient Name'), 'Test Ingredient 3');
    await tester.enterText(find.widgetWithText(TextField, 'Price'), '5.99');

    await tester.tap(find.widgetWithText(TextButton, 'Add'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    await tester.enterText(find.widgetWithText(TextField, 'Ingredient Name'), 'Test Ingredient 3');
    await tester.enterText(find.widgetWithText(TextField, 'Price'), '8.99');

    await tester.tap(find.widgetWithText(TextButton, 'Add'));
    await tester.pumpAndSettle();

    expect(find.text('Error'), findsOneWidget);
    expect(find.text('An ingredient with this name already exists.'), findsOneWidget);
  });

  testWidgets('Adding an ingredient with a negative price should show an error', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: InventoryManagementScreen()));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    await tester.enterText(find.widgetWithText(TextField, 'Ingredient Name'), 'Test Ingredient 6');
    await tester.enterText(find.widgetWithText(TextField, 'Price'), '-5.99');

    await tester.tap(find.widgetWithText(TextButton, 'Add'));
    await tester.pumpAndSettle();

    expect(find.text('Error'), findsOneWidget);
    expect(find.text('The price must be a strictly positive value.'), findsOneWidget);
  });

  testWidgets('Adding an ingredient with a negative price should show an error 2', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: InventoryManagementScreen()));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    await tester.enterText(find.widgetWithText(TextField, 'Ingredient Name'), 'Test Ingredient 7');
    await tester.enterText(find.widgetWithText(TextField, 'Price'), '0');

    await tester.tap(find.widgetWithText(TextButton, 'Add'));
    await tester.pumpAndSettle();

    expect(find.text('Error'), findsOneWidget);
    expect(find.text('The price must be a strictly positive value.'), findsOneWidget);
  });

  testWidgets('Adding an ingredient with correct details should add it to the list', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: InventoryManagementScreen()));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    await tester.enterText(find.widgetWithText(TextField, 'Ingredient Name'), 'Test Ingredient 9');
    await tester.enterText(find.widgetWithText(TextField, 'Price'), '5.99');

    await tester.tap(find.widgetWithText(TextButton, 'Add'));
    await tester.pumpAndSettle();

    expect(find.text('Test Ingredient 9'), findsOneWidget);
    expect(find.text('\$5.99'), findsOneWidget);
  });

  testWidgets('Adding an ingredient with correct details should add it to the list 2', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: InventoryManagementScreen()));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    await tester.enterText(find.widgetWithText(TextField, 'Ingredient Name'), 'Test Ingredient 10');
    await tester.enterText(find.widgetWithText(TextField, 'Price'), '9.99');

    await tester.tap(find.widgetWithText(TextButton, 'Add'));
    await tester.pumpAndSettle();

    expect(find.text('Test Ingredient 10'), findsOneWidget);
    expect(find.text('\$9.99'), findsOneWidget);
  });
}
