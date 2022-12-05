import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/colors.dart';

import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class DateSelector extends StatefulWidget {
  final DateTimeRange dateTimeRange;
  final Function(DateTimeRange) onPick;

  const DateSelector(
      {Key? key, required this.onPick, required this.dateTimeRange})
      : super(key: key);

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTimeRange? _dateTimeRange;

  @override
  void initState() {
    _dateTimeRange = widget.dateTimeRange;
    super.initState();
  }

  void _validate(DateTimeRange dateTimeRange) {
    final difference = dateTimeRange.end.difference(dateTimeRange.start).inDays;
    if (difference <= 6) {
      setState(() {
        _dateTimeRange = dateTimeRange;
        widget.onPick(_dateTimeRange!);
      });
    } else {
      showErrorSnackBar(context, 'Date range should up to 7 days');
    }
  }

  Future _pickDateRange() async {
    final newDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: _dateTimeRange,
        lastDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: (336 * 10))),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: AppColors.blueViolet,
              dividerColor: AppColors.white,
              //Non selected days of the month color
              // textTheme: TextTheme(
              //   bodyText2:
              //   TextStyle(color:AppColors.smokeyGrey),
              // ),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                //Selected dates background color
                primary: AppColors.blueViolet,
                //Month title and week days color
                onSurface: AppColors.blueViolet,
                //Header elements and selected dates text color
                //onPrimary: Colors.white,
              ),
            ),
            child: child!,
          );
        });
    if (newDateRange == null) return;
    _validate(newDateRange);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: _pickDateRange,
        child: Container(
          padding: const EdgeInsets.all(AppSize.s8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            color: AppColors.lightVioletTwo,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.date_range,
                color: AppColors.purpleBlue,
                size: AppSize.s18.rSp,
              ),
              SizedBox(width: AppSize.s8.rw),
              Text(
                DateTimeProvider.dateRangeString(_dateTimeRange!),
                style: getRegularTextStyle(
                  color: AppColors.purpleBlue,
                  fontSize: AppFontSize.s13.rSp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
