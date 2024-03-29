import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/functions/pickers.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/core/widgets/kt_chip.dart';
import 'package:klikit/core/widgets/kt_dropdown.dart';
import 'package:klikit/modules/home/data/model/report_info.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/segments/event_manager.dart';
import 'package:klikit/segments/segemnt_data_provider.dart';

import '../../../../app/di.dart';
import '../../../../printer/printer_manager.dart';
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
  late final generateButtonController = KTButtonController(label: AppStrings.generate.tr());
  late ReportInfo reportInfo;
  List<ReportInfo> days = [];
  final ValueNotifier<Size?> _dropdownSize = ValueNotifier<Size?>(null);

  @override
  void initState() {
    days = prepareReportInfoData();
    reportInfo = days.first;
    super.initState();
  }

  List<ReportInfo> prepareReportInfoData() {
    List<ReportInfo> list = [];
    DateTime today = DateTime.now();
    list.add(ReportInfo(name: AppStrings.today.tr(), dateType: DateType.today, dateTime: today));
    list.add(ReportInfo(name: AppStrings.yesterday.tr(), dateType: DateType.yesterday, dateTime: today.subtract(const Duration(days: 1))));
    list.add(ReportInfo(name: AppStrings.custom_date.tr(), dateType: DateType.range, dateTime: today));
    list.add(ReportInfo(name: AppStrings.custom_time.tr(), dateType: DateType.timeRange, dateTime: today));

    return list;
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
            AppStrings.z_report_action_description.tr(),
            style: regularTextStyle(
              color: AppColors.neutralB300,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
          SizedBox(height: AppSize.s16.rh),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: KTDropdown(
                  onSizeCalculated: (calculatedSize) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      _dropdownSize.value = calculatedSize;
                    });
                  },
                  items: days,
                  titleBuilder: (ReportInfo item) {
                    return item.name;
                  },
                  textStyle: mediumTextStyle(fontSize: AppSize.s12.rSp),
                  hintTextStyle: mediumTextStyle(fontSize: AppSize.s12.rSp),
                  selectedItemBuilder: (ReportInfo item, bool isSelected) {
                    return item.name;
                  },
                  selectedItem: reportInfo,
                  onSelected: (ReportInfo selectedItem) async {
                    if (selectedItem.dateType == DateType.range) {
                      DateTime dateTime = await showKTDatePicker(context, initialDate: selectedItem.dateTime) ?? selectedItem.dateTime;

                      setState(() {
                        days[days.indexOf(selectedItem)] = reportInfo = selectedItem.copyWith(dateTime: dateTime);
                      });
                    } else if (selectedItem.dateType == DateType.timeRange) {
                      final DateTime? dateTime = await showKTDatePicker(context, initialDate: selectedItem.dateTime, positiveText: AppStrings.select_time.tr());
                      if (dateTime != null && mounted) {
                        final DateTimeRange? result = await showKTTimeRangePicker(context, dateTime);
                        if (result != null) {
                          setState(() {
                            days[days.indexOf(selectedItem)] = reportInfo = selectedItem.copyWith(dateTime: result.start, endDateTime: result.end);
                          });
                        } else {
                          setState(() {});
                        }
                      } else {
                        setState(() {});
                      }
                    } else {
                      setState(() {
                        reportInfo = selectedItem;
                      });
                    }
                  },
                  padding: EdgeInsets.symmetric(horizontal: AppSize.s20.rw),
                  borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                  backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.white, strokeColor: AppColors.neutralB40),
                  trailingWidget: ImageResourceResolver.downArrowSVG.getImageWidget(
                    width: 14.rw,
                    height: 14.rh,
                    color: AppColors.neutralB700,
                  ),
                ),
              ),
              AppSize.s12.horizontalSpacer(),
              BlocConsumer<FetchZReportCubit, ResponseState>(
                listener: (ct, state) {
                  generateButtonController.setLoaded(state is! Loading);

                  if (state is Failed) {
                    showApiErrorSnackBar(context, state.failure);
                  } else if (state is Success<ZReportData>) {
                    getIt.get<PrinterManager>().printZReport(state.data, reportInfo.dateTime, reportEndDate: reportInfo.endDateTime, locale: context.locale);
                  }
                },
                builder: (ct, state) {
                  return ValueListenableBuilder<Size?>(
                    valueListenable: _dropdownSize,
                    builder: (_, size, __) => SizedBox(
                      height: (size?.height ?? 0) > 0 ? size?.height : null,
                      child: KTButton(
                        controller: generateButtonController,
                        prefixWidget: ImageResourceResolver.downloadSVG.getImageWidget(width: 12.rw, height: 12.rh, color: AppColors.primaryP300),
                        backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.primaryP50),
                        labelStyle: mediumTextStyle(fontSize: AppSize.s12.rSp, color: AppColors.primaryP300),
                        splashColor: AppColors.greyBright,
                        horizontalContentPadding: 20.rw,
                        onTap: () async {
                          context.read<FetchZReportCubit>().fetchZReportData(
                                startDateTime: reportInfo.dateTime,
                                endDateTime: reportInfo.dateType == DateType.timeRange ? reportInfo.endDateTime : null,
                              );
                          SegmentManager().track(
                            event: SegmentEvents.GENERATE_ZREPORT,
                            properties: {
                              'date_type': reportInfo.name,
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Visibility(
            visible: (reportInfo.dateType == DateType.range || reportInfo.dateType == DateType.timeRange),
            child: KTChip(
              text: reportInfo.prepareSelectedItemData(),
              leadingIcon: ImageResourceResolver.calendarSVG.getImageWidget(width: 12.rw, height: 12.rh, color: AppColors.neutralB100),
              backgroundColor: AppColors.neutralB20,
              strokeColor: AppColors.neutralB40,
              textStyle: mediumTextStyle(fontSize: 10.rSp, color: AppColors.neutralB600),
              padding: EdgeInsets.symmetric(horizontal: 12.rw, vertical: 4.rh),
            ).setVisibilityWithSpace(direction: Axis.vertical, startSpace: 8),
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
}
