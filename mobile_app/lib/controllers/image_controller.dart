import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageController {
  Future<File> getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    File file = File(image!.path);
    return file;
  }
}
