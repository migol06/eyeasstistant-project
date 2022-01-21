import 'dart:io';

import 'package:eyeassistant/widgets/constants/constants.dart';
import 'package:eyeassistant/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ESTextImageScreen extends StatefulWidget {
  const ESTextImageScreen({Key? key}) : super(key: key);

  @override
  State<ESTextImageScreen> createState() => _ESTextImageScreenState();
}

class _ESTextImageScreenState extends State<ESTextImageScreen> {
  bool hasImage = false;
  File? image;

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
        hasImage = true;
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
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
      body: Column(
        children: [_blankContainer(context), _getButton()],
      ),
    );
  }

  Widget _getButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed: () {
              getImage(ImageSource.camera);
            },
            child: const ESText('Camera')),
        ElevatedButton(
            onPressed: () {
              getImage(ImageSource.gallery);
            },
            child: const ESText('Gallery'))
      ],
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
          },
        )
      ],
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
