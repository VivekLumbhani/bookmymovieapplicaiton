import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:nookmyseatapplication/pages/seats_update.dart';
import 'package:nookmyseatapplication/pages/serv.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ticketDetailsScreen extends StatefulWidget {
  final movieename;
  final selectedSeats;
  final movieId;
  final seatingArrangement;
  final cinemaName;
  final time;
  final date;
  final ticketDateTime;
  final movieIdToSearch;

  const ticketDetailsScreen({
    Key? key,
    this.movieename,
    this.selectedSeats,
    this.seatingArrangement,
    this.cinemaName,
    this.time,
    this.date,
    this.ticketDateTime,
    this.movieIdToSearch,
    this.movieId,
  }) : super(key: key);

  @override
  State<ticketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<ticketDetailsScreen> {
  var data;
  var expiryDate;
  var casts;
  var date;
  var imgName;
  var castsString;
  var movieName;
  var category;
  var description;
  var link;
  var time;
  var movieId;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SeatsUpdate(
                          movieename: widget.movieId,
                          oriname: widget.movieIdToSearch,
                          selectedSeats: widget.selectedSeats,
                          seatingArrangement: widget.seatingArrangement,
                          cinemaname: widget.cinemaName,
                          selectTime: widget.time,
                          date: date,
                        )),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: Text('Confirmation'),
                    content: Text(
                        'Are you sure you want to cancel your ticket fully?'),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            QuerySnapshot<Map<String, dynamic>> queryUpdate =
                                await _firestore
                                    .collection('bookings')
                                    .where('movieId',
                                        isEqualTo: widget.movieId)
                                    .get();

                            for (QueryDocumentSnapshot documentSnapshot
                                in queryUpdate.docs) {
                              var existingDoc = documentSnapshot.data()
                                  as Map<String, dynamic>?;

                              if (existingDoc != null) {
                                var seatsString =
                                    existingDoc['selectedSeats'] as String?;

                                if (seatsString != null) {
                                  var seatsList =
                                      jsonDecode(seatsString) as List<dynamic>;
                                  var userSeats =
                                      jsonDecode(widget.selectedSeats);

                                  seatsList.removeWhere(
                                      (seat) => userSeats.contains(seat));

                                  await documentSnapshot.reference.update({
                                    'selectedSeats': jsonEncode(seatsList),
                                  });
                                }
                              } else {
                                print("id not found ${widget.movieIdToSearch}");
                              }
                            }

                            QuerySnapshot<Map<String, dynamic>> querySnapshot =
                                await _firestore
                                    .collection('personalbooking')
                                    .where('username', isEqualTo: _user?.email)
                                    .where('movieId',
                                        isEqualTo: widget.movieId)
                                    .get();

                            for (QueryDocumentSnapshot documentSnapshot
                                in querySnapshot.docs) {
                              print(
                                  "id found to be deleted ${widget.movieIdToSearch}");
                              await documentSnapshot.reference.delete();
                            }

                            Navigator.of(dialogContext).pop();
                          } catch (e) {
                            print("error is $e");
                          }
                        },
                        child: Text('Yes'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print("no clicked ${widget.movieIdToSearch}");
                          Navigator.of(dialogContext).pop();
                        },
                        child: Text('No'),
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
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
          imgName = data['imgname'] as String;
          castsString = data['casts'] as String;
          movieName = data['movieName'] as String;
          category = data['categories'] as List;
          description = data['descriptionOfMovie'] as String;
          link = data['link'] as String;
          print("data is ${widget.selectedSeats}");
          var tostr = widget.ticketDateTime.toString();
          DateTime dateTime = DateTime.parse(tostr);

          var seatsString = widget.selectedSeats;
          var seatsList = jsonDecode(seatsString) as List<dynamic>;

          var seatsInAlphabets = seatsList.map((seatString) {
            var firstDigit = int.parse(seatString.split('-')[0]);

            var alphabet = String.fromCharCode(65 + firstDigit);

            return seatString.replaceFirst(RegExp(r'^\d+'), alphabet);
          }).toList();

          print("seats are $seatsInAlphabets");

          print("seats are $seatsInAlphabets");

          print("seats are $seatsInAlphabets");
          String formattedDate =
              "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

          return FutureBuilder<String>(
            future: serv().downloadurl(imgName),
            builder: (BuildContext context,
                AsyncSnapshot<String> movieImageSnapshot) {
              if (movieImageSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (movieImageSnapshot.hasError) {
                return Center(
                  child:
                      Text('Error loading image: ${movieImageSnapshot.error}'),
                );
              }

              final imageUrl = movieImageSnapshot.data;

              var obj = {
                "seats": "${widget.selectedSeats}",
                "date": formattedDate,
                "time": widget.time,
                "venue": "${widget.cinemaName}",
              };
              return // ... existing code ...

                  Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Image at the top
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: imageUrl != null
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Text('Image not available'),
                              ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Card with movie details
                    Expanded(
                      child: SingleChildScrollView(
                        child: Card(
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movieName,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Divider(),
                                //
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Date',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          '${formattedDate}',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Time',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          '${widget.time}',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w500),
                                        ), // Replace with actual time from data
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Venue',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            '${widget.cinemaName}',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Seats',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            "${seatsInAlphabets}",
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16),

                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      QrImageView(
                                        data: obj.toString(),
                                        version: QrVersions.auto,
                                        size: 200.0,
                                      ),
                                      SizedBox(height: 16),
                                      Text('Scan QR Code'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
              ;
            },
          );
        },
      ),
    );
  }
}
