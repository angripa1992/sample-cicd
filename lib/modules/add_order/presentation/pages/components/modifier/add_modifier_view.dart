import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/modifier/add_to_cart_button_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/modifier/item_description_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/modifier/level_one_select_multiple_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/modifier/level_one_select_one_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/modifier/modifier_group_info.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/modifier/speacial_instruction.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';
import 'package:klikit/modules/base/common_dashboard_app_bar.dart';
import 'package:klikit/modules/menu/domain/entities/item_price.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../common/entities/brand.dart';
import '../../../../../menu/domain/entities/menu/menu_item.dart';
import '../../../../domain/entities/add_to_cart_item.dart';
import '../../../../domain/entities/modifier/item_modifier_group.dart';
import '../../../../utils/modifier_manager.dart';

class AddModifierView extends StatefulWidget {
  final List<MenuItemModifierGroup> groups;
  final MenuCategoryItem item;
  final Brand brand;
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
  final _textController = TextEditingController();
  final _enabledNotifier = ValueNotifier<bool>(false);
  final _priceNotifier = ValueNotifier<num>(0);
  late ItemPrice _itemPrice;
  num _modifierPrice = 0;
  int _quantity = 1;

  @override
  void initState() {
    _itemPrice = widget.item.klikitPrice();
    _priceNotifier.value = _itemPrice.advancePrice(CartManager().orderType);
    ModifierManager().verifyRules(widget.groups).then((value) => _enabledNotifier.value = value);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _enabledNotifier.dispose();
    _priceNotifier.dispose();
    super.dispose();
  }

  void _onChanged() async {
    final validated = await ModifierManager().verifyRules(widget.groups);
    _modifierPrice = await ModifierManager().calculateModifiersPrice(widget.groups);
    if (_enabledNotifier.value != validated) {
      _enabledNotifier.value = validated;
    }
    _changePrice();
  }

  void _onQuantityChanged(int quantity) {
    _quantity = quantity;
    _changePrice();
  }

  void _changePrice() {
    final totalPrice = (_modifierPrice + _itemPrice.advancePrice(CartManager().orderType)) * _quantity;
    if (_priceNotifier.value != totalPrice) {
      _priceNotifier.value = totalPrice;
    }
  }

  AddToCartItem _createCartItem() {
    return AddToCartItem(
      modifiers: widget.groups,
      item: widget.item,
      quantity: _quantity,
      itemInstruction: _textController.text,
      modifiersPrice: _modifierPrice,
      itemPrice: _itemPrice,
      brand: widget.brand,
      discountType: DiscountType.flat,
      discountValue: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            CommonDashboardAppBar(
              title: AppStrings.item_details.tr(),
              onNavBack: () {
                Navigator.pop(context);
                widget.onClose(null);
              },
              onCartTap: () {
                Navigator.pop(context);
                widget.onCartTap();
              },
            ),
            Divider(color: AppColors.greyLight, thickness: 1, height: 1),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ItemDescriptionView(item: widget.item),
                    Divider(thickness: 8.rh, color: AppColors.grey),
                    Column(
                      children: widget.groups.map((group) {
                        return Column(
                          children: [
                            ModifierGroupInfo(title: group.title, rule: group.rule),
                            ((group.rule.min == group.rule.max) && group.rule.max == 1)
                                ? LevelOneSelectOneView(modifiers: group.modifiers, onChanged: _onChanged)
                                : LevelOneSelectMultipleView(modifiers: group.modifiers, onChanged: _onChanged),
                          ],
                        );
                      }).toList(),
                    ),
                    if (widget.groups.isNotEmpty) Divider(thickness: 8.rh, color: AppColors.grey),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.rw, vertical: 8.rh),
                      child: SpecialInstructionField(controller: _textController),
                    ),
                    Divider(thickness: 8.rh, color: AppColors.grey),
                  ],
                ),
              ),
            ),
            AddToCartButtonView(
              enabled: _enabledNotifier,
              price: _priceNotifier,
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
