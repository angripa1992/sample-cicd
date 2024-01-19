import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';
import 'package:klikit/modules/home/domain/entities/order_summary_overview.dart';
import 'package:klikit/modules/home/presentation/cubit/order_summary_cubit.dart';
import 'package:klikit/modules/orders/presentation/components/order_summary_card.dart';
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
              'Order Summary',
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
              return const CircularProgress();
            } else if (state is Success<List<OrderSummaryOverview>>) {
              return Container(
                color: AppColors.greyLight,
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 2.2,
                  mainAxisSpacing: 1.rh,
                  crossAxisSpacing: 1.rw,
                  physics: const NeverScrollableScrollPhysics(),
                  children: state.data.map((orderSummary) {
                    return OrderSummaryCard(
                      label: orderSummary.label,
                      value: orderSummary.value,
                      tooltipMessage: orderSummary.label,
                      changeInPercentage: 20,
                      labelToCompareWith: '',
                      isPositive: true,
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
}
