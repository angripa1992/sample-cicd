import 'package:docket_design_template/utils/extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/common/business_information_provider.dart';
import 'package:klikit/modules/common/entities/branch.dart';
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
                  if (widget.order.vat > 0)
                    _priceBreakdownItem(
                      _vatTitle(widget.order),
                      widget.order.vat,
                    ),
                  if (widget.order.additionalFee > 0)
                    _priceBreakdownItem(
                      AppStrings.additional_fee.tr(),
                      widget.order.additionalFee,
                    ),
                  if (widget.order.restaurantServiceFee > 0)
                    _priceBreakdownItem(
                      AppStrings.restaurant_service_fee.tr(),
                      widget.order.restaurantServiceFee,
                    ),
                  if (widget.order.providerId == ProviderID.KLIKIT &&
                      widget.order.deliveryFee > 0 &&
                      (widget.order.isManualOrder || (widget.order.type == OrderType.DELIVERY && !widget.order.isThreePlOrder)))
                    _priceBreakdownItem(
                      AppStrings.delivery_fee.tr(),
                      widget.order.deliveryFee,
                    ),
                  FutureBuilder<Branch?>(
                    future: getIt.get<BusinessInformationProvider>().branchByID(SessionManager().branchId()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return _showBranchDependentFee(snapshot.data!);
                      }
                      return Container();
                    },
                  ),
                  if (widget.order.discount > 0)
                    _priceBreakdownItem(
                      '${AppStrings.discount.tr()} ${_appliedPromos(widget.order)}',
                      widget.order.discount,
                      showNegative: true,
                    ),
                  if (widget.order.rewardDiscount > 0)
                    _priceBreakdownItem(
                      'Reward',
                      widget.order.rewardDiscount,
                      showNegative: true,
                    ),
                  if (widget.order.isManualOrder && widget.order.roundOffAmount != 0)
                    _priceBreakdownItem(
                      'Rounding Off',
                      widget.order.roundOffAmount,
                      isRoundOff: true,
                    ),
                ],
              ),
            ),
            controller: _controller!,
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
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
                  PriceCalculator.convertPrice(widget.order, widget.order.finalPrice),
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

  Widget _showBranchDependentFee(Branch branch) {
    return Column(
      children: [
        if (widget.order.customFee > 0.0)
          _priceBreakdownItem(
            branch.webshopCustomFeesTitle,
            widget.order.customFee,
          ),
        if (branch.mergeFeeEnabled && widget.order.mergeFee > 0 && !widget.order.feePaidByCustomer && widget.order.providerId == ProviderID.KLIKIT)
          _priceBreakdownItem(
            branch.mergeFeeTitle,
            widget.order.mergeFee,
            showNegative: true,
          ),
        if (!branch.mergeFeeEnabled && widget.order.providerId == ProviderID.KLIKIT && widget.order.serviceFee > 0 && !widget.order.feePaidByCustomer)
          _priceBreakdownItem(
            AppStrings.service_fee.tr(),
            widget.order.serviceFee,
            showNegative: true,
          ),
        if (!branch.mergeFeeEnabled && widget.order.providerId == ProviderID.KLIKIT && widget.order.gatewayFee > 0 && !widget.order.feePaidByCustomer)
          _priceBreakdownItem(
            AppStrings.processing_fee.tr(),
            widget.order.gatewayFee,
            showNegative: true,
          ),
      ],
    );
  }

  String _appliedPromos(Order order) {
    final Set<String> promos = <String>{};
    for (var element in order.promos) {
      promos.add(element.code ?? EMPTY);
    }
    final promoStr = promos.join(', ');
    return promoStr.isEmpty ? promoStr : '($promoStr)';
  }

  String _vatTitle(Order order) {
    if (order.providerId == ProviderID.FOOD_PANDA && !order.isInterceptorOrder && !order.isVatIncluded) {
      return AppStrings.vat.tr();
    }
    return AppStrings.inc_vat.tr();
  }

  Widget _priceBreakdownItem(
    String name,
    num price, {
    bool showNegative = false,
    bool isRoundOff = false,
  }) {
    final textStyle = TextStyle(
      color: showNegative ? AppColors.red : AppColors.black,
      fontSize: AppFontSize.s14.rSp,
      fontWeight: AppFontWeight.regular,
    );
    return Padding(
      padding: EdgeInsets.only(top: AppSize.s2.rh),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: textStyle),
          Text(
            isRoundOff ? '${widget.order.currencySymbol} ${price.isNegative ? '' : '+'}${price / 100}' : '${showNegative ? '-' : ''}${PriceCalculator.convertPrice(widget.order, price)}',
            style: textStyle,
          ),
        ],
      ),
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
