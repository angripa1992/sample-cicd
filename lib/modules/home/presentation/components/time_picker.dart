import 'package:flutter/cupertino.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class TimePicker extends StatelessWidget {
  final DateTime initialDateTime;
  final DateTime? maximumDateTime;

  final int minuteInterval;

  final bool use24hForm;

  final Color? fontColor;
  final Function(DateTime) onDateTimeChanged;

  const TimePicker({
    super.key,
    required this.onDateTimeChanged,
    required this.initialDateTime,
    this.maximumDateTime,
    this.minuteInterval = 30,
    this.use24hForm = false,
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: semiBoldTextStyle(
            color: fontColor ?? AppColors.neutralB500,
            fontSize: AppSize.s12.rSp,
          ),
        ),
      ),
      child: CupertinoDatePicker(
        backgroundColor: AppColors.white,
        mode: CupertinoDatePickerMode.dateAndTime,
        initialDateTime: initialDateTime,
        minuteInterval: minuteInterval,
        minimumDate: initialDateTime,
        maximumDate: maximumDateTime,
        use24hFormat: use24hForm,
        onDateTimeChanged: onDateTimeChanged,
      ),
    );
  }
}
