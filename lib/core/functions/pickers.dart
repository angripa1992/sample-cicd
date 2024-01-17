import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/values.dart';

Future<DateTime?> showKTDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  return await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime(2000),
    lastDate: lastDate ?? DateTime.now(),
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
    builder: (context, child) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppSize.s60.rh, horizontal: AppSize.s12.rw),
        child: Theme(
          data: ThemeData.light().copyWith(
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s12.rSp), // this is the border radius of the picker
              ),
            ),
            primaryColor: AppColors.primaryP300,
            dividerColor: AppColors.white,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: AppColors.primaryP300,
              onSurface: AppColors.primaryP300,
            ),
          ),
          child: child!,
        ),
      );
    },
  );
}
