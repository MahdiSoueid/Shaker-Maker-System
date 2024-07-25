import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Profile.dart';
import 'costumizeshake.dart';
import 'productbox.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title, required this.username, required this.password});
  final String title;
  final String username;
  final String password;
  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  int _currentIndex=0;

  late double _userbalance=0;
  int _count=0;

  @override
  void initState() {
    super.initState();
    readBalance();
  }

  void countUpdater(int newCount) {
    setState(() {
      _count = newCount;
    });
  }

  void updateBalance(double newBalance) {
    setState(() {
      _userbalance = newBalance;
    });
  }

  Future<void> readBalance() async {
    try {
      CollectionReference profiles = FirebaseFirestore.instance.collection(widget.username);
      DocumentSnapshot profileDoc = await profiles.doc('Profile').get();
      if (profileDoc.exists) {
        Map<String, dynamic> data = profileDoc.data() as Map<String, dynamic>;
        dynamic balance = data['balance'];
        dynamic count=data["OrderNb"];
        print('Balance: $balance $count');
        setState(() {
          _userbalance=balance;
          _count=count;
        });

      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error reading balance: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
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

      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('ProductBox').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return ListView.builder(
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
                title: ProductBox(
                  name: name,
                  description: description,
                  price: price,
                  image: image,
                  userbalance: _userbalance,
                  updateBalanceCallback: updateBalance,
                  countUpdater:countUpdater,
                  count:_count,
                  username:widget.username,
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GymShakeCustomizer(
                userbalance: _userbalance,
                username: widget.username,
                updateBalanceCallback: updateBalance,
                countUpdater: countUpdater,
                count:_count,
              ),
            ),
          );
        }
        ,tooltip: 'Shake',
        child:  Image.asset("assets/icons/costumize.png", width: 40,height: 40,),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  title: 'Profile',
                  username: widget.username,
                  password: widget.password,
                  userbalance:_userbalance,
                  updateBalanceCallback: updateBalance,

                ),
              ),
            );

          }
        },
      ),

    );
  }
}
