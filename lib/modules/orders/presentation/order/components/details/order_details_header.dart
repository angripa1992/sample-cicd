import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/order/components/details/order_status.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../app/di.dart';
import '../../../../../../core/provider/order_information_provider.dart';
import '../../../../domain/entities/provider.dart';

class OrderDetailsHeaderView extends StatelessWidget {
  final _infoProvider = getIt.get<OrderInformationProvider>();
  final Order order;

  OrderDetailsHeaderView({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.remove,
          color: Colors.grey[600],
        ),
        Text(
          '# ${order.shortId}',
          style: getBoldTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s20.rSp,
          ),
        ),
        SizedBox(height: AppSize.s2.rh),
        Text(
          DateTimeProvider.parseOrderCreatedDate(order.createdAt),
          style: getRegularTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s20.rSp,
          ),
        ),
        SizedBox(height: AppSize.s8.rh),
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
                future: _infoProvider.getProviderById(order.providerId),
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
