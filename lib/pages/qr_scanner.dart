import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:nookmyseatapplication/pages/result_screen.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({Key? key}) : super(key: key);

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final bgColor = Color(0xfffafafa);
  bool isFlashOn=false;
  bool isfrontCameraOn=false;

  bool isScanComplete=false;

  void closeScreen(){
    isScanComplete=false;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(

      ),
      backgroundColor: bgColor,
      appBar: AppBar(

        centerTitle: true,
        title: Text(
          "Qr Scanner screen",
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Place the Qr code in the area",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Scanning will be started automatically",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            )),
            Expanded(
                flex: 4,
                child:Stack(
                  children: [
                    MobileScanner(
                      onDetect: (barcode) {
                        if (isScanComplete) {
                          String code = barcode.raw ?? '---';
                          isScanComplete = true;
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ResultOfQrScreen(
                          //       closeScreen: closeScreen,
                          //       code: code,
                          //     ),
                          //   ),
                          // );
                        }
                      },
                    ),
                    Positioned(
                      top: 0.0, // Adjust position as needed
                      left: 0.0, // Adjust position as needed
                      right: 0.0, // Adjust position as needed
                      bottom: 0.0, // Adjust position as needed
                      child: Container(
                        color: Colors.black.withOpacity(0.3), // Adjust opacity for desired transparency
                        // You can add other widgets here for the overlay content
                      ),
                    ),
                  ],
                ),


            ),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: Text(
                "Developed by me",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
