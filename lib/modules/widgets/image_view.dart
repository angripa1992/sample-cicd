import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/image_url_provider.dart';

import '../../app/di.dart';
import '../../environment_variables.dart';
import '../../resources/values.dart';

class ImageView extends StatelessWidget {
  final envVariables = getIt.get<EnvironmentVariables>();
  final String path;
  final double? height;
  final double? width;

  ImageView({Key? key, required this.path, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? AppSize.s40.rh,
      width: width ?? AppSize.s40.rw,
      child: CachedNetworkImage(
        imageUrl: ImageUrlProvider.getUrl(path),
        placeholder: (context, url) => SizedBox(
          height: AppSize.s12.rh,
          width: AppSize.s12.rw,
          child: const CircularProgressIndicator(strokeWidth: 1,),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
