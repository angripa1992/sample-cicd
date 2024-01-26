import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class LabeledView extends StatelessWidget {
  final String label;
  final Widget widget;

  const LabeledView({
    Key? key,
    required this.label,
    required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: mediumTextStyle(
            color: AppColors.black,
            fontSize: AppSize.s14.rSp,
          ),
        ),
        SizedBox(height: AppSize.s12.rh),
        widget
      ],
    );
  }
}
