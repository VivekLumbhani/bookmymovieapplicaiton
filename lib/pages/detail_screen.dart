import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nookmyseatapplication/colors.dart';
import 'dart:convert';

import 'package:nookmyseatapplication/movies.dart';
import 'package:nookmyseatapplication/pages/choose.dart';
import 'package:nookmyseatapplication/pages/reviews.dart';

import 'package:nookmyseatapplication/pages/serv.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final String? movieename;

  const DetailScreen({required this.movieename});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<MovieModel> popularItems = List.of(popularImages);
  var data;
  var expiryDate;
  var casts;
  var date;
  var imgname;
  var castsString;
  var movieName;
  var reviews;
  var category;
  var description;
  var link;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>giveRivews(movieId: widget.movieename,)
              ),
            );

          }, icon: Icon(Icons.reviews_outlined),

          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('buscollections')
            .doc(widget.movieename)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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

          data = snapshot.data!.data()! as Map<String, dynamic>;

          expiryDate = data['expiryDate'] as String;
          date = data['date'] as String;
          imgname = data['imgname'] as String;
          castsString = data['casts'] as String;
          movieName = data['movieName'] as String;
          category = data['categories'] as List;
          reviews=data["reviews"] ??"[]";
          description = data['descriptionOfMovie'] as String;
          link = data['link'] as String;

          return FutureBuilder<String>(
            future: serv().downloadurl(imgname),
            builder: (BuildContext context,
                AsyncSnapshot<String> movieImageSnapshot) {
              if (movieImageSnapshot.connectionState ==
                  ConnectionState.waiting) {
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
                // Movie image loaded successfully
                return FutureBuilder<List<String>>(
                  future: _fetchCastImages(castsString),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> castImagesSnapshot) {
                    if (castImagesSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (castImagesSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${castImagesSnapshot.error}'),
                      );
                    } else if (!castImagesSnapshot.hasData) {
                      return Center(
                        child: Text('No cast images data available'),
                      );
                    } else {
                      // All images loaded successfully
                      List<String> castImages = castImagesSnapshot.data!;
                      return Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    launch(link);
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        foregroundDecoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(18),
                                          gradient: LinearGradient(
                                            colors: [
                                              kBackgroundColor.withOpacity(0.8),
                                              Colors.transparent,
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height * 0.50,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(movieImageSnapshot.data!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Align(
                                          alignment: FractionalOffset.center,
                                          child: Container(
                                            width: 500,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black.withOpacity(0.5),
                                            ),
                                            child: Center(
                                              child: TextButton.icon(onPressed: (){},
                                                  icon:Icon(Icons.play_arrow,color: Colors.white,), label: Text("Trailer",style: TextStyle(color: Colors.white),)),
                                            ),

                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),



                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$movieName',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.solidStar,
                                                color: Colors.amber,
                                                size: 16,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "8.2",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                            category.length,
                                            (index) => Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: buildTag(category[index]),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: ReadMoreText(
                                          "$description",
                                          trimLines: 3,
                                          trimMode: TrimMode.Line,
                                          moreStyle:
                                              TextStyle(color: Colors.blue),
                                          lessStyle:
                                              TextStyle(color: Colors.blue),
                                          style: TextStyle(
                                              color: Colors.black,
                                              height: 1.5,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      CastAndCrewWidget(
                                        casts: jsonDecode(castsString),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),

                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Comments",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 20),
                                                ),
                                              ],
                                            ),
                                            buildCommentCard(reviews),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.15,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                              top: 60,
                              right: 20,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                              )),
                          Positioned(
                            bottom: 20,
                            left: 30,
                            right: 30,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => chooseshow(
                                            movieename: widget.movieename)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                height: 68,
                                child: Text(
                                  "Book Tickets",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }
                  },
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget buildTag(String title) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget buildCommentCard(String reviews) {
    var decodedReviews = List<Map<String, dynamic>>.from(jsonDecode(reviews));

    print("all revies are $decodedReviews and type is ${decodedReviews.runtimeType}");
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      height: 160,
      child: ListView.builder(
        itemCount: decodedReviews.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.redAccent,
            ),
            margin: EdgeInsets.only(right: 15),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                         "images/unknown.jpeg",
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        decodedReviews[index]["user"] ?? "Unknown User",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        decodedReviews[index]["description"] ?? "No description",
                        style: TextStyle(color: Colors.white60),
                      ),
                      SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                decodedReviews[index]["rating"]?.toString() ?? "0",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 12,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}

Future<List<String>> _fetchCastImages(String castsString) async {
  try {
    List<Map<String, dynamic>> castList =
        (jsonDecode(castsString) as List<dynamic>).cast<Map<String, dynamic>>();

    List<String> castImages = [];

    for (Map<String, dynamic> cast in castList) {
      String castImageName = cast['image'] as String;
      String imageUrl = await serv().downloadCastImages(castImageName);
      castImages.add(imageUrl);
    }

    return castImages;
  } catch (e) {
    print('Error decoding cast images: $e');
    return [];
  }
}

class CastAndCrewWidget extends StatefulWidget {
  final List casts;

  const CastAndCrewWidget({
    Key? key,
    required this.casts,
  }) : super(key: key);

  @override
  State<CastAndCrewWidget> createState() => _CastAndCrewWidgetState();
}

class _CastAndCrewWidgetState extends State<CastAndCrewWidget> {
  Future<List<String>> _fetchCastImages(List castList) async {
    List<String> castImages = [];

    for (var cast in castList) {
      String imageName = cast['image'];
      print('Fetching URL for image: $imageName');

      if (imageName.isNotEmpty) {
        String imageUrl = await serv().downloadCastImages(imageName);
        castImages.add(imageUrl);
      } else {
        castImages.add('images/profile.png');
      }
    }

    return castImages;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cast",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
          ),
          SizedBox(
            height: 130,
            child: FutureBuilder<List<String>>(
              future: _fetchCastImages(
                widget.casts is List
                    ? widget.casts
                    : (widget.casts is String
                        ? jsonDecode(widget.casts as String)
                        : []),
              ),
              builder: (context, snapshot) {
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

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No cast images available'),
                  );
                }

                List<String> castImages = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.casts.length,
                  itemBuilder: (context, index) {
                    return castCard(widget.casts[index], castImages[index]);
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget castCard(final Map cast, String castImage) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: 80,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              image: DecorationImage(
                image: NetworkImage(castImage),
                fit: BoxFit.cover,
              ),
            ),
            height: 70,
          ),
          SizedBox(height: 8),
          Expanded(
            child: Text(
              cast["name"],
              maxLines: 3,
              textAlign: TextAlign.left,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }
}
