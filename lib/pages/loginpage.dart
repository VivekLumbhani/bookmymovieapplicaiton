
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nookmyseatapplication/pages/services/shared_pref.dart';
import 'package:nookmyseatapplication/pages/themes/theme_model.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatefulWidget {
  final void Function()? onPressed;

  const LoginPage({super.key, required this.onPressed});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  bool _obscureText = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  signInWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });


      QuerySnapshot<Map<String, dynamic>> userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _email.text)
          .get();

      if (userQuery.docs.isNotEmpty) {

        Map<String, dynamic> userData = userQuery.docs.first.data()!;
        String userName = userData['name'];
        String userId = userData['uniqueUserId'];
        String userEmailId = userData['uniqueUserId'];

        await SharedPreferenceHelper().saveUserEmail(userEmailId);
        await SharedPreferenceHelper().saveUserId(userId);
        await SharedPreferenceHelper().saveName(userName);


      } else {
        // User not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not found'),
          ),
        );
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );

      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wrong User'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wrong password for user'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Consumer<ThemeModel>(
      builder: (context, ThemeModel themeNotifier, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Hello, \nWelcome Back",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: size.width * 0.1),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: _handleGoogleSignIn,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'images/google.png',
                                  fit: BoxFit.cover,
                                  width: 30.0,
                                  height: 30.0,
                                ),
                              ),
                            ),
                            SizedBox(width: 40),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'images/facebook.png',
                                  fit: BoxFit.cover,
                                  width: 30.0,
                                  height: 30.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 3,
                              width: size.width * 0.4,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Or",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 3,
                              width: size.width * 0.4,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius:
                            BorderRadius.all(Radius.circular(20)),
                          ),
                          child: TextFormField(
                            controller: _email,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Email can't be empty";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Email",
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius:
                            BorderRadius.all(Radius.circular(20)),
                          ),
                          child: TextFormField(
                            obscureText: _obscureText,
                            controller: _password,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Password can't be empty";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Enter Password",
                              border: InputBorder.none,
                              suffixIcon: SizedBox(
                                height: 0,
                                child: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Column(
                          children: [
                            MaterialButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  signInWithEmailAndPassword();
                                }
                              },
                              elevation: 0,
                              padding: EdgeInsets.all(18),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: Colors.blue,
                              child: Center(
                                child: Text(
                                  "Login",
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextButton(
                              onPressed: () {
                                widget.onPressed?.call();
                              },
                              child: Text(
                                "Create account",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

  }

  void _handleGoogleSignIn() {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }
}
