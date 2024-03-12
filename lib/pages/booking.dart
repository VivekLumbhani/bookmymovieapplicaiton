import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class bookings extends StatefulWidget {
  final String? movieename;
  final String? date;
  final String? timeof;
  final String? oriname;
  final String? cinemaname;
  final String? seatingArrangement;
  const bookings(
      {required this.movieename,
      required this.date,
      this.timeof,
      this.oriname,
      this.cinemaname,
      this.seatingArrangement});

  @override
  State<bookings> createState() => _bookings();
}

class _bookings extends State<bookings> {
  double scale = 1.0;
  String? docid;
  String? date;
  String? timeof;
  String? oriname;
  String? cinemaname;
  String? priceofseat;
  String? seatingArrangement;
  double totalCharge = 0.0;

  List<bool> selectedSeats = List.generate(100, (index) => false);
  List<int> selectedSeatIndices = [];
  List<int> reservedSeats = [];
  var username = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    date = widget.date;
    timeof = widget.timeof;
    oriname = widget.oriname;
    priceofseat = "100";
    cinemaname = widget.cinemaname;
    seatingArrangement = widget.seatingArrangement;
    final docid = widget.movieename;
    final idtochek = docid! + timeof! + date!;

    print("seating arrangement: $seatingArrangement");

    print(
        "docid is $docid and date is $date /n \n $timeof \n  $idtochek price \n $priceofseat seating arrangement \n $seatingArrangement");

