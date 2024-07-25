import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:firebaseproject/addShakeTest.dart';

void main() {
 testWidgets('Adding a shake with an existing name should show an error', (WidgetTester tester) async {

  await tester.pumpWidget(MaterialApp(home: InventoryManagementScreen()));

  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();


  await tester.enterText(find.widgetWithText(TextField, 'Shake Name'), 'Test Shake');
  await tester.enterText(find.widgetWithText(TextField, 'Description'), 'Test Description');
  await tester.enterText(find.widgetWithText(TextField, 'Price'), '4');


  await tester.tap(find.widgetWithText(TextButton, 'Add'));
  await tester.pumpAndSettle();


  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();

  await tester.enterText(find.widgetWithText(TextField, 'Shake Name'), 'Test Shake');
  await tester.enterText(find.widgetWithText(TextField, 'Description'), 'Test Description 2');
  await tester.enterText(find.widgetWithText(TextField, 'Price'), '8');

  await tester.tap(find.widgetWithText(TextButton, 'Add'));
  await tester.pumpAndSettle();


  expect(find.text('Error'), findsOneWidget);
  expect(find.text('A shake with this name already exists.'), findsOneWidget);
 });
 testWidgets('Adding another shake with an existing name should show an error 2', (WidgetTester tester) async {

  await tester.pumpWidget(MaterialApp(home: InventoryManagementScreen()));


  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();


  await tester.enterText(find.widgetWithText(TextField, 'Shake Name'), 'Test Shake 3');
  await tester.enterText(find.widgetWithText(TextField, 'Description'), 'Test Description 2');
  await tester.enterText(find.widgetWithText(TextField, 'Price'), '8');


  await tester.tap(find.widgetWithText(TextButton, 'Add'));
  await tester.pumpAndSettle();


  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();

  await tester.enterText(find.widgetWithText(TextField, 'Shake Name'), 'Test Shake 3');
  await tester.enterText(find.widgetWithText(TextField, 'Description'), 'Test Description 2');
  await tester.enterText(find.widgetWithText(TextField, 'Price'), '6');

  await tester.tap(find.widgetWithText(TextButton, 'Add'));
  await tester.pumpAndSettle();


  expect(find.text('Error'), findsOneWidget);
  expect(find.text('A shake with this name already exists.'), findsOneWidget);
 });

 testWidgets('Adding a shake with a negative price should show an error', (WidgetTester tester) async {

  await tester.pumpWidget(MaterialApp(home: InventoryManagementScreen()));


  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();


  await tester.enterText(find.widgetWithText(TextField, 'Shake Name'), 'Test Shake 6');
  await tester.enterText(find.widgetWithText(TextField, 'Description'), 'Test Description');
  await tester.enterText(find.widgetWithText(TextField, 'Price'), '-44');


  await tester.tap(find.widgetWithText(TextButton, 'Add'));
  await tester.pumpAndSettle();


  expect(find.text('Error'), findsOneWidget);
  expect(find.text('The price must be a strictly positive value.'), findsOneWidget);
 });
 testWidgets('Adding a shake with a negative price should show an error 2', (WidgetTester tester) async {

  await tester.pumpWidget(MaterialApp(home: InventoryManagementScreen()));


  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();


  await tester.enterText(find.widgetWithText(TextField, 'Shake Name'), 'Test Shake 7');
  await tester.enterText(find.widgetWithText(TextField, 'Description'), 'Test Description');
  await tester.enterText(find.widgetWithText(TextField, 'Price'), '0');


  await tester.tap(find.widgetWithText(TextButton, 'Add'));
  await tester.pumpAndSettle();


  expect(find.text('Error'), findsOneWidget);
  expect(find.text('The price must be a strictly positive value.'), findsOneWidget);
 });
 testWidgets('Adding a shake with correct details should add it to the list', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: InventoryManagementScreen()));

  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();

  await tester.enterText(find.widgetWithText(TextField, 'Shake Name'), 'Test Shake 9');
  await tester.enterText(find.widgetWithText(TextField, 'Description'), 'Test Description');
  await tester.enterText(find.widgetWithText(TextField, 'Price'), '5.99');

  await tester.tap(find.widgetWithText(TextButton, 'Add'));
  await tester.pumpAndSettle();


  expect(find.text('Test Shake 9'), findsOneWidget);
  expect(find.text('Test Description'), findsOneWidget);
  expect(find.text('\$5.99'), findsOneWidget);
 });
 testWidgets('Adding a shake with correct details should add it to the list 2', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: InventoryManagementScreen()));

  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();

  await tester.enterText(find.widgetWithText(TextField, 'Shake Name'), 'Test Shake 10');
  await tester.enterText(find.widgetWithText(TextField, 'Description'), 'Test Description');
  await tester.enterText(find.widgetWithText(TextField, 'Price'), '9.99');

  await tester.tap(find.widgetWithText(TextButton, 'Add'));
  await tester.pumpAndSettle();


  expect(find.text('Test Shake 10'), findsOneWidget);
  expect(find.text('Test Description'), findsOneWidget);
  expect(find.text('\$9.99'), findsOneWidget);
 });

}
