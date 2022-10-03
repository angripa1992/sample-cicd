import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/order_information_provider.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/entities/provider.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class OrderItemView extends StatelessWidget {
  final _infoProvider = getIt.get<OrderInformationProvider>();
  final Order order;

  OrderItemView({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                height: AppSize.s36.rh,
                width: AppSize.s36.rw,
                child: FutureBuilder<Provider>(
                  future: _infoProvider.getProviderById(order.providerId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Image.network(
                          'https://cdn.dev.shadowchef.co/${snapshot.data!.logo}');
                    }
                    return SizedBox(
                      height: AppSize.s12.rh,
                      width: AppSize.s12.rw,
                      child: const CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              SizedBox(width: AppSize.s10.rw),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '#${order.shortId}',
                        style: getBoldTextStyle(
                          color: AppColors.purpleBlue,
                          fontSize: AppFontSize.s13.rSp,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.copy,
                          size: AppSize.s14.rSp,
                          color: AppColors.purpleBlue,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
