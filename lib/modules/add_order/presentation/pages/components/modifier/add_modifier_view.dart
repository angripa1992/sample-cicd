import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
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
import '../../../../utils/order_price_provider.dart';
import 'add_to_cart_button_view.dart';
import 'item_description_view.dart';
import 'level_one_select_multiple_view.dart';
import 'level_one_select_one_view.dart';
import 'modifier_group_info.dart';
import 'modifier_header_view.dart';

class AddModifierView extends StatefulWidget {
  final List<ItemModifierGroup> groups;
  final MenuItems item;
  final MenuBrand brand;
  final Function(AddToCartItem?) onClose;
  final VoidCallback onCartTap;

  const AddModifierView({
    Key? key,
    required this.groups,
    required this.item,
    required this.onClose,
    required this.onCartTap,
    required this.brand,
  }) : super(key: key);

  @override
  State<AddModifierView> createState() => _AddModifierViewState();
}

class _AddModifierViewState extends State<AddModifierView> {
  final _enabled = ValueNotifier<bool>(false);
  final _price = ValueNotifier<num>(0);
  late Prices _itemPrice;
  num _modifierPrice = 0;
  int _quantity = 1;

  @override
  void initState() {
    _itemPrice = OrderPriceProvider.klikitPrice(widget.item.prices);
    _price.value = _itemPrice.price;
    super.initState();
  }

  void _onChanged() async {
    final validated = await ModifierManager().verifyRules(widget.groups);
    _modifierPrice =
        await ModifierManager().calculateModifiersPrice(widget.groups);
    if (_enabled.value != validated) {
      _enabled.value = validated;
    }
    _changePrice();
  }

  void _onQuantityChanged(int quantity) {
    _quantity = quantity;
    _changePrice();
  }


  void _changePrice(){
    final totalPrice = (_modifierPrice + _itemPrice.price) * _quantity;
    if (_price.value != totalPrice) {
      _price.value = totalPrice;
    }
  }

  AddToCartItem _createCartItem() {
    return AddToCartItem(
      modifiers: widget.groups,
      item: widget.item,
      quantity: _quantity,
      itemInstruction: '',
      modifiersPrice: _modifierPrice,
      itemPrice: _itemPrice,
      brand: widget.brand,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightGrey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ModifierHeaderView(
            onBack: () => widget.onClose(null),
            itemName: widget.item.title,
            onCartTap: widget.onCartTap,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ItemDescriptionView(item: widget.item),
                  Column(
                    children: widget.groups.map((group) {
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
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Add Instruction',
                      hintStyle: getRegularTextStyle(
                        color: AppColors.black,
                        fontSize: AppFontSize.s16.rSp,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: AppColors.blueViolet),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: AppColors.blueViolet),
                      ),
                      border: UnderlineInputBorder(
                        borderSide:
                        BorderSide(color:  AppColors.blueViolet),
                      ),
                    ),
                  ),
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
