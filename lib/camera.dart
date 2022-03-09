import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class Camera {
  File? image;

  Future getImage(ImageSource source) async {
    try {
      XFile? imagePath = await ImagePicker().pickImage(source: source);

      if (imagePath == null) {
        return;
      } else {
        image = File(imagePath.path);
      }
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }
}
