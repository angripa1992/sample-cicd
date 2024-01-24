import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_item.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';

class MenuItemAddCounterButton extends StatelessWidget {
  final MenuCategoryItem menuItem;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const MenuItemAddCounterButton({
    super.key,
    required this.menuItem,
    required this.onAdd,
    required this.onRemove,
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
          ),
          child: numberOfAddedItem > 0
              ? Row(
                  children: [
                    IconButton(
                      onPressed: onRemove,
                      padding: EdgeInsets.symmetric(horizontal: 8.rw),
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.remove,
                        color: AppColors.neutralB600,
                      ),
                    ),
                    Text(
                      '$numberOfAddedItem',
                      style: semiBoldTextStyle(
                        color: AppColors.neutralB500,
                        fontSize: 14.rSp,
                      ),
                    ),
                    IconButton(
                      onPressed: onAdd,
                      padding: EdgeInsets.symmetric(horizontal: 8.rw),
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.add,
                        color: AppColors.neutralB600,
                      ),
                    ),
                  ],
                )
              : IconButton(
                  onPressed: onAdd,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.add,
                    color: AppColors.neutralB600,
                  ),
                ),
        );
      },
    );
  }
}
