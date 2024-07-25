
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class RegisterPage extends StatefulWidget {

  @override
  final void Function(int) refresh;
  const RegisterPage({super.key, required this.refresh});
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _retypePasswordController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _passwordIsValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('REGISTRATION'),
        centerTitle: true,
        backgroundColor: Color(0xFF2196f3),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                onChanged: (_) => _validatePassword(_passwordController.text),
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              _passwordIsValid
                  ? Container()
                  : Text(
                'Password should contain at least 1 number, 1 capital letter, 1 small letter, 1 unique character, and length greater than 6.',
                style: TextStyle(color: Colors.red),
              ),

              SizedBox(height: 20),
              TextField(
                controller: _retypePasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Retype Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _balanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Balance',
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {

                  String username = _usernameController.text;
                  String password = _passwordController.text;
                  String retypePassword = _retypePasswordController.text;
                  double balance;
                  try {
                     balance = double.parse(_balanceController.text);
                  } catch (e) {
                    // Show alert dialog if parsing fails
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Please enter a valid number for balance.'),
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
                  final CollectionReference userCollection = firestore.collection(username);
                  final CollectionReference users = firestore.collection("Users");
                  try {
                    QuerySnapshot querySnapshot = await users.get();
                    List<DocumentSnapshot> documents = querySnapshot.docs;
                    for (DocumentSnapshot doc in documents) {
                      if(username==doc["name"]){
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text('Username already used'),
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
                  if(!_passwordIsValid){
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Incomplete Password '),
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

                  if (balance < 0) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
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

                  if (password == retypePassword) {
                    try {

                      await userCollection.doc('Profile').set({
                        'balance': balance,
                        'password': password,
                        'OrderNb': 0,
                      });

                      await users.add({
                        'name': username,
                      });
                      print('User registered successfully: $username');
                    } catch (e) {
                      print('Error registering user: $e');
                    }
                    print('Registration successful for $username with balance $balance');
                    Navigator.pop(context);
                    widget.refresh(1);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Passwords do not match.'),
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
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _validatePassword(String password) {
    setState(() {
      _passwordIsValid = RegExp(
          r'^(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*(),.?":{}|<>]).{6,}$')
          .hasMatch(password);
    });
  }
}
