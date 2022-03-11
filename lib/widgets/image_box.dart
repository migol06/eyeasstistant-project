import 'package:eyeassistant/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'constants/constants.dart';

class ESBlankImageBox extends StatelessWidget {
  const ESBlankImageBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.image_outlined,
        ),
        SizedBox(
          height: ESGrid.medium,
        ),
        ESText(
          'Max file size 10MB, Minimum \nResolution 1024 x 1024',
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
