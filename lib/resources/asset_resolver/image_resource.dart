import 'package:flutter/material.dart';

abstract class ImageResource {
  Widget getImageWidget({double? width, double? height, BoxFit? boxFit, Color? color});

  String get getPath;
}
