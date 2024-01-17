import 'dart:developer';
import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Helper {
  final ImagePicker picker = ImagePicker();

  Future<File?> singleImagePicker(ImageSource source, {bool allowOriginal = false}) async {
    try {
      CroppedFile? file;

      XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        file = await ImageCropper().cropImage(sourcePath: image.path);
      }

      if (file != null) {
        return File(file.path);
      } else {
        return null;
      }
    } on Exception catch (e) {
      var data = {
        'error': e.toString(),
        'source': source.toString(),
      };
      log("singleImagePicker Exception: $data");
      return null;
    } catch (e) {
      var data = {
        'error': e.toString(),
        'source': source.toString(),
      };
      log("singleImagePicker catch: $data");
      return null;
    }
  }
}
