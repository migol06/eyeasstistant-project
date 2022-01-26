import 'package:flutter/material.dart';

class ESTextArea extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ESTextArea({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .20,
            width: MediaQuery.of(context).size.width * .80,
            decoration: BoxDecoration(border: Border.all()),
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: SelectableText(text),
          ),
          IconButton(
              onPressed: onTap,
              icon: const Icon(
                Icons.copy,
                color: Colors.black,
              ))
        ],
      ),
    );
  }
}
