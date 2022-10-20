import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/cancelled_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/order/observer/filter_observer.dart';
import 'package:klikit/modules/orders/presentation/order/observer/filter_subject.dart';
import 'package:klikit/modules/orders/presentation/order/shimmer/total_order_card_shimmer.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../domain/entities/order.dart';
import '../../bloc/orders/completed_order_cubit.dart';
import '../../bloc/orders/total_order_cubit.dart';
import '../../components/orders_card.dart';

class TotalOrderView extends StatefulWidget {
  final FilterSubject subject;

  const TotalOrderView({Key? key, required this.subject}) : super(key: key);

  @override
  State<TotalOrderView> createState() => _TotalOrderViewState();
}

class _TotalOrderViewState extends State<TotalOrderView> with FilterObserver {
  List<int>? _providers;
  List<int>? _brands;
  Timer? _timer;

  @override
  void initState() {
    filterSubject = widget.subject;
    filterSubject?.addObserver(this, ObserverTag.TOTAL_ORDER);
    _providers = filterSubject?.getProviders();
    _brands = filterSubject?.getBrands();
    _fetchOrders(true);
    _startTimer();
    super.initState();
  }

  void _fetchOrders(bool willShowLoading) {
    context.read<CompletedOrderCubit>().fetchLifeTimeCompletedOrder(
          willShowLoading: willShowLoading,
          providersID: _providers,
          brandsID: _brands,
        );
    context.read<TotalOrderCubit>().fetchLifeTimeTotalOrder(
          willShowLoading: willShowLoading,
          providersID: _providers,
          brandsID: _brands,
        );
    context.read<CancelledOrderCubit>().fetchLifeTimeCancelledOrder(
          willShowLoading: willShowLoading,
          providersID: _providers,
          brandsID: _brands,
        );
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: AppConstant.refreshTime),
      (timer) {
        // _fetchCompletedOrder(false);
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenSizes.screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          BlocBuilder<TotalOrderCubit, ResponseState>(
            builder: (context, state) {
              if (state is Loading) {
                return TotalOrderCardShimmer(
                  height: AppSize.s96.rh,
                  width: AppSize.s107.rw,
                  text: 'Total Orders',
                  orders: "0",
                  orderColor: AppColors.purpleBlue,
                  fontSize: AppFontSize.s14.rSp,
                  orderFontSize: AppFontSize.s24.rSp,
                );
              }
              return OrdersCard(
                height: AppSize.s96.rh,
                width: AppSize.s107.rw,
                text: 'Total Orders',
                orders: (state is Success<Orders>)
                    ? state.data.total.toString()
                    : "0",
                orderColor: AppColors.purpleBlue,
                fontSize: AppFontSize.s14.rSp,
                orderFontSize: AppFontSize.s24.rSp,
              );
            },
          ),
          BlocBuilder<CompletedOrderCubit, ResponseState>(
            builder: (context, state) {
              if (state is Loading) {
                return TotalOrderCardShimmer(
                  height: AppSize.s96.rh,
                  width: AppSize.s107.rw,
                  text: 'Completed Orders',
                  orders: '',
                  orderColor: AppColors.white,
                  textColor: AppColors.white,
                  bgColor: AppColors.blackCow,
                  fontSize: AppFontSize.s14.rSp,
                  orderFontSize: AppFontSize.s24.rSp,
                );
              }
              return OrdersCard(
                height: AppSize.s96.rh,
                width: AppSize.s107.rw,
                text: 'Completed Orders',
                orders: (state is Success<Orders>)
                    ? state.data.total.toString()
                    : "0",
                orderColor: AppColors.white,
                textColor: AppColors.white,
                bgColor: AppColors.blackCow,
                fontSize: AppFontSize.s14.rSp,
                orderFontSize: AppFontSize.s24.rSp,
              );
            },
          ),
          BlocBuilder<CancelledOrderCubit, ResponseState>(
            builder: (context, state) {
              if (state is Loading) {
                return TotalOrderCardShimmer(
                  height: AppSize.s96.rh,
                  width: AppSize.s107.rw,
                  text: AppStrings.cancelled_orders.tr(),
                  orders: "0",
                  orderColor: AppColors.lightViolet,
                  fontSize: AppFontSize.s14.rSp,
                  orderFontSize: AppFontSize.s24.rSp,
                );
              }
              return OrdersCard(
                height: AppSize.s96.rh,
                width: AppSize.s107.rw,
                text: AppStrings.cancelled_orders.tr(),
                orders: (state is Success<Orders>)
                    ? state.data.total.toString()
                    : "0",
                orderColor: AppColors.lightViolet,
                fontSize: AppFontSize.s14.rSp,
                orderFontSize: AppFontSize.s24.rSp,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void applyBrandsFilter(List<int> brandsID) {
    _brands = brandsID;
    _fetchOrders(true);
  }

  @override
  void applyProviderFilter(List<int> providersID) {
    _providers = providersID;
    _fetchOrders(true);
  }

  @override
  void applyStatusFilter(List<int> status) {}
}
