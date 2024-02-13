import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_chip.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_item.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class MenuItemAddCounterButton extends StatelessWidget {
  final MenuCategoryItem menuItem;
  final VoidCallback onAddNonModifierItem;
  final VoidCallback onAddModifierItem;
  final VoidCallback onRemoveNonModifierItem;

  const MenuItemAddCounterButton({
    super.key,
    required this.menuItem,
    required this.onAddModifierItem,
    required this.onAddNonModifierItem,
    required this.onRemoveNonModifierItem,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CartManager().cartItemCountNotifier,
      builder: (_, value, __) {
        final numberOfAddedItem = CartManager().numberOfAddedItem(menuItem.id);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(200.rSp),
            color: AppColors.white,
            border: Border.all(
              color: (numberOfAddedItem > 0 && !menuItem.haveModifier) ? AppColors.primaryP300 : AppColors.white,
            ),
          ),
          child: _getButtons(numberOfAddedItem),
        );
      },
    );
  }

  Widget _getButtons(int count) {
    if (count > 0 && menuItem.haveModifier) {
      return _modifierItemButton(count);
    } else if (count > 0 && !menuItem.haveModifier) {
      return _nonModifierItemAddButton(count);
    } else {
      return _addButton();
    }
  }

  Widget _addButton() => IconButton(
    onPressed: () {
          if (menuItem.haveModifier) {
            onAddModifierItem();
          } else {
            onAddNonModifierItem();
          }
        },
        // padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: Icon(Icons.add, color: AppColors.primaryP300, size: 20.rSp),
      );

  Widget _modifierItemButton(int count) => InkWell(
    onTap: onAddModifierItem,
        child: KTChip(
          text: '$count',
          strokeColor: AppColors.white,
          backgroundColor: AppColors.white,
          textStyle: semiBoldTextStyle(fontSize: 12.rSp, color: AppColors.neutralB600),
          borderRadius: 200.rSp,
          padding: EdgeInsets.fromLTRB(
            count < 10 ? AppSize.s16.rw : AppSize.s12.rw,
            AppSize.s10.rh,
            count < 10 ? AppSize.s16.rw : AppSize.s12.rw,
            AppSize.s10.rh,
          ),
        ),
      );

  Widget _nonModifierItemAddButton(int count) => Row(
        children: [
          IconButton(
            onPressed: onRemoveNonModifierItem,
            constraints: const BoxConstraints(),
            // padding: EdgeInsets.zero,
            icon: Icon(
              Icons.remove,
              color: AppColors.neutralB600,
              size: 20.rSp,
            ),
          ),
          Text(
            '$count',
            style: semiBoldTextStyle(
              color: AppColors.neutralB500,
              fontSize: 12.rSp,
            ),
          ),
          IconButton(
            onPressed: onAddNonModifierItem,
            constraints: const BoxConstraints(),
            // padding: EdgeInsets.zero,
            icon: Icon(
              Icons.add,
              color: AppColors.neutralB600,
              size: 20.rSp,
            ),
          ),
        ],
      );
}
