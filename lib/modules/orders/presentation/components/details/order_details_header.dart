import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/components/order_item/order_action_button_manager.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../../../../app/extensions.dart';
import '../../../../common/business_information_provider.dart';
import '../../../../common/entities/provider.dart';
import '../../../../widgets/snackbars.dart';
import 'comment_action_view.dart';
import 'order_tags.dart';

class OrderDetailsHeaderView extends StatelessWidget {
  final Order order;
  final VoidCallback onCommentActionSuccess;
  final VoidCallback onEditGrabOrder;
  final VoidCallback onEditManualOrder;
  final VoidCallback onSwitchRider;

  const OrderDetailsHeaderView({
    Key? key,
    required this.order,
    required this.onCommentActionSuccess,
    required this.onEditGrabOrder,
    required this.onEditManualOrder,
    required this.onSwitchRider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final canUpdateGrabOrder = (order.providerId == ProviderID.GRAB_FOOD) && order.externalId.isNotEmpty && order.canUpdate;
    final canUpdateKlikitOrder = OrderActionButtonManager().canUpdateOrder(order);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
        vertical: AppSize.s10.rh,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _idView(),
          SizedBox(height: AppSize.s12.rh),
          OrderTagsView(order: order, onSwitchRider: onSwitchRider),
          SizedBox(height: AppSize.s8.rh),
          _externalIdView(),
          SizedBox(height: AppSize.s8.rh),
          _timeView(),
          SizedBox(height: AppSize.s12.rh),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (canUpdateKlikitOrder || canUpdateGrabOrder) Expanded(child: _editOrderButton(canUpdateGrabOrder ? onEditGrabOrder : onEditManualOrder)),
              if (canUpdateKlikitOrder || canUpdateGrabOrder) SizedBox(width: AppSize.s8.rw),
              if (order.isThreePlOrder && order.canFindFulfillmentRider) SizedBox(width: AppSize.s8.rw),
              Expanded(
                child: CommentActionView(
                  onCommentActionSuccess: onCommentActionSuccess,
                  order: order,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _editOrderButton(VoidCallback onEdit) {
    return InkWell(
      onTap: onEdit,
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
              Icons.edit_outlined,
              color: AppColors.black,
              size: AppSize.s16.rSp,
            ),
            SizedBox(width: AppSize.s8.rw),
            Flexible(
              child: Text(
                AppStrings.edit_order.tr(),
                style: regularTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _idView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            (order.providerId == ProviderID.KLIKIT) ? '#${order.id}' : '#${order.shortId}',
            style: boldTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s20.rSp,
            ),
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        _copyIdView(
          (order.providerId == ProviderID.KLIKIT) ? order.id.toString() : order.shortId,
        ),
        if (order.providerId > ZERO)
          Padding(
            padding: EdgeInsets.only(left: AppSize.s18.rw),
            child: FutureBuilder<Provider>(
              future: getIt.get<BusinessInformationProvider>().findProviderById(order.providerId),
              builder: (_, result) {
                if (result.hasData && result.data != null) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSize.s4.rh,
                      horizontal: AppSize.s8.rw,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s24.rSp),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Text(
                      '${AppStrings.placed_on.tr()} ${result.data!.title}',
                      style: mediumTextStyle(
                        color: AppColors.primary,
                        fontSize: AppFontSize.s14.rSp,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
      ],
    );
  }

  Widget _copyIdView(String id) {
    return InkWell(
      onTap: () {
        Clipboard.setData(
          ClipboardData(text: id),
        ).then((value) {
          showSuccessSnackBar(
            RoutesGenerator.navigatorKey.currentState!.context,
            AppStrings.order_id_copied.tr(),
          );
        });
      },
      child: Icon(
        Icons.copy,
        size: AppSize.s18.rSp,
        color: AppColors.black,
      ),
    );
  }

  Widget _externalIdView() {
    return Row(
      children: [
        Text(
          AppStrings.id.tr(),
          style: regularTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s15.rSp,
          ),
        ),
        SizedBox(width: AppSize.s6.rw),
        Flexible(
          child: Text(
            order.externalId,
            style: mediumTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        _copyIdView(order.externalId),
      ],
    );
  }

  Widget _timeView() {
    return Row(
      children: [
        Icon(
          Icons.date_range,
          color: AppColors.primary,
          size: AppSize.s18.rSp,
        ),
        SizedBox(width: AppSize.s6.rw),
        Expanded(
          child: Text(
            DateTimeProvider.parseOrderCreatedDate(order.createdAt),
            style: mediumTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
      ],
    );
  }
}
