import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ResultOfQrScreen extends StatefulWidget {
  final code;

  const ResultOfQrScreen({Key? key, this.code}) : super(key: key);

  @override
  State<ResultOfQrScreen> createState() => _ResultOfQrScreenState();
}

class _ResultOfQrScreenState extends State<ResultOfQrScreen> {
  late Map<String, dynamic> qrData;
  String status = "";

  @override
  void initState() {
    super.initState();
    String jsonString = widget.code.toString();

    qrData = json.decode(widget.code);

    String dateString = qrData['date'].toString();
    String timeString = qrData['time'].toString();

    DateTime date = DateTime.parse(dateString);
    DateTime time = DateFormat.jm().parse(timeString);

    // Combine date and time to create a DateTime object
    DateTime dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    // Calculate current time minus 2 hours
    DateTime currentTimeMinus2Hours = DateTime.now().subtract(Duration(hours: 2));

    // Check if the QR code's date is today and the time is after the current time minus 2 hours
    if (date.year == currentTimeMinus2Hours.year &&
        date.month == currentTimeMinus2Hours.month &&
        date.day == currentTimeMinus2Hours.day &&
        dateTime.isAfter(currentTimeMinus2Hours)) {
      status = "valid";
    } else {
      status = "Not Valid";
    }
  }


  final bgColor = Color(0xfffafafa);

  @override
  Widget build(BuildContext context) {
    String animationPath =
    status == "valid" ? 'assets/Lottie/rightticket.json' : 'assets/Lottie/wrongticket.json';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Qr Scanner screen",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              animationPath,
              width: MediaQuery.of(context).size.width - 100,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            if (status == "valid") ...[
              Text(
                "Proceed to Screen 1",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
            if (status == "expired") ...[
              Text(
                "Ticket Expired",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ],
        ),
      ),

    );
  }
}
