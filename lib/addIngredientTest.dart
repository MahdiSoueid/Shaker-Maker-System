import 'package:flutter/material.dart';

class Ingredient {
  String name;
  double price;

  Ingredient({required this.name, required this.price});
}

class InventoryManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InventoryPage(),
    );
  }
}

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final List<Ingredient> ingredients = [];

  void _showAddIngredientDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Ingredient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Ingredient Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newName = nameController.text;
                double newPrice = double.tryParse(priceController.text) ?? 0.0;

                if (ingredients.any((ingredient) => ingredient.name == newName)) {
                  _showErrorDialog(context, "An ingredient with this name already exists.");
                  return;
                }

                if (newPrice <= 0) {
                  _showErrorDialog(context, "The price must be a strictly positive value.");
                  return;
                }

                Ingredient newIngredient = Ingredient(
                  name: newName,
                  price: newPrice,
                );

                setState(() {
                  ingredients.add(newIngredient);
                });

                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showEditIngredientDialog(BuildContext context, Ingredient ingredient) {
    TextEditingController nameController = TextEditingController(text: ingredient.name);
    TextEditingController priceController = TextEditingController(text: ingredient.price.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Ingredient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Ingredient Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String updatedName = nameController.text;
                double updatedPrice = double.tryParse(priceController.text) ?? 0.0;

                if (updatedName != ingredient.name && ingredients.any((ingredient) => ingredient.name == updatedName)) {
                  _showErrorDialog(context, "An ingredient with this name already exists.");
                  return;
                }

                if (updatedPrice <= 0) {
                  _showErrorDialog(context, "The price must be a strictly positive value.");
                  return;
                }

                setState(() {
                  ingredient.name = updatedName;
                  ingredient.price = updatedPrice;
                });

                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Management'),
      ),
      body: ListView.builder(
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(ingredients[index].name),
            trailing: Text('\$${ingredients[index].price.toStringAsFixed(2)}'),
            onTap: () => _showEditIngredientDialog(context, ingredients[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddIngredientDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(InventoryManagementScreen());
}
