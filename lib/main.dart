import 'package:camera/camera.dart';
import 'package:eyeassistant/screens/screens.dart';
import 'package:flutter/material.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eyessistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ESHomeScreen(),
    );
  }
}
