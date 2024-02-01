import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/resource_resolver.dart';

import '../../../../../core/provider/date_time_provider.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class ScheduledDetailsView extends StatelessWidget {
  final String scheduleTime;

  const ScheduledDetailsView({Key? key, required this.scheduleTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.warningY50,
      child: Row(
        children: [
          Container(width: AppSize.s4.rw, constraints: BoxConstraints(minHeight: AppSize.s32.rh), color: AppColors.warningY300),
          AppSize.s12.horizontalSpacer(),
          ImageResourceResolver.timeSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh, color: AppColors.warningY300),
          SizedBox(width: AppSize.s4.rw),
          Text(
            '${AppStrings.scheduled.tr()} - ${DateTimeFormatter.scheduleDate(scheduleTime)}, ${DateTimeFormatter.scheduleTime(scheduleTime)}',
            style: mediumTextStyle(
              color: AppColors.neutralB700,
              fontSize: AppFontSize.s12.rSp,
            ),
          ),
          const Spacer()
        ],
      ),
    );
  }
}
