import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../core/provider/image_url_provider.dart';
import '../../../../../resources/assets.dart';
import '../../../../../resources/values.dart';

class MenuItemImageView extends StatelessWidget {
  final String image;

  const MenuItemImageView({Key? key, required this.image}) : super(key: key);

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
              //_getBlurImage(),
              //Text('Out')
            ],
          ),
        ),
        progressIndicatorBuilder: (_, __, ___) => Padding(
          padding: EdgeInsets.only(top: AppSize.s8.rh),
          child: const Center(
            child: CircularProgressIndicator(),
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
             // _getBlurImage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBlurImage(){
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
}
