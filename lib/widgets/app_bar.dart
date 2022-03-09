import 'package:flutter/material.dart';
import 'constants/constants.dart';

class ESAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onTap;
  final String title;
  final Color color;

  const ESAppBar({
    Key? key,
    this.onTap,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          )),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: onTap,
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
