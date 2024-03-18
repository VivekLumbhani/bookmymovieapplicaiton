
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nookmyseatapplication/pages/choose.dart';

import '../../colors.dart';
import '../serv.dart';

class CustomCardThumnail extends StatefulWidget {

  const CustomCardThumnail();

  @override
  State<CustomCardThumnail> createState() => _CustomCardThumnailState();
}

class _CustomCardThumnailState extends State<CustomCardThumnail> {
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
              String movieid = doc.id ?? 'not found';
              String moviename = moviedet['movieName'] ?? 'Unknown Bus';
              String releaseDate=moviedet['date']??'';

              String imgname = moviedet['imgname'] ?? 'Unknown seats';
              String movieexpdate = moviedet['expiryDate'];

              DateTime expdate = DateTime.parse(movieexpdate);
              DateTime relDate=DateTime.parse(releaseDate);
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
                    if (currentDate.isBefore(expdate) && !relDate.isAfter(currentDate)) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      chooseshow(movieename: movieid),
                                ),
                              );
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: MediaQuery.of(context).size.width * 0.5,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '4.5', // Static rating
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
                                        '1000', // Static total votes
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
                                          maxLines: 5, // Specify maximum number of lines to show

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
