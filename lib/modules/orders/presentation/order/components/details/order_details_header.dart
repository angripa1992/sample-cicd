import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/order/components/details/comment_action_view.dart';
import 'package:klikit/modules/orders/presentation/order/components/details/order_status.dart';
import 'package:klikit/modules/orders/presentation/order/components/dialogs/comment_dialog.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../app/constants.dart';
import '../../../../../../app/di.dart';
import '../../../../../../core/provider/order_information_provider.dart';
import '../../../../../widgets/snackbars.dart';
import '../../../../domain/entities/provider.dart';

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
        Icon(
          Icons.remove,
          color: AppColors.blackCow,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(
              width: AppSize.s32.rw,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: (order.providerId == ProviderID.KLIKIT)
                          ? order.id.toString()
                          : order.shortId,
                    ),
                  ).then((value) {
                    showSuccessSnackBar(
                      RoutesGenerator.navigatorKey.currentState!.context,
                      'Order id copied',
                    );
                  });
                },
                icon: Icon(
                  Icons.copy,
                  size: AppSize.s18.rSp,
                  color: AppColors.purpleBlue,
                ),
              ),
            ),
            CommentActionView(
              onCommentActionSuccess: onCommentActionSuccess,
              order: order,
            ),
          ],
        ),
        Text(
          DateTimeProvider.parseOrderCreatedDate(order.createdAt),
          style: getRegularTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s20.rSp,
          ),
        ),
        SizedBox(height: AppSize.s12.rh),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s24.rw,
            vertical: AppSize.s8.rh,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s24.rSp),
            color: AppColors.purpleBlue,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Placed on',
                style: getRegularTextStyle(
                  color: AppColors.white,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
              FutureBuilder<Provider>(
                future: _infoProvider.findProviderById(order.providerId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      ' ${snapshot.data!.title}',
                      style: getBoldTextStyle(
                        color: AppColors.white,
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
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s18.rw,
          ),
          child: OrderStatusView(order: order),
        ),
      ],
    );
  }
}
