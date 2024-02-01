import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/common/business_information_provider.dart';
import 'package:klikit/modules/common/entities/branch.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/resource_resolver.dart';
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
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
      child: Column(
        children: [
          AppSize.s16.verticalSpacer(),
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
              style: mediumTextStyle(
                color: AppColors.neutralB500,
                fontSize: AppFontSize.s14.rSp,
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
            child: TotalPrice(order: widget.order),
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
        /*if (branch.mergeFeeEnabled && widget.order.mergeFee > 0 && !widget.order.feePaidByCustomer && widget.order.providerId == ProviderID.KLIKIT)
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
          ),*/
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
    final textStyle = mediumTextStyle(
      color: showNegative ? AppColors.red : AppColors.neutralB200,
      fontSize: AppFontSize.s12.rSp,
    );
    return Padding(
      padding: EdgeInsets.only(top: AppSize.s2.rh),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: regularTextStyle(fontSize: AppSize.s12.rSp, color: showNegative ? AppColors.red : AppColors.neutralB600)),
          Text(
            isRoundOff ? '${widget.order.currencySymbol} ${price.isNegative ? '' : '+'}${price / 100}' : '${showNegative ? '-' : ''}${PriceCalculator.convertPrice(widget.order, price)}',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

class TotalPrice extends StatelessWidget {
  final Order order;
  final TextStyle? textStyle;

  const TotalPrice({Key? key, required this.order, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppStrings.total.tr(),
          style: textStyle ??
              mediumTextStyle(
                color: AppColors.neutralB500,
                fontSize: AppFontSize.s16.rSp,
              ),
        ),
        FutureBuilder<Branch?>(
          future: getIt<BusinessInformationProvider>().branchByID(order.branchId),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return webshopTooltip(order, snapshot.data?.mergeFeeEnabled ?? false);
            }
            return const SizedBox();
          },
        ),
        const Spacer(),
        8.horizontalSpacer(),
        Text(
          PriceCalculator.convertPrice(order, order.finalPrice),
          style: textStyle ??
              mediumTextStyle(
                color: AppColors.neutralB500,
                fontSize: AppFontSize.s16.rSp,
              ),
        ),
      ],
    );
  }

  Widget webshopTooltip(Order order, bool mergeFeesEnabled) {
    if (order.providerId == ProviderID.KLIKIT &&
        !order.isManualOrder &&
        ((!order.gatewayFeePaidByCustomer && order.gatewayFee == 1) ||
            (!order.serviceFeePaidByCustomer && order.serviceFee == 1) ||
            (!order.feePaidByCustomer && (order.serviceFee == 1 || order.gatewayFee == 1 || mergeFeesEnabled)))) {
      String msg = 'Total fee includes processing fee and service fee';

      if ((!order.gatewayFeePaidByCustomer && order.serviceFeePaidByCustomer) || (order.gatewayFee == 1 && order.serviceFee != 1)) {
        msg = 'Total fee includes processing fee';
      } else if ((order.gatewayFeePaidByCustomer && !order.serviceFeePaidByCustomer) || (order.gatewayFee != 1 && order.serviceFee == 1)) {
        msg = 'Total fee includes service fee';
      }

      return Tooltip(
        message: msg,
        child: ImageResourceResolver.infoSVG.getImageWidget(width: AppSize.s16.rw, height: AppSize.s16.rh),
      ).setVisibilityWithSpace(direction: Axis.horizontal, startSpace: 8.rw);
    }
    return const SizedBox();
  }
}

class SubtotalExpandHeader extends StatefulWidget {
  final ExpandedTileController controller;

  const SubtotalExpandHeader({Key? key, required this.controller}) : super(key: key);

  @override
  State<SubtotalExpandHeader> createState() => _SubtotalExpandHeaderState();
}

class _SubtotalExpandHeaderState extends State<SubtotalExpandHeader> {
  late bool _isExpanded;

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
          style: mediumTextStyle(
            color: AppColors.neutralB500,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        Icon(
          _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: AppColors.neutralB500,
          size: AppSize.s18.rSp,
        ),
      ],
    );
  }
}
