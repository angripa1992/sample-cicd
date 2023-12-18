import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import 'attachment_view.dart';

class OrderCustomerInfoView extends StatelessWidget {
  final Order order;

  const OrderCustomerInfoView({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: order.status != OrderStatus.CANCELLED && order.status != OrderStatus.DELIVERED && order.status != OrderStatus.PICKED_UP,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s16.rw,
          vertical: AppSize.s8.rh,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(),
            Text(
              AppStrings.customer_info.tr(),
              style: semiBoldTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s17.rSp,
              ),
            ),
            if (order.orderAppliedPromo != null && order.orderAppliedPromo!.isSeniorCitizenPromo!)
              Padding(
                padding: EdgeInsets.only(top: AppSize.s8.rh),
                child: _tagView(),
              ),
            SizedBox(height: AppSize.s8.rh),
            Row(
              children: [
                Expanded(
                  child: Visibility(
                    visible: order.userFirstName.isNotEmpty,
                    child: _infoItem(AppStrings.name.tr(), '${order.userFirstName} ${order.userLastName}'),
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: order.userPhone.isNotEmpty,
                    child: _infoItem(AppStrings.phone_number.tr(), order.userPhone),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSize.s8.rh),
            Row(
              children: [
                Expanded(
                  child: Visibility(
                    visible: order.type == OrderType.PICKUP && order.pickupType == PickupType.DRIVE_THRU && order.additionalInfo != null,
                    child: _infoItem(AppStrings.vehicle_registration.tr(), '${order.additionalInfo?.vehicleInfo?.regNo}'),
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible:
                        order.type == OrderType.PICKUP && order.pickupType == PickupType.DRIVE_THRU && order.additionalInfo != null && order.additionalInfo!.vehicleInfo!.additionalDetails.isNotEmpty,
                    child: _infoItem('Additional Information', '${order.additionalInfo?.vehicleInfo?.additionalDetails}'),
                  ),
                ),
              ],
            ),
            if (!order.isManualOrder && order.orderAppliedPromo != null && order.orderAppliedPromo!.isSeniorCitizenPromo!) AttachmentView(order: order),
          ],
        ),
      ),
    );
  }

  Widget _tagView() {
    return Row(
      children: [
        _tagItem('SC/PWD', null),
        SizedBox(width: AppSize.s4.rw),
        _tagItem('Total- ${order.orderAppliedPromo!.numberOfCustomer!}', AppIcons.totalCustomer),
        SizedBox(width: AppSize.s4.rw),
        _tagItem('PWD/SC- ${order.orderAppliedPromo!.numberOfSeniorCitizen!}', AppIcons.seniorCitizen),
      ],
    );
  }

  Widget _tagItem(String tag, String? iconPath) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw, vertical: AppSize.s2.rh),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyDark),
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
      ),
      child: Row(
        children: [
          if (iconPath != null)
            SvgPicture.asset(
              iconPath,
              width: AppSize.s16.rw,
              height: AppSize.s16.rh,
            ),
          if (iconPath != null) SizedBox(width: AppSize.s4.rw),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: semiBoldTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        SizedBox(height: AppSize.s2.rh),
        Text(
          description,
          style: regularTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
      ],
    );
  }
}
