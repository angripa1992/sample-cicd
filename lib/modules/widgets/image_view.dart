import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/image_url_provider.dart';

import '../../resources/assets.dart';
import '../../resources/values.dart';

class ImageView extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;

  const ImageView({
    Key? key,
    required this.path,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: ImageUrlProvider.getUrl(path),
      imageBuilder: (context, imageProvider) => Container(
        width: width ?? AppSize.s48.rw,
        height: height ?? AppSize.s40.rh,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s8.rSp)),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(strokeWidth: AppSize.s2.rSp),
      ),
      errorWidget: (context, url, error) => SvgPicture.asset(
        AppImages.placeholder,
        height: height,
        width: width,
      ),
    );
  }
}
