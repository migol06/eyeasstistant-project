import 'package:camera/camera.dart';
import 'package:eyeassistant/main.dart';
import 'package:eyeassistant/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite/tflite.dart';

class ESLiveCameraScreen extends StatefulWidget {
  const ESLiveCameraScreen({Key? key}) : super(key: key);

  @override
  State<ESLiveCameraScreen> createState() => _ESLiveCameraScreenState();
}

class _ESLiveCameraScreenState extends State<ESLiveCameraScreen> {
  FlutterTts flutterTts = FlutterTts();
  CameraController? controller;
  bool isDetecting = false;
  String detectedImage = '';

  loadModel() async {
    String? res = await Tflite.loadModel(
        model: "assets/model/mobilenet_v1_1.0_224.tflite",
        labels: "assets/model/mobilenet_v1_1.0_224.txt");
    debugPrint(res);
  }

  @override
  void initState() {
    controller = CameraController(cameras![0], ResolutionPreset.max);
    controller?.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        controller?.startImageStream((CameraImage img) async {
          if (!isDetecting) {
            isDetecting = true;
            var recognitions = await Tflite.runModelOnFrame(
                bytesList: img.planes.map((plane) {
                  return plane.bytes;
                }).toList(),
                imageHeight: img.height,
                imageWidth: img.width,
                imageMean: 127.5,
                imageStd: 127.5,
                rotation: 90,
                numResults: 1,
                threshold: 0.1,
                asynch: true);
            for (var response in recognitions!) {
              if ((response['confidence'] as double) >= 0.75) {
                await Future.delayed(const Duration(seconds: 1));
                detectedImage = response['label'];
              } else {
                await Future.delayed(const Duration(seconds: 1));
                detectedImage = 'Can\'t recognize the Image';
              }
            }
            setState(() {
              detectedImage;
              speech();
              debugPrint(detectedImage);
            });

            isDetecting = false;
          }
        });
      });
    });

    loadModel();
    super.initState();
  }

  @override
  void dispose() async {
    await Tflite.close();
    controller?.dispose();
    super.dispose();
  }

  speech() {
    flutterTts.speak(detectedImage);
    flutterTts.setSpeechRate(0.8);
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
      body: Stack(children: [
        Center(child: CameraPreview(controller!)),
        ESText(detectedImage)
      ]),
    );
  }
}
