import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/decorated_image_view.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

class TestPrint extends StatelessWidget {
  const TestPrint({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(13.rSp),
      child: Row(
        children: [
          DecoratedImageView(
            iconWidget: ImageResourceResolver.printerSVG.getImageWidget(
              height: 20.rh,
              width: 20.rw,
              color: AppColors.primaryP300,
            ),
            padding: EdgeInsets.all(6.rSp),
            decoration: BoxDecoration(
              color: AppColors.primaryLighter,
              borderRadius: BorderRadius.all(
                Radius.circular(200.rSp),
              ),
            ),
          ),
          SizedBox(width: 12.rw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.test_print.tr(),
                  style: semiBoldTextStyle(fontSize: AppFontSize.s14.rSp, color: AppColors.black),
                ),
                Text(
                  AppStrings.test_print_description.tr(),
                  style: regularTextStyle(
                    color: AppColors.neutralB100,
                    fontSize: AppFontSize.s12.rSp,
                  ),
                )
              ],
            ),
          ),
          KTButton(
            controller: KTButtonController(label: AppStrings.test_print.tr()),
            backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.primaryP50),
            prefixWidget: SizedBox(
              width: 20.rw,
            ),
            labelStyle: mediumTextStyle(color: AppColors.primaryP300),
            suffixWidget: SizedBox(
              width: 20.rw,
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
