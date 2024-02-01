import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/resource_resolver.dart';

import '../../../../../resources/assets.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class PrintButton extends StatelessWidget {
  final VoidCallback onPrint;
  final bool expanded;

  const PrintButton({
    Key? key,
    required this.onPrint,
    required this.expanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KTButton(
      controller: KTButtonController(label: expanded ? AppStrings.print.tr() : ''),
      prefixWidget: Padding(
        padding: EdgeInsets.symmetric(horizontal: expanded ? 0 : AppSize.s20.rw),
        child: ImageResourceResolver.printerSVG.getImageWidget(width: AppSize.s18.rw, height: AppSize.s18.rh, color: AppColors.neutralB400),
      ),
      backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.white, strokeColor: AppColors.greyBright),
      labelStyle: mediumTextStyle(fontSize: AppSize.s12.rSp, color: AppColors.neutralB700),
      splashColor: AppColors.greyBright,
      onTap: onPrint,
    );
  }
}

class PickedUpButton extends StatelessWidget {
  final VoidCallback onPickedUp;
  final bool enabled;
  final bool expanded;

  const PickedUpButton({
    Key? key,
    required this.onPickedUp,
    required this.enabled,
    required this.expanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s28.rh,
      child: ElevatedButton(
        onPressed: enabled ? onPickedUp : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            side: BorderSide(
              color: enabled ? AppColors.primary : Colors.transparent,
            ),
          ),
        ),
        child: Text(
          AppStrings.picked_up.tr(),
          style: mediumTextStyle(
            color: enabled ? AppColors.primary : AppColors.greyDarker,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  final VoidCallback onEdit;

  const EditButton({
    Key? key,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s28.rh,
      child: ElevatedButton(
        onPressed: onEdit,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            side: BorderSide(color: AppColors.primary),
          ),
        ),
        child: SvgPicture.asset(
          AppIcons.tablerEdit,
          color: AppColors.primary,
          height: AppSize.s16.rh,
          width: AppSize.s16.rw,
        ),
      ),
    );
  }
}

class FindRiderButton extends StatelessWidget {
  final VoidCallback onFound;

  const FindRiderButton({
    Key? key,
    required this.onFound,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s28.rh,
      child: ElevatedButton(
        onPressed: onFound,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s8.rSp), side: BorderSide(color: AppColors.primary)),
        ),
        child: Icon(
          Icons.delivery_dining_rounded,
          size: AppSize.s16.rSp,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
