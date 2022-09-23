import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../widgets/shimmer/container_shimmer.dart';

class HomeOrderNavCardShimmer extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textBaseColor;
  final Color textHighlightColor;
  final Color containerBaseColor;
  final Color containerHighlightColor;

  const HomeOrderNavCardShimmer({
    Key? key,
    required this.bgColor,
    required this.text,
    required this.textBaseColor,
    required this.textHighlightColor,
    required this.containerBaseColor,
    required this.containerHighlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgColor,
      shadowColor: AppColors.smokeyGrey,
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s20.rw,
          vertical: AppSize.s12.rh,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: textBaseColor,
              highlightColor: textHighlightColor,
              child: Text(
                text,
                style: getRegularTextStyle(
                  color: textBaseColor,
                  fontSize: AppFontSize.s15.rSp,
                ),
              ),
            ),
            const Spacer(),
            ContainerShimmer(
              baseColor: containerBaseColor,
              highlightColor: containerHighlightColor,
              height: AppFontSize.s14.rh,
              width: AppSize.s32.rw,
            ),
            SizedBox(width: AppSize.s20.rw),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: textBaseColor,
            ),
          ],
        ),
      ),
    );
  }
}
