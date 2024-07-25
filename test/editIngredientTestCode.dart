import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebaseproject/addIngredientTest.dart';

void main() {
  testWidgets('Editing an ingredient with correct details should update it correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: InventoryManagementScreen()));


    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Ingredient Name'), 'Test Ingredient');
    await tester.enterText(find.widgetWithText(TextField, 'Price'), '10');

    await tester.tap(find.widgetWithText(TextButton, 'Add'));
    await tester.pumpAndSettle();

    expect(find.text('Test Ingredient'), findsOneWidget);
    expect(find.text('\$10.00'), findsOneWidget);


    await tester.tap(find.text('Test Ingredient'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Ingredient Name'), 'Updated Ingredient');
    await tester.enterText(find.widgetWithText(TextField, 'Price'), '15');

    await tester.tap(find.widgetWithText(TextButton, 'Save'));
    await tester.pumpAndSettle();


    expect(find.text('Updated Ingredient'), findsOneWidget);
    expect(find.text('\$15.00'), findsOneWidget);
  });


  testWidgets('Editing an ingredient with a negative price should show an error', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: InventoryManagementScreen()));


    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Ingredient Name'), 'Test Ingredient');
    await tester.enterText(find.widgetWithText(TextField, 'Price'), '50');

    await tester.tap(find.widgetWithText(TextButton, 'Add'));
    await tester.pumpAndSettle();

    expect(find.text('Test Ingredient'), findsOneWidget);
    expect(find.text('\$50.00'), findsOneWidget);

    // Edit the ingredient with a negative price
    await tester.tap(find.text('Test Ingredient'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Price'), '-10'); // Editing to a negative price
    await tester.tap(find.widgetWithText(TextButton, 'Save'));
    await tester.pumpAndSettle();

    // Verify that an error dialog is shown
    expect(find.text('Error'), findsOneWidget);
    expect(find.text('The price must be a strictly positive value.'), findsOneWidget);

    // Verify that the price didn't change after encountering the error
    expect(find.text('\$50.00'), findsOneWidget);
  });
}
