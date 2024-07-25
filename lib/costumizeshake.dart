import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';

class Flavor {
  String name;
  double price;
  @override
  String toString(){
    return name;
  }
  Flavor({required this.name, required this.price});
}
class Protein {
  String name;
  double price;

  @override
  String toString(){
    return name;
  }
  Protein({required this.name, required this.price});
}
class Milk {
  String name;
  double price;
  @override
  String toString(){
    return name;
  }
  Milk({required this.name, required this.price});
}

class GymShakeCustomizer extends StatefulWidget {
  GymShakeCustomizer({Key? key,required this.userbalance, required this.username,required this.updateBalanceCallback, required this.countUpdater, required this.count}) : super(key: key);
  final double userbalance;
  final String username;
  final Function(double) updateBalanceCallback;
  final void Function(int) countUpdater;
  int count=0;

  @override
  _GymShakeCustomizerState createState() => _GymShakeCustomizerState();
}

class _GymShakeCustomizerState extends State<GymShakeCustomizer> {
   double _userbalance=0;
  late Protein selectedProtein=Protein(name: "Whey Protein", price: 2);
  double electrolytesAmount = 0.0;
  late Milk selectedSolute =Milk(name: "OatMilk", price: 2);
  bool isCaffeinated = false;
  late Flavor selectedFlavor =Flavor(name: "Soy", price: 1);
  int _size = 1;


  @override
  void initState() {
    super.initState();
    fetchFlavors();
    fetchMilks();
    fetchProteins();
    _userbalance = widget.userbalance;
  }
  void _setSizeAsOne() {
    setState(() {
      _size = 1;
    });
  }
  void _setSizeAsTwo() {
    setState(() {
      _size = 2;
    });
  }
  void _setSizeAsThree() {
    setState(() {
      _size = 3;
    });
  }

  final List<Protein> proteinTypes = [];
  final List<Milk> soluteTypes = [];
  final List<Flavor> flavors = [];


  void fetchMilks() async {
    try {
      CollectionReference ingredients = FirebaseFirestore.instance.collection('Ingredients');

      DocumentSnapshot milkDoc = await ingredients.doc('Milk').get();

      if (milkDoc.exists) {
        Map<String, dynamic> milkData = milkDoc.data() as Map<String, dynamic>;

        soluteTypes.clear();

        milkData.forEach((milkName, milkPrice) {
          if (milkPrice is num) {
            Milk milk = Milk(name: milkName, price: milkPrice.toDouble());
            setState(() {
              soluteTypes.add(milk);
              selectedSolute=milk;
            });
          } else {
            print('Invalid price format for milk: $milkName');
          }
        });
      } else {
        print('Milk document does not exist');
      }
    } catch (e) {
      print('Error fetching milk: $e');
    }
  }

  void fetchFlavors() async {
    try {
      CollectionReference ingredients = FirebaseFirestore.instance.collection('Ingredients');

      DocumentSnapshot flavorDoc = await ingredients.doc('Flavor').get();

      if (flavorDoc.exists) {
        Map<String, dynamic> flavorsData = flavorDoc.data() as Map<String, dynamic>;

        flavors.clear();

        flavorsData.forEach((flavorName, flavorPrice) {
          if (flavorPrice is num) {
            Flavor flavor = Flavor(name: flavorName, price: flavorPrice.toDouble());
            setState(() {
              flavors.add(flavor);
              selectedFlavor=flavor;
            });
          } else {
            print('Invalid price format for flavor: $flavorName');
          }
        });
      } else {
        print('Flavor document does not exist');
      }
    } catch (e) {
      print('Error fetching flavors: $e');
    }
  }

  void fetchProteins() async {
    try {
      CollectionReference ingredients = FirebaseFirestore.instance.collection('Ingredients');

      DocumentSnapshot proteinDoc = await ingredients.doc('Protein').get();

      if (proteinDoc.exists) {
        Map<String, dynamic> proteinData = proteinDoc.data() as Map<String, dynamic>;

        proteinTypes.clear();

        proteinData.forEach((proteinName, proteinPrice) {
          if (proteinPrice is num) {
            Protein protein = Protein(name: proteinName, price: proteinPrice.toDouble());
            setState(() {
              proteinTypes.add(protein);
              selectedProtein=protein;
            });
          } else {
            print('Invalid price format for protein: $proteinName');
          }
        });
      } else {
        print('Protein document does not exist');
      }
    } catch (e) {
      print('Error fetching protein: $e');
    }
  }




  void _subtractPriceAndUpdateBalance(double calculatedPrice) async {
    try {
      double newBalance = widget.userbalance - calculatedPrice;

      CollectionReference profiles = FirebaseFirestore.instance.collection(widget.username);
      DocumentReference profileDoc = profiles.doc('Profile');
      await profileDoc.update({'balance': newBalance});

      widget.updateBalanceCallback(newBalance);
      setState(() async {
        widget.countUpdater(widget.count+1);
        try {
          int newcount = widget.count +1;

          CollectionReference profiles = FirebaseFirestore.instance.collection(widget.username);
          DocumentReference profileDoc = profiles.doc('Profile');
          await profileDoc.update({'OrderNb': newcount});
          widget.updateBalanceCallback(newBalance);
        } catch (e) {
          print('Error updating balance: $e');
        }
      });
    } catch (e) {
      print('Error updating balance: $e');
    }
  }
  
