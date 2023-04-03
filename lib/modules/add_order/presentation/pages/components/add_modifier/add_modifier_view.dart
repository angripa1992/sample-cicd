import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/add_modifier/level_one_select_one_view.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/values.dart';
import '../../../../../menu/domain/entities/items.dart';
import '../../../../domain/entities/item_modifier_group.dart';
import '../../../../utils/modifier_manager.dart';
import '../../../../utils/order_price_provider.dart';
import 'add_to_cart_button_view.dart';
import 'item_description_view.dart';
import 'level_one_select_multiple_view.dart';
import 'modifier_group_info.dart';
import 'modifier_header_view.dart';

class AddModifierView extends StatefulWidget {
  final List<ItemModifierGroup> groups;
  final MenuItems item;
  final VoidCallback onClose;

  const AddModifierView(
      {Key? key,
      required this.groups,
      required this.item,
      required this.onClose})
      : super(key: key);

  @override
  State<AddModifierView> createState() => _AddModifierViewState();
}

class _AddModifierViewState extends State<AddModifierView> {
  final _enabled = ValueNotifier<bool>(false);
  final _price = ValueNotifier<num>(0);
  num _itemPrice = 0;

  @override
  void initState() {
    _itemPrice = OrderPriceProvider.klikitPrice(widget.item.prices);
    _price.value = _itemPrice;
    super.initState();
  }

  void _onChanged() async {
    final validated = await ModifierManager().verifyRules(widget.groups);
    final price = await ModifierManager().calculateModifiersPrice(widget.groups);
    if(_enabled.value != validated){
      _enabled.value = validated;
    }
    if(_price.value != price){
      _price.value = price + _itemPrice;
    }
    print(
        "check rule -> ${await ModifierManager().verifyRules(widget.groups)}");
    print(
        "modifier price -> ${await ModifierManager().calculateModifiersPrice(widget.groups)}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightGrey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ModifierHeaderView(
            onBack: widget.onClose,
            itemName: widget.item.title,
            onCartClick: () async {},
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
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
                  )
                ],
              ),
            ),
          ),
          AddToCartButtonView(
            enabled: _enabled,
            price: _price,
          ),
        ],
      ),
    );
  }
}
