import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nookmyseatapplication/snaks.dart';

class SeatLayoutTry extends StatefulWidget {
  final movieename;
  final date;
  final oriname;
  final seatingArrangement;
  final cinemaname;
  final selectTime;
  final numofseats;

  const SeatLayoutTry({
    Key? key,
    this.movieename,
    this.date,
    this.oriname,
    this.seatingArrangement,
    this.cinemaname,
    this.selectTime,
    this.numofseats,
  }) : super(key: key);

  @override
  State<SeatLayoutTry> createState() => _SeatLayoutTryState();
}

class _SeatLayoutTryState extends State<SeatLayoutTry> {
  late Map<String, dynamic>? seatingArrMap;
  late Map<String, dynamic>? upperPart;
  late Map<String, dynamic>? lowerPart;

  var username = FirebaseAuth.instance.currentUser;

  List<String> reservedSeats = [];
  List<String> selectedSeats = [];
  double buttonHeight = 0.0;
  double totalBill = 0.0;
  int numofseats=0;
  String? timeof;
  String? date;
  String? movieName;
  String? cinemaName;


  @override
  void initState() {
    super.initState();
    numofseats=widget.numofseats;

    print("seating arr is ${widget.seatingArrangement}");
    seatingArrMap = widget.seatingArrangement != null
        ? json.decode(widget.seatingArrangement!)
        : null;
    upperPart = seatingArrMap?['upperPart'];
    lowerPart = seatingArrMap?['lowerPart'];
    date = widget.date;
    timeof = widget.selectTime;
    movieName = widget.oriname;
    cinemaName = widget.cinemaname;

    final docid = widget.movieename;
    final idtochek = docid! + timeof! + date!;

    FirebaseFirestore.instance
        .collection('bookings')
        .where('movieId', isEqualTo: idtochek)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        List<String> reserved = [];
        for (var doc in querySnapshot.docs) {
          String seats = doc['selectedSeats'];
          List<String> selectedSeats = jsonDecode(seats).cast<String>();

          for (var seat in selectedSeats) {
            List<String> parts = seat.split('-');
            reserved.add(seat);
          }
        }

        setState(() {
          reservedSeats = reserved.cast<String>();
          print("reserved seats are $reservedSeats");

        });
      }
    });
    print("all reserved seats are $reservedSeats");
    print("upper part price ${upperPart}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Row(
          children: [
            Text(
              "${widget.oriname}",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            SizedBox(width: 8),
            Text(
              "${widget.cinemaname},",
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        actions: [
          IconButton(
            color: Colors.red,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.edit),
          ),
          Text(
            '${widget.numofseats} tickets',
            style: TextStyle(fontSize: 16,color: Colors.red),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLegend('Selected', Colors.green),
                SizedBox(width: 10),
                buildLegend('Unselected', Colors.white),
                SizedBox(width: 10),
                buildLegend('Reserved', Colors.grey),
              ],
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Upper Part: ${upperPart?['price']}"),
                  buildSeats(upperPart, 'upper'),
                  SizedBox(height: 20),
                  Text("Lower Part: ${lowerPart?['price']}"),
                  buildSeats(lowerPart, 'lower'),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 10),
                Image.asset(
                  'images/screen.jpg',
                  width: double.maxFinite,
                  height: 150,
                ),
                SizedBox(height: 40),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: buttonHeight,
                  width: double.maxFinite,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        print("selected seats $selectedSeats and price is $totalBill");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SnackBooking(
                              movieid: widget.movieename,
                              date: widget.date,
                              moviename: widget.oriname,
                              cinemaname: widget.cinemaname,
                              selecttime: widget.selectTime,
                              seats: selectedSeats,
                              amount: totalBill,
                              seatingArr:widget.seatingArrangement
                            ),
                          ),
                        );


                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      child: Text('Pay $totalBill'),
                    ),
                  ),
                ),


              ],
            ),
          ),
        ],
      ),

    );
  }
  Widget buildLegend(String label, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget buildSeats(Map<String, dynamic>? part, String partType) {
    if (part == null) {
      return Container();
    }

    int rows = int.parse(part['row'] ?? '0');
    int columns = int.parse(part['column'] ?? '0');

    List<String> alphabet =
    List.generate(26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index));

    return Container(
      child: Column(
        children: List.generate(
          rows,
              (rowIndex) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(alphabet[rowIndex]),
                SizedBox(width: 25),
                ...List.generate(
                  columns,
                      (seatIndex) {
                    int seatNumber = rowIndex * columns + seatIndex + 1;
                    String seatKey = '$rowIndex-$seatIndex-$partType';

                    double bottomPadding = rowIndex == rows - 1 ? 0.0 : 10.0;

                    bool isReserved = reservedSeats.contains(seatKey);

                    return Padding(
                      padding: EdgeInsets.only(
                        right: seatIndex % 5 == 4 ? 17.0 : 5.0,
                        bottom: bottomPadding,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          handleSeatTap(rowIndex, seatIndex, partType);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(1),
                            color: isReserved
                                ? Colors.grey // Reserved seats color
                                : selectedSeats.contains('$rowIndex-$seatIndex-$partType')
                                ? Colors.green // Selected seats color
                                : Colors.white, // Unselected seats color
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Center(
                                  child: Text(
                                    "$seatNumber",
                                    style: TextStyle(
                                      color: isReserved ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                                height: 20,
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void handleSeatTap(int rowIndex, int seatIndex, String partType) {
    setState(() {
      String seatKey = '$rowIndex-$seatIndex-$partType';

      // Check if the seat is reserved
      if (reservedSeats.contains(seatKey)) {
        // Seat is reserved, do not proceed
        return;
      }

      // Check if the selected seat is from a different part
      if (selectedSeats.isNotEmpty && partType != selectedSeats.last.split('-').last) {
        selectedSeats.clear();
      }

      // Check if the seat is already selected
      bool isSeatSelected = selectedSeats.contains(seatKey);

      // Check if selecting this seat would exceed the limit
      if (!isSeatSelected && selectedSeats.length >= numofseats) {
        // Display a message or prevent further selection
        // For now, let's just return without doing anything
        return;
      }

      if (isSeatSelected) {
        // Deselect the seat
        selectedSeats.remove(seatKey);
      } else {
        // Select the seat
        selectedSeats.add(seatKey);
      }

      // Calculate total bill
      double totalBill = 0.0;
      for (String seat in selectedSeats) {
        List<String> seatInfo = seat.split('-');
        double seatPrice = seatInfo[2] == 'upper'
            ? double.parse(upperPart?['price'] ?? '0.0')
            : double.parse(lowerPart?['price'] ?? '0.0');
        totalBill += seatPrice;
      }
      this.totalBill = totalBill;
      buttonHeight = selectedSeats.isNotEmpty ? 50.0 : 0.0;
    });
  }

}

