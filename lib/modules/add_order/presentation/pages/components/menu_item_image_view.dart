import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';

import '../../../../../app/enums.dart';
import '../../../../../core/provider/image_url_provider.dart';
import '../../../../../resources/assets.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';

class MenuItemImageView extends StatelessWidget {
  final String image;
  final MenuAvailability availability;

  const MenuItemImageView({
    Key? key,
    required this.image,
    required this.availability,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CachedNetworkImage(
        imageUrl: ImageUrlProvider.getUrl(image),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.rSp)),
            shape: BoxShape.rectangle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              if (availability != MenuAvailability.AVAILABLE) _getBlurImage(),
              if (availability == MenuAvailability.OUT_OF_STOCK) _outOfStockMessage(),
            ],
          ),
        ),
        progressIndicatorBuilder: (_, __, ___) => Center(
          child: SizedBox(
            height: 14.rh,
            width: 16.rw,
            child: const CircularProgress(strokeWidth: 1),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.rSp)),
            color: const Color(0xFFF0E7FE),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Center(
                child: SvgPicture.asset(AppImages.placeholder, fit: BoxFit.cover),
              ),
              if (availability != MenuAvailability.AVAILABLE) _getBlurImage(),
              if (availability == MenuAvailability.OUT_OF_STOCK) _outOfStockMessage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBlurImage() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.rSp)),
          color: AppColors.blur,
        ),
      ),
    );
  }

  Widget _outOfStockMessage() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.rw, vertical: 2.rh),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.rSp),
      ),
      child: Text(
        AppStrings.out_of_stock.tr(),
        style: regularTextStyle(
          color: AppColors.blur,
          fontSize: 12.rSp,
        ),
      ),
    );
  }
}
