import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nookmyseatapplication/pages/ResultQr.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'permission_of_qr.dart';



class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 10,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width / 2,
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              result?.code ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton.extended(
              onPressed: (result != null) ? null : _scanQRCode,
              label: Text(result != null ? 'Scan Again' : 'Scan QR Code'),
              icon: Icon(result != null ? Icons.refresh : Icons.scanner),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() => result = scanData);
      print('Scanned QR code data: ${scanData.code} and type is ${scanData.runtimeType}');  // Add this line

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>ResultOfQrScreen(code: scanData.code.toString(),)
          // GenresList(categoryof:genresList[index].movieName.toString(),)
        ),
      );



    });
  }

  void _scanQRCode() async {
    if (await requestCameraPermission()) {
      // Check permission granted
      controller?.scannedDataStream.listen((scanData) {
        setState(() => result = scanData);
      });
    }
  }



}
