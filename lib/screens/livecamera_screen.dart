import 'package:eyeassistant/widgets/app_bar.dart';
import 'package:eyeassistant/widgets/text.dart';
import 'package:flutter/material.dart';

class ESLiveCameraScreen extends StatelessWidget {
  const ESLiveCameraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ESAppBar(
        onTap: () {
          showAboutDialog(
              context: context,
              applicationName: 'Eyessistant',
              children: [const ESText('Lorem Ipsum Dolor')]);
        },
      ),
    );
  }
}
