import 'dart:io';

import 'package:eyeassistant/widgets/constants/constants.dart';
import 'package:eyeassistant/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ESTextImageScreen extends StatefulWidget {
  const ESTextImageScreen({Key? key}) : super(key: key);

  @override
  State<ESTextImageScreen> createState() => _ESTextImageScreenState();
}

class _ESTextImageScreenState extends State<ESTextImageScreen> {
  bool hasImage = false;
  File? image;
  TextDetector textDetector = GoogleMlKit.vision.textDetector();
  String? imagePath;
  String scanText = '';

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
        imagePath = imageTemporary.path;
        debugPrint(imagePath);
        hasImage = true;
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  Future getText(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);

    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          setState(() {
            scanText = scanText + '   ' + element.text;
            debugPrint(scanText);
          });
        }
        scanText = scanText + '\n';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ESAppBar(
        onTap: () {
          showAboutDialog(
              context: context,
              applicationName: 'Text Image Screen',
              applicationIcon: Image.asset(
                'assets/images/eyessistant.png',
                scale: 5,
              ),
              children: [const ESText('Lorem Ipsum Dolor')]);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            hasImage ? _imageContainer() : _blankContainer(context),
            _getButton(),
            ESText(scanText)
          ],
        ),
      ),
    );
  }

  Widget _getButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ESButton(
            icon: Icons.camera_alt,
            description: 'Camera',
            color: ESColor.orange,
            onTap: () {
              getImage(ImageSource.camera);
              // getText(imagePath!);
            },
          ),
          ESButton(
              icon: Icons.photo_album,
              description: 'Scan',
              color: ESColor.primaryBlue,
              onTap: () => getText(imagePath!)),
        ],
      ),
    );
  }

  Column _bottomSheet(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text('Camera'),
          onTap: () {
            getImage(ImageSource.camera);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_album),
          title: const Text('Gallery'),
          onTap: () {
            getImage(ImageSource.gallery);
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  Widget _imageContainer() {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                child: _bottomSheet(context),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
                border: Border.all(color: ESColor.gray, width: ESGrid.xxSmall),
                borderRadius:
                    const BorderRadius.all(Radius.circular(ESGrid.xSmall))),
            child: Image.file(image!)),
      ),
    );
  }

  Widget _blankContainer(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                child: _bottomSheet(context),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
              border: Border.all(color: ESColor.gray, width: ESGrid.xxSmall),
              borderRadius:
                  const BorderRadius.all(Radius.circular(ESGrid.xSmall))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.image_outlined,
              ),
              SizedBox(
                height: ESGrid.medium,
              ),
              ESText(
                'Max file size 10MB, Minimum \nResolution 1024 x 1024',
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
