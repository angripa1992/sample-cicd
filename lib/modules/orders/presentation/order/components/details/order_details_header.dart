import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/order/components/details/order_status.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../app/constants.dart';
import '../../../../../../app/di.dart';
import '../../../../../../core/provider/order_information_provider.dart';
import '../../../../../widgets/snackbars.dart';
import '../../../../domain/entities/provider.dart';
import '../../../../domain/entities/source.dart';
import 'comment_action_view.dart';

class OrderDetailsHeaderView extends StatelessWidget {
  final _infoProvider = getIt.get<OrderInformationProvider>();
  final GlobalKey<ScaffoldState> modalKey;
  final Order order;
  final VoidCallback onCommentActionSuccess;

  OrderDetailsHeaderView(
      {Key? key,
      required this.order,
      required this.modalKey,
      required this.onCommentActionSuccess})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: AppSize.s8.rh,
              bottom: AppSize.s16.rh,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _idView()),
                SizedBox(width: AppSize.s8.rw),
                _placedOnView(),
              ],
            ),
          ),
          _externalIdView(),
          SizedBox(height: AppSize.s12.rh),
          _timeView(),
          SizedBox(height: AppSize.s12.rh),
          //_brandAndCommentView(),
          //SizedBox(height: AppSize.s8.rh),
          OrderStatusView(order: order),
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

  Widget _placedOnView() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSize.s4.rh,
        horizontal: AppSize.s8.rw,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s24.rSp),
          border: Border.all(color: AppColors.purpleBlue)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.placed_on.tr(),
            style: getRegularTextStyle(
              color: AppColors.purpleBlue,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
          order.source > 0
              ? FutureBuilder<Source>(
                  future: _infoProvider.findSourceById(order.source),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Flexible(
                        child: Text(
                          ' ${snapshot.data!.name}',
                          style: getBoldTextStyle(
                            color: AppColors.purpleBlue,
                            fontSize: AppFontSize.s14.rSp,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                )
              : FutureBuilder<Provider>(
                  future: _infoProvider.findProviderById(order.providerId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Flexible(
                        child: Text(
                          ' ${snapshot.data!.title}',
                          style: getBoldTextStyle(
                            color: AppColors.purpleBlue,
                            fontSize: AppFontSize.s14.rSp,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
        ],
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

  Widget _brandAndCommentView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _brandView()),
        SizedBox(width: AppSize.s8.rw),
        CommentActionView(
          onCommentActionSuccess: onCommentActionSuccess,
          order: order,
        ),
      ],
    );
  }

  Widget _brandView() {
    return Row(
      children: [
        Text(
          '${AppStrings.brand.tr()} : ',
          style: getRegularTextStyle(
            color: AppColors.dustyGrey,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        Flexible(
          child: Text(
            order.brandName,
            style: getMediumTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
      ],
    );
  }
}
