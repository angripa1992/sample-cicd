import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class PriceView extends StatelessWidget {
  final Order order;
  final _controller = ExpandedTileController(isExpanded: false);

  PriceView({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        ExpandedTile(
          theme: ExpandedTileThemeData(
            headerColor: AppColors.white,
            headerPadding: EdgeInsets.symmetric(
              horizontal: AppSize.ZERO,
              vertical: AppSize.ZERO,
            ),
            headerSplashColor: AppColors.lightViolet,
            contentBackgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
          ),
          trailing: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.black,
          ),
          trailingRotation: 180,
          title: Text(
            'Subtotal',
            style: getRegularTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s11.rSp,
            ),
          ),
          content: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Column(
              children: [
                _getSubtotalItem('Vat', order.vat.toString()),
                _getSubtotalItem('Delivery Fee', order.vat.toString()),
                _getSubtotalItem('Additional Fee', order.vat.toString()),
                _getSubtotalItem('Discount', order.vat.toString(),color: AppColors.red),
              ],
            ),
          ),
          controller: _controller,
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: getRegularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
            Text(
              '${order.currencySymbol}${order.finalPrice}',
              style: getRegularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getSubtotalItem(String name, String price, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: getRegularTextStyle(
            color: color ?? AppColors.black,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        Text(
          '${order.currencySymbol}$price',
          style: getRegularTextStyle(
            color: color ?? AppColors.black,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
      ],
    );
  }
}
