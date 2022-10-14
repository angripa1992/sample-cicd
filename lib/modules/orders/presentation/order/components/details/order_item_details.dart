import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/cart.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../resources/styles.dart';

class OrderItemDetails extends StatelessWidget {
  final Order order;
  final ScrollController controller;

  OrderItemDetails({Key? key, required this.order, required this.controller})
      : super(key: key);

  final _itemTextStyle = getRegularTextStyle(
    color: AppColors.blueViolet,
    fontSize: AppFontSize.s16.rSp,
  );
  final _modifiersTextStyle = getRegularTextStyle(
    color: AppColors.lightViolet,
    fontSize: AppFontSize.s16.rSp,
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s18.rw,
          vertical: AppSize.s14.rh,
        ),
        child: ListView.builder(
          controller: controller,
          itemCount: order.cartV2.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppSize.s16.rh),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ///cart item
                  _cartItemView(order.cartV2[index], order.currencySymbol),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.s32.rw,
                      vertical: AppSize.s8.rh,
                    ),
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
                              Text(
                                '• ${modifiersGroup.name}',
                                style: _itemTextStyle,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppSize.s8.rw),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: modifiersGroup.modifiers.map(
                                    (modifiers) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppSize.s8.rw,
                                          vertical: AppSize.s2.rh,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ///level 1 modifiers
                                            _modifierItemView(modifiers),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: AppSize.s8.rw,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: modifiers
                                                    .modifierGroups
                                                    .map(
                                                  (modifierGroups) {
                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal:
                                                            AppSize.s8.rw,
                                                        vertical: AppSize.s8.rh,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          ///level 2 modifiers group
                                                          Text(
                                                            '• ${modifierGroups.name}',
                                                            style:
                                                                _itemTextStyle,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal:
                                                                  AppSize.s8.rw,
                                                              vertical:
                                                                  AppSize.s2.rh,
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children:
                                                                  modifierGroups
                                                                      .modifiers
                                                                      .map(
                                                                (modifiers) {
                                                                  return Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          AppSize
                                                                              .s8
                                                                              .rw,
                                                                    ),

                                                                    ///level 2 modifiers
                                                                    child: _modifierItemView(
                                                                        modifiers),
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
                                            ),
                                          ],
                                        ),
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
        Text(cartV2.name, style: _itemTextStyle),
        const Spacer(),
        Text(
          '$currencySymbol${cartV2.price}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
      ],
    );
  }

  Widget _modifierItemView(Modifiers modifiers) {
    return Row(
      children: [
        Text('${modifiers.quantity}x', style: _modifiersTextStyle),
        SizedBox(width: AppSize.s12.rw),
        Text(modifiers.name, style: _modifiersTextStyle),
      ],
    );
  }
}
