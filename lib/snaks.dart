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
    {'name': 'Popcorn', 'price': 200.0, 'image': 'assets/snaksimg/popcorn.png'},
    {'name': 'Coke', 'price': 70.0, 'image': 'assets/snaksimg/coke.png'},
    {'name': 'Chips', 'price': 50.0, 'image': 'assets/snaksimg/chips.png'},
  ];



  Map<String, int> snackQuantity = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snack Booking'),
        actions: [

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                      movieid: widget.movieid,
                      date: widget.date,
                      moviename: widget.moviename,
                      cinemaname: widget.cinemaname,
                      selecttime: widget.selecttime,
                      seats: widget.seats,
                      amount: totalBill.toStringAsFixed(2),
                      seatingArr:widget.seatingArr
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
          final price=snack["price"];

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
                        "$snackName \t $price",
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
              //
              // Text(
              //   'Total Bill: \u20B9 ${totalBill.toStringAsFixed(2)}',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),

              ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        movieid: widget.movieid,
                        date: widget.date,
                        moviename: widget.moviename,
                        cinemaname: widget.cinemaname,
                        selecttime: widget.selecttime,
                        seats: widget.seats,
                        amount: totalBill.toStringAsFixed(2),
                        seatingArr:widget.seatingArr
                      ),
                    ),
                  );


                },

                child: Text('CheckOut \u20B9 ${totalBill.toStringAsFixed(2) }',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ),
      ),

    );
  }
}

