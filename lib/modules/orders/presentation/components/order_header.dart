import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/presentation/components/busy_mode_view.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../filter_subject.dart';
import 'filter/aggregator_filter.dart';
import 'filter/brand_filter.dart';
import 'filter/status_filter.dart';

class OrderHeaderView extends StatelessWidget {
  final FilterSubject subject;
  final TabController tabController;

  const OrderHeaderView(
      {Key? key, required this.subject, required this.tabController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppSize.s14.rw, vertical: AppSize.s12.rh),
          child: Text(
            AppStrings.filter_by_brand.tr(),
            style: getRegularTextStyle(
              color: AppColors.purpleBlue,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s12.rw,
          ),
          child: BrandFilter(
            filterSubject: subject,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppSize.s14.rw, vertical: AppSize.s12.rh),
          child: Text(
            AppStrings.filter_by_aggregator.tr(),
            style: getRegularTextStyle(
              color: AppColors.purpleBlue,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s12.rw,
          ),
          child: AggregatorsFilter(filterSubject: subject),
        ),
        StatusFilter(
          subject: subject,
          tabController: tabController,
        ),
        Padding(
          padding: EdgeInsets.only(
            right: AppSize.s12.rw,
            left: AppSize.s16.rw,
            top: AppSize.s12.rw,
            bottom: AppSize.s8.rw,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.orders.tr(),
                style: getRegularTextStyle(
                  color: AppColors.purpleBlue,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
              const BusyModeView(),
            ],
          ),
        ),
      ],
    );
  }
}
