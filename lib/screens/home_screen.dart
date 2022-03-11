import 'package:eyeassistant/screens/screens.dart';
import 'package:eyeassistant/widgets/constants/constants.dart';
import 'package:eyeassistant/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ESHomeScreen extends StatelessWidget {
  const ESHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: mediaHeight * .45,
              color: ESColor.primaryBlue.withOpacity(0.5),
            ),
            SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(ESGrid.large),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: ESColor.orange.withOpacity(0.75),
                          shape: BoxShape.circle,
                        ),
                        child: PopupMenuButton(
                          icon: const Icon(Icons.more_vert_outlined),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                child: ListTile(
                                    title: const Text('About us'),
                                    onTap: () {
                                      showAboutDialog(
                                          context: context,
                                          applicationName: 'Eyessistant',
                                          applicationVersion: '1.0.0',
                                          applicationIcon: Image.asset(
                                            'assets/images/eyessistant.png',
                                            scale: 5,
                                          ),
                                          children: [
                                            const ESText('Lorem Ipsum Dolor')
                                          ]);
                                    }))
                          ],
                        ),
                      )),
                  const Image(
                      image: AssetImage('assets/images/eyessistant.png'),
                      width: ESGrid.xxxxxLarge,
                      height: ESGrid.xLarge),
                  const ESText(
                    'EYESSISTANT',
                    color: Colors.white,
                    size: ESTextSize.xLarge,
                    weight: ESTextWeight.bold,
                  ),
                  SizedBox(
                    height: mediaHeight * .10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ESHomeButton(
                        title: "Live Camera",
                        desc: 'Lorem ipsum Dolor',
                        backGroundColor: ESColor.primaryBlue,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const ESLiveCameraScreen()));
                        },
                        iconData: Icons.videocam_outlined,
                      ),
                      const SizedBox(
                        height: ESGrid.medium,
                      ),
                      ESHomeButton(
                        title: "Money Identifier",
                        desc: 'Lorem ipsum Dolor',
                        backGroundColor: Colors.green[700]!,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ESMoneyIdentifier()));
                        },
                        iconData: Icons.attach_money_outlined,
                      ),
                      const SizedBox(
                        height: ESGrid.medium,
                      ),
                      ESHomeButton(
                        title: 'Text Image Recognition',
                        desc: 'Lorem Ipsum Dolor',
                        backGroundColor: ESColor.orange,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ESTextImageScreen()));
                        },
                        iconData: Icons.notes_outlined,
                      )
                    ],
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
