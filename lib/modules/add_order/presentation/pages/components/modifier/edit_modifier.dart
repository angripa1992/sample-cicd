import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/modifier/speacial_instruction.dart';
import 'package:klikit/modules/menu/domain/entities/brand.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../menu/domain/entities/items.dart';
import '../../../../../menu/domain/entities/price.dart';
import '../../../../domain/entities/add_to_cart_item.dart';
import '../../../../domain/entities/item_modifier_group.dart';
import '../../../../utils/modifier_manager.dart';
import 'add_to_cart_button_view.dart';
import 'item_description_view.dart';
import 'level_one_select_multiple_view.dart';
import 'level_one_select_one_view.dart';
import 'modifier_group_info.dart';
import 'modifier_header_view.dart';

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
  late List<ItemModifierGroup> _groups;
  late MenuItems _item;
  late MenuBrand? _brand;
  late Prices _itemPrice;
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
    final totalPrice = (_modifierPrice + _itemPrice.price) * _quantity;
    if (_price.value != totalPrice) {
      _price.value = totalPrice;
    }
  }

  AddToCartItem _createCartItem() {
    return AddToCartItem(
      modifiers: _groups,
      item: _item,
      quantity: _quantity,
      itemInstruction: '',
      modifiersPrice: _modifierPrice,
      itemPrice: _itemPrice,
      brand: _brand!,
      discountType: DiscountType.flat,
      discountValue: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteSmoke,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ModifierHeaderView(
            onBack: () => widget.onClose(null),
            itemName: _item.title,
            onCartTap: widget.onCartTap,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ItemDescriptionView(item: _item),
                  Padding(
                    padding: EdgeInsets.only(
                      top: AppSize.s8.rh,
                      left: AppSize.s10.rw,
                      right: AppSize.s10.rw,
                    ),
                    child: OutlinedButton(
                      onPressed: widget.onAddAsNew,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.purpleBlue),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: AppColors.purpleBlue),
                          Text(
                            'Add as New',
                            style: getMediumTextStyle(
                              color: AppColors.purpleBlue,
                              fontSize: AppFontSize.s14.rSp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: _groups.map((group) {
                      return Container(
                        margin: EdgeInsets.only(
                          top: AppSize.s8.rh,
                          left: AppSize.s10.rw,
                          right: AppSize.s10.rw,
                        ),
                        child: Column(
                          children: [
                            ModifierGroupInfo(
                              title: group.title,
                              rule: group.rule,
                            ),
                            (group.rule.typeTitle == RuleType.exact &&
                                    group.rule.value == 1)
                                ? LevelOneSelectOneView(
                                    modifiers: group.modifiers,
                                    onChanged: _onChanged,
                                  )
                                : LevelOneSelectMultipleView(
                                    modifiers: group.modifiers,
                                    onChanged: _onChanged,
                                  ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  SpecialInstructionField(controller: _textEditingController),
                ],
              ),
            ),
          ),
          AddToCartButtonView(
            enabled: _enabled,
            price: _price,
            quantity: _quantity,
            currencySymbol: _itemPrice.symbol,
            onQuantityChanged: _onQuantityChanged,
            onAddToCart: () => widget.onClose(_createCartItem()),
          ),
        ],
      ),
    );
  }
}
