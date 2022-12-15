import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/cart.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../resources/styles.dart';

class OrderItemDetails extends StatelessWidget {
  final Order order;

  OrderItemDetails({Key? key, required this.order})
      : super(key: key);

  final _itemTextStyle = getMediumTextStyle(
    color: AppColors.black,
    fontSize: AppFontSize.s16.rSp,
  );
  final _modifiersTextStyle = getRegularTextStyle(
    color: AppColors.black,
    fontSize: AppFontSize.s16.rSp,
  );

  final _modifiersItemTextStyle = getRegularTextStyle(
    color: AppColors.blackCow,
    fontSize: AppFontSize.s16.rSp,
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s18.rw,
          vertical: AppSize.s4.rh,
        ),
        child: ListView.builder(
          //controller: controller,
          itemCount: order.cartV2.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppSize.s8.rh),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ///cart item
                  _cartItemView(order.cartV2[index], order.currencySymbol),
                  Padding(
                    padding: EdgeInsets.only(left: AppSize.s32.rw, top: AppSize.s4.rh,bottom: AppSize.s4.rh),
                    child: Column(
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: modifiersGroup.modifiers.map((modifiers) {
                                    return Padding(
                                      padding: EdgeInsets.only(left: AppSize.s8.rw, top: AppSize.s2.rh,bottom: AppSize.s2.rh),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          ///level 1 modifiers
                                          _modifierItemView(modifiers: modifiers,prevQuantity: modifiers.quantity,itemQuantity: order.cartV2[index].quantity),
                                          Padding(
                                            padding: EdgeInsets.only(left: AppSize.s8.rw),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: modifiers.modifierGroups.map((modifierGroups) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(left: AppSize.s8.rw, top: AppSize.s4.rh,bottom: AppSize.s4.rh),
                                                    child: Column(
                                                      crossAxisAlignment:CrossAxisAlignment.stretch,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        ///level 2 modifiers group
                                                        _showModifierGroupName(modifiersGroup.name),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: modifierGroups.modifiers.map((secondModifier) {
                                                              return Padding(
                                                                padding: EdgeInsets.only(left: AppSize.s8.rw),
                                                                ///level 2 modifiers
                                                                child: _modifierItemView(modifiers: secondModifier,prevQuantity: secondModifier.quantity,itemQuantity: order.cartV2[index].quantity),
                                                              );
                                                            },
                                                          ).toList(),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ).toList(),
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
            );
          },
        ),
      ),
    );
  }


  Widget _cartItemView(CartV2 cartV2, String currencySymbol) {
    return Row(
      children: [
        Text('${cartV2.quantity}x', style: _itemTextStyle),
        SizedBox(width: AppSize.s8.rw),
        Expanded(child: Text(cartV2.name, style: _itemTextStyle)),
        SizedBox(width: AppSize.s12.rw),
        Text(
          '$currencySymbol${getItemPrice(cartV2)}',
          style: TextStyle(
            fontWeight: AppFontWeight.bold,
            fontSize: AppFontSize.s16.rSp,
            color: AppColors.black,
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
        Text('• ${modifiers.quantity}x', style: _modifiersItemTextStyle),
        SizedBox(width: AppSize.s8.rw),
        Expanded(child: Text(modifiers.name, style: _modifiersItemTextStyle)),
        SizedBox(width: AppSize.s8.rw),
        Text(
          '${order.currencySymbol}${getModifierPrice(modifiers, prevQuantity, itemQuantity)}',
          style: TextStyle(
            fontWeight: AppFontWeight.regular,
            fontSize: AppFontSize.s16.rSp,
            color: AppColors.blackCow,
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
            'Note: $comment',
            style: getBoldTextStyle(
              color: AppColors.blueViolet,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _showModifierGroupName(String name){
    if(name.isEmpty){
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

  String getModifierPrice(
      Modifiers modifiers, int prevQuantity, int itemQuantity) {
    if (!order.isInterceptorOrder &&
        order.providerId != ProviderID.FOOD_PANDA) {
      double unitPrice = double.parse(modifiers.unitPrice);
      double modifierTotalPrice =
          unitPrice * modifiers.quantity * prevQuantity * itemQuantity;
      return modifierTotalPrice.toString();
    }
    return modifiers.price;
  }

  String getItemPrice(CartV2 cartV2) {
    if (!order.isInterceptorOrder &&
        order.providerId != ProviderID.FOOD_PANDA) {
      double unitPrice = double.parse(cartV2.unitPrice);
      double itemTotalPrice = unitPrice * cartV2.quantity;
      return itemTotalPrice.toString();
    }
    return cartV2.price;
  }
}
