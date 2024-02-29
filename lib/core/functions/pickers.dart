import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/modules/home/presentation/components/time_range_picker.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

Future<DateTime?> showKTDatePicker(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  String? positiveText,
}) async {
  return await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime(2000),
    lastDate: lastDate ?? DateTime.now(),
    confirmText: positiveText,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s12.rSp), // this is the border radius of the picker
            ),
          ),
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryP300,
            onPrimary: AppColors.white,
            onSurface: AppColors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}

Future<DateTimeRange?> showKTDateRangePicker({
  required BuildContext context,
  DateTimeRange? initialDateRange,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  return await showDateRangePicker(
    context: context,
    initialDateRange: initialDateRange,
    firstDate: firstDate ?? DateTime.now().subtract(const Duration(days: (336 * 10))),
    lastDate: lastDate ?? DateTime.now(),
    saveText: AppStrings.apply.tr().toUpperCase(),
    helpText: AppStrings.select_date_range.tr(),
    builder: (context, child) {
      return SafeArea(
        top: true,
        child: Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primaryP300,
            dividerColor: AppColors.greyLight,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: AppColors.primaryP300,
              onSurface: AppColors.black,
              brightness: Brightness.dark,
            ),
          ),
          child: child!,
        ),
      );
    },
  );
}

Future<DateTimeRange?> showKTTimeRangePicker(BuildContext context, DateTime selectedDateTime) async {
  return await showDialog(
    context: context,
    builder: (c) {
      DateTime? startDateTime;
      DateTime? endDateTime;

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
        title: Text(AppStrings.time_selection.tr()),
        titlePadding: EdgeInsets.only(left: AppSize.s16.rw, right: AppSize.s16.rw, top: AppSize.s16.rh, bottom: AppSize.s6.rh),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          height: ScreenSizes.screenHeight * 0.4,
          width: ScreenSizes.screenWidth * 0.9,
          child: TimeRangePicker(
            selectedDate: DateTime(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day),
            onStartDateTimeSelected: (DateTime? start) {
              startDateTime = start;
            },
            onEndDateTimeSelected: (DateTime? end) {
              endDateTime = end;
            },
          ),
        ),
        actionsPadding: EdgeInsets.only(left: AppSize.s16.rw, right: AppSize.s16.rw, top: AppSize.s8.rh, bottom: AppSize.s16.rh),
        actions: <Widget>[
          KTButton(
            controller: KTButtonController(label: AppStrings.ok.tr()),
            backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.primaryP300),
            labelStyle: mediumTextStyle(color: AppColors.white),
            progressPrimaryColor: AppColors.white,
            onTap: () {
              Navigator.pop(context, (startDateTime != null && endDateTime != null) ? DateTimeRange(start: startDateTime!, end: endDateTime!) : null);
            },
          ),
        ],
      );
    },
  );
}
