import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/components/order_item/three_pl_status.dart';
import 'package:klikit/modules/widgets/image_view.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../core/provider/date_time_provider.dart';
import 'order_action_buttons.dart';

class OrderItemView extends StatelessWidget {
  final VoidCallback seeDetails;
  final Function(String, int) onAction;
  final Function(String) onCancel;
  final VoidCallback onPrint;
  final VoidCallback onEditGrabOrder;
  final VoidCallback onEditManualOrder;
  final VoidCallback onRiderFind;
  final Order order;

  const OrderItemView({
    Key? key,
    required this.order,
    required this.seeDetails,
    required this.onAction,
    required this.onCancel,
    required this.onPrint,
    required this.onEditGrabOrder,
    required this.onEditManualOrder,
    required this.onRiderFind,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: AppSize.s10),
                child: SizedBox(
                  child: ImageView(path: order.orderSource.logo),
                ),
              ),
              SizedBox(width: AppSize.s8.rw),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: AppSize.s2.rh),
                            child: Text(
                              (order.providerId == ProviderID.KLIKIT)
                                  ? '#${order.id}'
                                  : '#${order.shortId}',
                              style: getBoldTextStyle(
                                color: AppColors.purpleBlue,
                                fontSize: AppFontSize.s16.rSp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSize.s8.rw),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: (order.providerId == ProviderID.KLIKIT)
                                    ? order.id.toString()
                                    : order.shortId,
                              ),
                            ).then((value) {
                              showSuccessSnackBar(
                                  context, AppStrings.order_id_copied.tr());
                            });
                          },
                          child: Icon(
                            Icons.copy,
                            size: AppSize.s14.rSp,
                            color: AppColors.purpleBlue,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      order.orderSource.title,
                      style: getRegularTextStyle(
                        color: AppColors.bluewood,
                        fontSize: AppFontSize.s12.rSp,
                      ),
                    ),
                    if (order.isThreePlOrder && order.fulfillmentStatusId > 0)
                      Padding(
                        padding: EdgeInsets.only(top: AppSize.s6.rh),
                        child: ThreePlStatus(threePlStatus: order.fulfillmentStatusId),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: AppSize.s8.rh,
              right: AppSize.s8.rw,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _getActionButton(),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: seeDetails,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        AppStrings.see_details.tr(),
                        style: getMediumTextStyle(
                          color: AppColors.purpleBlue,
                          fontSize: AppFontSize.s11.rSp,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.purpleBlue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getActionButton() {
    if (order.status == OrderStatus.CANCELLED ||
        order.status == OrderStatus.DELIVERED ||
        order.status == OrderStatus.PICKED_UP) {
      return SizedBox(
        width: AppSize.s42.rw,
        child: PrintButton(
          expanded: false,
          onPrint: onPrint,
        ),
      );
    } else if (order.status == OrderStatus.SCHEDULED) {
      return _scheduleOrderAction();
    } else {
      return getActionButtons(
        order: order,
        onAction: onAction,
        onPrint: onPrint,
        onCancel: onCancel,
        onEditGrabOrder: onEditGrabOrder,
        onEditManualOrder: onEditManualOrder,
        onRiderFind: onRiderFind,
      );
    }
  }

  Widget _scheduleOrderAction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          AppStrings.scheduled.tr(),
          style: getMediumTextStyle(
            color: AppColors.dustyOrange,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.date_range,
                size: AppSize.s16.rSp,
                color: AppColors.purpleBlue,
              ),
              SizedBox(width: AppSize.s4.rw),
              Flexible(
                child: Text(
                  DateTimeProvider.scheduleDate(order.scheduledTime),
                  style: getMediumTextStyle(
                    color: AppColors.purpleBlue,
                    fontSize: AppFontSize.s14.rSp,
                  ),
                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.access_time,
              size: AppSize.s16.rSp,
              color: AppColors.purpleBlue,
            ),
            SizedBox(width: AppSize.s4.rw),
            Flexible(
              child: Text(
                DateTimeProvider.scheduleTime(order.scheduledTime),
                style: getMediumTextStyle(
                  color: AppColors.purpleBlue,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
