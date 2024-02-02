import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/modifier/item_description_view.dart';
import 'package:klikit/modules/base/order_counter.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../menu/domain/entities/menu/menu_item.dart';
import 'modifier/quantity_selector.dart';
import 'modifier/speacial_instruction.dart';

class NonModifierItemDetails extends StatefulWidget {
  final MenuCategoryItem menuCategoryItem;
  final Function(int, String) addToCart;
  final VoidCallback gotoCart;

  const NonModifierItemDetails({
    Key? key,
    required this.menuCategoryItem,
    required this.addToCart,
    required this.gotoCart,
  }) : super(key: key);

  @override
  State<NonModifierItemDetails> createState() => _NonModifierItemDetailsState();
}

class _NonModifierItemDetailsState extends State<NonModifierItemDetails> {
  final _textController = TextEditingController();
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: const Text('Item Details'),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.rSp, vertical: 10.rSp),
              child: OrderCounter(
                onCartTap: () {
                  Navigator.pop(context);
                  widget.gotoCart();
                },
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ItemDescriptionView(item: widget.menuCategoryItem),
                    Divider(thickness: 8.rh, color: AppColors.grey),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.rw, vertical: 8.rh),
                      child: SpecialInstructionField(controller: _textController),
                    ),
                    Divider(thickness: 8.rh, color: AppColors.grey),
                  ],
                ),
              ),
            ),
            Divider(thickness: 1.rh, color: AppColors.grey),
            Container(
              margin: EdgeInsets.only(top: AppSize.s8.rh),
              padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw, vertical: AppSize.s8.rh),
              decoration: BoxDecoration(
                color: AppColors.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
                child: Row(
                  children: [
                    QuantitySelector(
                      quantity: _quantity,
                      onQuantityChanged: (quantity) {
                        _quantity = quantity;
                      },
                    ),
                    SizedBox(width: 16.rw),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          widget.addToCart(_quantity, _textController.text);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSize.s8.rh,
                              horizontal: AppSize.s16.rw,
                            ),
                            child: Text(
                              AppStrings.add_to_cart.tr(),
                              textAlign: TextAlign.center,
                              style: mediumTextStyle(color: AppColors.white, fontSize: 16.rSp),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
