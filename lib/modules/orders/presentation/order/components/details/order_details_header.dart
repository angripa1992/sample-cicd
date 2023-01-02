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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.s16.rh,
            horizontal: AppSize.s16.rw,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _idView(),
              const Spacer(),
              _placedOnView(),
            ],
          ),
        ),
        _externalIdView(),
        SizedBox(height: AppSize.s4.rh),
        _timeView(),
        SizedBox(height: AppSize.s4.rh),
        _brandAndCommentView(),
        SizedBox(height: AppSize.s12.rh),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s18.rw,
          ),
          child: OrderStatusView(order: order),
        ),
      ],
    );
  }

  Widget _idView() {
    return Row(
      children: [
        Text(
          (order.providerId == ProviderID.KLIKIT)
              ? '#${order.id}'
              : '#${order.shortId}',
          style: getBoldTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s20.rSp,
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
        horizontal: AppSize.s8.rw,
        vertical: AppSize.s4.rh,
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
                      return Text(
                        ' ${snapshot.data!.name}',
                        style: getBoldTextStyle(
                          color: AppColors.purpleBlue,
                          fontSize: AppFontSize.s14.rSp,
                        ),
                      );
                    }
                    return SizedBox(
                      height: AppSize.s12.rh,
                      width: AppSize.s12.rw,
                      child: const CircularProgressIndicator(),
                    );
                  },
                )
              : FutureBuilder<Provider>(
                  future: _infoProvider.findProviderById(order.providerId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        ' ${snapshot.data!.title}',
                        style: getBoldTextStyle(
                          color: AppColors.purpleBlue,
                          fontSize: AppFontSize.s14.rSp,
                        ),
                      );
                    }
                    return SizedBox(
                      height: AppSize.s12.rh,
                      width: AppSize.s12.rw,
                      child: const CircularProgressIndicator(),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _externalIdView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
      child: Row(
        children: [
          Text(
            '${AppStrings.id.tr()} : ',
            style: getRegularTextStyle(
              color: AppColors.dustyGrey,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          Text(
            order.externalId,
            style: getRegularTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          SizedBox(width: AppSize.s8.rw),
          _copyIdView(order.externalId),
        ],
      ),
    );
  }

  Widget _timeView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
      child: Row(
        children: [
          Text(
            '${AppStrings.time.tr()} : ',
            style: getRegularTextStyle(
              color: AppColors.dustyGrey,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          Text(
            DateTimeProvider.parseOrderCreatedDate(order.createdAt),
            style: getRegularTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _brandAndCommentView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _brandView(),
          CommentActionView(
            onCommentActionSuccess: onCommentActionSuccess,
            order: order,
          ),
        ],
      ),
    );
  }

  Widget _brandView() {
    return Row(
      children: [
        Text(
          '${AppStrings.brand.tr()} : ',
          style: getRegularTextStyle(
            color: AppColors.dustyGrey,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
        Text(
          order.brandName,
          style: getRegularTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
      ],
    );
  }
}
