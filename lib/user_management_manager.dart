
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'register.dart';
class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<User> userList = [];
  List<String> users = [];
  List<User> filterList = [];
  void refresh(int c){
    setState(() {
      fetchUserData();
    });
  }



  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    await getUsers();
    await getUsersBalance();
  }

  Future<void> getUsers() async {
    users.clear();
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('Users').get();
    for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
      String userName = userDoc['name'];
      if(userName != "Jihad" && userName != "ProductBox" && userName != "Ingredients" && userName != "Users" && !users.contains(userName)) {
        users.add(userName);
      }
    }
  }

  Future<void> getUsersBalance() async {
    userList.clear();
    for(String collection in users){
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(collection).doc("Profile").get();
      if (userDoc.exists) {
        double balance = userDoc["balance"];
        User u = User(balance: balance.toStringAsFixed(2), name: collection);
        userList.add(u);
      }
    }
    setState(() {}); // Trigger a rebuild after fetching data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by name...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    filterList = userList.where((user) => user.name.contains(value)).toList();
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filterList.isEmpty ? userList.length : filterList.length,
                itemBuilder: (BuildContext context, int index) {
                  final User user = filterList.isEmpty ? userList[index] : filterList[index];
                  return UserCard(user: user,refresh: refresh,);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterPage(refresh:refresh)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class User {
  final String name;
  final String balance;

  User({
    required this.name,
    required this.balance,
  });
  String toString(){
    return name+", "+balance.toString();
  }

}

class UserCard extends StatefulWidget {
  final User user;
  final void Function(int) refresh;


  const UserCard({
    Key? key,
    required this.user, required this.refresh,
  }) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${widget.user.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final collectionRef = FirebaseFirestore.instance.collection(widget.user.name);
                final snapshots = await collectionRef.get();


                for (var doc in snapshots.docs) {
                  await doc.reference.delete();
                }final snapshot2= await FirebaseFirestore.instance.collection("Users").get();
                for (var doc in snapshot2.docs) {
                  if(doc["name"]==widget.user.name)
                    await doc.reference.delete();
                }
                Navigator.of(context).pop();
                widget.refresh(1);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: widget.user.name);
    TextEditingController balanceController = TextEditingController(text: widget.user.balance.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit ${widget.user.name}\'s balance '),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: balanceController,
                decoration: InputDecoration(labelText: 'Balance'),
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
                double newBalance ;

                try {
                  newBalance = double.parse(balanceController.text);
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

                if(newBalance<0) {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(
                          title: Text('Error'),
                          content: Text('Balance cannot be less than zero.'),
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
                await FirebaseFirestore.instance
                    .collection(widget.user.name)
                    .doc("Profile")
                    .update({

                  'balance': newBalance,

                });
                Navigator.of(context).pop();
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
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name: ${widget.user.name}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Balance: ${widget.user.balance}',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditDialog(context);
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
    );
  }
}
