import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/core/widgets/decorated_image_view.dart';
import 'package:klikit/core/widgets/kt_chip.dart';
import 'package:klikit/core/widgets/kt_network_image.dart';
import 'package:klikit/modules/orders/domain/entities/cart.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../core/utils/price_calculator.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../app/app_preferences.dart';
import '../../../../../printer/printer_manager.dart';
import '../../../../common/entities/brand.dart';

class OrderItemDetails extends StatelessWidget {
  final _printerSetting = getIt.get<AppPreferences>().printerSetting();
  final Order order;

  OrderItemDetails({Key? key, required this.order}) : super(key: key);

  final _itemTextStyle = mediumTextStyle(
    color: AppColors.neutralB500,
    fontSize: AppFontSize.s14.rSp,
  );

  final _modifiersTextStyle = regularTextStyle(
    color: AppColors.neutralB200,
    fontSize: AppFontSize.s12.rSp,
  );

  final _modifiersItemTextStyle = regularTextStyle(
    color: AppColors.neutralB200,
    fontSize: AppFontSize.s12.rSp,
  );

  Future<Map<int, List<CartV2>>> _filterOrder() async {
    Map<int, List<CartV2>> filteredOrders = {};
    for (var cart in order.cartV2) {
      if (filteredOrders.containsKey(cart.cartBrand.id)) {
        List<CartV2> carts = filteredOrders[cart.cartBrand.id]!;
        carts.add(cart);
        filteredOrders[cart.cartBrand.id] = carts;
      } else {
        List<CartV2> carts = [];
        carts.add(cart);
        filteredOrders[cart.cartBrand.id] = carts;
      }
    }
    return filteredOrders;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.white,
        padding: EdgeInsets.only(
          left: AppSize.s16.rw,
          right: AppSize.s16.rw,
          bottom: AppSize.s8.rw,
        ),
        child: FutureBuilder<Map<int, List<CartV2>>>(
          future: _filterOrder(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final cartsMap = snapshot.data!;
              return ListView.separated(
                itemCount: order.brands.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: AppSize.s16.rh),
                itemBuilder: (_, brandIndex) {
                  final cartBrand = order.brands[brandIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _brandView(cartBrand, cartsMap[cartBrand.id]?.length ?? ZERO),
                      AppSize.s16.verticalSpacer(),
                      ListView.separated(
                        itemCount: cartsMap[cartBrand.id]?.length ?? ZERO,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index) {
                          CartV2 cart = cartsMap[cartBrand.id]![index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ///cart item
                              _cartItemView(cartV2: cart, currencySymbol: order.currencySymbol, paddingLevel: 1),
                              Visibility(visible: cart.modifierGroups.isNotEmpty, child: const Divider()),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: cart.modifierGroups.map(
                                  (modifiersGroupOne) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        ///level 1 modifiers group
                                        _showModifierGroupName(name: modifiersGroupOne.name, paddingLevel: 2),
                                        Column(
                                          children: modifiersGroupOne.modifiers.map(
                                            (modifiersOne) {
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  ///level 1 modifiers
                                                  _modifierItemView(modifiers: modifiersOne, prevQuantity: 1, itemQuantity: cart.quantity, paddingLevel: 3),
                                                  Column(
                                                    children: modifiersOne.modifierGroups.map(
                                                      (secondModifierGroups) {
                                                        return Column(
                                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            ///level 2 modifiers group
                                                            _showModifierGroupName(name: secondModifierGroups.name, paddingLevel: 4),
                                                            Column(
                                                              children: secondModifierGroups.modifiers.map(
                                                                (secondModifier) {
                                                                  return _modifierItemView(modifiers: secondModifier, prevQuantity: modifiersOne.quantity, itemQuantity: cart.quantity, paddingLevel: 5)
                                                                      .setVisibilityWithSpace(direction: Axis.vertical, endSpace: AppSize.s4);
                                                                },
                                                              ).toList(),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ).toList(),
                                                  ),
                                                ],
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ],
                                    );
                                  },
                                ).toList(),
                              ),

                              ///comment
                              _itemComment(cart.comment),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return AppSize.s16.verticalSpacer();
                        },
                      ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return AppSize.s24.verticalSpacer();
                },
              );
            }
            return const CircularProgressIndicator();
          },
        )).setVisibilityWithSpace(direction: Axis.vertical, startSpace: AppSize.s8);
  }

