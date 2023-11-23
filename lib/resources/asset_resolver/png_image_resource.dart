import 'package:flutter/material.dart';

import 'asset_image_provider.dart';
import 'image_resource.dart';

class PNGImageResource implements ImageResource, AssetImageProvider {
  final String name;

  const PNGImageResource(this.name);

  @override
  Widget getImageWidget({double? width, double? height, BoxFit? boxFit, Color? color}) {
    return Image.asset(
      name,
      height: height,
      width: width,
      fit: boxFit,
      color: color,
    );
  }

  @override
  String get getPath {
    return name;
  }

  @override
  AssetImage get assetImage {
    return AssetImage(name);
  }
}
