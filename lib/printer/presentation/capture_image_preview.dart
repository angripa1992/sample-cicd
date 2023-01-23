import 'dart:typed_data';

import 'package:flutter/material.dart';

class CaptureImagePrivew extends StatelessWidget {
  final Uint8List? capturedImage;

  const CaptureImagePrivew({Key? key, required this.capturedImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: capturedImage != null
                ? Image.memory(
                    capturedImage!,
                    fit: BoxFit.cover,
                  )
                : Container()),
      ),
    );
  }
}
