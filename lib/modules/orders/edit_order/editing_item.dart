import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../resources/colors.dart';
import '../../../resources/fonts.dart';
import '../../../resources/styles.dart';
import '../../../resources/values.dart';
import '../../widgets/menu_item_image_view.dart';
import '../domain/entities/cart.dart';
import 'editing_manager.dart';
import 'grab_quantity_selecter.dart';

class EditingItemVIew extends StatelessWidget {
  final Function(String, String, int) onQuantityChange;
  final Function(String, String) onDeleteItem;
  final CartV2 item;
  final String currencySymbol;

  const EditingItemVIew({
    Key? key,
    required this.item,
    required this.onQuantityChange,
    required this.currencySymbol,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            MenuItemImageView(url: item.image),
            SizedBox(width: AppSize.s16.rw),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: getMediumTextStyle(
                            color: AppColors.purpleBlue,
                            fontSize: AppFontSize.s14.rSp,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.s8.rw,
                          vertical: AppSize.s4.rh,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSize.s4.rSp),
                          color: AppColors.seaShell,
                        ),
                        child: Text(
                          '$currencySymbol ${item.unitPriceDisplay}',
                          style: TextStyle(
                            color: AppColors.balticSea,
                            fontSize: AppFontSize.s13.rSp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.s8.rh),
                  Text(
                    EditingManager().allCsvModifiersName(item.modifierGroups),
                    style: getRegularTextStyle(
                      color: AppColors.smokeyGrey,
                      fontSize: AppFontSize.s13.rSp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                onDeleteItem(item.id, item.externalId);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outlined,
                    color: AppColors.red,
                    size: AppSize.s20.rSp,
                  ),
                  SizedBox(width: AppSize.s4.rw),
                  Text(
                    'Delete Item',
                    style: getMediumTextStyle(color: AppColors.red),
                  ),
                ],
              ),
            ),
            GrabQuantitySelector(
              quantity: item.quantity,
              onQuantityChanged: (quantity) {
                onQuantityChange(item.id, item.externalId, quantity);
              },
            ),
          ],
        ),
      ],
    );
  }
}
