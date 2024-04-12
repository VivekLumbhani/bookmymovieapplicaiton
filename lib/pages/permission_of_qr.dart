import 'package:permission_handler/permission_handler.dart';

Future<bool> requestCameraPermission() async {
  var status = await Permission.camera.status;
  if (status.isDenied) {
    status = await Permission.camera.request();
  }
  return status.isGranted;
}
