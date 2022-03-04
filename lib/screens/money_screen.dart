import 'package:camera/camera.dart';
import 'package:eyeassistant/main.dart';
import 'package:eyeassistant/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ESMoneyRecognition extends StatefulWidget {
  const ESMoneyRecognition({Key? key}) : super(key: key);

  @override
  State<ESMoneyRecognition> createState() => _ESMoneyRecognitionState();
}

class _ESMoneyRecognitionState extends State<ESMoneyRecognition> {
  CameraController? _controller;

  @override
  void initState() {
    _controller = CameraController(cameras![0], ResolutionPreset.max);
    _controller?.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ESAppBar(
        onTap: () {},
      ),
      body: Stack(children: [
        Center(child: CameraPreview(_controller!)),
        // ESText(detectedImage)
      ]),
    );
  }
}
