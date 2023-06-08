import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/cart.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../core/utils/price_calculator.dart';
import '../../../../../../resources/styles.dart';
import '../../../../widgets/image_view.dart';
import '../../../domain/entities/brand.dart';

class OrderItemDetails extends StatelessWidget {
  final Order order;

  OrderItemDetails({Key? key, required this.order}) : super(key: key);

  final _itemTextStyle = getMediumTextStyle(
    color: AppColors.darkGrey,
    fontSize: AppFontSize.s14.rSp,
  );

  final _modifiersTextStyle = getRegularTextStyle(
    color: AppColors.smokeyGrey,
    fontSize: AppFontSize.s14.rSp,
  );

  final _modifiersItemTextStyle = getRegularTextStyle(
    color: AppColors.smokeyGrey,
    fontSize: AppFontSize.s14.rSp,
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
    return Expanded(
      child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s16.rw,
          ),
          child: FutureBuilder<Map<int, List<CartV2>>>(
            future: _filterOrder(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final cartsMap = snapshot.data!;
                return ListView.builder(
                  itemCount: order.brands.length,
                  itemBuilder: (_, brandIndex) {
                    final cartBrand = order.brands[brandIndex];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                          child: _brandView(cartBrand),
                        ),
                        ListView.builder(
                          itemCount: cartsMap[cartBrand.id]?.length ?? ZERO,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            CartV2 cart = cartsMap[cartBrand.id]![index];
                            return Padding(
                              padding: EdgeInsets.only(
                                top: AppSize.s4.rh,
                                bottom: AppSize.s4.rh,
                                left: AppSize.s4.rw,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ///cart item
                                  _cartItemView(
                                    cartV2: cart,
                                    currencySymbol: order.currencySymbol,
                                    paddingLevel: 1,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: cart.modifierGroups.map(
                                      (modifiersGroupOne) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ///level 1 modifiers group
                                            _showModifierGroupName(
                                              name: modifiersGroupOne.name,
                                              paddingLevel: 2,
                                            ),
                                            Column(
                                              children: modifiersGroupOne
                                                  .modifiers
                                                  .map(
                                                (modifiersOne) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      ///level 1 modifiers
                                                      _modifierItemView(
                                                        modifiers: modifiersOne,
                                                        prevQuantity:
                                                            modifiersOne
                                                                .quantity,
                                                        itemQuantity:
                                                            cart.quantity,
                                                        paddingLevel: 3,
                                                      ),
                                                      Column(
                                                        children: modifiersOne
                                                            .modifierGroups
                                                            .map(
                                                          (secondModifierGroups) {
                                                            return Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                ///level 2 modifiers group
                                                                _showModifierGroupName(
                                                                  name:
                                                                      secondModifierGroups
                                                                          .name,
                                                                  paddingLevel:
                                                                      4,
                                                                ),
                                                                Column(
                                                                  children:
                                                                      secondModifierGroups
                                                                          .modifiers
                                                                          .map(
                                                                    (secondModifier) {
                                                                      return _modifierItemView(
                                                                        modifiers:
                                                                            secondModifier,
                                                                        prevQuantity:
                                                                            secondModifier.quantity,
                                                                        itemQuantity:
                                                                            cart.quantity,
                                                                        paddingLevel:
                                                                            5,
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
                                          ],
                                        );
                                      },
                                    ).toList(),
                                  ),

                                  ///comment
                                  _itemComment(cart.comment),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              return const CircularProgressIndicator();
            },
          )),
    );
  }

  Widget _brandView(CartBrand cartBrand) {
    return Row(
      children: [
        ImageView(
          path: cartBrand.logo,
          height: AppSize.s32.rh,
          width: AppSize.s36.rw,
        ),
        SizedBox(width: AppSize.s12.rw),
        Flexible(
          child: Text(
            cartBrand.title,
            style: getBoldTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _cartItemView({
    required CartV2 cartV2,
    required String currencySymbol,
    required int paddingLevel,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Text('${cartV2.quantity} x', style: _itemTextStyle),
              SizedBox(width: AppSize.s4.rw),
              Expanded(child: Text(cartV2.name, style: _itemTextStyle)),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            textAlign: TextAlign.end,
            PriceCalculator.calculateItemPrice(order, cartV2),
            style: TextStyle(
              fontWeight: AppFontWeight.regular,
              fontSize: AppFontSize.s14.rSp,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _modifierItemView({
    required Modifiers modifiers,
    required int prevQuantity,
    required int itemQuantity,
    required int paddingLevel,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(left: (AppSize.s8.rw * paddingLevel)),
            child: Row(
              children: [
                Text('${modifiers.quantity} x', style: _modifiersItemTextStyle),
                SizedBox(width: AppSize.s4.rw),
                Expanded(
                    child:
                        Text(modifiers.name, style: _modifiersItemTextStyle)),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            PriceCalculator.calculateModifierPrice(
                order, modifiers, prevQuantity, itemQuantity),
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: AppFontWeight.regular,
              fontSize: AppFontSize.s14.rSp,
              color: AppColors.black,
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
        padding: EdgeInsets.symmetric(
          vertical: AppSize.s2.rh,
        ),
        child: Center(
          child: Text(
            '${AppStrings.note.tr()}: $comment',
            style: getBoldTextStyle(
              color: AppColors.blueViolet,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _showModifierGroupName(
      {required String name, required int paddingLevel}) {
    if (name.isEmpty) {
      return const SizedBox();
    }
    return Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.s4.rh,
          horizontal: (AppSize.s8.rw * paddingLevel),
        ),
        child: Text(
          name,
          style: _modifiersTextStyle,
        ));
  }
}
