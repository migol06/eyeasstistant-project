import 'package:flutter/material.dart';
import 'constants/constants.dart';

class ESAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onTapButton;
  final VoidCallback onBackButton;
  final String title;
  final Color color;

  const ESAppBar({
    Key? key,
    this.onTapButton,
    required this.title,
    required this.color,
    required this.onBackButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
          onPressed: onBackButton,
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          )),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: onTapButton,
            child: const Icon(
              Icons.help_outline,
              color: Colors.white,
            ),
          ),
        )
      ],
      backgroundColor: color,
      toolbarHeight: 60,
      shadowColor: ESColor.gray.withOpacity(.3),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
