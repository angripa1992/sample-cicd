import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/assets.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class PrintButton extends StatelessWidget {
  final VoidCallback onPrint;
  final double padding;

  const PrintButton(
      {Key? key, required this.onPrint, this.padding = AppSize.s32})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s32.rh,
      child: ElevatedButton(
        onPressed: onPrint,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: padding.rw),
          primary: AppColors.purpleBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s24.rSp), // <-- Radius
          ),
        ),
        child: Text(
          'Print',
          style: getMediumTextStyle(
            color: AppColors.white,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
      ),
    );
  }
}

class ReadyButton extends StatelessWidget {
  final VoidCallback onReady;

  const ReadyButton({
    Key? key,
    required this.onReady,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s32.rh,
      child: ElevatedButton(
        onPressed: onReady,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
          primary: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s24.rSp),
            side: BorderSide(color: AppColors.purpleBlue),
          ),
        ),
        child: Text(
          'Ready',
          style: getMediumTextStyle(
            color: AppColors.purpleBlue,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
      ),
    );
  }
}

class DeliverButton extends StatelessWidget {
  final VoidCallback onDeliver;

  const DeliverButton({
    Key? key,
    required this.onDeliver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s32.rh,
      child: ElevatedButton(
        onPressed: onDeliver,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
          primary: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s24.rSp),
            side: BorderSide(color: AppColors.purpleBlue),
          ),
        ),
        child: Text(
          'Deliver',
          style: getMediumTextStyle(
            color: AppColors.purpleBlue,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
      ),
    );
  }
}

class AcceptButton extends StatelessWidget {
  final VoidCallback onAccept;

  const AcceptButton({
    Key? key,
    required this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s32.rh,
      child: ElevatedButton(
        onPressed: onAccept,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
          primary: AppColors.purpleBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s24.rSp),
          ),
        ),
        child: const Icon(Icons.check),
      ),
    );
  }
}

class CanceledButton extends StatelessWidget {
  final VoidCallback onCanceled;

  const CanceledButton({
    Key? key,
    required this.onCanceled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s32.rh,
      child: ElevatedButton(
        onPressed: onCanceled,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
          primary: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s24.rSp),
            side: BorderSide(color: AppColors.black),
          ),
        ),
        child: SvgPicture.asset(AppIcons.canceled),
      ),
    );
  }
}
