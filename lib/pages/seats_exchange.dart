import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nookmyseatapplication/pages/services/shared_pref.dart';

class seats_exchange extends StatefulWidget {
  final name, email;

  const seats_exchange({Key? key, this.name, this.email}) : super(key: key);

  @override
  State<seats_exchange> createState() => _seats_exchangeState();
}

class _seats_exchangeState extends State<seats_exchange> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var ticketDateTime;
  var mycurrentemail = FirebaseAuth.instance.currentUser;

  String? selectedMovie;
  String? selecetdMovieId;
  List<String> availableSeats = [];
  List<String> selectedSeats = [];
  List<String> movieNames = [];
  List<String> movieIds = [];
  List<String> forsenderschange=[];
  Map<String, List<String>> movieSeats = {};

  String? myName, myEmail;

  gettheSharedPref() async {
    myName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
  }

  @override
  void initState() {
    print("name is ${widget.name} and email is ${widget.email}");
    super.initState();
    gettheSharedPref();
  }

  void logSelectedSeats() {
    if (selectedMovie != null && selectedSeats.isNotEmpty) {
      print("Selected Movie: $selectedMovie");
      print("movie id $selecetdMovieId");
      print("Selected Seats users selected: $selectedSeats");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('personalbooking')
            .where('username', isEqualTo: mycurrentemail?.email.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            snapshot.data!.docs.forEach((document) {
              final data = document.data() as Map<String, dynamic>;
              final movieName = data['movieName'] as String;
              final movieId = data["movieId"] as String?;

              final selectedSeatsString = data['selectedSeats'] as String;

              final selectedSeatsList =jsonDecode(selectedSeatsString).cast<String>();


              if (!movieNames.contains(movieName)) {
                movieNames.add(movieName);
                movieIds.add(movieId ?? '');
                movieSeats[movieName] = selectedSeatsList;
              }
            });

            if (selectedMovie != null) {
              availableSeats = [...movieSeats[selectedMovie] ?? []];
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: DropdownButton<String>(
                  value: selectedMovie,
                  onChanged: (value) {
                    setState(() {
                      selectedMovie = value;
                      selecetdMovieId = movieIds[movieNames
                          .indexOf(value!)]; // Update selected movie id
                      availableSeats = [...movieSeats[value] ?? []];
                    });
                  },
                  items: movieNames
                      .map((movieName) => DropdownMenuItem<String>(
                            value: movieName,
                            child: Text(movieName),
                          ))
                      .toList(),
                  hint: Text('Select a movie'),
                ),
              ),
              SizedBox(height: 20),
              if (selectedMovie != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Seats:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      children: availableSeats
                          .map((seat) => CheckboxListTile(
                                value: selectedSeats.contains(seat),

                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      selectedSeats.add(seat);
                                    } else {
                                      selectedSeats.remove(seat);
                                    }
                                    print("Selected Seats users: $selectedSeats");
                                  });
                                },
                                title: Text(seat),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: selectedSeats.isNotEmpty
                            ? () {


                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Transfer Confirmation"),
                                content: Text(
                                    "Are you sure you want to transfer the selected seats to ${widget.name}?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("No"),
                                  ),
                                  TextButton(

                                    onPressed: () {
                                      Navigator.of(context).pop();

                                      Navigator.of(context).pop();

                                      _firestore.collection("personalbooking")
                                          .where("movieId", isEqualTo: selecetdMovieId)
                                          .where("username", isEqualTo: mycurrentemail!.email.toString())
                                          .get()
                                          .then((QuerySnapshot senderQuerySnapshot) {
                                        senderQuerySnapshot.docs.forEach((doc) {
                                          var receiversseats = "";
                                          var sendersseats = "";
                                          _firestore
                                              .collection('personalbooking')
                                              .where('movieId', isEqualTo: selecetdMovieId)
                                              .where('username', isEqualTo: widget.email)
                                              .get()
                                              .then((QuerySnapshot querySnapshot) {
                                            querySnapshot.docs.forEach((doc) {
                                              receiversseats = doc["selectedSeats"];

                                              List<dynamic> receiversseatsList = jsonDecode(receiversseats) as List<dynamic>;
                                              List<String> selectedSeatsList = selectedSeats.cast<String>();

                                              List<dynamic> combinedSeatsList = [...receiversseatsList, ...selectedSeatsList];
                                              String finalSeats = jsonEncode(combinedSeatsList);

                                              // Update the receiver's document
                                              var receiverDocRef = _firestore.collection('personalbooking').doc(doc.id);
                                              receiverDocRef.update({
                                                "selectedSeats": finalSeats,
                                              }).then((_) {
                                                print("Receiver's document updated successfully!");
                                              }).catchError((error) {
                                                print("Failed to update receiver's document: $error");
                                              });
                                            });
                                          }).catchError((error) => print("Failed to search: $error"));

                                          sendersseats = doc["selectedSeats"];

                                          List<dynamic> sendersseatsList = jsonDecode(sendersseats) as List<dynamic>;
                                          List<String> selectedSeatsList = selectedSeats.cast<String>();

                                          forsenderschange = selectedSeats.cast<String>();

                                          forsenderschange.forEach((seat) {
                                            sendersseatsList.removeWhere((senderSeat) => seat == senderSeat);
                                          });

                                          String finalSeatsofsender = jsonEncode(sendersseatsList);

                                          // Update the sender's document
                                          var senderDocRef = _firestore.collection('personalbooking').doc(doc.id);
                                          senderDocRef.update({
                                            "selectedSeats": finalSeatsofsender,
                                          }).then((_) {
                                            print("Sender's document updated successfully!");
                                          }).catchError((error) {
                                            print("Failed to update sender's document: $error");
                                          });
                                        });
                                      });
                                      logSelectedSeats();
                                    },

                                    child: Text("Yes"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                            : null,
                        child: Text('Transfer'),
                      ),
                    ),

                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
