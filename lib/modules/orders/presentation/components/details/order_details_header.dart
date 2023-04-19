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
import '../../../../widgets/snackbars.dart';
import 'comment_action_view.dart';
import 'order_tags.dart';

class OrderDetailsHeaderView extends StatelessWidget {
  final GlobalKey<ScaffoldState> modalKey;
  final Order order;
  final VoidCallback onCommentActionSuccess;

  const OrderDetailsHeaderView({
    Key? key,
    required this.order,
    required this.modalKey,
    required this.onCommentActionSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
      ),
      child: Column(
        children: [
          _idView(),
          SizedBox(height: AppSize.s12.rh),
          OrderTagsView(order: order),
          SizedBox(height: AppSize.s12.rh),
          _externalIdView(),
          SizedBox(height: AppSize.s12.rh),
          _timeView(),
          SizedBox(height: AppSize.s12.rh),
        ],
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
          '${AppStrings.id.tr()} : ',
          style: getRegularTextStyle(
            color: AppColors.dustyGrey,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        Flexible(
          child: Text(
            order.externalId,
            style: getMediumTextStyle(
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
        Text(
          '${AppStrings.time.tr()} : ',
          style: getRegularTextStyle(
            color: AppColors.dustyGrey,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        Expanded(
          child: Text(
            DateTimeProvider.parseOrderCreatedDate(order.createdAt),
            style: getMediumTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        CommentActionView(
          onCommentActionSuccess: onCommentActionSuccess,
          order: order,
        ),
      ],
    );
  }
}
