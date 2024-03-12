import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nookmyseatapplication/snaks.dart';

class SeatsUpdate extends StatefulWidget {
  final movieename;
  final date;
  final oriname;
  final seatingArrangement;
  final cinemaname;
  final selectTime;
  final selectedSeats;

  const SeatsUpdate({
    Key? key,
    this.movieename,
    this.date,
    this.oriname,
    this.seatingArrangement,
    this.cinemaname,
    this.selectTime,
    this.selectedSeats,
  }) : super(key: key);

  @override
  State<SeatsUpdate> createState() => _SeatLayoutTryState();
}

class _SeatLayoutTryState extends State<SeatsUpdate> {
  late Map<String, dynamic>? seatingArrMap;
  late Map<String, dynamic>? upperPart;
  late Map<String, dynamic>? lowerPart;
  late List<dynamic>? selectedSeatsofUser;
  late List<dynamic>? finalseatsbyusertocheck;


  var username = FirebaseAuth.instance.currentUser;


  List<String> reservedSeats = [];
  List<String> selectedSeats = [];
  List<String> fixedSeats=[];
  double buttonHeight = 0.0;
  double totalBill = 0.0;
  int numofseats=100;
  String? timeof;
  String? date;
  String? movieName;
  String? cinemaName;
  int? numsCalc;


