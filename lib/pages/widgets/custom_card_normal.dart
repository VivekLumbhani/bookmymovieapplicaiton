import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nookmyseatapplication/pages/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../serv.dart';

class CustomCardNormal extends StatefulWidget {
  const CustomCardNormal();

  @override
  State<CustomCardNormal> createState() => _CustomCardNormalState();
}

class _CustomCardNormalState extends State<CustomCardNormal> {
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
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('buscollections').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No data available');
        }

        var itemList = snapshot.data!.docs;


        itemList.sort((a, b) {
          var ratingA = double.parse(a['rating'] ?? '0');
          var ratingB = double.parse(b['rating'] ?? '0');
          return ratingB.compareTo(ratingA);
        });


        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: itemList.map((doc) {
              var moviedet = doc.data() as Map<String, dynamic>;
              String moviename = moviedet['movieName'] ?? 'Unknown Bus';
              String imgname = moviedet['imgname'] ?? 'Unknown seats';
              String movieexpdate = moviedet['expiryDate'];
              String releaseDate = moviedet['date'] ?? '';

              String ratings = moviedet["rating"] ?? "5";
              String reviews = moviedet["reviews"] ?? "[]";
              var decodedReviews = List<Map<String, dynamic>>.from(jsonDecode(reviews));
              DateTime relDate = DateTime.parse(releaseDate);

              final theatersData = moviedet["theaters"] ?? "[]";
              final theatersInSelectedCity = jsonDecode(theatersData).where((theater) => theater["city"] == selectedCity).toList();

              if (theatersInSelectedCity.isEmpty) {
                return Container();
              }

              theatersInSelectedCity.forEach((theater) {
                print("movie name " + moviename);

                print("Cinema Name: ${theater["cinemaName"]}");
                print("City: ${theater["city"]}");
                print("Dynamic Times:");
                for (var time in theater["dynamicTimes"]) {
                  print("${time["hour"]}:${time["minute"]}");
                }
                print("Seatings:");
                print("Upper Part: Row - ${theater["seatings"]["upperPart"]["row"]}, Column - ${theater["seatings"]["upperPart"]["column"]}, Price - ${theater["seatings"]["upperPart"]["price"]}");
                print("Lower Part: Row - ${theater["seatings"]["lowerPart"]["row"]}, Column - ${theater["seatings"]["lowerPart"]["column"]}, Price - ${theater["seatings"]["lowerPart"]["price"]}");
                print("\n");
              });

              DateTime expdate = DateTime.parse(movieexpdate);
              DateTime currentDate = DateTime.now();

              return FutureBuilder<String>(
                future: serv().downloadurl(imgname),
                builder: (BuildContext context, AsyncSnapshot<String> imageSnapshot) {
                  if (imageSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (imageSnapshot.hasError) {
                    return Text('Error: ${imageSnapshot.error}');
                  } else if (!imageSnapshot.hasData) {
                    return Text('No image data available');
                  } else {
                    print("movie name is $imgname");
                    if (currentDate.isBefore(expdate) && !relDate.isAfter(currentDate)) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(movieename: doc.id),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                height: 300,
                                width: 140,
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(imageSnapshot.data!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    moviename,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        ratings,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
