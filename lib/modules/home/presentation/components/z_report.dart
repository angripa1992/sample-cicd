import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/core/widgets/kt_dropdown.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/segments/event_manager.dart';
import 'package:klikit/segments/segemnt_data_provider.dart';

import '../../../../app/di.dart';
import '../../../../printer/printing_handler.dart';
import '../../../../resources/colors.dart';
import '../../../../resources/fonts.dart';
import '../../../../resources/styles.dart';
import '../../../../resources/values.dart';
import '../../data/model/z_report_data_model.dart';
import '../cubit/fetch_zreport_cubit.dart';

class ZReportView extends StatefulWidget {
  const ZReportView({Key? key}) : super(key: key);

  @override
  State<ZReportView> createState() => _ZReportViewState();
}

class _ZReportViewState extends State<ZReportView> {
  DateType _selectedValue = DateType.today;
  DateTime _selectedDate = DateTime.now();
  late final generateButtonController = KTButtonController(label: AppStrings.generate.tr());
  List<String> days = [];

  @override
  void initState() {
    days = [AppStrings.today.tr(), AppStrings.yesterday.tr(), AppStrings.custom.tr()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
        vertical: AppSize.s16.rh,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.z_report.tr(),
            style: boldTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          SizedBox(height: AppSize.s8.rh),
          Text(
            'Select and download the Z Report for a detailed breakdown of your transactions.',
            style: regularTextStyle(
              color: AppColors.neutralB300,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
          SizedBox(height: AppSize.s16.rh),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /*ZReportSelector(
                onDateChange: (dateTime, dateType) {
                  _selectedValue = dateType;
                  _selectedDate = dateTime;
                },
              ),*/
              Expanded(
                child: KTDropdown(
                  items: days,
                  titleBuilder: (String item) {
                    return item;
                  },
                  onSelected: (String selectedItem) {},
                  padding: EdgeInsets.symmetric(horizontal: AppSize.s20.rw, vertical: AppSize.s1.rh),
                  borderRadius: BorderRadius.circular(AppSize.s6.rSp),
                  backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.white, strokeColor: AppColors.neutralB40),
                  trailingWidget: ImageResourceResolver.downArrowSVG.getImageWidget(
                    width: 14.rw,
                    height: 14.rh,
                    color: AppColors.neutralB700,
                  ),
                ),
              ),
              AppSize.s12.rw.horizontalSpacer(),
              Expanded(
                child: BlocConsumer<FetchZReportCubit, ResponseState>(
                  listener: (ct, state) {
                    generateButtonController.setLoaded(state is! Loading);

                    if (state is Failed) {
                      showApiErrorSnackBar(context, state.failure);
                    } else if (state is Success<ZReportDataModel>) {
                      getIt.get<PrintingHandler>().printZReport(state.data, _selectedDate);
                    }
                  },
                  builder: (ct, state) {
                    return KTButton(
                      controller: generateButtonController,
                      prefixWidget: ImageResourceResolver.downloadSVG.getImageWidget(
                        width: 18.rw,
                        height: 18.rh,
                        color: AppColors.neutralB700,
                      ),
                      backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.greyBright),
                      labelStyle: mediumTextStyle(),
                      splashColor: AppColors.greyBright,
                      onTap: () async {
                        context.read<FetchZReportCubit>().fetchZReportData(_selectedDate);
                        SegmentManager().track(
                          event: SegmentEvents.GENERATE_ZREPORT,
                          properties: {
                            'date_type': prepareDateType(_selectedValue),
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    generateButtonController.dispose();
    super.dispose();
  }

  String prepareDateType(DateType dateType) {
    switch (dateType) {
      case DateType.today:
        return 'Today';
      case DateType.yesterday:
        return 'Yesterday';
      case DateType.range:
        return 'Custom';
    }
  }
}

class ZReportSelector extends StatefulWidget {
  final Function(DateTime, DateType) onDateChange;

  const ZReportSelector({
    Key? key,
    required this.onDateChange,
  }) : super(key: key);

  @override
  State<ZReportSelector> createState() => _ZReportSelectorState();
}

class _ZReportSelectorState extends State<ZReportSelector> {
  DateType _selectedValue = DateType.today;
  DateTime _selectedDate = DateTime.now();

  void _showDatePicker() async {
    _selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColors.primary,
                  onPrimary: AppColors.white,
                  onSurface: AppColors.black,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary, // button text color
                  ),
                ),
              ),
              child: child!,
            );
          },
        ) ??
        DateTime.now();
    _changeDate(
      DateType.range,
      _selectedDate,
    );
  }

  void _changeDate(DateType type, DateTime dateTime) {
    setState(() {
      _selectedValue = type;
      _selectedDate = dateTime;
    });
    widget.onDateChange(_selectedDate, _selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              _changeDate(
                DateType.today,
                DateTime.now(),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                color: _selectedValue == DateType.today ? AppColors.primary : AppColors.greyLight,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                child: Center(
                  child: Text(
                    AppStrings.today.tr(),
                    style: regularTextStyle(
                      color: _selectedValue == DateType.today ? AppColors.white : AppColors.black,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSize.s4.rw),
        Expanded(
          child: InkWell(
            onTap: () {
              _changeDate(
                DateType.yesterday,
                DateTime.now().subtract(const Duration(days: 1)),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                color: _selectedValue == DateType.yesterday ? AppColors.primary : AppColors.greyLight,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                child: Center(
                  child: Text(
                    AppStrings.yesterday.tr(),
                    style: regularTextStyle(
                      color: _selectedValue == DateType.yesterday ? AppColors.white : AppColors.black,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSize.s4.rw),
        Expanded(
          child: InkWell(
            onTap: _showDatePicker,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                color: _selectedValue == DateType.range ? AppColors.primary : AppColors.greyLight,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.s8.rh,
                  horizontal: AppSize.s8.rw,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.date_range,
                      size: AppSize.s14.rSp,
                      color: _selectedValue == DateType.range ? AppColors.white : AppColors.black,
                    ),
                    SizedBox(width: AppSize.s4.rw),
                    Flexible(
                      child: Text(
                        (_selectedValue == DateType.range) ? DateFormat('d MMM').format(_selectedDate) : AppStrings.custom.tr(),
                        style: regularTextStyle(
                          color: _selectedValue == DateType.range ? AppColors.white : AppColors.black,
                          fontSize: AppFontSize.s14.rSp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
