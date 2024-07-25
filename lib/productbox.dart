import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';



class ProductBox extends StatefulWidget {
  ProductBox( {super.key, required this.name, required this.description, required this.price, required this.image, required this.userbalance, required this.updateBalanceCallback, required this.count, required this.countUpdater, required String this.username}) ;
  final String name;
  final String description;
  final double price;
  final String image;
  final void Function(int) countUpdater;
  double userbalance;
  int count;
  String username;
  final Function(double) updateBalanceCallback;

  @override
  State<ProductBox> createState() => _ProductBoxState();
}

class _ProductBoxState extends State<ProductBox> {
  int _size = 1;

  double calculatePrice() {
    if (_size == 1) {
      return widget.price;
    } else if (_size == 2) {
      return widget.price + 1;
    } else if (_size == 3) {
      return widget.price + 2;
    } else {
      return widget.price;
    }
  }

  void _setSizeAsOne() {
    setState( ()  { _size = 1; });
  }
  void _setSizeAsTwo() {
    setState( () { _size = 2; });
  }
  void _setSizeAsThree() {
    setState(() {
      _size = 3;
    });
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
                    child: Image.network(
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
                        ElevatedButton(
                          onPressed: () {
                            _showOrderConfirmationDialog();
                          },
                          child: Text(
                            "Order",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      ClipRRect(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _setSizeAsOne();
                            });
                          },
                          child: SizedBox(
                            height: 45,
                            child: Image.asset((_size == 1)
                                ? "assets/icons/frappe.png"
                                : "assets/icons/frappeblack.png"
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _setSizeAsTwo();
                              });
                            },
                            child: SizedBox(
                              height: 60,
                              child: Image.asset((_size == 2)
                                  ? "assets/icons/frappe.png"
                                  : "assets/icons/frappeblack.png"
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _setSizeAsThree();
                              });
                            },
                            child: SizedBox(
                              height: 75,
                              child: Image.asset((_size == 3)
                                  ? "assets/icons/frappe.png"
                                  : "assets/icons/frappeblack.png"
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Price: \$${calculatePrice().toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
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

  void _showOrderConfirmationDialog() {
    String shakeName = widget.name;
    double calculatedPrice = calculatePrice();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Order Confirmation"),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text("Your reciept :"),
              const SizedBox(height: 10),
              Text("Shake: $shakeName"),
              Text("Price: \$${calculatedPrice.toStringAsFixed(2)}"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if(widget.userbalance<calculatedPrice){
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
                else
                  {
                    setState(() {
                      _subtractPriceAndUpdateBalance(calculatedPrice);
                      _addOrderToHistory(shakeName,calculatedPrice,widget.count);
                    });
                    Navigator.of(context).pop();
                  }
              },
              child: const Text("Confirm"),
            ),
            TextButton(
                onPressed: (){Navigator.of(context).pop();},
                child: const Text("Cancel")
            )
          ],
        );
      },
    );
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
}
