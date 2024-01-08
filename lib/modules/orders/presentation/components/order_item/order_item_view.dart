import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/decorated_image_view.dart';
import 'package:klikit/core/widgets/kt_network_image.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/components/order_item/three_pl_status.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../core/provider/date_time_provider.dart';
import '../../../../../resources/assets.dart';
import 'order_action_buttons.dart';

class OrderItemView extends StatelessWidget {
  final VoidCallback seeDetails;
  final VoidCallback onSwitchRider;
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
    required this.onSwitchRider,
    required this.onAction,
    required this.onCancel,
    required this.onPrint,
    required this.onEditGrabOrder,
    required this.onEditManualOrder,
    required this.onRiderFind,
  }) : super(key: key);

  String _id() {
    if (order.providerId == ProviderID.KLIKIT) {
      return order.id.toString();
    } else if (order.shortId.isNotEmpty) {
      return order.shortId;
    } else {
      return order.externalId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: seeDetails,
      child: Container(
        padding: EdgeInsets.all(AppSize.s12.rSp),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(width: 0.5.rSp, color: AppColors.neutralB40),
          borderRadius: BorderRadius.circular(AppSize.s12.rSp),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  // providerId == 1 ? order.orderSource.logo :
                  KTNetworkImage(width: AppSize.s34.rw, height: AppSize.s34.rh, imageUrl: order.orderSource.logo),
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
                                  '# ${_id()}',
                                  style: boldTextStyle(
                                    color: AppColors.primary,
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
                                    text: _id(),
                                  ),
                                ).then((value) {
                                  showSuccessSnackBar(context, AppStrings.order_id_copied.tr());
                                });
                              },
                              child: Icon(
                                Icons.copy,
                                size: AppSize.s14.rSp,
                                color: AppColors.primary,
                              ),
                            ),
                            if (!order.isManualOrder && order.promos.isNotEmpty && order.promos.first.isSeniorCitizenPromo!)
                              Container(
                                padding: EdgeInsets.all(AppSize.s4.rSp),
                                margin: EdgeInsets.only(left: AppSize.s4.rw),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.greyDarker),
                                ),
                                child: SvgPicture.asset(AppIcons.seniorCitizen),
                              ),
                          ],
                        ),
                        SizedBox(height: AppSize.s2.rh),
                        Text(
                          order.orderSource.title,
                          style: regularTextStyle(
                            color: AppColors.black,
                            fontSize: AppFontSize.s14.rSp,
                          ),
                        ),
                        SizedBox(height: AppSize.s4.rh),
                        Text(
                          DateTimeProvider.parseOrderCreatedDate(order.createdAt),
                          style: regularTextStyle(
                            color: AppColors.black,
                            fontSize: AppFontSize.s12.rSp,
                          ),
                        ),
                        ThreePlStatus(order: order, showTag: false, onSwitchRider: onSwitchRider),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _getActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _getActionButton() {
    if (order.status == OrderStatus.CANCELLED || order.status == OrderStatus.DELIVERED || order.status == OrderStatus.PICKED_UP) {
      return DecoratedImageView(
        iconWidget: ImageResourceResolver.printerSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh, color: AppColors.neutralB600),
        padding: EdgeInsets.all(AppSize.s10.rSp),
        decoration: BoxDecoration(
          color: AppColors.neutralB20,
          borderRadius: BorderRadius.all(
            Radius.circular(200.rSp),
          ),
        ),
        onTap: onPrint,
      );
    } else if (order.status == OrderStatus.SCHEDULED) {
      return Expanded(child: _scheduleOrderAction());
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
          style: mediumTextStyle(
            color: AppColors.yellowDarker,
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
                color: AppColors.primary,
              ),
              SizedBox(width: AppSize.s4.rw),
              Flexible(
                child: Text(
                  DateTimeProvider.scheduleDate(order.scheduledTime),
                  style: mediumTextStyle(
                    color: AppColors.primary,
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
              color: AppColors.primary,
            ),
            SizedBox(width: AppSize.s4.rw),
            Flexible(
              child: Text(
                DateTimeProvider.scheduleTime(order.scheduledTime),
                style: mediumTextStyle(
                  color: AppColors.primary,
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
