import 'package:eyeassistant/widgets/constants/constants.dart';
import 'package:eyeassistant/widgets/text.dart';
import 'package:flutter/material.dart';

class ESButton extends StatelessWidget {
  final IconData icon;
  final String description;
  final Color color;
  final VoidCallback? onTap;

  const ESButton(
      {Key? key,
      required this.icon,
      required this.description,
      required this.color,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * .20,
        height: MediaQuery.of(context).size.height * .15,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(ESGrid.small)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(
              height: ESGrid.small,
            ),
            ESText(
              description,
              color: Colors.white,
              size: ESTextSize.medium,
              weight: ESTextWeight.bold,
            )
          ],
        ),
      ),
    );
  }
}
