import 'package:eyeassistant/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'constants/constants.dart';

class ESHomeButton extends StatelessWidget {
  final String title;
  final String desc;
  final Color backGroundColor;
  final VoidCallback? onTap;

  const ESHomeButton(
      {Key? key,
      required this.title,
      required this.desc,
      required this.backGroundColor,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * .85,
        decoration: BoxDecoration(
            color: backGroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(ESGrid.small)),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 8), blurRadius: 4, color: ESColor.gray)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(ESGrid.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _getIcon(),
                ],
              ),
              const SizedBox(
                height: ESGrid.xxxLarge,
              ),
              ESText(
                title,
                color: Colors.white,
                weight: ESTextWeight.bold,
                size: ESTextSize.xxLarge,
              ),
              ESText(
                desc,
                color: Colors.white,
                weight: ESTextWeight.light,
                size: ESTextSize.medium,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getIcon() {
    if (title.toUpperCase() == 'LIVE CAMERA') {
      return const Icon(
        Icons.videocam_outlined,
        color: Colors.white,
        size: ESGrid.xxLarge,
      );
    } else {
      return const Icon(
        Icons.notes_outlined,
        color: Colors.white,
        size: ESGrid.xxLarge,
      );
    }
  }
}
