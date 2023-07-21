import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class CancellationReasonView extends StatelessWidget {
  final String cancellationReason;

  const CancellationReasonView({Key? key, required this.cancellationReason})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
        vertical: AppSize.s8.rh,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(),
          Text(
            'Cancellation Reason',
            style: boldTextStyle(
              color: AppColors.warmRed,
              fontSize: AppFontSize.s15.rSp,
            ),
          ),
          SizedBox(height: AppSize.s4.rh),
          Text(
            cancellationReason,
            style: regularTextStyle(
              color: AppColors.bluewood,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
