// balance, string
//price, string
//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InventoryManagementScreen extends StatefulWidget {
  @override
  State<InventoryManagementScreen> createState() => _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  void refresh(int c){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Inventory Management'),
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Shakes',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showAddShakeDialog(context);
                  },
                  child: Text('Add Shake'),

                ),
              ],
            ),
            SizedBox(height: 16.0),
            FutureBuilder(
              future: FirebaseFirestore.instance.collection('ProductBox').get(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return Expanded(child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var document = snapshot.data?.docs[index];
                    if (!document!.exists || document.data() == null) {
                      return SizedBox();
                    }
                    Map<String, dynamic> data = (document.data() as Map<String, dynamic>);

                    String name = data['name'];
                    String description = data['description'];
                    double price = data['price'];
                    String image = data['image'];

                    return ListTile(
                      title: ShakeCard(
                        name: name,
                        description: description,
                        price: price,
                        image: image,
                        refresh: refresh,
                      ),
                    );
                  },
                ),);
              },
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Ingredients',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showAddIngredientDialog(context, 'Protein');
                          },
                          child: Text('Add Protein'),
                        ),
                        SizedBox(height: 8.0),
                        FutureBuilder(
                          future: FirebaseFirestore.instance.collection('Ingredients').doc('Protein').get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Text('Document does not exist');
                            }

                            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

                            List<Widget> ingredientCards = [];
                            data.forEach((name, price) {
                              ingredientCards.add(
                                IngredientCard(
                                  name: name,
                                  price: price.toDouble(),
                                  color: Colors.blue,
                                  ingredientType: 'Protein',
                                  refresh: refresh,
                                ),
                              );
                            });
                            return Expanded(child: ListView(
                              shrinkWrap: true,
                              children: ingredientCards,
                            )
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.grey,
                    thickness: 1.0,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showAddIngredientDialog(context, 'Milk');
                          },
                          child: Text('Add Solute'),
                        ),
                        SizedBox(height: 8.0),
                        FutureBuilder(
                          future: FirebaseFirestore.instance.collection('Ingredients').doc('Milk').get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Text('Document does not exist');
                            }

                            // Extract data map from DocumentSnapshot
                            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

                            // Iterate over each entry in the data map
                            List<Widget> ingredientCards = [];
                            data.forEach((name, price) {
                              ingredientCards.add(
                                IngredientCard(
                                  name: name,
                                  price: price.toDouble(), // Assuming price is of type int
                                  color: Colors.green,
                                  ingredientType: 'Milk',
                                  refresh: refresh,
                                ),
                              );
                            });
                            return Expanded(child: ListView(
                              shrinkWrap: true,
                              children: ingredientCards,
                            ));
                          },
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.grey,
                    thickness: 1.0,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showAddIngredientDialog(context, 'Flavor');
                          },
                          child: Text('Add Flavor'),
                        ),
                        SizedBox(height: 8.0),
                        FutureBuilder(
                          future: FirebaseFirestore.instance.collection('Ingredients').doc('Flavor').get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Text('Document does not exist');
                            }

                            // Extract data map from DocumentSnapshot
                            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

                            // Iterate over each entry in the data map
                            List<Widget> ingredientCards = [];
                            data.forEach((name, price) {
                              ingredientCards.add(
                                IngredientCard(
                                  name: name,
                                  price: price.toDouble(),
                                  color: Colors.grey,
                                  ingredientType: 'Flavor',
                                  refresh: refresh,
                                ),
                              );
                            });
                            return Expanded(child: ListView(
                              shrinkWrap: true,
                              children: ingredientCards,
                            ));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddShakeDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController imageAddressController = TextEditingController();

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
              TextField(
                controller: imageAddressController,
                decoration: InputDecoration(labelText: 'Image Address'),
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
              onPressed: () async {
                String newName = nameController.text;
                String newDescription = descriptionController.text;
                double newPrice ;
                String newImageAddress = imageAddressController.text;

                try {
                  newPrice = double.parse(priceController.text);
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Please enter a valid number for price.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                final FirebaseFirestore firestore = FirebaseFirestore.instance;
                final CollectionReference shakes = firestore.collection("ProductBox");
                try {
                  QuerySnapshot querySnapshot = await shakes.get();
                  List<DocumentSnapshot> documents = querySnapshot.docs;
                  for (DocumentSnapshot doc in documents) {
                    if(newName==doc["name"]){
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content: Text('Shake name already used'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }
                  }
                } catch (e) {
                  print('Error fetching documents: $e');
                }

                if(newPrice<=0){
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Price cant be negative'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }


                try {
                  CollectionReference docRef = FirebaseFirestore.instance
                      .collection('ProductBox') ;
                  await docRef.doc(newName).set({
                    'name': newName,
                    'description': newDescription,
                    'price': newPrice,
                    'image': newImageAddress,

                  });
                  print('Field updated successfully!');
                } catch (e) {
                  print('Error updating field: $e');
                }

                Navigator.of(context).pop(); // Close the dialog
                refresh(1);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddIngredientDialog(BuildContext context, String type) {
    TextEditingController nameController = TextEditingController();
    TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add $type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: '$type Name'),
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newName = nameController.text;
                double newPrice ;
                try {
                  newPrice = double.parse(quantityController.text);
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Please enter a valid number for price.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                final FirebaseFirestore firestore = FirebaseFirestore.instance;
                final CollectionReference shakes = firestore.collection("Ingredients");
                try {
                  QuerySnapshot querySnapshot = await shakes.get();
                  List<DocumentSnapshot> documents = querySnapshot.docs;
                  for (DocumentSnapshot doc in documents) {
                    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
                    if (data != null && data.containsKey(newName)) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content: Text('Inregedient already exists'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                      return ;
                    }
                  }
                } catch (e) {
                  print('Error fetching documents: $e');
                }

                if(newPrice<=0){
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Price cant be negative'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                try {
                  DocumentReference docRef = FirebaseFirestore.instance
                      .collection('Ingredients').doc(type) ;
                  await docRef.update({
                    newName: newPrice,
                  });
                  print('Field updated successfully!');
                  } catch (e) {
                  print('Error updating field: $e');
                  }
                  Navigator.of(context).pop(); // Close the dialog
                      refresh(1);
                        },

                  child: Text('Add'),
                ),
              ],
        );
      },
    );
  }
}
class IngredientCard extends StatefulWidget {
  final String name;
  final double price;
  final Color color;
  final String ingredientType;
  final void Function(int) refresh;

