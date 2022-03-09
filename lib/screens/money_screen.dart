import 'package:eyeassistant/camera.dart';
import 'package:eyeassistant/widgets/constants/constants.dart';
import 'package:eyeassistant/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class ESMoneyIdentifier extends StatefulWidget {
  const ESMoneyIdentifier({Key? key}) : super(key: key);

  @override
  State<ESMoneyIdentifier> createState() => _ESMoneyIdentifierState();
}

class _ESMoneyIdentifierState extends State<ESMoneyIdentifier> {
  Camera image = Camera();
  FlutterTts flutterTts = FlutterTts();
  String? imagePath;
  bool hasImage = false;
  String camera = 'Camera';
  String gallery = 'Gallery';
  String result = '';

  Future<void> getImage(ImageSource source) async {
    await image.getImage(source);
    setState(() {
      hasImage = true;
      imagePath = image.image?.path;
      processImage();
    });
  }

  loadModel() async {
    String? res = await Tflite.loadModel(
        model: "assets/model/ph_currency.tflite",
        labels: "assets/model/ph_currency.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false);

    debugPrint(res);
  }

  Future<void> processImage() async {
    var recognitions = await Tflite.runModelOnImage(
        path: imagePath!,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true);

    for (var output in recognitions!) {
      debugPrint(output.toString());
      if (mounted) {
        if (output['confidence'] > .5) {
          setState(() {
            result += output['label'].toString() + '\n';
            outputTTS();
          });
        } else {
          outputTTSerror();
        }
      }
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
    loadModel();
    super.initState();
  }

  @override
  void dispose() {
    Tflite.close();
    flutterTts.stop();
    super.dispose();
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
        color: Colors.green[700]!,
        title: 'Money Identifier',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: imageContainer(context),
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
                  // flutterTts.speak(camera);
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
                    // flutterTts.speak(gallery);
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageContainer(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            builder: (context) {
              return Container(
                child: _bottomSheet(context),
              );
            });
      },
      child: Container(
        child: hasImage ? Image.file(image.image!) : getChildContainer(),
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
            border: Border.all(color: ESColor.gray, width: ESGrid.xxSmall),
            borderRadius:
                const BorderRadius.all(Radius.circular(ESGrid.xSmall))),
      ),
    );
  }

  Column _bottomSheet(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text('Camera'),
          onTap: () {
            getImage(ImageSource.camera);
            result = '';
            // flutterTts.stop();
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_album),
          title: const Text('Gallery'),
          onTap: () {
            getImage(ImageSource.gallery);
            // flutterTts.stop();
            result = '';
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  Column getChildContainer() {
    return Column(
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
    );
  }
}
