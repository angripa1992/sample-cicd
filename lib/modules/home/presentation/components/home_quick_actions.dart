import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/actionable_tile.dart';
import 'package:klikit/core/widgets/kt_chip.dart';
import 'package:klikit/modules/base/base_screen_cubit.dart';
import 'package:klikit/modules/home/presentation/shimer/home_order_nav_card_shimmer.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/bloc/new_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/ongoing_order_cubit.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
        vertical: AppSize.s16.rh,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Quick Actions", style: semiBoldTextStyle()),
          SizedBox(height: AppSize.s16.rh),
          BlocConsumer<OngoingOrderCubit, ResponseState>(
            listener: (context, state) {
              if (state is Failed) {
                showApiErrorSnackBar(context, state.failure);
              }
            },
            builder: (context, state) {
              if (state is Loading) {
                return HomeOrderNavCardShimmer(
                  bgColor: AppColors.white,
                  text: AppStrings.ongoing_orders.tr(),
                  textBaseColor: AppColors.primaryLight,
                  textHighlightColor: AppColors.grey,
                  containerBaseColor: AppColors.primaryLight,
                  containerHighlightColor: AppColors.grey,
                );
              }
              return ActionableTile(
                title: AppStrings.ongoing_orders.tr(),
                titleStyle: mediumTextStyle(),
                titleHelper: KTChip(
                  text: (state is Success<Orders>) ? state.data.total.toString() : "0",
                  textStyle: mediumTextStyle(fontSize: AppSize.s10.rSp, color: AppColors.neutralB700),
                  strokeColor: AppColors.neutralB20,
                  backgroundColor: AppColors.neutralB20,
                  padding: EdgeInsets.symmetric(horizontal: 8.rw, vertical: 2.rh),
                ),
                prefixWidget: ImageResourceResolver.refreshSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh),
                suffixWidget: ImageResourceResolver.rightArrowSVG.getImageWidget(width: 16.rw, height: 16.rh),
                onTap: () {
                  context.read<BaseScreenCubit>().changeIndex(
                        NavigationData(
                          index: BottomNavItem.ORDER,
                          subTabIndex: OrderTab.ONGOING,
                          data: null,
                        ),
                      );
                },
              );
            },
          ),
          SizedBox(height: AppSize.s8.rh),
          BlocConsumer<NewOrderCubit, ResponseState>(
            listener: (context, state) {
              if (state is Failed) {
                showApiErrorSnackBar(context, state.failure);
              }
            },
            builder: (context, state) {
              if (state is Loading) {
                return HomeOrderNavCardShimmer(
                  bgColor: AppColors.primary,
                  text: AppStrings.new_orders.tr(),
                  textBaseColor: AppColors.white,
                  textHighlightColor: AppColors.primaryLight,
                  containerBaseColor: AppColors.primaryLight,
                  containerHighlightColor: AppColors.grey,
                );
              }

              int unread = (state is Success<Orders>) ? state.data.total : 0;
              return ActionableTile(
                title: AppStrings.new_orders.tr(),
                titleStyle: mediumTextStyle(),
                titleHelper: KTChip(
                  text: "$unread",
                  textStyle: mediumTextStyle(fontSize: AppSize.s10.rSp, color: AppColors.white),
                  strokeColor: AppColors.errorR300,
                  backgroundColor: AppColors.errorR300,
                  padding: EdgeInsets.symmetric(horizontal: 8.rw, vertical: 2.rh),
                ),
                prefixWidget: unread > 0
                    ? ImageResourceResolver.unreadNotificationSVG.getImageWidget(
                        width: AppSize.s20.rw,
                        height: AppSize.s20.rh,
                      )
                    : ImageResourceResolver.notificationSVG.getImageWidget(
                        width: AppSize.s20.rw,
                        height: AppSize.s20.rh,
                      ),
                suffixWidget: ImageResourceResolver.rightArrowSVG.getImageWidget(width: 16.rw, height: 16.rh),
                onTap: () {
                  context.read<BaseScreenCubit>().changeIndex(
                        NavigationData(
                          index: BottomNavItem.ORDER,
                          subTabIndex: OrderTab.NEW,
                          data: null,
                        ),
                      );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
