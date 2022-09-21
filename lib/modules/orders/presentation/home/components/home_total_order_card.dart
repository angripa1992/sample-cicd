import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/today_total_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/yesterday_total_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/home/shimer/home_total_order_shimmer.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';

class HomeTotalOrdersCard extends StatelessWidget {
  final VoidCallback onTap;

  const HomeTotalOrdersCard({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shadowColor: AppColors.smokeyGrey,
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s20.rw,
            vertical: AppSize.s20.rh,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocConsumer<TodayTotalOrderCubit,ResponseState>(
                listener: (context,state){
                  if(state is Failed){
                    showErrorSnackBar(context, state.failure.message);
                  }
                },
                builder: (context, state) {
                  if(state is Loading){
                    return todayTotalOrderShimmer();
                  }
                  return  Column(
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
                        (state is Success<Orders>) ? state.data.total.toString() : '0',
                        style: getRegularTextStyle(
                          color: AppColors.purpleBlue,
                          fontSize: AppFontSize.s30.rSp,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Spacer(),
              BlocConsumer<YesterdayTotalOrderCubit,ResponseState>(
                listener: (context,state){
                  if(state is Failed){
                    showErrorSnackBar(context, state.failure.message);
                  }
                },
                builder: (context, state) {
                  if(state is Loading){
                    return yesterdayTotalOrderShimmer();
                  }
                  return  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppStrings.yesterday.tr(),
                        style: getRegularTextStyle(
                          color: AppColors.coolGrey,
                          fontSize: AppFontSize.s14.rSp,
                        ),
                      ),
                      Text(
                        (state is Success<Orders>) ? state.data.total.toString() : '0',
                        style: getRegularTextStyle(
                          color: AppColors.coolGrey,
                          fontSize: AppFontSize.s17.rSp,
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(width: AppSize.s8.rw),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.coolGrey,
                size: AppSize.s20.rSp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
