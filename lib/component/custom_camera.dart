import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CustomCamera {
  File? pickedFile;

  Future<File> pickFileFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      pickedFile = File(pickedImage.path);
      return pickedFile!;
      // Do something with the picked file
    } else {
      return File("");
      // Handle the case when no image is picked
    }
  }
}
