import 'package:eyeassistant/camera.dart';
import 'package:eyeassistant/widgets/constants/constants.dart';
import 'package:eyeassistant/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clipboard/clipboard.dart';

class ESTextImageScreen extends StatefulWidget {
  const ESTextImageScreen({Key? key}) : super(key: key);

  @override
  State<ESTextImageScreen> createState() => _ESTextImageScreenState();
}

class _ESTextImageScreenState extends State<ESTextImageScreen> {
  Camera image = Camera();
  bool hasImage = false;
  // File? image;
  TextDetector textDetector = GoogleMlKit.vision.textDetector();
  late String imagePath;
  String scanText = '';
  FlutterTts flutterTts = FlutterTts();
  String camera = 'Camera';
  String gallery = 'Gallery';
  String title = 'Text Image Recognition';

  Future getImage(ImageSource source) async {
    await image.getImage(source);
    setState(() {
      hasImage = true;
      imagePath = image.image!.path;
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
          await flutterTts.speak(title);
        },
        color: ESColor.orange,
        title: title,
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
            description: camera,
            color: ESColor.orange,
            onTap: () {
              getImage(ImageSource.camera);
              scanText = '';
              flutterTts.speak(camera);
            },
          ),
          ESButton(
              icon: Icons.collections_outlined,
              description: gallery,
              color: Colors.green,
              onTap: () {
                getImage(ImageSource.gallery);
                scanText = '';
                flutterTts.speak(gallery);
              }),
          ESButton(
              icon: Icons.document_scanner_outlined,
              description: 'Scan',
              color: ESColor.primaryBlue,
              onTap: () async {
                if (scanText.isEmpty && hasImage) {
                  getText(imagePath);
                  await Future.delayed(const Duration(seconds: 5), () {
                    setState(() {
                      _speech();
                    });
                  });
                } else if (!hasImage) {
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
