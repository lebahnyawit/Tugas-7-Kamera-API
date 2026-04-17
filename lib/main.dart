import 'package:flutter/material.dart';
import 'camerascreen/camera_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(CameraApp());
}

class CameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: CameraScreen());
  }
}
