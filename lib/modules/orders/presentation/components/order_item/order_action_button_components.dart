import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/assets.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class PrintButton extends StatelessWidget {
  final VoidCallback onPrint;
  final double padding;
  final bool expanded;

  const PrintButton({
    Key? key,
    required this.onPrint,
    this.padding = AppSize.s32,
    required this.expanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s28.rh,
      child: ElevatedButton(
        onPressed: onPrint,
        style: ElevatedButton.styleFrom(
            minimumSize: Size.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            ),
            side: BorderSide(color: AppColors.primary)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.print,
              size: AppSize.s16.rSp,
              color: AppColors.primary,
            ),
            if (expanded)
              Padding(
                padding: EdgeInsets.only(left: AppSize.s8.rw),
                child: Text(
                  AppStrings.print.tr(),
                  style: mediumTextStyle(
                    color: AppColors.primary,
                    fontSize: AppFontSize.s12.rSp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ReadyButton extends StatelessWidget {
  final VoidCallback onReady;
  final bool enabled;
  final bool expanded;

  const ReadyButton({
    Key? key,
    required this.onReady,
    required this.enabled,
    required this.expanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s28.rh,
      child: ElevatedButton(
        onPressed: enabled ? onReady : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            side: BorderSide(
              color: enabled ? AppColors.primary : Colors.transparent,
            ),
          ),
        ),
        child: Text(
          AppStrings.ready.tr(),
          style: mediumTextStyle(
            color: enabled ? AppColors.primary : AppColors.greyDarker,
            fontSize: AppFontSize.s12.rSp,
          ),
        ),
      ),
    );
  }
}

class DeliverButton extends StatelessWidget {
  final VoidCallback onDeliver;
  final bool enabled;
  final bool expanded;

  const DeliverButton({
    Key? key,
    required this.onDeliver,
    required this.enabled,
    required this.expanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s28.rh,
      child: ElevatedButton(
        onPressed: enabled ? onDeliver : null,
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
          AppStrings.deliver.tr(),
          style: mediumTextStyle(
            color: enabled ? AppColors.primary : AppColors.greyDarker,
            fontSize: AppFontSize.s12.rSp,
          ),
        ),
      ),
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

class AcceptButton extends StatelessWidget {
  final VoidCallback onAccept;
  final bool enabled;
  final bool expanded;

  const AcceptButton({
    Key? key,
    required this.onAccept,
    required this.enabled,
    required this.expanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s28.rh,
      child: ElevatedButton(
        onPressed: enabled ? onAccept : null,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              size: AppSize.s16.rSp,
              color: enabled ? AppColors.primary : AppColors.greyDarker,
            ),
            if (expanded)
              Padding(
                padding: EdgeInsets.only(left: AppSize.s8.rw),
                child: Text(
                  AppStrings.accept.tr(),
                  style: mediumTextStyle(
                    color: enabled ? AppColors.primary : AppColors.greyDarker,
                    fontSize: AppFontSize.s12.rSp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CanceledButton extends StatelessWidget {
  final VoidCallback onCanceled;
  final bool enabled;
  final bool expanded;

  const CanceledButton({
    Key? key,
    required this.onCanceled,
    required this.enabled,
    required this.expanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s28.rh,
      child: ElevatedButton(
        onPressed: enabled ? onCanceled : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            side: BorderSide(color: enabled ? AppColors.red : Colors.transparent),
          ),
        ),
        child: expanded
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.clear, color: enabled ? AppColors.red : AppColors.greyDarker),
                  if (expanded)
                    Padding(
                      padding: EdgeInsets.only(left: AppSize.s8.rw),
                      child: Text(
                        AppStrings.reject.tr(),
                        style: mediumTextStyle(
                          color: enabled ? AppColors.red : AppColors.greyDarker,
                          fontSize: AppFontSize.s12.rSp,
                        ),
                      ),
                    ),
                ],
              )
            : Icon(
                Icons.clear,
                size: AppSize.s16.rSp,
                color: enabled ? AppColors.red : AppColors.greyDarker,
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
