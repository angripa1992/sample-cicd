import 'package:flutter/material.dart';
import 'package:klikit/app/date_time_patterns.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/core/widgets/labeled_view.dart';
import 'package:klikit/modules/home/presentation/components/time_picker.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class TimeRangePicker extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime?) onStartDateTimeSelected;
  final Function(DateTime?) onEndDateTimeSelected;

  const TimeRangePicker({
    super.key,
    required this.selectedDate,
    required this.onStartDateTimeSelected,
    required this.onEndDateTimeSelected,
  });

  @override
  State<TimeRangePicker> createState() => _TimeRangePickerState();
}

class _TimeRangePickerState extends State<TimeRangePicker> {
  ValueNotifier<SelectionType> selectionChangeListener = ValueNotifier(SelectionType.start);
  ValueNotifier<DateTime?> startDateTime = ValueNotifier(null);
  ValueNotifier<DateTime?> endDateTime = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        ValueListenableBuilder<DateTime?>(
          valueListenable: endDateTime,
          builder: (_, endDT, __) {
            final isSingle = isSingleDateSelected(endDT);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ImageResourceResolver.calendarSVG.getImageWidget(width: AppSize.s24.rw, height: AppSize.s24.rh, color: AppColors.neutralB300),
                  AppSize.s8.horizontalSpacer(),
                  Text(
                    isSingle
                        ? DateTimeFormatter.getDate(widget.selectedDate, 'EEE, MMM d')
                        : '${DateTimeFormatter.getDate(widget.selectedDate, 'EEE, MMM d')} - ${DateTimeFormatter.getDate(endDT!, 'EEE, MMM d')}',
                    style: mediumTextStyle(fontSize: AppSize.s14.rSp, color: AppColors.neutralB500),
                  ),
                  if (!isSingle)
                    Tooltip(
                      message: 'Time range selected \nin between two dates',
                      child: ImageResourceResolver.infoSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh, color: AppColors.warningY300),
                    ).setVisibilityWithSpace(direction: Axis.horizontal, startSpace: AppSize.s8.rw),
                  const Spacer(),
                ],
              ),
            );
          },
        ),
        const Divider().setVisibilityWithSpace(direction: Axis.vertical, endSpace: AppSize.s6.rh),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<DateTime?>(
                valueListenable: startDateTime,
                builder: (_, dateTime, __) {
                  widget.onStartDateTimeSelected(dateTime);

                  return Expanded(
                    child: LabeledView(
                      label: 'Start time',
                      widget: KTButton(
                        controller: KTButtonController(label: dateTime?.format(DTPatterns.hh_mm_a) ?? 'Select'),
                        backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.greyBright),
                        labelStyle: mediumTextStyle(fontSize: AppSize.s12.rSp),
                        splashColor: AppColors.greyBright,
                        onTap: () {
                          startDateTime.value = null;
                          endDateTime.value = null;
                          selectionChangeListener.value = SelectionType.start;
                        },
                      ),
                    ),
                  );
                },
              ),
              AppSize.s20.horizontalSpacer(),
              ValueListenableBuilder<DateTime?>(
                valueListenable: endDateTime,
                builder: (_, dateTime, __) {
                  widget.onEndDateTimeSelected(dateTime);

                  return Expanded(
                    child: LabeledView(
                      label: 'End time',
                      widget: ValueListenableBuilder<DateTime?>(
                        valueListenable: startDateTime,
                        builder: (_, startDT, __) => KTButton(
                          controller: KTButtonController(label: dateTime?.format(DTPatterns.hh_mm_a) ?? 'Select', enabled: startDT != null),
                          backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.greyBright),
                          labelStyle: mediumTextStyle(fontSize: AppSize.s12.rSp),
                          splashColor: AppColors.greyBright,
                          onTap: () {
                            selectionChangeListener.value = SelectionType.end;
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        ValueListenableBuilder<SelectionType>(
          valueListenable: selectionChangeListener,
          builder: (_, selectedType, __) {
            final initialDateTime = calculateInitialDateTime();
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
                child: TimePicker(
                  fontColor: AppColors.neutralB700,
                  initialDateTime: initialDateTime,
                  maximumDateTime: selectedType == SelectionType.start ? initialDateTime.add(const Duration(days: 1)) : initialDateTime.add(const Duration(hours: 24)),
                  onDateTimeChanged: (dt) {
                    if (selectedType == SelectionType.start) {
                      startDateTime.value = dt;
                    } else {
                      endDateTime.value = dt;
                    }
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  bool isSingleDateSelected(DateTime? endDT) {
    return (endDT == null || (startDateTime.value != null && endDT.isSameDate(startDateTime.value!)));
  }

  DateTime calculateInitialDateTime() {
    final date = widget.selectedDate;
    if (startDateTime.value == null && endDateTime.value == null) {
      return date;
    } else {
      return startDateTime.value != null ? DateTime(date.year, date.month, date.day, startDateTime.value!.hour, startDateTime.value!.minute) : date;
    }
  }
}
