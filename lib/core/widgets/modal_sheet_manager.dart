import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class ModalSheetManager {
  static Future<dynamic> openBottomSheet(
    BuildContext context,
    Widget widget, {
    String? title,
    bool showCloseButton = true,
    dismissible = true,
    isScrollControlled = true,
    enableDrag = false,
    RouteSettings? routeSettings,
  }) async {
    return await showModalBottomSheet(
      context: context,
      isDismissible: dismissible,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      routeSettings: routeSettings,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.rSp),
          topRight: Radius.circular(16.rSp),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(top: 24.rh, bottom: 20.rh),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null || showCloseButton)
                Row(
                  children: [
                    16.horizontalSpacer(),
                    if (title != null)
                      Text(
                        title,
                        style: semiBoldTextStyle(
                          color: AppColors.black,
                          fontSize: AppFontSize.s16.rSp,
                        ),
                      ),
                    const Spacer(),
                    if (showCloseButton)
                      InkWell(
                        child: ImageResourceResolver.closeSVG.getImageWidget(width: 20.rw, height: 20.rh),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    16.horizontalSpacer(),
                  ],
                ),
              if (title != null || showCloseButton) const Divider().setVisibilityWithSpace(direction: Axis.vertical, startSpace: 12, endSpace: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
                child: widget,
              )
            ],
          ),
        );
      },
    );
  }

  static Future showModalTopSheet(
    BuildContext context,
    Widget widget, {
    dismissible = true,
    barrierColor = Colors.grey,
    RouteSettings? routeSettings,
  }) {
    Widget childWrapper = Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: ModalBarrier(
              dismissible: dismissible,
              color: barrierColor,
            ),
          ),
          widget,
        ],
      ),
    );
    return Navigator.push(
      context,
      PageRouteBuilder(
        settings: routeSettings,
        pageBuilder: (context, animation, secondaryAnimation) => childWrapper,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, -4.0);
          const end = Offset.zero;
          const curve = Curves.decelerate;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: tween.animate(animation),
            child: child,
          );
        },
        opaque: false,
        barrierDismissible: true,
        barrierColor: const Color.fromRGBO(100, 100, 100, 0.5),
        //color of the grayed under
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}
