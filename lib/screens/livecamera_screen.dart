import 'package:camera/camera.dart';
import 'package:eyeassistant/main.dart';
import 'package:eyeassistant/widgets/app_bar.dart';
import 'package:eyeassistant/widgets/text.dart';
import 'package:flutter/material.dart';

class ESLiveCameraScreen extends StatefulWidget {
  const ESLiveCameraScreen({Key? key}) : super(key: key);

  @override
  State<ESLiveCameraScreen> createState() => _ESLiveCameraScreenState();
}

class _ESLiveCameraScreenState extends State<ESLiveCameraScreen> {
  CameraController? controller;

  @override
  void initState() {
    controller = CameraController(cameras![0], ResolutionPreset.max);
    controller?.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ESAppBar(
        onTap: () {
          showAboutDialog(
              context: context,
              applicationName: 'Live Camera',
              applicationIcon: Image.asset(
                'assets/images/eyessistant.png',
                scale: 5,
              ),
              children: [const ESText('Lorem Ipsum Dolor')]);
        },
      ),
      body: Center(child: CameraPreview(controller!)),
    );
  }
}
