import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../core/provider/date_time_provider.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class ScheduledDetailsView extends StatelessWidget {
  final String scheduleTime;

  ScheduledDetailsView({Key? key, required this.scheduleTime})
      : super(key: key);

  final _textStyle = mediumTextStyle(
    color: AppColors.white,
    fontSize: AppFontSize.s14.rSp,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
        vertical: AppSize.s8.rh,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s16.rSp),
          color: AppColors.yellowDarker,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s8.rw,
            vertical: AppSize.s4.rh,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time,
                size: AppSize.s16.rSp,
                color: AppColors.white,
              ),
              SizedBox(width: AppSize.s4.rw),
              Flexible(
                child: Text(
                  '${AppStrings.scheduled.tr()} - ${DateTimeProvider.scheduleDate(scheduleTime)}, ${DateTimeProvider.scheduleTime(scheduleTime)}',
                  style: _textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
