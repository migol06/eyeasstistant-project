import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

typedef Callback = void Function(List<dynamic> list);

class ESCamera extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final Callback? setRecognitions;
  const ESCamera({
    Key? key,
    this.cameras,
    this.setRecognitions,
  }) : super(key: key);

  @override
  _ESCameraState createState() => _ESCameraState();
}

class _ESCameraState extends State<ESCamera> {
  CameraController? controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();

    controller = CameraController(widget.cameras![0], ResolutionPreset.max);
    controller?.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});

      controller?.startImageStream((CameraImage img) async {
        if (!isDetecting) {
          isDetecting = true;
          await Tflite.runModelOnFrame(
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
                  asynch: true)
              .then((recognitions) {
            widget.setRecognitions!(recognitions!);
          });

          isDetecting = false;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return Container();
    } else {
      return OverflowBox(
        child: CameraPreview(controller!),
      );
    }
  }
}
