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
        child: ListView.separated(
          itemCount: order.cartV2.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppSize.s8.rh),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ///cart item
                  _cartItemView(
                    order.cartV2[index],
                    order.currencySymbol,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppSize.s32.rw,
                      top: AppSize.s4.rh,
                      bottom: AppSize.s4.rh,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: order.cartV2[index].modifierGroups.map(
                        (firstModifiersGroup) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ///level 1 modifiers group
                              _showModifierGroupName(firstModifiersGroup.name),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: firstModifiersGroup.modifiers.map(
                                  (firstModifiers) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: AppSize.s8.rw,
                                          top: AppSize.s2.rh,
                                          bottom: AppSize.s2.rh),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ///level 1 modifiers
                                          _modifierItemView(
                                              modifiers: firstModifiers,
                                              prevQuantity:
                                                  firstModifiers.quantity,
                                              itemQuantity:
                                                  order.cartV2[index].quantity),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: AppSize.s8.rw),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: firstModifiers
                                                  .modifierGroups
                                                  .map(
                                                (secondModifierGroups) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        left: AppSize.s8.rw,
                                                        top: AppSize.s4.rh,
                                                        bottom: AppSize.s4.rh),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        ///level 2 modifiers group
                                                        _showModifierGroupName(
                                                            secondModifierGroups
                                                                .name),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children:
                                                              secondModifierGroups
                                                                  .modifiers
                                                                  .map(
                                                            (secondModifier) {
                                                              return Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: AppSize
                                                                            .s8
                                                                            .rw),

                                                                ///level 2 modifiers
                                                                child: _modifierItemView(
                                                                    modifiers:
                                                                        secondModifier,
                                                                    prevQuantity:
                                                                        secondModifier
                                                                            .quantity,
                                                                    itemQuantity: order
                                                                        .cartV2[
                                                                            index]
                                                                        .quantity),
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
          separatorBuilder: (BuildContext context, int index) {
            return Divider(color: AppColors.lightViolet);
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
          '$currencySymbol${PriceCalculator.calculateItemPrice(order, cartV2)}',
          style: TextStyle(
            fontWeight: AppFontWeight.bold,
            fontSize: AppFontSize.s14.rSp,
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
          '${order.currencySymbol}${PriceCalculator.calculateModifierPrice(order, modifiers, prevQuantity, itemQuantity)}',
          style: TextStyle(
            fontWeight: AppFontWeight.regular,
            fontSize: AppFontSize.s14.rSp,
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
