import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nookmyseatapplication/pages/choose.dart';
import 'package:nookmyseatapplication/pages/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../colors.dart';
import '../serv.dart';

class CustomCardThumnail extends StatefulWidget {
  const CustomCardThumnail();

  @override
  State<CustomCardThumnail> createState() => _CustomCardThumnailState();
}

class _CustomCardThumnailState extends State<CustomCardThumnail> {
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

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: itemList.map((doc) {
              var moviedet = doc.data() as Map<String, dynamic>;
              String moviename = moviedet['movieName'] ?? 'Unknown Bus';
              String releaseDate = moviedet['date'] ?? '';
              String ratings = moviedet["rating"] ?? "5";
              String reviews = moviedet["reviews"] ?? "[]";
              String theaters = moviedet["theaters"] ?? "[]";
              var decodedReviews = List<Map<String, dynamic>>.from(jsonDecode(reviews));
              final theatersData = jsonDecode(theaters);

              final theatersInSelectedCity = theatersData.where((theater) => theater["city"] == selectedCity).toList();

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

              var numofvotes = decodedReviews.length > 0 ? decodedReviews.length : 1;
              String imgname = moviedet['imgname'] ?? 'Unknown seats';
              String movieexpdate = moviedet['expiryDate'];

              DateTime expdate = DateTime.parse(movieexpdate);
              DateTime relDate = DateTime.parse(releaseDate);
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
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(movieename: doc.id),
                                ),
                              );
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: MediaQuery.of(context).size.width * 0.5,
                              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(imageSnapshot.data!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        ratings,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.people,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        numofvotes.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          moviename,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
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
