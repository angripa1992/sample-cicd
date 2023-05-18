import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../../../../app/extensions.dart';
import '../../../../widgets/snackbars.dart';
import '../../../domain/entities/provider.dart';
import '../../../provider/order_information_provider.dart';
import 'comment_action_view.dart';
import 'order_tags.dart';

class OrderDetailsHeaderView extends StatelessWidget {
  final GlobalKey<ScaffoldState> modalKey;
  final Order order;
  final VoidCallback onCommentActionSuccess;
  final VoidCallback onEdit;

  const OrderDetailsHeaderView({
    Key? key,
    required this.order,
    required this.modalKey,
    required this.onCommentActionSuccess,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
        vertical: AppSize.s10.rh,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _idView(),
          SizedBox(height: AppSize.s8.rh),
          _externalIdView(),
          SizedBox(height: AppSize.s8.rh),
          _timeView(),
          SizedBox(height: AppSize.s12.rh),
          OrderTagsView(order: order),
          SizedBox(height: AppSize.s12.rh),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if(order.providerId == ProviderID.GRAB_FOOD && order.externalId.isNotEmpty)
              Expanded(
                child: _editOrderButton(onEdit),
              ),
              if(order.providerId == ProviderID.GRAB_FOOD && order.externalId.isNotEmpty)
              SizedBox(width: AppSize.s16.rw),
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
          color: AppColors.dawnPink,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit,
              color: AppColors.blackCow,
              size: AppSize.s16.rSp,
            ),
            SizedBox(width: AppSize.s8.rw),
            Text(
              'Edit Order',
              style: getRegularTextStyle(
                color: AppColors.blackCow,
                fontSize: AppFontSize.s14.rSp,
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
            (order.providerId == ProviderID.KLIKIT)
                ? '#${order.id}'
                : '#${order.shortId}',
            style: getBoldTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s20.rSp,
            ),
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        _copyIdView(
          (order.providerId == ProviderID.KLIKIT)
              ? order.id.toString()
              : order.shortId,
        ),
        if (order.providerId > ZERO)
          Padding(
            padding: EdgeInsets.only(left: AppSize.s18.rw),
            child: FutureBuilder<Provider>(
              future: getIt
                  .get<OrderInformationProvider>()
                  .findProviderById(order.providerId),
              builder: (_, result) {
                if (result.hasData && result.data != null) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSize.s4.rh,
                      horizontal: AppSize.s8.rw,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s24.rSp),
                      border: Border.all(color: AppColors.purpleBlue),
                    ),
                    child: Text(
                      '${AppStrings.placed_on.tr()} ${result.data!.title}',
                      style: getMediumTextStyle(
                        color: AppColors.purpleBlue,
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
        color: AppColors.dustyGreay,
      ),
    );
  }

  Widget _externalIdView() {
    return Row(
      children: [
        Text(
          AppStrings.id.tr(),
          style: getRegularTextStyle(
            color: AppColors.dustyGrey,
            fontSize: AppFontSize.s15.rSp,
          ),
        ),
        SizedBox(width: AppSize.s6.rw),
        Flexible(
          child: Text(
            order.externalId,
            style: getMediumTextStyle(
              color: AppColors.dustyGreay,
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
          color: AppColors.dustyGreay,
          size: AppSize.s18.rSp,
        ),
        SizedBox(width: AppSize.s6.rw),
        Expanded(
          child: Text(
            DateTimeProvider.parseOrderCreatedDate(order.createdAt),
            style: getMediumTextStyle(
              color: AppColors.darkGrey,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
      ],
    );
  }
}