  Widget _brandView(CartBrand cartBrand, int itemCount) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        KTNetworkImage(
          imageUrl: cartBrand.logo,
          width: AppSize.s28.rw,
          height: AppSize.s28.rh,
          imageBorderWidth: 0,
        ),
        AppSize.s8.horizontalSpacer(),
        Flexible(
          child: Text(
            cartBrand.title.trim(),
            style: semiBoldTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
        AppSize.s8.horizontalSpacer(),
        KTChip(
          text: '$itemCount ${itemCount > 1 ? 'items' : 'item'}',
          backgroundColor: AppColors.neutralB20,
          textStyle: regularTextStyle(fontSize: 10),
          padding: EdgeInsets.symmetric(horizontal: 8.rw, vertical: 2.rh),
        ),
      ],
    );
  }

  Widget _cartItemView({required CartV2 cartV2, required String currencySymbol, required int paddingLevel}) {
    return Row(
      children: [
        Flexible(
          child: Row(
            children: [
              Visibility(
                visible: (_printerSetting.stickerPrinterEnabled && !UserPermissionManager().isBizOwner()),
                child: DecoratedImageView(
                  iconWidget: ImageResourceResolver.printerSVG.getImageWidget(width: AppSize.s14.rw, height: AppSize.s14.rh, color: AppColors.primaryP300),
                  padding: EdgeInsets.all(AppSize.s10.rSp),
                  decoration: BoxDecoration(
                    color: AppColors.primaryP50,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppSize.s4.rSp),
                    ),
                  ),
                  onTap: () {
                    getIt.get<PrinterManager>().printSticker(order, cartV2);
                  },
                ).setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s8),
              ),
              Text('${cartV2.quantity} x ', style: _itemTextStyle),
              SizedBox(width: AppSize.s4.rw),
              Expanded(child: Text(cartV2.name.trim(), style: _itemTextStyle)),
            ],
          ),
        ),
        SizedBox(width: AppSize.s4.rw),
        Text(
          PriceCalculator.calculateItemPrice(order, cartV2),
          textAlign: TextAlign.end,
          style: TextStyle(
            fontWeight: AppFontWeight.regular,
            fontSize: AppFontSize.s14.rSp,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  Widget _modifierItemView({required Modifiers modifiers, required int prevQuantity, required int itemQuantity, required int paddingLevel}) {
    final modifierPrice = PriceCalculator.calculateModifierPrice(
      order,
      modifiers,
      prevQuantity,
      itemQuantity,
    );
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(left: (AppSize.s4.rw * paddingLevel)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('•  ${modifiers.quantity} x', style: _modifiersItemTextStyle),
                SizedBox(width: AppSize.s4.rw),
                Expanded(child: Text(modifiers.name, style: _modifiersItemTextStyle)),
              ],
            ),
          ),
        ),
        if (modifierPrice > 0 && order.providerId != ProviderID.FOOD_PANDA)
          Expanded(
            flex: 2,
            child: Text(
              PriceCalculator.formatPrice(
                price: modifierPrice,
                code: order.currency,
                symbol: order.currencySymbol,
              ),
              textAlign: TextAlign.end,
              style: mediumTextStyle(
                fontSize: AppFontSize.s12.rSp,
                color: AppColors.neutralB200,
              ),
            ),
          ),
      ],
    );
  }

  Widget _itemComment(String comment) {
    return Visibility(
      visible: comment.isNotEmpty,
      child: Padding(
        padding: EdgeInsets.only(
          top: AppSize.s8.rh,
          left: AppSize.s8.rw,
        ),
        child: Row(
          children: [
            ImageResourceResolver.noteSVG.getImageWidget(width: AppSize.s12.rw, height: AppSize.s12.rh, color: AppColors.neutralB300),
            SizedBox(width: AppSize.s4.rw),
            Expanded(
              child: Text(
                comment,
                style: regularTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showModifierGroupName({required String name, required int paddingLevel}) {
    return Visibility(
      visible: name.isNotEmpty,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: paddingLevel == 4 ? (AppSize.s2.rw * paddingLevel) : 0,
        ),
        child: Text(
          name.trim(),
          style: _modifiersTextStyle,
        ),
      ),
    );
  }
}
