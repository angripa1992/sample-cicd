import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/cart.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../core/utils/price_calculator.dart';
import '../../../../../../resources/styles.dart';

class OrderItemDetails extends StatelessWidget {
  final Order order;

  OrderItemDetails({Key? key, required this.order}) : super(key: key);

  final _tableHeaderStyle = getMediumTextStyle(
    color: AppColors.black,
    fontSize: AppFontSize.s14.rSp,
  );

  final _itemTextStyle = getMediumTextStyle(
    color: AppColors.purpleBlue,
    fontSize: AppFontSize.s14.rSp,
  );

  final _modifiersTextStyle = getRegularTextStyle(
    color: AppColors.blueViolet,
    fontSize: AppFontSize.s14.rSp,
  );

  final _modifiersItemTextStyle = getRegularTextStyle(
    color: AppColors.blueViolet,
    fontSize: AppFontSize.s14.rSp,
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.s4.rh,
          horizontal: AppSize.s16.rw,
        ),
        child: Column(
          children: [
            Row(
              children:  [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Items',
                   // textAlign: TextAlign.start,
                    style: _tableHeaderStyle,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Qty',
                    textAlign: TextAlign.center,
                    style: _tableHeaderStyle,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Total Price',
                    textAlign: TextAlign.center,
                    style: _tableHeaderStyle,
                  ),
                ),
              ],
            ),
            Divider(color: AppColors.lightViolet),
            Expanded(
              child: ListView.separated(
                itemCount: order.cartV2.length,
                itemBuilder: (_, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 1.0, color: Colors.lightBlue.shade600),
                        right: BorderSide(width: 1.0, color: Colors.lightBlue.shade900),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ///cart item
                        _cartItemView(
                          order.cartV2[index],
                          order.currencySymbol,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: order.cartV2[index].modifierGroups.map(
                            (modifiersGroup) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ///level 1 modifiers group
                                  _showModifierGroupName(modifiersGroup.name),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: modifiersGroup.modifiers.map(
                                      (modifiers) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ///level 1 modifiers
                                            _modifierItemView(
                                                modifiers: modifiers,
                                                prevQuantity: modifiers.quantity,
                                                itemQuantity:
                                                    order.cartV2[index].quantity),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children:
                                                  modifiers.modifierGroups.map(
                                                (modifierGroups) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      ///level 2 modifiers group
                                                      _showModifierGroupName(
                                                          modifiersGroup.name),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: modifierGroups
                                                            .modifiers
                                                            .map(
                                                          (secondModifier) {
                                                            return _modifierItemView(
                                                                modifiers:
                                                                    secondModifier,
                                                                prevQuantity:
                                                                    secondModifier
                                                                        .quantity,
                                                                itemQuantity: order
                                                                    .cartV2[index]
                                                                    .quantity);
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
                        _itemComment(order.cartV2[index].comment),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: AppColors.lightViolet);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartItemView(CartV2 cartV2, String currencySymbol) {
    return Row(
      children: [
        // Text('${cartV2.quantity}x', style: _itemTextStyle),
        // SizedBox(width: AppSize.s8.rw),
        Expanded(
          flex: 3,
          child: Text(cartV2.name, style: _itemTextStyle),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '${cartV2.quantity}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: AppFontWeight.bold,
              fontSize: AppFontSize.s14.rSp,
              color: AppColors.black,
            ),
          ),
        ),
        Expanded(
          child: Text(
            textAlign: TextAlign.center,
            '$currencySymbol${PriceCalculator.calculateItemPrice(order, cartV2)}',
            style: TextStyle(
              fontWeight: AppFontWeight.bold,
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
  }) {
    return Row(
      children: [
        // Text('• ${modifiers.quantity}x', style: _modifiersItemTextStyle),
        // SizedBox(width: AppSize.s8.rw),
        Expanded(
          flex: 3,
          child: Text(modifiers.name, style: _modifiersItemTextStyle),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '${modifiers.quantity}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: AppFontWeight.bold,
              fontSize: AppFontSize.s14.rSp,
              color: AppColors.black,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '${order.currencySymbol}${PriceCalculator.calculateModifierPrice(order, modifiers, prevQuantity, itemQuantity)}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: AppFontWeight.bold,
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

  Widget _showModifierGroupName(String name) {
    if (name.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
      child: Text(
        name,
        style: _modifiersTextStyle,
      ),
    );
  }
}
