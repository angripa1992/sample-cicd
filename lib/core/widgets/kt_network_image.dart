import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/decorated_image_view.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/resource_resolver.dart';

class KTNetworkImage extends StatelessWidget {
  final double? width;
  final double? height;
  final String imageUrl;
  final BoxFit boxFit;
  final BoxShape boxShape;
  final Decoration? imageDecoration;
  final Widget? errorWidget;
  final double? widgetPadding;

  const KTNetworkImage({
    Key? key,
    this.width,
    this.height,
    required this.imageUrl,
    this.boxFit = BoxFit.contain,
    this.boxShape = BoxShape.circle,
    this.imageDecoration,
    this.errorWidget,
    this.widgetPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) =>
          Container(width: width, height: height, decoration: imageDecoration ?? BoxDecoration(shape: boxShape, image: DecorationImage(image: imageProvider, fit: boxFit))),
      progressIndicatorBuilder: (context, url, progress) {
        return buildPlaceholder(boxShape, CircularProgress(size: 34.rSp, strokeWidth: 2.rSp), widgetPadding);
      },
      errorWidget: (context, url, error) => errorWidget ?? buildPlaceholder(boxShape, ImageResourceResolver.userSVG.getImageWidget(width: 32.rw, height: 32.rh), widgetPadding),
    );
  }
}

Widget buildPlaceholder(BoxShape boxShape, Widget iconWidget, double? padding) {
  return DecoratedImageView(
    iconWidget: iconWidget,
    padding: padding == null ? null : EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: AppColors.primaryLighter,
      borderRadius: boxShape == BoxShape.circle
          ? BorderRadius.all(
              Radius.circular(200.rSp),
            )
          : null,
    ),
  );
}
