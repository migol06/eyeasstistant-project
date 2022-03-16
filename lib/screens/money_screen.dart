import 'package:eyeassistant/camera.dart';
import 'package:eyeassistant/widgets/constants/constants.dart';
import 'package:eyeassistant/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

const String _title = 'Money Identifier';

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

  List<ImageLabel>? labels;

  Future<void> getImage(ImageSource source) async {
    await image.getImage(source);
    if (image.image != null) {
      setState(() {
        hasImage = true;
        imagePath = image.image?.path;
        processImageWithRemoteModel(imagePath);
      });
    } else {
      hasImage = false;
    }
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
    labels = await _imageLabeler.processImage(inputImage);
    if (labels!.isEmpty) {
      outputTTSerror();
    }
    debugPrint(labels.toString());
    isBusy = false;
    if (mounted) {
      setState(() {
        for (ImageLabel label in labels!) {
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
        onTapButton: () async {
          await flutterTts.speak(_title);
        },
        color: Colors.green[700]!,
        title: _title,
        onBackButton: () {
          Navigator.of(context).pop();
        },
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
            size: ESTextSize.xxxLarge,
          )
        ],
      ),
    );
  }

  Widget _getButton() {
    return Row(
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
                color: Colors.green,
                onTap: () {
                  getImage(ImageSource.gallery);
                  result = '';
                }),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ESButton(
                icon: Icons.volume_up,
                description: 'Speak',
                color: ESColor.primaryBlue,
                onTap: () async {
                  if (!hasImage) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please add an Image'),
                    ));
                    flutterTts.speak('Please add an Image');
                  } else if (labels!.isEmpty) {
                    outputTTSerror();
                  } else {
                    outputTTS();
                  }
                }),
          ),
        ),
      ],
    );
  }
}
