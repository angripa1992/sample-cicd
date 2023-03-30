import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/add_modifier/level_one_select_one_view.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/values.dart';
import '../../../../../menu/domain/entities/items.dart';
import '../../../../domain/entities/item_modifier_group.dart';
import 'item_description_view.dart';
import 'level_one_select_multiple_view.dart';
import 'modifier_group_info.dart';
import 'modifier_header_view.dart';

class AddModifierView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightGrey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ModifierHeaderView(
            onBack: onClose,
            itemName: item.title,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ItemDescriptionView(item: item),
                  Column(
                    children: groups.map((e) {
                      return Container(
                        margin: EdgeInsets.only(
                          top: AppSize.s8.rh,
                          left: AppSize.s10.rw,
                          right: AppSize.s10.rw,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                          color: AppColors.white,
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                          child: Column(
                            children: [
                              ModifierGroupInfo(title: e.title, rule: e.rule),
                              e.rule.value == 1
                                  ? LevelOneSelectOneView(
                                      modifiers: e.modifiers)
                                  : LevelOneSelectMultipleView(
                                      modifiers: e.modifiers,
                                    ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
