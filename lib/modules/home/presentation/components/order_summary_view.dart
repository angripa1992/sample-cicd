import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/core/widgets/kt_radio_group.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';
import 'package:klikit/modules/home/domain/entities/order_summary_overview.dart';
import 'package:klikit/modules/home/presentation/cubit/order_summary_cubit.dart';
import 'package:klikit/modules/orders/presentation/components/order_summary_card.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../core/widgets/filter/filter_icon_view.dart';
import '../../../../core/widgets/filter/home_filter_screen.dart';
import '../../../../resources/colors.dart';

class OrderSummaryView extends StatefulWidget {
  const OrderSummaryView({super.key});

  @override
  State<OrderSummaryView> createState() => _OrderSummaryViewState();
}

class _OrderSummaryViewState extends State<OrderSummaryView> {
  HomeFilteredData? _filterAppliedData;

  @override
  void initState() {
    _fetchSummary();
    super.initState();
  }

  void _fetchSummary() {
    context.read<OrderSummaryCubit>().fetchOrderSummaryData(_filterAppliedData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.order_summary.tr(),
              style: boldTextStyle(color: AppColors.black, fontSize: 16.rSp),
            ),
            StatefulBuilder(
              builder: (_, setState) {
                return FilterIconView(
                  applied: _filterAppliedData != null,
                  openFilterScreen: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => HomeFilterScreen(
                          initData: _filterAppliedData,
                          onApplyFilterCallback: (filteredData) {
                            setState(() {
                              _filterAppliedData = filteredData;
                            });
                            _fetchSummary();
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        const Divider(),
        BlocBuilder<OrderSummaryCubit, ResponseState>(
          builder: (_, state) {
            if (state is Loading) {
              return SizedBox(height: 180.rh, child: const Center(child: CircularProgress()));
            } else if (state is Success<List<OrderSummaryOverview>>) {
              return Container(
                color: AppColors.greyLight,
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 1.8,
                  mainAxisSpacing: 1.rh,
                  crossAxisSpacing: 1.rw,
                  physics: const NeverScrollableScrollPhysics(),
                  children: state.data.map((orderSummary) {
                    return OrderSummaryCard(
                      overview: orderSummary,
                      labelToCompareWith: comparisonLabelFromDateType(_filterAppliedData?.dateFilteredData?.selectedItem),
                    );
                  }).toList(),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  String comparisonLabelFromDateType(KTRadioValue? selectedValue) {
    if (selectedValue == null || selectedValue.id == DateType.today || selectedValue.id == DateType.yesterday) {
      return AppStrings.previous_day.tr();
    } else if (selectedValue.id == DateType.lastWeek) {
      return AppStrings.previous_week.tr();
    } else if (selectedValue.id == DateType.lastMonth) {
      return AppStrings.previous_month.tr();
    } else {
      return AppStrings.previous_range.tr();
    }
  }
}