  void orderShake() {
    double price = selectedFlavor.price+selectedProtein.price+selectedSolute.price+_size+((isCaffeinated)?1:0);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Receipt'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Protein Type: ${selectedProtein.name}'),
            Text('Flavor : ${selectedFlavor.name}'),
            Text('Electrolytes Amount: $electrolytesAmount'),
            Text('Size: $_size'),
            Text('Solute Type: ${selectedSolute.name}'),
            Text('Caffeinated: ${isCaffeinated ? 'Yes' : 'No'}'),
            SizedBox(height: 10),
            Text('Total Price: \$${price.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (price > _userbalance) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Transaction Failed'),
                    content: Text('Your balance is insufficient for this order.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              }
              else{
                setState(() {
                  _subtractPriceAndUpdateBalance(price);
                  _addOrderToHistory("$selectedFlavor"+"_$selectedProtein",price,widget.count);
                  _userbalance-=price;
                });
              Navigator.pop(context);
              }},
            child: Text('Confirm'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

   void _addOrderToHistory(String shakeName, double shakePrice, int count) async {
     try {
       CollectionReference orders = FirebaseFirestore.instance.collection(widget.username);
       await orders.doc('order$count').set({
         'shake_name': shakeName,
         'date': Timestamp.now(),
         'price': shakePrice,
       });
       print(count);
       print('Order added to history successfully.');
     } catch (e) {
       print('Error adding order to history: $e');
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50], 
      appBar: AppBar(
        backgroundColor: Colors.green,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 60.0),
            child: Row(
              children: [
                Image.asset("assets/icons/dollar.png",width: 45,height: 45,),
                SizedBox(width: 5),
                Text(
                  'Balance: \$${_userbalance.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16,color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(50.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Size Options',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _setSizeAsOne();
                          });
                        },
                        child: SizedBox(
                          height: 45,
                          child: Image.asset((_size == 1) ? "assets/icons/frappe.png" : "assets/icons/frappeblack.png"),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _setSizeAsTwo();
                          });
                        },
                        child: SizedBox(
                          height: 60,
                          child: Image.asset((_size == 2) ? "assets/icons/frappe.png" : "assets/icons/frappeblack.png"),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _setSizeAsThree();
                          });
                        },
                        child: SizedBox(
                          height: 75,
                          child: Image.asset((_size == 3) ? "assets/icons/frappe.png" : "assets/icons/frappeblack.png"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Type of Milk',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700], // Set text color to green
                    ),
                  ),
                  DropdownButtonFormField<Milk>(
                    dropdownColor: Colors.green[50],
                    value: selectedSolute,
                    onChanged: (newValue) {
                      setState(() {
                        selectedSolute = newValue!;
                      });
                    },
                    items: soluteTypes.map<DropdownMenuItem<Milk>>((Milk value) {
                      return DropdownMenuItem<Milk>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 40.0),
                  Row(
                    children: [
                      Text('Caffeinated:', style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                      ),
                      Checkbox(
                        value: isCaffeinated,
                        onChanged: (newValue) {
                          setState(() {
                            isCaffeinated = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
            SizedBox(width: 30.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Protein Type',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 10,),

                  DropdownButtonFormField<Protein>(
                    dropdownColor: Colors.green[50],
                    value: selectedProtein,
                    onChanged: (newValue) {
                      setState(() {
                        selectedProtein = newValue!;
                      });
                    },
                    items: proteinTypes.map<DropdownMenuItem<Protein>>((Protein value) {
                      return DropdownMenuItem<Protein>(
                        value: value,
                        child: Text(value.name ),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.green), // Set label color to green
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Text("Electrolytes Amount : ", style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700], // Set text color to green
                  ),), // Set text color to green
                  Slider(
                    value: electrolytesAmount,
                    min: 0.0,
                    max: 10.0, // Adjust the maximum value according to your requirement
                    divisions: 10, // Number of divisions on the slider track
                    label: '$electrolytesAmount', // Display the current value as a label
                    onChanged: (newValue) {
                      setState(() {
                        electrolytesAmount = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Flavor',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700], // Set text color to green
                    ),
                  ),
                  SizedBox(height: 10,),

                  DropdownButtonFormField<Flavor>(
                    dropdownColor: Colors.green[50],
                    value: selectedFlavor,
                    onChanged: (newValue) {
                      setState(() {
                        selectedFlavor = newValue!;
                      });
                    },
                    items: flavors.map<DropdownMenuItem<Flavor>>((Flavor flavor) {
                      return DropdownMenuItem<Flavor>(
                        value: flavor,
                        child: Text(flavor.name),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 50,),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        orderShake(); // Function to show the order confirmation dialog
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0), // Adjust padding to increase button size
                        child: Text(
                          "Order",
                          style: TextStyle(color: Colors.white,fontSize: 20,), // White text color
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
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
}



