
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nookmyseatapplication/pages/intoduction_page.dart';
import 'package:nookmyseatapplication/pages/services/shared_pref.dart';
import 'package:nookmyseatapplication/pages/themes/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  final void Function()? onPressed;

  const SignUp({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _name = TextEditingController();
  bool _obscureText = true;

  bool isLoading = false;

  Future<void> createUserWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });


      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyAppIntroductionScreen(),
        ),
      );

      String userIdto = randomAlphaNumeric(10);

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );


      await SharedPreferenceHelper().saveUserId(userIdto);
      await SharedPreferenceHelper().saveName(_name.text.toUpperCase());
      await SharedPreferenceHelper().saveUserEmail(_email.text);


      String userNameCap=_name.text.toUpperCase();
      String firstletter=userNameCap.substring(0,1).toUpperCase();

      await FirebaseFirestore.instance.collection('users').add({
        'email': _email.text,
        'name': userNameCap,
        'phonenumber': _number.text,
        'uniqueUserId': userIdto,
        "searchKey":firstletter,
      });
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Weak Password'),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email already exists'),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Consumer<ThemeModel>(
      builder: (context, ThemeModel themeNotifier, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                    width: size.width,
                    height: size.height,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 60,
                        ),
                        Text(
                          "Hello, \nWelcome ",
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              ?.copyWith(fontSize: size.width * 0.1),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: TextFormField(
                                controller: _name,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Name can't be empty";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Name",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: TextFormField(
                                controller: _number,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Number can't be empty";
                                  }
                                  if (text.length != 10) {
                                    return "Enter a valid number";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Phone number",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
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
                                  hintText: "Enter Email ",
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
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
                                  border: InputBorder.none,
                                  hintText: "Enter Password",
                                  suffixIcon: SizedBox(
                                    height: 40,
                                    child: IconButton(
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors
                                            .black, // Set color explicitly
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
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  createUserWithEmailAndPassword();
                                }
                              },
                              elevation: 0,
                              padding: EdgeInsets.all(18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Colors.blue,
                              child: Center(
                                child: Text(
                                  "Register",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextButton(
                              onPressed: widget.onPressed,
                              child: Text(
                                'Already Have an Account?',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                  Theme.of(context).textTheme.bodyText1!,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
