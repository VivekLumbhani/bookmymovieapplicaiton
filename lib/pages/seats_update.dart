import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nookmyseatapplication/pages/messages.dart';
import 'package:nookmyseatapplication/pages/services/database.dart';
import 'package:nookmyseatapplication/pages/services/shared_pref.dart';
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

  String? myName;
  String? myEmail;

  gettheSharedPref()async{
    myName=await SharedPreferenceHelper().getUserName();
    myEmail=await SharedPreferenceHelper().getUserEmail();

  }


  ontheLoad()async{
    // chatRoomsStream=await DatabasesHelper().getChatRooms();
    await gettheSharedPref();

    setState(() {

    });
  }

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
  String? allSeatsofbookings;

  String getChatRoomIdbyUserName(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    }
    else {
      return "$a\_$b";
    }
  }

  Map<String, String> seatUserNameMap = {};

  Map<String, String> seatUserEmailMap = {};
  @override
  void initState() {
    super.initState();
    ontheLoad();

    String seatstr = widget.seatingArrangement.trim();
    print("seat trim $seatstr");
    seatingArrMap = json.decode(seatstr);
    selectedSeatsofUser = json.decode(widget.selectedSeats);

    finalseatsbyusertocheck = json.decode(widget.selectedSeats);

    print("selectedSeatsofUser is $selectedSeatsofUser and length is ${selectedSeatsofUser?.length}");
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
        .collection('personalbooking')
        .where('movieId', isEqualTo: idtochek)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          String useEmail = doc['username'];
          String selectedSeats = doc['selectedSeats'];
          String nameoftheuser = doc['nameoftheuser'];

          List<String> seatList = jsonDecode(selectedSeats).cast<String>();

          // Assign each seat to the corresponding user name
          for (String seat in seatList) {
            seatUserNameMap[seat] = nameoftheuser;
            seatUserEmailMap[seat]=useEmail;
          }
        }
      }
    });


    FirebaseFirestore.instance
        .collection('bookings')
        .where('movieId', isEqualTo: idtochek)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        List<String> reserved = [];
        for (var doc in querySnapshot.docs) {
          String seats = doc['selectedSeats'];
          allSeatsofbookings = doc["selectedSeats"]; // Assigning value here
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

      // Now you can safely access allSeatsofbookings here
      print("all reserved seats are $reservedSeats");
      print("upper part price ${upperPart}");
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
                        print("selected seats $selectedSeats and all seats were $allSeatsofbookings  price is $totalBill");
                        List<String> decodedseats = jsonDecode(allSeatsofbookings!).cast<String>();
                        List<String> decodedusersoldseats = (finalseatsbyusertocheck as List<dynamic>).map((e) => e.toString()).toList();

                        decodedseats.addAll(selectedSeats);
                        decodedseats.removeWhere((seat) => decodedusersoldseats.contains(seat));

                        var jsonecoded=jsonEncode(decodedseats);
                        print("updating value will be $jsonecoded and tyep is ${jsonecoded.runtimeType}" );
                        print("selected seats ${selectedSeats.runtimeType} and all seats were ${allSeatsofbookings.runtimeType}  price is ${totalBill.runtimeType}");

                        print("selected seats $selectedSeats and all seasts were $allSeatsofbookings  price is $totalBill");


                        print("users old seats $decodedusersoldseats and type ${decodedusersoldseats.runtimeType}");
                        print("Final eat are $decodedseats and its type ${decodedseats.runtimeType}");

                        print("selected seats ${selectedSeats.runtimeType} and all seasts were ${allSeatsofbookings.runtimeType}  price is ${totalBill.runtimeType}");



                      },


                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      child: Text('Update seats'),
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
                    bool isSelectedByUser = selectedSeats.contains(seatKey) && selectedSeatsofUser!.contains(seatKey) ?? false;

                    // Determine the color of the seat
                    Color seatColor = Colors.white;
                    if (isSelectedByUser) {
                      seatColor = Colors.green;
                    } else if (isSelected) {
                      seatColor = Colors.green;
                    } else if (isReserved) {
                      seatColor = Colors.grey;
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
                            color: seatColor, // Set the determined color
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

      if (isSeatReserved(seatKey)) {

        String userName = seatUserNameMap[seatKey] ?? 'Unknown';
        String userEmail = seatUserEmailMap[seatKey] ?? 'Unknown';

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Warning'),
              content: Text('You will be chatting with unknown user,BE AWARE'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () async {

                    var chatRoomId=getChatRoomIdbyUserName(myName!, userName);
                    Map<String,dynamic>chatRoomInfoMap={
                      "users":[myName,userName],
                    };
                    await DatabasesHelper().createChatRoom(chatRoomId, chatRoomInfoMap);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => messagesScreen(name: userName, email: userEmail),
                      ),
                    );
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        );
        return;
      }

      if (isSeatReserved(seatKey)) {
        // Reservation handling remains the same
        return;
      }

      // Check if the seat is already selected by the user
      bool isSeatSelected = selectedSeats.contains(seatKey);

      // Check if the user already has a seat in the opposite part
      bool hasSeatInOppositePart = false;
      String oppositePartType = partType == 'upper' ? 'lower' : 'upper';
      for (String selectedSeat in selectedSeats) {
        if (selectedSeat.contains(oppositePartType)) {
          hasSeatInOppositePart = true;
          break;
        }
      }

      // If the user has a seat in the opposite part, prevent selecting seats in this part
      if (hasSeatInOppositePart) {
        return;
      }

      if (isSeatSelected) {
        // If the seat is already selected, deselect it
        selectedSeats.remove(seatKey);
      } else {
        // If the seat is not selected, check if the total selected seats is less than or equal to selectedSeatsofUser.length
        if (selectedSeats.length < selectedSeatsofUser!.length) {
          selectedSeats.add(seatKey);
        }
      }

      // Recalculate total bill
      double totalBill = calculateTotalBill();
      print('New total bill after seat tap: $totalBill');
      this.totalBill = totalBill;

      // Update button height based on selected seats
      buttonHeight = selectedSeats.isNotEmpty ? 50.0 : 0.0;
    });
  }

  void handleUserSelectedSeatTap(String seatKey) {
    setState(() {
      // Deselect the seat if it's already selected
      if (selectedSeats.contains(seatKey)) {
        selectedSeats.remove(seatKey);
      } else {
        // If the seat is not selected, add it back to the selectedSeats list
        selectedSeats.add(seatKey);
      }

      // Recalculate total bill
      double totalBill = calculateTotalBill();
      print('New total bill after deselection: $totalBill');
      this.totalBill = totalBill;

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

        // Check if the deselected seat was previously charged
        if (selectedSeats.contains(deselectedSeat)) {
          totalBill -= deselectedSeatPrice;
        }
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
