import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nookmyseatapplication/pages/detail_of_tickets.dart';
import 'package:nookmyseatapplication/pages/navbar.dart';
import 'package:intl/intl.dart'; // Import the intl package

class booked extends StatefulWidget {
  const booked({Key? key}) : super(key: key);

  @override
  State<booked> createState() => _BookedScreenState();
}

class _BookedScreenState extends State<booked> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  var ticketDateTime;
  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bookings"), centerTitle: true),
      drawer: navbar(email: _user!.email.toString()),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('personalbooking')
            .where('username', isEqualTo: _user!.email.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("You haven't made any bookings yet."),
            );
          }

          List<Widget> bookingCards = snapshot.data!.docs
              .map((document) {
                final data = document.data() as Map<String, dynamic>;
                final movieId = data['movieId'];
                final date = data['date'];
                final movieName = data['movieName'];
                final timeOf = data['timeof'];
                final selectedSeats = data['selectedSeats'];
                final cleanedDate = date.replaceAll(RegExp(r'\s+'), ' ').trim();
                final movieIdToSearch = data['movieSearchId'];


                final seatingArrangement=data["seatingArrangement"];
                final cinemaName=data['cinemaName'];
                print(
                    "date is $date and time is $timeOf and cleaned time is $cleanedDate");

                final parsedDate = DateFormat("dd/MMM E").parse(cleanedDate);
                final fixedYear = 2024;

                if (parsedDate != null) {
                  final parsedTime = DateFormat.jm().parse(timeOf);

                  ticketDateTime = DateTime(
                    fixedYear,
                    parsedDate.month,
                    parsedDate.day,
                    parsedTime.hour,
                    parsedTime.minute,
                    DateTime.now().timeZoneOffset.inMinutes,
                  );

                  print(
                      "date time is $ticketDateTime and comparison is with ${DateTime.now()}");

                  print(
                      "current time is ${DateTime.now()} and movie time is $ticketDateTime");

                  if (DateTime.now().isAfter(ticketDateTime)) {
                    return null;
                  }
                }

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Movie: $movieName'),
                    subtitle: Text(
                        'Date: $date, Time: $timeOf \n Seats: $selectedSeats'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ticketDetailsScreen(
                                  movieename: movieIdToSearch,

                                  selectedSeats:selectedSeats,
                                  seatingArrangement:seatingArrangement,
                                  cinemaName:cinemaName,
                                  time:timeOf,
                                  date:date,
                                  movieId:movieId,
                                  ticketDateTime:ticketDateTime,
                                  movieIdToSearch:movieName
                              )),
                        );
                      },
                      child: Text('Deatils'),
                    ),
                  ),
                );
              })
              .where((widget) => widget != null)
              .cast<Widget>()
              .toList();

          return ListView(
            children: bookingCards,
          );
        },
      ),
    );
  }
}
