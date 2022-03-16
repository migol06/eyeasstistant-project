import 'package:camera/camera.dart';
import 'package:eyeassistant/main.dart';
import 'package:eyeassistant/widgets/constants/constants.dart';
import 'package:eyeassistant/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        model: "assets/model/fifteenmodels.tflite",
        labels: "assets/model/fifteen.txt");
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
              await Future.delayed(const Duration(seconds: 1));
              detectedImage = response['label'];
              isDetecting = false;
            }

            if (mounted) {
              setState(() {
                detectedImage;
                debugPrint(detectedImage);
              });
              _speech();
            }
          }
        });
      });
    });

    loadModel();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
    controller?.dispose();
    flutterTts.stop();
  }

  Future _speech() async {
    await flutterTts.speak(detectedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ESAppBar(
        color: ESColor.primaryBlue,
        onTapButton: () async {
          await flutterTts.speak('Live Camera');
        },
        title: 'Live Camera',
        onBackButton: () {
          SystemNavigator.pop();
        },
      ),
      body: Stack(children: [
        Center(child: CameraPreview(controller!)),
        ESText(detectedImage)
      ]),
    );
  }
}
