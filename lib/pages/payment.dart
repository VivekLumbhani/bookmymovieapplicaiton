import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nookmyseatapplication/pages/services/shared_pref.dart';
import 'package:nookmyseatapplication/pages/test_home.dart';

class PaymentScreen extends StatefulWidget {
  final movieid;
  final date;
  final moviename;
  final cinemaname;
  final selecttime;
  final seats;
  final amount;
  final seatingArr;


  const PaymentScreen({Key? key, this.movieid, this.date, this.moviename, this.cinemaname, this.selecttime, this.seats, this.amount, this.seatingArr}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _type = -1;

  void _handleRadio(Object? value) {
    if (value != null && value is int) {
      setState(() {
        _type = value;
      });
    }
  }
  String? nameoftheuser;


  Future<void> initializeUserName() async {
    nameoftheuser = await SharedPreferenceHelper().getUserName();
    setState(() {}); // Update the UI after obtaining the user name
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeUserName();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    String price=widget.amount;
    double totbill=double.parse(price);
    double addedbill=totbill+50;
    return Scaffold(
        appBar: AppBar(
          title: Text("Payment Screen"),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 40,),
                  Container(
                    width: size.width,
                    height: 70,
                    decoration: BoxDecoration(
                      border: _type == 1
                          ? Border.all(width: 1, color: const Color(0xFFDB3022))
                          : Border.all(width: 0.3, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                    value: 1,
                                    groupValue: _type,
                                    onChanged: _handleRadio,
                                    activeColor: Color(0xFFDB3022),
                                  ),
                                  Text(
                                    "Amazon Pay",
                                    style: _type == 1
                                        ? TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )
                                        : TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              "assets/paymentproviders/amazonpay.png",
                              width: 120,
                              height: 22,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15,),
                  Container(
                    width: size.width,
                    height: 70,
                    decoration: BoxDecoration(
                      border: _type == 1
                          ? Border.all(width: 1, color: const Color(0xFFDB3022))
                          : Border.all(width: 0.3, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                    value: 2,
                                    groupValue: _type,
                                    onChanged: _handleRadio,
                                    activeColor: Color(0xFFDB3022),
                                  ),
                                  Text(
                                    "Debit/Credit cards",
                                    style: _type == 1
                                        ? TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )
                                        : TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              "assets/paymentproviders/visa.png",
                              width: 120,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15,),
                  Container(
                    width: size.width,
                    height: 75,
                    decoration: BoxDecoration(
                      border: _type == 1
                          ? Border.all(width: 1, color: const Color(0xFFDB3022))
                          : Border.all(width: 0.3, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                    value: 3,
                                    groupValue: _type,
                                    onChanged: _handleRadio,
                                    activeColor: Color(0xFFDB3022),
                                  ),
                                  Text(
                                    "BHIM/Upi",
                                    style: _type == 1
                                        ? TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )
                                        : TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              "assets/paymentproviders/bhimupi.png",
                              width: 125,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    width: size.width,
                    height: 80,
                    decoration: BoxDecoration(
                      border: _type == 1
                          ? Border.all(width: 1, color: const Color(0xFFDB3022))
                          : Border.all(width: 0.3, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                    value: 4,
                                    groupValue: _type,
                                    onChanged: _handleRadio,
                                    activeColor: Color(0xFFDB3022),
                                  ),
                                  Text(
                                    "Gpay",
                                    style: _type == 1
                                        ? TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )
                                        : TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              "assets/paymentproviders/gpay.png",
                              width: 125,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Sub-Total",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.grey,),),
                      Text(totbill.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey,))
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text("Convinience fee",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.grey,),),
                      Text("50",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.grey,))
                    ],
                  ),
                  Divider(height: 30,color: Colors.black,),

                  Row(                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text("Total Payment",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.grey,),),
                      Text(addedbill.toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.redAccent,))
                    ],
                  ),
                  SizedBox(height: 70,),
                  InkWell(
                    onTap: () async {
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
                            'totalCharge': widget.amount,
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
                                  : 'Your booking is successfully added and your Total is \$${widget.amount }'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomeScreen()),
                                    );                                  },
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

                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xFFDB3022), // Red color from the image
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Center(
                        child: Text(
                          "Confirm Payment",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                ],

              ),
            ),
          ),
        )
    );
  }
}
