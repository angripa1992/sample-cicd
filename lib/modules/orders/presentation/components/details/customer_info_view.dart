import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import 'attachment_view.dart';

class OrderCustomerInfoView extends StatelessWidget {
  final Order order;

  const OrderCustomerInfoView({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: order.status != OrderStatus.CANCELLED && order.status != OrderStatus.DELIVERED && order.status != OrderStatus.PICKED_UP,
      child: Container(
        color: AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.rw, vertical: 8.rh),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.customer_info.tr(),
              style: semiBoldTextStyle(
                color: AppColors.neutralB500,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
            if (order.orderAppliedPromo != null && order.orderAppliedPromo!.isSeniorCitizenPromo!)
              Padding(
                padding: EdgeInsets.only(top: 12.rh),
                child: _tagView(),
              ),
            SizedBox(height: 8.rh),
            Wrap(
              spacing: 16.0.rw,
              runSpacing: 8.0.rh,
              children: [
                if (order.userFirstName.isNotEmpty)
                  _infoItem(
                    AppStrings.name.tr(),
                    '${order.userFirstName} ${order.userLastName}',
                  ),
                if (order.userPhone.isNotEmpty)
                  _infoItem(
                    AppStrings.phone_number.tr(),
                    order.userPhone,
                  ),
                if (order.type == OrderType.PICKUP && order.pickupType == PickupType.DRIVE_THRU && order.additionalInfo != null)
                  _infoItem(
                    AppStrings.vehicle_registration.tr(),
                    '${order.additionalInfo?.vehicleInfo?.regNo}',
                  ),
                if (order.estimatedPickUpAt.isNotEmpty)
                  _infoItem(
                    'Pickup Time',
                    DateTimeFormatter.parseOrderCreatedDate(order.estimatedPickUpAt),
                  ),
                if (order.estimatedDeliveryAt.isNotEmpty)
                  _infoItem(
                    'Delivery Time',
                    DateTimeFormatter.parseOrderCreatedDate(order.estimatedDeliveryAt),
                  ),
                if (order.type == OrderType.PICKUP && order.pickupType == PickupType.DRIVE_THRU && order.additionalInfo != null && order.additionalInfo!.vehicleInfo!.additionalDetails.isNotEmpty)
                  _infoItem(
                    'Additional Information',
                    '${order.additionalInfo?.vehicleInfo?.additionalDetails}',
                  )
              ],
            ),
            if (!order.isManualOrder && order.orderAppliedPromo != null && order.orderAppliedPromo!.isSeniorCitizenPromo!) AttachmentView(order: order),
          ],
        ),
      ).setVisibilityWithSpace(direction: Axis.vertical, startSpace: 8),
    );
  }

  Widget _tagView() {
    return Row(
      children: [
        _tagItem('SC/PWD', null),
        SizedBox(width: 4.rw),
        _tagItem('Total- ${order.orderAppliedPromo?.numberOfCustomer}', AppIcons.totalCustomer),
        SizedBox(width: 4.rw),
        _tagItem('PWD/SC- ${order.orderAppliedPromo?.numberOfSeniorCitizen}', AppIcons.seniorCitizen),
      ],
    );
  }

  Widget _tagItem(String tag, String? iconPath) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.rw, vertical: 2.rh),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyDark),
        borderRadius: BorderRadius.circular(8.rSp),
      ),
      child: Row(
        children: [
          if (iconPath != null)
            SvgPicture.asset(
              iconPath,
              width: 16.rw,
              height: 16.rh,
            ),
          if (iconPath != null) SizedBox(width: 4.rw),
          Text(
            tag,
            style: regularTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String title, String description) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        Text(
          title,
          style: mediumTextStyle(
            color: AppColors.neutralB300,
            fontSize: AppFontSize.s12.rSp,
          ),
        ),
        SizedBox(height: 2.rh),
        SizedBox(
          width: ScreenSizes.screenWidth/3,
          child: Text(
            description,
            style: regularTextStyle(
              color: AppColors.neutralB500,
              fontSize: AppFontSize.s12.rSp,
            ),
          ),
        ),
      ],
    );
  }
}
