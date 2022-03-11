import 'package:eyeassistant/widgets/constants/constants.dart';
import 'package:flutter/material.dart';

class ESImageContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback onTapCamera;
  final VoidCallback onTapGallery;
  const ESImageContainer(
      {Key? key,
      required this.child,
      required this.onTapCamera,
      required this.onTapGallery})
      : super(key: key);

  @override
  State<ESImageContainer> createState() => _ESImageContainerState();
}

class _ESImageContainerState extends State<ESImageContainer> {
  Column _bottomSheet(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: widget.onTapCamera),
        ListTile(
            leading: const Icon(Icons.photo_album),
            title: const Text('Gallery'),
            onTap: widget.onTapGallery)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                child: _bottomSheet(context),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
              border: Border.all(color: ESColor.gray, width: ESGrid.xxSmall),
              borderRadius:
                  const BorderRadius.all(Radius.circular(ESGrid.xSmall))),
          child: widget.child,
        ),
      ),
    );
  }
}
