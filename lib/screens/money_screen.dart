import 'package:eyeassistant/camera.dart';
import 'package:eyeassistant/widgets/constants/constants.dart';
import 'package:eyeassistant/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ESMoneyIdentifier extends StatefulWidget {
  const ESMoneyIdentifier({Key? key}) : super(key: key);

  @override
  State<ESMoneyIdentifier> createState() => _ESMoneyIdentifierState();
}

class _ESMoneyIdentifierState extends State<ESMoneyIdentifier> {
  ImageLabeler _imageLabeler = GoogleMlKit.vision.imageLabeler();
  Camera image = Camera();
  FlutterTts flutterTts = FlutterTts();
  String? imagePath;
  bool hasImage = false;
  bool isBusy = false;
  String result = '';
  String title = 'Money Identifier';

  Future<void> getImage(ImageSource source) async {
    await image.getImage(source);
    setState(() {
      hasImage = true;
      imagePath = image.image?.path;
      processImageWithRemoteModel(imagePath);
    });
  }

  Future<void> processImageWithRemoteModel(String? path) async {
    final inputImage = InputImage.fromFilePath(path!);

    final options = CustomImageLabelerOptions(
        maxCount: 3,
        customModel: CustomLocalModel.asset,
        customModelPath: 'ph_currency.tflite');
    _imageLabeler = GoogleMlKit.vision.imageLabeler(options);
    processImage(inputImage);
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    await Future.delayed(const Duration(milliseconds: 50));
    final labels = await _imageLabeler.processImage(inputImage);
    if (labels.isEmpty) {
      outputTTSerror();
    }
    debugPrint(labels.toString());
    isBusy = false;
    if (mounted) {
      setState(() {
        for (ImageLabel label in labels) {
          result += label.label + " ";
          outputTTS();
          debugPrint(label.index.toString());
          debugPrint(result);
          debugPrint(label.confidence.toString());
        }
      });
    }
  }

  outputTTS() async {
    await flutterTts.speak('You have $result');
  }

  outputTTSerror() async {
    await flutterTts.speak('Can not recognize the image. Try Again');
  }

  @override
  void initState() {
    getImage(ImageSource.camera);
    super.initState();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ESAppBar(
        onTap: () async {
          await flutterTts.speak(title);
        },
        color: Colors.green[700]!,
        title: title,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ESImageContainer(
                child: hasImage
                    ? Image.file(image.image!)
                    : const ESBlankImageBox(),
                onTapCamera: () {
                  getImage(ImageSource.camera);
                  result = '';
                  Navigator.pop(context);
                },
                onTapGallery: () {
                  getImage(ImageSource.gallery);
                  result = '';
                  Navigator.pop(context);
                }),
          ),
          _getButton(),
          ESText(
            result,
            size: ESTextSize.xxLarge,
          )
        ],
      ),
    );
  }

  Widget _getButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ESButton(
                icon: Icons.camera_alt,
                description: 'Camera',
                color: ESColor.orange,
                onTap: () {
                  getImage(ImageSource.camera);
                  result = '';
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ESButton(
                  icon: Icons.collections_outlined,
                  description: 'Gallery',
                  color: ESColor.primaryBlue,
                  onTap: () {
                    getImage(ImageSource.gallery);
                    result = '';
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
