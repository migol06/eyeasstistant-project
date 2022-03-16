import 'package:eyeassistant/camera.dart';
import 'package:eyeassistant/widgets/constants/constants.dart';
import 'package:eyeassistant/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clipboard/clipboard.dart';

const String _camera = 'Camera';
const String _gallery = 'Gallery';
const String _title = 'Text Image Recognition';

class ESTextImageScreen extends StatefulWidget {
  const ESTextImageScreen({Key? key}) : super(key: key);

  @override
  State<ESTextImageScreen> createState() => _ESTextImageScreenState();
}

class _ESTextImageScreenState extends State<ESTextImageScreen> {
  Camera image = Camera();
  bool hasImage = false;
  TextDetector textDetector = GoogleMlKit.vision.textDetector();
  late String imagePath;
  String scanText = '';
  FlutterTts flutterTts = FlutterTts();

  Future getImage(ImageSource source) async {
    await image.getImage(source);
    setState(() {
      hasImage = true;
      imagePath = image.image!.path;
      getText(imagePath);
    });
  }

  Future getText(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);

    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          setState(() {
            scanText = scanText + '  ' + element.text;
            debugPrint(scanText);
          });
        }
        scanText = scanText + '\n';
      }
    }
    await Future.delayed(const Duration(seconds: 3), () {
      _speech();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await flutterTts.stop();
  }

  Future _speech() async {
    await flutterTts.speak(scanText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ESAppBar(
        onTap: () async {
          await flutterTts.speak(_title);
        },
        color: ESColor.orange,
        title: _title,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ESImageContainer(
                onTapCamera: () {
                  getImage(ImageSource.camera);
                  scanText = '';
                  flutterTts.stop();
                  Navigator.pop(context);
                },
                onTapGallery: () {
                  getImage(ImageSource.gallery);
                  flutterTts.stop();
                  scanText = '';
                  Navigator.pop(context);
                },
                child: hasImage
                    ? Image.file(image.image!)
                    : const ESBlankImageBox()),
            _getButton(),
            ESTextArea(text: scanText, onTap: copyToClipBoard),
            const SizedBox(
              height: ESGrid.large,
            )
          ],
        ),
      ),
    );
  }

  void copyToClipBoard() {
    if (scanText.trim() != '') {
      FlutterClipboard.copy(scanText);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Copy Text"),
      ));
    }
  }

  Widget _getButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ESButton(
            icon: Icons.camera_alt,
            description: _camera,
            color: ESColor.orange,
            onTap: () {
              getImage(ImageSource.camera);
              scanText = '';
              flutterTts.speak(_camera);
            },
          ),
          ESButton(
              icon: Icons.collections_outlined,
              description: _gallery,
              color: Colors.green,
              onTap: () {
                getImage(ImageSource.gallery);
                scanText = '';
                flutterTts.speak(_gallery);
              }),
          ESButton(
              icon: Icons.volume_up,
              description: 'Speak',
              color: ESColor.primaryBlue,
              onTap: () async {
                if (!hasImage) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please add an Image'),
                  ));
                  flutterTts.speak('Scan, Please add an Image');
                } else {
                  _speech();
                }
              }),
          ESButton(
              icon: Icons.clear_outlined,
              description: 'Clear',
              color: Colors.red,
              onTap: () {
                setState(() {
                  scanText = '';
                  hasImage = false;
                  flutterTts.stop();
                  imagePath = '';
                });
              }),
        ],
      ),
    );
  }
}
