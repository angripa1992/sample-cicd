import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/styles.dart';

class ThreePlStatus extends StatelessWidget {
  final int threePlStatus;
  const ThreePlStatus({Key? key, required this.threePlStatus}) : super(key: key);

  String _status(){
    switch(threePlStatus){
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
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSize.s4.rh,
        horizontal: AppSize.s8.rw,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        color: AppColors.lightGrey,
      ),
      child: Text(
        _status(),
        style: regularTextStyle(color: AppColors.bluewood),
      ),
    );
  }
}
