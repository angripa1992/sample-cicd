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
          //vertical: AppSize.s4.rh,
          horizontal: AppSize.s16.rw,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                      width: 1.0, color: AppColors.lightViolet),
                  right: BorderSide(
                      width: 1.0, color: AppColors.lightViolet),
                  top: BorderSide(width: 1.0, color: AppColors.lightViolet),
                  bottom: BorderSide(width: 1.0, color: AppColors.lightViolet),
                //  bottom: BorderSide(width: 1.0, color: AppColors.lightViolet),
                ),
              ),
              child: Row(
                children: [
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
                      'Quantity',
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
            ),
            // Divider(color: AppColors.lightViolet,endIndent: 0,indent: 0,),
            Expanded(
              child: ListView.builder(
                itemCount: order.cartV2.length,
                itemBuilder: (_, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 1.0, color: AppColors.lightViolet),
                        right: BorderSide(
                            width: 1.0, color: AppColors.lightViolet),
                        top: BorderSide(width: (index == 0) ? 0 : 1.0, color: AppColors.lightViolet),
                        bottom: BorderSide(width: (order.cartV2.length == (index+1)) ? 1.0 : 0, color: AppColors.lightViolet),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ///cart item
                          _cartItemView(order.cartV2[index], order.currencySymbol,),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: order.cartV2[index].modifierGroups.map((modifiersGroupOne) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ///level 1 modifiers group
                                      _showModifierGroupName(modifiersGroupOne.name),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: modifiersGroupOne.modifiers.map((modifiersOne) {
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  ///level 1 modifiers
                                                  _modifierItemView(modifiers: modifiersOne, prevQuantity: modifiersOne.quantity, itemQuantity: order.cartV2[index].quantity),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: modifiersOne.modifierGroups.map((secondModifierGroups) {
                                                          return Column(
                                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              ///level 2 modifiers group
                                                              _showModifierGroupName(secondModifierGroups.name),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 8.0),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: secondModifierGroups.modifiers.map((secondModifier) {
                                                                      return _modifierItemView(modifiers: secondModifier, prevQuantity: secondModifier.quantity, itemQuantity: order.cartV2[index].quantity);
                                                                    },
                                                                  ).toList(),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ).toList(),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
                          ),

                          ///comment
                          _itemComment(order.cartV2[index].comment),
                        ],
                      ),
                    ),
                  );
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
          flex: 1,
          child: Text(
            textAlign: TextAlign.end,
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
            textAlign: TextAlign.end,
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
