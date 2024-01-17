import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/core/widgets/kt_dropdown.dart';
import 'package:klikit/modules/home/data/model/report_info.dart';
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
  late final generateButtonController = KTButtonController(label: AppStrings.generate.tr());
  late ReportInfo reportInfo;
  List<ReportInfo> days = [];

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
    list.add(ReportInfo(name: AppStrings.custom.tr(), dateType: DateType.range, dateTime: today));

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
              Expanded(
                child: KTDropdown(
                  items: days,
                  titleBuilder: (ReportInfo item) {
                    return item.name;
                  },
                  textStyle: mediumTextStyle(fontSize: AppSize.s12.rSp),
                  hintTextStyle: mediumTextStyle(fontSize: AppSize.s12.rSp),
                  selectedItemBuilder: (ReportInfo item, bool isSelected) {
                    return reportInfo.dateType == DateType.range ? item.prepareSelectedItemData() : item.name;
                  },
                  selectedItem: reportInfo,
                  onSelected: (ReportInfo selectedItem) async {
                    if (selectedItem.dateType == DateType.range) {
                      DateTime dateTime = await showKTDatePicker(selectedItem.dateTime) ?? selectedItem.dateTime;

                      setState(() {
                        days.removeWhere((element) => element.dateType == DateType.range);
                        days.add(reportInfo = selectedItem.copyWith(dateTime: dateTime));
                      });
                    } else {
                      reportInfo = selectedItem;
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
              Expanded(
                child: BlocConsumer<FetchZReportCubit, ResponseState>(
                  listener: (ct, state) {
                    generateButtonController.setLoaded(state is! Loading);

                    if (state is Failed) {
                      showApiErrorSnackBar(context, state.failure);
                    } else if (state is Success<ZReportData>) {
                      getIt.get<PrintingHandler>().printZReport(state.data, reportInfo.dateTime);
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
                      labelStyle: mediumTextStyle(fontSize: AppSize.s12.rSp),
                      splashColor: AppColors.greyBright,
                      onTap: () async {
                        context.read<FetchZReportCubit>().fetchZReportData(reportInfo.dateTime);
                        SegmentManager().track(
                          event: SegmentEvents.GENERATE_ZREPORT,
                          properties: {
                            'date_type': reportInfo.name,
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

  Future<DateTime?> showKTDatePicker(DateTime? selectedOne) async {
    return await showDatePicker(
      context: context,
      initialDate: selectedOne ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
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

  @override
  void dispose() {
    generateButtonController.dispose();
    super.dispose();
  }
}
