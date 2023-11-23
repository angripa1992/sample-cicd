import 'asset_resolver/svg_image_resource.dart';

const String assetBasePath = 'assets';
const String fontBasePath = '$assetBasePath/fonts';
const String imageBasePath = '$assetBasePath/images';
const String iconBasePath = '$assetBasePath/icons';

class ImageResourceResolver {
  static SVGImageResource get logoutSVG => SVGImageResource('$iconBasePath/ic_logout.svg');
}