  const IngredientCard({
    Key? key,
    required this.name,
    required this.price,
    required this.color,

    required this.ingredientType, required this.refresh,
  }) : super(key: key);

  @override
  State<IngredientCard> createState() => _IngredientCardState();
}

class _IngredientCardState extends State<IngredientCard> {
  void _showDeleteConfirmation(BuildContext context, String ingredientType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this $ingredientType?'),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  // Get the reference to the document
                  DocumentReference docRef = FirebaseFirestore.instance
                      .collection('Ingredients')
                      .doc(ingredientType);


                  await docRef.update({widget.name: FieldValue.delete()});
                  Navigator.pop(context);
                  widget.refresh(1);
                  print('Field deleted successfully!');
                } catch (e) {
                  print('Error deleting field: $e');
                }
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: widget.name);
    TextEditingController quantityController = TextEditingController(text: widget.price.toString());

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
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newName = nameController.text;
                double newQuantity ;

                try {
                  newQuantity = double.parse(quantityController.text);
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Please enter a valid number for price.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }




                if(newQuantity<0){
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Price cant be negative'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }
                try {

                    DocumentReference docRef = FirebaseFirestore.instance
                        .collection('Ingredients')
                        .doc(widget.ingredientType);

                    await docRef.update({widget.name: newQuantity});

                  print('Field updated successfully!');
                } catch (e) {
                  print('Error updating field: $e');
                }
                Navigator.of(context).pop(); // Close the dialog
                widget.refresh(1);
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
    return Card(
      elevation: 4.0,
      color: widget.color,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name: ${widget.name}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Price: ${widget.price}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  color: Colors.white,
                  onPressed: () {
                      _showEditDialog(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.white,
                  onPressed: () {
                    _showDeleteConfirmation(context, widget.ingredientType);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShakeCard extends StatefulWidget {
  final String name;
  final String description;
  final double price;
  final String image;
  final void Function(int) refresh;

  const ShakeCard({
    Key? key,
    required this.name,
    required this.description,
    required this.price,
    required this.image, required this.refresh,
  }) : super(key: key);

  @override
  _ShakeCardState createState() => _ShakeCardState();
}

class _ShakeCardState extends State<ShakeCard> {
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${widget.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {

                  QuerySnapshot snapshot =await FirebaseFirestore.instance.collection('ProductBox').get();
                  for(var doc in snapshot.docs){
                    if(doc["name"]==widget.name){
                        doc.reference.delete();
                    }
                  }

                  Navigator.of(context).pop();
                  widget.refresh(1);
                } catch (e) {
                  print('Error deleting document: $e');

                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialogShake(BuildContext context, String currentName, String currentDescription, double currentPrice, String currentImageAddress) {

    TextEditingController descriptionController = TextEditingController(text: currentDescription);
    TextEditingController priceController = TextEditingController(text: currentPrice.toString());
    TextEditingController imageAddressController = TextEditingController(text: currentImageAddress);

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
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: imageAddressController,
                decoration: InputDecoration(labelText: 'Image Address'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // String  newName=nameController.text;
                String newDescription = descriptionController.text;
                double newPrice ;
                String newImageAddress = imageAddressController.text;

                try {
                  newPrice = double.parse(priceController.text);
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Please enter a valid number for price.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }







                if(newPrice<=0){
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Price cant be negative'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }
                try {
                    await FirebaseFirestore.instance
                        .collection('ProductBox')
                        .doc(currentName)
                        .update({
                      "name":currentName,
                      'description': newDescription,
                      'price': newPrice,
                      'image': newImageAddress,
                    });
                    print("yes2");
                  Navigator.of(context).pop();
                  widget.refresh(1);

                } catch (e) {
                  print('Error updating document: $e');
                  // Handle error here
                }
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
    return Container(
      padding: const EdgeInsets.all(20),
      height: 220,
      child: Stack(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 120,
                    child:Image.network(
                      widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          widget.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          widget.price.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                            _showEditDialogShake(
                              context,
                              widget.name,
                              widget.description,
                              widget.price,
                              widget.image,
                            );
                        },
                      ),

                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmation(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}