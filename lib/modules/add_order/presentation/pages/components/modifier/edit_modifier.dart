import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/modifier/speacial_instruction.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';
import 'package:klikit/modules/base/order_counter.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../common/entities/brand.dart';
import '../../../../../menu/domain/entities/item_price.dart';
import '../../../../../menu/domain/entities/menu/menu_item.dart';
import '../../../../domain/entities/add_to_cart_item.dart';
import '../../../../domain/entities/modifier/item_modifier_group.dart';
import '../../../../utils/modifier_manager.dart';
import 'add_to_cart_button_view.dart';
import 'item_description_view.dart';
import 'level_one_select_multiple_view.dart';
import 'level_one_select_one_view.dart';
import 'modifier_group_info.dart';

class EditModifierView extends StatefulWidget {
  final AddToCartItem cartItem;
  final Function(AddToCartItem?) onClose;
  final VoidCallback onAddAsNew;
  final VoidCallback onCartTap;

  const EditModifierView({
    Key? key,
    required this.onClose,
    required this.onCartTap,
    required this.cartItem,
    required this.onAddAsNew,
  }) : super(key: key);

  @override
  State<EditModifierView> createState() => _EditModifierViewState();
}

class _EditModifierViewState extends State<EditModifierView> {
  final _textEditingController = TextEditingController();
  final _enabled = ValueNotifier<bool>(true);
  final _price = ValueNotifier<num>(0);
  late List<MenuItemModifierGroup> _groups;
  late MenuCategoryItem _item;
  late Brand? _brand;
  late ItemPrice _itemPrice;
  late num _modifierPrice;
  late int _quantity;

  @override
  void initState() {
    final cartItem = widget.cartItem;
    _groups = cartItem.modifiers;
    _item = cartItem.item;
    _brand = cartItem.brand;
    _itemPrice = cartItem.itemPrice;
    _modifierPrice = cartItem.modifiersPrice;
    _quantity = cartItem.quantity;
    _changePrice();
    _textEditingController.text = cartItem.itemInstruction;
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _price.dispose();
    _enabled.dispose();
    super.dispose();
  }

  void _onChanged() async {
    final validated = await ModifierManager().verifyRules(_groups);
    _modifierPrice = await ModifierManager().calculateModifiersPrice(_groups);
    if (_enabled.value != validated) {
      _enabled.value = validated;
    }
    _changePrice();
  }

  void _onQuantityChanged(int quantity) {
    _quantity = quantity;
    _changePrice();
  }

  void _changePrice() {
    final totalPrice = (_modifierPrice + _itemPrice.advancePrice(CartManager().orderType)) * _quantity;
    if (_price.value != totalPrice) {
      _price.value = totalPrice;
    }
  }

  AddToCartItem _createCartItem() {
    return AddToCartItem(
      modifiers: _groups,
      item: _item,
      quantity: _quantity,
      itemInstruction: _textEditingController.text,
      modifiersPrice: _modifierPrice,
      itemPrice: _itemPrice,
      brand: _brand!,
      discountType: DiscountType.flat,
      discountValue: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: const Text('Item Details'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onClose(null);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.rSp, vertical: 10.rSp),
              child: OrderCounter(
                onCartTap: () {
                  Navigator.pop(context);
                  widget.onCartTap();
                },
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ItemDescriptionView(item: _item),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.rh, horizontal: 12.rw),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onAddAsNew();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primary),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: AppColors.primary),
                            Text(
                              AppStrings.add_as_new.tr(),
                              style: mediumTextStyle(color: AppColors.primary, fontSize: 14.rSp),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(thickness: 8.rh, color: AppColors.grey),
                    Column(
                      children: _groups.map((group) {
                        return Column(
                          children: [
                            ModifierGroupInfo(
                              title: group.title,
                              rule: group.rule,
                            ),
                            ((group.rule.min == group.rule.max) && group.rule.max == 1)
                                ? LevelOneSelectOneView(
                                    modifiers: group.modifiers,
                                    onChanged: _onChanged,
                                  )
                                : LevelOneSelectMultipleView(
                                    modifiers: group.modifiers,
                                    onChanged: _onChanged,
                                  ),
                          ],
                        );
                      }).toList(),
                    ),
                    if (_groups.isNotEmpty) Divider(thickness: 8.rh, color: AppColors.grey),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.rh, horizontal: 12.rw),
                      child: SpecialInstructionField(controller: _textEditingController),
                    ),
                    Divider(thickness: 8.rh, color: AppColors.grey),
                  ],
                ),
              ),
            ),
            AddToCartButtonView(
              enabled: _enabled,
              price: _price,
              quantity: _quantity,
              currencyCode: _itemPrice.currencyCode,
              currencySymbol: _itemPrice.currencySymbol,
              onQuantityChanged: _onQuantityChanged,
              onAddToCart: () {
                Navigator.of(context).pop();
                widget.onClose(_createCartItem());
              },
            ),
          ],
        ),
      ),
    );
  }
}
