import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/core/provider/device_information_provider.dart';
import 'package:klikit/modules/base/base_screen_app_bar.dart';
import 'package:klikit/modules/home/presentation/components/home_quick_actions.dart';
import 'package:klikit/modules/home/presentation/components/order_summary_view.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/values.dart';

import '../../../segments/event_manager.dart';
import '../../../segments/segemnt_data_provider.dart';
import '../../busy/presentation/pause_store_header_view.dart';
import '../../orders/presentation/bloc/new_order_cubit.dart';
import '../../orders/presentation/bloc/ongoing_order_cubit.dart';
import 'components/z_report_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    getIt.get<DeviceInfoProvider>().getOsVersion();
    _fetchOrder(true);
    _startTimer();
    SegmentManager().screen(
      event: SegmentEvents.HOME_TAB,
      name: 'Home Tab',
      properties: {'device_type': ScreenSizes.isTablet ? 'Tab' : 'Mobile'},
    );
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: AppConstant.refreshTime),
      (timer) {
        _fetchOrder(false);
      },
    );
  }

  void _fetchOrder(bool isInitialCall) {
    context.read<NewOrderCubit>().fetchNewOrder(willShowLoading: isInitialCall, filteredData: null);
    context.read<OngoingOrderCubit>().fetchOngoingOrder(willShowLoading: isInitialCall, filteredData: null);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const BaseScreenAppBar(),
            2.rh.verticalSpacer(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!UserPermissionManager().isBizOwner())
                      Container(
                        color: AppColors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.s16.rw,
                          vertical: AppSize.s16.rh,
                        ),
                        child: const PauseStoreHeaderView(),
                      ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: 8),
                    Container(
                      color: AppColors.white,
                      padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw, vertical: AppSize.s12.rh),
                      child: const OrderSummaryView(),
                    ),
                    8.rh.verticalSpacer(),
                    const HomeQuickActions(),
                    if (!UserPermissionManager().isBizOwner())
                      const ZReportView().setVisibilityWithSpace(
                        direction: Axis.vertical,
                        startSpace: 8,
                        endSpace: 8,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