  @override
  void initState() {
    super.initState();

    String seatstr = widget.seatingArrangement.trim();
    print("seat trim $seatstr");
    seatingArrMap = json.decode(seatstr);
    selectedSeatsofUser = json.decode(widget.selectedSeats);

    finalseatsbyusertocheck = json.decode(widget.selectedSeats);

    print("selected seats $finalseatsbyusertocheck and its length ${finalseatsbyusertocheck?.length}");
    upperPart = seatingArrMap?['upperPart'];
    lowerPart = seatingArrMap?['lowerPart'];
    date = widget.date;
    timeof = widget.selectTime;
    movieName = widget.oriname;
    cinemaName = widget.cinemaname;

    final docid = widget.movieename;
    final idtochek = widget.movieename;

    FirebaseFirestore.instance
        .collection('bookings')
        .where('movieId', isEqualTo: idtochek)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        List<String> reserved = [];
        for (var doc in querySnapshot.docs) {
          String seats = doc['selectedSeats'];
          List<String> selectedSeatss = jsonDecode(seats).cast<String>();

          for (var seat in selectedSeatss) {
            if (!selectedSeatsofUser!.contains(seat) ?? true) {
              reserved.add(seat);
            }
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


    for (var seat in selectedSeatsofUser!) {
      if (!selectedSeats.contains(seat)) {
        selectedSeats.add(seat);
      }
    }
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


                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => SnackBooking(
                        //         movieid: widget.movieename,
                        //         date: widget.date,
                        //         moviename: widget.oriname,
                        //         cinemaname: widget.cinemaname,
                        //         selecttime: widget.selectTime,
                        //         seats: selectedSeats,
                        //         amount: totalBill,
                        //         seatingArr:seatingArrMap
                        //     ),
                        //   ),
                        // );


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

    List<String> alphabet = List.generate(26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index));

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
                    bool isSelected = selectedSeats.contains(seatKey);
                    bool isSelectedByUser = selectedSeatsofUser?.contains(seatKey) ?? false;


                    if (isSelectedByUser) {
                      isReserved = false;

                    }




                    return Padding(
                      padding: EdgeInsets.only(
                        right: seatIndex % 5 == 4 ? 17.0 : 5.0,
                        bottom: bottomPadding,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (isSelectedByUser) {
                            handleUserSelectedSeatTap(seatKey);
                          } else {
                            handleSeatTap(rowIndex, seatIndex, partType);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(1),
                            color: isReserved
                                ? Colors.grey
                                : isSelectedByUser
                                ? Colors.green
                                : isSelected
                                ? Colors.green
                                : Colors.white,
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

  void handleUserSelectedSeatTap(String seatKey) {
    setState(() {
      bool isSeatSelected = selectedSeats.contains(seatKey);

      // Check if the seat is already selected by the user
      if (isSeatSelected) {
        // If the seat is previously booked by the user, allow deselection
        if (finalseatsbyusertocheck!.contains(seatKey)) {
          print('Deselecting seat: $seatKey');
          selectedSeats.remove(seatKey);
          selectedSeatsofUser?.remove(seatKey);

          // Recalculate total bill
          double totalBill = calculateTotalBill();
          print('New total bill after deselection: $totalBill');
          this.totalBill = totalBill;
        }
      } else {
        // If not already selected, allow selection if there are fewer than 2 selected seats
        if (selectedSeats.length < 2) {
          print('Selecting seat: $seatKey');
          selectedSeats.add(seatKey);
          selectedSeatsofUser?.remove(seatKey);

          // Recalculate total bill
          double totalBill = calculateTotalBill();
          print('New total bill after selection: $totalBill');
          this.totalBill = totalBill;
        }
      }

      // Update button height based on selected seats
      buttonHeight = selectedSeats.isNotEmpty ? 50.0 : 0.0;
    });
  }

  void handleSeatTap(int rowIndex, int seatIndex, String partType) {
    setState(() {
      String seatKey = '$rowIndex-$seatIndex-$partType';

      if (isSeatReserved(seatKey)) {
        return;
      }

      bool isSeatSelected = selectedSeats.contains(seatKey);


      if (!isSeatSelected && selectedSeats.length + 1 > finalseatsbyusertocheck!.length) {
        // Charge for the seat
        double seatPrice = partType == 'upper'
            ? double.parse(upperPart?['price'] ?? '0.0')
            : double.parse(lowerPart?['price'] ?? '0.0');
        totalBill += seatPrice;
      }

      if (selectedSeats.isNotEmpty && partType != selectedSeats.last.split('-').last) {
        selectedSeats.clear();
        selectedSeats.addAll(selectedSeatsofUser! as Iterable<String>);
      }

      if (selectedSeatsofUser!.contains(seatKey)) {
        return;
      }

      if (isSeatSelected) {
        selectedSeats.remove(seatKey);
      } else {
        selectedSeats.add(seatKey);
      }

      // Update button height based on selected seats
      buttonHeight = selectedSeats.isNotEmpty ? 50.0 : 0.0;
    });
  }

  bool isSeatReserved(String seatKey) {
    return reservedSeats.contains(seatKey);
  }

  double calculateTotalBill() {
    double totalBill = 0.0;

    // Calculate the total bill for selected seats
    for (String seat in selectedSeats) {
      if (!isSeatReserved(seat) && !selectedSeatsofUser!.contains(seat)) {
        List<String> seatInfo = seat.split('-');
        double seatPrice = seatInfo[2] == 'upper'
            ? double.parse(upperPart?['price'] ?? '0.0')
            : double.parse(lowerPart?['price'] ?? '0.0');
        totalBill += seatPrice;
      }
    }

    // Subtract the price of deselected seats from the total bill
    for (String deselectedSeat in selectedSeatsofUser!) {
      if (!selectedSeats.contains(deselectedSeat)) {
        List<String> seatInfo = deselectedSeat.split('-');
        double deselectedSeatPrice = seatInfo[2] == 'upper'
            ? double.parse(upperPart?['price'] ?? '0.0')
            : double.parse(lowerPart?['price'] ?? '0.0');
        totalBill -= deselectedSeatPrice;
      }
    }

    return totalBill;
  }



}
class SeatLayout {
  String? movieid;
  Map<String, dynamic>? upperPart;
  Map<String, dynamic>? lowerPart;

  SeatLayout({
    this.movieid,
    this.upperPart,
    this.lowerPart,
  });

  factory SeatLayout.fromJson(String? seatingArrangement) {
    Map<String, dynamic>? seatingArrMap =
    seatingArrangement != null ? json.decode(seatingArrangement) : null;

    return SeatLayout(
      movieid: seatingArrMap?['movieid'],
      upperPart: seatingArrMap?['upperPart'],
      lowerPart: seatingArrMap?['lowerPart'],
    );
  }
}