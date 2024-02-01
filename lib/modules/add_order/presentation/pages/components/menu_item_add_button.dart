import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_item.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';

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
            borderRadius: BorderRadius.circular(16.rSp),
            color: AppColors.white,
            border: Border.all(
              color: (numberOfAddedItem > 0 && !menuItem.haveModifier) ? AppColors.primary : AppColors.white,
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
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: Icon(Icons.add, color: AppColors.primary),
      );

  Widget _modifierItemButton(int count) => InkWell(
        onTap: onAddModifierItem,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.rSp, vertical: 4.rSp),
          child: Text(
            '$count',
            style: mediumTextStyle(
              color: AppColors.neutralB600,
              fontSize: 14.rSp,
            ),
          ),
        ),
      );

  Widget _nonModifierItemAddButton(int count) => Row(
        children: [
          IconButton(
            onPressed: onRemoveNonModifierItem,
            padding: EdgeInsets.symmetric(horizontal: 8.rw),
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.remove,
              color: AppColors.neutralB600,
            ),
          ),
          Text(
            '$count',
            style: semiBoldTextStyle(
              color: AppColors.neutralB500,
              fontSize: 14.rSp,
            ),
          ),
          IconButton(
            onPressed: onAddNonModifierItem,
            padding: EdgeInsets.symmetric(horizontal: 8.rw),
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.add,
              color: AppColors.neutralB600,
            ),
          ),
        ],
      );
}
