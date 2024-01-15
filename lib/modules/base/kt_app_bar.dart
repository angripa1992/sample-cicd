import 'dart:io';

import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class KTAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double? height;
  final String title;
  final String? subtitle;
  final double? elevation;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final Function()? onNavBack;

  const KTAppBar({
    Key? key,
    this.height,
    required this.title,
    this.subtitle,
    this.elevation,
    this.bottom,
    this.actions,
    this.onNavBack,
  }) : super(key: key);

  @override
  Size get preferredSize {
    return Size.fromHeight(height ?? kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: height,
      elevation: elevation ?? 0,
      bottom: bottom,
      leading: IconButton(
        onPressed: () {
          onNavBack != null ? onNavBack!() : Navigator.of(context).pop();
        },
        icon: ImageResourceResolver.navBackSVG.getImageWidget(width: AppSize.s24.rw, height: AppSize.s24.rh, color: AppColors.neutralB600),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(title, style: mediumTextStyle(fontSize: AppSize.s16.rSp, color: AppColors.neutralB700)),
          if (subtitle != null)
            Column(
              children: [
                const SizedBox(
                  height: 6,
                ),
                Text(subtitle!, style: regularTextStyle(fontSize: 12, color: AppColors.neutralB500)),
              ],
            ),
        ],
      ),
      titleSpacing: 0,
      backgroundColor: Colors.white,
      actions: actions,
    );
  }
}
