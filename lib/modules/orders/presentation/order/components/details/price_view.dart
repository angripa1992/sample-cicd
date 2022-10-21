import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class PriceView extends StatefulWidget {
  final Order order;

  const PriceView({super.key, required this.order});

  @override
  State<PriceView> createState() => _PriceViewState();
}

class _PriceViewState extends State<PriceView> {
  ExpandedTileController? _controller;

  @override
  void initState() {
    _controller = ExpandedTileController(isExpanded: false);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String _subtotal() {
    final order = widget.order;
    late num subtotal;
    if (order.providerId == ProviderID.FOOD_PANDA) {
      subtotal = (order.finalPrice + order.discount) - order.deliveryFee;
    } else {
      subtotal = order.itemPrice;
    }
    return '${order.currencySymbol}$subtotal';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        ExpandedTile(
          theme: ExpandedTileThemeData(
            headerColor: Colors.transparent,
            headerPadding: EdgeInsets.symmetric(
              horizontal: AppSize.s12.rw,
              vertical: AppSize.ZERO,
            ),
            leadingPadding: EdgeInsets.zero,
            trailingPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            headerSplashColor: AppColors.lightGrey,
            contentBackgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
          ),
          trailing: Text(
            _subtotal(),
            style: TextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
              fontWeight: AppFontWeight.bold,
            ),
          ),
          trailingRotation: 0,
          title: SubtotalExpandHeader(controller: _controller!),
          content: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSize.s8.rh,
              horizontal: AppSize.s12.rw,
            ),
            child: Column(
              children: [
                _getSubtotalItem(
                  'Vat',
                  widget.order.vat.toString(),
                ),
                SizedBox(height: AppSize.s2.rh),
                _getSubtotalItem(
                  'Delivery Fee',
                  widget.order.deliveryFee.toString(),
                ),
                SizedBox(height: AppSize.s2.rh),
                _getSubtotalItem(
                  'Additional Fee',
                  widget.order.additionalFee.toString(),
                ),
                SizedBox(height: AppSize.s2.rh),
                _getSubtotalItem(
                  'Discount',
                  widget.order.discount.toString(),
                  color: AppColors.red,
                ),
              ],
            ),
          ),
          controller: _controller!,
        ),
        const Divider(),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.s8.rh,
            horizontal: AppSize.s12.rw,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s20.rSp,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
              Text(
                '${widget.order.currencySymbol}${widget.order.finalPrice}',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s20.rSp,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getSubtotalItem(String name, String price, {Color? color}) {
    final textStyle = TextStyle(
      color: color ?? AppColors.black,
      fontSize: AppFontSize.s14.rSp,
      fontWeight: AppFontWeight.regular,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: textStyle,
        ),
        Text(
          '${widget.order.currencySymbol}$price',
          style: textStyle,
        ),
      ],
    );
  }
}

class SubtotalExpandHeader extends StatefulWidget {
  final ExpandedTileController controller;

  const SubtotalExpandHeader({Key? key, required this.controller})
      : super(key: key);

  @override
  State<SubtotalExpandHeader> createState() => _SubtotalExpandHeaderState();
}

class _SubtotalExpandHeaderState extends State<SubtotalExpandHeader> {
  bool? _isExpanded;

  @override
  void initState() {
    _isExpanded = widget.controller.isExpanded;
    widget.controller.addListener(onExpandStateChange);
    super.initState();
  }

  void onExpandStateChange() {
    setState(() {
      _isExpanded = widget.controller.isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Subtotal',
          style: getBoldTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        Visibility(
          visible: !_isExpanded!,
          child: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.black,
            size: AppSize.s24.rSp,
          ),
        ),
      ],
    );
  }
}
