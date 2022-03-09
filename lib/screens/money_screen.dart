import 'package:eyeassistant/camera.dart';
import 'package:eyeassistant/widgets/constants/constants.dart';
import 'package:eyeassistant/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class ESMoneyIdentifier extends StatefulWidget {
  const ESMoneyIdentifier({Key? key}) : super(key: key);

  @override
  State<ESMoneyIdentifier> createState() => _ESMoneyIdentifierState();
}

class _ESMoneyIdentifierState extends State<ESMoneyIdentifier> {
  Camera image = Camera();
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
    });
  }

  loadModel() async {
    String? res = await Tflite.loadModel(
        model: "assets/model/ph_currency.tflite",
        labels: "assets/model/ph_currency.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );

    debugPrint(res);
  }

  Future<void> processImage() async {
    var recognitions = await Tflite.runModelOnImage(
        path: imagePath!, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );

    for (var output in recognitions!) {
      debugPrint(output.toString());
      if (mounted) {
        setState(() {
          result += output['label'].toString() + '\n';
        });
      }
    }
  }

  @override
  void initState() {
    loadModel();
    super.initState();
  }

  @override
  void dispose() {
    Tflite.close();
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
            size: ESTextSize.large,
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
          ESButton(
            icon: Icons.camera_alt,
            description: 'Camera',
            color: ESColor.orange,
            onTap: () {
              getImage(ImageSource.camera);
              // scanText = '';
              // flutterTts.speak(camera);
            },
          ),
          ESButton(
              icon: Icons.collections_outlined,
              description: 'Gallery',
              color: Colors.green,
              onTap: () {
                getImage(ImageSource.gallery);
                // scanText = '';
                // flutterTts.speak(gallery);
              }),
          ESButton(
              icon: Icons.document_scanner_outlined,
              description: 'Scan',
              color: ESColor.primaryBlue,
              onTap: () {
                processImage();
                // if (scanText.isEmpty && hasImage) {
                //   getText(imagePath);
                //   await Future.delayed(const Duration(seconds: 5), () {
                //     setState(() {
                //       _speech();
                //     });
                //   });
                // } else if (!hasImage) {
                //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //     content: Text('Please add an Image'),
                //   ));
                //   flutterTts.speak('Scan, Please add an Image');
                // } else {
                //   _speech();
                // }
              }),
          ESButton(
              icon: Icons.clear_outlined,
              description: 'Clear',
              color: Colors.red,
              onTap: () {
                setState(() {
                  // scanText = '';
                  hasImage = false;
                  // flutterTts.stop();
                  imagePath = '';
                });
              }),
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
            // scanText = '';
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
            // scanText = '';
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
