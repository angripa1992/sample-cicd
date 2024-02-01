import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/core/widgets/kt_network_image.dart';
import 'package:klikit/modules/common/business_information_provider.dart';
import 'package:klikit/modules/common/entities/provider.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/components/order_item/order_action_button_manager.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../app/constants.dart';
import '../../../../widgets/snackbars.dart';
import 'comment_action_view.dart';
import 'order_tags.dart';

class OrderDetailsHeaderView extends StatelessWidget {
  final Order order;
  final VoidCallback onCommentActionSuccess;
  final VoidCallback onEditGrabOrder;
  final VoidCallback onEditManualOrder;
  final VoidCallback onSwitchRider;
  final VoidCallback onRiderFind;

  const OrderDetailsHeaderView({
    Key? key,
    required this.order,
    required this.onCommentActionSuccess,
    required this.onEditGrabOrder,
    required this.onEditManualOrder,
    required this.onSwitchRider,
    required this.onRiderFind,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final canUpdateGrabOrder = (order.providerId == ProviderID.GRAB_FOOD) && order.externalId.isNotEmpty && order.canUpdate;
    final canUpdateKlikitOrder = OrderActionButtonManager().canUpdateOrder(order);
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
        vertical: AppSize.s10.rh,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              KTNetworkImage(
                width: 56.rw,
                height: 56.rh,
                imageUrl: order.orderSource.logo,
                widgetPadding: AppSize.s8.rSp,
                borderRadius: BorderRadius.all(
                  Radius.circular(200.rSp),
                ),
              ).setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _idView(),
                    if (order.providerId > ZERO)
                      FutureBuilder<Provider>(
                        future: getIt.get<BusinessInformationProvider>().findProviderById(order.providerId),
                        builder: (_, result) {
                          if (result.hasData && result.data != null) {
                            return Text(
                              '${AppStrings.placed_on.tr()} ${result.data!.title}',
                              style: mediumTextStyle(
                                color: AppColors.neutralB700,
                                fontSize: AppFontSize.s12.rSp,
                              ),
                            ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: AppSize.s2);
                          }
                          return const SizedBox();
                        },
                      ),
                    Text(
                      DateTimeFormatter.parseOrderCreatedDate(order.createdAt, 'd MMM yyyy, h:mm a'),
                      style: regularTextStyle(
                        color: AppColors.neutralB600,
                        fontSize: AppFontSize.s12.rSp,
                      ),
                    ).setVisibilityWithSpace(direction: Axis.vertical, endSpace: AppSize.s2),
                  ],
                ),
              ),
            ],
          ),
          _externalIdView().setVisibilityWithSpace(direction: Axis.vertical, startSpace: AppSize.s12, endSpace: AppSize.s12),
          OrderTagsView(order: order, onSwitchRider: onSwitchRider).setVisibilityWithSpace(direction: Axis.vertical, endSpace: AppSize.s12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (canUpdateKlikitOrder || canUpdateGrabOrder)
                Expanded(child: _editOrderButton(canUpdateGrabOrder ? onEditGrabOrder : onEditManualOrder).setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s8)),
              if (OrderActionButtonManager().canTrackRider(order) || OrderActionButtonManager().canFindRider(order))
                Expanded(
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
                  ).setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s8),
                ),
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
    return KTButton(
      controller: KTButtonController(label: AppStrings.edit_order.tr()),
      prefixWidget: ImageResourceResolver.editSVG.getImageWidget(
        width: AppSize.s14.rw,
        height: AppSize.s14.rh,
        color: AppColors.neutralB700,
      ),
      backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.greyBright),
      labelStyle: mediumTextStyle(fontSize: AppSize.s12.rSp, color: AppColors.neutralB700),
      splashColor: AppColors.greyBright,
      onTap: onEdit,
    );
  }

  Widget _idView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            (order.providerId == ProviderID.KLIKIT) ? '#${order.id}' : '#${order.shortId}',
            style: semiBoldTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s18.rSp,
            ),
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        _copyIdView(
          (order.providerId == ProviderID.KLIKIT) ? order.id.toString() : order.shortId,
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
      child: ImageResourceResolver.copySVG.getImageWidget(width: AppSize.s16.rw, height: AppSize.s16.rh, color: AppColors.neutralB90),
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
}
