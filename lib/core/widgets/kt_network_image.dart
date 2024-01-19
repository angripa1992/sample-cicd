import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/decorated_image_view.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';
import 'package:klikit/env/environment_variables.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/resource_resolver.dart';

class KTNetworkImage extends StatelessWidget {
  final double? width;
  final double? height;
  final String imageUrl;
  final BoxFit boxFit;
  final BoxShape boxShape;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;
  final double? widgetPadding;
  final double? imageBorderWidth;

  const KTNetworkImage({
    Key? key,
    this.width,
    this.height,
    required this.imageUrl,
    this.boxFit = BoxFit.contain,
    this.boxShape = BoxShape.circle,
    this.borderRadius,
    this.errorWidget,
    this.widgetPadding,
    this.imageBorderWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '${getIt.get<EnvironmentVariables>().cdnUrl}/$imageUrl',
      imageBuilder: (context, imageProvider) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              border: Border.all(width: imageBorderWidth ?? 2.rSp, color: AppColors.greyBright),
              borderRadius: boxShape != BoxShape.circle ? borderRadius : null,
              shape: boxShape,
              image: DecorationImage(image: imageProvider, fit: boxFit))),
      progressIndicatorBuilder: (context, url, progress) {
        final circleSize = (((width ?? 34.rw) + (height ?? 34.rh)) / 2);
        return buildPlaceholder(boxShape, CircularProgress(size: circleSize, strokeWidth: 2.rSp), 0, borderRadius);
      },
      errorWidget: (context, url, error) => errorWidget ?? buildPlaceholder(boxShape, ImageResourceResolver.placeholderSVG.getImageWidget(width: width, height: height), widgetPadding, borderRadius),
    );
  }
}

Widget buildPlaceholder(BoxShape boxShape, Widget iconWidget, double? padding, BorderRadius? borderRadius) {
  return DecoratedImageView(
    iconWidget: iconWidget,
    padding: padding == null ? null : EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: AppColors.primaryLighter,
      borderRadius: boxShape == BoxShape.circle
          ? BorderRadius.all(
              Radius.circular(200.rSp),
            )
          : borderRadius,
    ),
  );
}
