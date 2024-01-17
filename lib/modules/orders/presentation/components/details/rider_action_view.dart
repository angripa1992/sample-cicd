import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/components/order_item/order_action_button_manager.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/resource_resolver.dart';

import '../../../../../core/route/routes.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class RiderActionView extends StatelessWidget {
  final VoidCallback onRiderFind;
  final Order order;

  const RiderActionView({super.key, required this.order, required this.onRiderFind});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: OrderActionButtonManager().canTrackRider(order) || OrderActionButtonManager().canFindRider(order),
      child: KTButton(
        controller: KTButtonController(label: OrderActionButtonManager().canFindRider(order) ? AppStrings.find_rider.tr() : AppStrings.track_rider.tr()),
        prefixWidget: ImageResourceResolver.riderSVG.getImageWidget(width: AppSize.s14.rw, height: AppSize.s14.rh, color: AppColors.neutralB400),
        backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.greyBright),
        labelStyle: mediumTextStyle(fontSize: AppSize.s12.rSp, color: AppColors.neutralB700),
        splashColor: AppColors.greyBright,
        onTap: () {
          if (OrderActionButtonManager().canFindRider(order)) {
            onRiderFind();
          } else if (OrderActionButtonManager().canTrackRider(order)) {
            Navigator.of(context).pushNamed(
              Routes.webView,
              arguments: order.fulfillmentTrackingUrl,
            );
          }
        },
      ),
    );
  }
}
