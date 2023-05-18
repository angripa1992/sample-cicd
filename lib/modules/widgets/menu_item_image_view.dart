import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';

import '../../core/provider/image_url_provider.dart';
import '../../resources/assets.dart';
import '../../resources/values.dart';

class MenuItemImageView extends StatelessWidget {
  final String url;
  const MenuItemImageView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s48.rh,
      width: AppSize.s48.rw,
      child: CachedNetworkImage(
        imageUrl: ImageUrlProvider.getUrl(url),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            shape: BoxShape.rectangle,
            image: DecorationImage(
                image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        progressIndicatorBuilder: (_, __, ___) => Center(
          child: SizedBox(
            height: AppSize.s16.rh,
            width: AppSize.s16.rw,
            child: const CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Center(
          child: SvgPicture.asset(
            AppImages.placeholder,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
