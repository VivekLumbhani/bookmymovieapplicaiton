import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nookmyseatapplication/pages/payment.dart';
import 'package:nookmyseatapplication/pages/services/shared_pref.dart';

class SnackBooking extends StatefulWidget {
  final movieid;
  final date;
  final moviename;
  final cinemaname;
  final selecttime;
  final seats;
  final amount;
  final seatingArr;

  const SnackBooking({Key? key, this.movieid, this.date, this.moviename, this.cinemaname, this.selecttime, this.seats, this.amount, this.seatingArr}) : super(key: key);

  @override
  _SnackBookingState createState() => _SnackBookingState();
}

class _SnackBookingState extends State<SnackBooking> {
  double totalBill =0.0;

  String? nameoftheuser;
  @override
  void initState() {
    super.initState();

    initializeUserName();
    totalBill = widget.amount ?? 0.0;
  }

  Future<void> initializeUserName() async {
    nameoftheuser = await SharedPreferenceHelper().getUserName();
    setState(() {}); // Update the UI after obtaining the user name
  }
  List<Map<String, dynamic>> snacks = [
    {'name': 'Popcorn', 'price': 5.0, 'image': 'assets/snaksimg/popcorn.png'},
    {'name': 'Coke', 'price': 2.5, 'image': 'assets/snaksimg/coke.png'},
    {'name': 'Chips', 'price': 3.0, 'image': 'assets/snaksimg/chips.png'},
  ];



  Map<String, int> snackQuantity = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snack Booking'),
        actions: [
          // Skip button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                    // movieid: widget.movieename,
                    // date: widget.date,
                    // moviename: widget.oriname,
                    // cinemaname: widget.cinemaname,
                    // selecttime: widget.selectTime,
                    // seats: selectedSeats,
                    // amount: totalBill,
                  ),
                ),
              );
            },
            icon: Icon(Icons.skip_next),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: snacks.length,
        itemBuilder: (context, index) {
          final snack = snacks[index];
          final snackName = snack['name'];

          return ListTile(
            contentPadding: EdgeInsets.all(16.0),
            title: Row(
              children: [
                // Text and buttons on the left side
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snackName,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          // Minus button
                          IconButton(
                            onPressed: () {
                              setState(() {
                                snackQuantity[snackName] = (snackQuantity[snackName] ?? 0) - 1;
                                if (snackQuantity[snackName]! >= 0) {
                                  totalBill -= snack['price'];
                                }
                              });
                            },
                            icon: Icon(Icons.remove),
                          ),
                          // Quantity text
                          Text(
                            '${snackQuantity[snackName] ?? 0}',
                            style: TextStyle(fontSize: 18),
                          ),
                          // Plus button
                          IconButton(
                            onPressed: () {
                              setState(() {
                                snackQuantity[snackName] = (snackQuantity[snackName] ?? 0) + 1;
                                totalBill += snack['price'];
                              });
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.0),
                // Image on the right side
                Image.asset(
                  snack['image'],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            onTap: () {
            },
          );

        },
      ),

      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 16.0), // Add padding for better appearance
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                'Total Bill: \u20B9 ${totalBill.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              ElevatedButton(
                onPressed: () async {
                  final username = FirebaseAuth.instance.currentUser;
                  final docid = widget.movieid;
                  final date = widget.date;
                  final timeof = widget.selecttime;

                  final id = docid! + timeof! + date!;
                  print('id to be inserted is ${id.trim()}');

                  final selectedSeatsString = jsonEncode(widget.seats);

                  final bookingSnapshot = await FirebaseFirestore
                      .instance
                      .collection('bookings')
                      .where('movieId', isEqualTo: id)
                      .get();


                  Future<void> handleBooking(bool isPersonalBooking) async {
                    final snapshot = await FirebaseFirestore.instance
                        .collection(isPersonalBooking
                        ? 'personalbooking'
                        : 'bookings')
                        .where('movieId', isEqualTo: id)
                        .where('username', isEqualTo: username!.email.toString())
                        .get();

                    if (snapshot.docs.isNotEmpty) {
                      final existingDoc = snapshot.docs.first;
                      final existingId = existingDoc.id;
                      final existingSeats = existingDoc['selectedSeats'] as String;
                      final List<dynamic> updatedSeatsList = jsonDecode(existingSeats);
                      updatedSeatsList.addAll(widget.seats);

                      await FirebaseFirestore.instance
                          .collection(isPersonalBooking
                          ? 'personalbooking'
                          : 'bookings')
                          .doc(existingId)
                          .update({'selectedSeats': jsonEncode(updatedSeatsList)});
                    } else {
                      final bookingData = {
                        'username': username!.email.toString(),
                        'movieId': id,
                        'date': date,
                        'nameoftheuser':nameoftheuser,
                        'movieSearchId':widget.movieid,
                        'movieName': widget.moviename,
                        'timeof': timeof,
                        'cinemaName': widget.cinemaname,
                        'totalCharge': widget.amount + totalBill,
                        'selectedSeats': selectedSeatsString,
                        'seatingArrangement':widget.seatingArr.toString()
                      };

                      await FirebaseFirestore.instance
                          .collection(isPersonalBooking
                          ? 'personalbooking'
                          : 'bookings')
                          .add(bookingData);
                    }

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(isPersonalBooking
                              ? 'Booking Updated'
                              : 'Booking Successful'),
                          content: Text(isPersonalBooking
                              ? 'Your booking has been updated with the new seat information.'
                              : 'Your booking is successfully added and your Total is \$${widget.amount + totalBill}'),
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


                  final isPersonalBooking = widget.amount != null;

                  if (bookingSnapshot.docs.isNotEmpty) {
                    final existingBookingDoc = bookingSnapshot.docs.first;
                    final existingBookingId = existingBookingDoc.id;
                    final existingSeats =
                    existingBookingDoc['selectedSeats'] as String;
                    final List<dynamic> updatedSeatsList = jsonDecode(existingSeats);
                    updatedSeatsList.addAll(widget.seats);

                    await FirebaseFirestore.instance
                        .collection('bookings')
                        .doc(existingBookingId)
                        .update({'selectedSeats': jsonEncode(updatedSeatsList)});

                    await handleBooking(isPersonalBooking);
                  } else {
                    var seatingarr=widget.seatingArr;

                    final bookingData = {'movieId': id, 'selectedSeats': selectedSeatsString,'seatingArrangement':seatingarr.toString()};
                    await FirebaseFirestore.instance
                        .collection('bookings')
                        .add(bookingData);

                    await handleBooking(isPersonalBooking);
                  }
                },
                child: Text('book \$${widget.amount + totalBill}'),
              ),
            ],
          ),
        ),
      ),

    );
  }
}

