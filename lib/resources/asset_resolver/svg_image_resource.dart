import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'image_resource.dart';

class SVGImageResource implements ImageResource {
  final String name;

  SVGImageResource(this.name);

  @override
  Widget getImageWidget({double? width, double? height, Color? color, BoxFit? boxFit}) {
    return SvgPicture.asset(
      name,
      fit: boxFit ?? BoxFit.scaleDown,
      height: height,
      width: width,
      color: color,
    );
  }

  @override
  String get getPath {
    return name;
  }
}
