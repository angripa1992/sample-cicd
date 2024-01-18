import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/modules/home/domain/entities/order_summary_overview.dart';
import 'package:klikit/modules/home/presentation/cubit/order_summary_cubit.dart';
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
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.rh),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Summary',
                style: boldTextStyle(
                  color: AppColors.black,
                  fontSize: 16.rSp,
                ),
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
        ),
        BlocBuilder<OrderSummaryCubit, ResponseState>(
          builder: (_, state) {
            if (state is Loading) {
              return CircularProgressIndicator(color: AppColors.primary);
            } else if (state is Success<OrderSummaryOverview>) {
              return Column(
                children: [
                  Row(
                    children: [
                      _summaryItem(AppStrings.completed_orders.tr(), '${state.data.completedOrders}'),
                      _summaryItem(AppStrings.cancelled_orders.tr(), '${state.data.cancelledOrders}'),
                    ],
                  ),
                  Row(
                    children: [
                      _summaryItem(AppStrings.gross_order_value.tr(), state.data.grossOrderValues),
                      _summaryItem(AppStrings.discount_value.tr(), state.data.discountValues),
                    ],
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _summaryItem(String name, String value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.rSp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                value,
                textAlign: TextAlign.center,
                style: semiBoldTextStyle(
                  color: AppColors.primary,
                  fontSize: 16.rSp,
                ),
              ),
              SizedBox(height: 4.rh),
              Text(
                name,
                textAlign: TextAlign.center,
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: 14.rSp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
