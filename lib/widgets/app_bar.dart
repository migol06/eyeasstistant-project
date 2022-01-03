import 'package:flutter/material.dart';
import 'constants/constants.dart';

class ESAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onTap;

  const ESAppBar({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        'assets/images/eyessistant.png',
        scale: 3,
      ),
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ESColor.orange,
          )),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: onTap,
            child: const Icon(
              Icons.help_outline,
              color: ESColor.orange,
            ),
          ),
        )
      ],
      backgroundColor: ESColor.athensGray,
      toolbarHeight: 60,
      shadowColor: ESColor.gray.withOpacity(.3),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
