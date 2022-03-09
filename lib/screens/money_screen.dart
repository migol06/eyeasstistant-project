import 'package:eyeassistant/camera.dart';
import 'package:eyeassistant/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ESMoneyIdentifier extends StatefulWidget {
  const ESMoneyIdentifier({Key? key}) : super(key: key);

  @override
  State<ESMoneyIdentifier> createState() => _ESMoneyIdentifierState();
}

class _ESMoneyIdentifierState extends State<ESMoneyIdentifier> {
  Camera camera = Camera();
  String? imagePath;
  bool hasImage = false;

  Future<void> getImage(ImageSource source) async {
    await camera.getImage(source);
    setState(() {
      hasImage = true;
      imagePath = camera.image?.path;
    });
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
          ElevatedButton(
              onPressed: () {
                getImage(ImageSource.camera);
              },
              child: const Text('Camera')),
          ElevatedButton(
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              child: const Text('Gallery')),
          ElevatedButton(
              onPressed: () {
                // processImageWithRemoteModel(imagePath);
                // processImage();
              },
              child: const Text('Scan')),
          Text(
            'Hello',
          )
        ],
      ),
    );
  }

  Widget imageContainer(BuildContext context) {
    return Container(
      child: hasImage ? Image.file(camera.image!) : const Text('Text'),
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 5.0),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
    );
  }
}
