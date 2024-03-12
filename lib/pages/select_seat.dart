import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nookmyseatapplication/pages/seat_demo_layout.dart';

class SeatSelectionScreen extends StatefulWidget {
  final movieename;
  final date;
  final oriname;
  final seatingArrangement;
  final cinemaname;
  final allTimeSlots;
  final selectTime;

  const SeatSelectionScreen({
    Key? key,
    this.movieename,
    this.date,
    this.oriname,
    this.seatingArrangement,
    this.cinemaname,
    this.allTimeSlots,
    this.selectTime,
  }) : super(key: key);

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  int selectedTimeIndex = -1;
  int selectedNumOfSeats = 2;

  String? seatingArrangement;
  final List<int> numofseats = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  String getSelectedTime() {
    if (selectedTimeIndex >= 0 &&
        selectedTimeIndex < widget.allTimeSlots.length) {
      return widget.allTimeSlots[selectedTimeIndex]['time'];
    }
    return '';
  }

  @override
  initState() {
    seatingArrangement=widget.seatingArrangement;
    super.initState();

    for (int i = 0; i < widget.allTimeSlots.length; i++) {
      String time = widget.allTimeSlots[i]['time'];

      if (time == widget.selectTime) {
        setState(() {
          selectedTimeIndex = i;
        });
        break;
      }
    }
    print("seating arrangement like $seatingArrangement ");
  }

  @override
  Widget build(BuildContext context) {
    String date = widget.date;
    String cinemaName = widget.cinemaname;
    List<Map<String, dynamic>> timeSlots = widget.allTimeSlots;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        elevation: 0,
        title: Text("${widget.oriname}"),
        actions: [],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '${date.trim()} - ${getSelectedTime()}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Cinema Name: $cinemaName',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Display the time slots dynamically
          SizedBox(
            height: 80,
            child: ListView.builder(
              itemCount: timeSlots.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                String time = timeSlots[index]['time'];
                bool isSelected = index == selectedTimeIndex;
                print("Index: $index, isSelected: $isSelected");
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTimeIndex = index;
                      print("Selected Time Index: $selectedTimeIndex");
                    });
                  },
                  child: AnimatedContainer(
                    margin: EdgeInsets.all(8.0),
                    width: 73,
                    height: 36,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.green : Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      color: isSelected ? Colors.green : Colors.transparent,
                    ),
                    duration: const Duration(microseconds: 300),
                    child: Center(
                      child: Text(
                        time,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              height: double.maxFinite,
              width: double.maxFinite,
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "How many seats?",
                        style: TextStyle(fontSize: 16),
                      )),
                  if (selectedNumOfSeats != -1)
                    SvgPicture.asset(
                      getSvgPath(selectedNumOfSeats),
                      height: 150, // Adjust the height as needed
                      width: 150, // Adjust the width as needed
                    ),
                  SizedBox(height: 25,),
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    children: numofseats
                        .map(
                          (numSeats) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedNumOfSeats = numSeats;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(microseconds: 400),
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: numSeats == selectedNumOfSeats
                                    ? Colors.greenAccent
                                    : Colors.transparent,
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Center(child: Text("$numSeats")),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 30,),
                  if (seatingArrangement != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: generateSeatingArrangementWidgets(),
                      ),
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      widthFactor: 1.0, // Takes the full width
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          left: 0,
                          right: 0,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeatLayoutTry(
                                  movieename: widget.movieename,
                                  date: widget.date,
                                  oriname: widget.oriname,
                                  seatingArrangement: widget.seatingArrangement,
                                  cinemaname: widget.cinemaname,
                                  selectTime: getSelectedTime(),
                                  numofseats:selectedNumOfSeats
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: Colors.red,
                            onPrimary: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: Text("Select Seats"),
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String getSvgPath(int numSeats) {
    switch (numSeats) {
      case 1:
        return "assets/seatssvg/bicycle.svg";
      case 2:
        return "assets/seatssvg/vespa.svg";
      case 3:
        return "assets/seatssvg/rickshaw.svg";
      case 4:
        return "assets/seatssvg/smallcar.svg";
      case 5:
        return "assets/seatssvg/car.svg";
      case 6:
        return "assets/seatssvg/car.svg";
      case 7:
        return "assets/seatssvg/van.svg";
      case 8:
        return "assets/seatssvg/van.svg";
      case 9:
        return "assets/seatssvg/bus.svg";
      case 10:
        return "assets/seatssvg/bus.svg";
      default:
        return "assets/seatssvg/vespa.svg";
    }
  }

  List<Widget> generateSeatingArrangementWidgets() {
    List<Widget> widgets = [];

    Map<String, dynamic> seatingArrangementMap = json.decode(seatingArrangement!); // Convert to Map

    seatingArrangementMap.forEach((part, details) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: const Color(0xfffcfcfc),
              border: Border.all(width: 0.5, color: const Color(0xffe5e5e5)),
            ),
            child: Column(
              children: [
                Text(part, style: TextStyle(color: Colors.black.withOpacity(0.7))),
                const SizedBox(height: 10),
                Text("\u20B9 ${details['price']}", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      );
    });

    return widgets;
  }
}
