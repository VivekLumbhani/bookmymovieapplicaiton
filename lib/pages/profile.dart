import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nookmyseatapplication/pages/booked.dart';
import 'package:nookmyseatapplication/pages/chats.dart';
import 'package:nookmyseatapplication/pages/login_or_signup.dart';
import 'package:nookmyseatapplication/pages/loginpage.dart';
import 'package:nookmyseatapplication/pages/qr_scanner.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _ProfileState();
}

class _ProfileState extends State<profile> {
  String? name;
  String? phoneNumber;
  String? useremail;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final username = FirebaseAuth.instance.currentUser;
    useremail = username!.email.toString();

    if (useremail != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: useremail.toString())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          name = querySnapshot.docs.first['name'];
          phoneNumber = querySnapshot.docs.first['phonenumber'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          // Add a finite height constraint
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                    AssetImage('images/unknown.jpeg'), // Replace with actual image path
                  ),
                  SizedBox(height: 20),
                  Text(
                    name ?? 'Loading...', // Display loading if name is not fetched yet
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    useremail ?? 'Loading...', // Display loading if name is not fetched yet
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    phoneNumber ?? 'Loading...', // Display loading if phone number is not fetched yet
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 40),
                  ListTile(
                    leading: Icon(Icons.chat),
                    title: Text('Chats'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => chatsScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.book),
                    title: Text('My Bookings'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => booked(),
                        ),
                      );
                    },
                  ),
                  if (useremail == "kruti@gmail.com" || useremail == "vivek@gmail.com")
                    ListTile(
                      leading: Icon(Icons.qr_code_scanner_sharp),
                      title: Text('QR Scanner'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QrCodeScanner(),
                          ),
                        );
                      },
                    ),
                  ListTile(
                    leading: Icon(Icons.feedback_outlined),
                    title: Text('Feedback'),
                    onTap: () {
                      showFeedbackDialog(context);
                    },
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Logout',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showFeedbackDialog(BuildContext context) async {
    double rating = 0;
    String feedback = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 40,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  rating = newRating;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                ),
                onChanged: (value) {
                  feedback = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                // Handle submission logic here
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
