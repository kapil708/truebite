import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreview extends StatelessWidget {
  final String filePath;

  const ImagePreview({
    super.key,
    required this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PhotoView(
          imageProvider: FileImage(File(filePath)),
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.contained * 3,
        ),
        Positioned(
          top: 48,
          right: 48,
          child: IconButton.filled(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
          ),
        ),
      ],
    );
  }
}
