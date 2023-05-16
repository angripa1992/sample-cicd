import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../core/provider/image_url_provider.dart';
import '../../../../../resources/assets.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class MenuItemImageView extends StatelessWidget {
  final String image;
  final String? available;
  static const _outOfStock = 'Out of Stock';
  static const _unavailable = 'Unavailable';

  const MenuItemImageView({Key? key, required this.image, this.available})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CachedNetworkImage(
        imageUrl: ImageUrlProvider.getUrl(image),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSize.s8.rSp),
              topRight: Radius.circular(AppSize.s8.rSp),
            ),
            shape: BoxShape.rectangle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              if (available == _outOfStock) _getBlurImage(),
              if (available == _outOfStock) _unavailableMessage(),
            ],
          ),
        ),
        progressIndicatorBuilder: (_, __, ___) => Center(
          child: SizedBox(
            height: AppSize.s14.rh,
            width: AppSize.s16.rw,
            child: const CircularProgressIndicator(strokeWidth: 1,),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSize.s8.rSp),
              topRight: Radius.circular(AppSize.s8.rSp),
            ),
            color: const Color(0xFFF0E7FE),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Center(
                child: SvgPicture.asset(
                  AppImages.placeholder,
                  fit: BoxFit.cover,
                ),
              ),
              if (available == _outOfStock) _getBlurImage(),
              if (available == _outOfStock) _unavailableMessage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBlurImage() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSize.s8.rSp),
            topRight: Radius.circular(AppSize.s8.rSp),
          ),
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _unavailableMessage() {
    return Text(
      available!,
      style: getRegularTextStyle(
        color: AppColors.white,
        fontSize: AppFontSize.s14.rSp,
      ),
    );
  }
}
