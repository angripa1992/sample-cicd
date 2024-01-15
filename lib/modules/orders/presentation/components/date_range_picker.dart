import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/functions/pickers.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class DateSelector extends StatefulWidget {
  final DateTimeRange dateTimeRange;
  final Function(DateTimeRange) onPick;

  const DateSelector({Key? key, required this.onPick, required this.dateTimeRange}) : super(key: key);

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
      showErrorSnackBar(context, AppStrings.date_range_validation_msg.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () async {
          final newDateRange = await showKTDateRangePicker(context: context, initialDateRange: _dateTimeRange);

          if (newDateRange == null) return;
          _validate(newDateRange);
        },
        child: Container(
          padding: const EdgeInsets.all(AppSize.s8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            color: AppColors.primaryLighter,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.date_range,
                color: AppColors.primary,
                size: AppSize.s18.rSp,
              ),
              SizedBox(width: AppSize.s8.rw),
              Text(
                DateTimeFormatter.dateRangeString(_dateTimeRange!),
                style: regularTextStyle(
                  color: AppColors.primary,
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
