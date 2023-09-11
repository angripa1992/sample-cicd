import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../../core/utils/price_calculator.dart';
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
    _controller = ExpandedTileController(isExpanded: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWebshopOrder = widget.order.providerId == ProviderID.KLIKIT && !widget.order.isManualOrder;
    final isManualOrderOrder = widget.order.providerId == ProviderID.KLIKIT && widget.order.isManualOrder;
    final serviceFee = widget.order.serviceFee;
    final gateWayFee = widget.order.gatewayFee;
    final willShowServiceFee = (isWebshopOrder && serviceFee > 0 && gateWayFee > 0) || (isManualOrderOrder && serviceFee > 0);
    final willShowProcessingFee = (isWebshopOrder && serviceFee > 0 && gateWayFee > 0);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
      child: Column(
        children: [
          const Divider(),
          ExpandedTile(
            theme: ExpandedTileThemeData(
              headerColor: Colors.transparent,
              headerPadding: EdgeInsets.zero,
              leadingPadding: EdgeInsets.zero,
              trailingPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              headerSplashColor: AppColors.greyLight,
              contentBackgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
            ),
            trailing: Text(
              PriceCalculator.calculateSubtotal(widget.order),
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
              ),
              child: Column(
                children: [
                  _getSubtotalItem(
                    _vatTitle(widget.order),
                    widget.order.vat,
                  ),
                  SizedBox(height: AppSize.s2.rh),
                  _getSubtotalItem(
                    AppStrings.delivery_fee.tr(),
                    widget.order.deliveryFee,
                  ),
                  SizedBox(height: AppSize.s2.rh),
                  _getSubtotalItem(
                    AppStrings.additional_fee.tr(),
                    widget.order.additionalFee,
                  ),
                  if (willShowServiceFee) SizedBox(height: AppSize.s2.rh),
                  if (willShowServiceFee) _getSubtotalItem('Service Fee', serviceFee),
                  if (willShowProcessingFee) SizedBox(height: AppSize.s2.rh),
                  if (willShowProcessingFee) _getSubtotalItem('Processing Fee', gateWayFee),
                  if (widget.order.restaurantServiceFee > 0) SizedBox(height: AppSize.s2.rh),
                  if (widget.order.restaurantServiceFee > 0) _getSubtotalItem('Restaurant Service Fee', widget.order.restaurantServiceFee),
                  SizedBox(height: AppSize.s2.rh),
                  _getSubtotalItem(
                    '${AppStrings.discount.tr()} (${_appliedPromos(widget.order)})',
                    widget.order.discount,
                    color: AppColors.red,
                    isDiscount: true,
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
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.total.tr(),
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.s18.rSp,
                    fontWeight: AppFontWeight.bold,
                  ),
                ),
                Text(
                  PriceCalculator.convertPrice(
                    widget.order,
                    widget.order.finalPrice,
                  ),
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.s18.rSp,
                    fontWeight: AppFontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _appliedPromos(Order order) {
    final Set<String> promos = <String>{};
    for (var element in order.appliedPromos) {
      promos.add(element.code);
    }
    return promos.join(', ');
  }

  String _vatTitle(Order order) {
    if (order.providerId == ProviderID.FOOD_PANDA && !order.isInterceptorOrder && !order.isVatIncluded) {
      return AppStrings.vat.tr();
    }
    return AppStrings.inc_vat.tr();
  }

  Widget _getSubtotalItem(
    String name,
    num price, {
    Color? color,
    bool isDiscount = false,
  }) {
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
          '${isDiscount ? '-' : ''}${PriceCalculator.convertPrice(
            widget.order,
            price,
          )}',
          style: textStyle,
        ),
      ],
    );
  }
}

class SubtotalExpandHeader extends StatefulWidget {
  final ExpandedTileController controller;

  const SubtotalExpandHeader({Key? key, required this.controller}) : super(key: key);

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
          AppStrings.sub_total.tr(),
          style: boldTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        Icon(
          _isExpanded! ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: AppColors.black,
          size: AppSize.s24.rSp,
        ),
      ],
    );
  }
}
