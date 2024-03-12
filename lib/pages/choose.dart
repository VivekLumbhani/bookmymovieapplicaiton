import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nookmyseatapplication/pages/select_seat.dart';
import 'navbar.dart';
import 'booking.dart'; // Import your 'booking' widget

class chooseshow extends StatefulWidget {
  final String? movieename;

  const chooseshow({required this.movieename});

  @override
  State<chooseshow> createState() => _ChooseShowState();
}

class _ChooseShowState extends State<chooseshow> {
  var user = FirebaseAuth.instance.currentUser;
  late TabController controller;
  String? docid;
  String? date;

  @override
  void initState() {
    super.initState();
    docid = widget.movieename;
    fetchData();
  }

  var movieTitle = "";
  var datesof = "";
  var expdate = "";
  var priceofseat = "";
  var seatingArrangement="";
  var theater="";
  List<Map<String, dynamic>> allTimeSlots = [];

  List<String> generateDateList(String startDate, String endDate) {
    List<String> dateList = [];
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);
    DateTime currentDate = DateTime.now();

    for (var i = currentDate; i.isBefore(end); i = i.add(Duration(days: 1))) {
      if (currentDate.isBefore(start)) {
      } else {
        String formattedDate =
            '${i.day}/${_getMonthName(i.month).substring(0, 3)} \n ${_getWeekdayName(i.weekday)}';
        dateList.add(formattedDate);
      }
    }
    print('datelist that is $dateList');
    return dateList;
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Sun';
      case 2:
        return 'Mon';
      case 3:
        return 'Tue';
      case 4:
        return 'Wed';
      case 5:
        return 'Thu';
      case 6:
        return 'Fri';
      case 7:
        return 'Sat';
      default:
        return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  List<Map<String, dynamic>> theatersList = [];

  Future<void> fetchData() async {
    try {
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('buscollections').doc(docid).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          movieTitle = data['movieName'] ?? '';
          datesof = data['date'] ?? '';
          expdate = data['expiryDate'] ?? '';
          dateList = generateDateList(datesof, expdate);
          priceofseat = data['price'] ?? '';
          theater=data["theaters"]??'';
          final theatersData = jsonDecode(data['theaters']);
          if (theatersData is List) {
            theatersList = theatersData.cast<Map<String, dynamic>>();
          }

          print('$movieTitle and ${widget.movieename.toString()} and $datesof and $expdate)');
          setState(() {});
        }
      } else {
        print('Document does not exist');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  List<String> dateList = [];

  int current = 0;
  void _selectTimeSlot(String cinemaName, List<dynamic> dynamicTimes) {
    List<Map<String, dynamic>> slots = [];

    if (dynamicTimes != null) {
      for (var dynamicTime in dynamicTimes) {
        int hour = dynamicTime['hour'];
        int minute = dynamicTime['minute'];

        DateTime showTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          hour,
          minute,
        );
        DateTime currentDateTime = DateTime.now();
        String time;


          time = DateFormat.jm().format(showTime);

        print("times are $time");

        slots.add({
          'cinemaName': cinemaName,
          'time': time,
          'date': dateList[current],
        });

      }
    }
    print("all slots are $slots");

    setState(() {
      allTimeSlots = slots;
    });
  }
  String realforMovieTime = ''; // Declare realTime outside the loop

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(5),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: dateList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Visibility(
                              visible: current == index,
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            );
                            setState(() {
                              current = index;
                            });
                          },
                          child: AnimatedContainer(
                            margin: EdgeInsets.all(1),
                            width: 80,
                            height: 45,
                            decoration: BoxDecoration(
                              color: current == index
                                  ? Colors.red
                                  : Colors.white54,
                              borderRadius: current == index
                                  ? BorderRadius.circular(15)
                                  : BorderRadius.circular(10),

                            ),
                            duration: Duration(milliseconds: 300),
                            child: Center(
                              child: Text(
                                dateList[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: current == index
                                      ? Colors.white
                                      : Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Column(
                children: theatersList.map((theater) {
                  final cinemaName = theater['cinemaName'];
                  final dynamicTimes = theater['dynamicTimes'];

                  List<Widget> timeSlots = [];


                  if (dynamicTimes != null) {
                    for (var dynamicTime in dynamicTimes) {
                      int hour = dynamicTime['hour'];
                      int minute = dynamicTime['minute'];

                      DateTime showTime = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        hour,
                        minute,
                      );

                      if (dateList[current] == '${DateTime.now().day}/${_getMonthName(DateTime.now().month).substring(0, 3)} \n ${_getWeekdayName(DateTime.now().weekday)}' &&
                          showTime.isAfter(DateTime.now())) {
                        // Format the showTime with AM/PM
                        String realTime = DateFormat.jm().format(showTime);
                        realforMovieTime = DateFormat.jm().format(showTime);

                        timeSlots.add(
                          GestureDetector(

                            child: Container(
                              width: 80,
                              height: 50.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Text(
                                  realforMovieTime,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              _selectTimeSlot(cinemaName, dynamicTimes);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SeatSelectionScreen(
                                      movieename: docid,
                                      date: dateList[current],
                                      oriname: movieTitle,
                                      seatingArrangement: jsonEncode(theater["seatings"]),
                                      cinemaname: cinemaName,
                                      allTimeSlots: allTimeSlots,
                                      selectTime:realforMovieTime

                                  ),
                                  //     bookings(
                                  //   movieename: docid,
                                  //   date: dateList[current],
                                  //   timeof: realforMovieTime,
                                  //   seatingArrangement:jsonEncode(theater['seatings']),
                                  //   oriname: movieTitle,
                                  //   cinemaname: cinemaName,
                                  // ),


                                ),
                              );
                            },
                          ),
                        );
                      } else if (dateList[current] != '${DateTime.now().day}/${_getMonthName(DateTime.now().month).substring(0, 3)} \n ${_getWeekdayName(DateTime.now().weekday)}') {
                        String time = DateFormat.jm().format(showTime);

                        timeSlots.add(
                          GestureDetector(
                            onTap: () {
                              _selectTimeSlot(cinemaName, dynamicTimes);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>     SeatSelectionScreen(
                                      movieename: docid,
                                      date: dateList[current],
                                      oriname: movieTitle,
                                      seatingArrangement: jsonEncode(theater["seatings"]),
                                      cinemaname: cinemaName,
                                      allTimeSlots: allTimeSlots,
                                      selectTime:time
                                  ),
                                  //     bookings(
                                  //   movieename: docid,
                                  //   date: dateList[current],
                                  //   timeof: time,
                                  //   oriname: movieTitle,
                                  //   seatingArrangement:jsonEncode(theater["seatings"]),
                                  //   cinemaname: cinemaName,
                                  // ),
                                  //

                                ),
                              );
                            },
                            child: Container(
                              width: 80,
                              height: 50.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Text(
                                  time,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  }
                  return Card(
                    margin: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(
                            '$cinemaName',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            children: timeSlots,
                            spacing: 8.0,
                            runSpacing: 8.0,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
