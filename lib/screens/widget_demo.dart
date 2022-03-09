import 'package:eyeassistant/widgets/constants/constants.dart';
import 'package:eyeassistant/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ESWidgetDemo extends StatefulWidget {
  const ESWidgetDemo({Key? key}) : super(key: key);

  @override
  _ESWidgetDemoState createState() => _ESWidgetDemoState();
}

class _ESWidgetDemoState extends State<ESWidgetDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo Widgets"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ESText.title("Eyesisstant"),
            const SizedBox(height: ESGrid.small),
            const ESText(
              'This is a demo Text',
              color: ESColor.scorpion,
              size: ESTextSize.small,
              weight: ESTextWeight.bold,
              style: ESTextStyle.normal,
            ),
            const SizedBox(
              height: ESGrid.large,
            ),
            const ESText(
              'This is a demo2 Text',
              color: ESColor.orange,
              size: ESTextSize.large,
              weight: ESTextWeight.extraBold,
              style: ESTextStyle.normal,
            ),
            const SizedBox(
              height: ESGrid.large,
            ),
            // ESAppBar(
            //   onTap: () {
            //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //       content: Text("Sending Message"),
            //     ));
            //   },
            // ),
            const SizedBox(
              height: ESGrid.large,
            ),
            // ESHomeButton(
            //   title: 'Live Camera',
            //   desc: 'Can identify Objects',
            //   backGroundColor: ESColor.primaryBlue,
            //   onTap: () {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(content: Text("Sending Message")));
            //   },
            // ),
            // const SizedBox(
            //   height: ESGrid.large,
            // ),
            // const ESHomeButton(
            //     title: 'Text Recognition',
            //     desc: 'Lorem ipsum dolor',
            //     backGroundColor: ESColor.orange)
          ],
        ),
      ),
    );
  }
}
