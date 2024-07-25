import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebaseproject/addIngredientTest.dart';

void main() {
  
  testWidgets('Editing an ingredient with a negative price should show an error', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: InventoryManagementScreen()));


    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Ingredient Name'), 'Test Ingredient 2');
    await tester.enterText(find.widgetWithText(TextField, 'Price'), '15');

    await tester.tap(find.widgetWithText(TextButton, 'Add'));
    await tester.pumpAndSettle();

    expect(find.text('Test Ingredient 2'), findsOneWidget);


    await tester.tap(find.text('Test Ingredient 2'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Price'), '-5');

    await tester.tap(find.widgetWithText(TextButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Error'), findsOneWidget);
    expect(find.text('The price must be a strictly positive value.'), findsOneWidget);


    expect(find.text('\$15.00'), findsOneWidget);
  });

  testWidgets('Editing an ingredient with correct details should update it correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: InventoryManagementScreen()));


    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Ingredient Name'), 'Test Ingredient 3');
    await tester.enterText(find.widgetWithText(TextField, 'Price'), '25');

    await tester.tap(find.widgetWithText(TextButton, 'Add'));
    await tester.pumpAndSettle();

    expect(find.text('Test Ingredient 3'), findsOneWidget);
    expect(find.text('\$25.00'), findsOneWidget);


    await tester.tap(find.text('Test Ingredient 3'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Ingredient Name'), 'Updated Ingredient');
    await tester.enterText(find.widgetWithText(TextField, 'Price'), '30');

    await tester.tap(find.widgetWithText(TextButton, 'Save'));
    await tester.pumpAndSettle();


    expect(find.text('Updated Ingredient'), findsOneWidget);
    expect(find.text('\$30.00'), findsOneWidget);
  });
}
