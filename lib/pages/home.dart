
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:nookmyseatapplication/pages/choose.dart';
import 'package:nookmyseatapplication/pages/navbar.dart';
import 'package:nookmyseatapplication/pages/serv.dart';

class home extends StatelessWidget {
  home({Key? key}) : super(key: key);

  final username = FirebaseAuth.instance.currentUser;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: navbar(email: username!.email.toString()),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          actions: [],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('All Movies',),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('buscollections')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    var itemList = snapshot.data!.docs;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: itemList.map((doc) {
                          var moviedet = doc.data() as Map<String, dynamic>;
                          String movieid=doc.id ?? 'not found';
                          String moviename = moviedet['movieName'] ??
                              'Unknown Bus';
                          int seatsBooked = moviedet['seats'] ??
                              'Unknown seats';
                          String imgname = moviedet['imgname'] ??
                              'Unknown seats';
                          String movieexpdate=moviedet['expiryDate'];

                          DateTime expdate = DateTime.parse(movieexpdate);
                          DateTime currentDate = DateTime.now();
                          return FutureBuilder<String>(
                            future: serv().downloadurl(imgname),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> imageSnapshot) {
                              if (imageSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (imageSnapshot.hasError) {
                                return Text('Error: ${imageSnapshot.error}');
                              } else if (!imageSnapshot.hasData) {
                                return Text('No image data available');
                              } else {
                                print("movie name is $imgname");
                                if(currentDate.isBefore(expdate)){

                                  return GestureDetector(
                                    onTap: (){
                                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => chooseshow(movieename:movieid ,)),);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(15),
                                      height: 320,
                                      width: 200,
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blue,
                                      ),

                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 250,
                                            child: Image.network(
                                              imageSnapshot.data!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Text(
                                            moviename,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }else{
                                  return Container();
                                }
                              }
                            },
                          );

                        }).toList(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}