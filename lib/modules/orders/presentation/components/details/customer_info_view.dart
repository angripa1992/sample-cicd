import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class OrderCustomerInfoView extends StatelessWidget {
  final Order order;

  const OrderCustomerInfoView({Key? key, required this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
        vertical: AppSize.s8.rh,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(),
          Text(
            'Customer Info',
            style: boldTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s15.rSp,
            ),
          ),
          SizedBox(height: AppSize.s4.rh),
          Row(
            children: [
              Expanded(
                child: _infoItem(
                    'Name', '${order.userFirstName} ${order.userLastName}'),
              ),
              Expanded(
                child: _infoItem('Phone Number', order.userPhone),
              ),
            ],
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
          style: mediumTextStyle(
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
