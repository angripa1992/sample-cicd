import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../core/provider/date_time_provider.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class ScheduledDetailsView extends StatelessWidget {
  final String scheduleTime;

  ScheduledDetailsView({Key? key, required this.scheduleTime})
      : super(key: key);

  final _textStyle = getMediumTextStyle(
    color: AppColors.white,
    fontSize: AppFontSize.s14.rSp,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSize.s16.rw,
        right: AppSize.s16.rw,
        bottom: AppSize.s8.rh,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s16.rSp),
          color: AppColors.dustyOrange,
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
                  'Scheduled - ${DateTimeProvider.scheduleDate(scheduleTime)}, ${DateTimeProvider.scheduleTime(scheduleTime)}',
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
