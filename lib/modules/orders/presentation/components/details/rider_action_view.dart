import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/components/order_item/order_action_button_manager.dart';
import 'package:klikit/resources/colors.dart';

import '../../../../../core/route/routes.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class RiderActionView extends StatelessWidget {
  final VoidCallback onRiderFind;
  final Order order;

  const RiderActionView({super.key, required this.order, required this.onRiderFind});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
      ),
      child: Column(
        children: [
          Visibility(
            visible: OrderActionButtonManager().canFindRider(order),
            child: InkWell(
              onTap: onRiderFind,
              child: Container(
                margin: EdgeInsets.only(bottom: AppSize.s8.rh),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s8.rw,
                  vertical: AppSize.s6.rh,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                  border: Border.all(color: AppColors.black),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delivery_dining_rounded,
                      color: AppColors.black,
                      size: AppSize.s16.rSp,
                    ),
                    SizedBox(width: AppSize.s8.rw),
                    Flexible(
                      child: Text(
                        AppStrings.find_rider.tr(),
                        style: regularTextStyle(
                          color: AppColors.black,
                          fontSize: AppFontSize.s14.rSp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: OrderActionButtonManager().canTrackRider(order),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  Routes.webView,
                  arguments: order.fulfillmentTrackingUrl,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s8.rw,
                  vertical: AppSize.s6.rh,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                  border: Border.all(color: AppColors.black),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delivery_dining_rounded,
                      color: AppColors.black,
                      size: AppSize.s16.rSp,
                    ),
                    SizedBox(width: AppSize.s8.rw),
                    Flexible(
                      child: Text(
                        AppStrings.track_rider.tr(),
                        style: regularTextStyle(
                          color: AppColors.black,
                          fontSize: AppFontSize.s14.rSp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
