import 'package:flutter/material.dart';

class Shake {
  String name;
  String description;
  double price;

  Shake({required this.name, required this.description, required this.price});
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
  final List<Shake> shakes = [];

  void _showAddShakeDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Shake'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Shake Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
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
                String newDescription = descriptionController.text;
                double newPrice = double.tryParse(priceController.text) ?? 0.0;

                if (shakes.any((shake) => shake.name == newName)) {
                  _showErrorDialog(context, "A shake with this name already exists.");
                  return;
                }

                if (newPrice <= 0) {
                  _showErrorDialog(context, "The price must be a strictly positive value.");
                  return;
                }

                Shake newShake = Shake(
                  name: newName,
                  description: newDescription,
                  price: newPrice,
                );

                setState(() {
                  shakes.add(newShake);
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

  void _showEditShakeDialog(BuildContext context, Shake shake) {
    TextEditingController nameController = TextEditingController(text: shake.name);
    TextEditingController descriptionController = TextEditingController(text: shake.description);
    TextEditingController priceController = TextEditingController(text: shake.price.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Shake'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Shake Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
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
                String updatedDescription = descriptionController.text;
                double updatedPrice = double.tryParse(priceController.text) ?? 0.0;

                if (updatedName != shake.name && shakes.any((shake) => shake.name == updatedName)) {
                  _showErrorDialog(context, "A shake with this name already exists.");
                  return;
                }

                if (updatedPrice <= 0) {
                  _showErrorDialog(context, "The price must be a strictly positive value.");
                  return;
                }

                setState(() {
                  shake.name = updatedName;
                  shake.description = updatedDescription;
                  shake.price = updatedPrice;
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
        itemCount: shakes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(shakes[index].name),
            subtitle: Text(shakes[index].description),
            trailing: Text('\$${shakes[index].price.toStringAsFixed(2)}'),
            onTap: () => _showEditShakeDialog(context, shakes[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddShakeDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(InventoryManagementScreen());
}
