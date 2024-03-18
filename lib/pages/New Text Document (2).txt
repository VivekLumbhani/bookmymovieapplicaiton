import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nookmyseatapplication/pages/home.dart';
import 'package:nookmyseatapplication/pages/mainScreen.dart';
import 'package:nookmyseatapplication/pages/serv.dart';
import 'package:nookmyseatapplication/pages/services/shared_pref.dart';
import 'package:nookmyseatapplication/pages/test_home.dart';

class giveRivews extends StatefulWidget {
  final movieId;

  const giveRivews({Key? key, required this.movieId}) : super(key: key);

  @override
  State<giveRivews> createState() => _giveRivewsState();
}

class _giveRivewsState extends State<giveRivews> {
  double rating = 0;
  late TextEditingController reviewController;
  late Future<DocumentSnapshot> _movieSnapshot;
  String? username;

  @override
  void initState() {
    super.initState();
    _movieSnapshot = FirebaseFirestore.instance
        .collection('buscollections')
        .doc(widget.movieId)
        .get();
    reviewController = TextEditingController();
    gettheSharedPref();
  }

  gettheSharedPref() async {
    username = await SharedPreferenceHelper().getUserName();
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<DocumentSnapshot>(
        future: _movieSnapshot,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('Document does not exist'),
            );
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;

          String imgname = data['imgname'] ?? '';
          String movieName = data['movieName'] ?? '';
          String reviews = data["reviews"] ?? "[]"; // Initialize reviews to an empty list if it's null
          String ratingindb = data["rating"] ?? "]"; // Initialize reviews to an empty list if it's null



          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<String>(
                  future: serv().downloadurl(imgname),
                  builder: (BuildContext context, AsyncSnapshot<String> movieImageSnapshot) {
                    if (movieImageSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (movieImageSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${movieImageSnapshot.error}'),
                      );
                    } else if (!movieImageSnapshot.hasData) {
                      return Center(
                        child: Text('No movie image data available'),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          // Handle onTap if needed
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width, // Set width to match screen width
                              height: MediaQuery.of(context).size.height * 0.30, // Set height to 30% of screen height
                              child: Stack(
                                children: [
                                  Container(
                                    foregroundDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(movieImageSnapshot.data!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    movieName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "How would you rate this movie?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                RatingWidget(
                  initialRating: rating,
                  onRatingUpdate: (newRating) {
                    setState(() {
                      rating = newRating; // Update the rating value
                    });
                  },
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: reviewController,
                    decoration: InputDecoration(
                      labelText: 'Write your review...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {

                    String description = reviewController.text;

                    double rateofdb=double.parse(ratingindb);
                    double addition=rateofdb+rating;

                    double avgrating=addition/2;


                    var decodedReviews = List<Map<String, dynamic>>.from(jsonDecode(reviews));
                    decodedReviews.add({
                      "rating": rating.toString(),
                      "description": description.toString(),
                      "user": username
                    });

                    print("all reviews are $decodedReviews");

                    // Update the reviews field in Firestore
                    FirebaseFirestore.instance
                        .collection('buscollections')
                        .doc(widget.movieId)
                        .update({'reviews': jsonEncode(decodedReviews)});
                    FirebaseFirestore.instance
                        .collection('buscollections')
                        .doc(widget.movieId)
                        .update({'rating': avgrating.toString()});

                    // Clear the review text field after submission
                    reviewController.clear();

                    // Show a snackbar to indicate successful submission

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Success'),
                          content: Text('Thank you for your Review '),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen()),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RatingWidget extends StatefulWidget {
  final double initialRating;
  final Function(double) onRatingUpdate;

  const RatingWidget({Key? key, required this.initialRating, required this.onRatingUpdate}) : super(key: key);

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: widget.initialRating,
      minRating: 0,
      direction: Axis.horizontal, // Horizontal layout
      allowHalfRating: true, // Allow half-star ratings
      itemCount: 5, // Five stars
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (newRating) {
        setState(() {
          _rating = newRating;
        });
        widget.onRatingUpdate(newRating);
      },
    );
  }
}
