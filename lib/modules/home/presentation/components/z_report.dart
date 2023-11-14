import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../app/di.dart';
import '../../../../printer/printing_handler.dart';
import '../../../../resources/colors.dart';
import '../../../../resources/fonts.dart';
import '../../../../resources/styles.dart';
import '../../../../resources/values.dart';
import '../../../widgets/loading_button.dart';
import '../../data/model/z_report_data_model.dart';
import '../cubit/fetch_zreport_cubit.dart';

class ZReportView extends StatefulWidget {
  const ZReportView({Key? key}) : super(key: key);

  @override
  State<ZReportView> createState() => _ZReportViewState();
}

class _ZReportViewState extends State<ZReportView> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSize.s24.rh,
        horizontal: AppSize.s16.rw,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.z_report.tr(),
            style: boldTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          SizedBox(height: AppSize.s8.rh),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: AppSize.s16.rh,
              horizontal: AppSize.s8.rw,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s8.rSp),
              color: AppColors.white,
            ),
            child: Column(
              children: [
                ZReportSelector(
                  onDateChange: (dateTime) {
                    _selectedDate = dateTime;
                  },
                ),
                SizedBox(height: AppSize.s16.rh),
                BlocConsumer<FetchZReportCubit, ResponseState>(
                  listener: (ct, state) {
                    if (state is Failed) {
                      showApiErrorSnackBar(context, state.failure);
                    } else if (state is Success<ZReportDataModel>) {
                      getIt.get<PrintingHandler>().printZReport(state.data, _selectedDate);
                    }
                  },
                  builder: (ct, state) {
                    return LoadingButton(
                      isLoading: state is Loading,
                      text: AppStrings.generate.tr(),
                      enabled: true,
                      borderColor: AppColors.primary,
                      color: AppColors.primary,
                      icon: Icons.print,
                      textColor: AppColors.white,
                      onTap: () {
                        context.read<FetchZReportCubit>().fetchZReportData(_selectedDate);

                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ZReportSelector extends StatefulWidget {
  final Function(DateTime) onDateChange;

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
    widget.onDateChange(_selectedDate);
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