    FirebaseFirestore.instance
        .collection('bookings')
        .where('movieId', isEqualTo: idtochek)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        List<int> reserved = [];
        for (var doc in querySnapshot.docs) {
          String seats = doc['selectedSeats'];
          List<int> selectedSeats = jsonDecode(seats).cast<int>();

          for (var seat in selectedSeats) {
            reserved.add(int.parse(seat.toString()));
          }
        }
        setState(() {
          reservedSeats = reserved;
          print("reserved seats are $reservedSeats");
        });
      }
    });
  }

  void toggleSeatSelection(int index) {
    setState(() {
      if (reservedSeats.contains(index)) {
        return;
      }

      selectedSeats[index] = !selectedSeats[index];
      if (selectedSeats[index]) {
        totalCharge += double.parse(priceofseat!);
        selectedSeatIndices.add(index);
      } else {
        totalCharge -= double.parse(priceofseat!);
        selectedSeatIndices.remove(index);
      }
    });
  }

  Future<void> _startBookingTimer(
      String movieid, String date, String moviename, String time) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int currentTime = DateTime.now().millisecondsSinceEpoch;
    prefs.setInt(movieid, currentTime);

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Bookings'),
          centerTitle: true,
        ),
        body: Center(
          child: GestureDetector(
            onScaleUpdate: (details) {
              setState(() {
                scale = details.scale.clamp(0.5, 2.0);
              });
            },
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 400,
                height: 600, // Set a fixed height for the container
                transformAlignment: Alignment.center,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: selectedSeatIndices.isEmpty
                          ? null
                          : () async {
                              final username =
                                  FirebaseAuth.instance.currentUser;
                              final docid = widget.movieename;
                              final date = widget.date;

                              final id = docid! + timeof! + date!;
                              print('id to be inserted is ${id.trim()}');

                              final selectedSeatsString =
                                  jsonEncode(selectedSeatIndices);

                              final bookingSnapshot = await FirebaseFirestore
                                  .instance
                                  .collection('bookings')
                                  .where('movieId', isEqualTo: id)
                                  .get();

                              if (bookingSnapshot.docs.isNotEmpty) {
                                final existingBookingDoc =
                                    bookingSnapshot.docs.first;
                                final existingBookingId = existingBookingDoc.id;
                                final existingSeats =
                                    existingBookingDoc['selectedSeats']
                                        as String;
                                final List<dynamic> updatedSeatsList =
                                    jsonDecode(existingSeats);
                                updatedSeatsList.addAll(selectedSeatIndices);

                                await FirebaseFirestore.instance
                                    .collection('bookings')
                                    .doc(existingBookingId)
                                    .update({
                                  'selectedSeats': jsonEncode(updatedSeatsList)
                                });
                                final personalBookingSnapshot =
                                    await FirebaseFirestore.instance
                                        .collection('personalbooking')
                                        .where('movieId', isEqualTo: id)
                                        .where('username',
                                            isEqualTo:
                                                username!.email.toString())
                                        .get();

                                if (personalBookingSnapshot.docs.isNotEmpty) {
                                  final existingPersonalBookingDoc =
                                      personalBookingSnapshot.docs.first;
                                  final existingPersonalBookingId =
                                      existingPersonalBookingDoc.id;
                                  final existingSeats =
                                      existingPersonalBookingDoc[
                                          'selectedSeats'] as String;
                                  final List<dynamic> updatedSeatsList =
                                      jsonDecode(existingSeats);
                                  updatedSeatsList.addAll(selectedSeatIndices);

                                  await FirebaseFirestore.instance
                                      .collection('personalbooking')
                                      .doc(existingPersonalBookingId)
                                      .update({
                                    'selectedSeats':
                                        jsonEncode(updatedSeatsList)
                                  });
                                } else {
                                  await _startBookingTimer(
                                      id, date, oriname!, timeof!);

                                  final personalBookingData = {
                                    'username': username!.email.toString(),
                                    'movieId': id,
                                    'date': date,
                                    'movieName': oriname,
                                    'timeof': timeof,
                                    'cinemaName': cinemaname,
                                    'totalCharge': totalCharge,
                                    'selectedSeats': selectedSeatsString,
                                  };
                                  await FirebaseFirestore.instance
                                      .collection('personalbooking')
                                      .add(personalBookingData);
                                }

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Booking Updated'),
                                      content: Text(
                                          'Your booking has been updated with the new seat information.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                final bookingData = {
                                  'movieId': id,
                                  'selectedSeats': selectedSeatsString,
                                };
                                await FirebaseFirestore.instance
                                    .collection('bookings')
                                    .add(bookingData);
                                final personalBookingSnapshot =
                                    await FirebaseFirestore.instance
                                        .collection('personalbooking')
                                        .where('movieId', isEqualTo: id)
                                        .get();

                                if (personalBookingSnapshot.docs.isNotEmpty) {
                                  final existingPersonalBookingDoc =
                                      personalBookingSnapshot.docs.first;
                                  final existingPersonalBookingId =
                                      existingPersonalBookingDoc.id;
                                  final existingSeats =
                                      existingPersonalBookingDoc[
                                          'selectedSeats'] as String;
                                  final List<dynamic> updatedSeatsList =
                                      jsonDecode(existingSeats);
                                  updatedSeatsList.addAll(selectedSeatIndices);

                                  await FirebaseFirestore.instance
                                      .collection('personalbooking')
                                      .doc(existingPersonalBookingId)
                                      .update({
                                    'selectedSeats':
                                        jsonEncode(updatedSeatsList)
                                  });
                                } else {
                                  final personalBookingData = {
                                    'username': username!.email.toString(),
                                    'movieId': id,
                                    'date': date,
                                    'movieName': oriname,
                                    'timeof': timeof,
                                    'cinemaName': cinemaname,
                                    'totalCharge': totalCharge,
                                    'selectedSeats': selectedSeatsString,
                                  };
                                  await FirebaseFirestore.instance
                                      .collection('personalbooking')
                                      .add(personalBookingData);
                                }

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Booking Successful'),
                                      content: Text(
                                          'Your booking is successfully added and your Total is $totalCharge'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                      child: Text('book 💲$totalCharge'),
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                        ),
                        itemBuilder: (context, index) {
                          final isReserved = reservedSeats.contains(index);
                          final isSelected = selectedSeats[index];
                          return GestureDetector(
                            onTap: () {
                              toggleSeatSelection(index);
                            },
                            child: Container(
                              margin: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                color: isReserved
                                    ? Colors.red
                                    : isSelected
                                        ? Colors.blue
                                        : Colors.green,
                              ),
                              child: Center(
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
