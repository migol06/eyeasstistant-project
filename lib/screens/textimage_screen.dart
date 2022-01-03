import 'package:eyeassistant/widgets/app_bar.dart';
import 'package:eyeassistant/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ESTextImageScreen extends StatelessWidget {
  const ESTextImageScreen({Key? key}) : super(key: key);

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
