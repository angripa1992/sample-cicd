import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/modules/home/presentation/cubit/order_summary_cubit.dart';
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
  HomeFilterAppliedData? _filterAppliedData;

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
          padding: EdgeInsets.symmetric(vertical: 8.rh),
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
                    applyFilter: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => HomeFilterScreen(
                            initialFilteredData: _filterAppliedData,
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
        Row(
          children: [
            _summaryItem('Completed Orders', '12345'),
            _summaryItem('Cancelled Order', '12345'),
          ],
        ),
        Row(
          children: [
            _summaryItem('Completed Orders', '12345'),
            _summaryItem('Cancelled Order', '12345'),
          ],
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
                style: semiBoldTextStyle(
                  color: AppColors.primary,
                  fontSize: 20.rSp,
                ),
              ),
              SizedBox(height: 4.rh),
              Text(
                name,
                style: regularTextStyle(
                  color: AppColors.black,
                  fontSize: 16.rSp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
