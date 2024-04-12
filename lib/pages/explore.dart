import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nookmyseatapplication/pages/serv.dart';
import 'package:nookmyseatapplication/pages/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class explore extends StatefulWidget {
  const explore({Key? key}) : super(key: key);

  @override
  State<explore> createState() => _exploreState();
}

class _exploreState extends State<explore> {
  String selectedCity = '';

  Future<void> loadSelectedCity() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCity = prefs.getString("selectedCity") ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    loadSelectedCity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(8),
          child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('buscollections').get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              var itemList = snapshot.data!.docs;

              if (itemList.isEmpty) {
                return Center(child: Text('No data available'));
              }

              // Filter out movies whose release date is in the future and not available in the selected city
              itemList = itemList.where((doc) {
                var moviedet = doc.data() as Map<String, dynamic>;
                String releaseDate = moviedet['date'] ?? '';
                DateTime relDate = DateTime.parse(releaseDate);
                DateTime currentDate = DateTime.now();
                final theatersData = moviedet["theaters"] ?? "[]";
                final theatersInSelectedCity =
                jsonDecode(theatersData).where((theater) => theater["city"] == selectedCity).toList();
                return !relDate.isAfter(currentDate) && theatersInSelectedCity.isNotEmpty;
              }).toList();

              return GridView.builder(
                shrinkWrap: true, // Add this line
                physics: NeverScrollableScrollPhysics(), // Add this line
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 0.7, // Adjust as needed
                ),
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  var doc = itemList[index];
                  var moviedet = doc.data() as Map<String, dynamic>;
                  String imgname = moviedet['imgname'] ?? 'Unknown seats';
                  String movieName = moviedet['movieName'] ?? 'Unknown Bus';
                  String movieid = doc.id;

                  String rating = moviedet["rating"] ?? "5";
                  double ratings = double.parse(rating);

                  return FutureBuilder<String>(
                    future: serv().downloadurl(imgname),
                    builder: (BuildContext context, AsyncSnapshot<String> imageSnapshot) {
                      if (imageSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (imageSnapshot.hasError) {
                        return Text('Error: ${imageSnapshot.error}');
                      } else if (!imageSnapshot.hasData) {
                        return Text('No image data available');
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(movieename: movieid),
                                  ),
                                );
                              },
                              child: SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: Image.network(
                                  imageSnapshot.data!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "$movieName \t",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2, // adjust as necessary
                                  ),
                                ),
                                Text(
                                  rating,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
