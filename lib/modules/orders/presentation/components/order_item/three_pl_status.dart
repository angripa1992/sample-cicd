import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/styles.dart';
import '../../../domain/entities/order.dart';

class ThreePlStatus extends StatelessWidget {
  final Order order;
  final bool showTag;
  final VoidCallback onSwitchRider;

  const ThreePlStatus({
    Key? key,
    required this.order,
    required this.showTag,
    required this.onSwitchRider,
  }) : super(key: key);

  String _status() {
    switch (order.fulfillmentStatusId) {
      case FulfillmentStatusId.ALLOCATING_RIDER:
        return 'Allocating Rider';
      case FulfillmentStatusId.ALLOCATING_RIDER_TWO:
        return 'Allocating Rider';
      case FulfillmentStatusId.CANCELED:
        return 'Canceled';
      case FulfillmentStatusId.CANCELED_TWO:
        return 'Canceled';
      case FulfillmentStatusId.COMPLETED:
        return 'Completed';
      case FulfillmentStatusId.FOUND_RIDER:
        return 'Found Rider';
      case FulfillmentStatusId.IN_DELIVERY:
        return 'In Delivery';
      case FulfillmentStatusId.IN_RETURN:
        return 'In Return';
      case FulfillmentStatusId.RETURNED:
        return 'Returned';
      case FulfillmentStatusId.PICKING_UP:
        return 'Picking Up';
      default:
        return 'Dispatch Failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: order.isThreePlOrder && order.fulfillmentStatusId > 0,
      child: showTag
          ? Expanded(
              child: InkWell(
                onTap: order.canCancelRider ? onSwitchRider : null,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
                  padding: EdgeInsets.symmetric(
                    vertical: AppSize.s4.rh,
                    horizontal: AppSize.s8.rw,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s24.rSp),
                    border: Border.all(color: AppColors.greyDarker),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _status(),
                          textAlign: TextAlign.center,
                          style: regularTextStyle(
                            color: AppColors.black,
                            fontSize: AppFontSize.s14.rSp,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: order.canCancelRider,
                        child: Padding(
                          padding: EdgeInsets.only(left: AppSize.s8.rw),
                          child: Icon(
                            Icons.change_circle_outlined,
                            size: AppSize.s18.rSp,
                            color: AppColors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              margin: EdgeInsets.only(top: AppSize.s6.rh),
              padding: EdgeInsets.symmetric(
                vertical: AppSize.s4.rh,
                horizontal: AppSize.s8.rw,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s24.rSp),
                color: AppColors.greyDark,
              ),
              child: Text(
                _status(),
                style: regularTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s12.rSp,
                ),
              ),
            ),
    );
  }
}
