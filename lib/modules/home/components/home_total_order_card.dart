import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/total_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/yesterday_total_order_cubit.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../shimer/home_total_order_shimmer.dart';

class HomeTotalOrdersCard extends StatelessWidget {
  final VoidCallback onToday;
  final VoidCallback onYesterday;

  const HomeTotalOrdersCard(
      {Key? key, required this.onToday, required this.onYesterday})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Card(
            shadowColor: AppColors.smokeyGrey,
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.s20.rw,
                vertical: AppSize.s20.rh,
              ),
              child: InkWell(
                onTap: onToday,
                child: BlocConsumer<TotalOrderCubit, ResponseState>(
                  listener: (context, state) {
                    if (state is Failed) {
                      showApiErrorSnackBar(context, state.failure);
                    }
                  },
                  builder: (context, state) {
                    if (state is Loading) {
                      return totalOrderShimmer(
                          AppStrings.total_orders_today.tr());
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.total_orders_today.tr(),
                          style: getRegularTextStyle(
                            color: AppColors.blackCow,
                            fontSize: AppFontSize.s14.rSp,
                          ),
                        ),
                        Text(
                          (state is Success<Orders>)
                              ? state.data.total.toString()
                              : '0',
                          style: getRegularTextStyle(
                            color: AppColors.purpleBlue,
                            fontSize: AppFontSize.s30.rSp,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        Expanded(
          child: Card(
            shadowColor: AppColors.smokeyGrey,
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.s20.rw,
                vertical: AppSize.s20.rh,
              ),
              child: InkWell(
                onTap: onYesterday,
                child: BlocConsumer<YesterdayTotalOrderCubit, ResponseState>(
                  listener: (context, state) {
                    if (state is Failed) {
                      showApiErrorSnackBar(context, state.failure);
                    }
                  },
                  builder: (context, state) {
                    if (state is Loading) {
                      return totalOrderShimmer(
                          AppStrings.total_orders_yesterday.tr());
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.total_orders_yesterday.tr(),
                          style: getRegularTextStyle(
                            color: AppColors.blackCow,
                            fontSize: AppFontSize.s14.rSp,
                          ),
                        ),
                        Text(
                          (state is Success<Orders>)
                              ? state.data.total.toString()
                              : '0',
                          style: getRegularTextStyle(
                            color: AppColors.purpleBlue,
                            fontSize: AppFontSize.s30.rSp,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
